#!/usr/bin/env bash
# Linux JEUS WAS — 중지 → 산출물 복사 → 기동
# 무중단 Rolling 시 WebToB Drain 이후에만 실행 (가이드 제6장)
#
#   ./restart_app.sh
#   JEUS_INSTANCE=aisanction21 ./restart_app.sh
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck disable=SC1091
[[ -f "${SCRIPT_DIR}/env.example" ]] && . "${SCRIPT_DIR}/env.example"
[[ -f "${SCRIPT_DIR}/env.local" ]] && . "${SCRIPT_DIR}/env.local"

resolve_instance() {
  if [[ -n "${JEUS_INSTANCE:-}" ]]; then
    echo "${JEUS_INSTANCE}"
    return
  fi
  case "$(hostname)" in
    wretaap1d) echo aisanction ;;
    wretaap1p) echo aisanction11 ;;
    wretaap2p) echo aisanction21 ;;
    *) echo aisanction ;;
  esac
}

AISANCTION_TARGET_EXPLODED="${AISANCTION_TARGET_EXPLODED:-/home/aisac/build/aisanction/target/aisanction-1.0.0}"
AISANCTION_APPS="${AISANCTION_APPS:-/home/aisac/apps}"
AISANCTION_BACKUP="${AISANCTION_BACKUP:-/home/aisac/backup}"
AISANCTION_LOG_DIR="${AISANCTION_LOG_DIR:-/home/aisac/build/log}"
JEUS_SCRIPT_DIR="${JEUS_SCRIPT_DIR:-/jeus/jeus8/SCRIPT}"
INSTANCE="$(resolve_instance)"

mkdir -p "${AISANCTION_LOG_DIR}" "${AISANCTION_BACKUP}"
DATE="$(date '+%Y%m%d')"
TIME="$(date '+%H%M%S')"
LOG="${AISANCTION_LOG_DIR}/aisanction_restart_${DATE}_${TIME}.log"
BACKUP_NAME="backup_${DATE}_${TIME}"

echo "SERVER_RESTART instance=${INSTANCE} host=$(hostname)" | tee "${LOG}"

if [[ ! -d "${AISANCTION_TARGET_EXPLODED}" ]]; then
  echo "ERROR: exploded not found: ${AISANCTION_TARGET_EXPLODED}" | tee -a "${LOG}"
  exit 1
fi

# 선택 백업
if [[ "${SKIP_BACKUP:-0}" != "1" ]]; then
  tar -cf "${AISANCTION_BACKUP}/${BACKUP_NAME}.tar" -C "$(dirname "${AISANCTION_APPS}")" "$(basename "${AISANCTION_APPS}")" \
    >>"${LOG}" 2>&1 || echo "WARN: backup tar failed (continue)" | tee -a "${LOG}"
fi

cd "${JEUS_SCRIPT_DIR}"
echo "cdown ${INSTANCE}" | tee -a "${LOG}"
./cdown "${INSTANCE}" >>"${LOG}" 2>&1

echo "copy ${AISANCTION_TARGET_EXPLODED} -> ${AISANCTION_APPS}" | tee -a "${LOG}"
mkdir -p "${AISANCTION_APPS}"
cp -r "${AISANCTION_TARGET_EXPLODED}/." "${AISANCTION_APPS}/"

# BIRT (소스 디렉터리 있을 때만)
copy_birt() {
  local src="$1" dst="$2"
  if [[ -d "${src}" && -n "${dst}" ]]; then
    mkdir -p "${dst}"
    cp -rf "${src}/." "${dst}/"
    echo "BIRT copy ${src} -> ${dst}" | tee -a "${LOG}"
  fi
}
copy_birt "${BIRT_REPORT_SRC:-}" "${BIRT_REPORT_DST:-}"
copy_birt "${BIRT_LAYOUT_SRC:-}" "${BIRT_LAYOUT_DST:-}"
copy_birt "${BIRT_STYLES_SRC:-}" "${BIRT_STYLES_DST:-}"

echo "cboot ${INSTANCE}" | tee -a "${LOG}"
./cboot "${INSTANCE}" >>"${LOG}" 2>&1

echo "success" | tee -a "${LOG}"
exit 0
