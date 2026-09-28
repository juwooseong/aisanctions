#!/usr/bin/env bash
# Linux — 설정 치환 (JEUS JNDI / 환경 properties)
#   ENV_PROFILE=p ./apply_config.sh [/home/aisac/apps]
set -euo pipefail

APPS="${1:-${AISANCTION_APPS:-/home/aisac/apps}}"
PROFILE="${ENV_PROFILE:-p}"

SPRING="${APPS}/WEB-INF/classes/egovframework/spring"
PROPS="${APPS}/WEB-INF/classes/egovframework/properties"

if [[ ! -d "${SPRING}" ]]; then
  echo "ERROR: spring config dir missing: ${SPRING}"
  exit 1
fi

if [[ -f "${SPRING}/context-datasource.xml.jeus" ]]; then
  cp "${SPRING}/context-datasource.xml.jeus" "${SPRING}/context-datasource.xml"
  echo "applied context-datasource.xml.jeus"
fi

if [[ -d "${PROPS}" ]]; then
  if [[ -f "${PROPS}/system.properties.${PROFILE}" ]]; then
    cp "${PROPS}/system.properties.${PROFILE}" "${PROPS}/system.properties"
    echo "applied system.properties.${PROFILE}"
  elif [[ "${PROFILE}" == "p" && -f "${PROPS}/system.properties.p" ]]; then
    cp "${PROPS}/system.properties.p" "${PROPS}/system.properties"
    echo "applied system.properties.p"
  elif [[ "${PROFILE}" == "d" && -f "${PROPS}/system.properties.d" ]]; then
    cp "${PROPS}/system.properties.d" "${PROPS}/system.properties"
    echo "applied system.properties.d"
  else
    echo "WARN: system.properties.${PROFILE} not found under ${PROPS}"
  fi
fi

echo "success"
exit 0
