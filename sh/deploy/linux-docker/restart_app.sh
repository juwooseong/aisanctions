#!/usr/bin/env bash
# Linux Docker — compose 앱 서비스 재기동 (로컬/검증용)
# 은행 운영 JEUS에는 사용하지 않는다. JEUS는 linux/restart_app.sh.
#
#   ./restart_app.sh
#   APP_SERVICE=aisanction-app ./restart_app.sh
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck disable=SC1091
[[ -f "${SCRIPT_DIR}/env.example" ]] && . "${SCRIPT_DIR}/env.example"
[[ -f "${SCRIPT_DIR}/env.local" ]] && . "${SCRIPT_DIR}/env.local"

COMPOSE_FILE="${COMPOSE_FILE:-docker-compose.deploy.yml}"
APP_SERVICE="${APP_SERVICE:-aisanction-app}"
COMPOSE_PATH="${SCRIPT_DIR}/${COMPOSE_FILE}"

if [[ ! -f "${COMPOSE_PATH}" ]]; then
  echo "ERROR: ${COMPOSE_PATH} not found"
  echo "로컬 Tomcat/Nginx 검증용 compose를 두거나, 운영은 linux/restart_app.sh 를 사용하세요."
  exit 1
fi

cd "${SCRIPT_DIR}"
echo "docker compose -f ${COMPOSE_FILE} up -d --build ${APP_SERVICE}"
docker compose -f "${COMPOSE_FILE}" up -d --build "${APP_SERVICE}"
docker compose -f "${COMPOSE_FILE}" ps
echo "success"
exit 0
