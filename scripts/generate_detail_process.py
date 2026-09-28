#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""상세 프로세스 정의서 생성 스크립트"""

import os
import textwrap

OUTPUT_DIR = os.path.join(os.path.dirname(__file__), "..", "docs", "process", "상세")

# (도메인파일, 도메인명, 기본문서, 화면 목록)
DOMAINS = [
    ("00_공통_진입화면_상세.md", "공통 진입", "../00_공통_진입화면.md", [
        "LOGIN", "MAIN", "DASH", "9999",
    ]),
    ("01_심사_상세.md", "심사", "../01_심사.md", [
        "1010", "1020", "1030", "1011", "BLMOD",
    ]),
    ("02_결재_상세.md", "결재", "../02_결재.md", [
        "2010", "BUNDLE", "2020", "2011", "2011QA",
    ]),
    ("03_QA_상세.md", "QA", "../03_QA.md", [
        "3010", "3020", "3011",
    ]),
    ("04_심사현황명세_상세.md", "심사 현황/명세", "../04_심사현황명세.md", [
        "4010", "4020", "4030", "4040", "4050",
    ]),
    ("05_업무일지_상세.md", "업무일지", "../05_업무일지.md", [
        "5010", "5020", "5030", "5040",
    ]),
    ("06_통계_상세.md", "통계", "../06_통계.md", [
        "6010", "6020", "6030", "6040", "6050",
    ]),
    ("07_관리자_상세.md", "관리자", "../07_관리자.md", [
        "7010", "7021", "7022", "7030", "7031", "7040", "7050", "7060",
        "7070", "7080", "7090", "8010", "8020", "8030", "8040", "8050",
        "8051", "8060",
    ]),
    ("08_공통팝업_상세.md", "공통 팝업/이력", "../08_공통팝업.md", [
        "9080", "9090", "9010", "9020", "USER_MODAL", "FILE_MODAL", "MAP",
    ]),
]

SCREENS = {
    "LOGIN": {
        "title": "SCR-LOGIN — 로그인",
        "screen_no": "—",
        "jsp": "`WEB-INF/jsp/login/login.jsp`, `proc.jsp`, `sso.jsp`",
        "url": "`/login`, `/login/sso/nst`, `/login/sso/prx`, `/logout`",
        "bpmn": "로그인.bpmn",
        "purpose": "SSO 또는 로컬 인증을 통해 세션을 생성하고 메인 화면으로 진입합니다.",
        "pre": ["브라우저에서 시스템 URL 접근", "네트워크/SSO 연동 가능"],
        "post": ["세션(`LoginVO`) 생성", "메뉴 권한 로드 가능 상태"],
        "ui": ["로그인 폼(ID/PW)", "SSO 자동 리다이렉트 처리 페이지"],
        "steps": [
            ("1", "화면 진입", "사용자", "URL `/login` 또는 SSO 리다이렉트", "로그인 JSP 렌더링", "—", "—", "로그인 화면", "—", "세션 없음 시 정상"),
            ("2", "인증 방식 분기", "시스템", "환경 설정", "SSO vs 로컬 로그인 분기", "CommonLoginController", "credentials/SSO token", "인증 요청", "SSO/로컬", "SSO 실패 시 에러"),
            ("3", "로컬 로그인", "사용자", "로그인 버튼", "ID/PW 검증 API 호출", "POST `/api/common/login`", "userId, password", "LoginVO", "성공/실패", "실패 시 메시지 표시"),
            ("4", "SSO 처리", "시스템", "SSO 콜백", "토큰 검증 후 세션 생성", "`/login/sso/*`", "SSO 파라미터", "세션", "성공", "토큰 무효 시 차단"),
            ("5", "사용자 정보 조회", "시스템", "로그인 성공 직후", "권한·부서 정보 로드", "POST `/api/common/getMyInfo`", "세션 ID", "사용자 프로필", "—", "403 시 접근 제한"),
            ("6", "메인 이동", "시스템", "인증 성공", "`/index` 리다이렉트", "CommonMainController", "—", "메인 프레임", "—", "—"),
        ],
        "events": [
            ("`checkLogin()`", "세션 유효성 클라이언트 검사"),
            ("`fnLoginAlert()`", "세션 만료 시 알림"),
        ],
        "apis": [
            ("POST `/api/common/login`", "로컬 로그인"),
            ("POST `/api/common/getMyInfo`", "사용자 정보"),
            ("GET `/api/common/login/forbidden`", "접근 거부"),
        ],
    },
    "MAIN": {
        "title": "SCR-MAIN — 메인 프레임",
        "screen_no": "—",
        "jsp": "`WEB-INF/jsp/main/index.jsp`",
        "url": "`/index`",
        "bpmn": "메인프레임.bpmn",
        "purpose": "GNB/LNB 메뉴, 탭, iframe 기반 업무 화면 셸을 제공합니다.",
        "pre": ["로그인 세션 유효"],
        "post": ["메뉴·탭·iframe 초기화 완료"],
        "ui": ["GNB `#main_menu_zone`", "LNB `#sub_menu_zone`", "탭 `#menu-tabContent`"],
        "steps": [
            ("1", "메인 로드", "시스템", "POST `/index`", "Tiles `main/index` 렌더링", "CommonMainController", "—", "메인 셸 HTML", "—", "—"),
            ("2", "메뉴 API 호출", "클라이언트", "onload", "권한별 메뉴 트리 조회", "GET `/api/common/menu`", "세션 권한", "menu tree JSON", "—", "빈 메뉴 시 안내"),
            ("3", "GNB 렌더링", "클라이언트", "API 응답", "`setMainMenu()`", "common.js", "menu data", "상단 메뉴 DOM", "—", "—"),
            ("4", "LNB 렌더링", "클라이언트", "대메뉴 선택", "`setSubMenu()`", "common.js", "menuId", "좌측 메뉴 DOM", "—", "—"),
            ("5", "기본 탭 오픈", "시스템", "초기화", "Dashboard iframe 로드", "`/dashboard/dashboard`", "—", "기본 탭", "—", "—"),
            ("6", "화면 전환", "사용자", "메뉴 클릭", "`dolocateMenu()` → iframe URL", "common.js", "screen URL", "업무 화면", "신규/기존 탭", "권한 없으면 차단"),
        ],
        "events": [
            ("`getMenuData()`", "메뉴 데이터 비동기 로드"),
            ("`dolocateMenu()`", "탭+iframe 화면 오픈"),
        ],
        "apis": [("GET `/api/common/menu`", "권한별 메뉴 트리 (CSPD108TI/109TI)")],
    },
    "DASH": {
        "title": "SCR-DASH — 대시보드",
        "screen_no": "Dashboard",
        "jsp": "`WEB-INF/jsp/dashboard/dashboard.jsp`",
        "url": "`/dashboard/dashboard`",
        "bpmn": "대시보드.bpmn",
        "purpose": "To-Do, 진행상태, 당일 심사현황, 국가별 수출입 현황을 요약 표시합니다.",
        "pre": ["로그인 완료", "메인 탭으로 로드"],
        "post": ["차트·표 데이터 표시"],
        "ui": ["To-Do 도넛 차트 `#canvas-1`", "진행상태 `#canvas-2`", "당일심사 `#canvas-3`", "지도 `common/map.jsp`"],
        "steps": [
            ("1", "화면 초기화", "시스템", "탭 로드", "Chart.js 초기화", "dashboard.jsp", "—", "빈 차트 영역", "—", "—"),
            ("2", "집계 API 호출", "클라이언트", "onload / 새로고침", "대시보드 데이터 요청", "POST `/api/dashboard`", "userId(세션)", "집계 JSON", "—", "API 오류 시 빈 표시"),
            ("3", "To-Do 렌더링", "클라이언트", "API 성공", "도넛 차트+표", "`#todo_table`", "todo 집계", "차트", "—", "—"),
            ("4", "진행상태 렌더링", "클라이언트", "API 성공", "도넛 차트+표", "`#status_table`", "status 집계", "차트", "—", "—"),
            ("5", "당일심사 렌더링", "클라이언트", "API 성공", "바 차트+표", "`#inpt_table`", "inpt 집계", "차트", "—", "—"),
            ("6", "지도 렌더링", "클라이언트", "API 성공", "국가별 수출입 지도", "map.jsp include", "국가별 데이터", "지도", "—", "—"),
            ("7", "새로고침", "사용자", "`#refreshBtn` 클릭", "2단계부터 재실행", "—", "—", "갱신된 차트", "—", "—"),
        ],
        "events": [("#refreshBtn click", "전체 데이터 재조회")],
        "apis": [("POST `/api/dashboard`", "대시보드 집계 데이터")],
    },
    "9999": {
        "title": "SCR-9999 — 사용자매뉴얼",
        "screen_no": "9999",
        "jsp": "`WEB-INF/jsp/common/manual.jsp`",
        "url": "`/common/manual`",
        "bpmn": "9999_사용자매뉴얼.bpmn",
        "purpose": "시스템 매뉴얼 조회·다운로드 및 관리자 업로드를 처리합니다.",
        "pre": ["로그인 완료"],
        "post": ["매뉴얼 목록 표시 또는 파일 처리 완료"],
        "ui": ["매뉴얼 목록", "다운로드 링크", "업로드 폼(관리자)"],
        "steps": [
            ("1", "목록 조회", "시스템", "화면 로드", "매뉴얼 파일 목록 API", "GET `/common/manual/list`", "—", "파일 목록", "—", "—"),
            ("2", "다운로드", "사용자", "파일 링크 클릭", "파일 스트림 다운로드", "—", "fileId", "파일", "—", "파일 없음 오류"),
            ("3", "업로드", "관리자", "파일 선택+업로드", "매뉴얼 저장", "POST `/api/common/manual/upload`", "multipart file", "성공/실패", "—", "용량/형식 오류"),
            ("4", "삭제", "관리자", "삭제 클릭", "업로드 파일 삭제", "GET `/api/common/manual/delUploadedFile`", "fileId", "삭제 결과", "—", "—"),
        ],
        "events": [],
        "apis": [
            ("GET `/common/manual/list`", "목록"),
            ("POST `/api/common/manual/upload`", "업로드"),
            ("GET `/api/common/manual/delUploadedFile`", "삭제"),
        ],
    },
    "1010": {
        "title": "SCR-1010 — 본인작업 ToDoList",
        "screen_no": "1010",
        "jsp": "`WEB-INF/jsp/revert/todo/list.jsp`",
        "url": "`/revert/todo`",
        "bpmn": "1010_본인작업_ToDoList.bpmn",
        "purpose": "심사자 배정 건을 검색·조회하고 심사상세/이력 팝업으로 처리합니다.",
        "pre": ["로그인(권한 01 심사자)", "본인 배정 업무 존재"],
        "post": ["목록 갱신 또는 팝업 처리 완료"],
        "ui": ["검색영역 `.searchWrap`", "DataTable `#dataTable_1010`", "심사상세 form `#formRevertDetail`", "이력 form `#formRevertHistory`"],
        "steps": [
            ("1", "화면 초기화", "시스템", "iframe 로드", "로딩 표시, 검색 기본값", "initLoadingDisplay", "—", "검색 폼", "—", "—"),
            ("2", "프로그램 이력", "시스템", "조회 시", "화면 사용 이력 기록", "fnCmnProgramLog('1010')", "검색 파라미터", "이력 저장", "—", "—"),
            ("3", "목록 조회", "사용자", "조회 버튼", "ToDo API 호출", "GET `/api/revert/todo`", "inptAtmcBizDscd, actlFxRefno, aiInptCsno, inptMstSrno", "resultList, paginationInfo", "—", "세션 만료 시 로그인 알림"),
            ("4", "목록 렌더링", "클라이언트", "API 응답", "DataTable 바인딩", "dataTable_1010Config", "resultList", "그리드", "inptAtvtCd=80 분홍행", "—"),
            ("5", "결과 색상", "클라이언트", "행 렌더", "TotalText/항목/SW 결과색", "fnRowCallback", "결과코드 30/40", "빨강/녹색", "—", "—"),
            ("6", "심사상세 오픈", "사용자", "프로세스/액티비티 컬럼 클릭(col 6,7)", "POST form → 팝업", "fnFullWin → `/revert/detail`", "inptMstSrno, inptAtvtCd, actlFxRefno", "심사상세 팝업", "—", "checkLogin 실패 시 중단"),
            ("7", "이력 오픈", "사용자", "Ref.No 더블클릭(col 3)", "이력 팝업", "fnHistoryWin → `/common/revert/history`", "inptMstSrno, actlFxRefno, inptAtmcBizDscd", "이력 팝업", "—", "—"),
            ("8", "팝업 후 재조회", "시스템", "팝업 닫힘", "tableReload()", "dataTable_1010.searchList()", "—", "갱신 목록", "—", "—"),
        ],
        "events": [
            ("td click col 6,7", "심사상세 팝업"),
            ("td dblclick col 3", "심사이력 팝업"),
            ("tableReload()", "팝업 종료 후 목록 재조회"),
        ],
        "apis": [("GET `/api/revert/todo`", "본인 ToDo 목록 (RevertTodoApiController)")],
        "states": [
            ("inptAtvtCd=80", "수기입력 대상 → 행 분홍색"),
            ("totaltextAiInptRstCd=30/40", "경보/정상 색상"),
        ],
    },
    "1011": {
        "title": "SCR-1011 — 심사상세",
        "screen_no": "1011",
        "jsp": "`WEB-INF/jsp/revert/detail/detail.jsp`",
        "url": "POST `/revert/detail`",
        "bpmn": "1011_심사상세.bpmn",
        "purpose": "문서 이미지·TotalText·항목심사·SafeWatch 결과를 검토하고 저장/결재상신합니다.",
        "pre": ["inptMstSrno 전달", "심사자 접근권한(schGbn=01) 통과", "btnFlag=A"],
        "post": ["임시저장/결재상신/재처리 요청 완료", "또는 팝업 종료"],
        "ui": ["B/L 탭 `.bl-link`", "문서분류 `.item-link`", "Canvas 이미지 뷰어", "TotalText/항목/SafeWatch DataTable", "전달의견 `#rspt_inpt_apv_req_txt`", "버튼 `#right_btn_zone`"],
        "steps": [
            ("1", "접근권한 검증", "서버", "POST 진입", "selectCheckAccess", "RevertDetailController", "inptMstSrno, schGbn=01", "checkAccess>0", "실패→alertClose", "권한 없음 메시지"),
            ("2", "상세 로드", "클라이언트", "onload", "fn_getBLData('A')", "POST `/api/common/detail/load`", "inptMstSrno, btnFlag=A", "selectStdInfo, tabs, img, rst", "CheackCd=50 시 이력갱신", "resultCode!=200 오류"),
            ("3", "B/L 탭 구성", "클라이언트", "load 성공", "fn_setBl()", "topTab 데이터", "—", "B/L 탭 UI", "—", "—"),
            ("4", "문서분류 탭", "클라이언트", "B/L 선택", "fn_setItem()", "leftTab 데이터", "inptBlGrpNo", "문서분류 탭", "—", "—"),
            ("5", "이미지 표시", "클라이언트", "문서분류 선택", "fn_setImgInfo()", "imgPageInfo, imgCdnts", "imexHisCd, inptTaskId", "Canvas 이미지+좌표", "—", "—"),
            ("6", "심사결과 표시", "클라이언트", "load 성공", "fn_setTotalTextRst/SanctionRst/SafeWatchRst", "—", "rst 데이터", "3개 DataTable", "—", "—"),
            ("7", "버튼 구성", "클라이언트", "load 성공", "fn_setBtn()", "aiInptAcvtCd 기준", "selectStdInfo", "심사진행/완료/재스캔 등", "80→수기, 90→검토", "—"),
            ("8", "항목 클릭 연동", "사용자", "TotalText/항목 행 클릭", "이미지 좌표 하이라이트", "fn_setBlink()", "inptTaskId, inptElmtId", "Canvas 강조", "—", "—"),
            ("9", "임시저장", "사용자", "tmpSaveBtn", "fn_setTmpParam → inspection", "POST `/api/common/revertDetail/inspection`", "jData(JSON): sanctionList, 의견", "rst + TA 연동", "aiInptAcvtCd 50/70", "TA 전송 실패 로그"),
            ("10", "심사진행/재심사", "사용자", "inspection 버튼", "inspection API (상신 전 단계)", "동일 API", "inspectionType", "심사 진행 상태", "80/90 분기", "—"),
            ("11", "결재상신(완료)", "사용자", "porsBtn/rePorsBtn", "santionSave", "POST `/api/common/revertDetail/santionSave`", "jData, sanctionList", "rst=success", "rebtnYn Y/N", "저장 실패 메시지"),
            ("12", "재스캔", "사용자", "reScanBtn", "재스캔 요청", "POST `/api/common/revertDetail/updateReScanNed`", "inptMstSrno", "요청 결과", "—", "—"),
            ("13", "재추출", "사용자", "reExtractionBtn", "CRF 재추출", "POST `/api/common/revertDetail/reCrf`", "inptMstSrno", "요청 결과", "—", "—"),
            ("14", "B/L번호 수정", "사용자", "모달 오픈", "ModiBlNum 팝업", "POST `/api/common/revertDetail/ModiBlNum`", "B/L번호", "갱신 후 reload", "—", "—"),
            ("15", "팝업 종료", "사용자", "닫기", "opener.tableReload() 호출", "—", "—", "ToDo 목록 갱신", "—", "—"),
        ],
        "events": [
            ("fn_blTabClickEvt", "B/L 탭 전환 → 문서분류/결과 재바인딩"),
            ("fn_itemClickEvt", "문서분류 전환 → 이미지 교체"),
            ("fn_Zoom / fn_rotate", "이미지 확대·회전"),
            ("fn_setTmpParam", "저장/상신 공통 파라미터 구성"),
        ],
        "apis": [
            ("POST `/api/common/detail/load`", "최초 로드"),
            ("POST `/api/common/detail/reload`", "부분 재로드"),
            ("POST `/api/common/revertDetail/inspection`", "임시저장+TA"),
            ("POST `/api/common/revertDetail/santionSave`", "결재상신"),
            ("POST `/api/common/revertDetail/updateReScanNed`", "재스캔"),
            ("POST `/api/common/revertDetail/reCrf`", "재추출"),
        ],
        "states": [
            ("aiInptAcvtCd=80", "수기대상 → 심사진행 버튼"),
            ("aiInptAcvtCd=90", "검토대상 → 재심사+완료 버튼"),
            ("CheackCd=50 + btnFlag A", "load 시 nextAiInspAtvtCd=90 갱신"),
        ],
    },
}

# 목록형 화면 공통 템플릿 확장
LIST_SCREEN_DEFAULTS = {
    "1020": ("진행업무별 현재상태", "1020", "revert/status/list.jsp", "/revert/status", "GET /api/revert/status", "1020_진행업무별_현재상태.bpmn", "재추출·심사·결재 진행/완료 건 조회"),
    "1030": ("업무미생성목록", "1030", "revert/ungenerated/list.jsp", "/revert/ungenerated", "GET /api/revert/ungenerated", "1030_업무미생성목록.bpmn", "WINI 접수 후 미생성 업무 관리"),
    "2010": ("결재자 ToDoList", "2010", "app/todo/list.jsp", "/app/todo", "GET /api/app/todo", "2010_결재자_ToDoList.bpmn", "결재 대상 조회·일괄승인·건당 결재"),
    "2020": ("결재자 진행상태", "2020", "app/status/list.jsp", "/app/status", "GET /api/app/status", "2020_결재자_진행상태.bpmn", "승인/반려/Block 처리 이력"),
    "3010": ("QA ToDoList", "3010", "qa/todo/list.jsp", "/qa/todo", "GET /api/qa/todo", "3010_QA_ToDoList.bpmn", "QA 배정 건 조회·처리"),
    "3020": ("QA 진행상태", "3020", "qa/status/list.jsp", "/qa/status", "GET /api/qa/status", "3020_QA_진행상태.bpmn", "QA 결재 진행/완료 건"),
    "4010": ("업무생성목록", "4010", "revert/stat/all/list.jsp", "/revert/stat/all", "GET /api/revert/stat/all", "4010_업무생성목록.bpmn", "스캔 전 심사대상"),
    "4020": ("담당자별 진행현황", "4020", "revert/stat/status/list.jsp", "/revert/stat/status", "GET /api/revert/stat/status", "4020_담당자별_진행현황.bpmn", "담당자별 진행 중"),
    "4030": ("심사완료명세", "4030", "revert/stat/complete/list.jsp", "/revert/stat/complete", "GET /api/revert/stat/complete", "4030_심사완료명세.bpmn", "승인/Block 완료"),
    "4040": ("심사오류명세", "4040", "revert/stat/error/list.jsp", "/revert/stat/error", "GET /api/revert/stat/error", "4040_심사오류명세.bpmn", "수기보정/재스캔/재추출 이력"),
    "4050": ("경보발생명세", "4050", "revert/stat/alert/list.jsp", "/revert/stat/alert", "GET /api/revert/stat/alert", "4050_경보발생명세.bpmn", "경보 발생 이력"),
    "5010": ("업무마감", "5010", "task/log/end/list.jsp", "/task/log/end", "GET/POST /api/task/log/end", "5010_업무마감.bpmn", "일별 마감 조회·저장"),
    "5020": ("업무일지 등록", "5020", "task/log/reg/list.jsp", "/task/log/reg", "GET/POST /api/task/log/reg", "5020_업무일지_등록.bpmn", "일별 건수 수기등록"),
    "5030": ("업무일지 조회", "5030", "task/log/inquiry/list.jsp", "/task/log/inquiry", "GET /api/task/log/inquiry", "5030_업무일지_조회.bpmn", "기간별 일지·차트"),
    "5040": ("성과관리", "5040", "task/log/result/list.jsp", "/task/log/result", "GET /api/task/log/result", "5040_성과관리.bpmn", "직원별 처리건수"),
    "6010": ("성능분석", "6010", "stat/analysis/list.jsp", "/stat/analysis", "GET /api/stat/analysis", "6010_성능분석.bpmn", "일자별 정상/오류 분석"),
    "6020": ("업무별 통계", "6020", "stat/task/list.jsp", "/stat/task", "GET /api/stat/task", "6020_업무별_통계.bpmn", "담당자별 건수·시간"),
    "6030": ("항목별 통계", "6030", "stat/item/list.jsp", "/stat/item", "GET /api/stat/item", "6030_항목별_통계.bpmn", "항목별 거래건수 그래프"),
    "6040": ("조건별 통계", "6040", "stat/cond/list.jsp", "/stat/cond", "GET /api/stat/cond", "6040_조건별_통계.bpmn", "조건별 심사명세"),
    "6050": ("고객별 통계", "6050", "stat/user/list.jsp", "/stat/user", "GET /api/stat/user/*", "6050_고객별_통계.bpmn", "고객별 거래·Pending/Block"),
}

ADMIN_SCREENS = {
    "7010": ("사용자 관리", "7010", "admin/user/list.jsp", "/admin/user", "GET/POST /api/admin/user/*", "7010_사용자_관리.bpmn", "사용자 CRUD"),
    "7021": ("로그인 이력관리", "7021", "admin/log/login/list.jsp", "/admin/log/login", "GET /api/admin/log/login", "7021_로그인_이력관리.bpmn", "로그인 이력 조회"),
    "7022": ("프로그램 사용 이력", "7022", "admin/log/program/list.jsp", "/admin/log/program", "GET /api/admin/log/program", "7022_프로그램_사용이력.bpmn", "화면별 사용 이력"),
    "7030": ("권한별 메뉴 관리", "7030", "admin/menu/list.jsp", "/admin/menu", "GET/POST /api/admin/menu/*", "7030_권한별_메뉴관리.bpmn", "권한-화면 매핑"),
    "7031": ("메뉴등록", "7031", "admin/menu/menuReg.jsp", "/admin/menu/menuReg", "GET/POST /api/admin/menu/reg*", "7031_메뉴등록.bpmn", "메뉴 CRUD"),
    "7040": ("WatchList 등록", "7040", "admin/watchlist/watchInfo.jsp", "/admin/watchlist", "GET/POST /api/admin/watchlist/*", "7040_WatchList_등록.bpmn", "카테고리/리스트/내용"),
    "7050": ("제재 Rule 등록", "7050", "admin/sanction/sanctionInfo.jsp", "/admin/sanction", "GET/POST /api/admin/sanction/*", "7050_제재Rule_등록.bpmn", "TotalText/항목 Rule"),
    "7060": ("QA선정 관리", "7060", "admin/qa/target.jsp", "/admin/qa/target", "GET/POST /api/admin/qa/target", "7060_QA선정_관리.bpmn", "QA 배정 Rule"),
    "7070": ("부재 관리", "7070", "admin/absence/list.jsp", "/admin/absence", "GET/POST /api/admin/absence/*", "7070_부재_관리.bpmn", "부재정보 관리"),
    "7080": ("업무 재할당", "7080", "admin/retask/list.jsp", "/admin/retask", "GET/POST /api/admin/retask/*", "7080_업무_재할당.bpmn", "업무 재배정"),
    "7090": ("일괄결재 의견 관리", "7090", "admin/app/memo/list.jsp", "/admin/app/memo", "GET/POST /api/admin/app/memo/*", "7090_일괄결재_의견관리.bpmn", "일괄승인 의견 템플릿"),
    "8010": ("국가코드관리", "8010", "admin/nation/list.jsp", "/admin/nation", "GET/POST /api/admin/nation/*", "8010_국가코드관리.bpmn", "국가코드 CRUD"),
    "8020": ("공통코드관리", "8020", "admin/code/list.jsp", "/admin/code", "GET/POST /api/admin/code/*", "8020_공통코드관리.bpmn", "그룹/코드 CRUD"),
    "8030": ("영업일 관리", "8030", "admin/businessday/list.jsp", "/admin/businessday", "GET/POST /api/admin/businessday/*", "8030_영업일_관리.bpmn", "영업일 캘린더"),
    "8040": ("도시항구관리", "8040", "admin/city/list.jsp", "/admin/city", "GET/POST /api/admin/city/*", "8040_도시항구관리.bpmn", "도시·항구 CRUD"),
    "8050": ("시스템심사진행현황", "8050", "admin/status/list.jsp", "/admin/status", "GET/POST /api/admin/status/*", "8050_시스템심사진행현황.bpmn", "진행 모니터링·재처리"),
    "8051": ("재처리 정보 등록", "8051", "admin/status/reprocessing.jsp", "/admin/status/reg", "GET/POST /api/admin/status/reg*", "8051_재처리정보_등록.bpmn", "재처리 SQL 등록"),
    "8060": ("후보정용어관리", "8060", "admin/word/correction.jsp", "/admin/word/correction", "GET/POST /api/admin/word/correction/*", "8060_후보정용어관리.bpmn", "후보정 용어 CRUD"),
}

EXTRA_SCREENS = {
    "BLMOD": {
        "title": "SCR-1011-BL — B/L번호 수정",
        "screen_no": "1011",
        "jsp": "`WEB-INF/jsp/revert/detail/ModiBlNum.jsp`",
        "url": "`/revert/detail/ModiBlNum`",
        "bpmn": "1011_BL번호수정.bpmn",
        "purpose": "심사상세에서 B/L 번호를 수정합니다.",
        "pre": ["심사상세 팝업에서 호출"],
        "post": ["B/L번호 DB 반영", "상세 화면 갱신"],
        "ui": ["B/L번호 입력 필드", "저장/취소 버튼"],
        "steps": [
            ("1", "모달 오픈", "사용자", "심사상세에서 호출", "ModiBlNum JSP 로드", "RevertDetailController", "inptMstSrno", "입력 폼", "—", "—"),
            ("2", "번호 입력", "사용자", "키보드 입력", "유효성 검증(클라이언트)", "—", "B/L번호", "—", "—", "빈값 오류"),
            ("3", "저장", "사용자", "저장 클릭", "API 호출", "POST `/api/common/revertDetail/ModiBlNum`", "inptMstSrno, blNum", "성공/실패", "—", "API 오류 메시지"),
            ("4", "갱신", "클라이언트", "저장 성공", "opener 상세 reload", "fn_getBLData", "—", "갱신된 B/L", "—", "—"),
        ],
        "events": [], "apis": [("POST `/api/common/revertDetail/ModiBlNum`", "B/L번호 저장")],
    },
    "BUNDLE": {
        "title": "SCR-2010-BUNDLE — 일괄승인 팝업",
        "screen_no": "2010",
        "jsp": "`WEB-INF/jsp/app/todo/bundle.jsp`",
        "url": "POST `/app/todo/bundle`",
        "bpmn": "2010_일괄승인팝업.bpmn",
        "purpose": "선택된 결재 건을 일괄 승인합니다.",
        "pre": ["2010 화면에서 건 선택", "결재자 권한"],
        "post": ["일괄 승인 완료", "ToDo 목록 갱신"],
        "ui": ["대상 목록", "결재의견 입력", "템플릿 선택", "확인/취소"],
        "steps": [
            ("1", "팝업 오픈", "사용자", "일괄승인 버튼", "bundle.jsp POST", "fnOpenAppTodoBundlePopup", "선택 inptMstSrno 목록", "팝업", "—", "미선택 시 알림"),
            ("2", "대상 로드", "시스템", "팝업 onload", "일괄대상 API", "GET `/api/app/todo/bundle`", "선택 키", "대상 목록", "—", "—"),
            ("3", "의견 입력", "사용자", "텍스트/템플릿", "결재의견 작성", "7090 템플릿 연동 가능", "의견 텍스트", "—", "—", "—"),
            ("4", "일괄승인", "사용자", "확인", "일괄 API", "POST `/api/app/todo/bundle`", "대상목록+의견", "처리결과", "—", "부분 실패 시 메시지"),
            ("5", "종료", "시스템", "처리 완료", "opener 재조회", "tableReload", "—", "갱신 목록", "—", "—"),
        ],
        "events": [("fnOpenAppTodoBundlePopup", "일괄승인 팝업 호출")],
        "apis": [
            ("GET `/api/app/todo/bundle`", "대상 조회"),
            ("POST `/api/app/todo/bundle`", "일괄승인 처리"),
        ],
    },
    "2011": {
        "title": "SCR-2011 — 결재자 심사상세",
        "screen_no": "2011",
        "jsp": "`WEB-INF/jsp/app/detail/revert/detail.jsp`",
        "url": "POST `/app/detail/revert`",
        "bpmn": "2011_결재자_심사상세.bpmn",
        "purpose": "심사 결과를 검토하고 승인/반려/Block/Pending 처리합니다.",
        "pre": ["결재자 권한(02)", "btnFlag=B", "결재 대상 건"],
        "post": ["결재 처리 완료", "업무 상태 전이"],
        "ui": ["심사상세 공통 UI", "승인/반려/Block/Pending 버튼"],
        "steps": [
            ("1", "접근권한", "서버", "POST 진입", "selectCheckAccess schGbn=02", "AppDetailController", "inptMstSrno", "권한 OK", "실패→닫기", "—"),
            ("2", "상세 로드", "클라이언트", "onload", "fn_getBLData('B')", "POST `/api/common/detail/load`", "btnFlag=B", "심사결과(읽기+의견)", "—", "—"),
            ("3", "결과 검토", "결재자", "화면 확인", "TotalText/항목/SW/이미지 검토", "—", "—", "—", "—", "—"),
            ("4", "의견 입력", "결재자", "전달의견", "aiInptPrcOpiTxt 입력", "—", "의견(4000byte)", "—", "—", "—"),
            ("5", "승인", "결재자", "apprBtn", "santionApprv", "POST `/api/common/revertDetail/santionApprv`", "jData, btnFlag=승인", "rst=success", "QA배정 여부", "권한없음 403"),
            ("6", "반려", "결재자", "returnBtn", "cancelApprv", "POST `/api/common/revertDetail/cancelApprv`", "jData", "심사자 반환", "—", "—"),
            ("7", "Block", "결재자", "blockBtn", "santionApprv Block", "동일 API", "btnFlag=Block", "Block 완료", "—", "—"),
            ("8", "Pending", "결재자", "pendingBtn", "santionApprv Pending", "동일 API", "btnFlag=Pending", "보류 상태", "acvtCd!=130", "—"),
            ("9", "종료", "결재자", "닫기", "opener 재조회", "—", "—", "ToDo 갱신", "—", "—"),
        ],
        "events": [
            ("apprBtn", "승인 → santionApprv"),
            ("returnBtn", "반려 → cancelApprv"),
            ("blockBtn", "Block 처리"),
            ("pendingBtn", "Pending 보류"),
        ],
        "apis": [
            ("POST `/api/common/revertDetail/santionApprv`", "승인/Block/Pending"),
            ("POST `/api/common/revertDetail/cancelApprv`", "반려"),
        ],
        "states": [
            ("auth=02", "결재자 권한"),
            ("aiInptAcvtCd=130", "Pending 버튼 비활성"),
        ],
    },
    "2011QA": {
        "title": "SCR-2011-QA — 결재자 QA상세",
        "screen_no": "2011",
        "jsp": "`WEB-INF/jsp/app/detail/qa/detail.jsp`",
        "url": "POST `/app/detail/qa`",
        "bpmn": "2011_결재자_심사상세.bpmn",
        "purpose": "QA 자체점검 결과를 결재(승인/반려)합니다.",
        "pre": ["QA결재자 권한", "btnFlag=D"],
        "post": ["QA 결재 완료"],
        "ui": ["QA 상세 UI", "승인/반려 버튼"],
        "steps": [
            ("1", "상세 로드", "클라이언트", "onload", "fn_getBLData('D')", "POST `/api/common/detail/load`", "btnFlag=D", "QA 결과", "—", "—"),
            ("2", "QA 검토", "결재자", "화면 확인", "원심사 vs QA 결과 비교", "—", "—", "—", "—", "—"),
            ("3", "승인/반려", "결재자", "apprBtn/returnBtn", "QaApprv", "POST `/api/common/revertDetail/QaApprv`", "jData, btnFlag", "rst=success", "auth=04", "—"),
            ("4", "종료", "결재자", "닫기", "opener 재조회", "—", "—", "QA ToDo 갱신", "—", "—"),
        ],
        "events": [], "apis": [("POST `/api/common/revertDetail/QaApprv`", "QA 결재")],
    },
    "3011": {
        "title": "SCR-3011 — QA상세",
        "screen_no": "3011",
        "jsp": "`WEB-INF/jsp/qa/detail/detail.jsp`",
        "url": "POST `/qa/detail`",
        "bpmn": "3011_QA상세.bpmn",
        "purpose": "자체점검 수행 후 결재상신합니다.",
        "pre": ["QA담당자 권한(03)", "btnFlag=C", "QA 배정 건"],
        "post": ["QA 저장/상신 완료"],
        "ui": ["심사상세 공통 UI", "완료(상신) 버튼"],
        "steps": [
            ("1", "상세 로드", "클라이언트", "onload", "fn_getBLData('C')", "POST `/api/common/detail/load`", "btnFlag=C", "원심사+문서", "—", "—"),
            ("2", "자체점검", "QA담당자", "결과 검토", "TotalText/항목/SW 재검토", "—", "—", "—", "—", "—"),
            ("3", "저장", "QA담당자", "tmpSaveBtn", "inspection", "POST `/api/common/revertDetail/inspection`", "jData", "임시저장", "—", "—"),
            ("4", "결재상신", "QA담당자", "porsBtn/rePorsBtn", "santionSave 또는 QA상신", "POST `/api/common/revertDetail/santionSave`", "jData", "QA결재 대기", "rebtnYn", "—"),
            ("5", "종료", "QA담당자", "닫기", "opener 재조회", "—", "—", "QA ToDo 갱신", "—", "—"),
        ],
        "events": [], "apis": [
            ("POST `/api/common/detail/load`", "로드"),
            ("POST `/api/common/revertDetail/inspection`", "저장"),
            ("POST `/api/common/revertDetail/santionSave`", "상신"),
        ],
    },
    "9080": {
        "title": "SCR-9080 — 심사이력",
        "screen_no": "9080",
        "jsp": "`WEB-INF/jsp/common/revert/history/list.jsp`",
        "url": "POST `/common/revert/history`",
        "bpmn": "9080_심사이력.bpmn",
        "purpose": "Ref.No 기준 심사 처리 이력 및 첨부를 관리합니다.",
        "pre": ["inptMstSrno, actlFxRefno 전달"],
        "post": ["이력 조회 또는 첨부 처리 완료"],
        "ui": ["이력 타임라인", "첨부 업로드", "의견 수정"],
        "steps": [
            ("1", "이력 조회", "시스템", "팝업 로드", "이력 API", "GET `/api/common/revert/history`", "inptMstSrno", "이력 목록", "—", "—"),
            ("2", "첨부 업로드", "사용자", "파일 선택", "업로드 API", "POST `/api/common/revert/history/upload`", "multipart", "첨부 ID", "—", "—"),
            ("3", "의견 수정", "사용자", "수정 저장", "updateOpt API", "POST `/api/common/revert/history/updateOpt`", "의견 텍스트", "갱신 결과", "—", "—"),
            ("4", "첨부 삭제", "사용자", "삭제", "delUploadedFile", "GET `/api/common/revert/history/delUploadedFile`", "fileId", "삭제", "—", "—"),
        ],
        "events": [("fnHistoryWin", "이력 팝업 호출")],
        "apis": [
            ("GET `/api/common/revert/history`", "이력 목록"),
            ("POST `/api/common/revert/history/upload`", "첨부"),
            ("POST `/api/common/revert/history/updateOpt`", "의견"),
        ],
    },
    "9090": {
        "title": "SCR-9090 — QA이력",
        "screen_no": "9090",
        "jsp": "`WEB-INF/jsp/common/qa/history/list.jsp`",
        "url": "POST `/common/qa/history`",
        "bpmn": "9090_QA이력.bpmn",
        "purpose": "QA 처리 이력 및 첨부를 관리합니다.",
        "pre": ["QA 이력 조회 파라미터"],
        "post": ["이력/첨부 처리 완료"],
        "ui": ["이력 목록", "첨부"],
        "steps": [
            ("1", "이력 조회", "시스템", "팝업 로드", "GET `/api/common/qa/history`", "—", "키", "이력", "—", "—"),
            ("2", "첨부 업로드", "사용자", "업로드", "POST `/api/common/qa/history/upload`", "—", "file", "결과", "—", "—"),
            ("3", "의견 수정", "사용자", "수정", "POST `/api/common/qa/history/updateOpt`", "—", "의견", "결과", "—", "—"),
        ],
        "events": [], "apis": [("GET `/api/common/qa/history`", "QA 이력")],
    },
    "9010": {
        "title": "SCR-9010 — 심사상세(이력)",
        "screen_no": "9010",
        "jsp": "`WEB-INF/jsp/common/history/detail.jsp`",
        "url": "`/common/history`",
        "bpmn": "9010_심사상세_이력.bpmn",
        "purpose": "이력 기반 심사상세를 읽기전용으로 조회합니다.",
        "pre": ["이력 파라미터", "btnFlag=E"],
        "post": ["조회 완료"],
        "ui": ["심사상세 UI(버튼 비활성)"],
        "steps": [
            ("1", "로드", "클라이언트", "onload", "fn_getBLData('E')", "POST `/api/common/detail/load`", "btnFlag=E", "읽기전용 데이터", "—", "—"),
            ("2", "표시", "시스템", "load 성공", "저장/상신 버튼 미표시", "fn_setBtn", "—", "조회 UI", "—", "—"),
        ],
        "events": [], "apis": [("POST `/api/common/detail/load`", "이력 상세")],
    },
    "9020": {
        "title": "SCR-9020 — QA상세(이력)",
        "screen_no": "9020",
        "jsp": "`WEB-INF/jsp/common/history/qa/detail.jsp`",
        "url": "`/common/history/qa`",
        "bpmn": "9020_QA상세_이력.bpmn",
        "purpose": "이력 기반 QA상세를 읽기전용으로 조회합니다.",
        "pre": ["btnFlag=F"],
        "post": ["조회 완료"],
        "ui": ["QA 상세 UI(읽기전용)"],
        "steps": [
            ("1", "로드", "클라이언트", "onload", "fn_getBLData('F')", "POST `/api/common/detail/load`", "btnFlag=F", "QA 이력 데이터", "—", "—"),
        ],
        "events": [], "apis": [("POST `/api/common/detail/load`", "QA 이력 상세")],
    },
    "USER_MODAL": {
        "title": "공통 — 사용자 조회 모달",
        "screen_no": "—",
        "jsp": "`WEB-INF/jsp/common/user.jsp`",
        "url": "`/common/user`",
        "bpmn": "—",
        "purpose": "관리자 화면 등에서 사용자 검색·선택 팝업을 제공합니다.",
        "pre": ["모달 호출 화면에서 trigger"],
        "post": ["사용자 선택 또는 취소"],
        "ui": ["검색조건", "사용자 목록", "선택 버튼"],
        "steps": [
            ("1", "모달 오픈", "부모화면", "사용자 검색 버튼", "모달 표시", "—", "—", "모달", "—", "—"),
            ("2", "검색", "사용자", "조회", "GET `/api/common/user`", "—", "검색조건", "사용자 목록", "—", "—"),
            ("3", "선택", "사용자", "행 선택", "부모 콜백", "—", "userId", "선택값 반환", "—", "—"),
        ],
        "events": [], "apis": [("GET `/api/common/user`", "사용자 검색")],
    },
    "FILE_MODAL": {
        "title": "공통 — 파일 업로드 모달",
        "screen_no": "—",
        "jsp": "`WEB-INF/jsp/common/file.jsp`",
        "url": "`/common/file`",
        "bpmn": "—",
        "purpose": "공통 파일 업로드 fragment입니다.",
        "pre": ["include 화면에서 호출"],
        "post": ["파일 업로드 완료"],
        "ui": ["파일 선택", "업로드 버튼"],
        "steps": [
            ("1", "모달 표시", "부모", "업로드 클릭", "file.jsp include", "—", "—", "모달", "—", "—"),
            ("2", "업로드", "사용자", "파일+전송", "부모 정의 action URL", "—", "file", "결과", "—", "—"),
        ],
        "events": [], "apis": [],
    },
    "MAP": {
        "title": "공통 — 국가별 지도",
        "screen_no": "—",
        "jsp": "`WEB-INF/jsp/common/map.jsp`",
        "url": "`/common/map`",
        "bpmn": "—",
        "purpose": "대시보드·통계에서 국가별 수출입 현황 지도를 표시합니다.",
        "pre": ["부모 화면에서 include", "국가별 데이터 전달"],
        "post": ["지도 렌더링"],
        "ui": ["지도 Canvas/SVG"],
        "steps": [
            ("1", "include", "부모", "화면 로드", "map.jsp 삽입", "—", "국가 데이터", "지도 영역", "—", "—"),
            ("2", "렌더링", "클라이언트", "데이터 바인딩", "국가별 마커/색상", "—", "수출입 건수", "지도", "—", "—"),
        ],
        "events": [], "apis": [],
    },
}


def make_list_screen(sid, name, screen_no, jsp, url, api, bpmn, purpose):
    return {
        "title": f"SCR-{screen_no} — {name}",
        "screen_no": screen_no,
        "jsp": f"`WEB-INF/jsp/{jsp}`",
        "url": f"`{url}`",
        "bpmn": bpmn,
        "purpose": purpose,
        "pre": ["로그인 완료", "해당 화면 메뉴 권한"],
        "post": ["목록 표시 또는 처리 완료"],
        "ui": ["검색영역 `.searchWrap`", "DataTable", "조회/초기화 버튼"],
        "steps": [
            ("1", "화면 초기화", "시스템", "iframe 로드", "로딩·검색 기본값", "initLoadingDisplay", "—", "검색 폼", "—", "—"),
            ("2", "프로그램 이력", "시스템", "조회 시", "fnCmnProgramLog", f"화면번호 {screen_no}", "검색 파라미터", "이력", "—", "—"),
            ("3", "검색조건 입력", "사용자", "필드 입력", "getSearchOption()", "—", "검색 필드", "options 객체", "—", "유효성 오류"),
            ("4", "목록 조회", "사용자", "조회 버튼", "REST API 호출", api, "searchVO", "resultList", "—", "세션 만료"),
            ("5", "목록 렌더링", "클라이언트", "API 응답", "DataTable 바인딩", "datatable.jsp", "resultList", "그리드", "—", "—"),
            ("6", "행 액션", "사용자", "행 클릭/버튼", "상세/처리/엑셀", "화면별 JS", "행 키", "팝업/다운로드", "화면별", "권한 오류"),
            ("7", "재조회", "시스템/사용자", "처리 후", "searchList()", "—", "—", "갱신 목록", "—", "—"),
        ],
        "events": [("searchBtn click", "목록 조회"), ("search-reset", "검색 초기화")],
        "apis": [(api.split()[0] + " " + api.split()[1] if " " in api else api, purpose)],
    }


def build_all_screens():
    all_s = dict(SCREENS)
    all_s.update(EXTRA_SCREENS)
    for sid, tup in LIST_SCREEN_DEFAULTS.items():
        if sid not in all_s:
            all_s[sid] = make_list_screen(sid, *tup)
    for sid, tup in ADMIN_SCREENS.items():
        if sid not in all_s:
            all_s[sid] = make_list_screen(sid, *tup)
            # 관리 화면 추가 단계
            all_s[sid]["steps"].extend([
                ("8", "등록/수정", "관리자", "저장 버튼", "POST insert/update", tup[4], "폼 데이터", "rst", "—", "검증 오류"),
                ("9", "삭제", "관리자", "삭제 버튼", "POST delete", tup[4], "키", "삭제 결과", "확인 다이얼로그", "참조 무결성"),
            ])
    return all_s


def render_screen(sid, data, basic_doc):
    lines = [
        f"## {data['title']}",
        "",
        f"> **기본 프로세스:** [{basic_doc}](../{basic_doc})",
        "",
        "### 1. 화면 개요",
        "",
        "| 항목 | 내용 |",
        "|------|------|",
        f"| 화면번호 | {data['screen_no']} |",
        f"| JSP | {data['jsp']} |",
        f"| URL | {data['url']} |",
    ]
    if data.get("bpmn") and data["bpmn"] != "—":
        lines.append(f"| BPMN | [{data['bpmn']}](../../bpmn/{data['bpmn']}) |")
    lines += [
        "",
        "**화면 목적**",
        "",
        data["purpose"],
        "",
        "### 2. 선행 조건 / 종료 조건",
        "",
        "| 구분 | 조건 |",
        "|------|------|",
    ]
    for p in data.get("pre", []):
        lines.append(f"| 선행 | {p} |")
    for p in data.get("post", []):
        lines.append(f"| 종료 | {p} |")
    lines += [
        "",
        "### 3. 화면 구성",
        "",
    ]
    for ui in data.get("ui", []):
        lines.append(f"- {ui}")
    lines += [
        "",
        "### 4. 상세 처리 흐름",
        "",
        "| 순번 | 단계 | 담당 | 트리거 | 처리 내용 | API/함수 | 입력 | 출력 | 분기 | 예외 |",
        "|------|------|------|--------|----------|----------|------|------|------|------|",
    ]
    for step in data.get("steps", []):
        lines.append("| " + " | ".join(step) + " |")
    if data.get("events"):
        lines += ["", "### 5. 이벤트 / 함수 매핑", "", "| 이벤트/함수 | 설명 |", "|------------|------|"]
        for ev, desc in data["events"]:
            lines.append(f"| {ev} | {desc} |")
    if data.get("apis"):
        lines += ["", "### 6. API 목록", "", "| API | 설명 |", "|-----|------|"]
        for api, desc in data["apis"]:
            lines.append(f"| {api} | {desc} |")
    if data.get("states"):
        lines += ["", "### 7. 상태 / 코드", "", "| 코드/조건 | 설명 |", "|----------|------|"]
        for code, desc in data["states"]:
            lines.append(f"| {code} | {desc} |")
    lines += ["", "---", ""]
    return "\n".join(lines)


def render_domain(filename, domain_name, basic_doc, screen_ids, all_screens):
    basic_name = os.path.basename(basic_doc)
    content = [
        f"# {domain_name} — 상세 프로세스 정의서",
        "",
        f"> [상세 목차](./목차.md) | [기본 프로세스](../{basic_name}) | [전체 목차](../목차.md)",
        "",
        "본 문서는 기본 프로세스 정의서를 보완하는 **상세 처리 흐름** 문서입니다.",
        "각 화면별 단계·API·입출력·분기·예외를 소스코드 기준으로 기술합니다.",
        "",
        "---",
        "",
    ]
    for sid in screen_ids:
        if sid in all_screens:
            content.append(render_screen(sid, all_screens[sid], basic_name))
    return "\n".join(content)


def render_index():
    lines = [
        "# 상세 프로세스 정의서 목차",
        "",
        "> **기본 프로세스:** [../목차.md](../목차.md) (기존 문서 유지)",
        "",
        "본 문서군은 화면별 **단계별 처리 흐름, API 입출력, 이벤트, 상태코드**를 상세 기술합니다.",
        "",
        "## 문서 구조",
        "",
        "| 구분 | 경로 | 설명 |",
        "|------|------|------|",
        "| 기본 프로세스 | `docs/process/*.md` | 화면 개요·요약 흐름 (유지) |",
        "| **상세 프로세스** | `docs/process/상세/*.md` | 단계별 상세 처리 정의 |",
        "| BPMN | `docs/bpmn/*.bpmn` | 프로세스 다이어그램 |",
        "",
        "## 상세 문서 목록",
        "",
        "| # | 상세 문서 | 기본 문서 | 화면 수 |",
        "|---|----------|----------|---------|",
    ]
    for i, (fname, dname, basic, sids) in enumerate(DOMAINS):
        lines.append(f"| {i:02d} | [{fname}](./{fname}) | [{os.path.basename(basic)}](../{os.path.basename(basic)}) | {len(sids)} |")
    lines += [
        "",
        "## 상세 정의서 항목 구조",
        "",
        "각 화면은 다음 섹션으로 구성됩니다.",
        "",
        "1. **화면 개요** — 기본 정보, BPMN 링크",
        "2. **선행/종료 조건**",
        "3. **화면 구성** — UI 영역",
        "4. **상세 처리 흐름** — 순번·담당·트리거·API·입출력·분기·예외",
        "5. **이벤트/함수 매핑**",
        "6. **API 목록**",
        "7. **상태/코드** (해당 시)",
        "",
        "## 관련 문서",
        "",
        "- [심사상세 이미지 뷰어 전략](../revert-detail-image-viewer-strategy.md)",
        "- [심사상세 이미지 뷰어 가이드](../revert-detail-image-viewer-guide.md)",
        "",
    ]
    return "\n".join(lines)


def main():
    os.makedirs(OUTPUT_DIR, exist_ok=True)
    all_screens = build_all_screens()

    with open(os.path.join(OUTPUT_DIR, "목차.md"), "w", encoding="utf-8") as f:
        f.write(render_index())

    for fname, dname, basic, sids in DOMAINS:
        path = os.path.join(OUTPUT_DIR, fname)
        with open(path, "w", encoding="utf-8") as f:
            f.write(render_domain(fname, dname, basic, sids, all_screens))
        print(f"Generated: {path}")

    # 기본 목차에 상세 링크 추가
    main_index = os.path.join(os.path.dirname(OUTPUT_DIR), "목차.md")
    with open(main_index, "r", encoding="utf-8") as f:
        content = f.read()
    if "## 8. 상세 프로세스 정의서" not in content:
        insert = (
            "\n---\n\n"
            "## 8. 상세 프로세스 정의서\n\n"
            "기본 프로세스 정의서를 보완하는 **단계별 상세 처리 문서**입니다.\n\n"
            "| 문서 | 설명 |\n|------|------|\n"
            "| [상세/목차.md](./상세/목차.md) | 상세 프로세스 정의서 목차 |\n\n"
            "상세 문서에는 화면별 **선행/종료 조건, UI 구성, 단계별 API·입출력·분기·예외**가 포함됩니다.\n"
        )
        # Insert before "## 7. 관련 문서"
        if "## 7. 관련 문서" in content:
            content = content.replace("## 7. 관련 문서", insert + "## 7. 관련 문서")
        else:
            content += insert
        with open(main_index, "w", encoding="utf-8") as f:
            f.write(content)
        print("Updated main index: 목차.md")

    print(f"Total screens: {len(all_screens)}")


if __name__ == "__main__":
    main()
