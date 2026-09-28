# -*- coding: utf-8 -*-
"""개발 표준 가이드 Excel — 상세 데이터."""
from __future__ import annotations

# §별 시트 구조 상세 (개발자 가이드)
SHEET_SECTIONS: list[tuple] = [
    ("1", "화면 개요", "목적·TO-BE 변경 범위", "담당 화면의 비즈니스 목적·변경 요약 확인", "purpose 문구"),
    ("2", "기본 정보", "URL·JSP·BPMN 링크", "View Controller 매핑·와이어프레임 HTML 경로", "Controller, JSP 경로"),
    ("3", "레이아웃", "ASCII·와이어프레임 대응", "영역 분할·패턴(C/D/E) 확인", "layout ASCII"),
    ("4", "검색 조건", "필드·파라미터·타입", "SearchVO 필드명·id/name 일치", "SearchVO, JSP form"),
    ("5", "목록·그리드 컬럼", "data 필드·정렬·비고", "DataTables columns[].data ↔ API 키", "columns config"),
    ("6", "버튼·액션", "조건·API/동작", "역할·Depth별 버튼 show/hide", "JSP 버튼·API 분기"),
    ("7", "이벤트·상호작용", "트리거·동작·비고 (설계 설명)", "핸들러 직접 구현 — 자동 생성 없음", "JS 이벤트 핸들러"),
    ("8", "API 명세", "Request/Response·Controller", "ApiController·VO·응답 JSON 구조", "ApiController, Mapper"),
    ("9", "접근권한", "Interceptor·Task-Role·SoD", "L1/L2/L3 검증 위치 확인", "Interceptor, Service WHERE"),
    ("10", "유효성·메시지", "메시지 코드·confirm", "MSG-* 코드·confirm 다이얼로그", "ExceptionHandler, JS confirm"),
    ("11", "백엔드", "Controller/Service/Mapper/XML", "처리 흐름·트랜잭션·권한 필터", "Java, MyBatis XML"),
    ("12", "관련 테이블", "논리명·물리명(CSPD*)·용도", "JOIN·WHERE 대상 테이블", "Mapper SQL"),
    ("13", "프론트엔드", "JSP·JS·CSS·include", "datatable.jsp·공통 함수·wf-* 클래스", "JSP, JS, CSS"),
    ("14", "화면 상태", "로딩·팝업·SSE 갱신", "SSE 이벤트·postMessage 수신 처리", "notify-client.js"),
    ("15", "체크리스트", "PR·UAT 검수 항목", "패턴 공통 + 화면별 항목 전체 확인", "PR 체크리스트"),
    ("16", "관련 문서", "BPMN·아키텍처", "프로세스 정의서·BPMN·FR 추적", "BPMN, process/*.md"),
]

IMPLEMENTATION_STEPS: list[tuple] = [
    ("1", "View Controller", "URL → JSP, 공통코드 Model", "@RequestMapping, ModelAndView, blank/ 뷰", "XxxController.java"),
    ("2", "ApiController", "REST 엔드포인트, SearchVO 바인딩", "@GetMapping/@PostMapping, HashMap 응답, PaginationInfo", "XxxApiController.java"),
    ("3", "Service/Mapper", "TO-BE 필터(Task-Role, Depth, SoD)", "selectList/selectListTotCnt, WHERE 절 권한", "Service, Mapper, *_SQL.xml"),
    ("4", "JSP", "검색폼 id/name = 시트 파라미터", "wf-search-v2, form id/name, hidden field", "list.jsp / detail.jsp"),
    ("5", "DataTables", "columns[].data ↔ resultList 키", "dataTable_XXXConfig, getSearchOption()", "JSP script, datatable.jsp"),
    ("6", "이벤트", "§7 트리거·동작·비고 참조", "클릭/더블클릭 column index, fnFullWin", "JS 핸들러"),
    ("7", "권한", "AuthenticationInterceptor + screenAccess", "세션 taskRoles[], screenAccess[]", "Interceptor, Service"),
    ("8", "체크리스트", "§15 전체 확인", "PR·UAT 검수", "체크리스트 완료"),
]

PR_CHECKLIST: list[str] = [
    "화면설계 시트 §1~§16 전체 대조",
    "와이어프레임 HTML과 UI 레이아웃 일치 (wf-* 클래스)",
    "검색 파라미터 ↔ SearchVO 필드명 일치",
    "API Request/Response ↔ 시트 §8 일치",
    "DataTables columns data ↔ API resultList 키 일치",
    "권한: screenAccess + Task-Role (TO-BE) 적용",
    "SoD·Depth 검증 (해당 화면)",
    "메시지 코드(MSG-*)·confirm 다이얼로그",
    "프로그램 사용이력 fnCmnProgramLog 호출",
    "SSE/postMessage 갱신 (해당 화면)",
    "BPMN·프로세스 정의서와 처리 흐름 일치",
]

NAMING_CONVENTIONS: list[tuple] = [
    ("View Controller", "XxxController", "RevertTodoController", "src/main/java/.../web/"),
    ("API Controller", "XxxApiController", "RevertTodoApiController", "/api/... REST"),
    ("Service", "XxxService / XxxServiceImpl", "RevertTodoService", "비즈니스·권한 필터"),
    ("Mapper", "XxxMapper", "RevertTodoMapper", "MyBatis Interface"),
    ("SQL XML", "Xxx_SQL.xml", "RevertTodo_SQL.xml", "egovframework/sqlmap/ui/mappers/"),
    ("VO", "XxxVO, SearchVO", "ReverTodoVO", "egovframework/ui/vo/"),
    ("JSP", "list.jsp / detail.jsp", "revert/todo/list.jsp", "WEB-INF/jsp/"),
    ("JS Config", "dataTable_{화면ID}Config", "dataTable_1010Config", "JSP inline 또는 .js"),
    ("Form id", "form{화면명}", "formRevertDetail", "hidden POST 팝업 진입"),
    ("검색 id", "txt_/cbo_ + 필드명 + _Search_{ID}", "cbo_inptAtmcBizDscd_Search_1010", "시트 §4 파라미터"),
]

BACKEND_LAYERS: list[tuple] = [
    ("Presentation", "Controller", "@Controller, @RequestMapping", "JSP 뷰 반환, Model 데이터"),
    ("Presentation", "ApiController", "@RestController", "JSON HashMap, PaginationInfo"),
    ("Business", "Service", "@Service", "권한·SoD·Depth 검증, 트랜잭션"),
    ("Persistence", "Mapper", "@Mapper (MyBatis)", "SQL 호출 Interface"),
    ("Persistence", "SQL XML", "namespace=Mapper", "selectList, selectListTotCnt, insert, update"),
    ("Cross-cutting", "Interceptor", "AuthenticationInterceptor", "screenAccess, 세션 검증"),
    ("Cross-cutting", "ExceptionHandler", "CommonExceptionHandler", "MSG-SESSION-*, MSG-AUTH-*"),
]

FRONTEND_PATTERNS: list[tuple] = [
    ("DataTables 초기화", "datatable.jsp include", "serverSide: true, ajaxUrl, columns", "모든 Pattern C"),
    ("검색 옵션", "getSearchOption()", "form serialize → API 파라미터", "Pattern C"),
    ("목록 조회", "dataTable.searchList()", "GET API 호출", "Pattern C"),
    ("상세 팝업", "fnFullWin(form)", "hidden form POST → fullLayout 팝업", "1011, 2011"),
    ("이력 팝업", "fnHistoryWin(form)", "9080 등 이력 화면", "1010 Ref.No dblclick"),
    ("로그인 체크", "checkLogin() / fnLoginAlert()", "ajax 호출 전 세션 검증", "전역"),
    ("프로그램 로그", "fnCmnProgramLog(화면ID)", "CSPD811TH INSERT", "모든 화면"),
    ("숫자 포맷", "fnNumberCommaFormat", "금액 컬럼 render", "목록·상세"),
    ("행 스타일", "fnRowCallback", "수기입력·우선순위 class", "1010 FR-004"),
    ("SSE 갱신", "postMessage 수신", "TODO_UPDATE → tableReload()", "1010, 2010, 3010"),
    ("탭 오픈", "shell-v2.js openTab()", "iframe MDI", "MAIN 셸"),
    ("Canvas 핀", "annotation-store.js", "이미지 좌표 하이라이트", "1011, 2011"),
]

COMMON_LAYOUTS: list[tuple] = [
    ("MAIN 셸", "A", "GNB + LNB + TabBar + iframe", "layout.jsp, shell-v2.js", "SSE 1회, postMessage 분배"),
    ("LOGIN", "단독", "ID/PW + SSO", "login/login.jsp", "taskRoles·screenAccess 세션 적재"),
    ("목록 공통", "C", "검색(wf-search-v2) + 그리드(wf-table-v2)", "list.jsp + datatable.jsp", "페이징·정렬·체크박스"),
    ("상세 공통", "D", "3단: 문서트리|이미지|탭패널", "detail.jsp, btnFlag 분기", "depth·역할별 버튼"),
    ("MD 공통", "E", "좌: 마스터 목록 / 우: 상세 폼", "wf-master-detail", "선택 행 하이라이트"),
    ("대시보드", "B", "긴급카드 + 숏컷카드", "dashboard.jsp", "v2: 차트 제거(FR-001)"),
]

ASIS_TOBE_AUTH: list[tuple] = [
    ("권한 단위", "사용자 1:1 (AI_INPT_AUT_CD)", "사용자 × 업무 × 단계(S1/S2/QA)"),
    ("메뉴 권한", "CSPD109TI (권한코드)", "CSPD109TI + CSPD122TI (화면별)"),
    ("ToDo 조회", "AI_INPT_AUT_CD + AI_INSPE_ENO", "업무별 S1/S2 자격 + 건 배정"),
    ("승인 depth", "항상 2단계", "규칙 기반 1/2단계 (CSPD121TI)"),
    ("관리 화면", "7010, 7030", "+ 7050(권한), 7052(Depth)"),
    ("전환기", "—", "기존 권한코드 OR 신규 Task-Role (이중 읽기)"),
]

ASIS_ROLES: list[tuple] = [
    ("01", "심사자 (S1)", "1010, 1011", "AI_INPT_AUT_CD"),
    ("02", "결재자 (S2)", "2010, 2011", "AI_INPT_AUT_CD"),
    ("03", "QA 담당자", "3010, 3011", "AI_INPT_AUT_CD"),
    ("04", "일반사용자", "제한적", "AI_INPT_AUT_CD"),
    ("—", "관리자", "7050, 7052, 8070", "AI_INPT_MGPE_YN=Y"),
]

TASK_DEFINITIONS: list[tuple] = [
    ("EXP", "2", "수출 심사", "선적서류심사", "SANCTION"),
    ("IMP", "1", "수입 심사", "선적서류심사", "SANCTION"),
    ("REMIT", "3", "송금 심사", "WORKFLOW심사", "WORKFLOW"),
    ("WF_SANC", "4", "고위험 SANCTION 심사의뢰", "WORKFLOW심사", "WORKFLOW"),
]

SOD_RULES: list[tuple] = [
    ("정적 SoD", "동일 (USER, TASK)에 S1+S2 동시 부여 금지", "7050 저장", "CSPD120TI UK + MSG-SOD-001"),
    ("동적 SoD", "본인이 S1 처리한 건은 S2 결재 불가", "2011 승인", "AI_INSPE_ENO ≠ loginUser, MSG-SOD-002"),
    ("배정 검증", "본인 배정 건만 심사 처리", "1011 진입", "AI_INSPE_ENO=loginUser"),
    ("Depth 필터", "결재 ToDo는 depth=2 건만", "2010 조회", "AI_INPT_APPV_DEPTH_CD=2"),
    ("이력", "권한·역할 변경 감사", "7050/7052 저장", "CSPD123TH INSERT"),
]

SESSION_FIELDS: list[tuple] = [
    ("userId", "로그인 사용자 직원번호", "전역", "AI_INPT_USER_ENO"),
    ("taskRoles[]", "업무별 역할 목록", "ToDo 필터", "{taskCd, stageRoleCd, ...}"),
    ("screenAccess[]", "접근 가능 화면 ID 목록", "메뉴·URL", "['1010','1011',...]"),
    ("mgpeYn", "관리자 여부", "7050/7052/8070", "Y/N"),
]

DEPTH_LOGIC: list[tuple] = [
    ("규칙 평가", "CSPD121TI 우선순위 오름차순", "건 생성 시", "ApprovalDepthService"),
    ("조건 유형", "AMOUNT, ALERT_YN, RISK_LEVEL, DEFAULT", "7052 관리", "공통코드 grp=132"),
    ("연산자", "LT, LTE, GTE, GT, EQ, IN", "7052 관리", "공통코드 grp=133"),
    ("결과", "1=단독결재, 2=교차결재", "CSPD001TM 스냅샷", "AI_INPT_APPV_DEPTH_CD"),
    ("1011 depth=1", "최종승인 버튼", "상신 생략", "MSG-DEPTH-001 confirm"),
    ("1011 depth=2", "결재상신 버튼", "S2 결재 필요", "2010/2011 연계"),
    ("시뮬레이션", "POST /api/admin/approvDepth/simulate", "7052 화면", "규칙 검증용"),
]

TOBE_TABLES: list[tuple] = [
    ("CSPD119TI", "업무(Task) 마스터", "AI_INPT_TASK_CD PK", "FR-040", "IMP, EXP, REMIT 등"),
    ("CSPD120TI", "업무별 사용자 역할", "USER+TASK+ROLE UK", "FR-042, FR-044", "S1/S2/QA, SoD"),
    ("CSPD121TI", "승인 Depth 규칙", "RULE_PRIO, COND_TYPE", "FR-041, FR-043", "1/2단계 판정"),
    ("CSPD122TI", "사용자 화면별 접근권한", "USER+SCRN_NO", "FR-054", "screenAccess[]"),
    ("CSPD123TH", "권한·역할 변경 이력", "CHG_TYP_CD, JSON", "FR-065", "감사 추적"),
]

TABLE_EXTENSIONS: list[tuple] = [
    ("CSPD001TM", "AI_INPT_TASK_CD", "업무 코드 FK", "건 생성 시"),
    ("CSPD001TM", "AI_INPT_APPV_DEPTH_CD", "승인 Depth (1/2)", "DepthRuleEngine 결과"),
    ("CSPD005TH", "AI_INPT_STAGE_ROLE_CD", "처리 단계 (S1/S2)", "승인 이력"),
    ("CSPD005TH", "AI_INPT_APPROV_DEPTH_CD", "처리 시점 Depth", "이력 기록"),
    ("CSPD005TH", "AI_INPT_FINAL_YN", "최종 승인 여부", "1단계 시 S1=Y"),
]

TOBE_CORE_SCREENS: list[dict] = [
    {
        "id": "7050",
        "name": "업무별 권한 설정",
        "url": "/admin/taskAuth",
        "fr": "FR-042, FR-054",
        "tabs": "탭1: 업무별 역할(S1/S2/QA) / 탭2: 화면별 접근",
        "api": "GET/POST /api/admin/taskAuth",
        "tables": "CSPD120TI, CSPD122TI, CSPD123TH",
        "validation": "S1+S2 동시 부여 금지, 필수: 업무·역할·유효기간",
        "ref": "task-auth-panel.js, task-centric-auth-approval-guide.md",
    },
    {
        "id": "7052",
        "name": "승인 규칙 관리",
        "url": "/admin/approvDepth",
        "fr": "FR-041, FR-043",
        "tabs": "규칙 목록 + 상세 폼 + 시뮬레이션",
        "api": "GET/POST /api/admin/approvDepth, POST .../simulate",
        "tables": "CSPD121TI",
        "validation": "우선순위 중복 경고, DEFAULT 규칙 1건 필수",
        "ref": "admin-7052-approv-depth.html",
    },
    {
        "id": "8070",
        "name": "AI 운영모니터링",
        "url": "/admin/aiMonitor",
        "fr": "FR-058, FR-064",
        "tabs": "AI 처리 현황 / 좌표 오프셋 / 재처리 큐",
        "api": "GET /api/admin/aiMonitor",
        "tables": "—",
        "validation": "mgpeYn=Y",
        "ref": "admin-8070-monitor.html",
    },
    {
        "id": "6066",
        "name": "감독증빙 통계",
        "url": "/stat/regulatory",
        "fr": "FR-066",
        "tabs": "검색 + 목록 + 엑셀 다운로드",
        "api": "GET /api/stat/regulatory",
        "tables": "CSPD001TM 등 집계",
        "validation": "기간·업무·결과 필수",
        "ref": "stats-6066-regulatory.html",
    },
    {
        "id": "6067",
        "name": "업무현황 통계",
        "url": "/stat/efficiency",
        "fr": "FR-067",
        "tabs": "검색 + 목록",
        "api": "GET /api/stat/efficiency",
        "tables": "집계",
        "validation": "—",
        "ref": "stats-6067-efficiency.html",
    },
    {
        "id": "6069",
        "name": "조기경보 통계",
        "url": "/stat/early-warning",
        "fr": "FR-069",
        "tabs": "검색 + 목록",
        "api": "GET /api/stat/early-warning",
        "tables": "집계",
        "validation": "—",
        "ref": "stats-6069-early-warning.html",
    },
]

BTNFLAG_MAP: list[tuple] = [
    ("A", "심사자", "1011", "[임시저장][최종승인|결재상신][재스캔][재추출][B/L수정]"),
    ("B", "결재자", "2011", "[승인][반려][의견] 등"),
    ("C", "QA", "3011", "QA 전용 버튼"),
    ("D", "결재자 QA", "2011-QA", "QA 결재"),
    ("E", "심사 이력", "9010", "읽기전용"),
    ("F", "QA 이력", "9020", "읽기전용"),
]

COMMON_CODE_GROUPS: list[tuple] = [
    ("130", "단계 역할", "S1, S2, QA", "CSPD120TI"),
    ("131", "승인 Depth", "1(단독), 2(교차)", "CSPD121TI"),
    ("132", "Depth 조건 유형", "AMOUNT, ALERT_YN, RISK_LEVEL, DEFAULT", "CSPD121TI"),
    ("133", "Depth 조건 연산자", "LT, LTE, GTE, GT, EQ, IN", "CSPD121TI"),
    ("134", "업무군", "SANCTION, WORKFLOW", "CSPD119TI"),
    ("150", "심사 업무 구분", "수입/수출/송금 등", "검색 조건"),
]

FR_TRACE: list[tuple] = [
    ("FR-001", "DASH-v2", "대시보드 v2 — 차트 제거, 긴급 카드"),
    ("FR-002", "MAIN", "GNB 2분류 (선적서류/WORKFLOW)"),
    ("FR-003", "MAIN, DASH-v2", "LNB 업무별 배지·숏컷"),
    ("FR-004", "1010", "우선순위 정렬·행 하이라이트"),
    ("FR-005", "GLOBAL, 1010", "긴급 알람 Toast·SSE"),
    ("FR-006~029", "1011", "심사상세 전체"),
    ("FR-038", "1011", "Depth 뱃지·버튼 가변"),
    ("FR-040", "CSPD119TI", "업무(Task) 마스터"),
    ("FR-041", "7052, CSPD121TI", "승인 Depth 규칙"),
    ("FR-042", "7050, CSPD120TI", "업무별 사용자 역할"),
    ("FR-043", "7052", "Depth 자동 판정·시뮬레이션"),
    ("FR-044", "7050", "S1+S2 SoD"),
    ("FR-054", "7050, CSPD122TI", "화면별 접근권한"),
    ("FR-055", "7010", "사용자 관리 v2"),
    ("FR-056", "7051", "부점정보"),
    ("FR-057", "LOGIN", "SSO 로그인"),
    ("FR-058", "8070", "AI 운영모니터링"),
    ("FR-064", "8070, 1011", "AI 처리 모니터링"),
    ("FR-065", "9080, CSPD123TH", "심사이력·권한 변경 이력"),
    ("FR-066", "6066", "감독증빙 통계"),
    ("FR-067", "6067", "업무현황 통계"),
    ("FR-069", "6069", "조기경보 통계"),
]
