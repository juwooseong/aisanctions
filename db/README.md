# db/ (로컬 Oracle Docker 초기화)

> **중요**: 2026-09-08 작업 중 `sql/` 폴더에 이 프로젝트 자체의 **진짜 원본 DDL/시퀀스/테스트데이터/
> 마이그레이션**(`sql/01_ddl.sql` 등, 번호 00~33)이 이미 존재한다는 것을 뒤늦게 확인했다.
> `db/init/` 아래 있던 `02_sequence.sql`~`06_sample_data.sql`은 `sql/` 폴더를 찾기 *전에*
> MyBatis 매퍼 SQL을 역추정해서 만든 것이라 정확도가 떨어진다(실제로 메뉴 ID 체계, 담당자 배정,
> `IS NULL` 판정 컬럼 등에서 여러 버그가 있었음). **이제 `sql/` 폴더가 정본이며, `db/init/`은
       더 이상 사용하지 않는다** (기록 보존용으로만 남겨둠). `docker-compose.yml`도 `sql/`을
> 마운트하도록 이미 변경되어 있다.

## 실행 순서 (신규 설치, `sql/00_drop.sql` 상단 주석 근거)

```
00_drop → 01_ddl → 02_sequence → 03_test_data
  → 26_task_auth_v2 → 27_qa_integ_v2 → 28_annotation
  → 07_menu_role_test_data → 04_review01_test_data → 05_approv01_test_data → 06_qauser01_test_data
  → 30_task_auth_mig → 31_dashboard_display_config → 32_urgent_review_mig → 33_home_menu_mig
```

- `29_item_val_seq.sql`은 파일 상단에 "신규 설치는 01_ddl.sql에 이미 반영됨. 본 파일은 기존 DB ALTER용"이라
  명시되어 있어 신규 설치에서는 **실행하지 않는다** (실행해도 컬럼/제약이 이미 있어 에러만 나고 무해함).
- `sql/archive/`는 이미 설치된(운영) DB에 대한 보정용이라 신규 설치에는 사용하지 않는다.

`docker compose up -d` 최초 실행 시 `gvenzl/oracle-free` 이미지가 `sanction` 계정을 자동 생성한 뒤,
`/container-entrypoint-initdb.d`에 마운트된 위 순서의 스크립트를 `sanction` 계정으로 자동 실행한다
(`docker-compose.yml`의 볼륨 마운트에서 `1x_` 접두어로 순서를 강제함).

## 결과로 생성되는 테스트 계정 (비밀번호 검증 없음, ID만 일치하면 로그인됨)

`sql/04_review01_test_data.sql`, `05_approv01_test_data.sql`, `06_qauser01_test_data.sql`,
`03_test_data.sql`에서 생성됨. 주요 계정(전체 13명은 `SELECT * FROM CSPD101TI`로 확인):

| ID | 이름 | 권한 |
|---|---|---|
| `review01` | 김심사 | 01 심사자 |
| `approv01` | 이결재 | 02 결재자 |
| `qauser01` / `qauser02` | 박QA / 한QA | 03 QA |
| `admin01` | 최관리 | 01 (관리 겸직으로 추정) |
| `general01` | 정일반 | 04 일반 — **주의: ID 9자, 로그인 화면(login.jsp)의 8자 제한에 걸려 이 화면으로는 로그인 불가** |
| `sysadmin01` | 한시스템 | 05 시스템관리자 — **주의: ID 10자, 동일하게 8자 제한에 걸림** |
| `c1_kim`,`c1_park`,`c1_choi`,`c1_lim`,`c2_lee`,`c2_cho` | 심사자/결재자 그룹 | 01/02 |

`general01`/`sysadmin01`은 실제 원본 데이터이지만 `login.jsp:65-66`의 8자 제한과 충돌한다 —
UI는 임의로 변경하지 않는 원칙에 따라 손대지 않았고, 로컬 테스트 시 8자 이내 계정을 사용한다.

## 재실행/초기화

`docker compose down -v` 후 `docker compose up -d`로 볼륨을 지우고 처음부터 다시 실행해야
init 스크립트가 다시 적용된다 (Oracle은 이미 데이터가 있는 볼륨에서는 init 스크립트를 건너뛴다).
Windows에서는 `scripts\db-reset.bat` 사용.

## 알려진 이슈 — 자동 init이 유실되는 경우

실측 검증 결과, `gvenzl/oracle-free` 이미지가 최초 기동 중 내부적으로 DB를 재시작하는 타이밍과 겹쳐
`/container-entrypoint-initdb.d` 스크립트 실행 로그는 정상 출력되지만 실제 테이블이 생성되지 않는
경우가 있었다(에러 없이 조용히 유실). `docker compose up -d` 이후 `scripts\db-status.bat` 또는
아래 쿼리로 테이블 존재를 확인하고, 비어 있으면 `scripts\db-init-apply.bat`으로 전체 체인을 수동 재적용한다.

```sql
SELECT COUNT(*) FROM CSPD001TM;   -- 31 이어야 정상 (sql/ 원본 테스트데이터 기준)
SELECT COUNT(*) FROM CSPD101TI;   -- 13
SELECT COUNT(*) FROM CSPD108TI;   -- 53
```

## 수동 실행이 필요한 경우

```
docker exec -it aisanction-oracle sqlplus sys/oracle_pw123@//localhost:1521/FREEPDB1 as sysdba
docker exec -it aisanction-oracle sqlplus sanction/sanction@//localhost:1521/FREEPDB1
```

## db/init/ (더 이상 사용하지 않음, 기록 보존용)

`sql/` 폴더를 발견하기 전에 MyBatis 매퍼를 역추정해서 만든 자체 DDL/샘플 데이터. 더 이상 참조되지 않지만
삭제하지 않고 남겨둔다(당시 STEP 1~4 분석 과정과 발견한 문제들의 기록으로서 `docs/local-db-design.md`와 함께 참고 가능).
