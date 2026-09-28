# -*- coding: utf-8 -*-
"""와이어프레임 허브 파싱 + 전체 화면 DETAIL 자동 보강."""
from __future__ import annotations

import re
from pathlib import Path
from typing import Any

from screen_design_dev_data import DETAIL as BASE_DETAIL, BACKEND_MAP, PATTERN_IMPL
from screen_design_tables import build_screen_tables

ROOT = Path(__file__).resolve().parents[1]
HUB = ROOT / "docs" / "wireframes" / "index.html"

# standalone HTML 목업 (SCREENS wireframe 필드 보완)
STANDALONE_MOCKUP: dict[str, str] = {
    "LOGIN": "login-v2.html",
    "MAIN": "main-shell.html",
    "DASH": "dashboard.html",
    "DASH-v2": "dashboard-v2.html",
    "GLOBAL": "etc-fr005-urgent-notify.html",
    "1010": "list-1010-v2.html",
    "1011": "detail-1011-v4.html",
    "2010": "list-2010.html",
    "3010": "list-3010.html",
    "7030": "admin-7030.html",
    "7040": "admin-7040.html",
    "7050": "admin-7050-task-auth.html",
    "7052": "admin-7052-approv-depth.html",
    "8070": "admin-8070-monitor.html",
    "9080": "history-9080.html",
    "6066": "stats-6066-regulatory.html",
}

# 허브 data-screen ID ↔ 화면ID (불일치 보정)
HUB_ID_ALIAS: dict[str, str] = {
    "LOGIN-v2": "LOGIN",
    "1010-v2": "1010",
    "2010-BUNDLE": "BUNDLE",
    "7050-AUTH": "7050",
    "7050-RULE": "7050-RULE",
    "ETC-FR005": "GLOBAL",
}

PATTERN_UI: dict[str, list[tuple[str, str, str]]] = {
    "C": [
        ("타이틀", "wf-title-bar / h2.title", "화면ID·breadcrumb"),
        ("검색", "wf-search-v2 / wf-search", "필드 + [초기화][조회]"),
        ("툴바", "wf-task-log-toolbar", "엑셀·확인 등 도메인 버튼"),
        ("그리드", "wf-table-v2 / wf-table", "DataTables, 가로스크롤"),
        ("페이징", "wf-paging", "서버 페이징"),
    ],
    "D": [
        ("헤더", "wf-detail-header", "Ref.No·Depth뱃지·[×]"),
        ("좌패널", "wf-doc-tree", "문서분류 트리"),
        ("중앙", "wf-image-viewer", "Canvas 이미지+핀"),
        ("우패널", "wf-result-tabs", "항목심사/TotalText 탭"),
        ("하단", "wf-detail-actions", "역할·Depth별 버튼"),
    ],
    "E": [
        ("검색", "wf-search-v2", "상단 필터"),
        ("마스터", "wf-master-panel", "좌측 목록·트리"),
        ("디테일", "wf-detail-panel", "우측 폼·탭"),
        ("탭", "wf-layer-tab", "레이어 탭 전환"),
        ("액션", "wf-form-actions", "[저장][취소]"),
    ],
    "B": [
        ("긴급", "wf-urgent-card", "URGENT 카드 + [심사하기]"),
        ("숏컷", "wf-shortcut-card", "ToDo 건수 → 탭 이동"),
    ],
    "A": [
        ("GNB", "wf-gnb", "로고·메뉴·사용자"),
        ("LNB", "wf-lnb", "메뉴·배지·위젯"),
        ("탭", "wf-tab-bar", "다중 탭"),
        ("본문", "wf-view-container", "iframe"),
    ],
    "G": [
        ("오버레이", "wf-modal-overlay", "dim 배경"),
        ("본문", "wf-modal-body", "폼·확인"),
        ("버튼", "wf-modal-footer", "[확인][취소]"),
    ],
    "H": [
        ("타임라인", "wf-timeline", "좌측 이력 단계"),
        ("상세", "wf-history-detail", "우측 상세·첨부"),
    ],
    "F": [
        ("폼", "wf-form-panel", "입력 필드"),
        ("액션", "wf-form-actions", "[저장]"),
    ],
    "단독": [("로그인", "wf-login-card", "ID/PW/SSO")],
    "전역": [("Toast", "wf-toast-urgent", "긴급 알림"), ("SSE", "notify-client", "이벤트 분배")],
    "차트": [("검색", "wf-search-v2", ""), ("차트", "wf-chart-area", "Chart.js")],
}

# 화면설계서 이벤트 — 설계·설명 목적 (구현 코드 자동 생성 없음)
EVENTS_SPEC_NOTE = (
    "※ 설계·설명 목적 — 화면 동작·상호작용 정의서. "
    "본 설계서는 이벤트 핸들러 등 구현 코드를 자동 생성하지 않음."
)

PATTERN_EVENTS: dict[str, list[tuple[str, str, str]]] = {
    "C": [
        ("화면 진입 (onLoad)", "View Controller → list.jsp 렌더. 공통코드·초기 SearchVO Model 전달", "iframe 탭 내 로드"),
        ("DOMContentLoaded", "DataTables 초기화 — columns, ajaxUrl, serverSide, getSearchOption", "datatable.jsp 공통"),
        ("[조회] click", "getSearchOption() 수집 → dataTable.searchList() → GET API", "SearchVO 파라미터"),
        ("[초기화] click", "검색 폼 reset → 목록 clear 또는 초기 조회", ""),
        ("행 클릭 (column)", "hidden form 구성 → fnFullWin / form submit → 상세·팝업", "프로세스·액티비티 컬럼 index"),
        ("행 더블클릭 (column)", "이력·부가 팝업 (fnHistoryWin 등)", "Ref.No 등 컬럼 index 확인"),
        ("rowCallback", "행 스타일 — 수기입력·우선순위·상태별 class (wf-row-highlight 등)", "FR-004 P0/P1"),
        ("페이징·정렬", "DataTables serverSide 콜백 — pageIndex, sortColumn", "paginationInfo 연동"),
        ("팝업 닫힘", "부모 window tableReload() 또는 dataTable.ajax.reload()", "opener 콜백"),
        ("SSE / postMessage", "TODO_UPDATE·ASIDE_REFRESH 수신 → 목록 갱신", "layout.jsp notify-client"),
    ],
    "D": [
        ("팝업 진입", "POST hidden form — inptMstSrno, inptAtvtCd, actlFxRefno, btnFlag", "fullLayout 팝업"),
        ("onLoad", "POST /api/common/detail/load — 마스터·항목·이미지 메타", "CommonDetailApiController"),
        ("문서분류 클릭", "트리 노드 선택 → 이미지·항목 패널 갱신", "좌측 wf-doc-tree"),
        ("이미지 핀 클릭", "Canvas 좌표 → 항목 하이라이트", "annotation-store.js"),
        ("탭 전환", "항목심사 / TotalText / 전달 탭 show·hide", "wf-result-tabs"),
        ("[임시저장] click", "입력값 수집 → POST save API → confirm", "TA 비동기 연동"),
        ("[결재상신|승인] click", "Depth·btnFlag·SoD 검증 → POST apprv API", "역할별 분기"),
        ("[×] 닫기", "팝업 close → opener tableReload()", ""),
    ],
    "E": [
        ("화면 진입", "View Controller → 목록 초기 로드", ""),
        ("마스터 행 선택", "선택 행 highlight → GET 상세 API", "wf-master-panel"),
        ("탭 전환", "레이어 탭별 폼·하위 그리드 전환", "wf-layer-tab"),
        ("[저장] click", "폼 validation → POST save → 목록·상세 갱신", "트랜잭션 단위"),
        ("[삭제] click", "confirm → DELETE/POST → 마스터 목록 갱신", ""),
        ("[취소] click", "편집 중 데이터 rollback 또는 선택 해제", ""),
    ],
    "B": [
        ("화면 진입", "POST /api/dashboard — 카드·숏컷 데이터", ""),
        ("긴급 카드 클릭", "심사상세(1011) 팝업 또는 탭 오픈", "URGENT 건"),
        ("숏컷 클릭", "해당 ToDo 화면 탭 오픈 (1010/2010)", "건수 배지"),
        ("SSE DASHBOARD_REFRESH", "카드·숏컷 수치 갱신", "notify-client"),
        ("[새로고침]", "전체 데이터 재조회", "#refreshBtn"),
    ],
    "A": [
        ("앱 시작", "layout.jsp 로드 — GNB·LNB·탭바 초기화", ""),
        ("LNB 메뉴 click", "screenAccess 검증 → 탭 오픈 + iframe src 설정", "중복 탭 방지"),
        ("탭 닫기", "iframe destroy, 활성 탭 전환", "wf-tab-bar"),
        ("SSE 연결", "GET /api/notify/stream — 1회 연결·재연결 backoff", "notify-client.js"),
        ("postMessage 수신", "TODO_UPDATE 등 → 활성 iframe에 전달", "origin 검증"),
    ],
    "G": [
        ("팝업 오픈", "window.open 또는 layer — 부모 파라미터 전달", ""),
        ("[확인] click", "폼 validation → POST API → 부모 콜백", "opener.reload"),
        ("[취소] click", "팝업 닫기 — 변경 없음", ""),
        ("배경 클릭", "dim 영역 — 닫기 또는 무시 (정책)", "wf-modal-overlay"),
    ],
    "H": [
        ("화면 진입", "이력 목록·타임라인 초기 로드", ""),
        ("타임라인 단계 click", "해당 단계 상세·첨부 로드", "읽기전용"),
        ("첨부 click", "파일 다운로드 또는 미리보기", ""),
    ],
    "F": [
        ("화면 진입", "단일 폼 — 기존 데이터 bind (수정 시)", ""),
        ("[저장] click", "client validation → POST → confirm", ""),
        ("[취소] click", "폼 reset 또는 목록 복귀", ""),
    ],
    "단독": [
        ("페이지 로드", "로그인 폼 표시 — 세션 없을 때", ""),
        ("[Login] submit", "beanValidator → POST /login → 세션 생성", "성공 시 /index"),
        ("[SSO] click", "POST /sso/prx — 포털 프록시 인증", ""),
    ],
    "전역": [
        ("SSE 수신", "notify 이벤트 파싱 → Toast 표시·postMessage 분배", "notify-client.js"),
        ("Toast 표시", "wf-toast-urgent — 긴급 알림 UI", "자동 소멸 타이머"),
        ("폴링 fallback", "GET /api/notify/poll — SSE 미지원 시", ""),
    ],
    "차트": [
        ("[조회] click", "검색조건 → Chart.js 데이터 갱신", ""),
        ("차트 hover", "툴팁·범례 상호작용", "읽기전용 통계"),
    ],
}


def _strip_tags(html: str) -> str:
    return re.sub(r"<[^>]+>", "", html).strip()


def _extract_th(section: str) -> list[str]:
    headers = re.findall(r"<th[^>]*>([^<]+)</th>", section)
    return [h.strip() for h in headers if h.strip() and h.strip() != "□"]


def _extract_labels(section: str) -> list[str]:
    labels = re.findall(r'<div class="wf-field"[^>]*>\s*<label>([^<]+)</label>', section)
    if not labels:
        labels = re.findall(r"<label>([^<]+)</label>", section)
    return list(dict.fromkeys(l.strip() for l in labels if l.strip()))


def _extract_toolbar(section: str) -> list[str]:
    toolbar = re.search(r'wf-task-log-toolbar[^>]*>(.*?)</div>', section, re.S)
    if not toolbar:
        return []
    return re.findall(r"<button[^>]*>([^<]+)</button>", toolbar.group(1))


def _extract_notes(section: str) -> str:
    m = re.search(r'<div class="wf-notes">(.*?)</div>', section, re.S)
    return _strip_tags(m.group(1)) if m else ""


def _extract_desc(section: str) -> str:
    m = re.search(r'<p class="wf-desc">([^<]*)</p>', section)
    return m.group(1).strip() if m else ""


def parse_hub_sections() -> dict[str, dict[str, Any]]:
    if not HUB.exists():
        return {}
    text = HUB.read_text(encoding="utf-8")
    sections = re.split(r'(?=<section id="screen-)', text)
    result: dict[str, dict[str, Any]] = {}
    for block in sections:
        m = re.match(r'<section id="screen-([^"]+)"', block)
        if not m:
            continue
        hub_id = m.group(1)
        sid = HUB_ID_ALIAS.get(hub_id, hub_id)
        result[sid] = {
            "hub_id": hub_id,
            "hub_anchor": f"index.html#screen-{hub_id}",
            "hub_url": f"docs/wireframes/index.html#screen-{hub_id}",
            "mockup_type": "hub",
            "desc": _extract_desc(block),
            "search_labels": _extract_labels(block),
            "columns": [(c, "—", "") for c in _extract_th(block)],
            "toolbar": _extract_toolbar(block),
            "interaction": _extract_notes(block),
        }
    return result


def mockup_source(sid: str, wireframe: str, hub: dict) -> dict[str, str]:
    if wireframe and wireframe != "—":
        return {
            "type": "standalone",
            "file": wireframe,
            "path": f"docs/wireframes/{wireframe}",
            "preview": f"docs/wireframes/{wireframe}",
        }
    if sid in STANDALONE_MOCKUP:
        f = STANDALONE_MOCKUP[sid]
        return {"type": "standalone", "file": f, "path": f"docs/wireframes/{f}", "preview": f"docs/wireframes/{f}"}
    if sid in hub:
        return {
            "type": "hub",
            "file": "index.html",
            "path": hub[sid]["hub_url"],
            "preview": hub[sid]["hub_anchor"],
        }
    return {"type": "pattern", "file": "—", "path": "docs/wireframes/index.html", "preview": "패턴 템플릿"}


def default_search(pattern: str, name: str) -> list[tuple]:
    if pattern == "C":
        return [
            ("기간", "schSdate1/schEdate1", "date", "N", "당일/기간"),
            ("업무", "inptAtmcBizDscd", "select", "N", "공통코드"),
            ("Ref.No", "actlFxRefno", "text", "N", ""),
            ("고객번호", "aiInptCsno", "text", "N", ""),
        ]
    if pattern == "E":
        return [("검색어", "keyword", "text", "N", "마스터 목록 필터")]
    return []


def default_columns(pattern: str) -> list[tuple]:
    if pattern == "C":
        return [
            ("No", "—", "순번"),
            ("생성일", "DESC", ""),
            ("업무", "—", ""),
            ("Ref.No", "—", "링크/더블클릭"),
            ("상태", "—", ""),
        ]
    return []


def default_buttons(pattern: str, toolbar: list[str]) -> list[tuple]:
    rows = [("항상", "[조회]", "목록 갱신"), ("항상", "[초기화]", "검색 reset")]
    for btn in toolbar:
        rows.append(("선택/조건", f"[{btn}]", ""))
    if pattern == "F":
        rows = [("—", "[저장]", "POST API"), ("—", "[취소]", "폼 reset")]
    if pattern == "G":
        rows = [("—", "[확인]", "POST"), ("—", "[취소]", "닫기")]
    return rows


def build_mockup_layout(sid: str, name: str, pattern: str, source: dict, ui_rows: list) -> str:
    ui_lines = "\n".join(f"│  · {a}: {b} ({c})" for a, b, c in ui_rows[:6])
    src = source.get("preview", "—")
    return f"""```
┌─ SCR-{sid} {name} ─────────────────────────────────────────┐
│ 목업: {src}
├───────────────────────────────────────────────────────────┤
{ui_lines}
└───────────────────────────────────────────────────────────┘
```"""


def _dedupe_events(rows: list[tuple[str, str, str]]) -> list[tuple[str, str, str]]:
    seen: set[tuple[str, str, str]] = set()
    out: list[tuple[str, str, str]] = []
    for row in rows:
        key = (row[0], row[1], row[2] if len(row) > 2 else "")
        if key in seen:
            continue
        seen.add(key)
        out.append((row[0], row[1], row[2] if len(row) > 2 else ""))
    return out


def build_screen_events(
    sid: str,
    pattern: str,
    base: dict[str, Any],
    h: dict[str, Any],
    api: str,
) -> list[tuple[str, str, str]]:
    """패턴·목업·버튼·컬럼 기반 이벤트 설명 생성 (설계서용)."""
    manual = base.get("events")
    if manual and len(manual) > 1:
        first = manual[0][0] if manual else ""
        if first not in ("목업 정의", "상호작용"):
            return list(manual)

    events: list[tuple[str, str, str]] = list(PATTERN_EVENTS.get(pattern, []))

    for cond, btn, action in base.get("buttons", []):
        label = btn.strip("[]")
        if label in ("조회", "초기화", "저장", "취소", "확인"):
            continue
        events.append((f"{btn} click", action or "도메인 액션", cond))

    for col in base.get("columns", []):
        if len(col) >= 4 and col[3] and col[3] not in ("—", "", "이벤트용"):
            events.append((f"컬럼 '{col[0]}'", col[3], "columnDef·render"))
        elif len(col) == 3 and col[2] and any(k in col[2] for k in ("클릭", "링크", "더블", "이벤트")):
            events.append((f"컬럼 '{col[0]}'", col[2], "columnDef"))

    for part in api.split(";"):
        part = part.strip()
        if not part or part == "—":
            continue
        if part.startswith(("GET", "POST", "PUT", "DELETE")):
            method, _, path = part.partition(" ")
            events.append((f"API {method}", path.strip() or part, "REST 연동"))
        else:
            events.append(("API 호출", part, ""))

    interaction = h.get("interaction") or base.get("interaction", "")
    if interaction:
        for chunk in re.split(r"[;\n]|(?<=\.)\s+", interaction):
            chunk = chunk.strip()
            if len(chunk) > 3:
                events.append(("상호작용", chunk, "화면 동작 정의"))

    if manual and len(manual) == 1:
        events.insert(0, manual[0])

    result = _dedupe_events(events)
    return result or [("—", "패턴 기본 상호작용 — PATTERN_EVENTS 참조", "설계 설명")]


def enrich_screen(sid: str, screen: tuple, hub: dict) -> dict[str, Any]:
    name, domain, url, pattern, status, jsp, api, wireframe, fr, bpmn, notes = screen[1:]
    base = dict(BASE_DETAIL.get(sid, {}))
    h = hub.get(sid, {})

    if not base.get("purpose"):
        base["purpose"] = h.get("desc") or f"{name} — {domain} 업무 화면 ({pattern})"

    if h.get("search_labels") and not base.get("search"):
        base["search"] = [
            (lbl, lbl.replace(".", "").replace(" ", ""), "text/select", "N", "검색 조건")
            for lbl in h["search_labels"]
        ]
    if not base.get("search"):
        base["search"] = default_search(pattern, name)

    if h.get("columns") and not base.get("columns"):
        base["columns"] = h["columns"]
    if not base.get("columns") and pattern in ("C", "차트"):
        base["columns"] = default_columns(pattern)

    if not base.get("buttons"):
        base["buttons"] = default_buttons(pattern, h.get("toolbar", []))

    # 레이아웃: 패턴 ASCII만 사용 (목업 HTML 경로 제외)
    if not base.get("layout"):
        pat_layout = PATTERN_IMPL.get(pattern, {}).get("layout", "")
        if pat_layout:
            base["layout"] = pat_layout if pat_layout.startswith("```") else f"```\n{pat_layout}\n```"
        else:
            base["layout"] = build_screen_layout(sid, name, pattern)
    elif not base["layout"].startswith("```"):
        base["layout"] = f"```\n{base['layout']}\n```"

    if h.get("interaction"):
        base["interaction"] = h["interaction"]

    base["events"] = build_screen_events(sid, pattern, base, h, api)
    base["events_note"] = EVENTS_SPEC_NOTE

    be = base.get("backend") if isinstance(base.get("backend"), dict) else BACKEND_MAP.get(sid)
    base["tables"] = build_screen_tables(sid, screen, base, be)

    base.setdefault("validation", "공통 세션·권한 검증 (AuthenticationInterceptor)")
    base.setdefault("auth", "CSPD109TI + screenAccess + Task-Role (해당 시)")

    return base


def build_screen_layout(sid: str, name: str, pattern: str) -> str:
    """패턴별 ASCII 레이아웃 (목업 경로 없음)."""
    ui_rows = PATTERN_UI.get(pattern, [])
    ui_lines = "\n".join(f"│  · {a}: {c}" for a, _b, c in ui_rows[:6]) or "│  · 영역 구성 — 패턴 참조"
    return f"""```
┌─ SCR-{sid} {name} ─────────────────────────────────────────┐
│ 패턴: {pattern}
├───────────────────────────────────────────────────────────┤
{ui_lines}
└───────────────────────────────────────────────────────────┘
```"""


def build_enriched_detail(screens: list[tuple]) -> dict[str, dict[str, Any]]:
    hub = parse_hub_sections()
    enriched = {}
    for s in screens:
        enriched[s[0]] = enrich_screen(s[0], s, hub)
    from screen_design_process import attach_process_to_detail

    attach_process_to_detail(enriched, screens)
    return enriched


# 모듈 로드 시 전체 화면 보강 DETAIL
def get_detail_for_screens(screens: list[tuple]) -> dict[str, dict[str, Any]]:
    return build_enriched_detail(screens)


# SCREENS 없이 import 시 BASE만
DETAIL: dict[str, dict[str, Any]] = dict(BASE_DETAIL)
