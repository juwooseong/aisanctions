-- ============================================================
-- 30_task_auth_mig.sql — 업무권한 TO-BE 데이터 마이그레이션
-- Tibero / Oracle
--
-- 전제: 26_task_auth_v2.sql 적용 완료 (CSPD119~124,127 + 001/005/101 ALTER)
-- 소스 연동: resolveAuthCodes / allowStageAction(per-task) / selectStdInfo Depth 백필
-- 목록: docs/to-be/권한_TO-BE_전환_변경_목록.md · docs/to-be/업무권한_TO-BE_데이터_마이그레이션.md
-- 실행 순서(운영):
--   1) 사전점검 (§0)
--   2) 본 스크립트 M1~M5 (트랜잭션 단위 커밋 권장)
--   3) 사후검증 (§V)
-- 롤백: §R (매트릭스·백필만 되돌림. DDL 롤백은 별도)
--
-- 매핑 원칙 (AS-IS → TO-BE):
--   AUT_CD=01 → USER_TYP=RVW + 전 업무 C1_YN=Y, DFLT_C2=기존 SNPE 또는 AUTO
--   AUT_CD=02 → USER_TYP=RVW + 전 업무 C2_YN=Y
--   AUT_CD=03 → USER_TYP=QA  + CSPD124TI QA1 (대상업무 기본 Y)
--   AUT_CD=04 → USER_TYP=GEN (매트릭스 없음)
--   AUT_CD=05 → USER_TYP=IT  (매트릭스 없음, MGPE 유지)
--   기존 건     → TASK_CD(119 매핑) + APPV_DEPTH_CD='2' (진행중 건 소급 1단 금지)
--
-- 주의:
--   - 이미 CSPD120 행이 있는 사용자는 SKIP (재실행 안전)
--   - INPT_ATMC_BIZ_DSCD ↔ CSPD119.INPT_ATMC_BIZ_DSCD 불일치 건은 TASK_CD NULL 잔존
--     → §V-3 로 확인 후 수동 매핑
--   - 시드 BPRS_* Depth=1 은 "신규 상신"부터 적용. 본 MIG 는 기존 건을 전부 Depth=2 로 고정
-- ============================================================

-- ------------------------------------------------------------
-- 0) 사전점검 (SELECT only)
-- ------------------------------------------------------------
-- 0-1 DDL 컬럼 존재
-- SELECT column_name FROM user_tab_columns
--  WHERE table_name='CSPD001TM' AND column_name IN ('AI_INPT_TASK_CD','AI_INPT_APPV_DEPTH_CD');
-- SELECT COUNT(*) FROM CSPD119TI WHERE AI_INPT_TASK_USG_YN='Y';

-- 0-2 AS-IS 사용자 분포
-- SELECT AI_INPT_AUT_CD, COUNT(*) CNT
--   FROM CSPD101TI WHERE AI_INPT_USER_YN='Y'
--  GROUP BY AI_INPT_AUT_CD ORDER BY 1;

-- 0-3 업무코드 매핑 갭 (마스터 건의 BIZ_DSCD 가 119 에 없음)
-- SELECT m.INPT_ATMC_BIZ_DSCD, COUNT(*) CNT
--   FROM CSPD001TM m
--   LEFT JOIN CSPD119TI t ON t.INPT_ATMC_BIZ_DSCD = m.INPT_ATMC_BIZ_DSCD
--  WHERE t.AI_INPT_TASK_CD IS NULL
--  GROUP BY m.INPT_ATMC_BIZ_DSCD;


-- ------------------------------------------------------------
-- M1) CSPD101TI — USER_TYP / BRCD 보정
-- ------------------------------------------------------------
UPDATE CSPD101TI
   SET AI_INPT_USER_TYP_CD = CASE TRIM(AI_INPT_AUT_CD)
           WHEN '01' THEN 'RVW'
           WHEN '02' THEN 'RVW'
           WHEN '03' THEN 'QA'
           WHEN '04' THEN 'GEN'
           WHEN '05' THEN 'IT'
           ELSE NVL(AI_INPT_USER_TYP_CD, 'GEN')
         END,
       AI_INPT_BRCD = NVL(AI_INPT_BRCD, '0000'),
       LST_DB_CHG_ID = 'MIG30',
       LST_DB_CHG_DTM = TO_CHAR(SYSTIMESTAMP, 'YYYYMMDDHH24MISS')
 WHERE AI_INPT_USER_YN = 'Y'
   AND (AI_INPT_USER_TYP_CD IS NULL OR TRIM(AI_INPT_USER_TYP_CD) IS NULL);

COMMIT;


-- ------------------------------------------------------------
-- M2) CSPD120TI — AUT_CD=01 → 전 업무 C1
--     기존 SNPE_ENO 를 DFLT_C2_ENO 로 이관 (본인/빈값 → AUTO)
-- ------------------------------------------------------------
INSERT INTO CSPD120TI (
    AI_INPT_TASK_ROLE_ID, AI_INPT_USER_ENO, AI_INPT_TASK_CD,
    AI_INPT_C1_YN, AI_INPT_C2_YN, AI_INPT_DFLT_C2_ENO,
    AI_INPT_ROLE_STA_DTM, AI_INPT_ROLE_END_DTM, AI_INPT_ROLE_USG_YN,
    AI_INPT_RMRK_TXT, LST_DB_CHG_ID, LST_DB_CHG_DTM
)
SELECT CSPD120TI_SG01.NEXTVAL,
       u.AI_INPT_USER_ENO,
       t.AI_INPT_TASK_CD,
       'Y',
       'N',
       CASE
         WHEN u.AI_INPT_SNPE_ENO IS NULL OR TRIM(u.AI_INPT_SNPE_ENO) IS NULL THEN 'AUTO'
         WHEN u.AI_INPT_SNPE_ENO = u.AI_INPT_USER_ENO THEN 'AUTO'
         ELSE u.AI_INPT_SNPE_ENO
       END,
       '20200101000000',
       '99991231235959',
       'Y',
       'MIG30 AUT=01→C1',
       'MIG30',
       TO_CHAR(SYSTIMESTAMP, 'YYYYMMDDHH24MISS')
  FROM CSPD101TI u
 CROSS JOIN CSPD119TI t
 WHERE u.AI_INPT_USER_YN = 'Y'
   AND TRIM(u.AI_INPT_AUT_CD) = '01'
   AND NVL(u.AI_INPT_USER_TYP_CD, 'RVW') = 'RVW'
   AND t.AI_INPT_TASK_USG_YN = 'Y'
   AND NOT EXISTS (
         SELECT 1 FROM CSPD120TI r
          WHERE r.AI_INPT_USER_ENO = u.AI_INPT_USER_ENO
            AND r.AI_INPT_TASK_CD  = t.AI_INPT_TASK_CD
       );

COMMIT;


-- ------------------------------------------------------------
-- M3) CSPD120TI — AUT_CD=02 → 전 업무 C2
-- ------------------------------------------------------------
INSERT INTO CSPD120TI (
    AI_INPT_TASK_ROLE_ID, AI_INPT_USER_ENO, AI_INPT_TASK_CD,
    AI_INPT_C1_YN, AI_INPT_C2_YN, AI_INPT_DFLT_C2_ENO,
    AI_INPT_ROLE_STA_DTM, AI_INPT_ROLE_END_DTM, AI_INPT_ROLE_USG_YN,
    AI_INPT_RMRK_TXT, LST_DB_CHG_ID, LST_DB_CHG_DTM
)
SELECT CSPD120TI_SG01.NEXTVAL,
       u.AI_INPT_USER_ENO,
       t.AI_INPT_TASK_CD,
       'N',
       'Y',
       NULL,
       '20200101000000',
       '99991231235959',
       'Y',
       'MIG30 AUT=02→C2',
       'MIG30',
       TO_CHAR(SYSTIMESTAMP, 'YYYYMMDDHH24MISS')
  FROM CSPD101TI u
 CROSS JOIN CSPD119TI t
 WHERE u.AI_INPT_USER_YN = 'Y'
   AND TRIM(u.AI_INPT_AUT_CD) = '02'
   AND NVL(u.AI_INPT_USER_TYP_CD, 'RVW') = 'RVW'
   AND t.AI_INPT_TASK_USG_YN = 'Y'
   AND NOT EXISTS (
         SELECT 1 FROM CSPD120TI r
          WHERE r.AI_INPT_USER_ENO = u.AI_INPT_USER_ENO
            AND r.AI_INPT_TASK_CD  = t.AI_INPT_TASK_CD
       );

COMMIT;


-- ------------------------------------------------------------
-- M4) CSPD124TI — AUT_CD=03 → QA1 프로필 (대상업무 기본 전부 Y)
-- ------------------------------------------------------------
MERGE INTO CSPD124TI t
USING (
    SELECT u.AI_INPT_USER_ENO AS ENO
      FROM CSPD101TI u
     WHERE u.AI_INPT_USER_YN = 'Y'
       AND TRIM(u.AI_INPT_AUT_CD) = '03'
) s
   ON (t.AI_INPT_USER_ENO = s.ENO)
 WHEN MATCHED THEN UPDATE SET
       AI_INPT_QA1_YN      = 'Y',
       AI_INPT_QA_EXP_YN   = NVL(t.AI_INPT_QA_EXP_YN, 'Y'),
       AI_INPT_QA_WRK_YN   = NVL(t.AI_INPT_QA_WRK_YN, 'Y'),
       AI_INPT_QA_SW_YN    = NVL(t.AI_INPT_QA_SW_YN, 'Y'),
       AI_INPT_DFLT_QA2_ENO = NVL(t.AI_INPT_DFLT_QA2_ENO, 'AUTO'),
       LST_DB_CHG_ID       = 'MIG30',
       LST_DB_CHG_DTM      = TO_CHAR(SYSTIMESTAMP, 'YYYYMMDDHH24MISS')
 WHEN NOT MATCHED THEN INSERT (
       AI_INPT_USER_ENO, AI_INPT_QA1_YN, AI_INPT_QA2_YN, AI_INPT_DFLT_QA2_ENO,
       AI_INPT_QA_EXP_YN, AI_INPT_QA_WRK_YN, AI_INPT_QA_SW_YN,
       LST_DB_CHG_ID, LST_DB_CHG_DTM
 ) VALUES (
       s.ENO, 'Y', 'N', 'AUTO',
       'Y', 'Y', 'Y',
       'MIG30', TO_CHAR(SYSTIMESTAMP, 'YYYYMMDDHH24MISS')
 );

-- QA 유형이면 매트릭스 제거 (유형 규칙)
DELETE FROM CSPD120TI r
 WHERE EXISTS (
       SELECT 1 FROM CSPD101TI u
        WHERE u.AI_INPT_USER_ENO = r.AI_INPT_USER_ENO
          AND TRIM(u.AI_INPT_AUT_CD) = '03'
 );

COMMIT;


-- ------------------------------------------------------------
-- M5) CSPD001TM — 진행/완료 건 TASK_CD · Depth=2 백필
--     (기존 건은 전부 2단 유지 — 정책 Depth=1 소급 금지)
-- ------------------------------------------------------------
UPDATE CSPD001TM m
   SET m.AI_INPT_TASK_CD = (
           SELECT t.AI_INPT_TASK_CD
             FROM CSPD119TI t
            WHERE t.INPT_ATMC_BIZ_DSCD = m.INPT_ATMC_BIZ_DSCD
              AND t.AI_INPT_TASK_USG_YN = 'Y'
              AND ROWNUM = 1
       ),
       m.AI_INPT_APPV_DEPTH_CD = NVL(m.AI_INPT_APPV_DEPTH_CD, '2'),
       m.LST_DB_CHG_ID = 'MIG30',
       m.LST_DB_CHG_DTM = TO_CHAR(SYSTIMESTAMP, 'YYYYMMDDHH24MISS')
 WHERE m.AI_INPT_TASK_CD IS NULL
   AND EXISTS (
         SELECT 1 FROM CSPD119TI t
          WHERE t.INPT_ATMC_BIZ_DSCD = m.INPT_ATMC_BIZ_DSCD
            AND t.AI_INPT_TASK_USG_YN = 'Y'
       );

-- Depth 만 NULL 인 건
UPDATE CSPD001TM
   SET AI_INPT_APPV_DEPTH_CD = '2',
       LST_DB_CHG_ID = 'MIG30',
       LST_DB_CHG_DTM = TO_CHAR(SYSTIMESTAMP, 'YYYYMMDDHH24MISS')
 WHERE AI_INPT_APPV_DEPTH_CD IS NULL;

COMMIT;


-- ------------------------------------------------------------
-- M6) 이력 (요약 1건)
-- ------------------------------------------------------------
INSERT INTO CSPD123TH (
    AI_INPT_AUTH_CHG_SRNO, AI_INPT_CHG_TYP_CD,
    AI_INPT_USER_ENO, AI_INPT_TASK_CD,
    AI_INPT_BF_CHG_TXT, AI_INPT_AF_CHG_TXT,
    AI_INPT_CHG_USER_ENO, AI_INPT_CHG_DTM,
    LST_DB_CHG_ID, LST_DB_CHG_DTM
) VALUES (
    CSPD123TH_SG01.NEXTVAL, 'MATRIX',
    NULL, NULL,
    'AS-IS AUT_CD 1:1',
    'MIG30: AUT→120/124 + case TASK/DEPTH backfill',
    'MIG30', TO_CHAR(SYSTIMESTAMP, 'YYYYMMDDHH24MISS'),
    'MIG30', TO_CHAR(SYSTIMESTAMP, 'YYYYMMDDHH24MISS')
);

COMMIT;


-- ============================================================
-- V) 사후검증
-- ============================================================

-- V-1 사용자별 매트릭스/QA 적재
-- SELECT u.AI_INPT_USER_ENO, u.AI_INPT_AUT_CD, u.AI_INPT_USER_TYP_CD,
--        (SELECT COUNT(*) FROM CSPD120TI r WHERE r.AI_INPT_USER_ENO=u.AI_INPT_USER_ENO AND r.AI_INPT_ROLE_USG_YN='Y') AS MTX,
--        (SELECT COUNT(*) FROM CSPD124TI q WHERE q.AI_INPT_USER_ENO=u.AI_INPT_USER_ENO) AS QA
--   FROM CSPD101TI u
--  WHERE u.AI_INPT_USER_YN='Y'
--  ORDER BY u.AI_INPT_AUT_CD, u.AI_INPT_USER_ENO;

-- V-2 AUT=01 인데 C1 매트릭스 0건 (이관 누락)
-- SELECT u.AI_INPT_USER_ENO, u.AI_INPT_USER_NM
--   FROM CSPD101TI u
--  WHERE u.AI_INPT_USER_YN='Y' AND TRIM(u.AI_INPT_AUT_CD)='01'
--    AND NOT EXISTS (
--          SELECT 1 FROM CSPD120TI r
--           WHERE r.AI_INPT_USER_ENO=u.AI_INPT_USER_ENO AND r.AI_INPT_C1_YN='Y');

-- V-3 TASK_CD 미매핑 잔존 건
-- SELECT INPT_ATMC_BIZ_DSCD, COUNT(*) CNT
--   FROM CSPD001TM WHERE AI_INPT_TASK_CD IS NULL
--  GROUP BY INPT_ATMC_BIZ_DSCD;

-- V-4 Depth NULL 잔존
-- SELECT COUNT(*) FROM CSPD001TM WHERE AI_INPT_APPV_DEPTH_CD IS NULL;

-- V-5 겸임 충돌 (DUAL=N 인데 C1+C2 동시)
-- SELECT r.AI_INPT_USER_ENO, r.AI_INPT_TASK_CD, t.AI_INPT_TASK_NM
--   FROM CSPD120TI r
--   JOIN CSPD119TI t ON t.AI_INPT_TASK_CD = r.AI_INPT_TASK_CD
--  WHERE r.AI_INPT_C1_YN='Y' AND r.AI_INPT_C2_YN='Y'
--    AND t.AI_INPT_DUAL_ROLE_YN='N'
--    AND r.AI_INPT_ROLE_USG_YN='Y';


-- ============================================================
-- R) 롤백 (매트릭스·QA·백필만 — DDL 유지)
-- ============================================================
-- DELETE FROM CSPD120TI WHERE LST_DB_CHG_ID = 'MIG30';
-- DELETE FROM CSPD124TI WHERE LST_DB_CHG_ID = 'MIG30';
-- UPDATE CSPD001TM SET AI_INPT_TASK_CD=NULL, AI_INPT_APPV_DEPTH_CD=NULL
--  WHERE LST_DB_CHG_ID='MIG30';
-- DELETE FROM CSPD123TH WHERE AI_INPT_CHG_USER_ENO='MIG30';
-- COMMIT;
