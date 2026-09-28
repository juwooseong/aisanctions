# -*- coding: utf-8 -*-
"""Update index.html wireframe sections from actual JSP screen definitions."""
from __future__ import annotations

import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
INDEX = ROOT / "docs" / "wireframes" / "index.html"


def th(*cols: str) -> str:
    return "<thead><tr>" + "".join(f"<th>{c}</th>" for c in cols) + "</tr></thead>"


def tr(*cells: str) -> str:
    return "<tr>" + "".join(f"<td>{c}</td>" for c in cells) + "</tr>"


def table(cols: list[str], rows: list[list[str]], compact: bool = True) -> str:
    cls = "wf-table wf-table-compact" if compact else "wf-table"
    body = "".join(tr(*r) for r in rows)
    return f'<table class="{cls}">{th(*cols)}{body}</table>'


def search_row(*fields: str, btn: str = "조회") -> str:
    inner = "".join(fields)
    return f'<div class="wf-search"><div class="wf-search-row">{inner}<button type="button" class="wf-btn-search">{btn}</button></div></div>'


def field(label: str, html: str) -> str:
    return f'<div class="wf-field"><label>{label}</label>{html}</div>'


def select(label: str, *opts: str) -> str:
    o = "".join(f"<option>{x}</option>" for x in opts)
    return field(label, f'<select class="wf-select">{o}</select>')


def text(label: str, cls: str = "wf-input wf-medium", val: str = "") -> str:
    v = f' value="{val}"' if val else ""
    return field(label, f'<input type="text" class="{cls}"{v}>')


def date_range(label: str = "업무생성일", notice: str = "") -> str:
    n = f'<span class="wf-task-log-notice">{notice}</span>' if notice else ""
    return field(
        label,
        f'<input type="text" class="wf-input wf-short"> ~ <input type="text" class="wf-input wf-short">{n}',
    )


def date_range_chk(label: str = "업무생성일") -> str:
    return (
        field(label, '<input type="checkbox"> <input type="text" class="wf-input wf-short"> ~ <input type="text" class="wf-input wf-short">')
    )


def section(
    sid: str,
    title: str,
    desc: str,
    tags: list[str],
    frame_body: str,
    notes: str,
) -> str:
    tag_html = "".join(f'<span class="wf-tag">{t}</span>' for t in tags)
    return f"""    <!-- ===== {sid} ===== -->
    <section id="screen-{sid}" class="aid-screen wf-screen-section">
      <header class="wf-screen-header">
        <h2>SCR-{sid} — {title}</h2>
        <p class="wf-desc">{desc}</p>
        <div class="wf-tags">{tag_html}</div>
      </header>
      <div class="wf-frame">
{frame_body}
      </div>
      <div class="wf-notes"><strong>인터랙션:</strong> {notes}</div>
    </section>
"""


def list_screen(
    sid: str,
    title: str,
    desc: str,
    url: str,
    search_html: str,
    cols: list[str],
    rows: list[list[str]],
    notes: str,
    toolbar: str = "",
    actions: str = "",
    extra_tags: list[str] | None = None,
) -> str:
    tags = [f"패턴 C", url] + (extra_tags or [])
    tbl = table(cols, rows)
    body = f"""        <div class="wf-title-bar"><h3>{title} [{sid}]</h3></div>
        {search_html}
        {toolbar}
        <div class="wf-table-wrap wf-table-scroll-h">{tbl}</div>
        <div class="wf-paging">◀ 1 2 3 ▶</div>
        {actions}"""
    return section(sid, title.split("[")[0].strip(), desc, tags, body, notes)


SCREENS: dict[str, str] = {}

# --- 1010 ---
SCREENS["1010"] = list_screen(
    "1010",
    "본인작업 ToDoList",
    "심사자 배정 수기입력·심사검토 대상 조회·처리.",
    "/revert/todo",
    search_row(
        select("업무", "전체", "수출", "수입"),
        text("Ref.No"),
        text("고객번호"),
        text("마스터번호"),
    ),
    ["생성일", "업무", "Ref.No", "저장", "주의", "프로세스", "액티비티", "고객번호", "고객명", "통화", "금액", "TotalText", "항목심사", "S/W", "DetectionID", "마스터ID"],
    [["07/03", "수출", '<span class="wf-link">FX-2026-000123</span>', "—", "—", '<span class="wf-link">심사</span>', '<span class="wf-link">1차심사</span>', "1234567", "ABC무역", "USD", "10,000", '<span class="wf-badge-red">30</span>', "OK", "OK", "D001", "M001"]],
    "프로세스/액티비티→1011. Ref.No 더블클릭→9080.",
    extra_tags=['<a href="list-1010.html">독립보기</a>', '<a href="list-1010-v2.html">v2</a>'],
)

# --- 1020 ---
SCREENS["1020"] = list_screen(
    "1020",
    "진행업무별 현재상태",
    "문서재추출·(재)심사·결재진행·결재완료 건 조회.",
    "/revert/status",
    search_row(
        select("업무", "전체", "수출", "수입"),
        text("Ref.No"),
        text("고객번호"),
        date_range_chk("업무생성일"),
    ),
    ["생성일", "업무", "Ref.No", "주의", "프로세스", "액티비티", "고객번호", "고객명", "통화", "금액", "TotalText", "항목심사", "S/W", "DetectionID"],
    [["07/03", "수출", '<span class="wf-link">FX-001</span>', "—", "심사", "결재진행", "1234567", "ABC", "USD", "5,000", "40", "OK", "OK", "D001"]],
    "읽기전용 심사/QA 이력 상세 팝업.",
)

# --- 1030 ---
SCREENS["1030"] = list_screen(
    "1030",
    "업무미생성목록",
    "WINI 접수 후 업무 미생성 건 확인·처리.",
    "/revert/ungenerated",
    search_row(
        date_range_chk("업무생성일"),
        select("처리상태", "전체", "미확인", "확인완료"),
        select("제외사유", "전체", "중복스캔", "WINI 외환 거래 정보 없음", "WINI 외환 거래 취소"),
    ),
    ["□", "접수일자", "제외사유", "업무", "Ref.No", "회차", "접수자", "스캔자", "스캔일시", "처리상태", "처리자", "처리일시"],
    [["☑", "07/03", "중복스캔", "수출", "FX-U001", "1", "user01", "scan01", "07/03 09:00", "미확인", "—", "—"]],
    "다중선택 후 확인완료/확인취소. 엑셀다운로드.",
    toolbar='<div class="wf-task-log-toolbar"><button type="button" class="wf-btn">확인완료</button><button type="button" class="wf-btn">확인취소</button><button type="button" class="wf-btn">엑셀다운로드</button></div>',
)

# --- 2010 ---
SCREENS["2010"] = list_screen(
    "2010",
    "본인작업 ToDoList(결재자)",
    "결재 대상 조회·일괄승인.",
    "/app/todo",
    search_row(select("업무", "전체", "수출+수입"), text("Ref.No"), text("고객번호")),
    ["□", "생성일", "업무", "Ref.No", "저장", "주의", "프로세스", "액티비티", "담당자", "고객번호", "고객명", "통화", "금액", "TotalText", "항목심사", "S/W", "DetectionID"],
    [["☑", "07/03", "수출", '<span class="wf-link">FX-001</span>', "—", "—", "심사", "결재대기", "홍길동", "1234567", "ABC", "USD", "10,000", "40", "OK", "OK", "D001"]],
    "일괄승인→2010-BUNDLE. Pending/Alert 건 체크박스 비활성.",
    actions='<div class="wf-btn-group"><button type="button" class="wf-btn wf-btn-success">일괄승인</button></div>',
    extra_tags=['<a href="list-2010.html">독립보기</a>'],
)

# --- 2020 ---
SCREENS["2020"] = list_screen(
    "2020",
    "진행업무별 현재상태(결재자)",
    "승인·반려·Block 처리 이력 조회.",
    "/app/status",
    search_row(
        select("업무", "전체", "수출+수입"),
        text("Ref.No"),
        text("고객번호"),
        date_range_chk("업무생성일"),
    ),
    ["생성일", "업무", "Ref.No", "주의", "프로세스", "액티비티", "고객번호", "고객명", "통화", "금액", "TotalText", "항목심사", "S/W", "DetectionID"],
    [["07/03", "수출", '<span class="wf-link">FX-001</span>', "—", "심사", "결재완료", "1234567", "ABC", "USD", "10,000", "40", "OK", "OK", "D001"]],
    "업무구분에 따라 심사/QA 이력·상세 팝업 분기.",
)

# --- 3010 ---
SCREENS["3010"] = list_screen(
    "3010",
    "본인작업 ToDoList(QA)",
    "자체점검 배정 건 조회·처리.",
    "/qa/todo",
    search_row(select("프로세스", "전체"), text("Ref.No"), text("고객번호")),
    ["생성일", "Ref.No", "저장", "주의", "프로세스", "액티비티", "고객번호", "고객명", "통화", "금액", "TotalText", "항목심사", "S/W", "DetectionID"],
    [["07/03", '<span class="wf-link">FX-Q001</span>', "—", "—", "자체점검", "QA심사", "1234567", "ABC", "USD", "10,000", '<span class="wf-badge-red">30</span>', "OK", "OK", "D001"]],
    "프로세스/액티비티→3011. Ref.No 더블클릭→9090.",
    extra_tags=['<a href="list-3010.html">독립보기</a>'],
)

# --- 3020 ---
SCREENS["3020"] = list_screen(
    "3020",
    "진행업무별 현재상태(QA)",
    "결재진행·결재완료 QA 건 조회.",
    "/qa/status",
    search_row(
        select("업무", "전체"),
        text("Ref.No"),
        text("고객번호"),
        date_range_chk("업무생성일"),
    ),
    ["생성일", "Ref.No", "주의", "프로세스", "액티비티", "고객번호", "고객명", "통화", "금액", "TotalText", "항목심사", "S/W", "DetectionID"],
    [["07/03", '<span class="wf-link">FX-Q001</span>', "—", "자체점검", "결재진행", "1234567", "ABC", "USD", "10,000", "40", "OK", "OK", "D001"]],
    "읽기전용 QA 이력 상세 팝업.",
)

# --- 4010 ---
SCREENS["4010"] = list_screen(
    "4010",
    "업무생성목록",
    "스캔 이전 심사대상 목록 조회.",
    "/revert/stat/all",
    search_row(
        field("업무생성일", '<label><input type="radio" name="d4010"> 전체</label> <label><input type="radio" name="d4010" checked> 당일</label>'),
        select("업무", "전체", "수출", "수입"),
        select("생성구분", "전체"),
        text("Ref.No"),
        text("고객번호"),
    ),
    ["생성일", "업무", "Ref.No", "고객번호", "고객명", "통화", "금액", "생성구분", "접수자", "영업점명(코드)", "상태"],
    [["07/03", "수출", "FX-001", "1234567", "ABC", "USD", "10,000", "정상", "user01", "강남(001)", "정상"]],
    "Ref.No 더블클릭→심사이력. 엑셀다운로드.",
    toolbar='<div class="wf-task-log-toolbar"><button type="button" class="wf-btn">엑셀다운로드</button></div>',
)

# --- 4020 ---
SCREENS["4020"] = section(
    "4020",
    "담당자별 진행현황",
    "담당자별 심사·자체점검 진행 중 목록 + 일별 집계.",
    ["패턴 C", "/revert/stat/status"],
    f"""        <div class="wf-title-bar"><h3>담당자별 진행현황 [4020]</h3></div>
        {search_row(date_range_chk("업무생성일"), select("업무", "전체", "수출+수입"), select("진행구분", "전체", "진행", "pending"), text("담당직원번호"), text("Ref.No"), text("고객번호"))}
        <div class="wf-task-log-toolbar"><button type="button" class="wf-btn">엑셀다운로드</button></div>
        <div class="wf-table-wrap wf-table-scroll-h">{table(["생성일","업무","Ref.No","주의정보","프로세스","액티비티","고객번호","고객명","통화","금액","진행구분","담당자","상세보기"], [["07/03","수출",'<span class="wf-link">FX-001</span>',"—","심사","1차심사","1234567","ABC","USD","10,000","진행","홍길동",'<button class="wf-btn wf-btn-sm">상세</button>']])}</div>
        <div class="wf-day-sum" style="margin:12px 16px;padding:10px;background:#f8fafc;border:1px solid var(--wf-border);border-radius:4px;font-size:11px">
          <strong>일별 집계</strong> 스캔건수 120 | AI자동심사 95 | 심사중 15 | 결재중 8 | 완료 102 | 총이미지수 450 <button type="button" class="wf-btn wf-btn-sm">새로고침</button>
        </div>""",
    "상세보기→이력. 하단 일별 집계 연동.",
)

# --- 4030 ---
SCREENS["4030"] = list_screen(
    "4030",
    "심사완료명세",
    "승인·Block 완료 목록. 결재취소.",
    "/revert/stat/complete",
    search_row(
        date_range_chk("업무생성일"),
        select("업무", "수출+수입"),
        select("완료구분", "Block", "승인"),
        text("담당직원번호"),
        text("Ref.No"),
        text("고객번호"),
    ),
    ["□", "생성일", "업무", "프로세스", "구분", "Ref.No", "고객번호", "고객명", "통화", "금액", "S1", "S2", "QA1", "QA2", "접수자", "스캔자", "영업점명", "TotalText", "항목심사", "S/W"],
    [["☑", "07/03", "수출", "심사", "승인", "FX-001", "1234567", "ABC", "USD", "10,000", "—", "—", "—", "—", "user01", "scan01", "강남", "40", "OK", "OK"]],
    "다중선택 결재취소. 엑셀다운로드.",
    toolbar='<div class="wf-task-log-toolbar"><button type="button" class="wf-btn">엑셀다운로드</button></div>',
    actions='<div class="wf-btn-group"><button type="button" class="wf-btn wf-btn-danger">결재취소</button></div>',
)

# --- 4040 ---
SCREENS["4040"] = list_screen(
    "4040",
    "심사오류명세",
    "수기보정·재스캔·재추출 이력 조회.",
    "/revert/stat/error",
    search_row(
        date_range_chk("업무생성일"),
        select("업무", "전체"),
        select("오류구분", "전체"),
        text("담당직원번호"),
        text("Ref.No"),
        text("고객번호"),
    ),
    ["생성일", "업무", "Ref.No", "액티비티", "고객번호", "고객명", "통화", "금액", "오류구분", "S1", "S2", "상세보기"],
    [["07/03", "수출", "FX-001", "1차심사", "1234567", "ABC", "USD", "10,000", "재추출", "—", "—", '<button class="wf-btn wf-btn-sm">상세</button>']],
    "상세보기→심사/QA 이력(읽기전용).",
    toolbar='<div class="wf-task-log-toolbar"><button type="button" class="wf-btn">엑셀다운로드</button></div>',
)

# --- 4050 ---
SCREENS["4050"] = section(
    "4050",
    "경보발생명세",
    "TotalText·항목심사·SafeWatch 경보 발생 이력.",
    ["패턴 C", "/revert/stat/alert"],
    f"""        <div class="wf-title-bar"><h3>경보발생명세 [4050]</h3></div>
        <div class="wf-search">
          <div class="wf-search-row">{date_range_chk("업무생성일")}{text("Ref.No")}{text("고객번호")}</div>
          <div class="wf-search-row" style="margin-top:6px">{select("업무", "전체")}{select("TotalText", "전체")}{select("항목심사", "전체")}{select("SafeWatch", "전체")}<button type="button" class="wf-btn-search">조회</button></div>
        </div>
        <div class="wf-task-log-toolbar"><button type="button" class="wf-btn">엑셀다운로드</button></div>
        <div class="wf-table-wrap wf-table-scroll-h">{table(["생성일","업무","Ref.No","액티비티","고객번호","고객명","통화","금액","S1","S2","TotalText","항목심사","S/W","상세보기"], [["07/03","수출","FX-001","1차심사","1234567","ABC","USD","10,000","—","—",'<span class="wf-badge-red">30</span>',"OK","OK",'<button class="wf-btn wf-btn-sm">상세</button>']])}</div>""",
    "2행 검색. 상세보기→이력 상세.",
)

# --- 6010 ---
SCREENS["6010"] = section(
    "6010",
    "성능분석",
    "일자별 정상·오류(수기등록·저품질·재추출) 건수 + 차트.",
    ["패턴 C+차트", "/stat/analysis"],
    f"""        <div class="wf-title-bar"><h3>성능분석 [6010]</h3></div>
        {search_row(date_range("업무생성일", "(최대 30일)"))}
        <div class="wf-task-log-toolbar"><button type="button" class="wf-btn">엑셀다운로드</button><button type="button" class="wf-btn">일 주요 성능지표</button></div>
        <div class="wf-task-log-grid-2" style="padding:0 16px">
          <div class="wf-task-log-panel"><div class="wf-task-log-panel-head">정상 &amp; 오류 차트</div><div class="wf-task-log-panel-body"><div class="wf-task-log-chart"><span style="height:60%;width:20px;background:#22c55e"></span><span style="height:40%;width:20px;background:#ef4444"></span></div></div></div>
          <div class="wf-task-log-panel"><div class="wf-task-log-panel-head">일자별 차트</div><div class="wf-task-log-panel-body"><div class="wf-task-log-chart"><span style="height:70%;width:20px;background:var(--wf-primary)"></span><span style="height:50%;width:20px;background:var(--wf-primary);opacity:.7"></span></div></div></div>
        </div>
        <div style="padding:0 16px 16px">
          <div class="wf-task-log-panel-head" style="border:1px solid var(--wf-border);border-bottom:none;border-radius:4px 4px 0 0">업무처리 건수내역</div>
          <div class="wf-table-wrap">{table(["일자","총 업무건수","자동건수","수기등록","저품질","재추출"], [["07/03","125","118","3","2","2"]])}</div>
        </div>""",
    "기간 조회→차트2+하단 표. 레포트 출력.",
)

# --- 6020 ---
SCREENS["6020"] = list_screen(
    "6020",
    "업무별 통계",
    "업무·담당자별 처리건수·처리시간.",
    "/stat/task",
    search_row(
        date_range("업무생성일", "(최대 30일)"),
        select("권한", "전체"),
        field("업무", '<label><input type="checkbox" checked> 수출</label> <label><input type="checkbox" checked> 수입</label>'),
    ),
    ["업무구분", "일자", "권한", "직원명", "직원번호", "처리건", "총처리 시간", "평균처리 시간"],
    [["수출", "07/03", "심사", "홍길동", "E10001", "45", "7h 30m", "10분"]],
    "엑셀다운로드.",
    toolbar='<div class="wf-task-log-toolbar"><button type="button" class="wf-btn">엑셀다운로드</button></div>',
)

# --- 6030 ---
SCREENS["6030"] = section(
    "6030",
    "항목별 통계",
    "항목별/기간별 조건별 거래건수 그래프·지도.",
    ["패턴 차트", "/stat/item"],
    f"""        <div class="wf-title-bar"><h3>항목별 통계 [6030]</h3></div>
        <div class="wf-stat-tabs" style="padding:12px 16px 0"><span class="wf-stat-tab active">항목별 통계</span><span class="wf-stat-tab">기간별 추이</span></div>
        <div class="wf-search" style="margin-top:8px"><div class="wf-search-row">
          {field("대상업무", '<label><input type="radio" name="biz6030" checked> 수출</label> <label><input type="radio" name="biz6030"> 수입</label>')}
          {date_range("업무생성일", "(최대 90일)")}
          {select("조건1", "금액")}{text("조건값1", "wf-input wf-short")}
          {select("x축", "일자")}
          <button type="button" class="wf-btn-search">조회</button>
        </div></div>
        <div class="wf-task-log-grid-2" style="padding:16px">
          <div class="wf-task-log-panel"><div class="wf-task-log-panel-head">Chart.js</div><div class="wf-task-log-panel-body"><div class="wf-task-log-chart" style="min-height:140px"><span style="height:55%;width:28px;background:var(--wf-primary)"></span><span style="height:80%;width:28px;background:var(--wf-primary)"></span></div></div></div>
          <div class="wf-task-log-panel"><div class="wf-task-log-panel-head">지도 (map.jsp)</div><div class="wf-task-log-panel-body" style="min-height:140px;background:#e2e8f0;display:flex;align-items:center;justify-content:center;color:var(--wf-muted);font-size:12px">거래국가 지도</div></div>
        </div>
        <div class="wf-btn-group" style="padding:0 16px 16px"><button type="button" class="wf-btn">이동뷰 전환</button></div>""",
    "탭별 검색·차트. 이동뷰→moveList.jsp.",
)

# --- 6040 ---
SCREENS["6040"] = list_screen(
    "6040",
    "조건별 통계",
    "조건별 심사명세 조회.",
    "/stat/cond",
    search_row(
        date_range("업무생성일", "(최대 90일)"),
        select("업무", "전체"),
        text("Ref.No"),
        select("조건1", "TotalText"),
        text("값1", "wf-input wf-short"),
    ),
    ["업무", "Ref.No", "R/N 일련번호", "고객번호", "고객명", "통화", "영업점", "수출상", "수입상", "선적항", "하역항", "원산지", "상세보기"],
    [["수출", "FX-001", "1", "1234567", "ABC", "USD", "강남", "Seller A", "Buyer B", "BUSAN", "LA", "KR", '<button class="wf-btn wf-btn-sm">상세</button>']],
    "조건1~5 텍스트/리스트 전환. 상세보기→이력.",
    toolbar='<div class="wf-task-log-toolbar"><button type="button" class="wf-btn">엑셀다운로드</button></div>',
)

# --- 6050 ---
SCREENS["6050"] = section(
    "6050",
    "고객별 통계",
    "고객별 거래현황 차트 + Pending/Block 이력.",
    ["패턴 C+차트", "/stat/user"],
    f"""        <div class="wf-title-bar"><h3>고객별 통계 [6050]</h3></div>
        {search_row(date_range("업무생성일", "(최대 90일)"), text("고객번호", val="1234567"), field("업무", '<label><input type="radio" name="u6050" checked> 수입</label> <label><input type="radio" name="u6050"> 수출</label>'))}
        <div class="wf-task-log-toolbar"><button type="button" class="wf-btn">레포트출력</button></div>
        <div class="wf-task-log-grid-2" style="padding:0 16px">
          <div class="wf-task-log-panel"><div class="wf-task-log-panel-head">거래국가</div><div class="wf-task-log-chart" style="min-height:80px"></div></div>
          <div class="wf-task-log-panel"><div class="wf-task-log-panel-head">거래상대방 (건수/금액)</div><div class="wf-task-log-chart" style="min-height:80px"></div></div>
          <div class="wf-task-log-panel"><div class="wf-task-log-panel-head">선적항 / 하역항</div><div class="wf-task-log-chart" style="min-height:60px"></div></div>
          <div class="wf-task-log-panel"><div class="wf-task-log-panel-head">물품 / 거래규모표</div>{table(["월별","거래건","금액"], [["2026-07","12","1.2M"]])}</div>
        </div>
        <div style="padding:0 16px 16px"><strong style="font-size:12px">Pending/Block 이력</strong>
        {table(["생성일","Ref.No","통화","금액","액티비티"], [["07/01","FX-001","USD","10,000","Pending"]])}</div>""",
    "고객번호 필수. 6분할 차트 + Pending/Block 표.",
)

# --- 7010 ---
SCREENS["7010"] = section(
    "7010",
    "사용자 관리",
    "사용자 CRUD. 좌 목록 / 우 상세 폼.",
    ["패턴 E", "/admin/user"],
    f"""        <div class="wf-title-bar"><h3>사용자 관리 [7010]</h3></div>
        {search_row(select("권한", "전체"), text("직원번호"), text("직원명"), select("사용여부", "전체", "사용", "미사용"), select("사용자구분", "전체"))}
        <div class="wf-split">
          <div class="wf-split-panel"><div class="wf-split-head">사용자 목록</div><div class="wf-split-body">{table(["권한","관리자","직원번호","직원명","담당 결재자 직원번호"], [["심사","N","E10001","홍길동","E20001"]])}</div></div>
          <div class="wf-split-panel"><div class="wf-split-head">사용자 정보</div><div class="wf-split-body"><div class="wf-form-panel"><div class="wf-form-row"><label>직원번호</label><input class="wf-input"></div><div class="wf-form-row"><label>직원명</label><input class="wf-input"></div><div class="wf-form-row"><label>권한</label><select class="wf-select"><option>심사</option></select></div></div><div class="wf-btn-group"><button class="wf-btn">신규</button><button class="wf-btn wf-btn-danger">삭제</button><button class="wf-btn wf-btn-primary">저장</button></div></div></div>
        </div>""",
    "목록 선택→폼 로드. CRUD.",
)

# --- 7021 ---
SCREENS["7021"] = list_screen(
    "7021",
    "로그인 이력관리",
    "로그인 이력 조회.",
    "/admin/log/login",
    search_row(date_range("로그인 일자"), text("직원번호"), text("아이피")),
    ["직원명", "로그인 시간", "로그인 아이피", "로그인 기기명", "성공여부"],
    [["홍길동", "07/03 09:00", "192.168.1.10", "PC-001", "성공"]],
    "기간·직원·IP 검색.",
)

# --- 7022 ---
SCREENS["7022"] = list_screen(
    "7022",
    "프로그램 사용 이력관리",
    "화면별 접근·행위 이력.",
    "/admin/log/program",
    search_row(date_range("로그 일자"), text("직원번호"), text("거래일련번호")),
    ["거래일련번호", "화면번호", "화면명", "화면섹션", "행위", "접속자명", "접속시각", "아이피", "파라미터", "상세"],
    [["10001", "1010", "본인작업 ToDoList", "—", "조회", "홍길동", "07/03 10:00", "192.168.1.10", "sch=...", '<button class="wf-btn wf-btn-sm">상세</button>']],
    "상세→파라미터 오버레이.",
)

# --- 7070 ---
SCREENS["7070"] = list_screen(
    "7070",
    "부재 관리",
    "사용자 부재정보 관리.",
    "/admin/absence",
    search_row(select("권한", "전체"), text("직원번호"), text("직원명"), select("부재여부", "전체", "N", "Y")),
    ["□", "권한", "직원번호", "직원명", "부재여부"],
    [["☑", "심사", "E10001", "홍길동", "Y"]],
    "다중선택 후 부재/해제.",
    actions='<div class="wf-btn-group"><button type="button" class="wf-btn">해제</button><button type="button" class="wf-btn wf-btn-primary">부재</button></div>',
)

# --- 7060 ---
SCREENS["7060"] = section(
    "7060",
    "QA선정 관리",
    "전일 수출·수입 심사완료건 QA 배정 Rule.",
    ["패턴 F", "/admin/qa/target"],
    f"""        <div class="wf-title-bar"><h3>QA선정 관리 [7060]</h3></div>
        <p style="padding:8px 16px;font-size:11px;color:var(--wf-muted)">전일 수출·수입 심사완료건에 대해 자체검증(QA) 대상 배정 Rule 관리</p>
        <div class="wf-task-log-grid-2" style="padding:0 16px">
          <div class="wf-task-log-panel"><div class="wf-task-log-panel-head">수출 QA 선정</div><div class="wf-task-log-panel-body"><div class="wf-form-panel"><div class="wf-form-row"><label>총건수</label><input class="wf-input wf-short" readonly value="120"></div><div class="wf-form-row"><label>Random</label><input class="wf-input wf-short" value="10"> %</div><div class="wf-form-row"><label>조건</label><select class="wf-select"><option>선택</option></select></div></div><button class="wf-btn wf-btn-primary">저장(수출)</button></div></div>
          <div class="wf-task-log-panel"><div class="wf-task-log-panel-head">수입 QA 선정</div><div class="wf-task-log-panel-body"><div class="wf-form-panel"><div class="wf-form-row"><label>총건수</label><input class="wf-input wf-short" readonly value="95"></div><div class="wf-form-row"><label>Random</label><input class="wf-input wf-short" value="10"> %</div></div><button class="wf-btn wf-btn-primary">저장(수입)</button></div></div>
        </div>""",
    "수출/수입 각각 Rule 저장.",
)

# --- 7080 ---
SCREENS["7080"] = section(
    "7080",
    "업무 재할당 관리",
    "배정 업무를 다른 사용자에게 재배정.",
    ["패턴 E", "/admin/retask"],
    f"""        <div class="wf-title-bar"><h3>업무 재할당 관리 [7080]</h3></div>
        {search_row(select("권한", "전체"), text("직원번호"), text("직원명"), select("부재여부", "전체"))}
        <div class="wf-split" style="min-height:200px">
          <div class="wf-split-panel"><div class="wf-split-head">사용자 목록</div><div class="wf-split-body">{table(["권한","직원번호","직원명","업무건수","부재여부"], [["심사","E10001","홍길동","12","N"]])}</div></div>
          <div class="wf-split-panel"><div class="wf-split-head">인계자 / 인수자</div><div class="wf-split-body"><div class="wf-form-panel"><div class="wf-form-row"><label>인계자</label><input class="wf-input wf-medium"></div><div class="wf-form-row"><label>인수자</label><input class="wf-input wf-medium"></div></div><button class="wf-btn">변경</button> <button class="wf-btn wf-btn-danger">삭제</button></div></div>
        </div>
        <div style="padding:8px 16px"><div class="wf-split-head">업무 목록</div>{table(["생성일","업무","Ref.No","프로세스","액티비티","담당자","고객번호","금액","TotalText"], [["07/03","수출","FX-001","심사","1차","홍길동","1234567","10,000","40"]])}</div>""",
    "사용자 선택→업무 그리드→인계/인수 변경.",
)

# --- 7090 ---
SCREENS["7090"] = section(
    "7090",
    "일괄결재 의견 관리",
    "일괄승인 결재 의견 템플릿 CRUD.",
    ["패턴 E", "/admin/app/memo"],
    f"""        <div class="wf-title-bar"><h3>일괄결재 의견 관리 [7090]</h3></div>
        <div class="wf-split">
          <div class="wf-split-panel" style="flex:0.4"><div class="wf-split-head">의견 목록</div><div class="wf-split-body">{table(["내용"], [["승인합니다"]], False)}</div></div>
          <div class="wf-split-panel"><div class="wf-split-head">의견 등록</div><div class="wf-split-body"><textarea class="wf-task-log-textarea" style="min-height:120px" placeholder="최대 4000 byte"></textarea><div class="wf-btn-group"><button class="wf-btn">신규</button><button class="wf-btn wf-btn-danger">삭제</button><button class="wf-btn wf-btn-primary">저장</button></div></div></div>
        </div>""",
    "좌 목록 선택→우 textarea 편집.",
)

# --- 8010 ---
SCREENS["8010"] = section(
    "8010",
    "국가코드관리",
    "국가코드 CRUD.",
    ["패턴 E", "/admin/nation"],
    f"""        <div class="wf-title-bar"><h3>국가코드관리 [8010]</h3></div>
        {search_row(text("국가코드", "wf-input wf-short"), text("국가명"), select("대표여부", "전체", "대표이름", "비대표이름"))}
        <div class="wf-split">
          <div class="wf-split-panel">{table(["국가코드","국가명(영문)","국가명(한글)","대표이름여부"], [["KR","KOREA","대한민국","Y"]])}</div>
          <div class="wf-split-panel"><div class="wf-form-panel"><div class="wf-form-row"><label>국가코드</label><input class="wf-input wf-short"></div><div class="wf-form-row"><label>국가명(한글)</label><input class="wf-input"></div></div><button class="wf-btn">신규</button> <button class="wf-btn wf-btn-danger">삭제</button> <button class="wf-btn wf-btn-primary">저장</button></div>
        </div>""",
    "좌 목록 / 우 폼 CRUD.",
)

# --- 8040 ---
SCREENS["8040"] = section(
    "8040",
    "도시항구관리",
    "도시·항구코드 CRUD.",
    ["패턴 E", "/admin/city"],
    f"""        <div class="wf-title-bar"><h3>도시항구관리 [8040]</h3></div>
        {search_row(select("도시항구구분", "전체"), text("City / Port"), text("국가코드", "wf-input wf-short"))}
        <div class="wf-split">
          <div class="wf-split-panel">{table(["도시항구","city / port","주 / Province","국가코드","국가명(대표)"], [["PORT","BUSAN","—","KR","대한민국"]])}</div>
          <div class="wf-split-panel"><div class="wf-form-panel"><div class="wf-form-row"><label>City/Port</label><input class="wf-input"></div><div class="wf-form-row"><label>국가코드</label><input class="wf-input wf-short"></div></div><button class="wf-btn">신규</button> <button class="wf-btn wf-btn-primary">저장</button></div>
        </div>""",
    "좌 목록 / 우 폼 CRUD.",
)

# --- 8050 ---
SCREENS["8050"] = section(
    "8050",
    "시스템심사진행현황",
    "심사 파이프라인 모니터링·재처리.",
    ["패턴 C", "/admin/status"],
    f"""        <div class="wf-title-bar"><h3>시스템심사진행현황 [8050]</h3></div>
        <div class="wf-search"><div class="wf-search-row">
          {field("업무생성일", '<label><input type="radio" name="d8050"> 전체</label> <label><input type="radio" name="d8050" checked> 당일</label>')}
          {select("심사진행상태", "전체")}{text("Ref.No")}
          {field("처리구분", '<label><input type="radio" checked> 전체</label> <label><input type="radio"> (재)심사 제외</label>')}
          {text("수행서버", "wf-input wf-short")}{text("경과시간(분)", "wf-input wf-short")}
          <button type="button" class="wf-btn-search">조회</button>
        </div></div>
        <div class="wf-task-log-toolbar" style="flex-wrap:wrap">
          <button class="wf-btn wf-btn-sm">액티비티 강제변경</button><button class="wf-btn wf-btn-sm">변경</button>
          <button class="wf-btn wf-btn-sm">심사결과분석(세트별)</button><button class="wf-btn wf-btn-sm">심사결과분석(항목별)</button>
          <button class="wf-btn wf-btn-sm">처리성능 분석</button><button class="wf-btn wf-btn-sm">심사수기등록 현황</button>
        </div>
        <div class="wf-table-wrap wf-table-scroll-h">{table(["생성일","업무","Ref.No","액티비티","담당자","이미지","CNN","OCR추출","항목추출","심사","S/W","경과시간","심사진행상태","처리구분","수행서버","삭제/재처리"], [["07/03","수출","FX-001","1차심사","—","✓","✓","✓","✓","✓","✓","5분","정상","자동","SV01",'<button class="wf-btn wf-btn-sm">재처리</button>']])}</div>""",
    "재처리 시 비밀번호 오버레이. 하단 일자별 엑셀 4종.",
)

# --- 8051 ---
SCREENS["8051"] = section(
    "8051",
    "재처리 정보 등록",
    "SQL 쿼리 실행·결과 조회 팝업.",
    ["패턴 G", "/admin/status/reg"],
    f"""        <div class="wf-modal-overlay" style="min-height:360px;position:relative">
          <div class="wf-modal" style="width:90%;max-width:720px">
            <div class="wf-modal-head"><span>재처리 정보 등록</span><span>×</span></div>
            <div class="wf-modal-body">
              {search_row(select("처리구분", "SELECT", "INSERT", "UPDATE", "DELETE"), btn="실행")}
              <div class="wf-field" style="margin-top:8px"><label>Query</label><textarea class="wf-task-log-textarea" style="min-height:80px;font-family:monospace">SELECT * FROM ...</textarea></div>
              <p style="font-size:11px;color:var(--wf-muted)">실행결과 — 동적 컬럼 DataTable</p>
              {table(["COL1","COL2","COL3"], [["val1","val2","val3"]])}
            </div>
            <div class="wf-modal-foot"><button class="wf-btn">엑셀다운로드</button><button class="wf-btn">닫기</button></div>
          </div>
        </div>""",
    "쿼리 실행→동적 그리드. 엑셀다운로드.",
)

# --- 8060 ---
SCREENS["8060"] = section(
    "8060",
    "후보정용어관리",
    "후보정 용어 CRUD.",
    ["패턴 E", "/admin/word/correction"],
    f"""        <div class="wf-title-bar"><h3>후보정용어관리 [8060]</h3></div>
        <p style="padding:4px 16px;font-size:11px;color:var(--wf-muted)">OCR 후보정 시 사용할 용어를 관리합니다.</p>
        {search_row(select("구분", "전체", "수출", "수입", "공통"), select("항목", "전체"), text("용어"))}
        <div class="wf-split">
          <div class="wf-split-panel" style="flex:1.4">{table(["구분","항목","용어"], [["수출","금액","USD"]])}</div>
          <div class="wf-split-panel"><div class="wf-split-head">용어 등록</div><div class="wf-form-panel"><div class="wf-form-row"><label>구분</label><select class="wf-select"><option>수출</option></select></div><div class="wf-form-row"><label>용어</label><input class="wf-input"></div></div><button class="wf-btn">신규</button> <button class="wf-btn wf-btn-primary">저장</button></div>
        </div>
        <div class="wf-task-log-toolbar"><button class="wf-btn">엑셀다운로드</button></div>""",
    "좌 58% 목록 + 우 등록 폼.",
)

# --- 8020 ---
SCREENS["8020"] = section(
    "8020",
    "공통코드관리",
    "그룹코드·공통코드 CRUD 4패널.",
    ["패턴 E", "/admin/code"],
    f"""        <div class="wf-title-bar"><h3>공통코드관리 [8020]</h3></div>
        <div class="wf-quad" style="min-height:280px">
          <div class="wf-quad-cell"><div class="wf-split-head">코드그룹 목록</div>{table(["그룹코드","코드그룹명","사용여부"], [["322","업무일지구분","Y"]])}</div>
          <div class="wf-quad-cell"><div class="wf-split-head">코드그룹 등록</div><div class="wf-form-panel"><div class="wf-form-row"><label>그룹코드</label><input class="wf-input wf-short"></div><div class="wf-form-row"><label>코드그룹명</label><input class="wf-input"></div></div><button class="wf-btn">신규</button> <button class="wf-btn wf-btn-primary">저장</button></div>
          <div class="wf-quad-cell"><div class="wf-split-head">공통코드 목록</div>{table(["공통코드","코드명(한글)","순서"], [["01","수출입 선적서류 심사","1"]])}</div>
          <div class="wf-quad-cell"><div class="wf-split-head">공통코드 등록</div><div class="wf-form-panel"><div class="wf-form-row"><label>공통코드</label><input class="wf-input wf-short"></div><div class="wf-form-row"><label>코드명</label><input class="wf-input"></div></div><button class="wf-btn">신규</button> <button class="wf-btn wf-btn-primary">저장</button></div>
        </div>""",
    "그룹 선택→코드 목록 연쇄. 각 패널 CRUD.",
)

# --- 8030 ---
SCREENS["8030"] = section(
    "8030",
    "영업일 관리",
    "월별 영업일·휴일 캘린더 그리드.",
    ["패턴 F", "/admin/businessday"],
    f"""        <div class="wf-title-bar"><h3>영업일 관리 [8030]</h3></div>
        <div class="wf-search"><div class="wf-search-row">{select("기준년도", "2026")}{select("기준월", "7월")}<button type="button" class="wf-btn">오늘</button><button type="button" class="wf-btn wf-btn-primary">저장</button></div></div>
        <div style="padding:0 16px 16px">{table(["일자","요일","휴일구분","비고"], [["2026-07-03","금","영업일",""],["2026-07-04","토","휴일","주말"],["2026-07-05","일","휴일","주말"]])}</div>""",
    "년/월 선택→일자 그리드 편집→저장.",
)

# --- 7040 ---
SCREENS["7040"] = section(
    "7040",
    "WatchList 등록",
    "카테고리→리스트→내용 3단 마스터-디테일.",
    ["패턴 E", "/admin/watchlist"],
    f"""        <div class="wf-title-bar"><h3>WatchList 등록 [7040]</h3></div>
        <div class="wf-split" style="min-height:320px">
          <div class="wf-split-panel" style="flex:0.35"><div class="wf-split-head">카테고리</div>{table(["카테고리명","카테고리 ID"], [["제재대상","CAT01"]])}<div class="wf-form-panel" style="margin-top:8px"><div class="wf-form-row"><label>카테고리명</label><input class="wf-input"></div></div><button class="wf-btn wf-btn-sm">신규</button> <button class="wf-btn wf-btn-sm wf-btn-primary">저장</button></div>
          <div class="wf-split-panel" style="flex:0.35"><div class="wf-split-head">리스트</div>{table(["리스트","리스트 ID"], [["OFAC","LST01"]])}<div class="wf-form-panel" style="margin-top:8px"><div class="wf-form-row"><label>리스트</label><input class="wf-input"></div></div><button class="wf-btn wf-btn-sm">신규</button> <button class="wf-btn wf-btn-sm wf-btn-primary">저장</button></div>
          <div class="wf-split-panel"><div class="wf-split-head">내용</div>{table(["내용","등록일자","삭제일자"], [["ACME CORP","2026-01-01","—"]])}<div class="wf-form-panel" style="margin-top:8px"><div class="wf-form-row"><label>내용</label><input class="wf-input"></div></div><button class="wf-btn wf-btn-sm">신규</button> <button class="wf-btn wf-btn-sm">엑셀업로드</button> <button class="wf-btn wf-btn-sm wf-btn-primary">저장</button></div>
        </div>""",
    "3단 연쇄 CRUD. 엑셀 샘플/업로드.",
)

# --- 2010-BUNDLE ---
SCREENS["2010-BUNDLE"] = section(
    "2010-BUNDLE",
    "일괄승인",
    "의견목록 선택 + 결재의견 작성 후 일괄 승인.",
    ["패턴 G", "/app/todo/bundle"],
    f"""        <div class="wf-modal-overlay" style="min-height:360px">
          <div class="wf-modal" style="width:640px">
            <div class="wf-modal-head"><span>일괄승인</span><span>×</span></div>
            <div class="wf-modal-body">
              <div class="wf-split" style="min-height:280px">
                <div class="wf-split-panel"><div class="wf-split-head">의견목록</div>{table(["내용"], [["승인합니다"]])}</div>
                <div class="wf-split-panel"><div class="wf-split-head">결재의견</div><textarea class="wf-task-log-textarea" style="min-height:180px" placeholder="전달의견 목록을 선택하거나 의견을 작성해주세요"></textarea><p style="font-size:10px;color:var(--wf-muted)">0 / 4000 byte</p></div>
              </div>
            </div>
            <div class="wf-modal-foot"><button type="button" class="wf-btn wf-btn-success">승인</button><button type="button" class="wf-btn">닫기</button></div>
          </div>
        </div>""",
    "의견목록 클릭→textarea 자동입력. 승인 처리.",
)

# --- 7030 ---
SCREENS["7030"] = section(
    "7030",
    "권한별 메뉴 관리",
    "권한별 메뉴·화면 사용 설정.",
    ["패턴 E", "/admin/menu"],
    f"""        <div class="wf-title-bar"><h3>권한별 메뉴 관리 [7030]</h3></div>
        <div class="wf-search"><div class="wf-search-row">{select("권한", "심사", "결재", "QA")}</div></div>
        <div class="wf-split">
          <div class="wf-split-panel"><div class="wf-split-head">메뉴 목록</div>{table(["메뉴ID","메뉴명"], [["100001","심사"],["100002","당일작업"]])}</div>
          <div class="wf-split-panel"><div class="wf-split-head">화면 목록 (사용 체크)</div>{table(["화면ID","화면명","사용"], [["1010","본인작업 ToDoList","☑"],["1020","진행업무별 현재상태","☑"]])}</div>
        </div>
        <div class="wf-btn-group" style="padding:12px 16px"><button class="wf-btn">메뉴등록</button><span style="flex:1"></span><button class="wf-btn wf-btn-primary">저장</button></div>""",
    "권한 선택→메뉴→화면 체크. 메뉴등록→7031.",
)

# --- 7050 ---
SCREENS["7050"] = section(
    "7050",
    "제재 Rule 등록",
    "TotalText·항목심사 제재 Rule 관리.",
    ["패턴 E", "/admin/sanction"],
    f"""        <div class="wf-title-bar"><h3>제재 Rule 등록 [7050]</h3></div>
        <div class="wf-search"><div class="wf-search-row">{field("Rule 유형", '<label><input type="radio" name="r7050" checked> TotalText</label> <label><input type="radio" name="r7050"> 항목심사</label>')}</div></div>
        <div class="wf-split">
          <div class="wf-split-panel"><div class="wf-split-head">TotalText Rule 등록</div>{table(["카테고리","리스트"], [["제재대상","OFAC"]])}<div class="wf-form-panel" style="margin-top:8px"><div class="wf-form-row"><label>리스트</label><select class="wf-select"><option>선택</option></select></div></div><button class="wf-btn wf-btn-sm">등록</button> <button class="wf-btn wf-btn-sm wf-btn-danger">삭제</button></div>
          <div class="wf-split-panel"><div class="wf-split-head">Rule 조건 (AND/OR)</div><p style="font-size:11px;padding:8px;color:var(--wf-muted)">조건1~4 × 리스트 매핑 그리드</p>{table(["조건","리스트1","리스트2"], [["조건1","L1","L2"]])}<button class="wf-btn wf-btn-primary">Rule적용요청</button></div>
        </div>""",
    "TotalText/항목심사 탭 전환. Rule CRUD·적용요청.",
)

# --- 9080 ---
SCREENS["9080"] = section(
    "9080",
    "심사이력",
    "심사 이력 DataTable + 추가의견 + 첨부파일.",
    ["패턴 H", "popup"],
    f"""        <div class="wf-detail-header"><strong>심사이력 [9080] — Ref.No: FX-2026-000123</strong><button class="wf-btn wf-btn-sm">× 닫기</button></div>
        <div style="padding:12px 16px">
          <div class="wf-split-head">심사이력</div>
          {table(["액티비티","담당자","시작시간","처리시간","처리","심사의견"], [["1차심사","홍길동","07/03 09:00","2h 10m","완료","승인"]])}
          <div style="margin-top:12px"><label style="font-size:12px">추가의견</label><textarea class="wf-task-log-textarea" style="min-height:48px" placeholder="추가할 의견을 입력해주세요"></textarea><button class="wf-btn wf-btn-sm wf-btn-primary">저장</button></div>
          <div style="margin-top:16px"><div class="wf-split-head">첨부파일 업로드</div>
          <div class="wf-split"><div class="wf-split-panel">{table(["파일명","등록일","삭제"], [["evidence.pdf","07/03","×"]])}</div><div class="wf-split-panel" style="display:flex;align-items:center;justify-content:center;border:1px dashed var(--wf-border);min-height:80px"><button class="wf-btn">파일선택 · 업로드</button></div></div></div>
        </div>""",
    "Ref.No 더블클릭 호출. 행 클릭→9010 이력상세.",
)

# --- 9090 ---
SCREENS["9090"] = section(
    "9090",
    "QA이력",
    "QA 이력 DataTable + 추가의견 + 첨부파일.",
    ["패턴 H", "popup"],
    f"""        <div class="wf-detail-header"><strong>QA이력 [9090] — Ref.No: FX-Q001</strong><button class="wf-btn wf-btn-sm">× 닫기</button></div>
        <div style="padding:12px 16px">
          {table(["액티비티","담당자","시작시간","처리시간","처리","심사의견"], [["QA심사","이QA","07/03 13:00","1h","완료","적정"]])}
          <div style="margin-top:12px"><label style="font-size:12px">추가의견</label><textarea class="wf-task-log-textarea" style="min-height:48px"></textarea><button class="wf-btn wf-btn-sm wf-btn-primary">저장</button></div>
          <div style="margin-top:16px"><div class="wf-split-head">첨부파일 업로드</div><button class="wf-btn wf-btn-sm">파일선택</button></div>
        </div>""",
    "QA Ref.No 더블클릭 호출. 행 클릭→9020.",
)

# --- 2010 title fix in 2020 ---
# Update 2010 section title in wireframe was already correct

SKIP_IDS = {
    "overview", "REQ", "LOGIN", "LOGIN-v2", "MAIN", "DASH", "DASH-v2", "9999",
    "1010-v2", "1011", "1011-v2", "1011-BL", "2010-BUNDLE", "2011", "2011-QA", "3011",
    "5010", "5020", "5030", "5040", "6066", "7030", "7031", "7040", "7050", "8020", "8030", "8070",
    "9080", "9090", "9010", "9020", "MODAL",
}


def patch_index() -> int:
    html = INDEX.read_text(encoding="utf-8")
    count = 0
    for sid, new_section in SCREENS.items():
        pattern = rf'    <!-- ===== {re.escape(sid)} ===== -->.*?    </section>\n'
        if not re.search(pattern, html, re.DOTALL):
            print(f"WARN: section {sid} not found")
            continue
        html = re.sub(pattern, new_section + "\n", html, count=1, flags=re.DOTALL)
        count += 1
        print(f"OK: {sid}")
    INDEX.write_text(html, encoding="utf-8")
    return count


if __name__ == "__main__":
    n = patch_index()
    print(f"Patched {n} sections in {INDEX}")
