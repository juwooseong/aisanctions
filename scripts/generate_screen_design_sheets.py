# -*- coding: utf-8 -*-
"""화면설계서 — 개발자용 Markdown 시트 생성."""
from __future__ import annotations

import re
from pathlib import Path
from typing import Any

from generate_screen_design_excel import DETAIL, PATTERN_DESC, SCREENS
from screen_design_dev_data import BACKEND_MAP, PATTERN_IMPL
from screen_design_enrich import EVENTS_SPEC_NOTE

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / "docs" / "screen-design" / "sheets"
INDEX = ROOT / "docs" / "screen-design" / "목차.md"
DEV_GUIDE = ROOT / "docs" / "screen-design" / "00_개발자_가이드.md"


def md_table(headers: list[str], rows: list[tuple]) -> str:
    if not rows:
        return "_해당 없음_"
    lines = [
        "| " + " | ".join(headers) + " |",
        "|" + "|".join(["---"] * len(headers)) + "|",
    ]
    for row in rows:
        lines.append("| " + " | ".join(str(c) for c in row) + " |")
    return "\n".join(lines)


def safe_filename(screen_id: str) -> str:
    return screen_id.replace("/", "-")


def infer_backend(url: str, jsp: str) -> dict[str, str]:
    if url in ("—", "", "모달", "팝업") or url.startswith("POST"):
        base = Path(jsp).stem if jsp and jsp != "—" else "Screen"
        cap = base[0].upper() + base[1:] if base else "Screen"
        return {
            "controller": f"*{cap}Controller (확인 필요)",
            "api": f"*{cap}ApiController (확인 필요)",
            "service": f"*{cap}Service",
            "mapper": f"*{cap}Mapper",
            "sql": f"*{cap}_SQL.xml",
            "vo": "SearchVO 등",
        }
    path = url.split()[-1] if " " in url else url
    parts = [p for p in path.strip("/").split("/") if p]
    if not parts:
        return {}
    if parts[0] == "admin":
        prefix = "Admin"
        resource = parts[1] if len(parts) > 1 else parts[0]
    elif parts[0] in ("revert", "app", "qa", "stat", "task", "common"):
        prefix = parts[0].capitalize()
        if parts[0] == "revert" and len(parts) > 1:
            prefix = "Revert"
        elif parts[0] == "app":
            prefix = "App"
        elif parts[0] == "qa":
            prefix = "Qa"
        resource = parts[-1]
    else:
        prefix = parts[0].capitalize()
        resource = parts[-1] if len(parts) > 1 else parts[0]

    def camel(s: str) -> str:
        if not s:
            return ""
        return s[0].upper() + re.sub(r"[-_]([a-z])", lambda m: m.group(1).upper(), s[1:])

    name = prefix + camel(resource)
    return {
        "controller": f"{name}Controller",
        "api": f"{name}ApiController",
        "service": f"{name}Service / {name}ServiceImpl",
        "mapper": f"{name}Mapper",
        "sql": f"egovframework/sqlmap/ui/mappers/{name}_SQL.xml",
        "vo": "SearchVO, *VO",
    }


def parse_api_list(api: str) -> list[tuple[str, str, str]]:
    rows = []
    for part in api.split(";"):
        part = part.strip()
        if not part or part == "—":
            continue
        if part.startswith(("GET", "POST", "PUT", "DELETE")):
            method, _, path = part.partition(" ")
            rows.append((path.strip() or part, method, ""))
        else:
            rows.append((part, "—", ""))
    return rows


def status_badge(status: str) -> str:
    if status == "신규":
        return "**신규 구현** — AS-IS 코드 없음. 본 시트·프로세스 정의서 기준 신규 개발."
    if status in ("변경", "v2"):
        return f"**{status}** — 기존 JSP/API 확장. `tobe_changes` 섹션 참조."
    return "AS-IS 유지 + TO-BE 권한/알림 연동 확인."


def section_backend(sec: int, sid: str, url: str, jsp: str, d: dict) -> list[str]:
    be = d.get("backend") or BACKEND_MAP.get(sid) or infer_backend(url, jsp)
    if isinstance(be, dict) and "controller" in be and len(be) <= 3:
        pass
    rows = []
    mapping = [
        ("View Controller", be.get("controller", "—")),
        ("API Controller", be.get("api", be.get("api_controller", "—"))),
        ("Service", be.get("service", "—")),
        ("Mapper", be.get("mapper", "—")),
        ("SQL XML", be.get("sql", "—")),
        ("VO/DTO", be.get("vo", "—")),
    ]
    for label, val in mapping:
        if val and val != "—":
            path_hint = ""
            if "Controller" in label and not val.startswith("*") and "(신규)" not in val:
                pkg = "controller" if "View" in label else "api"
                path_hint = f"`src/main/java/com/woori/ajs/{pkg}/`"
            rows.append((label, val, path_hint))
    lines = ["---", "", f"## {sec}. 백엔드 구현", "", md_table(["구분", "클래스/파일", "경로"], rows), ""]
    if d.get("flow"):
        lines += [f"### {sec}.1 처리 흐름", ""]
        for i, step in enumerate(d["flow"], 1):
            text = step.lstrip("0123456789. ")
            lines.append(f"{i}. {text}")
        lines.append("")
    return lines


def section_frontend(sec: int, sid: str, jsp: str, pattern: str, wireframe: str, d: dict) -> list[str]:
    fe = d.get("frontend") or {}
    impl = PATTERN_IMPL.get(pattern, {})
    rows = []

    if isinstance(fe, dict):
        jsp_path = fe.get("jsp", f"`WEB-INF/jsp/{jsp}`")
        rows.append(("JSP", jsp_path, fe.get("view", "blank/ 뷰")))
        if fe.get("js"):
            rows.append(("JavaScript", fe["js"], "이벤트·DataTables·API"))
        if fe.get("css"):
            rows.append(("CSS", fe["css"], "화면 스타일"))
        if fe.get("includes"):
            rows.append(("Include", fe["includes"], ""))
        if fe.get("forms"):
            rows.append(("Form", fe["forms"], "팝업 POST"))
    else:
        rows.append(("JSP", f"`WEB-INF/jsp/{jsp}`", ""))

    for item in impl.get("frontend", []):
        if len(item) == 3 and not any(item[0] in r[0] for r in rows):
            rows.append(item)

    lines = [f"## {sec}. 프론트엔드 구현", "", md_table(["구분", "파일/함수", "설명"], rows), "", "---", ""]
    return lines


def section_tables(sec: int, d: dict) -> list[str]:
    tables = d.get("tables") or []
    lines = ["---", "", f"## {sec}. 관련 테이블", ""]
    if tables:
        lines.append(md_table(["논리명", "물리명", "용도"], tables))
    else:
        lines.append("_관련 테이블 미정의 — Mapper SQL 확인_")
    lines.append("")
    return lines


def section_api_specs(sec: int, d: dict, api: str) -> list[str]:
    specs = d.get("api_specs") or []
    lines = [f"## {sec}. API 명세", ""]
    if specs:
        rows = [(s[0], s[1], s[2], s[3], s[4] if len(s) > 4 else "") for s in specs]
        lines.append(md_table(["경로", "Method", "Request", "Response", "비고"], rows))
    else:
        rows = parse_api_list(api)
        if rows:
            lines.append(md_table(["경로", "Method", "설명"], [(r[0], r[1], r[2]) for r in rows]))
        else:
            lines.append("_API 미정의 — 프로세스 문서 참조_")
    lines.append("")
    lines += [
        f"### {sec}.1 공통 응답",
        "",
        "- 성공: `HttpUtil.HttpType.T200` + `resultList` / 도메인 payload",
        "- 페이징: `paginationInfo` (pageIndex, recordCountPerPage, totalRecordCount)",
        "- 오류: `CommonExceptionHandler` → JSON 메시지 코드",
        "",
    ]
    return lines


def section_checklist(sec: int, sid: str, pattern: str, status: str, d: dict) -> list[str]:
    items = list(d.get("checklist") or [])
    items.extend(PATTERN_IMPL.get(pattern, {}).get("checklist") or [])
    if status == "신규":
        items.insert(0, "Controller / ApiController / Service / Mapper / JSP 신규 생성")
        items.append("메뉴(CSPD109TI) 및 screenAccess 등록")
    # dedupe preserve order
    seen = set()
    unique = []
    for it in items:
        if it not in seen:
            seen.add(it)
            unique.append(it)
    lines = ["---", "", f"## {sec}. 개발 체크리스트", ""]
    for it in unique:
        lines.append(f"- [ ] {it}")
    lines.append("")
    return lines


def build_sheet(screen: tuple) -> str:
    sid, name, domain, url, pattern, status, jsp, api, wireframe, fr, bpmn, notes = screen
    d = DETAIL.get(sid, {})
    proc = d.get("process") or {}
    purpose = d.get("purpose") or proc.get("purpose_process") or f"{name} — {PATTERN_DESC.get(pattern, pattern)} 화면."

    lines = [
        f"# SCR-{sid} — {name}",
        "",
        f"> **도메인:** {domain} · **상태:** {status} · **패턴:** {pattern} ({PATTERN_DESC.get(pattern, pattern)})  ",
        f"> **개발 가이드:** [00_개발자_가이드.md](../00_개발자_가이드.md) · **목차:** [목차.md](../목차.md)",
        "",
        "---",
        "",
        "## 1. 화면 개요",
        "",
        "| 항목 | 내용 |",
        "|------|------|",
        f"| 화면ID | `{sid}` |",
        f"| 화면명 | {name} |",
        f"| URL (View) | `{url}` |",
        f"| JSP | `WEB-INF/jsp/{jsp}` |",
        f"| 관련 FR | {fr or '—'} |",
        f"| 구현 상태 | {status_badge(status)} |",
        "",
        "### 1.1 화면 목적",
        "",
        purpose,
        "",
    ]
    if notes:
        lines += ["### 1.2 비고", "", notes, ""]
    if d.get("tobe_changes"):
        lines += ["### 1.3 TO-BE 변경 사항", ""]
        for ch in d["tobe_changes"]:
            lines.append(f"- {ch}")
        lines.append("")

    lines += [
        "---",
        "",
        "## 2. 기본 정보",
        "",
        "| 항목 | 값 |",
        "|------|-----|",
        f"| 유형 | {pattern} — {PATTERN_DESC.get(pattern, pattern)} |",
        f"| API | `{api}` |",
        f"| 프로세스 문서 | `{proc.get('process_doc', 'docs/process/목차.md')}` |",
        f"| 인증 | `AuthenticationInterceptor` + 세션 |",
        "",
        "---",
        "",
        "## 3. 업무 프로세스",
        "",
        "| 항목 | 내용 |",
        "|------|------|",
        f"| 선행 화면/조건 | {proc.get('nav_prev', '—')} |",
        f"| 후속 화면/결과 | {proc.get('nav_next', '—')} |",
        f"| 요약 | {proc.get('process_summary', purpose)} |",
        "",
    ]
    if proc.get("preconditions"):
        lines += [
            "### 3.1 선행·종료 조건",
            "",
            md_table(["구분", "조건"], proc["preconditions"]),
            "",
        ]
    steps = proc.get("process_steps") or []
    if steps:
        step_rows = []
        for s in steps:
            if len(s) >= 4:
                step_rows.append((s[0], s[1], s[2], s[3]))
            elif len(s) == 3:
                step_rows.append((s[0], s[1], s[2], ""))
            else:
                step_rows.append((s[0], s[1] if len(s) > 1 else "", "", ""))
        lines += [
            "### 3.2 상세 프로세스",
            "",
            md_table(["단계", "처리", "트리거/설명", "후속·비고"], step_rows),
            "",
        ]
    if proc.get("status_codes"):
        lines += [
            "### 3.3 상태·코드",
            "",
            md_table(["코드/조건", "의미"], proc["status_codes"]),
            "",
        ]
    if proc.get("detail_doc"):
        lines += [f"> 상세: `{proc['detail_doc']}`", ""]

    lines += [
        "---",
        "",
        "## 4. 레이아웃 (ASCII)",
        "",
        d.get("layout") or PATTERN_IMPL.get(pattern, {}).get("layout", ""),
        "",
    ]

    sec = 5
    if d.get("search"):
        lines += ["---", "", f"## {sec}. 검색 조건", "", md_table(
            ["필드", "파라미터", "타입", "필수", "HTML/설명"], d["search"]), ""]
        sec += 1
    elif d.get("fields"):
        lines += ["---", "", f"## {sec}. 입력·표시 필드", "", md_table(
            ["필드", "타입", "필수", "DB/설명"], d["fields"]), ""]
        sec += 1

    if d.get("columns"):
        hdr = ["컬럼", "data 필드", "정렬", "렌더/이벤트"]
        if d["columns"] and len(d["columns"][0]) == 3:
            hdr = ["컬럼", "정렬", "비고"]
        lines += ["---", "", f"## {sec}. 목록·그리드 컬럼", "", md_table(hdr, d["columns"]), ""]
        sec += 1

    if d.get("buttons"):
        lines += ["---", "", f"## {sec}. 버튼·액션", "", md_table(
            ["조건", "버튼", "API/동작"], d["buttons"]), ""]
        sec += 1

    if d.get("events"):
        note = d.get("events_note", EVENTS_SPEC_NOTE)
        lines += ["---", "", f"## {sec}. 이벤트·상호작용 (설계 설명)", "", f"> {note}", ""]
        if d.get("interaction"):
            lines.append(f"> 동작 요약: {d['interaction']}")
            lines.append("")
        lines += [md_table(["트리거", "동작", "비고"], d["events"]), ""]
        sec += 1
    else:
        lines += ["---", ""]

    lines += section_api_specs(sec, d, api)
    sec += 1
    lines += [
        "---",
        "",
        f"## {sec}. 접근권한 (TO-BE)",
        "",
        d.get("auth", "CSPD109TI(메뉴) + screenAccess(화면ID) + Task-Role(업무·역할, 해당 시)"),
        "",
        "| 계층 | 검증 위치 |",
        "|------|-----------|",
        "| L1 자격 | `TaskAuthService` — CSPD120TI |",
        "| L1 화면 | `ScreenAccessService` — CSPD122TI |",
        "| L2 Depth | `DepthRuleEngine` — CSPD121TI |",
        "| L3 SoD | Service — 동일인 심사·결재 금지 |",
        "",
        "---",
        "",
        f"## {sec + 1}. 유효성·메시지",
        "",
        d.get("validation", "공통: MSG-SESSION-001, MSG-AUTH-001 (AuthenticationInterceptor)"),
        "",
        "| 시점 | 처리 |",
        "|------|------|",
        "| 진입 | 세션·화면접근·역할 |",
        "| 조회 | SearchVO 타입·범위 |",
        "| 저장/승인 | 도메인 규칙 + confirm 다이얼로그 |",
        "",
    ]
    sec += 2

    lines += section_backend(sec, sid, url, jsp, d)
    sec += 1
    lines += section_tables(sec, d)
    sec += 1
    lines += ["---", ""]
    lines += section_frontend(sec, sid, jsp, pattern, wireframe, d)
    sec += 1

    lines += [
        "---",
        "",
        f"## {sec}. 화면 상태",
        "",
        "| 상태 | 설명 |",
        "|------|------|",
        "| 초기 | View Controller 모델 로드, 그리드 empty |",
        "| 조회중 | `initLoadingDisplay` 로딩 표시 |",
        "| 목록표시 | DataTables rowCallback — 색상·highlight |",
        "| 상세오픈 | 팝업 fullLayout, 부모 유지 |",
        "| 갱신 | SSE / 팝업닫기 → tableReload |",
        "",
    ]
    sec += 1

    lines += section_checklist(sec, sid, pattern, status, d)
    sec += 1

    lines += [
        "---",
        "",
        f"## {sec}. 관련 문서",
        "",
        "| 문서 | 경로 |",
        "|------|------|",
        f"| 프로세스 정의서 | `{proc.get('process_doc', 'docs/process/목차.md')}` |",
    ]
    if proc.get("detail_doc"):
        lines.append(f"| 상세 프로세스 | `{proc['detail_doc']}` |")
    lines += [
        "| UI 표준 | [00_UI표준.md](../00_UI표준.md) |",
        "| 권한·API | [00_권한_API_매트릭스.md](../00_권한_API_매트릭스.md) |",
        "| 메시지 | [00_메시지_검증.md](../00_메시지_검증.md) |",
        "| 시스템 프로세스 | [system-process.md](../../system-process.md) |",
        "| Excel | [화면설계서_TO-BE.xlsx](../excel/화면설계서_TO-BE.xlsx) |",
        "",
    ]
    return "\n".join(lines)


def build_dev_guide() -> str:
    return """# 화면설계서 — 개발자 가이드

> 화면별 시트(`sheets/*.md`)를 **구현 명세**로 사용하기 위한 읽는 법·공통 규칙.

---

## 1. 시트 구조

| § | 섹션 | 개발 시 활용 |
|---|------|-------------|
| 1 | 화면 개요 | 목적·TO-BE 변경 범위 |
| 2 | 기본 정보 | URL·JSP·API·프로세스 문서 |
| 3 | **업무 프로세스** | 선행/후속·단계·상태코드 |
| 4 | 레이아웃 | ASCII 구성 |
| 5~8 | 검색·컬럼·버튼·**이벤트** | 화면 동작 정의 |
| 9 | API 명세 | Request/Response·Controller |
| 10 | 접근권한 | Interceptor·Task-Role·SoD |
| 11 | 유효성·메시지 | 메시지 코드·confirm |
| 12 | 백엔드 | Controller/Service/Mapper/XML |
| 13 | **관련 테이블** | 논리명·물리명(CSPD*)·용도 |
| 14 | 프론트엔드 | JSP·JS·include |
| 15 | 화면 상태 | 로딩·팝업·SSE 갱신 |
| 16 | 체크리스트 | PR·UAT 검수 |
| 17 | 관련 문서 | 프로세스·아키텍처 |

---

## 2. 구현 순서 (권장)

1. **View Controller** — URL → JSP, 공통코드 Model
2. **ApiController** — REST 엔드포인트, SearchVO 바인딩
3. **Service/Mapper** — TO-BE 필터(Task-Role, Depth, SoD)
4. **JSP** — 검색폼 id/name을 시트 파라미터와 일치
5. **DataTables** — `columns[].data` ↔ API `resultList` 키
6. **이벤트** — 트리거·동작을 설계 설명으로 참조 후 구현
7. **권한** — AuthenticationInterceptor + screenAccess
8. **체크리스트** — 시트 전체 확인

---

## 3. 패턴별 Quick Reference

| 패턴 | 대표 | 핵심 파일 |
|------|------|-----------|
| C 목록 | 1010, 2010 | list.jsp + datatable.jsp + *ApiController |
| D 상세 | 1011, 2011 | detail.jsp + CommonDetailApiController |
| E MD | 7050, 7030 | master-detail JS + CRUD API |
| A 셸 | MAIN | layout.jsp + shell-v2.js + notify-client.js |
| G 모달 | BUNDLE | 팝업 JSP + POST API |

---

## 4. 신규 화면 (코드 없음)

| ID | URL | 우선 참조 |
|----|-----|-----------|
| 7050 | /admin/taskAuth | task-auth-panel.js, task-centric-auth-approval-guide.md |
| 7052 | /admin/approvDepth | admin-7052-approv-depth.html |
| 8070 | /admin/aiMonitor | admin-8070-monitor.html |
| 6066~6069 | /stat/* | stats-6066-regulatory.html 등 |

---

## 5. 재생성

```bash
python scripts/generate_screen_design_sheets.py
python scripts/generate_screen_design_excel.py
```
"""


def build_index() -> str:
    domains: dict[str, list] = {}
    for s in SCREENS:
        domains.setdefault(s[2], []).append(s)

    lines = [
        "# 화면설계서 목차 (TO-BE)",
        "",
        "> **개발자 가이드:** [00_개발자_가이드.md](./00_개발자_가이드.md)  ",
        "> **Markdown 시트:** `docs/screen-design/sheets/` (화면별 프로세스 포함)  ",
        "> **Excel 통합본:** [excel/화면설계서_TO-BE.xlsx](./excel/화면설계서_TO-BE.xlsx)",
        "",
        "## 공통 문서",
        "",
        "| 문서 | 설명 |",
        "|------|------|",
        "| [00_개발자_가이드.md](./00_개발자_가이드.md) | 시트 읽는 법·구현 순서 |",
        "| [00_UI표준.md](./00_UI표준.md) | 디자인·패턴 |",
        "| [00_권한_API_매트릭스.md](./00_권한_API_매트릭스.md) | 권한·API |",
        "| [00_메시지_검증.md](./00_메시지_검증.md) | 메시지·검증 |",
        "| [시스템 프로세스](../system-process.md) | End-to-End·상태전이 |",
        "| [프로세스 목차](../process/목차.md) | 도메인별 프로세스 정의서 |",
        "",
    ]
    for domain, screens in domains.items():
        lines += [f"## {domain}", "", "| ID | 화면명 | 상태 | 시트 |", "|----|--------|------|------|"]
        for s in screens:
            sid, sname, *_ = s
            st = s[5]
            fname = safe_filename(sid)
            lines.append(f"| {sid} | {sname} | {st} | [sheets/{fname}.md](./sheets/{fname}.md) |")
        lines.append("")
    return "\n".join(lines)


def main() -> None:
    OUT.mkdir(parents=True, exist_ok=True)
    DEV_GUIDE.write_text(build_dev_guide(), encoding="utf-8")
    for screen in SCREENS:
        path = OUT / f"{safe_filename(screen[0])}.md"
        path.write_text(build_sheet(screen), encoding="utf-8")
    INDEX.write_text(build_index(), encoding="utf-8")
    print(f"Dev guide: {DEV_GUIDE}")
    print(f"Markdown: {len(SCREENS)} sheets -> {OUT}")
    print(f"Index: {INDEX}")


if __name__ == "__main__":
    main()
