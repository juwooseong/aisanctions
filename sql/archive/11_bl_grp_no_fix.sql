-- ============================================================
-- INPT_BL_GRP_NO 숫자 문자열 보정
-- 운영/매퍼 기대값: '1', '2' 등 숫자 문자열 (예: selectTopTab → 'BL' || INPT_BL_GRP_NO)
-- 테스트 데이터 'BL20250001' 형태를 '1'로 통일 (마스터당 BL그룹 1개)
--
-- 실행: 기존 DB에 테스트 데이터가 이미 적재된 경우 1회 실행
-- ============================================================

UPDATE CSPD001TM
   SET INPT_BL_GRP_NO = '1'
 WHERE INPT_BL_GRP_NO LIKE 'BL2025%';

UPDATE CSPD002TG
   SET INPT_BL_GRP_NO = '1'
 WHERE INPT_BL_GRP_NO LIKE 'BL2025%';

UPDATE CSPD004TF
   SET INPT_BL_GRP_NO = '1'
 WHERE INPT_BL_GRP_NO LIKE 'BL2025%';

UPDATE CSPD007TL
   SET INPT_BL_GRP_NO = '1'
 WHERE INPT_BL_GRP_NO LIKE 'BL2025%';

COMMIT;
