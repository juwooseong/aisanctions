@echo off
REM Oracle 컨테이너 정지 (데이터 볼륨은 유지)
cd /d "%~dp0.."
docker compose stop
