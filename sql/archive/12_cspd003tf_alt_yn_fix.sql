-- ============================================================
-- CSPD003TF.AI_INPT_ALT_YN 컬럼 추가
-- 원인: CommonRevertDetailMapper 등에서 CSPD003TF.AI_INPT_ALT_YN 참조
--       DDL/테스트데이터에 컬럼 누락
--
-- 실행: 기존 DB에 CSPD003TF가 이미 생성된 경우 1회 실행
--       신규 설치(01_ddl 수정본) 시 불필요
-- ============================================================

ALTER TABLE CSPD003TF ADD AI_INPT_ALT_YN CHAR(1);

COMMENT ON COLUMN CSPD003TF.AI_INPT_ALT_YN IS 'AI 심사 알림 여부';

UPDATE CSPD003TF T
   SET AI_INPT_ALT_YN = NVL(
         (SELECT M.ALERT_YN FROM CSPD001TM M WHERE M.INPT_MST_SRNO = T.INPT_MST_SRNO),
         'N')
 WHERE T.AI_INPT_ALT_YN IS NULL;

COMMIT;
