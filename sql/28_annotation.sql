-- ============================================================
-- SCR-1011 심사상세 형광펜·핀고정 — 테이블
-- Tibero / Oracle
-- 실행: 27_qa_integ_v2.sql 이후, 07_menu_role_test_data 이전
--       00_drop → 01_ddl → 02_sequence → 03_test_data
--       → 26_task_auth_v2 → 27_qa_integ_v2 → 28_annotation → 07 → 04~06
-- 문서: docs/wireframes/ANNOTATION-MARKER-PIN-GUIDE.md
--
-- 번호: CSPD134TA (130~133 = KG 예약)
-- 물리 FK 없음. DROP 은 00_drop.sql.
-- ============================================================

CREATE SEQUENCE CSPD134TA_SG01 START WITH 1000 INCREMENT BY 1 NOCACHE NOCYCLE;

CREATE TABLE CSPD134TA (
    AI_INPT_ANNO_SRNO                NUMBER(19)     NOT NULL,
    INPT_MST_SRNO                    NUMBER(19)     NOT NULL,
    INPT_TASK_ID                     VARCHAR2(64)   NOT NULL,
    INPT_BL_GRP_NO                   VARCHAR2(64),
    IMEX_HIS_CD                      VARCHAR2(32),
    AI_INPT_ANNO_TYP_CD              VARCHAR2(8)    NOT NULL,
    AI_INPT_ANNO_ID                  VARCHAR2(64)   NOT NULL,
    AI_INPT_COLOR_VAL                VARCHAR2(64),
    AI_INPT_LINE_WD                  NUMBER(10,2),
    AI_INPT_POINTS_TXT               VARCHAR2(4000),
    AI_INPT_PIN_X                    NUMBER(12,2),
    AI_INPT_PIN_Y                    NUMBER(12,2),
    AI_INPT_OPINION_TXT              VARCHAR2(1000),
    AI_INPT_IMG_WD                   NUMBER(10),
    AI_INPT_IMG_HT                   NUMBER(10),
    AI_INPT_USG_YN                   CHAR(1)        DEFAULT 'Y' NOT NULL,
    TRN_LOG_SRNO                     VARCHAR2(60),
    LST_DB_CHG_ID                    VARCHAR2(64),
    LST_DB_CHG_DTM                   VARCHAR2(20),
    CONSTRAINT PK_CSPD134TA PRIMARY KEY (AI_INPT_ANNO_SRNO),
    CONSTRAINT CK_CSPD134TA_01 CHECK (AI_INPT_USG_YN IN ('Y', 'N')),
    CONSTRAINT CK_CSPD134TA_02 CHECK (AI_INPT_ANNO_TYP_CD IN ('MK', 'PIN'))
);

COMMENT ON TABLE  CSPD134TA IS '심사상세 형광펜·핀고정 어노테이션';
COMMENT ON COLUMN CSPD134TA.AI_INPT_ANNO_SRNO IS '어노테이션 일련번호';
COMMENT ON COLUMN CSPD134TA.INPT_MST_SRNO IS '심사마스터일련번호';
COMMENT ON COLUMN CSPD134TA.INPT_TASK_ID IS '이미지(페이지) 아이디';
COMMENT ON COLUMN CSPD134TA.INPT_BL_GRP_NO IS 'BL그룹번호';
COMMENT ON COLUMN CSPD134TA.IMEX_HIS_CD IS '문서분류코드';
COMMENT ON COLUMN CSPD134TA.AI_INPT_ANNO_TYP_CD IS 'MK=형광펜, PIN=핀고정';
COMMENT ON COLUMN CSPD134TA.AI_INPT_ANNO_ID IS '클라이언트/서버 식별자';
COMMENT ON COLUMN CSPD134TA.AI_INPT_COLOR_VAL IS '형광펜 색상 CSS';
COMMENT ON COLUMN CSPD134TA.AI_INPT_LINE_WD IS '형광펜 두께(원본 px)';
COMMENT ON COLUMN CSPD134TA.AI_INPT_POINTS_TXT IS '형광펜 점열 JSON [[x,y],...]';
COMMENT ON COLUMN CSPD134TA.AI_INPT_PIN_X IS '핀 원본 X';
COMMENT ON COLUMN CSPD134TA.AI_INPT_PIN_Y IS '핀 원본 Y';
COMMENT ON COLUMN CSPD134TA.AI_INPT_OPINION_TXT IS '핀 심사 의견';
COMMENT ON COLUMN CSPD134TA.AI_INPT_IMG_WD IS '저장 시점 원본 가로';
COMMENT ON COLUMN CSPD134TA.AI_INPT_IMG_HT IS '저장 시점 원본 세로';
COMMENT ON COLUMN CSPD134TA.AI_INPT_USG_YN IS '사용여부';
