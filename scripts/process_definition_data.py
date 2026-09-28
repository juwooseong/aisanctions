# -*- coding: utf-8 -*-
"""업무프로세스 정의서 — 화면·BPMN·상세 프로세스 데이터 통합."""
from __future__ import annotations

from pathlib import Path
from typing import Any

from bpmn_parser import DETAIL_ID_ALIAS, resolve_bpmn
from generate_screen_design_excel import DETAIL, SCREENS

ROOT = Path(__file__).resolve().parents[1]

# 도메인 정의 (generate_detail_process.DOMAINS 기반 + TO-BE 확장)
DOMAINS: list[tuple[str, str, list[str]]] = [
    ("00_공통", "공통·진입", ["LOGIN", "MAIN", "DASH-v2", "DASH", "9999", "GLOBAL"]),
    ("01_심사", "심사", ["1010", "1020", "1030", "1011", "1011-BL"]),
    ("02_결재", "결재", ["2010", "BUNDLE", "2020", "2011", "2011-QA"]),
    ("03_QA", "QA", ["3010", "3020", "3011"]),
    ("04_현황명세", "심사 현황·명세", ["4010", "4020", "4030", "4040", "4050"]),
    ("05_업무일지", "업무일지", ["5010", "5020", "5030", "5040"]),
    ("06_통계", "통계", ["6010", "6020", "6030", "6040", "6050", "6066", "6067", "6069"]),
    ("07_관리자", "관리자", [
        "7010", "7021", "7022", "7030", "7031", "7040", "7050-RULE", "7050", "7051", "7052",
        "7060", "7070", "7080", "7090",
    ]),
    ("08_관리자시스템", "관리자 시스템", [
        "8010", "8020", "8030", "8040", "8050", "8051", "8060", "8070",
    ]),
    ("09_공통", "공통 팝업·이력", ["9010", "9020", "9080", "9090"]),
]

DOMAIN_FLOW: dict[str, str] = {
    "01_심사": "ToDo(1010) → 심사상세(1011) → 결재상신 → TA 연동",
    "02_결재": "결재 ToDo(2010) → 심사상세(2011) → 승인/반려/Block",
    "03_QA": "QA ToDo(3010) → QA상세(3011) → QA결재",
    "04_현황명세": "검색 → API 조회 → 목록/엑셀 (읽기전용)",
    "05_업무일지": "기준일/기간 → 조회·등록 → 마감",
    "06_통계": "검색조건 → 통계 API → 차트/목록",
    "07_관리자": "마스터 조회 → CRUD → 감사로그",
    "08_관리자시스템": "코드/설정 관리 → 시스템 모니터링",
    "09_공통": "이력/팝업 — 읽기전용 또는 첨부 처리",
    "00_공통": "로그인 → 메인셸 → 업무 화면 탭 로드",
}


def _load_detail_screens() -> dict[str, dict[str, Any]]:
    import generate_detail_process as gdp

    return gdp.build_all_screens()


def _detail_key(screen_id: str) -> str:
    return DETAIL_ID_ALIAS.get(screen_id, screen_id)


def get_screen_by_id(screen_id: str) -> tuple | None:
    for s in SCREENS:
        if s[0] == screen_id:
            return s
    return None


def build_process_profile(screen: tuple) -> dict[str, Any]:
    """화면별 통합 프로세스 프로필."""
    sid, name, domain, url, pattern, status, jsp, api, wireframe, fr, bpmn, notes = screen
    detail = DETAIL.get(sid, {})
    all_detail = _load_detail_screens()
    dkey = _detail_key(sid)
    proc_detail = all_detail.get(dkey, {})

    bpmn_data = resolve_bpmn(sid, bpmn or proc_detail.get("bpmn", ""), ROOT)

    # 상세 단계: detail_process 우선, 없으면 DETAIL flow/events 기반 생성
    steps = list(proc_detail.get("steps") or [])
    if not steps and detail.get("flow"):
        for i, line in enumerate(detail["flow"], 1):
            steps.append((str(i), line, "시스템", "—", line, "—", "—", "—", "—", "—"))
    if not steps and detail.get("events"):
        for i, ev in enumerate(detail["events"], 1):
            trigger, action, note = ev[0], ev[1], ev[2] if len(ev) > 2 else ""
            steps.append((str(i), trigger, "사용자/시스템", trigger, action, "—", "—", "—", note, "—"))

    events = list(proc_detail.get("events") or [])
    if not events and detail.get("events"):
        events = [(e[0], e[1]) for e in detail["events"]]

    apis = list(proc_detail.get("apis") or [])
    if not apis and detail.get("api_specs"):
        apis = [(s[0], s[4] or s[1]) for s in detail["api_specs"]]
    if not apis and api and api != "—":
        for part in api.split(";"):
            part = part.strip()
            if part:
                apis.append((part, name))

    states = list(proc_detail.get("states") or [])
    ui = list(proc_detail.get("ui") or [])
    if not ui and detail.get("ui_components"):
        ui = [f"{a}: {b}" for a, b, c in detail["ui_components"]]

    purpose = proc_detail.get("purpose") or detail.get("purpose") or f"{name} 업무 처리"
    pre = proc_detail.get("pre") or ["로그인 세션 유효", "화면 접근 권한"]
    post = proc_detail.get("post") or ["업무 처리 완료 또는 화면 종료"]

    related: list[tuple[str, str]] = []
    if pattern == "C":
        for ev in detail.get("events") or []:
            if "1011" in str(ev) or "상세" in str(ev):
                related.append(("다음 화면", "1011 심사상세"))
            if "9080" in str(ev) or "이력" in str(ev):
                related.append(("연계 화면", "9080 심사이력"))
    if sid == "1010":
        related = [("다음", "1011 심사상세"), ("이력", "9080 심사이력")]
    if sid == "2010":
        related = [("상세", "2011 결재자 심사상세"), ("팝업", "BUNDLE 일괄승인")]

    return {
        "screen_id": sid,
        "name": name,
        "domain": domain,
        "url": url,
        "pattern": pattern,
        "status": status,
        "jsp": jsp,
        "api": api,
        "fr": fr,
        "bpmn": bpmn,
        "notes": notes,
        "purpose": purpose,
        "pre": pre,
        "post": post,
        "ui": ui,
        "steps": steps,
        "events": events,
        "apis": apis,
        "states": states,
        "bpmn_data": bpmn_data,
        "related": related,
        "auth": detail.get("auth", "—"),
        "validation": detail.get("validation", "—"),
        "tobe_changes": detail.get("tobe_changes") or [],
        "tables": detail.get("tables") or [],
    }


def build_all_profiles() -> dict[str, dict[str, Any]]:
    return {s[0]: build_process_profile(s) for s in SCREENS}


def profile_summary(profile: dict[str, Any]) -> dict[str, int]:
    bpmn = profile.get("bpmn_data") or {}
    nodes = len(bpmn.get("elements") or [])
    if not nodes and profile.get("steps"):
        nodes = min(len(profile["steps"]), 10) + 2
    return {
        "흐름노드": nodes,
        "흐름연결": len(bpmn.get("flows") or []),
        "상세단계": len(profile.get("steps") or []),
        "이벤트": len(profile.get("events") or []),
        "API": len(profile.get("apis") or []),
    }
