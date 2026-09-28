-- ============================================================
-- CSPD007TL.LST_DB_CHG_DTM 컬럼 추가
-- 원인: CommonRevertDetailMapper.selectSafeWtchRst 등에서
--       CSPD007TL.LST_DB_CHG_DTM 참조 (필터링심사결과수신일시)
--
-- 실행: 기존 DB에 CSPD007TL이 이미 생성된 경우 1회 실행
--       신규 설치(01_ddl 수정본) 시 불필요
-- ============================================================

ALTER TABLE CSPD007TL ADD LST_DB_CHG_DTM VARCHAR2(20);

COMMENT ON COLUMN CSPD007TL.LST_DB_CHG_DTM IS '최종 DB 변경 일시';

UPDATE CSPD007TL
   SET LST_DB_CHG_DTM = '20250115120000'
 WHERE LST_DB_CHG_DTM IS NULL;

COMMIT;
