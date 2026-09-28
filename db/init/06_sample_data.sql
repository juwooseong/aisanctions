-- =====================================================================
-- 06_sample_data.sql - sanction 계정
-- 화면 검증(로그인->1010->1011->2010->3010->QA->완료)이 가능하도록
-- 사용자/업무(60건)/이력을 생성한다. 상태값은 05_code_data.sql 에서
-- 실제 코드 근거(Java/매퍼 리터럴)로 확정한 CSPD112TI 값만 사용한다.
-- =====================================================================

-- ---- 사용자 ----
-- 로그인 화면(login.jsp:65-66)이 ID 8자 제한을 하드코딩하고 있어(실제 사번 체계 반영,
-- UI는 변경하지 않음) 샘플 ID를 8자 이내로 구성한다.
INSERT INTO CSPD101TI (AI_INPT_USER_ID, AI_INPT_USER_ENO, AI_INPT_USER_NM, AI_INPT_AUT_CD, AI_INPT_USER_YN, AI_INPT_MGPE_YN, AI_INPT_USER_RGS_DTM) VALUES ('admin',    'E9000','관리자',            '04','Y','Y',TO_CHAR(SYSDATE,'YYYYMMDDHH24MISS'));
INSERT INTO CSPD101TI (AI_INPT_USER_ID, AI_INPT_USER_ENO, AI_INPT_USER_NM, AI_INPT_AUT_CD, AI_INPT_USER_YN, AI_INPT_MGPE_YN, AI_INPT_USER_RGS_DTM) VALUES ('rev01',    'E1001','김심사',            '01','Y','N',TO_CHAR(SYSDATE,'YYYYMMDDHH24MISS'));
INSERT INTO CSPD101TI (AI_INPT_USER_ID, AI_INPT_USER_ENO, AI_INPT_USER_NM, AI_INPT_AUT_CD, AI_INPT_USER_YN, AI_INPT_MGPE_YN, AI_INPT_USER_RGS_DTM) VALUES ('rev02',    'E1002','이심사',            '01','Y','N',TO_CHAR(SYSDATE,'YYYYMMDDHH24MISS'));
INSERT INTO CSPD101TI (AI_INPT_USER_ID, AI_INPT_USER_ENO, AI_INPT_USER_NM, AI_INPT_AUT_CD, AI_INPT_USER_YN, AI_INPT_MGPE_YN, AI_INPT_USER_RGS_DTM) VALUES ('rev03',    'E1003','박심사',            '01','Y','N',TO_CHAR(SYSDATE,'YYYYMMDDHH24MISS'));
INSERT INTO CSPD101TI (AI_INPT_USER_ID, AI_INPT_USER_ENO, AI_INPT_USER_NM, AI_INPT_AUT_CD, AI_INPT_USER_YN, AI_INPT_MGPE_YN, AI_INPT_USER_RGS_DTM) VALUES ('appr01',   'E2001','최결재',            '02','Y','N',TO_CHAR(SYSDATE,'YYYYMMDDHH24MISS'));
INSERT INTO CSPD101TI (AI_INPT_USER_ID, AI_INPT_USER_ENO, AI_INPT_USER_NM, AI_INPT_AUT_CD, AI_INPT_USER_YN, AI_INPT_MGPE_YN, AI_INPT_USER_RGS_DTM) VALUES ('appr02',   'E2002','정결재',            '02','Y','N',TO_CHAR(SYSDATE,'YYYYMMDDHH24MISS'));
INSERT INTO CSPD101TI (AI_INPT_USER_ID, AI_INPT_USER_ENO, AI_INPT_USER_NM, AI_INPT_AUT_CD, AI_INPT_USER_YN, AI_INPT_MGPE_YN, AI_INPT_USER_RGS_DTM) VALUES ('qa01',      'E3001','강QA',             '03','Y','N',TO_CHAR(SYSDATE,'YYYYMMDDHH24MISS'));
INSERT INTO CSPD101TI (AI_INPT_USER_ID, AI_INPT_USER_ENO, AI_INPT_USER_NM, AI_INPT_AUT_CD, AI_INPT_USER_YN, AI_INPT_MGPE_YN, AI_INPT_USER_RGS_DTM) VALUES ('qaappr01', 'E3101','한QA결재',          '02','Y','N',TO_CHAR(SYSDATE,'YYYYMMDDHH24MISS'));
INSERT INTO CSPD101TI (AI_INPT_USER_ID, AI_INPT_USER_ENO, AI_INPT_USER_NM, AI_INPT_AUT_CD, AI_INPT_USER_YN, AI_INPT_MGPE_YN, AI_INPT_USER_RGS_DTM) VALUES ('user01',   'E4001','일반사용자',        '04','Y','N',TO_CHAR(SYSDATE,'YYYYMMDDHH24MISS'));

-- ---- 원장 (WINI 접수 소스) : 수출 30건 + 수입 30건 ----
DECLARE
  d DATE;
BEGIN
  FOR i IN 1..30 LOOP
    d := TO_DATE('20260901','YYYYMMDD') + MOD(i,20);
    INSERT INTO CSPD201TM (FX_ACNO, XPO_CVRG_MK_SQ, XPO_CVRG_MTBR_MK_DT, XPBY_COL_CTR_CUCD, XPBY_COL_AM,
        CUS_KORL_NM, CUS_ENG_NM, CSNO, KRBR_NM, DACC_BRCD, HS_CD, XPO_PTN_NACD, XPO_NACD, TRN_OPR_NO,
        INPT_ATMC_BIZ_DSCD, INPT_ATMC_REQ_DSCD, INPT_FAXC_AM)
    VALUES ('XPACNO'||LPAD(i,6,'0'), 1, TO_CHAR(d,'YYYYMMDD'), 'USD', 10000 + i*137.5,
        '(주)우리무역'||i, 'WOORI TRADING CO '||i, 'CS'||LPAD(i,6,'0'), '본점영업부', '001', '8471300000',
        CASE WHEN MOD(i,3)=0 THEN 'IR' WHEN MOD(i,4)=0 THEN 'KP' ELSE 'US' END,
        'KR', 'OPR'||LPAD(i,4,'0'), '2', '0', 10000 + i*137.5);
  END LOOP;

  FOR i IN 1..30 LOOP
    d := TO_DATE('20260901','YYYYMMDD') + MOD(i,20);
    INSERT INTO CSPD202TM (FX_ACNO, TDOC_RCP_SRNO, TDOC_RCP_DT, TDOC_RCP_CUCD, TDOC_RCP_AM,
        CUS_KORL_NM, CUS_ENG_NM, CSNO, KRBR_NM, DACC_BRCD, HS_CD, XPO_NACD, TRN_OPR_NO,
        INPT_ATMC_BIZ_DSCD, INPT_ATMC_REQ_DSCD, INPT_FAXC_AM)
    VALUES ('IMACNO'||LPAD(i,6,'0'), 1, TO_CHAR(d,'YYYYMMDD'), 'USD', 8000 + i*98.2,
        '(주)한국상사'||i, 'HANKOOK CORP '||i, 'CS'||LPAD(i+500,6,'0'), '강남지점', '002', '8517120000',
        CASE WHEN MOD(i,5)=0 THEN 'RU' ELSE 'CN' END,
        'OPR'||LPAD(i+1000,4,'0'), '1', '0', 8000 + i*98.2);
  END LOOP;
  COMMIT;
END;
/

-- =====================================================================
-- 업무(CSPD001TM) 60건 생성
-- 시나리오 배분(1~60, MOD 6 기준):
--  0(6,12..)  A 정상심사 완료           ACVT=160 APPV=160
--  1          B 반려 후 재심사 진행중    ACVT=90  APPV=120
--  2          C Block                  ACVT=140 APPV=140
--  3          D QA 진행/완료 혼합        ACVT=110/120/160 APPV/QLAS 다양
--  4          E 심사중                 ACVT=80/90 APPV=50
--  5          F 결재대기                ACVT=100 APPV=130
-- =====================================================================
DECLARE
  v_scn      NUMBER;
  v_biz      CHAR(1);          -- 1 수입 / 2 수출
  v_snpe     VARCHAR2(20);
  v_appr     VARCHAR2(20);
  v_acvt     VARCHAR2(4);
  v_appv     VARCHAR2(4);
  v_qlas_yn  CHAR(1);
  v_qlas_crpe VARCHAR2(20);
  v_qlas_snpe VARCHAR2(20);
  v_qlas_acvt VARCHAR2(4);
  v_rcpdt    VARCHAR2(8);
  v_fx       VARCHAR2(20);
  v_srno     VARCHAR2(4);
BEGIN
  FOR i IN 1..60 LOOP
    v_scn := MOD(i,6);
    -- 진행중 건(E 심사중, F 결재대기, B 재심사중)은 오늘~최근 3일에 집중시켜
    -- 대시보드/ToDo 화면(당일 기준 조회)에 데이터가 보이도록 하고,
    -- 완료/이력성 건(A/C/D)은 최근 15일에 걸쳐 분산시킨다.
    v_rcpdt := TO_CHAR(TRUNC(SYSDATE) - CASE WHEN v_scn IN (1,4,5) THEN MOD(i,3) ELSE MOD(i,15) END, 'YYYYMMDD');
    v_biz := CASE WHEN MOD(i,2)=0 THEN '2' ELSE '1' END; -- 짝수=수출, 홀수=수입
    -- 시나리오(MOD(i,6))와 담당자 배정 주기가 같은 배수 관계면 특정 시나리오가
    -- 항상 같은 담당자에게만 몰리므로(실측 버그: 심사중 건이 전부 rev02로 배정됨),
    -- 6과 서로소인 주기(5, 7)를 사용해 배정을 시나리오와 디커플링한다.
    v_snpe := CASE MOD(i,5) WHEN 0 THEN 'E1001' WHEN 1 THEN 'E1002' WHEN 2 THEN 'E1003' WHEN 3 THEN 'E1001' ELSE 'E1002' END;
    v_appr := CASE MOD(MOD(i,7),2) WHEN 0 THEN 'E2001' ELSE 'E2002' END;
    v_qlas_yn := NULL; v_qlas_crpe := NULL; v_qlas_snpe := NULL; v_qlas_acvt := NULL;

    IF v_biz = '2' THEN
      v_fx := 'XPACNO'||LPAD(MOD(i,30)+1,6,'0'); v_srno := '1';
    ELSE
      v_fx := 'IMACNO'||LPAD(MOD(i,30)+1,6,'0'); v_srno := '1';
    END IF;

    CASE v_scn
      WHEN 0 THEN v_acvt := '160'; v_appv := '160';                                   -- A 완료
      WHEN 1 THEN v_acvt := '90';  v_appv := '120';                                   -- B 반려->재심사중
      WHEN 2 THEN v_acvt := '140'; v_appv := '140';                                   -- C Block
      WHEN 3 THEN
        v_acvt := '160'; v_appv := '160'; v_qlas_yn := 'Y';
        v_qlas_crpe := 'E3001'; v_qlas_snpe := 'E3101';
        v_qlas_acvt := CASE MOD(i,3) WHEN 0 THEN '110' WHEN 1 THEN '120' ELSE '130' END; -- D QA진행/QA결재대기/QA결재상신
      WHEN 4 THEN v_acvt := CASE WHEN MOD(i,2)=0 THEN '80' ELSE '90' END; v_appv := '50'; -- E 심사중
      WHEN 5 THEN v_acvt := '100'; v_appv := '130';                                   -- F 결재대기
    END CASE;

    INSERT INTO CSPD001TM (
        INPT_MST_SRNO, INPT_RCP_DT, ACTL_FX_REFNO, FX_REFNO_SRNO, INPT_ATMC_BIZ_DSCD, INPT_ATMC_REQ_DSCD,
        AI_INSPE_ENO, AI_INPT_SNPE_ENO, AI_INPT_ACVT_CD, AI_INPT_APPV_STCD,
        TOTALTEXT_AI_INPT_RST_CD, ITM_INPT_AI_INPT_RST_CD, SAFEWATCH_AI_INPT_RST_CD,
        AI_INPT_IMG_KEY_NO, AI_INPT_DOC_SCAN_CHRG_ENO, AI_INPT_DOC_SCAN_DTM,
        QLAS_PRG_YN, QLAS_CRPE_ENO, QLAS_SNPE_ENO, QLAS_ALOC_DT, AI_INPT_QLAS_ACVT_CD,
        TRN_OPR_NO, LST_DB_CHG_ID, LST_DB_CHG_DTM
    ) VALUES (
        i, v_rcpdt, v_fx, v_srno, v_biz, '0',
        v_snpe, v_snpe, v_acvt, v_appv,
        CASE WHEN MOD(i,7)=0 THEN '2' ELSE '1' END,  -- 170: 1=정상,2=이상(가정) - AI 결과 다양화
        CASE WHEN MOD(i,7)=0 THEN '2' ELSE '1' END,
        CASE WHEN MOD(i,11)=0 THEN '2' ELSE '1' END,
        'IMGKEY'||LPAD(i,8,'0'), 'E4001', TO_CHAR(SYSDATE - MOD(i,20),'YYYYMMDDHH24MISS'),
        v_qlas_yn, v_qlas_crpe, v_qlas_snpe, CASE WHEN v_qlas_yn='Y' THEN v_rcpdt ELSE NULL END, v_qlas_acvt,
        'OPR'||LPAD(i,4,'0'), 'BATCH', TO_CHAR(SYSDATE,'YYYYMMDDHH24MISS')
    );

    -- 업무 상세(문서/이미지) 1건
    INSERT INTO CSPD002TG (INPT_MST_SRNO, INPT_TASK_ID, INPT_BL_GRP_NO, IMEX_HIS_CD, IMEX_HIS_SRNO,
        INPT_ELMT_ID, AI_INPT_PAPS_QLT_SCRE, LST_DB_CHG_ID, LST_DB_CHG_DTM)
    VALUES (i, 'TASK0001', 'BLGRP'||LPAD(i,6,'0'), v_biz, 1, 'ELMT001', 95.5, 'BATCH', TO_CHAR(SYSDATE,'YYYYMMDDHH24MISS'));

    -- 항목심사결과상세 (제재/AI 추출) 1~2건
    INSERT INTO CSPD004TF (INPT_MST_SRNO, INPT_TASK_ID, INPT_SANCTION_NO, SAFEWATCH_ITM_YN, ITM_INPT_RVSN_YN,
        INPT_SANCTION_DAT_TXT, AI_INPT_SANCTION_RULE_TXT, AI_INPT_EXTC_SNTN_TXT, ITM_INPT_NACRD_YN,
        LST_DB_CHG_ID, LST_DB_CHG_DTM)
    VALUES (i, 'TASK0001', 15, 'N', 'N', '(주)우리무역'||i, 'WatchList Rule1', 'Exporter Name', 'N',
        'BATCH', TO_CHAR(SYSDATE,'YYYYMMDDHH24MISS'));

    IF MOD(i,11)=0 THEN  -- 일부 건은 SafeWatch/제재 의심 항목 추가 (AI 자동심사 검수 시나리오 G)
      INSERT INTO CSPD004TF (INPT_MST_SRNO, INPT_TASK_ID, INPT_SANCTION_NO, SAFEWATCH_ITM_YN, ITM_INPT_RVSN_YN,
          INPT_SANCTION_DAT_TXT, AI_INPT_SANCTION_RULE_TXT, AI_INPT_EXTC_SNTN_TXT, ITM_INPT_NACRD_YN,
          LST_DB_CHG_ID, LST_DB_CHG_DTM)
      VALUES (i, 'TASK0001', 70, 'Y', 'Y', 'SANCTIONED PARTY '||i, 'WatchList Rule2', 'Consignee Name', 'Y',
          'BATCH', TO_CHAR(SYSDATE,'YYYYMMDDHH24MISS'));
    END IF;

    -- 첨부파일 1건
    INSERT INTO CSPD006TL (INPT_MST_SRNO, AI_INPT_ATFL_SRNO, AI_INPT_ATFL_NM, AI_INPT_ATFL_PATH_TXT, AI_INPT_BIZ_DSCD,
        LST_DB_CHG_ID, LST_DB_CHG_DTM)
    VALUES (i, 1, 'invoice_'||i||'.pdf', '/files/sample/invoice_'||i||'.pdf', v_biz, 'BATCH', TO_CHAR(SYSDATE,'YYYYMMDDHH24MISS'));

    -- 진행 이력 (접수->심사배정->...)
    INSERT INTO CSPD008TH (AI_INPT_PRG_SRNO, INPT_MST_SRNO, AI_INPT_BIZ_DSCD, AI_INPT_ACVT_CD, AI_INPT_ACVT_STS_CD,
        AI_INPT_CRPE_ENO, AI_INPT_PROS_STA_DTM, AI_INPT_PRC_OPI_TXT, LST_DB_CHG_ID, LST_DB_CHG_DTM)
    VALUES (CSPD008TH_SG01.NEXTVAL, i, v_biz, '10', '10', 'SYSTEM', TO_CHAR(SYSDATE - MOD(i,20),'YYYYMMDDHH24MISS'), 'WINI 접수', 'BATCH', TO_CHAR(SYSDATE,'YYYYMMDDHH24MISS'));

    INSERT INTO CSPD008TH (AI_INPT_PRG_SRNO, INPT_MST_SRNO, AI_INPT_BIZ_DSCD, AI_INPT_ACVT_CD, AI_INPT_ACVT_STS_CD,
        AI_INPT_CRPE_ENO, AI_INPT_PROS_STA_DTM, AI_INPT_PRC_OPI_TXT, LST_DB_CHG_ID, LST_DB_CHG_DTM)
    VALUES (CSPD008TH_SG01.NEXTVAL, i, v_biz, v_acvt, v_acvt, v_snpe, TO_CHAR(SYSDATE - MOD(i,10),'YYYYMMDDHH24MISS'),
        CASE v_scn WHEN 1 THEN '반려 - 서류 재확인 필요' WHEN 2 THEN 'Block - 제재대상 일치' ELSE '심사 진행' END,
        'BATCH', TO_CHAR(SYSDATE,'YYYYMMDDHH24MISS'));

    -- 결재 이력 (결재대상 건만)
    IF v_scn IN (0,1,2,3,5) THEN
      INSERT INTO CSPD005TH (AI_INPT_APPV_SRNO, INPT_MST_SRNO, AI_INPT_BIZ_DSCD, AI_INPT_CRPE_ENO,
          AI_INPT_PRC_OPI_TXT, AI_INPT_APPV_STCD, AI_INPT_PRC_DTM, LST_DB_CHG_ID, LST_DB_CHG_DTM)
      VALUES (CSPD005TH_SG01.NEXTVAL, i, v_biz, v_appr,
          CASE v_scn WHEN 1 THEN '증빙 서류 재확인 후 재상신 바랍니다' WHEN 2 THEN '제재대상 일치 - Block 처리' WHEN 0 THEN '승인합니다' ELSE NULL END,
          v_appv, TO_CHAR(SYSDATE - MOD(i,5),'YYYYMMDDHH24MISS'), 'BATCH', TO_CHAR(SYSDATE,'YYYYMMDDHH24MISS'));
    END IF;

    -- QA 대상 선정관리 (시나리오 D)
    IF v_scn = 3 THEN
      INSERT INTO CSPD107TI (QLAS_SLT_MNG_ID, AI_INPT_IMEX_DSCD, QLAS_ITM_TOT_CNT, QLAS_VOLN_CHC_CNT, QLAS_SLBS_VLD_YN,
          INPT_SANCTION_NO, QLAS_SLT_RGS_DTM)
      VALUES (CSPD107TI_SG01.NEXTVAL, v_biz, 1, 1, 'Y', 15, TO_CHAR(SYSDATE,'YYYYMMDDHH24MISS'));
    END IF;
  END LOOP;
  COMMIT;
END;
/

-- ---- 로그인 이력 샘플 ----
INSERT INTO CSPD810TH (AI_INPT_LGIN_HST_NO, AI_INPT_LGIN_USER_NO, AI_INPT_LGIN_DTM, AI_INPT_LGIN_USG_IPAD, AI_INPT_LGIN_USER_MCHR_NM, AI_INPT_LGIN_YN)
SELECT TO_CHAR(ROWNUM), AI_INPT_USER_ID, TO_CHAR(SYSDATE,'YYYYMMDDHH24MISS'), '127.0.0.1', 'LOCAL-PC', 'Y' FROM CSPD101TI;

COMMIT;
