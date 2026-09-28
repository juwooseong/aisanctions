#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Generate domain-grouped ERD markdown from sql/01_ddl.sql and DOMAIN_ZONE_CONFIG."""
from __future__ import annotations

import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
DDL = ROOT / "sql" / "01_ddl.sql"
OUT = ROOT / "docs" / "erd-domain.md"

# mirror scripts/ddl_to_erd.py DOMAIN_ZONE_CONFIG (+ descriptions)
DOMAINS = [
    {
        "name": "심사 처리",
        "anchor": "1-심사-처리",
        "desc": "심사건 마스터와 문서·추출·항목심사·결재·첨부·SafeWatch·의견 이력",
        "tables": [
            "CSPD001TM", "CSPD004TF", "CSPD005TH", "CSPD008TH",
            "CSPD900TI", "CSPD002TG", "CSPD003TF", "CSPD006TL", "CSPD007TL",
        ],
    },
    {
        "name": "기준정보",
        "anchor": "2-기준정보",
        "desc": "사용자·목록·공통코드·국가·항구 등 마스터 기준데이터",
        "tables": [
            "CSPD101TI", "CSPD106TI", "CSPD103TI", "CSPD107TI", "CSPD104TI",
            "CSPD112TI", "CSPD102TI", "CSPD105TI", "CSPD115TI", "CSPD111TI",
            "CSPD117TI", "CSPD118TI", "CSPD118TM", "CSPD116TI", "CSPD113TI",
        ],
    },
    {
        "name": "메뉴·권한",
        "anchor": "3-메뉴권한",
        "desc": "화면 메뉴 트리와 권한별 메뉴 매핑",
        "tables": ["CSPD108TI", "CSPD109TI", "CSPD110TI"],
    },
    {
        "name": "업무일지·통계",
        "anchor": "4-업무일지통계",
        "desc": "업무일지·통계 집계 및 미생성·추출 처리 로그",
        "tables": ["CSPD009TA", "CSPD010TA", "CSPD011TL"],
    },
    {
        "name": "외환 원장",
        "anchor": "5-외환-원장",
        "desc": "수출 커버링·수입 서류접수 원장 (JOIN용)",
        "tables": ["CSPD201TM", "CSPD202TM"],
    },
    {
        "name": "로그",
        "anchor": "6-로그",
        "desc": "로그인·프로그램 사용 이력",
        "tables": ["CSPD810TH", "CSPD811TH"],
    },
]

# Logical FK (parent, parent_cols, child, child_cols) — same as ddl_to_erd.py
LOGICAL_RELATIONSHIPS = [
    ("CSPD001TM", ["INPT_MST_SRNO"], "CSPD002TG", ["INPT_MST_SRNO"]),
    ("CSPD001TM", ["INPT_MST_SRNO"], "CSPD003TF", ["INPT_MST_SRNO"]),
    ("CSPD001TM", ["INPT_MST_SRNO"], "CSPD004TF", ["INPT_MST_SRNO"]),
    ("CSPD001TM", ["INPT_MST_SRNO"], "CSPD005TH", ["INPT_MST_SRNO"]),
    ("CSPD001TM", ["INPT_MST_SRNO"], "CSPD006TL", ["INPT_MST_SRNO"]),
    ("CSPD001TM", ["INPT_MST_SRNO"], "CSPD007TL", ["INPT_MST_SRNO"]),
    ("CSPD001TM", ["INPT_MST_SRNO"], "CSPD008TH", ["INPT_MST_SRNO"]),
    ("CSPD001TM", ["INPT_MST_SRNO"], "CSPD900TI", ["INPT_MST_SRNO"]),
    ("CSPD108TI", ["AI_INPT_MENU_ID"], "CSPD109TI", ["AI_INPT_MENU_ID"]),
    ("CSPD111TI", ["AI_INPT_GRP_CD"], "CSPD112TI", ["AI_INPT_GRP_CD"]),
    ("CSPD103TI", ["AI_INPT_LIST_ID"], "CSPD107TI", ["AI_INPT_LIST_ID"]),
    ("CSPD101TI", ["AI_INPT_USER_ID"], "CSPD810TH", ["AI_INPT_USER_ID"]),
    ("CSPD101TI", ["AI_INPT_USER_ID"], "CSPD811TH", ["AI_INPT_USER_ID"]),
]

REL_LABEL = {
    ("CSPD001TM", "CSPD002TG"): "has_docs",
    ("CSPD001TM", "CSPD003TF"): "has_totaltext",
    ("CSPD001TM", "CSPD004TF"): "has_items",
    ("CSPD001TM", "CSPD005TH"): "has_approval",
    ("CSPD001TM", "CSPD006TL"): "has_files",
    ("CSPD001TM", "CSPD007TL"): "has_safewatch",
    ("CSPD001TM", "CSPD008TH"): "has_opinions",
    ("CSPD001TM", "CSPD900TI"): "has_detail",
    ("CSPD108TI", "CSPD109TI"): "has_auth",
    ("CSPD111TI", "CSPD112TI"): "has_codes",
    ("CSPD103TI", "CSPD107TI"): "has_list_items",
    ("CSPD101TI", "CSPD810TH"): "login_log",
    ("CSPD101TI", "CSPD811TH"): "usage_log",
}


def parse_ddl(text: str) -> tuple[dict[str, list[dict]], dict[str, str], dict[str, dict[str, str]]]:
    tables: dict[str, list[dict]] = {}
    for m in re.finditer(r"CREATE TABLE (\w+) \((.*?)\)\s*;", text, re.DOTALL):
        tname = m.group(1)
        body = m.group(2)
        cols: list[dict] = []
        pk_cols: set[str] = set()
        for pk_m in re.finditer(r"PRIMARY KEY\s*\(([^)]+)\)", body, re.I):
            pk_cols.update(c.strip() for c in pk_m.group(1).split(","))
        for line in body.splitlines():
            raw = line.strip().rstrip(",")
            if not raw or raw.upper().startswith("CONSTRAINT"):
                continue
            parts = raw.split()
            if len(parts) < 2:
                continue
            cname, ctype = parts[0], parts[1]
            if not re.match(r"^[A-Z][A-Z0-9_]*$", cname):
                continue
            cols.append({"name": cname, "type": ctype, "pk": cname in pk_cols})
        tables[tname] = cols

    table_comments = dict(re.findall(r"COMMENT ON TABLE (\w+) IS '([^']*)'", text))
    col_comments: dict[str, dict[str, str]] = {}
    for m in re.finditer(r"COMMENT ON COLUMN (\w+)\.(\w+) IS '([^']*)'", text):
        col_comments.setdefault(m.group(1), {})[m.group(2)] = m.group(3)
    return tables, table_comments, col_comments


def mermaid_type(dtype: str) -> str:
    """속성 name 슬롯에 넣을 타입 라벨 — number/varchar 등 예약어 금지."""
    d = dtype.upper().replace(" ", "")
    d = re.sub(r"[()]", "", d)
    if d.startswith("NUMBER"):
        return d if d != "NUMBER" else "NUMBER_VAL"
    if d.startswith("VARCHAR2"):
        return d if len(d) > 8 else "VARCHAR2_VAL"
    if d.startswith("VARCHAR"):
        return d if len(d) > 7 else "VARCHAR_VAL"
    if d.startswith("CHAR"):
        return d if len(d) > 4 else "CHAR_VAL"
    if d.startswith("DATE") or "TIMESTAMP" in d:
        return "DATE_VAL"
    return "STRING_VAL"


def esc_comment(s: str) -> str:
    return s.replace('"', "'").replace("\n", " ").replace("\\", "/")


def rel_lines(table_set: set[str]) -> list[str]:
    out = []
    for parent, _pc, child, _cc in LOGICAL_RELATIONSHIPS:
        if parent in table_set and child in table_set:
            label = REL_LABEL.get((parent, child), "rel")
            out.append(f"    {parent} ||--o{{ {child} : {label}")
    return out


def entity_block(
    tname: str,
    cols: list[dict],
    col_comments: dict[str, str],
    table_comment: str = "",
    *,
    pk_only: bool = False,
) -> str:
    """
    Cursor Markdown 미리보기 호환 ER 엔티티.
    - 엔티티 ID: ASCII 테이블명만 (한글명은 위 표에 표시)
    - 속성: Mermaid 문법(type name PK)이지만
      type 슬롯=컬럼명, name 슬롯=타입 → 화면상 '컬럼명 타입 PK'
    """
    _ = (col_comments, table_comment)
    lines = [f"    {tname} {{"]
    use_cols = [c for c in cols if c["pk"]] if pk_only else cols
    if pk_only and not use_cols:
        use_cols = cols[:3]
    for c in use_cols:
        pk = " PK" if c["pk"] else ""
        col_id = c["name"]
        type_id = mermaid_type(c["type"])
        lines.append(f"        {col_id} {type_id}{pk}")
    lines.append("    }")
    return "\n".join(lines)


def column_md_table(tname: str, cols: list[dict], col_comments: dict[str, str]) -> list[str]:
    out = [
        f"#### `{tname}`",
        "",
        "| 컬럼 | 타입 | PK | 설명 |",
        "|------|------|----|------|",
    ]
    for c in cols:
        pk = "Y" if c["pk"] else ""
        out.append(
            f"| `{c['name']}` | `{c['type']}` | {pk} | {col_comments.get(c['name'], '')} |"
        )
    out.append("")
    return out


def build_markdown(
    tables: dict[str, list[dict]],
    table_comments: dict[str, str],
    col_comments: dict[str, dict[str, str]],
) -> str:
    all_domain_tables = [t for d in DOMAINS for t in d["tables"]]
    missing = sorted(set(tables) - set(all_domain_tables))
    orphan = sorted(set(all_domain_tables) - set(tables))

    lines: list[str] = []
    lines.append("# 도메인별 ERD")
    lines.append("")
    lines.append("> **출처:** `sql/01_ddl.sql`, `scripts/ddl_to_erd.py` DOMAIN_ZONE_CONFIG  ")
    lines.append("> **ERD 파일:** `sql/sanction_domain.erd` (도메인 배치) · `sql/sanction.erd` (기본 배치)  ")
    lines.append("> **작성일:** 2026-07-14  ")
    lines.append("> **관계:** DDL에 FK 미정의 — MyBatis 조인 기준 논리 관계만 표시")
    lines.append("")
    lines.append("---")
    lines.append("")
    lines.append("## 도메인 개요")
    lines.append("")
    lines.append("| # | 도메인 | 테이블 수 | 설명 |")
    lines.append("|---|--------|----------|------|")
    for i, d in enumerate(DOMAINS, 1):
        lines.append(f"| {i} | [{d['name']}](#{d['anchor']}) | {len(d['tables'])} | {d['desc']} |")
    lines.append("")
    lines.append(f"- **전체 테이블:** {len(tables)}개")
    lines.append(f"- **도메인 매핑:** {len(all_domain_tables)}개")
    if missing:
        lines.append(f"- **도메인 미배정:** {', '.join(missing)}")
    if orphan:
        lines.append(f"- **DDL 없음(설정만 존재):** {', '.join(orphan)}")
    lines.append("")
    lines.append("### 전체 도메인 맵")
    lines.append("")
    lines.append("```mermaid")
    lines.append("flowchart TB")
    lines.append("  subgraph core [Core]")
    lines.append("    D1[Review]")
    lines.append("  end")
    lines.append("  subgraph master [Master]")
    lines.append("    D2[Reference]")
    lines.append("    D3[MenuAuth]")
    lines.append("  end")
    lines.append("  subgraph support [Support]")
    lines.append("    D4[StatLog]")
    lines.append("    D5[FXLedger]")
    lines.append("    D6[AuditLog]")
    lines.append("  end")
    lines.append("  D1 -->|join| D5")
    lines.append("  D1 -->|codes| D2")
    lines.append("  D2 --> D3")
    lines.append("  D1 --> D4")
    lines.append("  D2 --> D6")
    lines.append("```")
    lines.append("")
    lines.append("- D1 심사 처리 · D2 기준정보 · D3 메뉴-권한 · D4 업무일지-통계 · D5 외환 원장 · D6 로그")
    lines.append("")
    lines.append("---")
    lines.append("")

    for i, d in enumerate(DOMAINS, 1):
        lines.append(f"## {i}. {d['name']}")
        lines.append("")
        lines.append(d["desc"])
        lines.append("")
        lines.append("### 테이블 목록")
        lines.append("")
        lines.append("| 테이블 | 한글명 | 컬럼 수 |")
        lines.append("|--------|--------|--------|")
        for t in d["tables"]:
            if t not in tables:
                lines.append(f"| `{t}` | _(DDL 없음)_ | - |")
                continue
            cmt = table_comments.get(t, "")
            lines.append(f"| `{t}` | {cmt} | {len(tables[t])} |")
        lines.append("")

        present = [t for t in d["tables"] if t in tables]
        table_set = set(present)

        # Compact ERD: PK-focused for readability
        lines.append("### ER Diagram (PK + 논리 관계)")
        lines.append("")
        lines.append("```mermaid")
        lines.append("erDiagram")
        for t in present:
            lines.append(
                entity_block(
                    t,
                    tables[t],
                    col_comments.get(t, {}),
                    table_comments.get(t, ""),
                    pk_only=True,
                )
            )
        for rel in rel_lines(table_set):
            lines.append(rel)
        lines.append("```")
        lines.append("")
        lines.append(
            "- ER 박스 ID는 영문 테이블명(한글명은 위 표 참고). "
            "속성 표시 순서: `컬럼명 타입 PK`"
        )
        lines.append("")

        lines.append("### 컬럼 상세")
        lines.append("")
        for t in present:
            lines.extend(column_md_table(t, tables[t], col_comments.get(t, {})))

        lines.append("---")
        lines.append("")

    lines.append("## 도메인 간 논리 관계")
    lines.append("")
    lines.append("부모 → 자식 방향. 동일 도메인 관계는 각 도메인 ER Diagram에 포함.")
    lines.append("")
    lines.append("| 부모 | 자식 | 조인 키 | 부모 도메인 | 자식 도메인 |")
    lines.append("|------|------|---------|-------------|-------------|")
    t2d = {t: d["name"] for d in DOMAINS for t in d["tables"]}
    for parent, pcols, child, _ccols in LOGICAL_RELATIONSHIPS:
        key = ",".join(pcols)
        lines.append(
            f"| `{parent}` | `{child}` | `{key}` | {t2d.get(parent, '-')} | {t2d.get(child, '-')} |"
        )
    lines.append("")
    lines.append("### 참고: 매퍼 조인 (원장·코드)")
    lines.append("")
    lines.append("| 설명 | 조인 |")
    lines.append("|------|------|")
    lines.append(
        "| 마스터 ↔ 수출 원장 | `CSPD001TM.ACTL_FX_REFNO` ≈ `CSPD201TM.FX_ACNO`, "
        "`FX_REFNO_SRNO` ≈ `XPO_CVRG_MK_SQ` |"
    )
    lines.append(
        "| 마스터 ↔ 수입 원장 | `CSPD001TM.ACTL_FX_REFNO` ≈ `CSPD202TM.FX_ACNO`, "
        "`FX_REFNO_SRNO` ≈ `TDOC_RCP_SRNO` |"
    )
    lines.append(
        "| 문서분류 코드 | `CSPD002TG.IMEX_HIS_CD` = `CSPD112TI.AI_INPT_CMN_CD` (grp `100`) |"
    )
    lines.append(
        "| 항목심사 코드 | `CSPD004TF.INPT_SANCTION_NO` = `CSPD112TI.AI_INPT_CMN_CD` "
        "(grp `230` / `240`) |"
    )
    lines.append("")
    lines.append("---")
    lines.append("")
    lines.append("## 재생성")
    lines.append("")
    lines.append("```bash")
    lines.append("# ERD Editor JSON")
    lines.append("python scripts/ddl_to_erd.py -o sql/sanction_domain.erd --layout domain")
    lines.append("# 본 마크다운")
    lines.append("python scripts/generate_erd_domain_md.py")
    lines.append("```")
    lines.append("")
    return "\n".join(lines)


def main() -> None:
    text = DDL.read_text(encoding="utf-8")
    tables, table_comments, col_comments = parse_ddl(text)
    md = build_markdown(tables, table_comments, col_comments)
    OUT.write_text(md, encoding="utf-8")
    print(f"Wrote {OUT} ({len(tables)} tables, {sum(len(d['tables']) for d in DOMAINS)} domain slots)")


if __name__ == "__main__":
    main()
