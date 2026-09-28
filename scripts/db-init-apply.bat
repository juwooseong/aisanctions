@echo off
REM 컨테이너의 /container-entrypoint-initdb.d 자동 실행이 유실된 경우(최초 부팅 중 재시작과
REM 겹치는 gvenzl 이미지의 알려진 타이밍 이슈) sql/ 폴더의 원본 DDL/데이터를 순서대로 수동 재적용한다.
REM 순서 근거: sql\00_drop.sql 상단 주석의 "신규 설치" 순서.
REM 이미 테이블이 존재하면 오류가 나므로, 완전 재적용은 db-reset.bat 사용.
cd /d "%~dp0.."
for %%f in (00_drop 01_ddl 02_sequence 03_test_data 26_task_auth_v2 27_qa_integ_v2 28_annotation 07_menu_role_test_data 04_review01_test_data 05_approv01_test_data 06_qauser01_test_data 30_task_auth_mig 31_dashboard_display_config 32_urgent_review_mig 33_home_menu_mig) do (
  echo === %%f ===
  docker exec -i aisanction-oracle bash -c "sqlplus -s sanction/sanction@//localhost:1521/FREEPDB1" < "sql\%%f.sql"
)
echo.
echo 적용 완료. scripts\db-status.bat 로 확인하세요.
