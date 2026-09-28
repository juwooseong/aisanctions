-- ============================================================
-- CSPD004TF.ITM_INPT_NACRD_YN 컬럼 추가
-- 원인: CommonRevertDetailMapper 등에서 CSPD004TF.ITM_INPT_NACRD_YN 참조
--       (항목별 불일치 여부)
--
-- 실행: 기존 DB에 CSPD004TF가 이미 생성된 경우 1회 실행
--       신규 설치(01_ddl 수정본) 시 불필요
-- ============================================================

ALTER TABLE CSPD004TF ADD ITM_INPT_NACRD_YN CHAR(1);

COMMENT ON COLUMN CSPD004TF.ITM_INPT_NACRD_YN IS '항목별 불일치 여부';

UPDATE CSPD004TF
   SET ITM_INPT_NACRD_YN = 'N'
 WHERE ITM_INPT_NACRD_YN IS NULL;

COMMIT;
