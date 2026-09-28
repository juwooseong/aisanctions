AISANCTION_POMXML_PATH="/home/aisac/build/aisanction/target/aisanction-1.0.0"
RESTART_LOG_PATH="/home/aisac/build/log/"
AISANCTION_TARGET="/home/aisac/apps"
AISANCTION_BACKUP="/home/aisac/backup"

BIRT_REPORT_TARGET="/home/aisac/build/birt/report"
BIRT_LAYOUT_TARGET="/home/aisac/build/birt/layout"
BIRT_STYLES_TARGET="/home/aisac/build/birt/styles"

BIRT_REPORT="/home/aisac/birt/report"
BIRT_LAYOUT="/home/aisac/birt/webcontent/birt/pages/layout"
BIRT_STYLES="/home/aisac/apps/birt/webcontent/birt/styles"

# Restart 시작 일시 기록
DATE=$(date '+%Y%m%d')
TIME=$(date '+%H%M%S')
MAVEN_BUILD_LOG="aisanction_maven_build_"$DATE"_"$TIME".log"
RESTART_LOG="aisanction_restart_"$DATE"_"$TIME".log"
BACKUP_NAME="backup_"$DATE"_"$TIME

echo "SERVER_RESTART"
echo "SERVER_RESTART" > ${RESTART_LOG_PATH}/${MAVEN_BUILD_LOG}

# 서버 중지
cd /jeus/jeus8/SCRIPT/
if [ "wretaap1d" = $HOSTNAME ]; then
	echo "wretaap1d STOP"
	./cdown aisanction >> ${RESTART_LOG_PATH}/${RESTART_LOG}
elif [ "wretaap1p" = $HOSTNAME ]; then
	echo "wretaap1p STOP"
	./cdown aisanction11 >> ${RESTART_LOG_PATH}/${RESTART_LOG}
elif [ "wretaap2p" = $HOSTNAME ]; then
	echo "wretaap2p STOP"
	./cdown aisanction21 >> ${RESTART_LOG_PATH}/${RESTART_LOG}
else 
	echo "wretaap2p STOP"
	./cdown aisanction21 >> ${RESTART_LOG_PATH}/${RESTART_LOG}
fi

echo Restart AISANCTION DATE=$DATE, TIME=$TIME
echo Restart AISANCTION DATE=$DATE, TIME=$TIME >> ${RESTART_LOG_PATH}/${RESTART_LOG}

# AISANCTION package 실행 디렉토리로 복사
cp -r ${AISANCTION_POMXML_PATH}/* ${AISANCTION_TARGET}
echo "AISANCTION package copy success"
echo "AISANCTION package copy success" >> ${RESTART_LOG_PATH}/${RESTART_LOG}

# BIRT package 실행 디렉토리로 복사
cp -rf ${BIRT_REPORT_TARGET}/* ${BIRT_REPORT}
cp -rf ${BIRT_LAYOUT_TARGET}/* ${BIRT_LAYOUT}
cp -rf ${BIRT_STYLES_TARGET}/* ${BIRT_STYLES}
echo "BIRT package copy success"
echo "BIRT package copy success" >> ${RESTART_LOG_PATH}/${RESTART_LOG}

# 서버 시작
cd /jeus/jeus8/SCRIPT/
if [ "wretaap1d" = $HOSTNAME ]; then
	echo "wretaap1d START"
	./cboot aisanction >> ${RESTART_LOG_PATH}/${RESTART_LOG}
elif [ "wretaap1p" = $HOSTNAME ]; then
	echo "wretaap1p START"
	./cboot aisanction11 >> ${RESTART_LOG_PATH}/${RESTART_LOG}
elif [ "wretaap2p" = $HOSTNAME ]; then
	echo "wretaap2p START"
	./cboot aisanction21 >> ${RESTART_LOG_PATH}/${RESTART_LOG}
else 
	echo "wretaap2p START"
	./cboot aisanction21 >> ${RESTART_LOG_PATH}/${RESTART_LOG}
fi

# 위 모든 과정이 성공할 경우 결과 출력
echo "success"
echo "success" >> ${RESTART_LOG_PATH}/${RESTART_LOG}

exit 0
