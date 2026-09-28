AISANCTION_POMXML_PATH="/home/aisac/build/aisanction"
MAVEN_BUILD_PATH="/home/aisac/build/log"
MVN_DENV=""

# maven build 일시 기록
DATE=$(date '+%Y%m%d')
TIME=$(date '+%H%M%S')
MAVEN_BUILD_LOG="aisanction_maven_build_"$DATE"_"$TIME".log"

echo "MAVEN_BUILD_START"
echo "MAVEN_BUILD_START" > ${MAVEN_BUILD_PATH}/${MAVEN_BUILD_LOG}

if [ "wretaap1d" = $HOSTNAME ]; then
	MVN_DENV="d"
	echo "MVN_DENV : D"
	echo "MVN_DENV : D" >> ${MAVEN_BUILD_PATH}/${MAVEN_BUILD_LOG}
elif [ "wretaap1p" = $HOSTNAME ]; then
	MVN_DENV="p"
	echo echo "MVN_DENV : P"
	"MVN_DENV : P" >> ${MAVEN_BUILD_PATH}/${MAVEN_BUILD_LOG}
elif [ "wretaap2p" = $HOSTNAME ]; then
	MVN_DENV="p"
	echo "MVN_DENV : P"
	echo "MVN_DENV : P" >> ${MAVEN_BUILD_PATH}/${MAVEN_BUILD_LOG}
else 
	echo "HOSTNAME IS NOT FOUND!"
	echo "HOSTNAME IS NOT FOUND!" >> ${MAVEN_BUILD_PATH}/${MAVEN_BUILD_LOG}
	exit 1
fi

# pom.xml이 있는 디렉터리로 이동
cd ${AISANCTION_POMXML_PATH}

echo Maven build DATE=$DATE, TIME=$TIME
echo Maven build DATE=$DATE, TIME=$TIME >> ${MAVEN_BUILD_PATH}/${MAVEN_BUILD_LOG}

# JAVA_HOME:q 패스 변경
JAVA_HOME="/usr/lib/jvm/java-1.8.0-openjdk-1.8.0.181-7.b13.el7.x86_64"
export JAVA_HOME

echo Change JAVA HOME path to $JAVA_HOME
echo Change JAVA HOME path to $JAVA_HOME >> ${MAVEN_BUILD_PATH}/${MAVEN_BUILD_LOG}

# maven 실행
echo mvn clean package -Denv=${MVN_DENV} -Dmaven.test.skip=true
mvn clean package -Denv=${MVN_DENV} -Dmaven.test.skip=true >> ${MAVEN_BUILD_PATH}/${MAVEN_BUILD_LOG}

# maven 실행 성공 여부 확인
if [ "$?" -ne  0 ]; then
    echo "Maven Package Build failed!"
    echo "Maven Package Build failed!" >> ${MAVEN_BUILD_PATH}/${MAVEN_BUILD_LOG}
    exit 1
fi

# 성공할 경우 결과 출력
echo "success"
echo "success" >> ${MAVEN_BUILD_PATH}/${MAVEN_BUILD_LOG}

exit 0

