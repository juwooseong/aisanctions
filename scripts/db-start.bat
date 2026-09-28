@echo off
REM Oracle Database Free 컨테이너 기동 (최초 기동 시 db\init\02~06 스크립트 자동 적용)
cd /d "%~dp0.."
docker compose up -d
echo.
echo Oracle 컨테이너 기동 요청 완료. 최초 초기화는 수 분 걸릴 수 있습니다.
echo 상태 확인: scripts\db-status.bat
