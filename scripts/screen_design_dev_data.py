# -*- coding: utf-8 -*-
"""화면설계서 — 개발자 구현용 상세 데이터."""
from __future__ import annotations

from typing import Any

# 패턴별 구현 가이드 (화면 DETAIL 미정의 시 기본값)
PATTERN_IMPL: dict[str, dict[str, Any]] = {
    "C": {
        "layout": """```
┌─ [화면ID] 화면명 ─────────────────────────────────────────┐
│ breadcrumb                                                │
├───────────────────────────────────────────────────────────┤
│ [검색] wf-search-v2  필드…          [초기화] [조회]       │
├───────────────────────────────────────────────────────────┤
│ DataTables (wf-table-v2) — 페이징·정렬·체크박스           │
└───────────────────────────────────────────────────────────┘
```""",
        "frontend": [
            ("JSP", "`WEB-INF/jsp/{path}/list.jsp`", "blank/ 뷰 — iframe 탭 내 로드"),
            ("공통 include", "`datatable.jsp` + `/common/grid`", "DataTables 초기화"),
            ("JS 패턴", "`{dataTableId}Config`", "ajaxUrl, columns, getSearchOption"),
            ("상세 진입", "`fnFullWin(form)`", "hidden form POST → 팝업"),
            ("v2 CSS", "wf-search-v2, wf-table-v2", "목록 검색·그리드 스타일"),
        ],
        "backend": [
            ("View Controller", "`@RequestMapping` URL → ModelAndView", "공통코드·초기데이터 set"),
            ("API Controller", "`@GetMapping` /api/... → HashMap", "SearchVO + PaginationInfo"),
            ("Service", "`selectList`, `selectListTotCnt`", "권한·업무 필터는 Service/Mapper"),
            ("Mapper/XML", "`egovframework/sqlmap/ui/mappers/*_SQL.xml`", "MyBatis"),
        ],
        "checklist": [
            "View Controller URL·JSP 경로 매핑",
            "검색 파라미터 ↔ SearchVO 필드 바인딩",
            "DataTables columns data 필드 ↔ API resultList 키 일치",
            "클릭/더블클릭 column index와 JSP 이벤트 핸들러 정합",
            "AuthenticationInterceptor screenAccess + Task-Role (TO-BE)",
            "프로그램 사용이력 fnCmnProgramLog 호출",
        ],
    },
    "D": {
        "layout": """```
┌─ 심사/결재 상세 [×] ──────────────────────────────────────┐
│ Ref.No │ 업무 │ Depth뱃지 │ 긴급                          │
├────────┬──────────────────────┬───────────────────────────┤
│문서분류│   이미지 뷰어        │ [항목심사][TotalText][전달] │
│ 트리   │   Canvas+핀          │ 탭 패널                     │
├────────┴──────────────────────┴───────────────────────────┤
│ [임시저장] [결재상신|최종승인] [재스캔][재추출][B/L수정]   │
└───────────────────────────────────────────────────────────┘
```""",
        "frontend": [
            ("JSP", "`detail.jsp`", "fullLayout 팝업, btnFlag 분기"),
            ("로드", "`POST /api/common/detail/load`", "마스터·항목·이미지 메타"),
            ("버튼", "depth·btnFlag별 show/hide", "1011=A, 2011=B"),
            ("이미지", "Canvas + annotation-store.js", "좌표 하이라이트"),
        ],
        "backend": [
            ("View", "`POST /revert/detail` 등", "hidden 파라미터: inptMstSrno, inptAtvtCd"),
            ("API", "CommonDetailApiController", "load / save / apprv"),
            ("SoD", "Service 레이어", "본인배정·S1≠S2 검증"),
        ],
        "checklist": [
            "진입 파라미터(inptMstSrno, inptAtvtCd, actlFxRefno) 검증",
            "btnFlag·Depth에 따른 버튼 노출",
            "저장/상신/승인 API 분기 및 확인 다이얼로그",
            "TA 연동(임시저장 후 비동기 결과 반영)",
            "닫기 시 부모 tableReload() 호출",
        ],
    },
    "E": {
        "layout": """```
┌─ Master(좌) ────┬─ Detail(우) ───────────────────────────┐
│ 목록/트리       │ 폼·탭·하위 그리드                        │
│ [검색]          │ [저장] [삭제] [취소]                     │
└─────────────────┴─────────────────────────────────────────┘
```""",
        "frontend": [
            ("CSS", "wf-master-detail, wf-layer-tab", "좌우 분할·탭"),
            ("JS", "마스터 선택 → 상세 AJAX 로드", "선택 행 하이라이트"),
        ],
        "backend": [
            ("API", "GET 목록 + GET 상세 + POST 저장", "트랜잭션 단위 저장"),
        ],
        "checklist": [
            "마스터-디테일 선택 상태 관리",
            "탭별 독립 validation",
            "저장 전 SoD·필수값 검증",
            "감사 로그(123TH 등) 기록",
        ],
    },
    "A": {
        "layout": "GNB + LNB + TabBar + iframe(wf-view-container). SSE 단일 연결.",
        "frontend": [
            ("JSP", "layout/layout.jsp", "메인 셸"),
            ("JS", "shell-v2.js, notify-client.js", "탭·postMessage·SSE"),
        ],
        "checklist": ["탭 open/close", "iframe URL 라우팅", "SSE postMessage 분배"],
    },
    "B": {
        "layout": "긴급 카드 + 숏컷 카드 + (v2: 차트 제거)",
        "frontend": [("JS", "dashboard API POST", "SSE DASHBOARD_REFRESH")],
        "checklist": ["긴급 카드 → 1011", "숏컷 → 1010/2010 탭"],
    },
    "G": {
        "layout": "모달 오버레이 — 부모 화면 위 팝업",
        "frontend": [("JSP", "소형 팝업 JSP", "layer popup 또는 window.open")],
        "checklist": ["부모 콜백(목록 reload)", "필수값 validation"],
    },
    "H": {
        "layout": "좌: 이력 타임라인 / 우: 상세·첨부",
        "frontend": [("JS", "타임라인 클릭 → 상세 로드", "")],
        "checklist": ["이력 단계별 표시", "읽기전용"],
    },
    "F": {
        "layout": "단일 폼 + 저장/삭제 버튼",
        "checklist": ["폼 validation", "저장 후 confirm"],
    },
    "단독": {"layout": "로그인 단독 페이지 (셸 없음)"},
    "전역": {"layout": "layout.jsp 내 전역 컴포넌트"},
    "차트": {"layout": "검색 + Chart.js 차트 + (선택) 목록"},
}

# 화면별 백엔드 명시 (AS-IS 코드 기준). 없으면 URL 추론.
BACKEND_MAP: dict[str, dict[str, str]] = {
    "1010": {
        "controller": "RevertTodoController",
        "api": "RevertTodoApiController",
        "service": "RevertTodoService / RevertTodoServiceImpl",
        "mapper": "RevertTodoMapper",
        "sql": "egovframework/sqlmap/ui/mappers/RevertTodo_SQL.xml",
        "vo": "ReverTodoVO, SearchVO",
    },
    "2010": {
        "controller": "AppTodoController",
        "api": "AppTodoApiController",
        "service": "AppTodoService",
        "mapper": "AppTodoMapper",
        "sql": "egovframework/sqlmap/ui/mappers/AppTodo_SQL.xml",
        "vo": "AppTodoVO, SearchVO",
    },
    "1011": {
        "controller": "RevertDetailController",
        "api": "CommonDetailApiController, RevertDetailApiController",
        "service": "RevertDetailService, CommonDetailService",
        "mapper": "RevertDetailMapper",
        "sql": "RevertDetail_SQL.xml 등",
        "vo": "DetailVO 계열",
    },
    "7050": {
        "controller": "AdminTaskAuthController (신규)",
        "api": "AdminTaskAuthApiController (신규)",
        "service": "TaskAuthService (신규)",
        "mapper": "TaskAuthMapper → CSPD120TI, CSPD122TI",
        "sql": "TaskAuth_SQL.xml (신규)",
        "vo": "TaskRoleVO, ScreenAccessVO",
    },
    "7052": {
        "controller": "AdminApprovDepthController (신규)",
        "api": "AdminApprovDepthApiController (신규)",
        "service": "ApprovDepthRuleService (신규)",
        "mapper": "ApprovDepthMapper → CSPD121TI",
        "sql": "ApprovDepth_SQL.xml (신규)",
        "vo": "ApprovDepthRuleVO",
    },
    "GLOBAL": {
        "api": "NotifyApiController (신규)",
        "service": "NotifyService, SseEmitter 관리",
        "mapper": "—",
        "sql": "—",
        "vo": "NotifyEventVO",
    },
    "MAIN": {
        "controller": "MainController / IndexController",
        "jsp": "layout/layout.jsp",
    },
}

# 기존 DETAIL + 개발 확장 (generate_screen_design_excel.DETAIL 대체)
DETAIL: dict[str, dict[str, Any]] = {
    "LOGIN": {
        "purpose": "직원 인증 후 세션 생성. TO-BE: taskRoles·screenAccess 세션 적재.",
        "layout": """```
┌─────────────────────────────────────┐
│        우리은행 AI Sanction         │
│  Username [____________]            │
│  Password [____________]            │
│       [ 로그인 ]  [ SSO 로그인 ]    │
└─────────────────────────────────────┘
```""",
        "fields": [
            ("Username", "text", "Y", "LoginVO.userId / 직원번호"),
            ("Password", "password", "Y", "LoginVO.password"),
            ("SSO", "button", "N", "POST /sso/prx"),
        ],
        "events": [
            ("Login 클릭", "beanValidator → 세션 생성", "성공 시 /index"),
            ("SSO", "포털 프록시 인증", "/sso/prx"),
            ("성공", "taskRoles, screenAccess 적재", "TO-BE Session"),
        ],
        "backend": {"controller": "LoginController", "api": "—", "service": "LoginService"},
        "frontend": {"jsp": "login/login.jsp", "js": "로그인 폼 submit", "css": "login-v2"},
        "api_specs": [
            ("POST /login", "POST", "userId, password", "{redirect: /index}", "MSG-SESSION-*"),
        ],
        "checklist": ["SSO 연동", "세션 타임아웃", "TO-BE 권한 세션 적재", "로그인 이력"],
    },
    "MAIN": {
        "purpose": "HYUNA v2 앱 셸. GNB·LNB·탭·iframe·SSE 단일 연결.",
        "layout": """```
┌─ GNB ─────────────────────────────────────────────────────┐
├─ LNB ─┬─ TabBar [화면1] [화면2 ×] ─────────────────────────┤
│ 배지  │ ┌─ iframe (wf-view-container) ───────────────────┐  │
│ 위젯  │ │ 활성 화면 JSP 로드                              │  │
│       │ └────────────────────────────────────────────────┘  │
└───────┴───────────────────────────────────────────────────┘
```""",
        "events": [
            ("메뉴 클릭", "탭 오픈 + iframe src", "screenAccess 필터"),
            ("탭 닫기", "iframe destroy", ""),
            ("SSE 연결", "GET /api/notify/stream", "layout.jsp 1회"),
            ("postMessage", "TODO_UPDATE 등", "활성 iframe"),
        ],
        "frontend": {
            "jsp": "layout/layout.jsp",
            "js": "resources/js/shell-v2.js, notify-client.js",
            "css": "wf-shell, wf-gnb, wf-lnb",
        },
        "checklist": ["탭 중복 방지", "SSE 재연결", "LNB 배지 ASIDE_REFRESH", "iframe 높이"],
    },
    "1010": {
        "purpose": "심사자(S1)에게 배정된 수기입력·심사검토 대상 조회 → 심사상세(1011) 진입.",
        "layout": """```
┌─ 본인작업 ToDoList [1010] ────────────────────────────────┐
│ 심사 > 본인작업 ToDoList                                   │
├───────────────────────────────────────────────────────────┤
│ 업무[▼] Ref.No[___] 고객번호[___] 마스터번호[___] [조회]  │
├───────────────────────────────────────────────────────────┤
│ □│No│우선│생성일│업무│Ref.No│저장│프로세스│액티비티│…│Depth│
│ ■│1 │P0  │01/27 │수출│FX-…  │ Y  │심사   │1차심사 │…│ 1  │ ← highlight
└───────────────────────────────────────────────────────────┘
```""",
        "search": [
            ("업무", "inptAtmcBizDscd", "select", "N", "공통코드 grp=150, id=cbo_inptAtmcBizDscd_Search_1010"),
            ("Ref.No", "actlFxRefno", "text", "N", "maxLength_refno"),
            ("고객번호", "aiInptCsno", "text", "N", "id=txt_aiInptCusNo_Search_1010"),
            ("마스터번호", "inptMstSrno", "text", "N", "Number 변환 후 전송"),
        ],
        "columns": [
            ("생성일", "inptRcpDt", "DESC", "dataFormat()"),
            ("업무", "inptAtmcBizDsNm", "—", ""),
            ("Ref.No", "actlFxRefno", "—", "dblclick col=3 → 9080"),
            ("저장", "save", "—", ""),
            ("주의", "wrrInfo", "—", ""),
            ("프로세스", "inptPrcsNm", "—", "click col=6 → 1011"),
            ("액티비티", "inptAtvtNm", "—", "click col=7 → 1011"),
            ("고객번호", "aiInptCsno", "—", ""),
            ("고객명", "aiInptCusNm", "—", ""),
            ("통화", "fcCuNm", "—", ""),
            ("금액", "aiInptBuyAm", "—", "fnNumberCommaFormat"),
            ("TotalText", "totaltextAiInptRstNm", "—", "30=red, 40=green"),
            ("항목심사", "itmInptAiInptRstNm", "—", "색상코드 연동"),
            ("S/W", "safewatchAiInptRstNm", "—", ""),
            ("(hidden)", "inptMstSrno,inptAtvtCd,inptAtmcBizDscd", "—", "이벤트용"),
            ("Depth", "aiInptApprovDepth", "—", "TO-BE 신규 컬럼"),
        ],
        "buttons": [
            ("항상", "[조회]", "dataTable.searchList()"),
            ("항상", "[초기화]", "검색 폼 reset"),
        ],
        "events": [
            ("조회", "GET /api/revert/todo", "getSearchOption() 파라미터"),
            ("프로세스/액티비티 클릭", "formRevertDetail → fnFullWin", "inptMstSrno, inptAtvtCd, actlFxRefno"),
            ("Ref.No 더블클릭", "formRevertHistory → fnHistoryWin", "9080"),
            ("SSE TODO_UPDATE", "tableReload()", "부모 postMessage"),
            ("수기입력행", "rowHandwriting 클래스", "inptAtvtCd=='80'"),
            ("우선순위", "wf-row-highlight", "FR-004 P0/P1"),
        ],
        "auth": "L1: S1 Task-Role(해당 업무) + screenAccess(1010) + AI_INSPE_ENO=loginUser",
        "validation": "세션 만료 시 fnLoginAlert; 우선순위 행 wf-row-highlight",
        "api_specs": [
            (
                "GET /api/revert/todo",
                "GET",
                "inptAtmcBizDscd, actlFxRefno, aiInptCsno, inptMstSrno, schSdate1, schEdate1, pageIndex",
                "{resultList:[ReverTodoVO], paginationInfo, searchVO}",
                "T200",
            ),
        ],
        "frontend": {
            "jsp": "WEB-INF/jsp/revert/todo/list.jsp",
            "view": "blank/revert/todo/list",
            "js": "dataTable_1010Config, getSearchOption, fnRowCallback",
            "forms": "formRevertDetail(→/revert/detail), formRevertHistory(→/common/revert/history)",
            "includes": "datatable.jsp, /common/grid",
        },
        "flow": [
            "1. RevertTodoController — 공통코드(업무) 로드 → list.jsp",
            "2. DataTables 초기화 — ajaxUrl /api/revert/todo",
            "3. 사용자 조회 — SearchVO + userId(세션) → Mapper 필터",
            "4. 행 클릭 — 심사상세 팝업 POST",
            "5. 팝업 닫힘 — tableReload()",
        ],
        "tobe_changes": [
            "Mapper: Task-Role 기반 업무 필터",
            "Depth 컬럼 추가(aiInptApprovDepth)",
            "v2 UI: wf-search-v2, wf-table-v2 클래스 적용",
            "우선순위 정렬 FR-004",
        ],
        "checklist": [
            "RevertTodoApiController list() SearchVO 바인딩",
            "TO-BE selectList WHERE Task-Role + AI_INSPE_ENO",
            "column index 6,7 클릭 / 3 더블클릭 유지",
            "SSE TODO_UPDATE → tableReload",
            "fnCmnProgramLog(1010) 호출",
        ],
    },
    "1011": {
        "purpose": "TotalText·항목심사·SafeWatch 검토 및 심사 처리(임시저장/상신/최종승인).",
        "layout": """```
┌─ 심사상세 [1011] ─ Ref.No FX-… │ 수출 │ Depth 1 ─────── [×]┐
├──────────┬─────────────────────┬────────────────────────────┤
│ 문서분류 │  이미지 뷰어        │ [항목심사][TotalText/SW]   │
│ 트리     │  Canvas+핀          │ 동적 행, AI결과 30/40      │
├──────────┴─────────────────────┴────────────────────────────┤
│ [임시저장] [최종승인|결재상신] [재스캔][재추출][B/L수정]      │
└─────────────────────────────────────────────────────────────┘
```""",
        "fields": [
            ("Ref.No", "header", "—", "actlFxRefno"),
            ("Depth", "badge", "—", "1=단독, 2=교차"),
            ("btnFlag", "hidden", "Y", "A=심사자"),
            ("항목명", "grid", "Y", "동적 행 추가 FR-012"),
            ("AI결과", "badge", "—", "30/40 + 신뢰도"),
            ("심사결과", "input", "Y", "수기"),
        ],
        "buttons": [
            ("공통", "[임시저장]", "POST /api/common/revertDetail/inspection"),
            ("depth=1", "[최종승인]", "POST /api/common/revertDetail/santionApprv + MSG-DEPTH-001"),
            ("depth=2", "[결재상신]", "POST /api/common/revertDetail/santionSave"),
            ("공통", "[재스캔]", "재스캔 API"),
            ("공통", "[재추출]", "재추출 API"),
            ("공통", "[B/L수정]", "1011-BL 모달"),
        ],
        "events": [
            ("진입", "POST /revert/detail", "inptMstSrno, inptAtvtCd"),
            ("로드", "POST /api/common/detail/load", "문서·항목·이미지"),
            ("임시저장", "inspection API → TA", "비동기 결과 폴링"),
            ("최종승인", "santionApprv", "depth=1만"),
            ("결재상신", "santionSave", "depth=2만"),
            ("닫기", "window.close + opener.tableReload", ""),
        ],
        "auth": "btnFlag=A; S1 + 본인 배정(AI_INSPE_ENO); screenAccess 1011",
        "validation": "MSG-DEPTH-001; 항목 필수; SoD는 결재 단계",
        "api_specs": [
            ("POST /api/common/detail/load", "POST", "inptMstSrno, inptAtvtCd, btnFlag", "상세 JSON", ""),
            ("POST /api/common/revertDetail/inspection", "POST", "항목 배열", "TA 요청 ID", ""),
            ("POST /api/common/revertDetail/santionSave", "POST", "상신 데이터", "결재대기", ""),
            ("POST /api/common/revertDetail/santionApprv", "POST", "승인 데이터", "완료", ""),
        ],
        "frontend": {
            "jsp": "revert/detail/detail.jsp",
            "js": "detail-result-tabs.js, item-audit-v3.js, image-viewer.js",
            "wireframe": "detail-1011-v2.html, detail-1011-v4.html",
        },
        "tobe_changes": ["Depth 뱃지", "depth별 버튼 분기", "v4 문서 D&D·일괄명변경"],
    },
    "2010": {
        "purpose": "결재자(S2) 교차결재(depth=2) 대기 건 조회·일괄승인.",
        "columns": [
            ("□", "chk", "—", "다중선택"),
            ("상신일", "apprvReqDt", "DESC", ""),
            ("Ref.No", "actlFxRefno", "—", ""),
            ("업무", "inptAtmcBizDsNm", "—", ""),
            ("심사자", "aiInspEnoNm", "—", "S1"),
            ("Depth", "aiInptApprovDepth", "—", "2만 표시"),
            ("유형", "taskTypeNm", "—", ""),
            ("상태", "statusNm", "—", ""),
        ],
        "buttons": [("선택≥1", "[일괄승인]", "BUNDLE 팝업 → POST /api/app/todo/bundle")],
        "auth": "S2 Task-Role + AI_INPT_SNPE_ENO + AI_INPT_APPV_DEPTH_CD=2",
        "tobe_changes": ["Mapper WHERE depth=2", "S2 업무 필터"],
        "api_specs": [("GET /api/app/todo", "GET", "검색조건+pageIndex", "{resultList}", "")],
    },
    "2011": {
        "purpose": "결재자 심사상세 — 승인/반려/Block. SoD: S2≠S1.",
        "buttons": [
            ("—", "[승인]", "POST /api/common/appDetail/approve"),
            ("—", "[반려]", "POST /api/common/appDetail/reject"),
            ("—", "[Block]", "POST block API"),
        ],
        "auth": "btnFlag=B; S2; AI_INSPE_ENO ≠ loginUser (MSG-SOD-002)",
        "validation": "MSG-SOD-002 본인 처리 건 결재 불가",
    },
    "7050": {
        "purpose": "사용자별 업무 역할(S1/S2/QA) 및 화면별 접근 예외 관리.",
        "layout": """```
┌─ 업무별 권한 [7050] ──────────────────────────────────────┐
│ 권한[▼] 사용여부[▼]                         [초기화][조회] │
├─ 사용자 목록 ──┬─ 홍길동 E10001 ─ [업무별역할|화면별접근]─┤
│ 직원 검색      │ 탭1: 업무|역할|유효기간|사용               │
│ ▶ 홍길동       │ 탭2: □|화면ID|화면명|접근Y/N              │
│   이결재       │ ⚠ S1·S2 동시 부여 불가                     │
├────────────────┴────────────────────────── [취소][저장] ───┤
│ [이력보기 9080]                                              │
└─────────────────────────────────────────────────────────────┘
```""",
        "fields": [
            ("업무", "select", "Y", "CSPD119TI.aiInptTaskCd"),
            ("역할", "select", "Y", "CSPD120TI.AI_INPT_STAGE_ROLE_CD S1/S2/QA"),
            ("유효시작", "datetime", "Y", "AI_INPT_ROLE_STA_DTM"),
            ("유효종료", "datetime", "Y", "AI_INPT_ROLE_END_DTM"),
            ("화면ID", "text", "Y", "CSPD122TI.AI_INPT_SCRN_ID"),
            ("접근여부", "checkbox", "Y", "AI_INPT_SCRN_ACS_YN"),
        ],
        "events": [
            ("사용자 클릭", "GET /api/admin/taskAuth?userEno=", "역할+화면 로드"),
            ("+역할 추가", "행 추가", ""),
            ("저장", "POST /api/admin/taskAuth", "SoD 검증 MSG-SOD-001"),
            ("이력보기", "9080 팝업", "CSPD123TH"),
        ],
        "auth": "mgpeYn=Y; screenAccess 7050",
        "validation": "MSG-SOD-001; 필수: 업무, 역할, 유효기간",
        "api_specs": [
            ("GET /api/admin/taskAuth", "GET", "userEno, authCd, usgYn", "{roles[], screens[]}", ""),
            ("POST /api/admin/taskAuth", "POST", "{userEno, roles[], screens[]}", "저장 결과", "MSG-SOD-001"),
        ],
        "frontend": {
            "jsp": "admin/taskAuth/list.jsp (신규)",
            "js": "docs/wireframes/js/task-auth-panel.js",
            "css": "wf-master-detail, wf-layer-tab",
        },
        "tobe_changes": ["신규 Controller/Service/Mapper 전체 구현"],
        "checklist": [
            "AdminTaskAuthController 뷰",
            "TaskAuthService.save — SoD 검증",
            "CSPD120TI/122TI CRUD",
            "CSPD123TH 이력",
            "task-auth-panel.js 포팅",
        ],
    },
    "7052": {
        "purpose": "승인 Depth 규칙 정의·우선순위·시뮬레이션.",
        "search": [
            ("업무", "aiInptTaskCd", "select", "N", ""),
            ("사용여부", "aiInptRuleUsgYn", "select", "N", "Y/N"),
            ("Depth", "aiInptApprovDepth", "select", "N", "1/2"),
        ],
        "columns": [
            ("□", "chk", "—", ""),
            ("우선순위", "aiInptRulePrio", "ASC", "낮을수록 우선"),
            ("업무", "aiInptTaskCd", "—", "NULL=공통"),
            ("조건유형", "aiInptCondType", "—", "AMOUNT,ALERT_YN,RISK_LEVEL,DEFAULT"),
            ("연산자", "aiInptCondOp", "—", "LT,GTE,EQ,IN"),
            ("조건값", "aiInptCondVal", "—", ""),
            ("Depth", "aiInptApprovDepth", "—", "1/2"),
            ("사용", "aiInptRuleUsgYn", "—", ""),
            ("비고", "rmk", "—", ""),
        ],
        "buttons": [
            ("—", "[시뮬레이션]", "POST /api/admin/approvDepth/simulate"),
            ("—", "[저장]", "POST /api/admin/approvDepth/save"),
            ("선택", "[선택삭제]", "USG_YN=N 소프트삭제"),
        ],
        "auth": "mgpeYn=Y",
        "validation": "DEFAULT 규칙 1건; 우선순위 중복 경고",
        "api_specs": [
            ("GET /api/admin/approvDepth", "GET", "검색조건", "{rules[]}", ""),
            ("POST /api/admin/approvDepth/simulate", "POST", "taskCd, amount, alertYn, risk", "{depth, matchedRule}", ""),
        ],
        "frontend": {"jsp": "admin/approvDepth/list.jsp (신규)", "wireframe": "admin-7052-approv-depth.html"},
        "checklist": ["DepthRuleEngine 연동", "시뮬레이션 UI", "121TI CRUD"],
    },
    "DASH-v2": {
        "purpose": "긴급 심사대상·ToDo 숏컷 미니멀 대시보드 (v1 차트 제거).",
        "events": [
            ("[심사하기]", "1011 팝업", "긴급 카드 detailUrl"),
            ("숏컷 클릭", "1010/2010 탭", "FR-003"),
            ("SSE DASHBOARD_REFRESH", "POST /api/dashboard 재조회", ""),
        ],
        "api_specs": [("POST /api/dashboard", "POST", "—", "{urgentList, todoCounts}", "")],
        "frontend": {"wireframe": "dashboard-v2.html"},
    },
    "GLOBAL": {
        "purpose": "전역 SSE·Toast·LNB 배지. layout.jsp 단일 EventSource.",
        "events": [
            ("URGENT", "notification-toast.js", "1011 바로가기"),
            ("TODO_UPDATE", "postMessage → iframe", "1010/2010/3010 tableReload"),
            ("DASHBOARD_REFRESH", "dashboard 갱신", ""),
            ("ASIDE_REFRESH", "LNB 배지", ""),
        ],
        "api_specs": [
            ("GET /api/notify/stream", "GET(SSE)", "세션 userId", "event: URGENT|TODO_UPDATE|…", ""),
            ("GET /api/notify/poll", "GET", "fallback", "이벤트 배열", ""),
        ],
        "frontend": {
            "jsp": "layout/layout.jsp",
            "js": "notify-client.js, notification-toast.js",
        },
        "checklist": ["SseEmitter per user", "재연결 backoff", "postMessage origin 검증"],
    },
    "8070": {
        "purpose": "AI 엔진 운영 모니터링 — 추출/검수 성공·실패, 재처리 큐.",
        "columns": [
            ("구분", "category", "—", ""),
            ("요청", "reqCnt", "—", ""),
            ("성공", "succCnt", "—", ""),
            ("실패", "failCnt", "—", ""),
            ("평균응답", "avgMs", "—", ""),
        ],
        "frontend": {"wireframe": "admin-8070-monitor.html", "jsp": "admin/aiMonitor/list.jsp (신규)"},
        "api_specs": [("GET /api/admin/aiMonitor", "GET", "period", "{metrics[]}", "")],
    },
    "9080": {
        "purpose": "심사 처리 이력 타임라인 + 첨부 (FR-065).",
        "auth": "screenAccess; 권한 이력 열람",
        "frontend": {"wireframe": "history-9080.html", "jsp": "common/revert/history.jsp"},
        "api_specs": [("GET /api/common/revert/history", "GET", "inptMstSrno, actlFxRefno", "{timeline[]}", "")],
    },
}
