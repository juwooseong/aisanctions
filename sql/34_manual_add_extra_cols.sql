-- ============================================================
-- 34_manual_add_extra_cols.sql
-- 1011 상세 화면 "항목심사" 그리드의 동적 "수기 추가" 컬럼(최대 3개) 값을 저장하기 위한
-- CSPD004TF 확장 컬럼. 기존 ITM_INPT_HNDG_INP_DAT_TXT(수기입력, 원본 항목 1개)와 별개로,
-- 사용자가 화면에서 임의로 추가한 보조 입력값 최대 3개를 각각 담는다.
-- 실행: sql/00~33 신규 설치 이후, 기존 DB에도 그대로 재적용 가능(멱등 처리).
-- 관련 문서: docs/feature-manual-add-column.md
-- Tibero/Oracle 공통 문법만 사용.
-- ============================================================

DECLARE
  v_cnt NUMBER;
BEGIN
  SELECT COUNT(*) INTO v_cnt FROM USER_TAB_COLUMNS
   WHERE TABLE_NAME = 'CSPD004TF' AND COLUMN_NAME = 'ITM_INPT_HNDG_ADD1_TXT';
  IF v_cnt = 0 THEN
    EXECUTE IMMEDIATE 'ALTER TABLE CSPD004TF ADD (
        ITM_INPT_HNDG_ADD1_TXT VARCHAR2(1000),
        ITM_INPT_HNDG_ADD2_TXT VARCHAR2(1000),
        ITM_INPT_HNDG_ADD3_TXT VARCHAR2(1000)
    )';
    EXECUTE IMMEDIATE q'[COMMENT ON COLUMN CSPD004TF.ITM_INPT_HNDG_ADD1_TXT IS '수기 추가 입력값 1 (1011 화면 동적 컬럼)']';
    EXECUTE IMMEDIATE q'[COMMENT ON COLUMN CSPD004TF.ITM_INPT_HNDG_ADD2_TXT IS '수기 추가 입력값 2 (1011 화면 동적 컬럼)']';
    EXECUTE IMMEDIATE q'[COMMENT ON COLUMN CSPD004TF.ITM_INPT_HNDG_ADD3_TXT IS '수기 추가 입력값 3 (1011 화면 동적 컬럼)']';
  END IF;
END;
/
