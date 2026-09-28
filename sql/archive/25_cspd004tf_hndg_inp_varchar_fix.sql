-- ============================================================
-- CSPD004TF.ITM_INPT_HNDG_INP_DAT_TXT 타입 보정
-- CLOB → VARCHAR2(4000)
--
-- 증상: /api/inpt/result/analy/xls/ref 등 심사결과분석 엑셀 다운로드
--       (InptResultAnalyMapper.selectRefList 등)
--       hand != ' ', hand = '.' 등 문자열 비교 시 ORA-00932
-- 원인: 매퍼가 수기입력 컬럼을 VARCHAR처럼 비교하는데 DDL이 CLOB
--
-- 실행: 기존 DB에 컬럼이 CLOB인 경우 1회 실행
--       신규 설치(01_ddl 수정본) 시 불필요
-- ============================================================

ALTER TABLE CSPD004TF ADD ITM_INPT_HNDG_INP_DAT_TXT_TMP VARCHAR2(4000);

UPDATE CSPD004TF
   SET ITM_INPT_HNDG_INP_DAT_TXT_TMP = DBMS_LOB.SUBSTR(ITM_INPT_HNDG_INP_DAT_TXT, 4000, 1)
 WHERE ITM_INPT_HNDG_INP_DAT_TXT IS NOT NULL;

ALTER TABLE CSPD004TF DROP COLUMN ITM_INPT_HNDG_INP_DAT_TXT;

ALTER TABLE CSPD004TF RENAME COLUMN ITM_INPT_HNDG_INP_DAT_TXT_TMP TO ITM_INPT_HNDG_INP_DAT_TXT;

COMMENT ON COLUMN CSPD004TF.ITM_INPT_HNDG_INP_DAT_TXT IS '항목별 수기 입력 데이터 내용';

COMMIT;
