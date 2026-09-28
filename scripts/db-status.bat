@echo off
cd /d "%~dp0.."
docker compose ps
echo.
echo --- healthcheck (SELECT 1 FROM DUAL) ---
docker exec aisanction-oracle bash -c "echo 'SELECT 1 FROM DUAL;' | sqlplus -s sanction/sanction@//localhost:1521/FREEPDB1"
