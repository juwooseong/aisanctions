#!/usr/bin/env bash
# Linux Docker — Maven 이미지로 WAR 빌드 (호스트 JDK 불필요)
#   ./build_app.sh
#   MVN_DENV=p MAVEN_IMAGE=maven:3.9-eclipse-temurin-21 ./build_app.sh
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck disable=SC1091
[[ -f "${SCRIPT_DIR}/env.example" ]] && . "${SCRIPT_DIR}/env.example"
[[ -f "${SCRIPT_DIR}/env.local" ]] && . "${SCRIPT_DIR}/env.local"

PROJECT_ROOT="$(cd "${SCRIPT_DIR}/../../.." && pwd)"
MAVEN_IMAGE="${MAVEN_IMAGE:-maven:3.9-eclipse-temurin-8}"
MVN_DENV="${MVN_DENV:-d}"
HOST_OUT_DIR="${HOST_OUT_DIR:-${PROJECT_ROOT}/target/docker-out}"
M2_CACHE="${M2_CACHE:-${HOME}/.m2}"

mkdir -p "${HOST_OUT_DIR}" "${M2_CACHE}"
DATE="$(date '+%Y%m%d')"
TIME="$(date '+%H%M%S')"
LOG="${HOST_OUT_DIR}/aisanction_docker_build_${DATE}_${TIME}.log"

echo "DOCKER_MAVEN_BUILD_START" | tee "${LOG}"
echo "IMAGE=${MAVEN_IMAGE} ENV=${MVN_DENV} ROOT=${PROJECT_ROOT}" | tee -a "${LOG}"

docker run --rm \
  -v "${PROJECT_ROOT}:/workspace" \
  -v "${M2_CACHE}:/root/.m2" \
  -w /workspace \
  "${MAVEN_IMAGE}" \
  mvn clean package -Denv="${MVN_DENV}" -Dmaven.test.skip=true \
  2>&1 | tee -a "${LOG}"

# 산출물 스냅샷 (호스트 target → docker-out)
mkdir -p "${HOST_OUT_DIR}/artifact"
cp -f "${PROJECT_ROOT}/target"/aisanction-*.war "${HOST_OUT_DIR}/artifact/" 2>/dev/null || true
if ls "${PROJECT_ROOT}/target"/aisanction-*.war >/dev/null 2>&1; then
  (cd "${PROJECT_ROOT}/target" && sha256sum aisanction-*.war | grep -vE 'sources|javadoc' | tee "${HOST_OUT_DIR}/artifact/war.sha256")
fi

echo "Artifacts: ${HOST_OUT_DIR}/artifact" | tee -a "${LOG}"
echo "success" | tee -a "${LOG}"
exit 0
