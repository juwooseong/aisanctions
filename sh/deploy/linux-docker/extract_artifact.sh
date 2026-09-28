#!/usr/bin/env bash
# Docker 빌드 산출물(WAR)을 호스트 경로로 추출·정리
#   ./extract_artifact.sh [/dest/dir]
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/../../.." && pwd)"
DEST="${1:-${PROJECT_ROOT}/target/docker-out/artifact}"

mkdir -p "${DEST}"
shopt -s nullglob
wars=("${PROJECT_ROOT}/target"/aisanction-*.war)
if [[ ${#wars[@]} -eq 0 ]]; then
  echo "ERROR: no WAR under ${PROJECT_ROOT}/target — run build_app.sh first"
  exit 1
fi

cp -f "${wars[@]}" "${DEST}/"
(cd "${DEST}" && sha256sum aisanction-*.war | grep -vE 'sources|javadoc' | tee war.sha256)
echo "Extracted to ${DEST}"
echo "success"
exit 0
