-- ============================================================
-- CSPD900TI 누락 컬럼 추가
-- 컬럼: AI_INPT_SVR_INF_TXT
-- 원인: AdminStatus MyBatis에서 수행서버(AI_INPT_SVR_INF_TXT) 컬럼 참조
--
-- 실행: 기존 DB에 CSPD900TI가 이미 생성된 경우 1회 실행
--       신규 설치(01_ddl 수정본) 시 불필요
--       이미 추가된 컬럼은 ORA-01430 등으로 무시 후 다음 문장 진행
-- ============================================================

ALTER TABLE CSPD900TI ADD AI_INPT_SVR_INF_TXT VARCHAR2(300);

COMMENT ON COLUMN CSPD900TI.AI_INPT_SVR_INF_TXT IS 'AI 심사 수행 서버 정보';

-- 테스트 데이터 보정
UPDATE CSPD900TI SET AI_INPT_SVR_INF_TXT = NVL(AI_INPT_SVR_INF_TXT, '1') WHERE INPT_MST_SRNO = 10001;
UPDATE CSPD900TI SET AI_INPT_SVR_INF_TXT = NVL(AI_INPT_SVR_INF_TXT, '2') WHERE INPT_MST_SRNO = 10002;
UPDATE CSPD900TI SET AI_INPT_SVR_INF_TXT = NVL(AI_INPT_SVR_INF_TXT, '1') WHERE INPT_MST_SRNO = 10003;
UPDATE CSPD900TI SET AI_INPT_SVR_INF_TXT = NVL(AI_INPT_SVR_INF_TXT, '1') WHERE INPT_MST_SRNO BETWEEN 10004 AND 10015;

COMMIT;
