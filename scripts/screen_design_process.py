# -*- coding: utf-8 -*-
"""화면설계서 — docs/process/*.md 에서 화면별 프로세스 추출."""
from __future__ import annotations

import re
from pathlib import Path
from typing import Any

ROOT = Path(__file__).resolve().parents[1]
PROCESS_DIR = ROOT / "docs" / "process"
PROCESS_DETAIL_DIR = PROCESS_DIR / "상세"

DOMAIN_PROCESS_FILE: dict[str, str] = {
    "00_공통": "00_공통_진입화면.md",
    "01_심사": "01_심사.md",
    "02_결재": "02_결재.md",
    "03_QA": "03_QA.md",
    "04_현황명세": "04_심사현황명세.md",
    "05_업무일지": "05_업무일지.md",
    "06_통계": "06_통계.md",
    "07_관리자": "07_관리자.md",
    "08_관리자시스템": "07_관리자.md",
    "09_공통": "08_공통팝업.md",
}

DOMAIN_DETAIL_FILE: dict[str, str] = {
    "00_공통": "00_공통_진입화면_상세.md",
    "01_심사": "01_심사_상세.md",
    "02_결재": "02_결재_상세.md",
    "03_QA": "03_QA_상세.md",
    "04_현황명세": "04_심사현황명세_상세.md",
    "05_업무일지": "05_업무일지_상세.md",
    "06_통계": "06_통계_상세.md",
    "07_관리자": "07_관리자_상세.md",
    "08_관리자시스템": "07_관리자_상세.md",
    "09_공통": "08_공통팝업_상세.md",
}

# End-to-End 인접 화면 (화면ID → 이전/다음)
NAV_FLOW: dict[str, dict[str, str]] = {
    "LOGIN": {"prev": "SSO/포털", "next": "MAIN"},
    "MAIN": {"prev": "LOGIN", "next": "DASH / LNB 메뉴"},
    "DASH": {"prev": "MAIN", "next": "1010 / 2010"},
    "DASH-v2": {"prev": "MAIN", "next": "1010 / 2010"},
    "1010": {"prev": "TA배정 / DASH", "next": "1011 → 상신 → 2010"},
    "1020": {"prev": "1010", "next": "1011 / 9080"},
    "1030": {"prev": "WINI 접수", "next": "업무생성 확인 → 1010"},
    "1011": {"prev": "1010", "next": "임시저장 / 상신 → 2010"},
    "1011-BL": {"prev": "1011", "next": "1011 복귀"},
    "2010": {"prev": "1011 상신", "next": "2011 / BUNDLE"},
    "2020": {"prev": "2010", "next": "2011"},
    "2011": {"prev": "2010", "next": "승인→완료/QA / 반려→1010 / Block"},
    "2011-QA": {"prev": "3011 QA상신", "next": "QA승인→완료 / QA반려→3010"},
    "BUNDLE": {"prev": "2010", "next": "일괄승인 → 목록 갱신"},
    "3010": {"prev": "QA선정배치(7060)", "next": "3011"},
    "3020": {"prev": "3010", "next": "3011"},
    "3011": {"prev": "3010", "next": "QA상신 → 2011-QA"},
    "4010": {"prev": "업무생성", "next": "1010 / 현황"},
    "4030": {"prev": "결재완료/QA완료", "next": "9080 이력"},
    "4040": {"prev": "심사오류", "next": "8051 재처리"},
    "4050": {"prev": "경보발생", "next": "1011 / 통계"},
    "7060": {"prev": "결재완료", "next": "3010 QA ToDo"},
    "7080": {"prev": "부재/이관", "next": "1010 / 2010 재배정"},
    "8051": {"prev": "8050", "next": "재처리 → 심사 재개"},
    "9080": {"prev": "목록 Ref.No", "next": "9010 이력상세"},
    "9090": {"prev": "목록 QA Ref.No", "next": "9020 QA이력상세"},
    "9010": {"prev": "9080", "next": "닫기"},
    "9020": {"prev": "9090", "next": "닫기"},
}


def _parse_md_table(block: str) -> list[list[str]]:
    rows: list[list[str]] = []
    for line in block.splitlines():
        line = line.strip()
        if not line.startswith("|"):
            continue
        cells = [c.strip() for c in line.strip("|").split("|")]
        if cells and all(re.match(r"^:?-+:?$", c) for c in cells):
            continue
        rows.append(cells)
    return rows


def _split_scr_sections(text: str) -> dict[str, str]:
    """## SCR-xxxx 섹션을 화면ID 키로 분리."""
    parts = re.split(r"(?=^## SCR-)", text, flags=re.M)
    result: dict[str, str] = {}
    for part in parts:
        m = re.match(r"^## SCR-([A-Za-z0-9_-]+)", part.strip())
        if not m:
            continue
        sid = m.group(1)
        # 제목에 부가명 포함: SCR-1010 — ...
        result[sid] = part
    return result


def _extract_purpose(section: str) -> str:
    m = re.search(
        r"###\s*화면\s*목적\s*\n+(.+?)(?=\n###|\n## |\Z)",
        section,
        re.S,
    )
    if m:
        return re.sub(r"\s+", " ", m.group(1).strip())
    m2 = re.search(r"\*\*화면\s*목적\*\*\s*\n+(.+?)(?=\n###|\n## |\Z)", section, re.S)
    if m2:
        return re.sub(r"\s+", " ", m2.group(1).strip())
    return ""


def _extract_subsection_table(section: str, titles: list[str]) -> list[list[str]]:
    for title in titles:
        # "### 4. 상세 처리 흐름" 처럼 번호가 붙은 제목도 인식
        m = re.search(
            rf"###\s*(?:\d+\.\s*)?{re.escape(title)}\s*\n+((?:\|.+\n)+)",
            section,
            re.I,
        )
        if m:
            rows = _parse_md_table(m.group(1))
            return rows[1:] if len(rows) > 1 else rows  # drop header
    return []


def _extract_preconditions(section: str) -> list[tuple[str, str]]:
    rows = _extract_subsection_table(section, ["선행 조건 / 종료 조건", "선행·종료 조건"])
    out: list[tuple[str, str]] = []
    for r in rows:
        if len(r) >= 2:
            out.append((r[0], r[1]))
    return out


def _extract_process_steps(section: str) -> list[tuple]:
    """상세 프로세스 표 → (단계, 처리, 트리거/설명, 후속/비고)."""
    rows = _extract_subsection_table(
        section,
        ["상세 프로세스", "상세 처리 흐름", "처리 흐름"],
    )
    out: list[tuple] = []
    for r in rows:
        if len(r) >= 10:
            # 상세: 순번|단계|담당|트리거|처리내용|API|입력|출력|분기|예외
            note = r[4]
            if r[5] and r[5] != "—":
                note = f"{r[4]} · {r[5]}"
            out.append((r[0], r[1], r[3], note))
        elif len(r) >= 4:
            out.append((r[0], r[1], r[2], r[3] if len(r) > 3 else ""))
        elif len(r) == 3:
            out.append((r[0], r[1], r[2], ""))
    return out


def _extract_status_codes(section: str) -> list[tuple[str, str]]:
    rows = _extract_subsection_table(section, ["상태 / 코드", "결과 코드 색상", "상태·코드"])
    out: list[tuple[str, str]] = []
    for r in rows:
        if len(r) >= 2:
            out.append((r[0], r[1]))
    # 본문에 코드 리스트만 있는 경우
    if not out:
        for line in section.splitlines():
            m = re.match(r"^-\s*`?(\d+|[\w=]+)`?\s*(?:\(([^)]+)\))?\s*[:：]?\s*(.*)$", line.strip())
            if m and ("30" in m.group(1) or "40" in m.group(1) or "=" in m.group(1)):
                label = m.group(2) or m.group(1)
                out.append((m.group(1), f"{label} {m.group(3)}".strip()))
    return out


def _load_file(path: Path) -> dict[str, str]:
    if not path.exists():
        return {}
    return _split_scr_sections(path.read_text(encoding="utf-8"))


def load_all_process_sections() -> dict[str, dict[str, str]]:
    """sid → {basic, detail, process_doc, detail_doc}."""
    cache: dict[str, dict[str, str]] = {}
    for domain, fname in DOMAIN_PROCESS_FILE.items():
        basic_map = _load_file(PROCESS_DIR / fname)
        detail_name = DOMAIN_DETAIL_FILE.get(domain, "")
        detail_map = _load_file(PROCESS_DETAIL_DIR / detail_name) if detail_name else {}
        for sid, body in basic_map.items():
            entry = cache.setdefault(sid, {})
            entry["basic"] = body
            entry["process_doc"] = f"docs/process/{fname}"
        for sid, body in detail_map.items():
            entry = cache.setdefault(sid, {})
            entry["detail"] = body
            if detail_name:
                entry["detail_doc"] = f"docs/process/상세/{detail_name}"
            if "process_doc" not in entry:
                entry["process_doc"] = f"docs/process/{fname}"
    return cache


def build_process_for_screen(
    sid: str,
    domain: str,
    name: str,
    pattern: str,
    notes: str,
    sections: dict[str, dict[str, str]] | None = None,
) -> dict[str, Any]:
    """화면별 프로세스 보강 데이터."""
    if sections is None:
        sections = load_all_process_sections()
    sec = sections.get(sid, {})
    basic = sec.get("basic", "")
    detail = sec.get("detail", "")
    source = detail or basic

    purpose = _extract_purpose(detail) or _extract_purpose(basic)
    steps = _extract_process_steps(detail) or _extract_process_steps(basic)
    preconds = _extract_preconditions(detail) or _extract_preconditions(basic)
    codes = _extract_status_codes(detail) or _extract_status_codes(basic)

    # 기본 프로세스 미존재 시 패턴 기반 생성
    if not steps:
        steps = _default_steps(pattern, sid, name)

    nav = NAV_FLOW.get(sid, {})
    process_doc = sec.get("process_doc") or f"docs/process/{DOMAIN_PROCESS_FILE.get(domain, '목차.md')}"
    detail_doc = sec.get("detail_doc") or ""

    summary = purpose or f"{name} 업무 처리"
    if nav:
        summary = f"{summary} (흐름: {nav.get('prev', '—')} → [{sid}] → {nav.get('next', '—')})"

    return {
        "purpose_process": purpose,
        "process_summary": summary,
        "process_steps": steps,
        "preconditions": preconds,
        "status_codes": codes,
        "nav_prev": nav.get("prev", "—"),
        "nav_next": nav.get("next", "—"),
        "process_doc": process_doc,
        "detail_doc": detail_doc,
        "has_process_source": bool(source),
        "notes": notes or "",
    }


def _default_steps(pattern: str, sid: str, name: str) -> list[tuple]:
    common = {
        "C": [
            ("1", "화면 초기화", "iframe/탭 로드", "검색조건·공통코드 세팅"),
            ("2", "목록 조회", "[조회] / 자동", "API → DataTables 렌더"),
            ("3", "행 처리", "클릭/더블클릭", "상세·이력 팝업 또는 액션"),
            ("4", "목록 갱신", "팝업 닫힘 / SSE", "tableReload()"),
        ],
        "D": [
            ("1", "상세 진입", "목록에서 POST", "진입 파라미터·권한 검증"),
            ("2", "상세 로드", "onLoad", "load API → 마스터·항목·이미지"),
            ("3", "검토·입력", "사용자 조작", "항목 수정·문서 검토"),
            ("4", "저장/상신/승인", "버튼 클릭", "도메인 API → 상태 전이"),
            ("5", "닫기", "[×]", "부모 목록 갱신"),
        ],
        "E": [
            ("1", "마스터 목록 조회", "화면 진입", "좌측 목록/트리"),
            ("2", "상세 로드", "행 선택", "우측 폼·탭 바인딩"),
            ("3", "저장/삭제", "버튼", "CRUD API → 목록 갱신"),
        ],
        "F": [
            ("1", "폼 로드", "화면 진입", "기존 데이터 바인딩"),
            ("2", "입력·검증", "사용자", "필수·포맷 검증"),
            ("3", "저장", "[저장]", "POST API"),
        ],
        "G": [
            ("1", "팝업 오픈", "부모 호출", "파라미터 수신"),
            ("2", "확인 처리", "[확인]", "POST → 부모 콜백"),
            ("3", "취소", "[취소]", "변경 없이 닫기"),
        ],
        "H": [
            ("1", "이력 로드", "화면 진입", "타임라인/목록 API"),
            ("2", "단계 선택", "클릭", "상세·첨부 표시"),
            ("3", "닫기", "[×]", "부모 복귀"),
        ],
        "A": [
            ("1", "셸 로드", "로그인 후", "GNB·LNB·탭·SSE 초기화"),
            ("2", "메뉴 오픈", "LNB 클릭", "탭+iframe 로드"),
            ("3", "알림 분배", "SSE 수신", "Toast/postMessage"),
        ],
        "B": [
            ("1", "대시보드 조회", "진입", "카드·숏컷 API"),
            ("2", "화면 이동", "카드/숏컷 클릭", "ToDo/상세 오픈"),
            ("3", "갱신", "SSE / 새로고침", "수치 재조회"),
        ],
        "단독": [
            ("1", "로그인 폼", "세션 없음", "ID/PW 또는 SSO"),
            ("2", "인증", "submit", "세션 생성 → MAIN"),
        ],
        "전역": [
            ("1", "SSE 연결", "layout 로드", "/api/notify/stream"),
            ("2", "이벤트 분배", "수신", "Toast · iframe postMessage"),
        ],
        "차트": [
            ("1", "검색조건 설정", "사용자", "기간·업무 등"),
            ("2", "통계 조회", "[조회]", "Chart.js 데이터 바인딩"),
        ],
    }
    return common.get(pattern, [
        ("1", f"{name} 진입", "메뉴", f"SCR-{sid}"),
        ("2", "조회/처리", "사용자", "도메인 API"),
        ("3", "완료", "후속", "목록 갱신 또는 닫기"),
    ])


def attach_process_to_detail(
    detail: dict[str, dict[str, Any]],
    screens: list[tuple],
) -> dict[str, dict[str, Any]]:
    sections = load_all_process_sections()
    for screen in screens:
        sid, name, domain, *_rest = screen
        notes = screen[11] if len(screen) > 11 else ""
        pattern = screen[4]
        proc = build_process_for_screen(sid, domain, name, pattern, notes, sections)
        entry = detail.setdefault(sid, {})
        entry["process"] = proc
        # 프로세스 목적·선행조건으로 목적 보강 (기존 한 줄 목적에 구체 내용 병합)
        if proc.get("purpose_process"):
            base_purpose = str(entry.get("purpose") or "").strip()
            proc_purpose = proc["purpose_process"].strip()
            if not base_purpose:
                entry["purpose"] = proc_purpose
            elif proc_purpose not in base_purpose and base_purpose not in proc_purpose:
                entry["purpose"] = f"{base_purpose} {proc_purpose}"
            elif len(proc_purpose) > len(base_purpose):
                entry["purpose"] = proc_purpose
        # flow 미정의 시 프로세스 단계로 채움
        if not entry.get("flow") and proc.get("process_steps"):
            entry["flow"] = [
                f"{s[0]}. {s[1]} — {s[2]} → {s[3]}"
                for s in proc["process_steps"]
            ]
    return detail
