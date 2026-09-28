# 로컬 DB 설계 (STEP 2)

작성일: 2026-09-08
전제: STEP 1(`docs/local-environment-analysis.md`) 분석 결과 + MyBatis 매퍼 52개 전수 조사(테이블/컬럼/PK/FK/시퀀스 역추출) 기반.

---

## [설계 결정] Oracle Docker 구성

**문제**: 로컬 개발 DB를 무엇으로 구축할 것인가.

**선택지**
- A. H2/HSQL 등 경량 임베디드 DB
- B. PostgreSQL/MySQL 등 오픈소스 DB
- C. Oracle Database Free (Docker, `gvenzl/oracle-free`)

**선택**: C

**이유**:
- 사용자 지정 사항(변경 불가 조건)이며, 기존 저장소의 `docker-compose.yml`이 이미 `gvenzl/oracle-free:23-slim` + `APP_USER=sanction/sanction`으로 구성되어 있어 원래 이 프로젝트가 의도한 로컬 실행 경로였다.
- 매퍼 전수 조사 결과 MERGE INTO, DECODE, NVL/NVL2, CONNECT BY PRIOR/START WITH, ROWNUM 페이징, ROW_NUMBER()/RANK() OVER, GROUPING SETS/ROLLUP, WM_CONCAT, DBMS_RANDOM, DBMS_LOB.SUBSTR, `(+)` outer join, PL/SQL 익명 블록 등 Oracle/Tibero 전용 문법이 43개 파일 227건 이상 사용됨 — H2/PostgreSQL/MySQL로는 코드 수정 없이 동작 불가.
- `pom.xml`에 `ojdbc8`이 Maven Central 일반 dependency로 이미 있어 드라이버 확보 문제가 없다.

## [설계 결정] Oracle 버전

**문제**: 어떤 Oracle 이미지/버전을 쓸 것인가.

**선택지**
- A. Oracle Database Free 23ai (`gvenzl/oracle-free:23-slim`, 공식 Oracle Free 계열 커뮤니티 이미지, Docker Hub 공식 문서화)
- B. Oracle XE 11g/18c/21c 구버전 이미지
- C. Oracle 공식 컨테이너 레지스트리(container-registry.oracle.com) Enterprise 이미지

**선택**: A (기존 docker-compose.yml 그대로 유지)

**이유**:
- 기존 저장소가 이미 이 이미지를 사용 중 — 별도 변경 사유 없음.
- 23ai는 MERGE/CONNECT BY/분석함수/DBMS_LOB 등 매퍼가 사용하는 모든 구문을 지원.
- `WM_CONCAT`는 Oracle 12c 이후 제거된 비공식 함수이므로 `CommonRevertDetail_SQL.xml`에서 사용된 부분만 **LISTAGG로 교체가 필요** — 이는 STEP 3에서 별도 파일로 관리(원본 SQL 보존, Oracle 전용 대체 SQL 분리).
- FREE 서비스명(PDB)은 기본적으로 `FREEPDB1`이며, 기존 datasource 주석의 `xe`/`FREE` 서비스명과 다르므로 STEP 3에서 실제 접속 문자열을 이 값으로 맞춘다.

## [설계 결정] DB 계정 분리

**문제**: 애플리케이션 계정을 SYS/SYSTEM으로 직접 쓸 것인가.

**선택**: 전용 계정 `SANCTION` 사용 (기존 docker-compose.yml의 `APP_USER=sanction` 값을 그대로 유지 — 새 이름을 만들지 않음. 대문자 `SANCTION`은 Oracle 식별자 기본 규칙일 뿐 동일 계정).

**이유**: 기존 docker-compose.yml 환경변수(`APP_USER`, `APP_USER_PASSWORD`)와 `context-datasource.xml`의 주석 처리된 Oracle 블록(`sanction/sanction`)이 이미 이 이름으로 일치되어 있음 — 새 계정명을 도입하면 오히려 기존 설계와 어긋난다. SYS/SYSTEM은 `gvenzl/oracle-free` 이미지가 기동 시 자동 생성하며, 앱 전용 계정(`SANCTION`)은 이미지의 `APP_USER` 기능으로 자동 생성되고 `CONNECT, RESOURCE` 및 필요한 최소 권한만 가진다(기본 동작).

## 2. 테이블 인벤토리 (매퍼 전수 조사 결과 요약)

아래 표는 실제 매퍼 XML에서 확인된 테이블만 포함한다. 프롬프트가 나열한 CSPD 목록 중 매퍼에서 전혀 참조되지 않는 테이블(예: CSPD100TI, CSPD120TI, CSPD121TI)은 **임의로 생성하지 않는다.**

| 테이블 | 용도 | PK | 시퀀스 |
|---|---|---|---|
| CSPD001TM | 심사 마스터 (업무 1건 = 1행) | INPT_MST_SRNO | 없음(MAX+1) |
| CSPD002TG | 업무-이미지/문서 상세 | INPT_MST_SRNO+INPT_TASK_ID | 없음 |
| CSPD003TF | TotalText 심사결과 | +AI_INPT_TOTALTEXT_SRNO | 없음 |
| CSPD004TF | 항목심사결과상세(제재/AI추출) | +INPT_SANCTION_NO | 없음 |
| CSPD005TH | 결재 이력 | AI_INPT_APPV_SRNO | CSPD005TH_SG01 |
| CSPD006TL | 첨부파일 | INPT_MST_SRNO+AI_INPT_ATFL_SRNO | 없음 |
| CSPD007TL | SafeWatch 필터 결과 | AI_INPT_PRG_SRNO 등 | 없음 |
| CSPD008TH | 심사 진행 이력 | AI_INPT_PRG_SRNO | CSPD008TH_SG01 |
| CSPD009TA | 업무마감 통계 | 복합(DT,DSCD,ITCD) | 없음 |
| CSPD010TA | 업무일지 통계 | 복합(DT,DSCD,ITCD) | 없음 |
| CSPD011TL | 미생성 업무(XT) | AI_INPT_XT_SRNO | 없음 |
| CSPD101TI | 사용자 | AI_INPT_USER_ID | 없음 |
| CSPD102TI | WatchList 카테고리 | AI_INPT_CTGR_ID | CSPD102TI_SG01 |
| CSPD103TI | WatchList 그룹 | +AI_INPT_LIST_ID | CSPD103TI_SG01 |
| CSPD104TI | WatchList 항목 | +AI_INPT_RSPT_TXT_SRNO | 없음 |
| CSPD105TI | 제재 Rule1 | AI_INPT_SNRL1_ID | 없음 |
| CSPD106TI | 제재 Rule2 | AI_INPT_SNRL2_ID | 없음 |
| CSPD107TI | QA 대상 선정 관리 | QLAS_SLT_MNG_ID | CSPD107TI_SG01 |
| CSPD108TI | 메뉴(계층형) | AI_INPT_MENU_ID | 없음 |
| CSPD109TI | 권한별 메뉴 사용여부 | AI_INPT_MENU_ID+AI_INPT_AUT_CD | 없음 |
| CSPD110TI | 결재의견 | AI_INPT_APPV_OPI_SRNO | CSPD110TI_SG01 |
| CSPD111TI | 공통코드 그룹 | AI_INPT_GRP_CD | 없음 |
| CSPD112TI | 공통코드 | AI_INPT_GRP_CD+AI_INPT_CMN_CD | 없음 |
| CSPD113TI | 제재 Rule3(SQL텍스트) | AI_INPT_SNRL3_ID | 없음 |
| CSPD115TI | 국가 | NACD | 없음 |
| CSPD116TI | 제재 공통설정 | AI_INPT_RULE_DSCD | 없음 |
| CSPD117TI | AI 용어사전 | AI_INPT_WORD_SRNO+AI_INPT_GRP_CD | 없음 |
| CSPD118TI | 도시 | CITY_SRNO | 없음 |
| CSPD118TM | 영업일 | BAS_DT | 없음 |
| CSPD201TM | 수출 원장 | FX_ACNO+XPO_CVRG_MK_SQ | 없음 |
| CSPD202TM | 수입 원장 | FX_ACNO+TDOC_RCP_SRNO | 없음 |
| CSPD810TH | 로그인 이력 | AI_INPT_LGIN_HST_NO | 없음 |
| CSPD811TH | 프로그램 사용 이력 | AI_INPT_PGM_USG_HST_NO | 없음 |
| CSPD900TI | 심사 진행 큐/재처리 | INPT_MST_SRNO | 없음 |

VW_MENU/VW_TASK/VW_LEDGER 등은 실제 DB VIEW가 아니라 매퍼 내 인라인 CTE/서브쿼리 별칭이므로 DDL 대상에서 제외.

## 3. Tibero→Oracle 호환성 분류

```
[호환 가능 — 수정 없이 원본 SQL 그대로 사용]
DECODE, NVL/NVL2, TO_CHAR/TO_DATE, SYSDATE, CONNECT BY PRIOR/START WITH,
MERGE INTO, ROWNUM 페이징, ROW_NUMBER()/RANK() OVER, GROUPING SETS/ROLLUP,
DBMS_RANDOM.VALUE, DBMS_LOB.SUBSTR, (+) outer join, PL/SQL 익명 블록

[Oracle에서 별도 처리 필요 — 원본 SQL은 보존, Oracle 전용 대체본을 별도 관리]
WM_CONCAT (CommonRevertDetail_SQL.xml) → Oracle Free 23ai에서 미지원/비권장.
  Oracle 로컬 프로필에서만 LISTAGG(...) WITHIN GROUP (ORDER BY ...)로 대체한
  버전을 db/oracle-compat/ 에 별도 보관하고, 애플리케이션 코드/원본 매퍼는 수정하지 않는다.
  (실제 매퍼 수정 여부는 화면 검증(STEP 8) 시 WM_CONCAT 사용 화면에서 ORA 오류가
  나는 것을 확인한 뒤, 사용자 확인을 받고 진행한다.)

[수정 필요 — 동적 SQL, DDL 범위 밖]
AdminStatus의 ${table}/${column} 완전 동적 쿼리(queryTest/customQueryTest)는
정적 분석으로 대상 테이블을 알 수 없음 — 로컬 검증 시 실행해보고 개별 대응.
```

## 4. 초기화 순서

```
db/init/
  01_create_user.sql      (SANCTION 계정/권한 확인 — 이미지가 자동 생성하므로 검증용)
  02_sequence.sql          (CSPD005TH_SG01, 008TH_SG01, 102TI_SG01, 103TI_SG01,
                             107TI_SG01, 110TI_SG01)
  03_schema_reference.sql  (참조/코드성 테이블 먼저: CSPD111TI, 112TI, 115TI, 118TI,
                             118TM, 108TI, 109TI, 101TI, 102TI~107TI, 113TI, 116TI, 117TI)
  04_schema_business.sql   (CSPD201TM, 202TM → CSPD001TM → 002TG/003TF/004TF/
                             005TH/006TL/007TL/008TH/009TA/010TA/011TL/900TI/
                             810TH/811TH — FK 순서 준수)
  05_code_data.sql         (CSPD111TI/112TI 공통코드 값)
  06_sample_data.sql        (사용자/업무/이력 샘플 — STEP 4)
```

FK가 실제 DB 제약으로 선언된 것은 매퍼상 확인되지 않았으므로(원본에 FK 제약 DDL이 없어 애플리케이션 레벨 정합성에 의존하는 구조로 보임), 1차 DDL은 **PK + 논리적 FK 주석**으로 구성하고, 실제 FK CONSTRAINT 추가 여부는 원본 운영 DB의 제약 유무를 확인할 방법이 없으므로 사용자 확인 후 결정한다(과도한 제약으로 샘플 데이터 삽입 순서가 깨지는 것을 방지하기 위해 기본은 제약 없이 진행).

## 5. 접속 정보 (환경변수화)

```properties
DB_HOST=localhost
DB_PORT=1521
DB_SERVICE=FREEPDB1
DB_USERNAME=sanction
DB_PASSWORD=sanction
```

`context-datasource.xml`은 Tibero 활성 블록을 유지하되, **local 프로필 전용 오버라이드**를 추가하는 방식으로 진행할 예정(운영 설정 비파괴). 이 부분은 Java 설정 파일 수정이 필요하므로 STEP 3 착수 전 사용자 확인 요청.

## 다음 단계
STEP 3: `db/init/*.sql` DDL 작성, `docker-compose.yml` 검증/보강, `scripts/db-*.bat` 작성.
