-- ============================================================
-- CSPD105TI.AI_INPT_SNRL1_NM 누락 컬럼 추가
-- VARCHAR2(300) — CSPD106TI.AI_INPT_SNRL2_NM / CSPD113TI.AI_INPT_SNRL3_NM 과 동일
--
-- 증상: AdminSanctionMapper.selectListRule1 / selectInfoRule1
--       A.AI_INPT_SNRL1_NM 조회 시 ORA-00904
--
-- 실행: 기존 DB에 컬럼이 없는 경우 1회 실행
--       신규 설치(01_ddl 수정본) 시 불필요
-- ============================================================

ALTER TABLE CSPD105TI ADD AI_INPT_SNRL1_NM VARCHAR2(300);

COMMENT ON COLUMN CSPD105TI.AI_INPT_SNRL1_NM IS 'AI 심사 제재 룰 1단계명';

UPDATE CSPD105TI SET AI_INPT_SNRL1_NM = 'OFAC SDN' WHERE AI_INPT_SNRL1_ID = '01' AND AI_INPT_SNRL1_NM IS NULL;
UPDATE CSPD105TI SET AI_INPT_SNRL1_NM = 'EU Sanctions' WHERE AI_INPT_SNRL1_ID = '02' AND AI_INPT_SNRL1_NM IS NULL;

COMMIT;
