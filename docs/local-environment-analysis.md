# 로컬 개발환경 분석 (STEP 1)

작성일: 2026-09-08
분석 대상: `ta_ui-master` (eGovFrame 3.8.0 / Spring 4.3 / MyBatis / Java 21 target, Tibero 기반)

> 본 문서는 실제 파일을 근거로 작성되었다. `docs/`, `sql/` 폴더는 원래 프로젝트에 **존재하지 않았음**을 확인했다 (본 작업으로 신규 생성).

---

## 1. 디렉터리 구조

```
src/main/java/com/woori/ajs/
  controller/   52개 JSP 렌더링 컨트롤러 (기능명 기반: admin/, app/, qa/, revert/, stat/, task/ ...)
  api/          52개 *ApiController (JSON REST), api/batch/QaTargetBatchController.java
  dao/, service/, service/impl/, model/ (VO)
  filters/AuthenticationInterceptor.java

src/main/java/egovframework/ui/
  cmmn/   PropUtil, ComUtil, SsoUtil, Encryptor, PasswdSecurity, HttpCallUtil, HttpUtil, initProp.java
  listener/CustomHttpSessionListener.java
  util/LoginUtils.java, RestTemplateUtils.java

src/main/resources/egovframework/spring/
  context-datasource.xml, context-mapper.xml, context-sqlMap.xml,
  context-properties.xml, context-security.xml, context-transaction.xml,
  context-idgen.xml, context-aspect.xml, context-common.xml, context-validator.xml

src/main/resources/egovframework/sqlmap/ui/mappers/   MyBatis Mapper XML 52개 + sql-mapper-config.xml
src/main/resources/egovframework/properties/          system.properties(활성), d_system.properties(dev), p_system.properties(prod)

src/main/webapp/WEB-INF/jsp/  admin/, app/, common/, dashboard/, login/, main/, qa/, revert/, stat/, task/log/
```

**중요 발견**: URL/화면은 "1010/1011/2010/3010" 같은 화면코드 기반이 아니라 **기능명 기반**(`/app/todo`, `/app/detail`, `/qa/todo`, `/qa/detail`, `/revert/...`, `/stat/...`)이다. 프롬프트 상의 화면코드 체계는 이 저장소의 실제 구조와 다르므로, 이후 문서/작업에서는 실제 URL 체계를 기준으로 한다.

---

## 2. DB 연결 구조 (핵심)

`src/main/resources/egovframework/spring/context-datasource.xml`:

- **현재 활성 빈**: Tibero
  ```
  driverClassName = net.sf.log4jdbc.sql.jdbcapi.DriverSpy
  url = jdbc:log4jdbc:tibero:thin:@localhost:8629:tibero
  username = APPUSER / password = app1234
  ```
- 주석 처리된 대안 3종: Tibero dev(10.232.181.109:8639/SPDDBT), Tibero prod(10.233.95.61:8649/SPDDBP), HSQLDB, **Oracle thin** (`jdbc:log4jdbc:oracle:thin:@//localhost:1521/xe`, `sanction/sanction`).
- 기존 루트 `docker-compose.yml`은 이미 `gvenzl/oracle-free:23-slim` + `APP_USER=sanction/sanction`로 구성되어 있고, 주석에 "context-datasource.xml 의 오라클 접속 계정과 일치"라고 명시되어 있다. 즉 **Oracle Docker 로컬 실행은 이 프로젝트가 원래 의도했던 경로**이며, 활성 빈만 Tibero→Oracle 블록으로 교체하면 된다.
- `system.properties`가 `mode=local`로 시작하는 로컬 프로필을 지원 (`egovframework.ui.cmmn.initProp.java`/`PropUtil`이 로드).

## 3. Oracle 버전/드라이버 적합성 분석

- `pom.xml`: Java 21 target, Spring 4.3.16, `com.oracle.database.jdbc:ojdbc8`가 **Maven Central에서 정상 resolve되는 일반 dependency**로 이미 선언되어 있음 → 별도 jar 수동 배치 불필요.
- Tibero 드라이버(`tibero6-jdbc*`)는 system-scope로 로컬 jar 필요 → 로컬 개발 경로에서는 사용하지 않음(운영 코드는 보존).
- Tibero SQL 문법은 Oracle 호환 방언(NVL, DECODE, TO_CHAR/TO_DATE, ROWNUM, CONNECT BY, MERGE, SEQUENCE.NEXTVAL, DUAL)을 그대로 사용하므로 Oracle DB와 방언 차이가 거의 없다. → **Oracle Database Free(23ai, `gvenzl/oracle-free:23-slim`)를 그대로 유지**하는 것이 가장 낮은 리스크의 선택.
- 최종 결정은 `docs/local-db-design.md`(STEP 2)에 [설계 결정] 형식으로 별도 기록.

## 4. MyBatis Mapper / 테이블 (1차 조사, 후속 STEP에서 전수 조사 예정)

52개 매퍼 파일 확인. 지금까지 실제로 발견된 테이블/뷰:

- `CSPD001TM`, `CSPD002TG`, `CSPD007TL`, `CSPD008TH` — Ca.xml, TaskLogReg_SQL.xml, TaskLogResult_SQL.xml, WordDictionaryRegBatch_SQL.xml
- `CSPD101TI`, `CSPD102TI`, `CSPD103TI`, `CSPD104TI`, `CSPD112TI`, `CSPD117TI`, `CSPD118TM` — AdminUser/AdminAbsence/AdminWatchList/AdminLogProgram/CommonCode 등
- `CSPD811TH` — AdminLogProgram_SQL.xml
- `W_MAIN`, `W_S1`, `W_S2`, `W_S3` — TaskLogResult_SQL.xml (추출/스테이징성 테이블로 추정, 확인 필요)
- `VW_TASK` — 뷰, TaskLogReg_SQL.xml에서 다수 사용
- `DUAL` — 시퀀스/단건 조회용

나머지 ~35개 매퍼 파일의 테이블/컬럼/시퀀스는 아직 전수 확인되지 않았다 (1차 조사에서 grep 결과가 80줄로 잘림). **STEP 2/3에서 52개 매퍼 파일 전체를 전수 조사하여 실제 DDL을 역추출한다** — CSPD001TM~CSPD121TI, CSPD201TM/202TM, CSPD810TH/811TH, CSPD900TI 등 프롬프트에 나열된 테이블 중 실제로 존재하는 것만 채택하고, 존재하지 않는 것은 임의로 만들지 않는다.

Oracle 방언 사용 현황(발췌): DECODE/TO_CHAR/TO_DATE/NVL/ROWNUM/CLOB 등 227건이 43개 파일에 분포, 특히 `AdminStatus_SQL.xml`(25), `AdminWatchList_SQL.xml`(17), `InptResultAnaly_SQL.xml`(14), `Dashboard_SQL.xml`(13), `CommonRevertDetail_SQL.xml`(16).

## 5. 컨트롤러/URL

- `controller/*Controller.java` (JSP 렌더링) + `api/*ApiController.java` (JSON) 쌍 구조, 52쌍.
- 확인된 실제 URL 예: `/login`(CommonLoginDController, 로컬/개발용 추정), `/login/sso/nst`, `/sso/prx`, `/login/sso/prx2`, `/logout` (CommonLoginController, SSO).
- 화면코드(1010 등) 기반 URL은 존재하지 않음 — `/app/todo`, `/app/detail`, `/qa/todo`, `/qa/detail`, `/revert/...`, `/stat/...`, `/admin/...` 등 기능명 기반.

## 6. 로그인/인증

- `AuthenticationInterceptor` — 미로그인 시 API는 `/api/common/login/forbidden`, 화면은 `PropUtil.PORTAL_LOGIN`(SSO 포털)로 리다이렉트. 관리자 전용 URL은 `LoginVO.getAdminYN()` + `LoginUtils.isAdminUrl()`로 체크.
- SSO: `SsoUtil` + `CommonLoginController`(`/login/sso/*`) — `portal.prc` 등 외부 포털과 토큰 교환하는 프록시 패턴, 사내망 전용 URL이라 로컬에서 도달 불가.
- **`CommonLoginDController` (`/login`)가 이미 존재하는 로컬/개발용 로그인 경로로 추정** — STEP 5(Mock 구축)에서 이 컨트롤러를 우선 재사용/검증한다. 신규 Mock 로그인을 만들기 전에 이 클래스부터 정독한다.

## 7. 기존 DDL / 샘플 데이터

- `.sql`/`.ddl` 파일 **전무** (target 제외 전체 탐색, 0건).
- 테스트 코드 전무 (JUnit 선언은 있으나 테스트 클래스 없음), H2/임베디드 DB 미사용(HSQLDB 블록은 주석 처리되어 비활성).
- `resources/files/test/revert/*.png`, `resources/img/test/*.jpg`는 문서 이미지 UI 테스트용 샘플이며 DB 시드 데이터 아님.

## 8. 외부 연동

`system.properties`/`d_system.properties`에 사내망 URL로 설정된 연동 지점:

| key | 용도 | 예시 |
|---|---|---|
| `extraction.url` | 문서 추출(OCR/AI) | 10.232.181.108:10917 계열 |
| `inspection.url` | AI 자동심사 | 동일 대역 |
| `bpr.url` | BPR 이미지 뷰어 | wbbprt.woorifg.com |
| `file.upload`/`download`/`delete` | 파일 서버 | 사내망 |
| `img.url` | 이미지 서버 | 사내망 |

Java 사용처: `initProp.java`(필드 매핑), `AdminStatusApiController`, `CommonRevertDetailApiController`, `ExtractionApiController`. "WINI"/"Flask" 라는 문자열 자체는 코드에서 발견되지 않았음 — extraction/inspection 엔드포인트가 실질적인 AI 연동 지점으로 판단됨. 전부 사내망이라 로컬에서는 **Mock 서버로 대체 필요** (STEP 5).

## 9. 배치

- `sh/batch/{d,p1,p2}/STDDAI00101.sh` → `curl http://localhost:8080/batch/task/log/end` → `TaskLogEndApiController` + `TaskLogEnd_SQL.xml`
- `sh/batch/{d,p1,p2}/STDMGT00119.sh` → `curl http://localhost:8080/batch/qa/target` → `api/batch/QaTargetBatchController` + `QaTargetBatch_SQL.xml`
- 인프로세스 스케줄러(Quartz/Spring Batch) 없음. cron으로 쉘 스크립트가 HTTP 엔드포인트를 호출하는 구조. cron 표현식은 properties의 `batchTime.qa`, `batchTime.taskEnd`.

## 10. 로컬 실행 저해 요소

1. context-datasource.xml이 Tibero로 고정 활성화되어 있어 그대로는 로컬 Oracle에 연결 불가 (교체 필요, STEP 3에서 진행 — **DB 연결 대상 변경이므로 사용자 확인 후 반영**).
2. DDL이 전무하여 CSPD 테이블 스키마를 매퍼 SQL에서 역추출해야 함 (52개 파일 전수 조사 필요, STEP 2/3에서 진행).
3. 외부 연동(extraction/inspection/bpr/file/SSO)이 전부 사내망이라 로컬에서 Mock 필요.
4. Tibero 전용 드라이버 jar가 system-scope라 로컬 빌드에 없음 → 로컬 프로필에서는 ojdbc8(Maven Central)만 사용.

## 11. DB 구축 전략 (요약, 상세는 STEP 2 `docs/local-db-design.md`)

- **Docker + Oracle Database Free 유지** (사용자 지정, 기존 docker-compose.yml과도 일치). H2/HSQL/PostgreSQL/MySQL 등으로 변경하지 않는다.
- 기존 `docker-compose.yml`(`gvenzl/oracle-free:23-slim`)을 최대한 재사용하고, 계정 분리(SYS/SYSTEM vs 앱 전용 계정)를 명확히 한다.
- `db/init/` 폴더에 스키마/시퀀스/코드/샘플 데이터를 번호순 SQL로 구성 (FK 의존성 순서 준수).
- Tibero 전용 문법이 발견되면 `sql/tibero/` vs `sql/oracle/`로 분리 관리하고 기존 SQL은 덮어쓰지 않는다.

## 12. Mock 필요 사항

| 대상 | 로컬 대응 |
|---|---|
| SSO | `CommonLoginDController`(`/login`) 우선 재사용 검토, 부족하면 local 전용 Mock 로그인 추가 |
| extraction/inspection(AI) | Mock REST 응답 서버 또는 controller-level mock (JSON 고정 응답) |
| BPR 이미지 뷰어 | 로컬 정적 리소스로 대체 |
| 파일 서버 | 로컬 디스크 경로로 대체 |

---

## 다음 단계

STEP 2: `docs/local-db-design.md` 작성 — Oracle 버전/계정 설계 결정, 52개 매퍼 전수 조사 결과 기반 DDL 설계.
