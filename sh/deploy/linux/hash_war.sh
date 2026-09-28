#!/usr/bin/env bash
# Linux — WAR SHA256 (반입 검증용)
#   ./hash_war.sh [/path/to/aisanction-1.0.0.war]
set -euo pipefail

WAR="${1:-}"
if [[ -z "${WAR}" ]]; then
  BUILD_HOME="${AISANCTION_BUILD_HOME:-/home/aisac/build/aisanction}"
  WAR="$(ls -1t "${BUILD_HOME}/target"/aisanction-*.war 2>/dev/null | grep -vE 'sources|javadoc' | head -1 || true)"
fi
if [[ -z "${WAR}" || ! -f "${WAR}" ]]; then
  echo "WAR not found"
  exit 1
fi

OUT="$(dirname "${WAR}")/war.sha256"
sha256sum "${WAR}" | tee "${OUT}"
echo "success"
exit 0
