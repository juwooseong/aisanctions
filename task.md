# Action Items

# QA
- 업무마감 > 성과관리 
  - 총 17건인데 12건만 나옴
- 조희 컬럼과 그리드 컬럼의 내용이 다름 ( Ref.No , RefNo )
- 업무일지 > 업무일지등록 : 100vh 로 하지 않을 경우 5.기타 항목 안보임

# 20191223
- TA task 확인 ( 신정후 적용 예정 )
- 문자열 특수문자( 정다운 처리 )
- datatable fixedColumns 적용 ( 이동훈 적용 예정 )
- 

# 20191212
- PCMS ( MAVEN, jdk ) 확인
  - sh(빌드, was restart)
- iframe
  - 빠르게 이동 시 빈화면 출현
  - 세션만료, 404
- 미등록자 로그인 시 처리 ( 이동훈 주임 확인 )
- 다중로그인

- DEV Maven build 작업
  - 소스 빌드 (clean package)시 jdk 필요하여 우리FIS 유태연 대리에게 요청 ( 목요일 설치 가능 응답 )
  - JDK 설치 후 소스 빌드 가능
- SVN(10.83.2.45) 에 TA 형상관리 ( 계정 수정 )
- iframe 버그 수정

# 20191205
- iframe 오류 페이지 ( IE에서 404 깨짐)
  - iframe 모든 에러페이지 css 수정 및 버튼 기능 수정 ( 없애거나 닫기 )
- iframe 로그인 화면 생기는 현상 ( 인증 실패 시 메인 페이지 이동 )
- Report 깨짐 현상 수정 ( 최신 IE 적용 )
  <META HTTP-EQUIV="x-ua-compatible" CONTENT="IE=edge">

# 20191203
- testcase sample  작성 및 내용 공유 ( 이동훈, 정다운, 박현우 )
  - spring-test jar 파일 필요
  svn://10.83.4.2/파일공유/Let's Do It/화면개발(UI)/요청/maven_repo.zip
- refNoValue 의 용도는?
  $('#refNoValue')
  layout.jsp 에 존재 하고 다수 페이지에 존재
- 초기화 방법 공유
  ```
  <span class="init_btn"><i class="fa fa-refresh search-reset fa-sm"></i> 초기화</span>
  ```
- MDI 적용 ( iframe 적용 ) : 진행중 ( ~1203 예정 )
- junit test 전파 ( 이동훈, 정다운, 박현우 )
  - spring-test.jar 파일 반입 후 전파 가능

# 201912202
- 빌드 프로세스 설명 ( 이동훈, 정다운, 박현우 )
- SVN 적용 방법 설명 ( 이동훈, 정다운, 박현우 )
- 팝업 세션 만료 시 처리 ( login.jsp ) : 팝업 닫히고 부모창 로그인 페이지로 이동
- 팝업 ( 움직이는 팝업, background-color : 무시 ) 방법 공유
  - $($0).draggable({ handle: 'h2' });
- 화면 추기화 방법 공유 ( 이동훈 A 적용 )
- login 페이지 SIGN UP 문구 제거
- ajax 오류 처리
  - ajaxSetup 적용
```
    $.ajaxSetup({
    	global:true
    });
 	
 	$(function(){
		$(document).ajaxError(function(e, xhr, settings, exception){
			if(xhr && xhr.status == 500){
				alert('처리중 오류가 발생하였습니다.');
			}
		});
	});
```
# 20200116

- log4j2 설정 관련
-- 로그파일 경로: /applog/aisanction/ (개발서버, 운영서버 동일)
-- 파일 당 최대 크기: 10 MB
-- 최대 Rolling 개수: 20 개
-- 로그레벨
--- 개발서버: DEBUG
--- 운영서버: INFO (java.sql 은 DEBUG)
-- 로그파일 제거 주기: 최종 수정시간 기준 30 일 이상

# Tip

## TestCase
- src/main/java
- src/test/java
- jUnitTest version 4