# 기능 설명: 항목심사 그리드 "수기 추가" 동적 컬럼

작성일: 2026-09-08 (최초 구현) → 2026-09-08 (서버 저장·자동 노출 추가) → 2026-09-09 (기존 소스 무수정 패키지화로 재구조화)
대상 화면: `1011 상세` (`revert/detail`, `src/main/webapp/WEB-INF/jsp/revert/detail/detail.jsp`) — "항목심사" 탭

> **2026-09-09 재구조화 배경**: 처음에는 `common_detail.js`(여러 화면이 공유하는 기존 파일) 안에
> 로직을 직접 삽입해서 diff가 크고 다른 화면에도 영향을 줄 수 있는 구조였다. "기존 소스를 최대한
> 건드리지 않고 JS를 분리해달라"는 요청에 따라, **`common_detail.js`는 원본 그대로 되돌리고**,
> 이 기능 전체를 새 파일 `manual-add-column.js` 하나로 옮겼다. `revert/detail/detail.jsp`에만
> 이 파일을 추가로 로드하므로, `common_detail.js`를 공유하는 다른 9개 화면(QA/결재 상세 등)은
> 이 기능의 존재 자체를 모른 채 완전히 예전과 동일하게 동작한다.

---

## 0. 수정 파일 목록

### 신규 생성
| 파일 | 내용 |
|---|---|
| `src/main/webapp/resources/js/manual-add-column.js` | 기능 전체 구현 (아래 2장 참고) |
| `sql/34_manual_add_extra_cols.sql` | `CSPD004TF`에 `ITM_INPT_HNDG_ADD1_TXT`/`ADD2_TXT`/`ADD3_TXT` 3개 컬럼 추가 (멱등 마이그레이션) |
| `docs/feature-manual-add-column.md` | 본 문서 |

### 기존 파일 수정
| 파일 | 내용 |
|---|---|
| `src/main/webapp/WEB-INF/jsp/revert/detail/detail.jsp` | `<script src=".../manual-add-column.js">` **한 줄** 추가 (common_detail.js 바로 다음) |
| `src/main/resources/egovframework/sqlmap/ui/mappers/CommonRevertDetail_SQL.xml` | `resultMap`에 3개 컬럼 매핑 추가, `selectSancRst`(조회) SELECT 목록에 3개 컬럼 추가, `insertSantionHndgInpDatTxt`/`updateSantionHndgInpDatTxt`/`updateSantionHndgInpDatTxtAndSfw`에 저장 컬럼 추가, `initHndgInpDatTxt` 초기화 대상/조건 확장 |
| `src/main/java/com/woori/ajs/model/CommonRevertDetailVO.java` | `itmInptHndgAdd1Txt`/`itmInptHndgAdd2Txt`/`itmInptHndgAdd3Txt` 필드 + getter/setter 추가 |
| `src/main/java/com/woori/ajs/api/CommonRevertDetailApiController.java` | `setSantionTransInfoParam()`에서 요청 JSON의 3개 필드를 VO에 매핑 |
| `src/main/java/com/woori/ajs/service/impl/CommonRevertDetailServiceImpl.java` | `hasHndgInputData()` 헬퍼 추가, `saveSantion()`/`inspection()`의 insert/update 실행 조건을 "수기입력만 확인"에서 "4개 필드 중 하나라도 있으면"으로 확장 |

**`src/main/webapp/resources/js/common_detail.js`는 이제 원본과 동일하다 — 이 기능 때문에 수정된 부분이 전혀 없다.**
(서버 쪽 5개 파일은 "저장/조회"라는 요구사항 자체가 DB·매퍼·컨트롤러·서비스를 거치지 않고는 구현할 수 없어서
불가피하게 손댔지만, 전부 **기존 로직을 바꾸지 않고 컬럼/조건을 추가하는 방식**으로만 수정했다.)

**추가 변경(2026-09-09)**: "수기입력" 옆 복사 아이콘(원본 `.btn-copy`, 항목내용을 입력칸에 복사)과
동일한 기능을 "수기 추가" 입력칸에도 붙였다. `manual-add-column.js`의 `makeManualCellRenderer()`가
입력칸 옆에 복사 아이콘을 함께 렌더링하고, `.manual-col-copy-btn` 클릭 핸들러(같은 파일 내)가
해당 행의 항목내용(`rowData[3]`)을 그 "수기 추가" 칸에 복사해 넣는다 — 역시 `common_detail.js`는
무수정.

---

## 1. 기능 개요

항목심사 그리드(`#sanctionRstTable`)의 **"수기입력" 컬럼 바로 옆**에 `[+]` 버튼이 있다.
버튼을 누르면 "수기 추가"라는 이름의 새 입력 컬럼이 그 자리에 하나 생기고, 각 "수기 추가" 컬럼
헤더에는 그 컬럼만 지우는 `[삭제]` 버튼이 함께 표시된다.

- 최대 **3개**까지 만들 수 있다. 3개가 되면 `[+]` 버튼이 비활성화되고, 그래도 클릭을 시도하면
  알림창("수기 추가는 3개까지 가능합니다.")이 뜬다.
- `[삭제]`를 누르면 해당 컬럼만 제거되고 나머지 컬럼(및 그 안에 입력된 값)은 그대로 유지된다.
- **컬럼 위치는 항상 "수기입력" 바로 오른쪽**이다.
- **임시저장/심사진행 시 서버(`CSPD004TF`)에 저장**되고, **다시 들어오면 저장된 값 개수만큼
  컬럼이 자동으로 노출**된다.
- 저장은 심사자(콜타입 `A`) 화면에서만 의미가 있다(결재자/QA 화면은 원래 이 그리드가 읽기 전용).

---

## 2. 구현 방식 — "기존 소스 무수정" 을 어떻게 달성했나

### 2.1 핵심 아이디어 1: DataTables의 `columns[].data` 를 이용한 위치 분리

원래 그리드는 "화면 컬럼 순서 = 데이터 배열 순서"가 암묵적으로 같았다
(`fn_setSanctionRst()`가 만드는 배열: `[No,≠,항목,항목내용,수기입력,Alert내용,계산기아이콘,
altYn,sanctionNo,imexHisCd,taskId,stRstKind,concatImexHisCd]`, 총 13칸).

DataTables는 컬럼마다 `data` 옵션으로 "이 컬럼이 원본 데이터의 몇 번째 값을 쓸지"를 명시적으로
지정할 수 있다. `manual-add-column.js`는 이 옵션을 이용해서:

- 앞의 5개 컬럼(No,≠,항목,항목내용,수기입력)은 `data: 0,1,2,3,4` 그대로.
- "수기 추가" 컬럼들은 `data: null` + 자체 `render` 함수(입력칸 `<input>` HTML을 직접 만들어 반환).
- 그 뒤의 원래 컬럼들(Alert내용, 계산기아이콘, 숨김 컬럼 4개)은 `data: 5,6,7,8,9,10,11,12`로
  **원본 배열 인덱스를 그대로 지정**.

즉 **화면에는 "수기 추가" 컬럼이 몇 개가 끼어 있든, 원본 데이터 배열(`fn_setSanctionRst()`가 만드는
그 배열)의 모양은 전혀 바뀌지 않는다.** 그래서 `fn_setSanctionRst()`를 단 한 줄도 고칠 필요가 없었다.

### 2.2 핵심 아이디어 2: 몽키패치 (원본 함수를 감싸서 교체)

common_detail.js는 전역 함수 `fn_dataTableComplete`, `fn_setTmpParam`을 `function ...() {}` 형태로
선언한다. 브라우저의 일반 `<script>`(모듈 아님) 환경에서 이런 전역 함수 선언은 `window`의 프로퍼티이고,
**나중에 로드되는 스크립트가 같은 이름으로 재할당하면 이후의 모든 호출(같은 파일 안의 호출 포함)이
새 함수를 타게 된다.** `manual-add-column.js`는 이 성질을 이용해서 두 함수만 감싼다.

```
원본 함수 저장 → window.fn_xxx = function() {
    ... 우리가 하고 싶은 일 ...
    var ret = 원본함수.apply(this, arguments);   // common_detail.js의 원래 동작을 그대로 수행
    ... 우리가 하고 싶은 일 ...
    return ret;
};
```

- **`fn_dataTableComplete`**: 원본을 그대로 호출해서 안전왓치/전달정보/TotalText/항목심사(원본 13컬럼)
  테이블 4개를 평소처럼 만들게 둔 다음, 항목심사 테이블만 즉시 `destroy()` 하고 우리 컬럼 구성
  (2.1의 `data` 매핑 + "수기 추가" N개)으로 다시 만든다. 호출 직전에 서버 데이터를 보고 필요한
  컬럼 수를 먼저 계산해 둔다(`ensureColsFromLoadedData`).
- **`fn_setTmpParam`**: 원본을 그대로 호출해서 임시저장/심사진행 파라미터(`sanctionList` 포함)를
  만들게 한 다음, 그 배열의 각 항목(원본이 이미 `inptTaskId`/`inptSanctionNo`를 채워 둠)에
  `itmInptHndgAdd1Txt`/`2Txt`/`3Txt`만 추가로 채워 넣고 반환한다.

`fn_setSanctionRst()`는 (2.1 덕분에) 아예 감쌀 필요조차 없었다 — 원본이 만드는 데이터를 그대로
써도 우리 컬럼 구성과 맞물려 정확하게 표시된다.

### 2.3 로딩 범위

`manual-add-column.js`는 `revert/detail/detail.jsp`에만 포함된다. `common_detail.js`를 함께 쓰는
다른 화면(`app/detail/qa`, `qa/detail`, `common/history/*` 등)은 이 파일을 로드하지 않으므로
`fn_dataTableComplete`/`fn_setTmpParam`이 몽키패치되지 않고, 원본 그대로 동작한다.

---

## 3. 저장(임시저장/심사진행) 흐름

1. 사용자가 "수기 추가" 입력칸에 값을 입력 → `onchange` → `window.fn_manualColValueChange()`가
   화면 메모리(`window.extraManualColValues[colId][rowKey]`)에 값을 기록.
2. 임시저장/심사진행 클릭 → (몽키패치된) `fn_setTmpParam()`이 원본 파라미터에 Add1/2/3 값을 얹어 반환.
3. `CommonRevertDetailApiController.setSantionTransInfoParam()`이 3개 필드를 VO에 매핑.
4. `CommonRevertDetailServiceImpl.saveSantion()`/`inspection()`이 `hasHndgInputData()`(4개 필드 중
   하나라도 있으면 true)로 저장 여부를 판단해 insert/update 실행. `initHndgInpDatTxt`도 "수기입력"
   뿐 아니라 Add1/2/3 중 하나라도 있던 행까지 초기화 대상에 포함하도록 확장.
5. `CommonRevertDetail_SQL.xml`의 insert/update 문이 `CSPD004TF.ITM_INPT_HNDG_ADD1/2/3_TXT`에 반영.

## 4. 조회(자동 노출) 흐름

1. 서버가 `selectSancRst`로 `ITM_INPT_HNDG_ADD1/2/3_TXT`까지 함께 내려준다.
2. (몽키패치된) `fn_dataTableComplete()` 안에서 `ensureColsFromLoadedData()`가 `$globaObjlData.sanctionRst`를
   훑어 값이 채워진 가장 큰 번호(1~3)만큼 `extraManualCols`를 미리 만들고, 값도 저장소에 미리 채운다.
3. 그 다음 원본 `fn_dataTableComplete()`가 4개 테이블을 만들고, 곧바로 항목심사 테이블만 우리 컬럼
   구성(이미 채워진 `extraManualCols` 반영)으로 재생성하므로, 처음부터 필요한 컬럼 수로 그려진다.

> 참고: 임시저장 직후 재조회(`fn_getReBLData` → `fn_setSanctionRst()` 직접 호출 경로)는 몽키패치
> 대상이 아니라서, 그 시점에 "이전에 없던 컬럼이 새로 필요해지는" 극단적 케이스까지는 자동 노출을
> 보장하지 않는다. 다만 실제로는 컬럼을 만들어 입력한 뒤 저장하는 흐름이라 저장 시점엔 이미 해당
> 컬럼이 화면에 떠 있으므로 실사용에서 문제되지 않는다.

## 5. 행(row) 식별 키

`rowKey = inptTaskId + '_' + inptSanctionNo` (`manual-add-column.js` 내부 `manualColRowKey`).
이 조합은 실제 저장 대상 `CSPD004TF`의 저장 키(`INPT_MST_SRNO+INPT_TASK_ID+INPT_SANCTION_NO`,
mst는 화면 내 고정)와 동일한 유일성을 가지므로, 화면에 몇 번째로 그려졌는지와 무관하게 항상 같은
키를 계산할 수 있다 — 그리드가 아직 그려지지 않은 시점(서버 조회 직후)에도 미리 값을 채워 넣을 수
있는 이유다.

## 6. 관련 코드 위치

| 영역 | 위치 |
|---|---|
| 상태(추가된 컬럼 목록/입력값 저장소) | `manual-add-column.js` 상단 `extraManualCols`, `window.extraManualColValues` |
| 컬럼 구성 계산 | `manual-add-column.js`의 `buildColumns()` (`data:` 명시적 인덱스 매핑) |
| 그리드 재생성 | `manual-add-column.js`의 `rebuildSanctionTable()` |
| 추가/삭제 진입점 | `manual-add-column.js`의 `addColumn()`, `removeColumn()`, `[+]`/`[삭제]` 클릭 바인딩 |
| 몽키패치 | `manual-add-column.js` 맨 아래, `fn_dataTableComplete` / `fn_setTmpParam` 재할당부 |
| 서버 저장/조회 | `CommonRevertDetail_SQL.xml`, `CommonRevertDetailVO.java`, `CommonRevertDetailApiController.java`, `CommonRevertDetailServiceImpl.java`, `sql/34_manual_add_extra_cols.sql` |

## 7. 알려진 제약

- 최대 3개는 화면(`manual-add-column.js`의 `MANUAL_COL_MAX_CNT`)과 DB 컬럼(ADD1~ADD3) 양쪽에
  고정되어 있다. 늘리려면 DB 마이그레이션 + 매퍼 + VO + 컨트롤러 + 이 상수를 함께 늘려야 한다.
- 몽키패치는 `fn_dataTableComplete`/`fn_setTmpParam`이라는 **정확한 함수 이름과 호출 시그니처**에
  의존한다. 추후 `common_detail.js`에서 이 두 함수의 이름을 바꾸거나 시그니처(인자/반환값 형태)를
  바꾸면 `manual-add-column.js`도 함께 확인해야 한다(반대로, 두 함수의 내부 구현이 바뀌는 것은
  이름/반환값 형태만 유지되면 영향 없음).
- 4장 끝의 "저장 직후 재조회" 극단적 케이스 참고.
