-- =====================================================================
-- 01_create_user.sql
-- gvenzl/oracle-free 이미지는 컨테이너 기동 시 APP_USER/APP_USER_PASSWORD
-- 환경변수로 애플리케이션 계정(sanction)을 FREEPDB1에 자동 생성한다.
-- 이 스크립트는 계정이 정상 생성되었는지 검증하고, 로컬 개발에 필요한
-- 최소 권한을 보강하는 용도로만 사용한다. (SYS/SYSTEM으로 접속해서 실행)
-- =====================================================================

ALTER SESSION SET CONTAINER = FREEPDB1;

-- 계정 존재 확인 (없으면 이미지가 APP_USER를 생성하지 못한 것 - 컨테이너 로그 확인 필요)
-- SELECT username, account_status FROM dba_users WHERE username = 'SANCTION';

GRANT CONNECT, RESOURCE TO sanction;
GRANT CREATE VIEW TO sanction;
GRANT UNLIMITED TABLESPACE TO sanction;

-- WM_CONCAT 대체(LISTAGG)는 SQL 문법이므로 별도 권한 불필요.
