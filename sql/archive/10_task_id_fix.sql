-- ============================================================
-- INPT_TASK_ID 숫자 형식 보정
-- 원인: CommonRevertDetailMapper.selectTopTab 등에서
--       ORDER BY TO_NUMBER(A.INPT_TASK_ID) 사용
--       'TASK10001' 형태는 ORA-01722(수치가 부적합합니다) 발생
--
-- 실행: 기존 DB에 테스트 데이터가 이미 적재된 경우 1회 실행
--       신규 설치 시 03~06 수정본 사용 시 불필요
-- ============================================================

UPDATE CSPD001TM
   SET INPT_TASK_ID = SUBSTR(INPT_TASK_ID, 5)
 WHERE INPT_TASK_ID LIKE 'TASK%';

UPDATE CSPD002TG
   SET INPT_TASK_ID = SUBSTR(INPT_TASK_ID, 5)
 WHERE INPT_TASK_ID LIKE 'TASK%';

UPDATE CSPD003TF
   SET INPT_TASK_ID = SUBSTR(INPT_TASK_ID, 5)
 WHERE INPT_TASK_ID LIKE 'TASK%';

UPDATE CSPD004TF
   SET INPT_TASK_ID = SUBSTR(INPT_TASK_ID, 5)
 WHERE INPT_TASK_ID LIKE 'TASK%';

COMMIT;
