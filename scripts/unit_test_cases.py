# -*- coding: utf-8 -*-
"""화면설계 데이터 기반 단위 테스트 케이스 생성."""
from __future__ import annotations

import re
from typing import Any

from screen_design_dev_data import BACKEND_MAP, PATTERN_IMPL
from screen_design_enrich import PATTERN_EVENTS

# 공통 메시지·권한 검증 케이스
COMMON_AUTH_CASES: list[tuple[str, str, str, str, str, str, str, str]] = [
    (
        "TC-COMMON-AUTH-001",
        "권한",
        "AuthenticationInterceptor",
        "screenAccess 없는 화면 URL 진입",
        "로그인 세션 존재, screenAccess 미등록",
        "GET /{url}",
        "MSG-AUTH-001, 403 또는 로그인 리다이렉트",
        "P0",
    ),
    (
        "TC-COMMON-AUTH-002",
        "권한",
        "AuthenticationInterceptor",
        "세션 만료 후 API 호출",
        "세션 타임아웃",
        "GET /api/...",
        "MSG-SESSION-001",
        "P0",
    ),
    (
        "TC-COMMON-AUTH-003",
        "권한",
        "TaskAuthService",
        "S1·S2 동시 역할 부여",
        "7050 역할 저장",
        "동일 업무 S1+S2",
        "MSG-SOD-001 예외",
        "P0",
    ),
    (
        "TC-COMMON-AUTH-004",
        "권한",
        "AppDetailService",
        "본인 처리 건 결재 시도",
        "2011 상세, AI_INSPE_ENO=loginUser",
        "POST approve",
        "MSG-SOD-002 예외",
        "P0",
    ),
]

COMMON_MSG_CASES: list[tuple[str, str, str, str, str, str, str, str]] = [
    (
        "TC-COMMON-MSG-001",
        "유효성",
        "CommonExceptionHandler",
        "세션 만료 JSON 응답",
        "세션 없음",
        "API 호출",
        "MSG-SESSION-001 + T4xx",
        "P0",
    ),
    (
        "TC-COMMON-MSG-002",
        "유효성",
        "DepthRuleEngine",
        "단독결재 최종승인 안내",
        "depth=1, 1011",
        "santionApprv 호출 전",
        "MSG-DEPTH-001 confirm",
        "P1",
    ),
]

LAYER_BY_PATTERN: dict[str, list[str]] = {
    "C": ["ApiController", "Service", "Mapper"],
    "D": ["ApiController", "Service", "Mapper"],
    "E": ["ApiController", "Service", "Mapper"],
    "A": ["Controller", "Service"],
    "B": ["ApiController", "Service"],
    "F": ["ApiController", "Service", "Mapper"],
    "G": ["ApiController", "Service"],
    "H": ["ApiController", "Service", "Mapper"],
    "단독": ["Controller", "Service"],
    "전역": ["ApiController", "Service"],
    "차트": ["ApiController", "Service", "Mapper"],
}


def _slug(text: str) -> str:
    return re.sub(r"[^a-zA-Z0-9_]", "_", text)[:40].strip("_").lower()


def _parse_api_specs(api_field: str, detail: dict[str, Any]) -> list[tuple[str, str, str, str, str]]:
    specs: list[tuple[str, str, str, str, str]] = list(detail.get("api_specs") or [])
    for part in api_field.split(";"):
        part = part.strip()
        if not part or part == "—":
            continue
        if part.startswith(("GET ", "POST ", "PUT ", "DELETE ")):
            method, _, path = part.partition(" ")
            if not any(s[0] == path.strip() for s in specs):
                specs.append((path.strip(), method, "—", "—", "T200"))
        elif not any(s[0] == part for s in specs):
            specs.append((part, "GET", "—", "—", "T200"))
    return specs


def _backend_info(sid: str, url: str, jsp: str, detail: dict[str, Any]) -> dict[str, str]:
    be = BACKEND_MAP.get(sid)
    if be:
        return dict(be)
    raw = detail.get("backend")
    if isinstance(raw, dict):
        return {k: str(v) for k, v in raw.items()}
    from generate_screen_design_excel import infer_backend

    return infer_backend(url, jsp)


def _test_class_name(backend: dict[str, str], layer: str) -> str:
    if layer == "ApiController":
        name = backend.get("api", "*ApiController").split(",")[0].strip()
        if "(신규)" in name:
            name = name.replace("(신규)", "").strip()
        return f"{name}Test" if name.endswith("Controller") else f"{name}ApiControllerTest"
    if layer == "Controller":
        name = backend.get("controller", "*Controller").split(",")[0].strip()
        return f"{name}Test"
    if layer == "Service":
        name = backend.get("service", "*Service").split("/")[0].strip()
        if "(신규)" in name:
            name = name.replace("(신규)", "").strip()
        return f"{name}Test"
    if layer == "Mapper":
        name = backend.get("mapper", "*Mapper")
        return f"{name}Test"
    return f"*Test"


def _api_test_rows(sid: str, specs: list[tuple], backend: dict[str, str]) -> list[tuple]:
    rows: list[tuple] = []
    api_class = _test_class_name(backend, "ApiController")
    for i, spec in enumerate(specs, 1):
        path, method, req, resp, note = spec
        method_slug = _slug(path.replace("/", "_"))
        rows.append(
            (
                f"TC-{sid}-API-{i:02d}-OK",
                "API",
                api_class,
                f"{method} {path} — 정상 응답",
                "유효 세션·권한, 정상 파라미터",
                req or "SearchVO 기본값",
                resp or "T200 + resultList",
                "P0",
            )
        )
        rows.append(
            (
                f"TC-{sid}-API-{i:02d}-AUTH",
                "API",
                api_class,
                f"{method} {path} — 권한 없음",
                "screenAccess 또는 Task-Role 미충족",
                req or "—",
                "MSG-AUTH-001 또는 빈 resultList",
                "P0",
            )
        )
        if "pageIndex" in (req or "") or "GET" in method:
            rows.append(
                (
                    f"TC-{sid}-API-{i:02d}-PAGE",
                    "API",
                    api_class,
                    f"{method} {path} — 페이징",
                    "pageIndex=2, recordCountPerPage 설정",
                    "pageIndex=2",
                    "paginationInfo.totalRecordCount ≥ 0",
                    "P1",
                )
            )
        if "POST" in method:
            rows.append(
                (
                    f"TC-{sid}-API-{i:02d}-VAL",
                    "API",
                    api_class,
                    f"{method} {path} — 필수값 누락",
                    "필수 파라미터 null/empty",
                    "필수 필드 제거",
                    "validation 오류 또는 T4xx",
                    "P1",
                )
            )
        if note and note not in ("T200", "—", ""):
            rows.append(
                (
                    f"TC-{sid}-API-{i:02d}-NOTE",
                    "API",
                    api_class,
                    f"{method} {path} — 도메인 규칙 ({note})",
                    note,
                    req or "—",
                    f"비즈니스 규칙 준수 ({note})",
                    "P1",
                )
            )
    return rows


def _service_test_rows(sid: str, pattern: str, detail: dict[str, Any], backend: dict[str, str]) -> list[tuple]:
    rows: list[tuple] = []
    svc_class = _test_class_name(backend, "Service")
    auth = detail.get("auth", "")
    validation = detail.get("validation", "")

    if auth and auth != "—":
        rows.append(
            (
                f"TC-{sid}-SVC-01-AUTH",
                "Service",
                svc_class,
                "접근권한·역할 필터 검증",
                "테스트 사용자·Task-Role fixture",
                auth[:80],
                "허용 건만 반환 / 미허용 시 예외",
                "P0",
            )
        )

    if validation and validation != "—":
        rows.append(
            (
                f"TC-{sid}-SVC-02-VAL",
                "Service",
                svc_class,
                "도메인 유효성 검증",
                "경계값·필수값 fixture",
                validation[:80],
                "예상 메시지 코드 또는 rollback",
                "P1",
            )
        )

    for i, change in enumerate(detail.get("tobe_changes") or [], 1):
        rows.append(
            (
                f"TC-{sid}-SVC-TOBE-{i:02d}",
                "Service",
                svc_class,
                f"TO-BE 변경 — {change[:40]}",
                "TO-BE fixture (CSPD120TI/121TI 등)",
                change[:60],
                "변경 사양 충족",
                "P0" if "신규" in change or "Mapper" in change else "P1",
            )
        )

    if pattern in ("C", "D", "E") and not any(r[0].endswith("LIST") for r in rows):
        rows.append(
            (
                f"TC-{sid}-SVC-03-LIST",
                "Service",
                svc_class,
                "selectList / selectListTotCnt",
                "SearchVO + userId",
                "업무·기간 조건",
                "resultList 건수 = totalCnt",
                "P1",
            )
        )

    if pattern == "D":
        rows.append(
            (
                f"TC-{sid}-SVC-04-SOD",
                "Service",
                svc_class,
                "SoD — 본인 배정·결재 분리",
                "S1≠S2 fixture",
                "approve/save 분기",
                "MSG-SOD-002 when violated",
                "P0",
            )
        )

    if pattern == "E":
        rows.append(
            (
                f"TC-{sid}-SVC-05-TXN",
                "Service",
                svc_class,
                "저장 트랜잭션 롤백",
                "마스터+디테일 동시 저장",
                "디테일 validation 실패",
                "전체 rollback",
                "P1",
            )
        )

    return rows


def _mapper_test_rows(sid: str, backend: dict[str, str], detail: dict[str, Any]) -> list[tuple]:
    if not backend.get("mapper") or backend.get("mapper") == "—":
        return []
    mapper_class = _test_class_name(backend, "Mapper")
    sql = backend.get("sql", "—")
    tables = detail.get("tables") or []
    table_hint = tables[0][1] if tables else "CSPD*"
    return [
        (
            f"TC-{sid}-MAP-01",
            "Mapper",
            mapper_class,
            "selectList SQL 실행",
            "HSQLDB 또는 @Sql 테스트 데이터",
            f"SearchVO, JOIN {table_hint}",
            "resultMap ↔ VO 필드 매핑",
            "P1",
        ),
        (
            f"TC-{sid}-MAP-02",
            "Mapper",
            mapper_class,
            "selectListTotCnt 일치",
            "동일 SearchVO",
            sql[:60] if sql != "—" else "—",
            "count = list.size (동일 조건)",
            "P2",
        ),
    ]


def _controller_test_rows(sid: str, url: str, backend: dict[str, str]) -> list[tuple]:
    if not backend.get("controller") or backend.get("controller") in ("—", ""):
        return []
    ctrl = _test_class_name(backend, "Controller")
    return [
        (
            f"TC-{sid}-CTRL-01",
            "Controller",
            ctrl,
            "View 매핑 — JSP 반환",
            "MockMvc + 세션",
            f"GET {url}",
            "200 + view name + Model 속성",
            "P1",
        ),
    ]


def _search_validation_rows(sid: str, detail: dict[str, Any]) -> list[tuple]:
    rows: list[tuple] = []
    for i, field in enumerate(detail.get("search") or [], 1):
        if len(field) < 4:
            continue
        label, param, ftype, required = field[0], field[1], field[2], field[3]
        if required == "Y":
            rows.append(
                (
                    f"TC-{sid}-VAL-SRCH-{i:02d}",
                    "유효성",
                    "SearchVO / BeanValidator",
                    f"검색 필수값 — {label}",
                    "조회 요청",
                    f"{param}=empty",
                    "validation 오류",
                    "P2",
                )
            )
        if ftype == "text" and "번호" in label:
            rows.append(
                (
                    f"TC-{sid}-VAL-SRCH-{i:02d}-FMT",
                    "유효성",
                    "SearchVO",
                    f"검색 형식 — {label}",
                    "숫자 필드",
                    f"{param}=abc",
                    "타입 변환 오류 또는 무시",
                    "P2",
                )
            )
    return rows


def _event_integration_rows(sid: str, pattern: str, detail: dict[str, Any]) -> list[tuple]:
    """프론트·통합 테스트 — 단위 테스트 문서에 참고 케이스로 포함."""
    events = detail.get("events") or PATTERN_EVENTS.get(pattern, [])
    rows: list[tuple] = []
    for i, ev in enumerate(events[:8], 1):
        trigger, action, note = ev[0], ev[1], ev[2] if len(ev) > 2 else ""
        if trigger == "—":
            continue
        rows.append(
            (
                f"TC-{sid}-ITG-{i:02d}",
                "통합(참고)",
                "JSP/JS 또는 MockMvc",
                f"이벤트 — {trigger}",
                "화면 로드·세션",
                action[:60],
                note[:60] if note else "설계서 §이벤트 정합",
                "P2",
            )
        )
    return rows


def build_screen_test_cases(
    sid: str,
    screen: tuple,
    detail: dict[str, Any],
) -> list[tuple[str, str, str, str, str, str, str, str]]:
    """8-tuple: TC_ID, 유형, 대상, 시나리오, 전제, 입력, 기대, 우선순위."""
    _name, _domain, url, pattern, status, jsp, api, *_rest = screen[1:]
    backend = _backend_info(sid, url, jsp, detail)
    specs = _parse_api_specs(api, detail)

    rows: list[tuple] = []
    rows.extend(_controller_test_rows(sid, url, backend))
    rows.extend(_api_test_rows(sid, specs, backend))
    rows.extend(_service_test_rows(sid, pattern, detail, backend))
    rows.extend(_mapper_test_rows(sid, backend, detail))
    rows.extend(_search_validation_rows(sid, detail))
    rows.extend(_event_integration_rows(sid, pattern, detail))

    if status == "신규":
        rows.insert(
            0,
            (
                f"TC-{sid}-NEW-01",
                "신규",
                "전체 스택",
                "신규 화면 스캐폴딩 테스트",
                "Controller/Service/Mapper/JSP 생성 완료",
                "기본 조회 1건",
                "빌드·기동·API 200",
                "P0",
            ),
        )

    # 중복 TC_ID 제거
    seen: set[str] = set()
    unique: list[tuple] = []
    for row in rows:
        if row[0] in seen:
            continue
        seen.add(row[0])
        unique.append(row)
    return unique


def test_summary(cases: list[tuple]) -> dict[str, int]:
    summary: dict[str, int] = {}
    for row in cases:
        kind = row[1]
        summary[kind] = summary.get(kind, 0) + 1
    return summary


def suggested_test_packages(sid: str, backend: dict[str, str]) -> list[tuple[str, str]]:
    base = "src/test/java/com/woori/ajs"
    rows = []
    if backend.get("api"):
        cls = backend["api"].split(",")[0].strip().replace("(신규)", "").strip()
        rows.append((f"{cls}Test", f"{base}/api/{cls}Test.java"))
    if backend.get("service"):
        cls = backend["service"].split("/")[0].strip().replace("(신규)", "").strip()
        rows.append((f"{cls}Test", f"{base}/service/{cls}Test.java"))
    if backend.get("mapper") and backend["mapper"] != "—":
        cls = backend["mapper"]
        rows.append((f"{cls}Test", f"{base}/mapper/{cls}Test.java"))
    if not rows:
        rows.append((f"Screen{sid}Test", f"{base}/screen/Screen{sid}Test.java"))
    return rows
