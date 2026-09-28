# -*- coding: utf-8 -*-
"""화면설계서 — 화면별 관련 테이블 (논리명/물리명) 매핑."""
from __future__ import annotations

import re
from pathlib import Path
from typing import Any

ROOT = Path(__file__).resolve().parents[1]
MAPPER_DIR = ROOT / "src/main/resources/egovframework/sqlmap/ui/mappers"

# sql/01_ddl.sql COMMENT ON TABLE + TO-BE 신규
TABLE_CATALOG: dict[str, str] = {
    "CSPD001TM": "AI 심사 마스터",
    "CSPD002TG": "문서 및 이미지 그룹",
    "CSPD003TF": "TotalText 추출 결과",
    "CSPD004TF": "제재 항목 탐지 데이터",
    "CSPD005TH": "승인 및 처리 이력",
    "CSPD006TL": "첨부파일 정보",
    "CSPD007TL": "SafeWatch 탐지 결과",
    "CSPD008TH": "AI 심사 진행 이력",
    "CSPD009TA": "업무 종료 통계",
    "CSPD010TA": "업무 등록 통계",
    "CSPD011TL": "미생성 및 추출 처리 로그",
    "CSPD101TI": "사용자 정보",
    "CSPD102TI": "WatchList 카테고리",
    "CSPD103TI": "WatchList 목록",
    "CSPD104TI": "WatchList 응답 텍스트",
    "CSPD105TI": "제재 룰 1단계",
    "CSPD106TI": "제재 룰 2단계",
    "CSPD107TI": "QA 대상 선정 정보",
    "CSPD108TI": "메뉴 정보",
    "CSPD109TI": "메뉴 권한 정보",
    "CSPD110TI": "승인 의견 메모",
    "CSPD111TI": "공통코드 그룹",
    "CSPD112TI": "공통코드 상세",
    "CSPD113TI": "제재 SQL 룰",
    "CSPD115TI": "국가 코드 정보",
    "CSPD116TI": "제재 룰 설정",
    "CSPD117TI": "AI 심사용어 사전",
    "CSPD118TI": "도시 및 항구 정보",
    "CSPD118TM": "영업일 및 휴일 정보",
    "CSPD119TI": "업무(Task) 마스터",
    "CSPD120TI": "업무별 사용자 역할",
    "CSPD121TI": "승인 Depth 규칙",
    "CSPD122TI": "사용자 화면별 접근권한",
    "CSPD123TH": "권한·역할 변경 이력",
    "CSPD201TM": "수출 원장",
    "CSPD202TM": "수입 원장",
    "CSPD810TH": "로그인 이력",
    "CSPD811TH": "프로그램 사용 이력",
    "CSPD900TI": "재처리 상태 정보",
}

# 공통 참조
T_AUTH = ["CSPD101TI", "CSPD109TI", "CSPD120TI", "CSPD122TI"]
T_CODE = ["CSPD111TI", "CSPD112TI"]
T_CASE_CORE = ["CSPD001TM", "CSPD201TM", "CSPD202TM", "CSPD005TH", "CSPD008TH"]
T_DETAIL = ["CSPD001TM", "CSPD002TG", "CSPD003TF", "CSPD004TF", "CSPD005TH", "CSPD006TL", "CSPD007TL"]
T_LOG_PROG = ["CSPD811TH"]

# 화면ID 수동 매핑 (우선)
SCREEN_TABLES: dict[str, list[tuple[str, str, str]]] = {
    "LOGIN": [
        ("사용자 정보", "CSPD101TI", "인증·세션"),
        ("업무별 사용자 역할", "CSPD120TI", "TO-BE taskRoles 적재"),
        ("사용자 화면별 접근권한", "CSPD122TI", "TO-BE screenAccess 적재"),
        ("메뉴 권한 정보", "CSPD109TI", "메뉴 트리"),
        ("로그인 이력", "CSPD810TH", "INSERT"),
    ],
    "MAIN": [
        ("메뉴 정보", "CSPD108TI", "LNB 트리"),
        ("메뉴 권한 정보", "CSPD109TI", "권한 필터"),
        ("사용자 화면별 접근권한", "CSPD122TI", "탭 오픈 검증"),
        ("업무별 사용자 역할", "CSPD120TI", "배지·숏컷"),
    ],
    "DASH": [("AI 심사 마스터", "CSPD001TM", "긴급·숏컷 집계")],
    "DASH-v2": [
        ("AI 심사 마스터", "CSPD001TM", "긴급 카드·ToDo 건수"),
        ("업무별 사용자 역할", "CSPD120TI", "숏컷 필터"),
    ],
    "GLOBAL": [],
    "1010": [
        ("AI 심사 마스터", "CSPD001TM", "ToDo 목록 메인"),
        ("수출 원장", "CSPD201TM", "JOIN"),
        ("수입 원장", "CSPD202TM", "JOIN"),
        ("승인 및 처리 이력", "CSPD005TH", "상태·결재"),
        ("AI 심사 진행 이력", "CSPD008TH", "진행단계"),
        ("SafeWatch 탐지 결과", "CSPD007TL", "S/W 결과"),
        ("문서 및 이미지 그룹", "CSPD002TG", "저장여부"),
        ("공통코드 상세", "CSPD112TI", "업무·프로세스·액티비티"),
        ("업무별 사용자 역할", "CSPD120TI", "TO-BE S1 필터"),
        ("사용자 화면별 접근권한", "CSPD122TI", "화면 1010"),
    ],
    "1011": [
        ("AI 심사 마스터", "CSPD001TM", "상세 마스터"),
        ("문서 및 이미지 그룹", "CSPD002TG", "이미지·문서분류"),
        ("TotalText 추출 결과", "CSPD003TF", "TotalText 탭"),
        ("제재 항목 탐지 데이터", "CSPD004TF", "항목심사 탭"),
        ("승인 및 처리 이력", "CSPD005TH", "상신·승인 INSERT"),
        ("첨부파일 정보", "CSPD006TL", "첨부"),
        ("SafeWatch 탐지 결과", "CSPD007TL", "S/W 탭"),
        ("승인 Depth 규칙", "CSPD121TI", "Depth·버튼 분기"),
    ],
    "2010": [
        ("AI 심사 마스터", "CSPD001TM", "결재 ToDo"),
        ("승인 및 처리 이력", "CSPD005TH", "Depth=2"),
        ("업무별 사용자 역할", "CSPD120TI", "TO-BE S2 필터"),
        ("승인 Depth 규칙", "CSPD121TI", "Depth=2 표시"),
    ],
    "2011": [
        ("AI 심사 마스터", "CSPD001TM", "결재 상세"),
        ("문서 및 이미지 그룹", "CSPD002TG", "이미지"),
        ("TotalText 추출 결과", "CSPD003TF", "TotalText"),
        ("제재 항목 탐지 데이터", "CSPD004TF", "항목심사"),
        ("승인 및 처리 이력", "CSPD005TH", "승인"),
        ("첨부파일 정보", "CSPD006TL", "첨부"),
        ("SafeWatch 탐지 결과", "CSPD007TL", "S/W"),
        ("승인 Depth 규칙", "CSPD121TI", "btnFlag=B"),
    ],
    "3010": [
        ("AI 심사 마스터", "CSPD001TM", "QA ToDo"),
        ("QA 대상 선정 정보", "CSPD107TI", "QA Role 필터"),
        ("업무별 사용자 역할", "CSPD120TI", "QA 역할"),
    ],
    "3011": [
        ("AI 심사 마스터", "CSPD001TM", "QA 상세"),
        ("문서 및 이미지 그룹", "CSPD002TG", "이미지"),
        ("TotalText 추출 결과", "CSPD003TF", "TotalText"),
        ("제재 항목 탐지 데이터", "CSPD004TF", "항목심사"),
        ("승인 및 처리 이력", "CSPD005TH", "QA 결재"),
        ("QA 대상 선정 정보", "CSPD107TI", "QA 대상"),
    ],
    "7050": [
        ("업무(Task) 마스터", "CSPD119TI", "업무 CRUD"),
        ("업무별 사용자 역할", "CSPD120TI", "S1/S2/QA 매핑"),
        ("사용자 화면별 접근권한", "CSPD122TI", "화면별 접근"),
        ("권한·역할 변경 이력", "CSPD123TH", "이력보기 9080"),
        ("사용자 정보", "CSPD101TI", "사용자 마스터"),
    ],
    "7052": [
        ("승인 Depth 규칙", "CSPD121TI", "규칙 CRUD·시뮬레이션"),
        ("업무(Task) 마스터", "CSPD119TI", "업무 FK"),
    ],
    "7030": [
        ("메뉴 정보", "CSPD108TI", "메뉴 트리"),
        ("메뉴 권한 정보", "CSPD109TI", "권한별 메뉴"),
    ],
    "7040": [
        ("WatchList 카테고리", "CSPD102TI", "카테고리"),
        ("WatchList 목록", "CSPD103TI", "목록"),
        ("WatchList 응답 텍스트", "CSPD104TI", "응답"),
    ],
    "7050-RULE": [
        ("제재 룰 1단계", "CSPD105TI", "1단계"),
        ("제재 룰 2단계", "CSPD106TI", "2단계"),
        ("제재 룰 설정", "CSPD116TI", "설정"),
        ("제재 SQL 룰", "CSPD113TI", "SQL"),
    ],
    "7021": [("로그인 이력", "CSPD810TH", "조회")],
    "7022": [("프로그램 사용 이력", "CSPD811TH", "조회")],
    "8010": [("국가 코드 정보", "CSPD115TI", "CRUD")],
    "8020": [("공통코드 그룹", "CSPD111TI", "마스터"), ("공통코드 상세", "CSPD112TI", "상세")],
    "8030": [("영업일 및 휴일 정보", "CSPD118TM", "CRUD")],
    "8040": [("도시 및 항구 정보", "CSPD118TI", "CRUD")],
    "8060": [("AI 심사용어 사전", "CSPD117TI", "CRUD")],
    "8050": [("AI 심사 마스터", "CSPD001TM", "진행현황"), ("재처리 상태 정보", "CSPD900TI", "재처리")],
    "8051": [("재처리 상태 정보", "CSPD900TI", "INSERT")],
    "9080": [
        ("AI 심사 진행 이력", "CSPD008TH", "타임라인"),
        ("승인 및 처리 이력", "CSPD005TH", "결재 이력"),
    ],
    "9090": [("AI 심사 진행 이력", "CSPD008TH", "QA 이력")],
    "BUNDLE": [("승인 의견 메모", "CSPD110TI", "일괄 의견"), ("AI 심사 마스터", "CSPD001TM", "대상 건")],
    "7090": [("승인 의견 메모", "CSPD110TI", "CRUD")],
}

# URL 경로별 기본 테이블
URL_TABLE_RULES: list[tuple[str, list[str], str]] = [
    ("/revert/todo", T_CASE_CORE + ["CSPD007TL", "CSPD002TG"] + T_CODE, "심사 ToDo"),
    ("/revert/status", T_CASE_CORE + T_CODE, "진행상태"),
    ("/revert/ungenerated", ["CSPD011TL", "CSPD001TM"], "미생성"),
    ("/revert/detail", T_DETAIL, "심사상세"),
    ("/revert/stat/", ["CSPD001TM", "CSPD009TA", "CSPD010TA", "CSPD011TL"], "현황명세"),
    ("/app/todo", T_CASE_CORE + ["CSPD110TI"], "결재 ToDo"),
    ("/app/status", T_CASE_CORE, "결재 진행"),
    ("/app/detail", T_DETAIL, "결재 상세"),
    ("/qa/todo", ["CSPD001TM", "CSPD107TI"] + T_CODE, "QA ToDo"),
    ("/qa/status", ["CSPD001TM", "CSPD107TI"], "QA 진행"),
    ("/qa/detail", T_DETAIL + ["CSPD107TI"], "QA 상세"),
    ("/task/log/", ["CSPD009TA", "CSPD010TA"], "업무일지"),
    ("/stat/", ["CSPD001TM", "CSPD004TF", "CSPD009TA", "CSPD010TA"], "통계"),
    ("/admin/user", ["CSPD101TI", "CSPD120TI", "CSPD122TI"], "사용자관리"),
    ("/admin/menu", ["CSPD108TI", "CSPD109TI"], "메뉴관리"),
    ("/admin/watchlist", ["CSPD102TI", "CSPD103TI", "CSPD104TI"], "WatchList"),
    ("/admin/sanction", ["CSPD105TI", "CSPD106TI", "CSPD116TI", "CSPD113TI"], "제재Rule"),
    ("/admin/taskAuth", ["CSPD119TI", "CSPD120TI", "CSPD122TI", "CSPD123TH"], "업무별권한"),
    ("/admin/approvDepth", ["CSPD121TI", "CSPD119TI"], "승인규칙"),
    ("/admin/absence", ["CSPD101TI"], "부재관리"),
    ("/admin/reTask", ["CSPD001TM", "CSPD120TI"], "업무재할당"),
    ("/admin/qa/target", ["CSPD107TI", "CSPD001TM"], "QA선정"),
    ("/admin/branch", ["CSPD101TI"], "부점정보"),
    ("/admin/aiMonitor", ["CSPD001TM", "CSPD011TL"], "AI모니터링"),
    ("/common/manual", [], "매뉴얼"),
    ("/common/history", T_DETAIL, "이력상세"),
    ("/common/revert/history", ["CSPD008TH", "CSPD005TH"], "심사이력"),
    ("/common/qa/history", ["CSPD008TH"], "QA이력"),
    ("/dashboard", ["CSPD001TM"], "대시보드"),
    ("/login", ["CSPD101TI", "CSPD810TH"], "로그인"),
    ("/index", ["CSPD108TI", "CSPD109TI", "CSPD122TI"], "메인셸"),
]

DOMAIN_DEFAULT: dict[str, list[str]] = {
    "01_심사": T_CASE_CORE + T_CODE,
    "02_결재": T_CASE_CORE + ["CSPD121TI"],
    "03_QA": ["CSPD001TM", "CSPD107TI", "CSPD004TF"],
    "04_현황명세": ["CSPD001TM", "CSPD009TA", "CSPD010TA"],
    "05_업무일지": ["CSPD009TA", "CSPD010TA"],
    "06_통계": ["CSPD001TM", "CSPD004TF", "CSPD009TA"],
    "07_관리자": T_AUTH + T_CODE,
    "08_관리자시스템": T_CODE,
    "09_공통": ["CSPD005TH", "CSPD008TH"],
    "00_공통": T_AUTH,
}


def _logical(physical: str) -> str:
    return TABLE_CATALOG.get(physical, physical)


def _row(physical: str, usage: str = "") -> tuple[str, str, str]:
    return (_logical(physical), physical, usage)


def _dedupe_rows(rows: list[tuple[str, str, str]]) -> list[tuple[str, str, str]]:
    seen: set[str] = set()
    out: list[tuple[str, str, str]] = []
    for row in rows:
        key = row[1]
        if key in seen:
            continue
        seen.add(key)
        out.append(row)
    return out


def tables_from_mapper(mapper: str) -> list[str]:
    if not mapper or mapper == "—" or mapper.startswith("*"):
        return []
    base = mapper.replace("Mapper", "").replace("ServiceImpl", "").replace("Service", "")
    candidates = [
        MAPPER_DIR / f"{base}_SQL.xml",
        MAPPER_DIR / f"{mapper}_SQL.xml",
        MAPPER_DIR / f"Common{base}_SQL.xml",
    ]
    found: list[str] = []
    for path in candidates:
        if not path.exists():
            continue
        text = path.read_text(encoding="utf-8", errors="ignore")
        for m in re.findall(r"CSPD\d{3}[A-Z]{2}", text):
            if m not in found:
                found.append(m)
        if found:
            break
    return found


def tables_from_url(url: str) -> list[tuple[str, str, str]]:
    if not url or url in ("—", "모달", "팝업"):
        return []
    path = url.split()[-1] if " " in url else url
    rows: list[tuple[str, str, str]] = []
    for pattern, physicals, usage in URL_TABLE_RULES:
        if pattern in path or path.startswith(pattern.strip("/")):
            for p in physicals:
                rows.append(_row(p, usage))
    return rows


def build_screen_tables(
    sid: str,
    screen: tuple,
    detail: dict[str, Any],
    backend: dict[str, str] | None = None,
) -> list[tuple[str, str, str]]:
    """화면별 관련 테이블 — (논리명, 물리명, 용도)."""
    _name, domain, url, pattern, status, jsp, api, *_rest = screen[1:]

    if sid in SCREEN_TABLES:
        return list(SCREEN_TABLES[sid])

    rows: list[tuple[str, str, str]] = []

    rows.extend(tables_from_url(url))

    for physical in DOMAIN_DEFAULT.get(domain, []):
        rows.append(_row(physical, domain))

    if backend:
        mapper = backend.get("mapper", "")
        for physical in tables_from_mapper(str(mapper)):
            rows.append(_row(physical, "Mapper SQL"))

    # 목록·상세 공통
    if pattern == "C" and "CSPD112TI" not in {r[1] for r in rows}:
        rows.append(_row("CSPD112TI", "공통코드(검색·표시)"))
    if pattern in ("C", "D", "E") and status in ("v2", "변경", "신규"):
        for p in ("CSPD120TI", "CSPD122TI"):
            if p not in {r[1] for r in rows}:
                rows.append(_row(p, "TO-BE 권한"))
    if pattern == "C":
        rows.append(_row("CSPD811TH", "프로그램 사용이력"))
    if pattern == "D":
        for p in T_DETAIL:
            if p not in {r[1] for r in rows}:
                rows.append(_row(p, "상세"))

    if not rows:
        rows = [_row("CSPD001TM", "도메인 기본 — Mapper XML 확인")]

    return _dedupe_rows(rows)
