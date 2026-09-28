#!/usr/bin/env python3
"""grp 230/240 항목심사 공통코드 SQL 생성 — 06_항목별 추출 요건.md 기준."""
from __future__ import annotations

import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
JSON_PATH = ROOT / "sql" / "itm_inpt_common_codes.json"
SQL_PATH = ROOT / "sql" / "19_itm_inpt_grp230_240_codes.sql"

# (No, nameKr, nameEn, priorityDoc, watchAttr, export, import)
ITEMS = [
    ("1", "거래일자", "Transaction Date", "WINI", "", True, True),
    ("2", "신용장개설일", "L/C Issuing Date", "WINI", "", True, True),
    ("3", "신용장번호", "L/C No.", "WINI", "", True, False),
    ("4", "참조번호", "Reference No.", "WINI", "", True, True),
    ("5", "일련번호", "Serial No.", "WINI", "", True, True),
    ("6", "고객명", "Customer Name", "WINI", "", True, True),
    ("7", "고객번호", "Customer No.", "WINI", "", True, True),
    ("8", "통화", "Currency", "WINI", "", True, True),
    ("9", "금액", "Amount", "WINI", "", True, True),
    ("10", "수출상대국가코드", "Counterparty Country Code", "WINI", "", True, False),
    ("11", "HS코드", "HS Code", "WINI", "", True, True),
    ("12", "영업점명", "Branch Name", "WINI", "", True, True),
    ("13", "영업점코드", "Branch Code", "WINI", "", True, True),
    ("14", "조작자번호", "Operator No.", "WINI", "", True, True),
    ("15", "수출자명", "Exporter Name", "Invoice", "GROUP", True, True),
    ("16", "수출자주소", "Exporter Address", "Invoice", "ALL", True, True),
    ("17", "수출자국가", "Exporter Country", "Invoice", "ALL", True, True),
    ("18", "수출자국가코드", "Exporter Country Code", "Invoice", "", True, True),
    ("19", "수입자명", "Importer Name", "Invoice", "GROUP", True, True),
    ("20", "수입자주소", "Importer Address", "Invoice", "ALL", True, True),
    ("21", "수입자국가", "Importer Country", "Invoice", "", True, True),
    ("22", "수입자국가코드", "Importer Country Code", "Invoice", "", True, True),
    ("23", "개설은행명", "Issuing Bank Name", "C/L", "GROUP", True, False),
    ("24", "개설은행주소", "Issuing Bank Address", "C/L", "COUNTRY", True, False),
    ("25", "개설은행국가", "Issuing Bank Country", "C/L", "", True, False),
    ("26", "개설은행국가코드", "Issuing Bank Country Code", "C/L", "", True, False),
    ("27", "개설은행BIC", "Issuing Bank BIC Code", "C/L", "", True, False),
    ("28", "네고은행명", "Nego Bank Name", "C/L", "GROUP", False, True),
    ("29", "네고은행주소", "Nego Bank Address", "C/L", "COUNTRY", False, True),
    ("30", "네고은행국가", "Nego Bank Country", "C/L", "", False, True),
    ("31", "네고은행BIC", "Nego Bank BIC Code", "C/L", "", False, True),
    ("32", "네고은행국가코드", "Nego Bank Country Code", "C/L", "", False, True),
    ("33", "우편은행명", "Mail Bank Name", "C/L", "GROUP", True, False),
    ("34", "우편은행주소", "Mail Bank Address", "C/L", "COUNTRY", True, False),
    ("35", "우편은행국가", "Mail Bank Country", "C/L", "", True, False),
    ("36", "우편은행국가코드", "Mail Bank Country Code", "C/L", "", True, False),
    ("37", "우편은행BIC", "Mail Bank BIC Code", "C/L", "ALL", True, False),
    ("38", "입금은행명", "Account with Bank Name", "C/L", "GROUP", False, True),
    ("39", "입금은행주소", "Account with Bank Address", "C/L", "COUNTRY", False, True),
    ("40", "입금은행국가", "Account with Bank Country", "C/L", "", False, True),
    ("41", "입금은행국가코드", "Account with Bank Country Code", "C/L", "", False, True),
    ("42", "입금은행BIC", "Account with Bank BIC Code", "C/L", "ALL", False, True),
    ("43", "상환은행명", "Reim Bank Name", "C/L", "GROUP", True, False),
    ("44", "상환은행주소", "Reim Bank Address", "C/L", "COUNTRY", True, False),
    ("45", "상환은행국가", "Reim Bank Country", "C/L", "", True, False),
    ("46", "상환은행국가코드", "Reim Bank Country Code", "C/L", "", True, False),
    ("47", "상환은행BIC", "Reim Bank BIC Code", "C/L", "", True, False),
    ("48", "원산지", "Country of Origin", "C/O", "", True, True),
    ("49", "원산지국가코드", "Country Code of Origin", "C/O", "", True, True),
    ("50", "선하증권번호", "Bill of lading No.", "B/L", "", True, True),
    ("51", "선박명", "Vessel Name", "B/L", "VESSEL", True, True),
    ("52", "항공기명", "Aircraft Name", "B/L", "", True, True),
    ("53", "품명", "Commodity Name", "Invoice", "", True, True),
    ("54", "인수지", "Place of Receipt", "B/L", "ALL", True, True),
    ("55", "인수지국가", "Country of Place of Receipt", "B/L", "", True, True),
    ("56", "인수지국가코드", "Country Code of Place of Receipt", "B/L", "", True, True),
    ("57", "선적항", "Port of Loading", "B/L", "ALL", True, True),
    ("58", "선적항국가", "Country of Port of Loading", "B/L", "", True, True),
    ("59", "선적항국가코드", "Country Code of Port of Loading", "B/L", "", True, True),
    ("60", "양하항", "Port of Discharging", "B/L", "ALL", True, True),
    ("61", "양하항국가", "Country of Port of Discharging", "B/L", "", True, True),
    ("62", "양하항국가코드", "Country Code of Port of Discharging", "B/L", "", True, True),
    ("63", "최종목적지", "Final Destination", "B/L", "ALL", True, True),
    ("64", "최종목적지국가", "Country of Final Destination", "B/L", "", True, True),
    ("65", "최종목적지국가코드", "Country Code of Final Destination", "B/L", "", True, True),
    ("66", "송하인명", "Shipper Name", "B/L", "GROUP", True, True),
    ("67", "송하인주소", "Shipper Address", "B/L", "ALL", True, True),
    ("68", "송하인국가", "Shipper Country", "B/L", "ALL", True, True),
    ("69", "송하인국가코드", "Shipper Country Code", "B/L", "", True, True),
    ("70", "수하인명", "Consignee Name", "B/L", "GROUP", True, True),
    ("71", "수하인주소", "Consignee Address", "B/L", "ALL", True, True),
    ("72", "수하인국가", "Consignee Country", "B/L", "", True, True),
    ("73", "수하인국가코드", "Consignee Country Code", "B/L", "", True, True),
    ("74", "통지처명", "Notify Party Name", "B/L", "GROUP", True, True),
    ("75", "통지처주소", "Notify Party Address", "B/L", "ALL", True, True),
    ("76", "통지처국가", "Notify Party Country", "B/L", "", True, True),
    ("77", "통지처국가코드", "Notify Party Country Code", "B/L", "", True, True),
    ("174", "2차통지처명", "2nd Notify Party Name", "B/L", "GROUP", True, True),
    ("175", "2차통지처주소", "2nd Notify Party Address", "B/L", "ALL", True, True),
    ("78", "포워더명", "Forwarder Name", "B/L", "GROUP", True, True),
    ("79", "포워더주소", "Forwarder Address", "B/L", "ALL", True, True),
    ("80", "포워더국가", "Forwarder Country", "B/L", "", True, True),
    ("81", "포워더국가코드", "Forwarder Country Code", "B/L", "", True, True),
    ("178", "2차포워더명", "2nd Forwarder Name", "B/L", "GROUP", True, True),
    ("179", "2차포워더주소", "2nd Forwarder Address", "B/L", "ALL", True, True),
    ("82", "선사명", "Shipping Company Name", "B/L", "GROUP", True, True),
    ("83", "선사주소", "Shipping Company Address", "B/L", "ALL", True, True),
    ("84", "선사국가", "Shipping Company Country", "B/L", "", True, True),
    ("85", "선사국가코드", "Shipping Company Country Code", "B/L", "", True, True),
    ("86", "운송사명", "Carrier Name", "B/L", "GROUP", True, True),
    ("87", "선박대리점명", "Shipping Agent Name", "B/L", "GROUP", True, True),
    ("88", "선장명", "Master Name", "B/L", "INDIVIDUAL", True, True),
    ("89", "보험회사명", "Insurance Company Name", "Insurance", "GROUP", True, True),
    ("90", "보험회사주소", "Insurance Company Address", "Insurance", "COUNTRY", True, True),
    ("91", "보험회사국가", "Insurance Company Country", "Insurance", "", True, True),
    ("92", "보험회사국가코드", "Insurance Company Country Code", "Insurance", "", True, True),
    ("93", "보험대리점명", "Insurance Agent Name", "Insurance", "GROUP", True, True),
    ("94", "보험대리점주소", "Insurance Agent Address", "Insurance", "COUNTRY", True, True),
    ("95", "보험대리점국가", "Insurance Agent Country", "Insurance", "", True, True),
    ("96", "보험대리점국가코드", "Insurance Agent Country Code", "Insurance", "", True, True),
    ("193", "2차보험대리점명", "2nd Insurance Agent Name", "Insurance", "GROUP", True, True),
    ("194", "2차보험대리점주소", "2nd Insurance Agent Address", "Insurance", "COUNTRY", True, True),
]

# doc04 수입 전용 항목(제조사·검사기관) — 별도 번호 부여 (테스트용 197-200)
IMPORT_EXTRA = [
    ("197", "제조사명", "Manufacturer", "B/L", "GROUP"),
    ("198", "제조사주소", "Manufacturer Address", "B/L", "COUNTRY"),
    ("199", "검사기관명", "Inspection agency", "B/L", "GROUP"),
    ("200", "검사기관주소", "Inspection agency Address", "B/L", "COUNTRY"),
]


def esc(val: str) -> str:
    return val.replace("'", "''")


def build_json() -> dict:
    export_items = []
    import_items = []
    for no, kr, en, doc, attr, ex, im in ITEMS:
        row = {
            "sanctionNo": no,
            "nameKr": kr,
            "nameEn": en,
            "priorityDoc": doc,
            "watchAttr": attr or None,
        }
        if ex:
            export_items.append(row)
        if im:
            import_items.append(row)
    for no, kr, en, doc, attr in IMPORT_EXTRA:
        import_items.append(
            {"sanctionNo": no, "nameKr": kr, "nameEn": en, "priorityDoc": doc, "watchAttr": attr or None}
        )
    return {
        "source": "06_항목별 추출 요건.md",
        "groups": {"export": "240", "import": "230"},
        "exportItems": export_items,
        "importItems": import_items,
    }


def insert_line(grp: str, no: str, kr: str, en: str, attr: str, doc: str) -> str:
    rmrk = attr or doc
    sort_no = no.replace("M", "")
    trn = f"{'240' if grp == '240' else '23'}{no.replace('M', '')}"
    return (
        f"INSERT INTO CSPD112TI (AI_INPT_GRP_CD, AI_INPT_CMN_CD, AI_INPT_CMN_CD_NM, AI_INPT_CMN_CD_ENG_NM, "
        f"AI_INPT_CMN_CD_STA_DTM, AI_INPT_CMN_CD_END_DTM, AI_INPT_CMN_USG_YN, AI_INPT_RMRK_TXT, AI_INPT_INTF_ITM_NM, "
        f"AI_INPT_SORT_SEQ, TRN_LOG_SRNO, LST_DB_CHG_ID, LST_DB_CHG_DTM)\n"
        f"SELECT '{grp}', '{esc(no)}', '{esc(kr)}', '{esc(en)}', '20200101000000', '99991231235959', 'Y', "
        f"'{esc(rmrk)}', '{esc(en)}', '{esc(sort_no)}', '{trn}', 'SYSTEM', '20250115120000' FROM DUAL\n"
        f" WHERE NOT EXISTS (SELECT 1 FROM CSPD112TI WHERE AI_INPT_GRP_CD = '{grp}' AND AI_INPT_CMN_CD = '{esc(no)}');"
    )


def build_sql(data: dict) -> str:
    lines = [
        "-- ============================================================",
        "-- grp 230(수입) / grp 240(수출) 항목심사 공통코드 전체",
        "-- 근거: 06_항목별 추출 요건.md",
        "-- 메타: sql/itm_inpt_common_codes.json (scripts/generate_itm_inpt_common_codes.py)",
        "-- 실행: 18 이전 또는 기존 DB 1회 (03 신규 설치 시 03에 포함 가능)",
        "-- ============================================================",
        "",
        "INSERT INTO CSPD111TI (AI_INPT_GRP_CD, AI_INPT_GRP_NM, AI_INPT_GRP_STA_DTM, AI_INPT_GRP_END_DTM, AI_INPT_GRP_USG_YN, AI_INPT_RMRK_TXT, TRN_LOG_SRNO, LST_DB_CHG_ID, LST_DB_CHG_DTM)",
        "SELECT '230', '수입 항목심사', '20200101000000', '99991231235959', 'Y', '항목심사-수입', '40', 'SYSTEM', '20250115120000' FROM DUAL",
        " WHERE NOT EXISTS (SELECT 1 FROM CSPD111TI WHERE AI_INPT_GRP_CD = '230');",
        "INSERT INTO CSPD111TI (AI_INPT_GRP_CD, AI_INPT_GRP_NM, AI_INPT_GRP_STA_DTM, AI_INPT_GRP_END_DTM, AI_INPT_GRP_USG_YN, AI_INPT_RMRK_TXT, TRN_LOG_SRNO, LST_DB_CHG_ID, LST_DB_CHG_DTM)",
        "SELECT '240', '수출 항목심사', '20200101000000', '99991231235959', 'Y', '항목심사-수출', '41', 'SYSTEM', '20250115120000' FROM DUAL",
        " WHERE NOT EXISTS (SELECT 1 FROM CSPD111TI WHERE AI_INPT_GRP_CD = '240');",
        "",
        "-- grp 240 수출",
    ]
    item_map = {row[0]: row for row in ITEMS}
    for no, kr, en, doc, attr, ex, _im in ITEMS:
        if ex:
            lines.append(insert_line("240", no, kr, en, attr, doc))
    lines.append("")
    lines.append("-- grp 230 수입")
    for no, kr, en, doc, attr, _ex, im in ITEMS:
        if im:
            lines.append(insert_line("230", no, kr, en, attr, doc))
    for no, kr, en, doc, attr in IMPORT_EXTRA:
        lines.append(insert_line("230", no, kr, en, attr, doc))
    lines.append("")
    lines.append("COMMIT;")
    lines.append("")
    return "\n".join(lines)


def main() -> None:
    data = build_json()
    JSON_PATH.write_text(json.dumps(data, ensure_ascii=False, indent=2), encoding="utf-8")
    SQL_PATH.write_text(build_sql(data), encoding="utf-8")
    print(f"Wrote {JSON_PATH.name} ({len(data['exportItems'])} export, {len(data['importItems'])} import)")
    print(f"Wrote {SQL_PATH.name}")


if __name__ == "__main__":
    main()
