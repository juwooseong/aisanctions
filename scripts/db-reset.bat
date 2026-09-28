@echo off
REM 개발 DB 완전 초기화: 컨테이너/볼륨 삭제 후 재생성 (샘플 데이터 재생성 포함)
REM 주의: oracle_data 볼륨의 모든 데이터가 삭제됩니다.
cd /d "%~dp0.."
set /p CONFIRM=정말 로컬 Oracle DB를 초기화하시겠습니까? (y/N):
if /I not "%CONFIRM%"=="y" (
  echo 취소되었습니다.
  exit /b 0
)
docker compose down -v
docker compose up -d
echo.
echo 초기화 요청 완료. 컨테이너가 기동되며 db\init\02~06 스크립트가 재적용됩니다.
echo 진행 상황: docker compose logs -f oracle
