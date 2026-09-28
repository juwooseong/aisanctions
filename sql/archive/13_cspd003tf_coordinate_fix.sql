-- ============================================================
-- CSPD003TF TotalText 좌표 컬럼 추가
-- 원인: CommonRevertDetailMapper에서 CSPD003TF의 X/Y 시작·종료 좌표 참조
--
-- 실행: 기존 DB에 CSPD003TF가 이미 생성된 경우 1회 실행
--       신규 설치(01_ddl 수정본) 시 불필요
-- ============================================================

ALTER TABLE CSPD003TF ADD (
    ITM_INPT_XAXIS_STA_CRDN_CN NUMBER(20,4),
    ITM_INPT_YAXIS_STA_CRDN_CN NUMBER(20,4),
    ITM_INPT_XAXIS_END_CRDN_CN NUMBER(20,4),
    ITM_INPT_YAXIS_END_CRDN_CN NUMBER(20,4)
);

COMMENT ON COLUMN CSPD003TF.ITM_INPT_XAXIS_STA_CRDN_CN IS '항목 X축 시작 좌표값';
COMMENT ON COLUMN CSPD003TF.ITM_INPT_YAXIS_STA_CRDN_CN IS '항목 Y축 시작 좌표값';
COMMENT ON COLUMN CSPD003TF.ITM_INPT_XAXIS_END_CRDN_CN IS '항목 X축 종료 좌표값';
COMMENT ON COLUMN CSPD003TF.ITM_INPT_YAXIS_END_CRDN_CN IS '항목 Y축 종료 좌표값';

COMMIT;
