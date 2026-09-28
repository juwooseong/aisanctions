#!/usr/bin/env bash
# Linux JEUS WAS — Maven 빌드
# 사용:
#   ./build_app.sh              # env.example / 환경변수 / hostname 기준
#   MVN_DENV=p ./build_app.sh
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck disable=SC1091
[[ -f "${SCRIPT_DIR}/env.example" ]] && . "${SCRIPT_DIR}/env.example"
[[ -f "${SCRIPT_DIR}/env.local" ]] && . "${SCRIPT_DIR}/env.local"

resolve_env() {
  if [[ -n "${MVN_DENV:-}" ]]; then
    echo "${MVN_DENV}"
    return
  fi
  case "$(hostname)" in
    wretaap1d) echo d ;;
    wretaap1p|wretaap2p) echo p ;;
    *) echo d ;;
  esac
}

AISANCTION_BUILD_HOME="${AISANCTION_BUILD_HOME:-/home/aisac/build/aisanction}"
AISANCTION_LOG_DIR="${AISANCTION_LOG_DIR:-/home/aisac/build/log}"
MVN_DENV="$(resolve_env)"
JAVA_HOME="${JAVA_HOME:-/usr/lib/jvm/java-1.8.0-openjdk}"
export JAVA_HOME

mkdir -p "${AISANCTION_LOG_DIR}"
DATE="$(date '+%Y%m%d')"
TIME="$(date '+%H%M%S')"
LOG="${AISANCTION_LOG_DIR}/aisanction_maven_build_${DATE}_${TIME}.log"

echo "MAVEN_BUILD_START" | tee "${LOG}"
echo "HOSTNAME=$(hostname) MVN_DENV=${MVN_DENV} JAVA_HOME=${JAVA_HOME}" | tee -a "${LOG}"

cd "${AISANCTION_BUILD_HOME}"
echo "mvn clean package -Denv=${MVN_DENV} -Dmaven.test.skip=true" | tee -a "${LOG}"
mvn clean package -Denv="${MVN_DENV}" -Dmaven.test.skip=true >>"${LOG}" 2>&1

echo "success" | tee -a "${LOG}"
exit 0
