# 개발환경 설치

# 파일 다운로드
- [개발환경 다운로드](http://www.egovframe.go.kr/EgovDevEnvReleaseNote.jsp?menu=3&submenu=2) > 표준프레임워크 통합다운로드
- 실행 시 압축해제함 `C:\eGovFrameDev-3.8.0-64bit`
- workspace : `C:\eGovFrameDev-3.8.0-64bit\workspace`

# 이클립스 실행
- [전자정부프레임워크 실행가이드](https://lab.t3q.co.kr:9999/UI_template/egov-ui.git)
- maven > settings.xml 지정 ( repo 지정 : `C:\eGovFrameDev-3.8.0-64bit\maven_repo`)

# 프로젝트
- 생성 또는 Checkout(https://lab.t3q.co.kr:9999/ui/egov-ui.git)
- 

# 장애/오류 처리 
- Maven 관련 오류
  - 프로젝트 오른쪽 마우스 > maven > Update Maven Project > OK
  
  

# tools (C:\eGovFrameDev-3.8.0-64bit\tools)
- IDE
  - eGovFrameDev-3.8.0-64bit 다운로드 및 설치 
  - 경로 : C:\eGovFrameDev-3.8.0-64bit
- java
  - 경로 : C:\eGovFrameDev-3.8.0-64bit\tools\jdk1.8.0_181
- python
  - 버전 :  
  - 경로 : 
- eclipse plugin 설치 및 목록 정리
  - pydev : marketplace > pydev > install
- dbclient
  - dbeaver
- server
  - tomcat 
  - 경로 : `C:\eGovFrameDev-3.8.0-64bit\tools\apache-tomcat-8.0.53`

# repo
- Maven repo
  - 경로 : C:\eGovFrameDev-3.8.0-64bit\maven_repo
  - maven > settings.xml 지정 ( repo 지정 : `C:\eGovFrameDev-3.8.0-64bit\maven_repo`)

# 프로젝트
- workspace
  - `C:\eGovFrameDev-3.8.0-64bit\workspace`
- ui ( )
  - 의존 라이브러리 다운로드 ( maven 경로 확인 )
- api ( )
  - 가상환경 설정 및 패키지 다운로드 ( flask, rest-api 등 )
  - jdbc 설정[링크](https://technet.tmaxsoft.com/download.do?filePath=/nas/technet/technet/upload/kss/tnote/tibero/2014/09/&fileName=FILE-20140925-000060_140925161709_1.pdf)
  
# 테스트 후 zip 패키징
- 오프라인 PC 테스트
- 해당 경로 zip 패키징(C:\eGovFrameDev-3.8.0-64bit.zip)


## 배포
cd /home/aisac
log.sh
was_restart.sh 

1. db정보 수정
cd /home/aisac/apps/WEB-INF/classes/egovframework/spring
cp context-datasource.xml.jeus context-datasource.xml

2. properties 수정
cd /home/aisac/apps/WEB-INF/classes/egovframework/properties
cp system.properties.p system.properties

2. 제우스 재기동
cd /jeus/jeus8/SCRIPT/
./cdown aisanction
./cboot aisanction

## 로그
cd /jeus_log/jeus8/aisanction
tail -f JeusServer.log

## tar 압축
tar -cvf apps_back.tar /home/aisac/apps

## tar 해제
tar -xvf app.tar 