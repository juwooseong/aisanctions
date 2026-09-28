# 변경 이력 및 상세 설명 (2026-09-08 세션)

목표: `ta_ui-master`(우리은행 AI Sanction 심사자동화)를 로컬 Oracle Docker 환경에서
실행/테스트 가능하게 만들고, 그 과정에서 발견된 실제 버그를 수정.

---

## 1. 로컬 Oracle DB 환경 구축

### 1.1 `docker-compose.yml`
- 기존에 이미 있던 `gvenzl/oracle-free:23-slim` 컨테이너 정의를 그대로 유지.
- `/container-entrypoint-initdb.d`에 `sql/` 폴더의 원본 스크립트를 **신규 설치 순서대로** 마운트해
  `docker compose up -d` 한 번으로 스키마+데이터가 자동 구성되도록 함.
  - 마운트 순서(파일명 접두 숫자로 강제): `00_drop → 01_ddl → 02_sequence → 03_test_data
    → 26_task_auth_v2 → 27_qa_integ_v2 → 28_annotation → 07_menu_role_test_data
    → 04_review01_test_data → 05_approv01_test_data → 06_qauser01_test_data
    → 30_task_auth_mig → 31_dashboard_display_config → 32_urgent_review_mig → 33_home_menu_mig`
  - `29_item_val_seq.sql`은 파일 자체에 "신규 설치는 01_ddl.sql에 이미 반영됨"이라 명시돼 있어 제외.

### 1.2 `src/main/resources/egovframework/spring/context-datasource.xml`
- 기존 활성 빈이 Tibero(`jdbc:log4jdbc:tibero:thin:@localhost:8629:tibero`)였던 것을,
  로컬 Oracle Docker(`jdbc:oracle:thin:@//localhost:1521/FREEPDB1`, 계정 `sanction/sanction`)로 전환.
  Tibero 블록은 삭제하지 않고 주석 처리만 해서 보존(사용자 승인: "단순 주석 전환" 방식).
- 드라이버는 `net.sf.log4jdbc.sql.jdbcapi.DriverSpy`(SQL 로깅 래퍼) 대신
  `oracle.jdbc.driver.OracleDriver`를 직접 사용하도록 변경.
  - **이유**: log4jdbc 래퍼용 의존성(`log4jdbc-log4j2-jdbc4.1`)이 특정 빌드/배포 환경에서
    `WEB-INF/lib`에 올라가지 않아 `Cannot create JDBC driver ... No suitable driver` 오류가 발생했음.
    `ojdbc8`(pom.xml에 Maven Central 의존성으로 이미 선언됨)을 직접 쓰면 이 문제를 피할 수 있음.

### 1.3 `db/init/`, `db/README.md`, `scripts/db-*.bat` — **1차 시도, 현재는 폐기(기록 보존용)**
- `sql/` 폴더의 존재를 발견하기 전에, MyBatis 매퍼 52개를 역추정해서 자체 DDL/시퀀스/공통코드/
  샘플데이터(사용자 9명, 업무 60건)를 직접 만들었던 산출물.
- 이후 `sql/` 폴더(프로젝트 원본 DDL·시퀀스·테스트데이터·메뉴/권한 마이그레이션)를 발견하면서
  **더 이상 사용하지 않음**. `docker-compose.yml`도 `sql/`을 정본으로 사용하도록 이미 변경됨.
  당시 발견했던 문제들(메뉴 ID 체계, 담당자 배정 상관관계, `IS NULL` 판정 컬럼 기본값 오류 등)은
  `db/README.md`에 기록으로만 남겨둠.

### 1.4 `docs/local-environment-analysis.md`, `docs/local-db-design.md`
- STEP 1(프로젝트 구조/DB 연결/MyBatis 매퍼/외부연동 분석), STEP 2(DB 선정 근거, 테이블 인벤토리,
  Tibero→Oracle 호환성 분류) 산출물. `sql/` 폴더 발견 **이전** 시점의 분석이라 일부(테이블 목록,
  메뉴 구조 추정 등)는 `sql/` 원본과 다를 수 있음 — 참고용으로 남겨두되, 실제 스키마는 `sql/01_ddl.sql`이
  기준.

---

## 2. `sql/` 폴더 발견 이후 — 정본 데이터로 전환

프로젝트에 이미 존재하던 `sql/00_drop.sql` ~ `sql/33_home_menu_mig.sql`(및 `sql/archive/`)이
이 프로젝트의 **진짜** 원본 DDL/시퀀스/테스트데이터/메뉴·권한 마이그레이션이라는 것을 확인.
이걸 신규 설치 순서대로 실행해 로컬 DB를 재구축(`docker compose down -v && up -d`).

결과: 테이블 45개, 사용자 13명, 업무(`CSPD001TM`) 31건, 메뉴 53개, 메뉴-권한 매핑 265건.

### 2.1 로그인 테스트 계정 (비밀번호 검증 없음, ID만 일치하면 로그인)
| ID | 이름 | 권한 |
|---|---|---|
| `review01` | 김심사 | 01 심사자 |
| `approv01` | 이결재 | 02 결재자 |
| `qauser01`/`qauser02` | 박QA/한QA | 03 QA |
| `admin01` | 최관리 | 01 |
| `c1_kim`,`c1_park`,`c1_choi`,`c1_lim`,`c2_lee`,`c2_cho` | - | 01/02 |
| `general01`(9자), `sysadmin01`(10자) | 정일반/한시스템 | 04/05 — **로그인 화면 8자 제한에 걸려 `/login`으로는 로그인 불가**(UI 미변경 원칙상 손대지 않음) |

---

## 3. 발견 및 수정한 버그

### 3.1 메뉴가 안 보이던 문제 — 프런트 JS의 메뉴 ID 파싱 규칙
- `resources/js/common.js:234-244`가 메뉴 ID(6자리)의 3~6번째 글자로 대/소분류를 구분함
  (`depth_2 = id.substring(2,4)`, `depth_3 = id.substring(4,6)`; 둘 다 `"00"`이면 최상위 메뉴로 인식).
- 초기 자체 제작 메뉴 데이터에서 하위 메뉴 ID를 `110000`처럼 만들어서 이 규칙과 충돌 → 하위 메뉴가
  전부 최상위로 오인식됨. `sql/` 원본 데이터(`101000`, `102000`, ... 형태)로 교체되며 자연히 해결.

### 3.2 `PAPS_RE_SCAN_NED_YN`, `QLAS_PRG_YN` 등 `DEFAULT 'N'` 오적용 (1차 자체 DDL 한정, 현재는 해당 없음)
- 실제 매퍼(`AppTodo_SQL.xml`, `Dashboard_SQL.xml`)는 이 컬럼들을 `IS NULL`로 "정상" 상태를 판단하는데,
  자체 제작 DDL에 `DEFAULT 'N'`을 넣어 정상 건이 ToDo 목록에서 전부 필터링되던 문제. `sql/` 원본 전환으로
  더 이상 해당 없음(기록 보존).

### 3.3 `ORA-01722` — VARCHAR2/NUMBER 암묵 변환 오류 (실제 운영 코드 버그, 수정함)
**파일**: `AdminSanction_SQL.xml`, `Ca.xml`(2곳), `CommonRevertDetail_SQL.xml`(3곳),
`Dashboard_SQL.xml`, `InptResultAnaly_SQL.xml`(4곳), `WordDictionaryRegBatch_SQL.xml` — 총 7개 파일 12곳.

- **증상**: `CSPD112TI.AI_INPT_CMN_CD`(VARCHAR2)와 `CSPD004TF.INPT_SANCTION_NO`(NUMBER)를 `=`로 직접
  비교하는 SQL에서 `ORA-01722: 문자열 값을 숫자로 변환할 수 없음: EXP` 발생.
- **원인**: Oracle은 VARCHAR2와 NUMBER를 비교할 때 VARCHAR2 쪽을 NUMBER로 암묵 변환한다. 실행계획에
  따라 `AI_INPT_GRP_CD` 필터가 적용되기 전에 `CSPD112TI` 전체(다른 그룹코드 포함, 예: 150그룹의
  `'EXP'`/`'IMP'` 같은 비숫자 코드)를 대상으로 변환을 시도해 실패. Tibero에서는 옵티마이저 차이로
  드러나지 않았을 가능성이 있는 Tibero→Oracle 마이그레이션 이슈.
- **수정**: NUMBER 쪽을 `TO_CHAR()`로 캐스팅해 문자열-문자열 비교로 통일 (Tibero에서도 동일하게 안전).
  - Outer join(`(+)`)이 걸린 3곳(`Ca.xml` 2곳, `CommonRevertDetail_SQL.xml` 1곳)은
    `TO_CHAR(컬럼)(+)`가 아니라 `TO_CHAR(컬럼(+))`로 작성해야 함(Oracle 문법 — `(+)`는 함수 밖이 아니라
    컬럼 바로 뒤에 위치). 처음에 `TO_CHAR(...)(+)`로 잘못 써서 `ORA-00936`이 났던 것을 재수정함.
  - 수정 후 실제 쿼리를 DB에서 직접 실행해 정상 동작 확인.

### 3.4 `ORA-00904: WM_CONCAT` — 제거된 비공식 함수 (실제 운영 코드 버그, 수정함)
**파일**: `CommonRevertDetail_SQL.xml` (`selectSancRst`)

- **증상**: `WM_CONCAT(DISTINCT(SB.IMEX_HIS_CD))` 호출 시 `ORA-00904: "WM_CONCAT": 부적합한 식별자`.
- **원인**: `WM_CONCAT`은 Oracle 12c부터 공식적으로 제거된 내부 함수(Tibero에는 존재해서 원본에서는
  동작했을 것으로 추정).
- **수정**: `LISTAGG(DISTINCT SB.IMEX_HIS_CD, ',') WITHIN GROUP (ORDER BY SB.IMEX_HIS_CD)`로 교체
  (Oracle 19c+ 부터 `LISTAGG(DISTINCT ...)` 지원, 현재 Oracle Free 23ai에서 정상 동작 확인).

---

## 4. 신규 기능 — 항목심사 그리드 동적 "추가" 컬럼

**파일**: `src/main/webapp/resources/js/common_detail.js` (1011 상세 화면 `항목심사` 탭)

- "수기입력" 헤더 옆에 `[+]` 버튼 추가.
- 클릭 시 그리드 오른쪽 끝에 새 컬럼이 생성됨(헤더: "추가" + `[-]` 버튼, 각 행에 입력칸 포함).
- `[-]` 버튼 클릭 시 해당 컬럼만 삭제.
- **구현 방식**: DataTables(jQuery 플러그인)는 초기화 후 컬럼 개수를 동적으로 바꿀 수 없어서,
  컬럼 구성이 바뀔 때마다 `destroy()` 후 새 컬럼 정의로 다시 초기화하는 방식(`fn_rebuildSanctionRstTable`)으로
  구현. 기존 컬럼 인덱스(0~12)를 건드리지 않기 위해 동적 컬럼은 항상 맨 뒤(인덱스 13부터)에 추가.
- 입력값은 컬럼을 추가/삭제해 테이블이 재생성돼도 유지되도록 `window.extraManualColValues`에
  화면 메모리로만 보관 — **서버 저장(DB 반영)은 하지 않는 순수 UI 기능**. 저장이 필요하면 별도 API/컬럼
  설계가 필요함(예: `sql/29_item_val_seq.sql`이 만든 `CSPD004TF.ITM_INPT_ADD_ROW_YN` 등 유사 목적의
  "수기 행추가" 설계를 참고할 수 있음 — 컬럼 추가가 아니라 행 추가 목적으로 이미 설계된 컬럼이라 그대로
  재사용은 안 되고, 저장까지 필요하면 별도로 논의 필요).

---

## 5. 참고 스크립트

| 파일 | 용도 |
|---|---|
| `scripts/db-start.bat` | `docker compose up -d` |
| `scripts/db-stop.bat` | 컨테이너 정지 (데이터 유지) |
| `scripts/db-reset.bat` | 볼륨까지 완전 초기화 후 재기동 (확인 프롬프트 있음) |
| `scripts/db-status.bat` | 컨테이너 상태 + `SELECT 1 FROM DUAL` 헬스체크 |
| `scripts/db-init-apply.bat` | 자동 init이 유실됐을 때(아래 5.1) `sql/` 체인을 수동 재적용 |

### 5.1 알려진 이슈 — `gvenzl/oracle-free` 자동 init 타이밍 문제
최초 부팅 중 이미지가 내부적으로 DB를 재시작하는 타이밍과 겹쳐, `/container-entrypoint-initdb.d`
스크립트 실행 로그는 정상 출력되지만 실제로는 테이블이 생성되지 않는 경우를 실측으로 확인했다
(에러 없이 조용히 유실). `docker compose up -d` 이후 `SELECT COUNT(*) FROM CSPD001TM;`으로 확인하고,
0이면 `scripts\db-init-apply.bat`으로 수동 재적용한다.

---

## 6. 현재 상태 / 다음에 할 만한 것
- 로그인 → 메뉴 → 1011 상세(항목심사/TotalText/SafeWatch 탭) 화면까지 실 Oracle DB 기준으로 정상 동작
  확인됨.
- 아직 화면별로 전수 검증하지는 않았음 — 2010 결재, 3010 QA, 현황/통계, 관리자 화면 등은 미검증.
  다른 화면에서도 `ORA-01722`/`ORA-00904`류의 Tibero→Oracle 마이그레이션 이슈가 추가로 나올 수 있으니,
  발생하면 동일한 방식(원인 분석 → 최소 수정 → DB에서 직접 검증 → 안내)으로 대응.
- 외부 연동(AI 추출/심사, BPR, 파일서버, SSO)은 전부 사내망 URL이라 로컬에서는 아직 Mock 처리가
  안 돼 있음 — 필요 시 STEP 5(Mock API)로 진행 가능.
