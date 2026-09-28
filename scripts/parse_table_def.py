#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Parse 테이블정의서_추출.xlsx and generate DDL + test data SQL (Tibero/Oracle)."""
import json
import re
from pathlib import Path

import openpyxl

ROOT = Path(__file__).resolve().parent.parent
XLSX = ROOT / "테이블정의서_추출.xlsx"
MAPPER_DIR = ROOT / "src/main/resources/egovframework/sqlmap/ui/mappers"
OUT_DIR = ROOT / "sql"

# 매퍼에서 확인된 시퀀스 (NEXTVAL 사용)
SEQUENCES = [
    ("CSPD005TH_SG01", 1000),
    ("CSPD008TH_SG01", 1000),
    ("CSPD102TI_SG01", 1000),
    ("CSPD103TI_SG01", 1000),
    ("CSPD107TI_SG01", 1000),
    ("CSPD110TI_SG01", 1000),
    ("CSPD113TI_SG01", 1000),
]

# DROP 순서: 자식 → 부모 (FK 의존 역순)
DROP_ORDER = [
    "CSPD002TG", "CSPD003TF", "CSPD004TF", "CSPD005TH", "CSPD006TL",
    "CSPD007TL", "CSPD008TH", "CSPD900TI", "CSPD011TL",
    "CSPD009TA", "CSPD010TA", "CSPD104TI",
    "CSPD107TI", "CSPD105TI", "CSPD106TI", "CSPD113TI", "CSPD116TI",
    "CSPD109TI", "CSPD201TM", "CSPD202TM",
    "CSPD811TH", "CSPD810TH", "CSPD110TI", "CSPD117TI",
    "CSPD001TM", "CSPD108TI", "CSPD103TI", "CSPD102TI", "CSPD101TI",
    "CSPD112TI", "CSPD111TI", "CSPD118TI", "CSPD118TM", "CSPD115TI",
]
COMPOSITE_PK = {
    "CSPD002TG": ["INPT_MST_SRNO", "INPT_ELMT_ID", "IMEX_HIS_CD"],
    "CSPD003TF": ["INPT_MST_SRNO", "AI_INPT_TOTALTEXT_SRNO"],
    "CSPD004TF": ["INPT_MST_SRNO", "INPT_SANCTION_NO"],
    "CSPD005TH": ["INPT_MST_SRNO", "AI_INPT_APPV_SRNO"],
    "CSPD006TL": ["INPT_MST_SRNO", "AI_INPT_ATFL_SRNO"],
    "CSPD007TL": ["INPT_MST_SRNO", "AI_INPT_PRG_SRNO"],
    "CSPD008TH": ["INPT_MST_SRNO", "AI_INPT_PRG_SRNO"],
    "CSPD011TL": ["AI_INPT_XT_SRNO"],
    "CSPD107TI": ["AI_INPT_IMEX_DSCD", "AI_INPT_LIST_ID"],
    "CSPD112TI": ["AI_INPT_GRP_CD", "AI_INPT_CMN_CD"],
    "CSPD116TI": ["AI_INPT_RULE_DSCD"],
    "CSPD201TM": ["XPO_CVRG_MK_SQ"],
    "CSPD202TM": ["TDOC_RCP_SRNO"],
    "CSPD900TI": ["INPT_MST_SRNO"],
}

# CSPD900TI: 엑셀 TRN_LOG_SRNO → INPT_MST_SRNO (매퍼 조인 키)
COLUMN_RENAME = {
    "CSPD900TI": {"TRN_LOG_SRNO": "INPT_MST_SRNO"},
}

INPT_MST_SRNO_TYPE = "NUMBER(19)"
TRN_LOG_SRNO_TYPE = "VARCHAR2(60)"

# 엑셀 text → CLOB 대신 VARCHAR2 (매퍼 GROUP BY/TRIM/UPPER/LIKE/= 호환)
COLUMN_TYPE_OVERRIDE = {
    ("CSPD003TF", "INPT_SANCTION_DAT_TXT"): "VARCHAR2(4000)",
    ("CSPD004TF", "INPT_SANCTION_DAT_TXT"): "VARCHAR2(4000)",
    ("CSPD004TF", "ITM_INPT_HNDG_INP_DAT_TXT"): "VARCHAR2(4000)",
}

# 엑셀 누락 · MyBatis 매퍼에서 사용하는 컬럼
EXTRA_COLUMNS = {
    "CSPD001TM": [
        {
            "seq": 50,
            "col": "INPT_ATMC_REQ_DSCD",
            "type": "varchar(32)",
            "nullable": "YES",
            "key": "",
            "class": "",
            "comment": "심사 자동화 요청 구분 코드",
            "source": "MyBatis Mapper",
        },
    ],
    "CSPD003TF": [
        {
            "seq": 2,
            "col": "AI_INPT_ALT_YN",
            "type": "char(1)",
            "nullable": "YES",
            "key": "",
            "class": "",
            "comment": "AI 심사 알림 여부",
            "source": "MyBatis Mapper",
        },
        {
            "seq": 10,
            "col": "ITM_INPT_XAXIS_STA_CRDN_CN",
            "type": "number(20,4)",
            "nullable": "YES",
            "key": "",
            "class": "",
            "comment": "항목 X축 시작 좌표값",
            "source": "MyBatis Mapper",
        },
        {
            "seq": 11,
            "col": "ITM_INPT_YAXIS_STA_CRDN_CN",
            "type": "number(20,4)",
            "nullable": "YES",
            "key": "",
            "class": "",
            "comment": "항목 Y축 시작 좌표값",
            "source": "MyBatis Mapper",
        },
        {
            "seq": 12,
            "col": "ITM_INPT_XAXIS_END_CRDN_CN",
            "type": "number(20,4)",
            "nullable": "YES",
            "key": "",
            "class": "",
            "comment": "항목 X축 종료 좌표값",
            "source": "MyBatis Mapper",
        },
        {
            "seq": 13,
            "col": "ITM_INPT_YAXIS_END_CRDN_CN",
            "type": "number(20,4)",
            "nullable": "YES",
            "key": "",
            "class": "",
            "comment": "항목 Y축 종료 좌표값",
            "source": "MyBatis Mapper",
        },
    ],
    "CSPD004TF": [
        {
            "seq": 20,
            "col": "ITM_INPT_NACRD_YN",
            "type": "char(1)",
            "nullable": "YES",
            "key": "",
            "class": "",
            "comment": "항목별 불일치 여부",
            "source": "MyBatis Mapper",
        },
    ],
    "CSPD007TL": [
        {
            "seq": 7,
            "col": "LST_DB_CHG_DTM",
            "type": "varchar(20)",
            "nullable": "YES",
            "key": "",
            "class": "",
            "comment": "최종 DB 변경 일시",
            "source": "MyBatis Mapper",
        },
    ],
    "CSPD201TM": [
        {
            "seq": 7,
            "col": "INPT_ATMC_REQ_DSCD",
            "type": "varchar(32)",
            "nullable": "YES",
            "key": "",
            "class": "",
            "comment": "심사 자동화 요청 구분 코드",
            "source": "MyBatis Mapper",
        },
        {
            "seq": 8,
            "col": "XPO_CVRG_MTBR_MK_DT",
            "type": "varchar(8)",
            "nullable": "YES",
            "key": "",
            "class": "",
            "comment": "수출 커버링 모점 작성 일자",
            "source": "MyBatis Mapper",
        },
        {
            "seq": 9,
            "col": "TRN_OPR_NO",
            "type": "varchar(64)",
            "nullable": "YES",
            "key": "",
            "class": "",
            "comment": "조작자 사번",
            "source": "MyBatis Mapper",
        },
        {
            "seq": 10,
            "col": "INPT_ATMC_BIZ_DSCD",
            "type": "varchar(32)",
            "nullable": "YES",
            "key": "",
            "class": "",
            "comment": "심사 자동화 업무 구분 코드",
            "source": "MyBatis Mapper",
        },
        {
            "seq": 11,
            "col": "KRBR_NM",
            "type": "varchar(300)",
            "nullable": "YES",
            "key": "",
            "class": "",
            "comment": "영업점명",
            "source": "MyBatis Mapper",
        },
    ],
    "CSPD202TM": [
        {
            "seq": 7,
            "col": "TDOC_RCP_DT",
            "type": "varchar(8)",
            "nullable": "YES",
            "key": "",
            "class": "",
            "comment": "무역서류 접수 일자",
            "source": "MyBatis Mapper",
        },
        {
            "seq": 8,
            "col": "INPT_ATMC_REQ_DSCD",
            "type": "varchar(32)",
            "nullable": "YES",
            "key": "",
            "class": "",
            "comment": "심사 자동화 요청 구분 코드",
            "source": "MyBatis Mapper",
        },
        {
            "seq": 9,
            "col": "TRN_OPR_NO",
            "type": "varchar(64)",
            "nullable": "YES",
            "key": "",
            "class": "",
            "comment": "조작자 사번",
            "source": "MyBatis Mapper",
        },
        {
            "seq": 10,
            "col": "INPT_ATMC_BIZ_DSCD",
            "type": "varchar(32)",
            "nullable": "YES",
            "key": "",
            "class": "",
            "comment": "심사 자동화 업무 구분 코드",
            "source": "MyBatis Mapper",
        },
        {
            "seq": 11,
            "col": "KRBR_NM",
            "type": "varchar(300)",
            "nullable": "YES",
            "key": "",
            "class": "",
            "comment": "영업점명",
            "source": "MyBatis Mapper",
        },
    ],
}

# 메뉴 권한 코드 (CSPD109TI.AI_INPT_AUT_CD) — admin01은 01 + MGPE_YN=Y
MENU_AUTH_CODES = ("01", "02", "03", "04")

# GNB 대메뉴 (menu_id: X00000)
MENU_DOMAIN_ROOTS = [
    ("100000", "선적서류심사"),
    ("200000", "결재"),
    ("300000", "QA"),
    ("400000", "심사현황"),
    ("500000", "업무일지"),
    ("600000", "통계"),
    ("700000", "관리자"),
    ("800000", "시스템관리"),
]

# (화면번호, 메뉴명, URL, 관리자메뉴YN) — list/진입 화면만
MENU_SCREENS = [
    ("1010", "본인작업 ToDoList", "/revert/todo/list.do", "N"),
    ("1020", "진행업무별 현재상태", "/revert/status/list.do", "N"),
    ("1030", "업무미생성목록", "/revert/ungenerated/list.do", "N"),
    ("2010", "결재자 ToDoList", "/app/todo/list.do", "N"),
    ("2020", "결재자 진행상태", "/app/status/list.do", "N"),
    ("3010", "QA ToDoList", "/qa/todo/list.do", "N"),
    ("3020", "QA 진행상태", "/qa/status/list.do", "N"),
    ("4010", "업무생성목록", "/revert/stat/all/list.do", "N"),
    ("4020", "담당자별 진행현황", "/revert/stat/status/list.do", "N"),
    ("4030", "심사완료명세", "/revert/stat/complete/list.do", "N"),
    ("4040", "심사오류명세", "/revert/stat/error/list.do", "N"),
    ("4050", "경보발생명세", "/revert/stat/alert/list.do", "N"),
    ("5010", "업무마감", "/task/log/end/list.do", "N"),
    ("5020", "업무일지 등록", "/task/log/reg/list.do", "N"),
    ("5030", "업무일지 조회", "/task/log/inquiry/list.do", "N"),
    ("5040", "성과관리", "/task/log/result/list.do", "N"),
    ("6010", "성능분석", "/stat/analysis/list.do", "N"),
    ("6020", "업무별 통계", "/stat/task/list.do", "N"),
    ("6030", "항목별 통계", "/stat/item/list.do", "N"),
    ("6040", "조건별 통계", "/stat/cond/list.do", "N"),
    ("6050", "고객별 통계", "/stat/user/list.do", "N"),
    ("7010", "사용자 관리", "/admin/user/list.do", "Y"),
    ("7021", "로그인 이력", "/admin/log/login/list.do", "Y"),
    ("7022", "프로그램 사용 이력", "/admin/log/program/list.do", "Y"),
    ("7030", "권한별 메뉴 관리", "/admin/menu/list.do", "Y"),
    ("7031", "메뉴등록", "/admin/menu/menuReg.do", "Y"),
    ("7040", "WatchList 관리", "/admin/watchlist/watchInfo.do", "Y"),
    ("7050", "제재 Rule 등록", "/admin/sanction/sanctionInfo.do", "Y"),
    ("7060", "QA선정 관리", "/admin/qa/target/list.do", "Y"),
    ("7070", "부재 관리", "/admin/absence/list.do", "Y"),
    ("7080", "업무 재할당", "/admin/retask/list.do", "Y"),
    ("7090", "일괄결재 의견", "/admin/app/memo/list.do", "Y"),
    ("8010", "국가코드관리", "/admin/nation/list.do", "Y"),
    ("8020", "공통코드관리", "/admin/code/list.do", "Y"),
    ("8030", "영업일 관리", "/admin/businessday/list.do", "Y"),
    ("8040", "도시항구관리", "/admin/city/list.do", "Y"),
    ("8050", "시스템심사진행현황", "/admin/status/list.do", "Y"),
    ("8060", "후보정용어관리", "/admin/word/correction/list.do", "Y"),
]


def menu_id_from_screen(screen):
    """화면번호(4자리) → 6자리 menu_id (예: 1010→101010, 7021→702021)."""
    s = str(screen)
    return str(int(s) // 10 * 1000 + int(s[-2:]))


def domain_root_for_screen(screen):
    return str(screen)[0] + "00000"


def build_cspd108ti_seeds():
    """CSPD108TI 메뉴 트리: 대메뉴 + Dashboard + 업무 화면."""
    rows = []
    for root_id, root_nm in MENU_DOMAIN_ROOTS:
        rows.append(("", root_id, root_nm, "", "", "N"))
    rows.append(("100000", "101000", "Dashboard", "", "/dashboard/dashboard", "N"))
    for screen, name, url, mgpe in MENU_SCREENS:
        root = domain_root_for_screen(screen)
        rows.append((root, menu_id_from_screen(screen), name, screen, url, mgpe))
    return rows

TABLE_SEEDS = {
    "CSPD111TI": [
        ("120", "권한코드", "20200101000000", "99991231235959", "Y", "사용자 권한"),
        ("150", "심사자동화업무구분", "20200101000000", "99991231235959", "Y", "업무구분"),
        ("170", "심사결과코드", "20200101000000", "99991231235959", "Y", "결과코드"),
        ("280", "프로세스코드", "20200101000000", "99991231235959", "Y", "프로세스"),
        ("290", "액티비티코드", "20200101000000", "99991231235959", "Y", "액티비티"),
        ("360", "심사진행상태QA", "20200101000000", "99991231235959", "Y", "QA진행상태"),
        ("165", "화면ID", "20200101000000", "99991231235959", "Y", "화면코드"),
        ("200", "제재Rule구분", "20200101000000", "99991231235959", "Y", "제재룰"),
        ("361", "심사처리구분", "20200101000000", "99991231235959", "Y", "처리구분"),
        ("371", "지연기준시간", "20200101000000", "99991231235959", "Y", "지연기준"),
        ("700", "프로그램행위대분류", "20200101000000", "99991231235959", "Y", "로그행위"),
        ("701", "프로그램행위소분류", "20200101000000", "99991231235959", "Y", "로그행위상세"),
        ("905", "도시항구구분", "20200101000000", "99991231235959", "Y", "도시항구"),
    ],
    "CSPD112TI": [
        ("120", "01", "심사자", "Reviewer", "20200101000000", "99991231235959", "Y", "권한-심사자", "1"),
        ("120", "02", "결재자", "Approver", "20200101000000", "99991231235959", "Y", "권한-결재자", "2"),
        ("120", "03", "QA담당자", "QA Officer", "20200101000000", "99991231235959", "Y", "권한-QA", "3"),
        ("120", "04", "일반사용자", "General User", "20200101000000", "99991231235959", "Y", "권한-일반", "4"),
        ("150", "01", "수출", "Export", "20200101000000", "99991231235959", "Y", "업무-수출", "1"),
        ("150", "02", "수입", "Import", "20200101000000", "99991231235959", "Y", "업무-수입", "2"),
        ("170", "01", "정상", "Normal", "20200101000000", "99991231235959", "Y", "결과-정상", "1"),
        ("170", "02", "이상", "Abnormal", "20200101000000", "99991231235959", "Y", "결과-이상", "2"),
        ("280", "01", "심사", "Inspection", "20200101000000", "99991231235959", "Y", "프로세스-심사", "1"),
        ("290", "01", "서류검토", "Doc Review", "20200101000000", "99991231235959", "Y", "액티비티-서류", "1"),
        ("300", "01", "대기", "Waiting", "20200101000000", "99991231235959", "Y", "상태-대기", "1"),
        ("300", "02", "진행중", "In Progress", "20200101000000", "99991231235959", "Y", "상태-진행", "2"),
        ("300", "03", "완료", "Complete", "20200101000000", "99991231235959", "Y", "상태-완료", "3"),
        ("165", "1010", "본인작업ToDo", "Todo Revert", "20200101000000", "99991231235959", "Y", "화면-1010", "1"),
        ("165", "2010", "결재ToDo", "Todo App", "20200101000000", "99991231235959", "Y", "화면-2010", "2"),
        ("165", "3010", "QA ToDo", "Todo QA", "20200101000000", "99991231235959", "Y", "화면-3010", "3"),
        ("200", "01", "Rule유형1", "Rule Type 1", "20200101000000", "99991231235959", "Y", "제재룰", "1"),
        ("361", "01", "자동처리", "Auto", "20200101000000", "99991231235959", "Y", "처리구분", "1"),
        ("361", "03", "수동처리", "Manual", "20200101000000", "99991231235959", "Y", "처리구분", "3"),
        ("371", "01", "30", "Delay 30min", "20200101000000", "99991231235959", "Y", "지연기준분", "30"),
        ("700", "01", "조회", "Select", "20200101000000", "99991231235959", "Y", "프로그램행위", "1"),
        ("701", "01", "등록", "Insert", "20200101000000", "99991231235959", "Y", "프로그램행위", "2"),
        ("905", "01", "도시", "City", "20200101000000", "99991231235959", "Y", "도시항구구분", "1"),
        ("905", "02", "항구", "Port", "20200101000000", "99991231235959", "Y", "도시항구구분", "2"),
    ],
    "CSPD115TI": [
        ("KR", "KOR", "대한민국", "Korea Republic of", "Korea", "Y", "410"),
        ("US", "USA", "미국", "United States of America", "United States", "Y", "840"),
        ("CN", "CHN", "중국", "China", "China", "Y", "156"),
    ],
    "CSPD118TI": [
        ("01", 1, "KR", "SEOUL", "SEOUL METRO", "서울"),
        ("02", 2, "KR", "BUSAN", "BUSAN METRO", "부산항"),
        ("01", 3, "US", "LOS ANGELES", "CALIFORNIA", "로스앤젤레스"),
    ],
    "CSPD101TI": [
        ("reviewer01", "E10001", "01", "N", "김심사", "Y", "N", "20200101000000", "99991231235959"),
        ("approver01", "E10002", "02", "N", "이결재", "Y", "N", "20200101000000", "99991231235959"),
        ("qauser01", "E10003", "03", "N", "박QA", "Y", "N", "20200101000000", "99991231235959"),
        ("admin01", "E10004", "01", "Y", "최관리", "Y", "N", "20200101000000", "99991231235959"),
    ],
    "CSPD001TM": [
        (10001, "E10001", "E10002", "01", "01", "01", "01", "01", "01", "BL20250001", "20250115", "202501"),
        (10002, "E10001", "E10002", "01", "02", "01", "02", "01", "02", "BL20250002", "20250116", "202501"),
        (10003, "E10003", "E10002", "02", "01", "02", "03", "02", "01", "BL20250003", "20250117", "202501"),
    ],
}


TABLE_SEEDS["CSPD108TI"] = build_cspd108ti_seeds()


def parse_excel():
    wb = openpyxl.load_workbook(XLSX, read_only=True, data_only=True)
    ws = wb["테이블정의서"]
    tables = {}
    for i, row in enumerate(ws.iter_rows(values_only=True)):
        if i < 5 or row[0] == "테이블명" or not row[0]:
            continue
        tname = str(row[0]).strip()
        if tname not in tables:
            tables[tname] = {"desc": row[1] or "", "cols": []}
        tables[tname]["cols"].append(
            {
                "seq": row[2],
                "col": str(row[3]).strip() if row[3] else "",
                "type": str(row[4]).strip() if row[4] else "varchar(100)",
                "nullable": row[5],
                "key": row[6] or "",
                "class": row[7] or "",
                "comment": row[8] or "",
                "source": row[9] or "",
            }
        )
    wb.close()
    return merge_extra_columns(tables)


def merge_extra_columns(tables):
    """엑셀에 없는 매퍼 기반 컬럼을 테이블 정의에 병합."""
    for tname, extras in EXTRA_COLUMNS.items():
        if tname not in tables:
            continue
        existing = {c["col"] for c in tables[tname]["cols"]}
        for col in extras:
            if col["col"] not in existing:
                tables[tname]["cols"].append(col)
    return tables


def parse_mappers():
    tables = set()
    pattern = re.compile(
        r"(?:FROM|INTO|UPDATE|JOIN|MERGE\s+INTO)\s+(CSPD[A-Z0-9]+)",
        re.IGNORECASE,
    )
    for f in MAPPER_DIR.glob("*.xml"):
        text = f.read_text(encoding="utf-8", errors="ignore")
        for m in pattern.finditer(text):
            tables.add(m.group(1).upper())
    return sorted(tables)


def to_tibero_type(dtype):
    """Convert Excel/generic types to Tibero/Oracle types."""
    if not dtype:
        return "VARCHAR2(100)"
    d = str(dtype).strip().lower()
    if d == "text":
        return "CLOB"
    m = re.match(r"varchar\((\d+)\)", d)
    if m:
        return f"VARCHAR2({m.group(1)})"
    m = re.match(r"char\((\d+)\)", d)
    if m:
        return f"CHAR({m.group(1)})"
    m = re.match(r"numeric\((\d+),(\d+)\)", d)
    if m:
        return f"NUMBER({m.group(1)},{m.group(2)})"
    if d in ("bigint", "integer"):
        return "NUMBER(19)"
    if d.startswith("varchar2") or d.startswith("number") or d.startswith("clob"):
        return d.upper()
    return d.upper()


def resolve_column(tname, col):
    """컬럼명·타입 보정 (INPT_MST_SRNO, CSPD900TI rename)."""
    cname = col["col"]
    if tname in COLUMN_RENAME and cname in COLUMN_RENAME[tname]:
        cname = COLUMN_RENAME[tname][cname]
    ctype = to_tibero_type(col["type"])
    if cname == "INPT_MST_SRNO":
        ctype = INPT_MST_SRNO_TYPE
    elif cname == "TRN_LOG_SRNO":
        ctype = TRN_LOG_SRNO_TYPE
    elif (tname, cname) in COLUMN_TYPE_OVERRIDE:
        ctype = COLUMN_TYPE_OVERRIDE[(tname, cname)]
    return cname, ctype


def resolve_pk_cols(tname, cols):
    """PK 컬럼명 보정 (rename 반영)."""
    raw = get_pk_cols(tname, cols)
    renames = COLUMN_RENAME.get(tname, {})
    return [renames.get(c, c) for c in raw]


def is_pk(key_val):
    return str(key_val).strip().upper() == "Y"


def get_pk_cols(tname, cols):
    if tname in COMPOSITE_PK:
        return COMPOSITE_PK[tname]
    return [c["col"] for c in cols if is_pk(c["key"])]


def gen_ddl(tables):
    lines = [
        "-- ============================================================",
        "-- AI 심사 시스템 DDL (Tibero/Oracle)",
        "-- Source: 테이블정의서_추출.xlsx + MyBatis Mapper 분석",
        "-- ============================================================",
        "",
    ]

    for tname in sorted(tables.keys()):
        t = tables[tname]
        desc = str(t["desc"] or tname).replace("'", "''")
        lines += [
            f"-- ------------------------------------------------------------",
            f"-- {tname}: {t['desc']}",
            f"-- ------------------------------------------------------------",
            f"CREATE TABLE {tname} (",
        ]

        col_defs = []
        for col in t["cols"]:
            cname, ctype = resolve_column(tname, col)
            col_defs.append(f"    {cname:<32} {ctype}")

        pk_cols = resolve_pk_cols(tname, t["cols"])
        lines.append(",\n".join(col_defs))
        if pk_cols:
            pk_str = ", ".join(pk_cols)
            lines.append(f",\n    CONSTRAINT PK_{tname} PRIMARY KEY ({pk_str})")
        lines.append(");")
        lines.append("")
        lines.append(f"COMMENT ON TABLE {tname} IS '{desc}';")
        for col in t["cols"]:
            cname, _ = resolve_column(tname, col)
            if col["comment"]:
                cmt = str(col["comment"]).replace("'", "''")
                if cname == "INPT_MST_SRNO":
                    cmt = "심사 마스터 일련번호"
                lines.append(f"COMMENT ON COLUMN {tname}.{cname} IS '{cmt}';")
        lines.append("")

    return "\n".join(lines)


def gen_drop(tables):
    lines = [
        "-- ============================================================",
        "-- AI 심사 시스템 DROP 스크립트 (Tibero/Oracle)",
        "-- 주의: 모든 테이블·시퀀스 데이터가 삭제됩니다.",
        "-- 실행 순서: 00_drop → 01_ddl → 02_sequence → 03_test_data",
        "-- ============================================================",
        "",
        "-- 시퀀스 삭제",
    ]
    for seq, _ in reversed(SEQUENCES):
        lines.append(f"BEGIN EXECUTE IMMEDIATE 'DROP SEQUENCE {seq}'; EXCEPTION WHEN OTHERS THEN NULL; END;")
        lines.append("/")
    lines.append("")
    lines.append("-- 테이블 삭제 (자식 → 부모)")
    for tname in DROP_ORDER:
        if tname in tables:
            lines.append(
                f"BEGIN EXECUTE IMMEDIATE 'DROP TABLE {tname} CASCADE CONSTRAINTS PURGE'; "
                f"EXCEPTION WHEN OTHERS THEN NULL; END;"
            )
            lines.append("/")
    for tname in sorted(tables.keys()):
        if tname not in DROP_ORDER:
            lines.append(
                f"BEGIN EXECUTE IMMEDIATE 'DROP TABLE {tname} CASCADE CONSTRAINTS PURGE'; "
                f"EXCEPTION WHEN OTHERS THEN NULL; END;"
            )
            lines.append("/")
    return "\n".join(lines)


def gen_sequence():
    lines = [
        "-- ============================================================",
        "-- AI 심사 시스템 SEQUENCE (Tibero/Oracle)",
        "-- Source: MyBatis Mapper NEXTVAL 분석",
        "-- ============================================================",
        "",
    ]
    for seq, start in SEQUENCES:
        lines += [
            f"-- {seq}",
            f"BEGIN EXECUTE IMMEDIATE 'DROP SEQUENCE {seq}'; EXCEPTION WHEN OTHERS THEN NULL; END;",
            "/",
            f"CREATE SEQUENCE {seq}",
            f"    START WITH {start}",
            "    INCREMENT BY 1",
            "    NOCACHE",
            "    NOCYCLE;",
            "",
        ]
    return "\n".join(lines)


def gen_rich_detail_data(audit):
    """마스터(10001~10003)와 연계된 상세·관리 테이블 시드."""
    lines = []
    dtm = audit[1]

    # CSPD105TI / CSPD106TI / CSPD113TI / CSPD116TI - 제재 Rule
    lines.append("-- CSPD105TI: 제재 룰 1단계")
    for i, (rid, lid, sno) in enumerate([("01", "WL001", "1"), ("02", "WL002", "2")], 1):
        lines.append(build_insert("CSPD105TI", {
            "AI_INPT_SNRL1_ID": q(rid), "AI_INPT_LIST_ID": q(lid),
            "INPT_SANCTION_NO": q(sno), "AI_INPT_RULE_DSCD": q("ITM"),
            "TRN_LOG_SRNO": trn_log_srno(i), "LST_DB_CHG_ID": q("SYSTEM"), "LST_DB_CHG_DTM": dtm,
        }))
    lines.append("")

    lines.append("-- CSPD106TI: 제재 룰 2단계")
    lines.append(build_insert("CSPD106TI", {
        "AI_INPT_SNRL2_ID": q("01"), "AI_INPT_SNRL2_NM": q("수출 BL검증"),
        "AI_INPT_RULE_DSCD": q("ITM"), "INPT_SANCTION1_NO": q("1"),
        "AI_INPT_LIST1_ID": q("WL001"), "INPT_SANCTION2_NO": q("2"),
        "AI_INPT_LIST2_ID": q("WL002"), "INPT_SANCTION3_NO": q("0"),
        "AI_INPT_LIST3_ID": q(""), "INPT_SANCTION4_NO": q("0"), "AI_INPT_LIST4_ID": q(""),
        "TRN_LOG_SRNO": trn_log_srno(1), "LST_DB_CHG_ID": q("SYSTEM"), "LST_DB_CHG_DTM": dtm,
    }))
    lines.append("")

    lines.append("-- CSPD113TI: 제재 SQL 룰")
    lines.append(build_insert("CSPD113TI", {
        "AI_INPT_SNRL3_ID": q("1"), "AI_INPT_SNRL3_NM": q("수출건 BL매칭"),
        "AI_INPT_RSPT_SQL_TXT": q("SELECT 1 FROM DUAL WHERE :BL_NO IS NOT NULL"),
        "TRN_LOG_SRNO": trn_log_srno(1), "LST_DB_CHG_ID": q("SYSTEM"), "LST_DB_CHG_DTM": dtm,
    }))
    lines.append("")

    lines.append("-- CSPD116TI: 제재 룰 설정")
    for dscd, s2, s3 in [("ITM", "Y", "Y"), ("TXT", "Y", "N")]:
        lines.append(build_insert("CSPD116TI", {
            "AI_INPT_RULE_DSCD": q(dscd), "AI_INPT_SNRL2_USG_YN": q(s2),
            "AI_INPT_SNRL3_USG_YN": q(s3), "AI_INPT_WORD_ACRD_RT": q("80"),
            "TRN_LOG_SRNO": trn_log_srno(1), "LST_DB_CHG_ID": q("SYSTEM"), "LST_DB_CHG_DTM": dtm,
        }))
    lines.append("")

    # CSPD104TI - WatchList 응답 텍스트
    lines.append("-- CSPD104TI: WatchList 응답 텍스트")
    for i, (lid, txt) in enumerate([("WL001", "OFAC SDN LIST MATCH"), ("WL002", "EU SANCTIONS MATCH")], 1):
        lines.append(build_insert("CSPD104TI", {
            "AI_INPT_RSPT_TXT_SRNO": str(i), "AI_INPT_LIST_ID": q(lid),
            "AI_INPT_CTGR_ID": q("CTG01"), "AI_INPT_RSPT_TXT_DES_TXT": q(txt),
            "AI_INPT_RSPT_TXT_RGS_DTM": q("20200101000000"),
            "AI_INPT_RSPT_TXT_END_DTM": q("99991231235959"), "AI_INPT_RSPT_TXT_YN": q("Y"),
            "TRN_LOG_SRNO": trn_log_srno(i), "LST_DB_CHG_ID": q("SYSTEM"), "LST_DB_CHG_DTM": dtm,
        }))
    lines.append("")

    # CSPD107TI - QA 선정
    lines.append("-- CSPD107TI: QA 선정 관리")
    for i, (imex, lid, tot, vol) in enumerate([
        ("01", "WL001", 100, 10), ("02", "WL002", 80, 8),
    ], 1):
        lines.append(build_insert("CSPD107TI", {
            "QLAS_SLT_MNG_ID": str(i), "AI_INPT_IMEX_DSCD": q(imex),
            "AI_INPT_LIST_ID": q(lid), "INPT_SANCTION_NO": q("1"),
            "QLAS_ITM_TOT_CNT": str(tot), "QLAS_VOLN_CHC_CNT": str(vol),
            "QLAS_SLBS_VLD_YN": q("Y"), "QLAS_SLT_RGS_DTM": q("20250101000000"),
            "TRN_LOG_SRNO": trn_log_srno(i), "LST_DB_CHG_ID": q("SYSTEM"), "LST_DB_CHG_DTM": dtm,
        }))
    lines.append("")

    # CSPD003TF / CSPD004TF - 마스터 연계
    lines.append("-- CSPD003TF: TotalText 추출 결과")
    for i, srno in enumerate([10001, 10002, 10003], 1):
        lines.append(build_insert("CSPD003TF", {
            "INPT_MST_SRNO": mst_srno(srno), "AI_INPT_TOTALTEXT_SRNO": str(i),
            "INPT_TASK_ID": q(f"TASK{srno}"),
            "BFRS_AICR_EXTC_TXT": q(f"Invoice TotalText 추출 결과 {srno}"),
            "INPT_SANCTION_DAT_TXT": q(f"SANCTION DATA {srno}"),
            "AI_INPT_SANCTION_RULE_TXT": q("RULE_MATCH_OK"),
            "AI_INPT_TOTALTEXT_RVSN_YN": q("N"),
            "AI_INPT_ALT_YN": q("N"),
            "ITM_INPT_XAXIS_STA_CRDN_CN": "100.0",
            "ITM_INPT_YAXIS_STA_CRDN_CN": "100.0",
            "ITM_INPT_XAXIS_END_CRDN_CN": "500.0",
            "ITM_INPT_YAXIS_END_CRDN_CN": "200.0",
            "LST_DB_CHG_ID": q("SYSTEM"), "LST_DB_CHG_DTM": dtm,
        }))
    lines.append("")

    lines.append("-- CSPD004TF: 제재 항목 탐지")
    for i, srno in enumerate([10001, 10002, 10003], 1):
        lines.append(build_insert("CSPD004TF", {
            "INPT_MST_SRNO": mst_srno(srno), "INPT_SANCTION_NO": str(i),
            "INPT_TASK_ID": q(f"TASK{srno}"), "INPT_BL_GRP_NO": q(f"BL2025000{i}"),
            "INPT_ATMC_BIZ_DSCD": q("01"), "AI_INPT_BUY_AM": str(1000000 * i),
            "AI_INPT_ALT_YN": q("N"), "SAFEWATCH_ITM_YN": q("N"),
            "ITM_INPT_NACRD_YN": q("N"),
            "ITM_INPT_RVSN_YN": q("N"), "AI_INPT_WORD_ACRD_RT": "85.5",
            "BFRS_AICR_EXTC_TXT": q(f"항목추출전 {i}"), "AFRS_AICR_EXTC_TXT": q(f"항목추출후 {i}"),
            "INPT_SANCTION_DAT_TXT": q(f"EXTRACT DATA {srno}"),
            "AI_INPT_SANCTION_RULE_TXT": q("MATCH"),
            "TRN_LOG_SRNO": trn_log_srno(i), "LST_DB_CHG_ID": q("SYSTEM"), "LST_DB_CHG_DTM": dtm,
        }))
    lines.append("")

    lines.append("-- CSPD006TL: 첨부파일")
    for i, srno in enumerate([10001, 10002, 10003], 1):
        lines.append(build_insert("CSPD006TL", {
            "INPT_MST_SRNO": mst_srno(srno), "AI_INPT_ATFL_SRNO": str(i),
            "AI_INPT_BIZ_DSCD": q("01"),
            "AI_INPT_ATFL_NM": q(f"invoice_{srno}.pdf"),
            "AI_INPT_ATFL_PATH_TXT": q(f"/data/attach/{srno}/invoice.pdf"),
            "TRN_LOG_SRNO": trn_log_srno(i), "LST_DB_CHG_ID": q("SYSTEM"), "LST_DB_CHG_DTM": dtm,
        }))
    lines.append("")

    lines.append("-- CSPD007TL: SafeWatch 탐지")
    for i, srno in enumerate([10001, 10002, 10003], 1):
        lines.append(build_insert("CSPD007TL", {
            "INPT_MST_SRNO": mst_srno(srno), "AI_INPT_PRG_SRNO": str(i),
            "BL_NO": q(f"BL2025000{i}"), "INPT_BL_GRP_NO": q(f"BL2025000{i}"),
            "FILT_DTCT_NO": q(f"DTCT{i:04d}"), "SAFEWATCH_AI_INPT_RST_CD": q("01"),
            "LST_DB_CHG_DTM": dtm,
        }))
    lines.append("")

    # CSPD117TI - 후보정 용어
    lines.append("-- CSPD117TI: 후보정 용어 사전")
    words = [("SHIPPER", "송하인", "150"), ("CONSIGNEE", "수하인", "150"), ("NOTIFY", "통지처", "150")]
    for i, (eng, kor, grp) in enumerate(words, 1):
        lines.append(build_insert("CSPD117TI", {
            "AI_INPT_WORD_SRNO": str(i), "AI_INPT_WORD_TXT": q(eng),
            "AI_INPT_WORD_INF_NM": q(kor), "AI_INPT_GRP_CD": q(grp),
            "AI_INPT_RMRK_TXT": q(f"후보정용어-{eng}"),
            "TRN_LOG_SRNO": trn_log_srno(i), "LST_DB_CHG_ID": q("SYSTEM"), "LST_DB_CHG_DTM": dtm,
        }))
    lines.append("")

    # CSPD811TH - 프로그램 사용 이력
    lines.append("-- CSPD811TH: 프로그램 사용 이력")
    logs = [
        ("PGM0001", "reviewer01", "1010", "700", "701", "01"),
        ("PGM0002", "approver01", "2010", "700", "701", "01"),
        ("PGM0003", "admin01", "7010", "700", "701", "02"),
    ]
    for i, (hst, uid, scr, fld, act, parm) in enumerate(logs, 1):
        lines.append(build_insert("CSPD811TH", {
            "AI_INPT_PGM_USG_HST_NO": q(hst), "AI_INPT_CNCT_USER_NO": q(uid),
            "AI_INPT_CNCT_IPAD": q("127.0.0.1"), "AI_INPT_CNCT_MCHR_NM": q("TEST-PC"),
            "AI_INPT_CNCT_SCRN_NO": q(scr), "AI_INPT_CNCT_FLD_CD": q(fld),
            "AI_INPT_CNCT_ACTI_CD": q(act), "AI_INPT_CNCT_PARM_TXT": q(parm),
            "TRN_LOG_SRNO": trn_log_srno(i), "LST_DB_CHG_ID": q("SYSTEM"), "LST_DB_CHG_DTM": dtm,
        }))
    lines.append("")

    # CSPD201TM / CSPD202TM - 외환 연계 (AppStatus 조인용)
    lines.append("-- CSPD201TM: 수출 커버링")
    for i, (acno, nm, amt, mk_dt) in enumerate([
        ("FX10001", "(주)테스트수출", 50000, "20250115"),
        ("FX10002", "글로벌무역", 120000, "20250116"),
    ], 1):
        lines.append(build_insert("CSPD201TM", {
            "XPO_CVRG_MK_SQ": str(i), "FX_ACNO": q(acno),
            "CSNO": q(f"C{i:06d}"), "CUS_KORL_NM": q(nm),
            "XPBY_COL_AM": str(amt), "XPBY_COL_CTR_CUCD": q("USD"),
            "INPT_ATMC_REQ_DSCD": q("1"),
            "XPO_CVRG_MTBR_MK_DT": q(mk_dt),
            "TRN_OPR_NO": q("E10001"),
            "INPT_ATMC_BIZ_DSCD": q("1"),
            "KRBR_NM": q("본점"),
        }))
    lines.append("")

    lines.append("-- CSPD202TM: 서류 접수")
    for i, (acno, nm, amt, rcp_dt) in enumerate([
        ("FX10001", "(주)테스트수출", 48000, "20250115"),
        ("FX10003", "한국수입상사", 75000, "20250117"),
    ], 1):
        lines.append(build_insert("CSPD202TM", {
            "TDOC_RCP_SRNO": str(i), "FX_ACNO": q(acno),
            "CSNO": q(f"C{i:06d}"), "CUS_KORL_NM": q(nm),
            "TDOC_RCP_AM": str(amt), "TDOC_RCP_CUCD": q("USD"),
            "TDOC_RCP_DT": q(rcp_dt),
            "INPT_ATMC_REQ_DSCD": q("1"),
            "TRN_OPR_NO": q("E10001"),
            "INPT_ATMC_BIZ_DSCD": q("2"),
            "KRBR_NM": q("본점"),
        }))
    lines.append("")

    # CSPD011TL - 미생성/추출 로그
    lines.append("-- CSPD011TL: 미생성 및 추출 처리 로그")
    for i, srno in enumerate([10001, 10002], 1):
        lines.append(build_insert("CSPD011TL", {
            "AI_INPT_XT_SRNO": str(i), "FX_REFNO_SRNO": str(srno),
            "ACTL_FX_REFNO": q(f"FX{srno}"), "INPT_ATMC_BIZ_DSCD": q("01"),
            "INPT_RCP_DT": q("20250115"), "AI_INPT_IMG_KEY_NO": q(f"IMG{srno}"),
            "AI_INPT_DOC_SCAN_CHRG_ENO": q("E10001"),
            "AI_INPT_DOC_SCAN_DTM": dtm, "AI_INPT_XT_PRC_STS_DSCD": q("01"),
            "TRN_LOG_SRNO": trn_log_srno(i), "LST_DB_CHG_ID": q("SYSTEM"), "LST_DB_CHG_DTM": dtm,
        }))
    lines.append("")

    # CSPD009TA / CSPD010TA - 업무일지 통계
    lines.append("-- CSPD009TA: 업무 종료 통계")
    lines.append(build_insert("CSPD009TA", {
        "AI_INPT_CLS_DT": q("20250115"), "AI_INPT_CLS_DSCD": q("01"),
        "AI_INPT_CLS_ITCD": q("1010"), "AI_INPT_CLS_CNT": "25",
        "AI_INPT_SNPE_ENO": q("E10001"), "AI_INPT_RMRK_TXT": q("일일 종료"),
        "TRN_LOG_SRNO": trn_log_srno(1), "LST_DB_CHG_ID": q("SYSTEM"), "LST_DB_CHG_DTM": dtm,
    }))
    lines.append("")

    lines.append("-- CSPD010TA: 업무 등록 통계")
    lines.append(build_insert("CSPD010TA", {
        "AI_INPT_APDR_DT": q("20250115"), "AI_INPT_APDR_DSCD": q("01"),
        "AI_INPT_APDR_ITCD": q("1010"), "AI_INPT_SNPE_ENO": q("E10001"),
        "AI_INPT_XPO_REL_CNT": "10", "AI_INPT_IMP_REL_CNT": "8",
        "AI_INPT_SMSG_CNT": "2", "AI_INPT_RMSG_CNT": "1",
        "TRN_LOG_SRNO": trn_log_srno(1), "LST_DB_CHG_ID": q("SYSTEM"), "LST_DB_CHG_DTM": dtm,
    }))
    lines.append("")

    return lines


def q(val):
  """Quote string for SQL."""
  if val is None:
    return "NULL"
  return "'" + str(val).replace("'", "''") + "'"


def mst_srno(val):
    """INPT_MST_SRNO 값 (NUMBER)."""
    return str(val)


def trn_log_srno(val):
    """TRN_LOG_SRNO 값 (VARCHAR2)."""
    return q(str(val))


def build_insert(tname, col_map):
    cols = list(col_map.keys())
    vals = [col_map[c] for c in cols]
    return f"INSERT INTO {tname} ({', '.join(cols)}) VALUES ({', '.join(vals)});"


def gen_seed_data(tables):
    lines = [
        "-- ============================================================",
        "-- AI 심사 시스템 테스트 데이터 (더미 데이터)",
        "-- Source: 테이블정의서_추출.xlsx + MyBatis Mapper 분석",
        "-- 실행 순서: 00_drop → 01_ddl → 02_sequence → 03_test_data",
        "--",
        "-- 타입 규칙:",
        "--   INPT_MST_SRNO: NUMBER(19) — 숫자 리터럴 (예: 10001)",
        "--   TRN_LOG_SRNO: VARCHAR2(60) — 문자열 리터럴 (예: '1', '10001')",
        "--   CSPD900TI: TRN_LOG_SRNO → INPT_MST_SRNO (마스터 키와 동일 값)",
        "-- ============================================================",
        "",
    ]
    audit = ("1", "'20250115120000'")

    # CSPD111TI - 공통코드 그룹
    lines.append("-- CSPD111TI: 공통코드 그룹")
    for i, (grp, nm, sta, end, usg, rmk) in enumerate(TABLE_SEEDS["CSPD111TI"], 1):
        lines.append(build_insert("CSPD111TI", {
            "AI_INPT_GRP_CD": q(grp), "AI_INPT_GRP_NM": q(nm),
            "AI_INPT_GRP_STA_DTM": q(sta), "AI_INPT_GRP_END_DTM": q(end),
            "AI_INPT_GRP_USG_YN": q(usg), "AI_INPT_RMRK_TXT": q(rmk),
            "TRN_LOG_SRNO": trn_log_srno(i), "LST_DB_CHG_ID": q("SYSTEM"), "LST_DB_CHG_DTM": audit[1],
        }))
    lines.append("")

    # CSPD112TI - 공통코드
    lines.append("-- CSPD112TI: 공통코드 상세")
    for i, (grp, cd, nm, eng, sta, end, usg, rmk, sort) in enumerate(TABLE_SEEDS["CSPD112TI"], 1):
        lines.append(build_insert("CSPD112TI", {
            "AI_INPT_GRP_CD": q(grp), "AI_INPT_CMN_CD": q(cd),
            "AI_INPT_CMN_CD_NM": q(nm), "AI_INPT_CMN_CD_ENG_NM": q(eng),
            "AI_INPT_CMN_CD_STA_DTM": q(sta), "AI_INPT_CMN_CD_END_DTM": q(end),
            "AI_INPT_CMN_USG_YN": q(usg), "AI_INPT_RMRK_TXT": q(rmk),
            "AI_INPT_INTF_ITM_NM": q(nm), "AI_INPT_SORT_SEQ": q(sort),
            "TRN_LOG_SRNO": trn_log_srno(i), "LST_DB_CHG_ID": q("SYSTEM"), "LST_DB_CHG_DTM": audit[1],
        }))
    lines.append("")

    # CSPD115TI - 국가코드
    lines.append("-- CSPD115TI: 국가 코드")
    for i, (nacd, abrv, kor, eng, eng_nm, rprs, nutp) in enumerate(TABLE_SEEDS["CSPD115TI"], 1):
        lines.append(build_insert("CSPD115TI", {
            "NACD": q(nacd), "KORL_NL_ABRV_NM": q(abrv), "KORL_NL_NM": q(kor),
            "ENG_NL_ABRV_NM": q(nacd), "ENG_NL_NM": q(eng_nm), "NUTP_NACD": q(nutp),
            "RPRS_CD_YN": q(rprs),
            "TRN_LOG_SRNO": trn_log_srno(i), "LST_DB_CHG_ID": q("SYSTEM"), "LST_DB_CHG_DTM": audit[1],
        }))
    lines.append("")

    # CSPD118TI - 도시항구
    lines.append("-- CSPD118TI: 도시 및 항구")
    for i, (dscd, srno, nacd, eng, rgn, kor) in enumerate(TABLE_SEEDS["CSPD118TI"], 1):
        lines.append(build_insert("CSPD118TI", {
            "CITY_SRNO": str(srno), "CITY_PORT_DSCD": q(dscd), "NACD": q(nacd),
            "ENG_CITY_NM": q(eng), "ENG_CITY_RGN_NM": q(rgn),
            "TRN_LOG_SRNO": trn_log_srno(i), "LST_DB_CHG_ID": q("SYSTEM"), "LST_DB_CHG_DTM": audit[1],
        }))
    lines.append("")

    # CSPD118TM - 영업일
    lines.append("-- CSPD118TM: 영업일")
    for dt, wkd, hldy, txt in [("20250115", "3", "0", "영업일"), ("20250118", "6", "1", "토요일"), ("20250119", "7", "1", "일요일")]:
        lines.append(build_insert("CSPD118TM", {
            "BAS_DT": q(dt), "WKD_CD": q(wkd), "HLDY_DSCD": q(hldy), "HLDY_TXT": q(txt),
            "TRN_LOG_SRNO": trn_log_srno(1), "LST_DB_CHG_ID": q("SYSTEM"), "LST_DB_CHG_DTM": audit[1],
        }))
    lines.append("")

    # CSPD101TI - 사용자 (admin01: 권한01 + 관리자Y → CSPD109TI 전 메뉴 접근)
    lines.append("-- CSPD101TI: 사용자")
    for i, (uid, eno, auth, mgpe, nm, usg, fare, rgs, end) in enumerate(TABLE_SEEDS["CSPD101TI"], 1):
        lines.append(build_insert("CSPD101TI", {
            "AI_INPT_USER_ID": q(uid), "AI_INPT_USER_ENO": q(eno), "AI_INPT_AUT_CD": q(auth),
            "AI_INPT_MGPE_YN": q(mgpe), "AI_INPT_USER_NM": q(nm), "AI_INPT_USER_YN": q(usg),
            "AI_INPT_USER_FA_RE_YN": q(fare), "AI_INPT_USER_RGS_DTM": q(rgs),
            "AI_INPT_USER_END_DTM": q(end), "AI_INPT_SNPE_ENO": q(eno),
            "AI_INPT_SRVC_USER_DSCD": q("01"),
            "TRN_LOG_SRNO": trn_log_srno(i), "LST_DB_CHG_ID": q("SYSTEM"), "LST_DB_CHG_DTM": audit[1],
        }))
    lines.append("")

    # CSPD102TI - WatchList 카테고리 (CSPD103TI 선행)
    lines.append("-- CSPD102TI: WatchList 카테고리")
    lines.append(build_insert("CSPD102TI", {
        "AI_INPT_CTGR_ID": q("CTG01"), "CTGR_CFCD": q("SANCTION"),
        "AI_INPT_CTGR_NM": q("제재목록"), "AI_INPT_CTGR_TXT": q("제재 관련 WatchList"),
        "AI_INPT_CTGR_RGS_DTM": q("20200101000000"), "AI_INPT_CTGR_END_DTM": q("99991231235959"),
        "AI_INPT_CTGR_YN": q("Y"),
        "TRN_LOG_SRNO": trn_log_srno(1), "LST_DB_CHG_ID": q("SYSTEM"), "LST_DB_CHG_DTM": audit[1],
    }))
    lines.append("")

    # CSPD103TI - WatchList
    lines.append("-- CSPD103TI: WatchList 목록")
    for i, (lid, lnm) in enumerate([("WL001", "OFAC SDN"), ("WL002", "EU Sanctions"), ("WL003", "UN List")], 1):
        lines.append(build_insert("CSPD103TI", {
            "AI_INPT_LIST_ID": q(lid), "AI_INPT_LIST_NM": q(lnm),
            "AI_INPT_CTGR_ID": q("CTG01"), "AI_INPT_LIST_DES_TXT": q(f"{lnm} 목록"),
            "AI_INPT_LIST_RGS_DTM": q("20200101000000"), "AI_INPT_LIST_END_DTM": q("99991231235959"),
            "AI_INPT_LIST_YN": q("Y"),
            "TRN_LOG_SRNO": trn_log_srno(i), "LST_DB_CHG_ID": q("SYSTEM"), "LST_DB_CHG_DTM": audit[1],
        }))
    lines.append("")

    # CSPD108TI - 메뉴
    lines.append("-- CSPD108TI: 메뉴")
    for i, (hgrn, mid, mnm, mno, url, mgpe) in enumerate(TABLE_SEEDS["CSPD108TI"], 1):
        lines.append(build_insert("CSPD108TI", {
            "AI_INPT_MENU_ID": q(mid), "AI_INPT_HGRN_MENU_ID": q(hgrn) if hgrn else "NULL",
            "AI_INPT_MENU_NM": q(mnm), "AI_INPT_MENU_NO": q(mno) if mno else "NULL",
            "AI_INPT_MENU_URL_NM": q(url) if url else "NULL", "AI_INPT_MGPE_YN": q(mgpe),
            "TRN_LOG_SRNO": trn_log_srno(i), "LST_DB_CHG_ID": q("SYSTEM"), "LST_DB_CHG_DTM": audit[1],
        }))
    lines.append("")

    # CSPD109TI - 메뉴권한 (admin01=권한01: 모든 메뉴 Y)
    lines.append("-- CSPD109TI: 메뉴 권한 (admin01 → AI_INPT_AUT_CD=01, 전 메뉴 Y)")
    aut_id = 1
    for _, mid, _, _, _, _ in TABLE_SEEDS["CSPD108TI"]:
        for auth in MENU_AUTH_CODES:
            lines.append(build_insert("CSPD109TI", {
                "AI_INPT_AUT_ID": str(aut_id), "AI_INPT_MENU_ID": q(mid),
                "AI_INPT_AUT_CD": q(auth), "AI_INPT_AUT_USG_YN": q("Y"),
                "AI_INPT_RMRK_TXT": q("admin01 전체 메뉴" if auth == "01" else "테스트 권한"),
                "TRN_LOG_SRNO": trn_log_srno(aut_id), "LST_DB_CHG_ID": q("SYSTEM"), "LST_DB_CHG_DTM": audit[1],
            }))
            aut_id += 1
    lines.append("")

    # CSPD001TM - 심사 마스터
    lines.append("-- CSPD001TM: AI 심사 마스터")
    for i, (srno, insp, snpe, biz, pros, acvt, appv, imex, rst, bl, rcpdt, rcpym) in enumerate(TABLE_SEEDS["CSPD001TM"], 1):
        lines.append(build_insert("CSPD001TM", {
            "INPT_MST_SRNO": mst_srno(srno), "AI_INSPE_ENO": q(insp), "AI_INPT_SNPE_ENO": q(snpe),
            "INPT_ATMC_BIZ_DSCD": q(biz), "INPT_ATMC_REQ_DSCD": q("1"),
            "AI_INPT_PROS_CD": q(pros), "AI_INPT_ACVT_CD": q(acvt),
            "AI_INPT_APPV_STCD": q(appv), "IMEX_HIS_CD": q(imex),
            "TOTALTEXT_AI_INPT_RST_CD": q(rst), "ITM_INPT_AI_INPT_RST_CD": q(rst),
            "SAFEWATCH_AI_INPT_RST_CD": q(rst), "QLT_GRN_AI_INPT_RST_CD": q(rst),
            "INPT_BL_GRP_NO": q(bl), "INPT_RCP_DT": q(rcpdt), "INPT_RCP_YM": q(rcpym),
            "INPT_SANCTION_NM": q(f"테스트심사건_{srno}"), "INPT_TASK_ID": q(f"TASK{srno}"),
            "INPT_ELMT_ID": q(f"ELMT{srno}"), "ACTL_FX_REFNO": q(f"FX{srno}"),
            "FX_REFNO_SRNO": str(srno), "AI_INPT_BUY_AM": str(1000000 * i),
            "ALERT_YN": q("N"), "QLAS_PRG_YN": q("N"), "REPROC_CNT": "0", "RESCAN_CNT": "0",
            "PAPS_CLF_ERR_YN": q("N"), "PAPS_RE_SCAN_NED_YN": q("N"), "PAPS_RE_SCAN_CMPL_YN": q("N"),
            "TRN_LOG_SRNO": trn_log_srno(i), "LST_DB_CHG_ID": q("SYSTEM"), "LST_DB_CHG_DTM": audit[1],
        }))
    lines.append("")

    # CSPD900TI - 재처리 큐 (마스터 직후, INPT_MST_SRNO NUMBER(19))
    lines.append("-- CSPD900TI: 시스템 심사 진행 큐")
    for srno, (stcd, prc, rproc) in zip(
        [10001, 10002, 10003], [("01", "01", 0), ("02", "03", 1), ("03", "01", 2)]
    ):
        lines.append(build_insert("CSPD900TI", {
            "INPT_MST_SRNO": mst_srno(srno),
            "AI_SYS_INPT_PRG_STCD": q(stcd), "AI_INPT_PRC_DSCD": q(prc),
            "RPROC_TCN": str(rproc),
            "LST_DB_CHG_ID": q("SYSTEM"), "LST_DB_CHG_DTM": audit[1],
        }))
    lines.append("")

    # CSPD002TG - 이미지 그룹
    lines.append("-- CSPD002TG: 문서 및 이미지 그룹")
    for srno, bl in [(10001, "BL20250001"), (10002, "BL20250002"), (10003, "BL20250003")]:
        for imex in ("01", "02"):
            lines.append(build_insert("CSPD002TG", {
                "INPT_MST_SRNO": mst_srno(srno), "INPT_ELMT_ID": q(f"ELMT{srno}"),
                "IMEX_HIS_CD": q(imex), "INPT_BL_GRP_NO": q(bl),
                "INPT_TASK_ID": q(f"TASK{srno}"), "AI_INPT_PAPS_QLT_SCRE": "95.5",
                "TRN_LOG_SRNO": trn_log_srno(srno), "LST_DB_CHG_ID": q("SYSTEM"), "LST_DB_CHG_DTM": audit[1],
            }))
    lines.append("")

    # CSPD008TH - 활동 이력
    lines.append("-- CSPD008TH: 심사 활동 이력")
    for i, (srno, insp, acvt, sts) in enumerate([
        (10001, "E10001", "01", "01"), (10001, "E10001", "01", "02"),
        (10002, "E10001", "01", "01"), (10003, "E10003", "02", "01"),
    ], 1):
        lines.append(build_insert("CSPD008TH", {
            "INPT_MST_SRNO": mst_srno(srno), "AI_INPT_PRG_SRNO": str(i),
            "AI_INPT_CRPE_ENO": q(insp), "AI_INPT_ACVT_CD": q(acvt),
            "AI_INPT_ACVT_STS_CD": q(sts), "AI_INPT_BIZ_DSCD": q("01"),
            "AI_INPT_PROS_STA_DTM": audit[1], "INPT_RCP_DT": q("20250115"),
            "TRN_LOG_SRNO": trn_log_srno(i), "LST_DB_CHG_ID": q("SYSTEM"), "LST_DB_CHG_DTM": audit[1],
        }))
    lines.append("")

    # CSPD005TH - 승인/처리 이력
    lines.append("-- CSPD005TH: 승인 및 처리 이력")
    for i, srno in enumerate([10001, 10002, 10003], 1):
        lines.append(build_insert("CSPD005TH", {
            "INPT_MST_SRNO": mst_srno(srno), "AI_INPT_APPV_SRNO": str(i),
            "AI_INPT_BIZ_DSCD": q("01"), "AI_INPT_CRPE_ENO": q("E10001"),
            "AI_INPT_APPV_STCD": q("01"), "AI_INPT_TOTALTEXT_RST_CD": q("01"),
            "AI_INPT_ITM_RST_CD": q("01"), "AI_INPT_TPY_SAVE_YN": q("Y"),
            "AI_INPT_PRC_DTM": audit[1], "AI_INPT_PRC_OPI_TXT": q(f"승인 처리 의견 {srno}"),
            "TRN_LOG_SRNO": trn_log_srno(i), "LST_DB_CHG_ID": q("SYSTEM"), "LST_DB_CHG_DTM": audit[1],
        }))
    lines.append("")

    # CSPD110TI - 결재 의견
    lines.append("-- CSPD110TI: 승인 의견 메모")
    for i, txt in enumerate(["승인합니다.", "검토 후 승인.", "추가 확인 필요."], 1):
        lines.append(build_insert("CSPD110TI", {
            "AI_INPT_APPV_OPI_SRNO": str(i), "AI_INPT_APPV_OPI_TXT": q(txt),
            "AI_INPT_APPV_OPI_RGS_DTM": audit[1], "AI_INPT_APPV_OPI_END_DTM": q("99991231235959"),
            "AI_INPT_APPV_OPI_USG_YN": q("Y"),
            "TRN_LOG_SRNO": trn_log_srno(i), "LST_DB_CHG_ID": q("SYSTEM"), "LST_DB_CHG_DTM": audit[1],
        }))
    lines.append("")

    # CSPD810TH - 로그인 이력
    lines.append("-- CSPD810TH: 로그인 이력")
    for i, uid in enumerate(["reviewer01", "approver01", "qauser01"], 1):
        lines.append(build_insert("CSPD810TH", {
            "AI_INPT_LGIN_HST_NO": q(f"LGIN{i:04d}"), "AI_INPT_LGIN_USER_NO": q(uid),
            "AI_INPT_LGIN_DTM": audit[1], "AI_INPT_LGIN_USG_IPAD": q("127.0.0.1"),
            "AI_INPT_LGIN_YN": q("Y"),
            "TRN_LOG_SRNO": trn_log_srno(i), "LST_DB_CHG_ID": q("SYSTEM"), "LST_DB_CHG_DTM": audit[1],
        }))
    lines.append("")

    # 마스터 연계 상세·관리 테이블
    lines.extend(gen_rich_detail_data(audit))

    # 나머지 테이블 - 기본 더미
    handled = {
        "CSPD111TI", "CSPD112TI", "CSPD115TI", "CSPD118TI", "CSPD118TM",
        "CSPD101TI", "CSPD102TI", "CSPD103TI", "CSPD104TI", "CSPD105TI",
        "CSPD106TI", "CSPD107TI", "CSPD108TI", "CSPD109TI", "CSPD113TI",
        "CSPD116TI", "CSPD117TI", "CSPD001TM", "CSPD002TG", "CSPD003TF",
        "CSPD004TF", "CSPD005TH", "CSPD006TL", "CSPD007TL", "CSPD008TH",
        "CSPD009TA", "CSPD010TA", "CSPD011TL", "CSPD110TI", "CSPD201TM",
        "CSPD202TM", "CSPD810TH", "CSPD811TH", "CSPD900TI",
    }
    for tname in sorted(tables.keys()):
        if tname in handled:
            continue
        t = tables[tname]
        lines.append(f"-- {tname}: {t['desc']} [기본 더미]")
        for i in range(1, 4):
            col_map = {}
            for col in t["cols"]:
                cname, _ = resolve_column(tname, col)
                col_map[cname] = default_val(col, i, tname, cname)
            lines.append(build_insert(tname, col_map))
        lines.append("")

    lines.append("COMMIT;")
    return "\n".join(lines)


def default_val(col, idx, tname, resolved_name=None):
    cn = (resolved_name or col["col"]).upper()
    ct = to_tibero_type(col["type"])

    if cn == "INPT_MST_SRNO":
        return mst_srno(1000 + idx)
    if cn == "TRN_LOG_SRNO":
        return trn_log_srno(1000 + idx)
    if is_pk(col["key"]) or cn.endswith("_SRNO") or cn.endswith("_NO"):
        if "NUMBER" in ct:
            return str(1000 + idx)
        return q(f"{cn[:8]}{idx:03d}")
    if "DTM" in cn or cn.endswith("_DT") or cn.endswith("_YMD"):
        return "'20250115120000'" if "VARCHAR" in ct or "CHAR" in ct else "SYSDATE"
    if cn.endswith("_YN"):
        return q("Y" if idx % 2 else "N")
    if "_CD" in cn and "DSCD" not in cn:
        return q(f"{idx:02d}")
    if "DSCD" in cn:
        return q("01")
    if "_NM" in cn or "_TXT" in cn:
        return q(f"테스트_{idx}")
    if "NUMBER" in ct:
        return str(idx * 100)
    if "CLOB" in ct:
        return q(f"테스트 CLOB 데이터 {idx}")
    if "CHAR(1)" in ct:
        return q("Y")
    m = re.search(r"VARCHAR2\((\d+)\)", ct)
    max_len = int(m.group(1)) if m else 50
    val = f"T{idx}"
    return q(val[:max_len])


def main():
    tables = parse_excel()
    mapper_tables = parse_mappers()

    OUT_DIR.mkdir(exist_ok=True)

    files = {
        "00_drop.sql": gen_drop(tables),
        "01_ddl.sql": gen_ddl(tables),
        "02_sequence.sql": gen_sequence(),
        "03_test_data.sql": gen_seed_data(tables),
    }
    for name, content in files.items():
        (OUT_DIR / name).write_text(content, encoding="utf-8")

    summary = {
        "excel_tables": len(tables),
        "mapper_tables": len(mapper_tables),
        "excel_only": sorted(set(tables.keys()) - set(mapper_tables)),
        "mapper_only": sorted(set(mapper_tables) - set(tables.keys())),
        "common": sorted(set(tables.keys()) & set(mapper_tables)),
        "pk_tables": {t: resolve_pk_cols(t, tables[t]["cols"]) for t in tables},
        "sequences": [s[0] for s in SEQUENCES],
        "execution_order": [
            "00_drop.sql", "01_ddl.sql", "02_sequence.sql", "03_test_data.sql",
        ],
    }
    (OUT_DIR / "00_summary.json").write_text(
        json.dumps(summary, ensure_ascii=False, indent=2), encoding="utf-8"
    )

    # 이전 파일명 정리
    old_data = OUT_DIR / "02_test_data.sql"
    if old_data.exists():
        old_data.unlink()

    print("Generated:")
    for name in files:
        print(f"  sql/{name}")
    print(f"Tables: {len(tables)}, Sequences: {len(SEQUENCES)}")
    print(f"Mapper match: {len(summary['common'])}/{len(mapper_tables)}")


if __name__ == "__main__":
    main()
