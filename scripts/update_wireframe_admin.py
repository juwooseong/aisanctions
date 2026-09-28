# -*- coding: utf-8 -*-
"""Refresh admin 7xxx/8xxx wireframe sections in index.html."""
from __future__ import annotations

import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
INDEX = ROOT / "docs" / "wireframes" / "index.html"
sys.path.insert(0, str(ROOT / "scripts"))
from update_wireframe_screens import (  # noqa: E402
    date_range,
    field,
    search_row,
    section,
    select,
    table,
    text,
)


def ab(*items: tuple[str, str]) -> str:
    """Compact admin action buttons. items: (label, optional class suffix e.g. ' wf-btn-primary')."""
    html = '<div class="wf-admin-actions">'
    for label, cls in items:
        html += f'<button type="button" class="wf-btn wf-btn-sm{cls}">{label}</button>'
    html += "</div>"
    return html


def split_row(left: str, right: str, min_h: str = "130px") -> str:
    return f'<div class="wf-split wf-admin-split" style="min-height:{min_h}"><div class="wf-split-panel">{left}</div><div class="wf-split-panel">{right}</div></div>'


ADMIN: dict[str, str] = {}

# 7010
ADMIN["7010"] = section(
    "7010",
    "사용자 관리",
    "사용자 CRUD. 좌 리스트 / 우 상세 폼.",
    ["패턴 E", "/admin/user"],
    f"""        <div class="wf-title-bar"><h3>사용자 관리 [7010]</h3></div>
        {search_row(select("권한", "전체", "심사", "결재", "QA"), text("직원번호"), text("직원명"), select("사용여부", "사용", "미사용"), select("사용자구분", "일반"))}
        <div class="wf-split wf-admin-split">
          <div class="wf-split-panel"><div class="wf-split-head">사용자 리스트</div><div class="wf-split-body">{table(["권한","관리자","직원번호","직원명","담당 결재자 직원번호"], [["심사","N","E10001","홍길동","E20001"]])}</div></div>
          <div class="wf-split-panel"><div class="wf-split-head">사용자 정보</div><div class="wf-split-body">
            <div class="wf-form-panel wf-form-compact">
              <div class="wf-form-row"><label>직원번호</label><input class="wf-input wf-medium"></div>
              <div class="wf-form-row"><label>직원명</label><input class="wf-input wf-medium"></div>
              <div class="wf-form-row"><label>사용여부</label><select class="wf-select"><option>사용</option><option>미사용</option></select></div>
              <div class="wf-form-row"><label>사용자구분</label><select class="wf-select"><option>일반</option></select></div>
              <div class="wf-form-row"><label>권한</label><select class="wf-select"><option>심사</option></select></div>
              <div class="wf-form-row"><label>관리자여부</label><label><input type="checkbox"> Y</label></div>
              <div class="wf-form-row"><label>담당 결재자</label><input class="wf-input wf-short"> <button type="button" class="wf-btn wf-btn-sm">🔍</button> <input class="wf-input wf-medium" placeholder="직원명" readonly></div>
            </div>
            {ab(("신규", ""), ("삭제", " wf-btn-danger"), ("저장", " wf-btn-primary"))}
          </div></div>
        </div>""",
    "목록 선택→폼 로드. 신규/삭제/저장.",
)

# 7030
ADMIN["7030"] = section(
    "7030",
    "권한별 메뉴 관리",
    "권한별 메뉴·화면 사용(Y/N) 설정.",
    ["패턴 E", "/admin/menu"],
    f"""        <div class="wf-title-bar"><h3>권한별 메뉴 관리 [7030]</h3></div>
        <div class="wf-search"><div class="wf-search-row">{select("권한", "심사", "결재", "QA")}</div></div>
        <div class="wf-split wf-admin-split">
          <div class="wf-split-panel"><div class="wf-split-head">메뉴 목록</div>{table(["메뉴ID","메뉴명"], [["100001","심사"],["100010","당일작업"]])}</div>
          <div class="wf-split-panel"><div class="wf-split-head">화면 목록</div>{table(["화면ID","화면명","사용"], [["1010","본인작업 ToDoList","Y"],["1020","진행업무별 현재상태","Y"]])}</div>
        </div>
        <div class="wf-admin-bar">{ab(("메뉴등록", ""))}<span style="flex:1"></span>{ab(("저장", " wf-btn-primary"))}</div>""",
    "메뉴 선택→화면 체크. 메뉴등록→7031 팝업.",
)

# 7031 popup
ADMIN["7031"] = section(
    "7031",
    "메뉴등록",
    "대메뉴 조회 + 메뉴 그리드 + 등록 폼 (팝업).",
    ["패턴 G", "/admin/menu/menuReg"],
    f"""        <div class="wf-modal-overlay" style="min-height:420px;position:relative">
          <div class="wf-modal" style="width:92%;max-width:900px">
            <div class="wf-modal-head"><span>메뉴등록 [7031]</span><span>×</span></div>
            <div class="wf-modal-body">
              <div class="wf-search"><div class="wf-search-row">{select("대메뉴", "심사", "관리자")}<button type="button" class="wf-btn-search">조회</button></div></div>
              <div class="wf-split wf-admin-split" style="min-height:260px">
                <div class="wf-split-panel" style="flex:1.5">{table(["메뉴ID","메뉴명","URL","상위메뉴ID","화면번호","관리자화면"], [["100010","당일작업","/todo","100001","1010","N"]])}</div>
                <div class="wf-split-panel">
                  <div class="wf-form-panel wf-form-compact">
                    <div class="wf-form-row"><label>메뉴ID</label><input class="wf-input wf-short"></div>
                    <div class="wf-form-row"><label>메뉴명</label><input class="wf-input"></div>
                    <div class="wf-form-row"><label>URL</label><input class="wf-input"></div>
                    <div class="wf-form-row"><label>상위메뉴ID</label><input class="wf-input wf-short"> <input class="wf-input wf-medium" placeholder="상위메뉴명" readonly></div>
                    <div class="wf-form-row"><label>화면번호</label><input class="wf-input wf-short"> <input class="wf-input wf-medium" placeholder="화면명" readonly></div>
                    <div class="wf-form-row"><label>관리자 화면</label><select class="wf-select"><option>Y</option><option>N</option></select></div>
                  </div>
                  {ab(("신규", ""), ("삭제", " wf-btn-danger"), ("저장", " wf-btn-primary"))}
                </div>
              </div>
            </div>
          </div>
        </div>""",
    "대메뉴 조회→그리드. 신규/삭제/저장.",
)

# 7040 WatchList 3-tier
ADMIN["7040"] = section(
    "7040",
    "WatchList 등록",
    "카테고리→리스트→내용 3단 CRUD + 엑셀.",
    ["패턴 E", "/admin/watchlist"],
    f"""        <div class="wf-title-bar"><h3>WatchList 등록 [7040]</h3></div>
        <div class="wf-admin-stack">
          {split_row('<div class="wf-split-head">카테고리</div>' + table(["카테고리명","카테고리ID"], [["제재대상","CAT01"]]), '<div class="wf-split-head">카테고리 생성</div><div class="wf-form-panel wf-form-compact"><div class="wf-form-row"><label>카테고리명</label><input class="wf-input"></div><div class="wf-form-row"><label>비고</label><input class="wf-input"></div></div>' + ab(("신규",""),("삭제"," wf-btn-danger"),("저장"," wf-btn-primary")))}
          {split_row('<div class="wf-split-head">리스트</div>' + table(["리스트명","리스트ID"], [["OFAC","LST01"]]), '<div class="wf-split-head">리스트 생성</div><div class="wf-form-panel wf-form-compact"><div class="wf-form-row"><label>리스트명</label><input class="wf-input"></div><div class="wf-form-row"><label>비고</label><input class="wf-input"></div></div>' + ab(("신규",""),("삭제"," wf-btn-danger"),("저장"," wf-btn-primary")))}
          {split_row('<div class="wf-split-head">내용 <select class="wf-select" style="margin-left:8px;font-size:11px"><option>사용</option><option>미사용</option><option>전체</option></select></div>' + table(["내용","등록일자","삭제일자"], [["ACME CORP","2026-01-01","—"]]), '<div class="wf-split-head">내용 생성</div><p style="font-size:10px;color:var(--wf-muted);margin:0 0 6px">엑셀샘플 형식·복호화 파일만 업로드</p><div class="wf-form-row"><label>내용</label><input class="wf-input"></div>' + ab(("엑셀샘플",""),("엑셀업로드",""),("신규",""),("삭제"," wf-btn-danger"),("저장"," wf-btn-primary")))}
        </div>""",
    "3단 연쇄 선택. 내용 엑셀 샘플/업로드.",
)

# 7050 Rule
ADMIN["7050"] = section(
    "7050",
    "제재 Rule 등록",
    "TotalText / 항목심사 Rule 탭.",
    ["패턴 E", "/admin/sanction"],
    f"""        <div class="wf-title-bar"><h3>제재 Rule 등록 [7050]</h3></div>
        <div class="wf-search"><div class="wf-search-row">{field("Rule 유형", '<label><input type="radio" name="r7050" checked> TotalText</label> <label><input type="radio" name="r7050"> 항목심사</label>')}</div></div>
        <div class="wf-split wf-admin-split">
          <div class="wf-split-panel"><div class="wf-split-head">Rule 등록 (카테고리·리스트)</div>{table(["카테고리","리스트"], [["제재대상","OFAC"]])}<div class="wf-form-panel wf-form-compact" style="margin-top:6px"><div class="wf-form-row"><label>리스트</label><select class="wf-select"><option>선택</option></select></div></div>{ab(("등록",""),("삭제"," wf-btn-danger"))}</div>
          <div class="wf-split-panel"><div class="wf-split-head">Rule 조건 (AND/OR) + 항목 생성</div>{table(["조건","리스트1","리스트2","리스트3","리스트4"], [["조건1","L1","—","—","—"]])}{ab(("Rule적용요청"," wf-btn-primary"))}</div>
        </div>""",
    "TotalText/항목심사 전환. Rule CRUD·적용요청.",
)

# 7060
ADMIN["7060"] = section(
    "7060",
    "QA선정 관리",
    "전일 수출·수입 심사완료건 QA 배정 Rule.",
    ["패턴 F", "/admin/qa/target"],
    f"""        <div class="wf-title-bar"><h3>QA선정 관리 [7060]</h3></div>
        <p class="wf-admin-hint">※ QA 선정 건수 = 총건수 × 3 (TotalText·항목심사·SafeWatch 각각) · 조건 우선, 나머지 Random</p>
        <div class="wf-admin-stack">
          {split_row('<div class="wf-split-head">수출</div><div class="wf-form-panel wf-form-compact"><div class="wf-form-row"><label>총건수(건)</label><input class="wf-input wf-short" value="120" readonly></div><div class="wf-form-row"><label>Random(건)</label><input class="wf-input wf-short" value="10"></div><div class="wf-form-row"><label>조건</label><select class="wf-select"><option>선택</option></select> <select class="wf-select"><option>리스트</option></select></div></div>', ab(("저장"," wf-btn-primary")), "100px")}
          {split_row('<div class="wf-split-head">수입</div><div class="wf-form-panel wf-form-compact"><div class="wf-form-row"><label>총건수(건)</label><input class="wf-input wf-short" value="95" readonly></div><div class="wf-form-row"><label>Random(건)</label><input class="wf-input wf-short" value="8"></div><div class="wf-form-row"><label>조건</label><select class="wf-select"><option>선택</option></select> <select class="wf-select"><option>리스트</option></select></div></div>', ab(("저장"," wf-btn-primary")), "100px")}
        </div>""",
    "수출/수입 각각 저장.",
)

# 7080 - fix buttons
ADMIN["7080"] = section(
    "7080",
    "업무 재할당 관리",
    "사용자별 업무 재배정.",
    ["패턴 E", "/admin/retask"],
    f"""        <div class="wf-title-bar"><h3>업무 재할당 관리 [7080]</h3></div>
        {search_row(select("권한", "전체"), text("직원번호"), text("직원명"), select("부재여부", "전체", "N", "Y"))}
        <div class="wf-split wf-admin-split" style="min-height:160px">
          <div class="wf-split-panel"><div class="wf-split-head">사용자 목록</div>{table(["권한","직원번호","직원명","업무건수","부재여부"], [["심사","E10001","홍길동","12","N"]])}</div>
          <div class="wf-split-panel"><div class="wf-split-head">인계자 / 인수자</div><div class="wf-form-panel wf-form-compact"><div class="wf-form-row"><label>인계자</label><input class="wf-input wf-medium"></div><div class="wf-form-row"><label>인수자</label><input class="wf-input wf-medium"></div></div>{ab(("변경",""),("삭제"," wf-btn-danger"))}</div>
        </div>
        <div style="padding:8px 16px 16px"><div class="wf-split-head">업무 목록</div>{table(["생성일","업무","Ref.No","프로세스","액티비티","담당자","고객번호","금액","TotalText","항목심사","S/W","Detection ID","master ID"], [["07/03","수출","FX-001","심사","1차","홍길동","1234567","10,000","40","OK","OK","D001","M001"]])}</div>""",
    "사용자 선택→업무 그리드→인계/인수 변경.",
)

# 8010
ADMIN["8010"] = section(
    "8010",
    "국가코드관리",
    "국가코드 CRUD.",
    ["패턴 E", "/admin/nation"],
    f"""        <div class="wf-title-bar"><h3>국가코드관리 [8010]</h3></div>
        {search_row(text("국가코드", "wf-input wf-short"), text("국가명"), select("대표여부", "전체", "대표이름", "비대표이름"))}
        <div class="wf-split wf-admin-split">
          <div class="wf-split-panel">{table(["국가코드","국가명(영문)","국가명(한글)","대표이름여부"], [["KR","KOREA","대한민국","Y"]])}</div>
          <div class="wf-split-panel"><div class="wf-form-panel wf-form-compact"><div class="wf-form-row"><label>국가코드</label><input class="wf-input wf-short"></div><div class="wf-form-row"><label>국가명(한글)</label><input class="wf-input"></div><div class="wf-form-row"><label>국가명(영문)</label><input class="wf-input"></div><div class="wf-form-row"><label>대표이름여부</label><select class="wf-select"><option>Y</option><option>N</option></select></div></div>{ab(("신규",""),("삭제"," wf-btn-danger"),("저장"," wf-btn-primary"))}</div>
        </div>""",
    "좌 목록 / 우 폼 CRUD.",
)

# 8020
ADMIN["8020"] = section(
    "8020",
    "공통코드관리",
    "그룹코드·공통코드 4패널.",
    ["패턴 E", "/admin/code"],
    f"""        <div class="wf-title-bar"><h3>공통코드관리 [8020]</h3></div>
        <div class="wf-quad wf-admin-quad">
          <div class="wf-quad-cell"><div class="wf-split-head">코드그룹 목록</div>{table(["그룹코드","코드그룹명","비고","사용여부"], [["322","업무일지구분","","Y"]])}</div>
          <div class="wf-quad-cell"><div class="wf-split-head">코드그룹 등록</div><div class="wf-form-panel wf-form-compact"><div class="wf-form-row"><label>그룹코드</label><input class="wf-input wf-short"></div><div class="wf-form-row"><label>코드그룹명</label><input class="wf-input"></div><div class="wf-form-row"><label>비고</label><input class="wf-input"></div><div class="wf-form-row"><label>사용여부</label><select class="wf-select"><option>Y</option><option>N</option></select></div></div>{ab(("신규",""),("삭제"," wf-btn-danger"),("저장"," wf-btn-primary"))}</div>
          <div class="wf-quad-cell"><div class="wf-split-head">공통코드 목록</div>{table(["그룹코드","공통코드","코드명(한글)","코드명(영문)","순서"], [["322","01","수출입 선적서류 심사","","1"]])}</div>
          <div class="wf-quad-cell"><div class="wf-split-head">공통코드 등록</div><div class="wf-form-panel wf-form-compact"><div class="wf-form-row"><label>공통코드</label><input class="wf-input wf-short"></div><div class="wf-form-row"><label>코드명(한글)</label><input class="wf-input"></div><div class="wf-form-row"><label>코드명(영문)</label><input class="wf-input"></div><div class="wf-form-row"><label>순서</label><input class="wf-input wf-short"></div></div>{ab(("신규",""),("삭제"," wf-btn-danger"),("저장"," wf-btn-primary"))}</div>
        </div>""",
    "그룹 선택→코드 목록. 패널별 CRUD.",
)

# 8040
ADMIN["8040"] = section(
    "8040",
    "도시항구관리",
    "도시·항구코드 CRUD.",
    ["패턴 E", "/admin/city"],
    f"""        <div class="wf-title-bar"><h3>도시항구관리 [8040]</h3></div>
        {search_row(select("도시항구구분", "전체"), text("City / Port"), text("국가코드", "wf-input wf-short"))}
        <div class="wf-split wf-admin-split">
          <div class="wf-split-panel">{table(["도시항구","city/port","주/Province","국가코드","국가명"], [["PORT","BUSAN","—","KR","대한민국"]])}</div>
          <div class="wf-split-panel"><div class="wf-form-panel wf-form-compact"><div class="wf-form-row"><label>구분</label><select class="wf-select"><option>PORT</option></select></div><div class="wf-form-row"><label>City/Port</label><input class="wf-input"></div><div class="wf-form-row"><label>국가코드</label><input class="wf-input wf-short"></div></div>{ab(("신규",""),("삭제"," wf-btn-danger"),("저장"," wf-btn-primary"))}</div>
        </div>""",
    "좌 목록 / 우 폼 CRUD.",
)

# 8050
ADMIN["8050"] = section(
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
        <div class="wf-admin-bar">{ab(("액티비티 강제변경",""),("변경",""),("심사결과분석(세트별)",""),("심사결과분석(항목별)",""),("처리성능 분석",""),("심사수기등록 현황",""))}</div>
        <div class="wf-table-wrap wf-table-scroll-h">{table(["생성일","업무","Ref.No","액티비티","담당자","이미지","CNN","OCR","항목","심사","S/W","경과","진행상태","처리구분","서버","삭제/재처리"], [["07/03","수출","FX-001","1차","—","✓","✓","✓","✓","✓","✓","5분","정상","자동","SV01",'<button type="button" class="wf-btn wf-btn-sm">재처리</button>']])}</div>
        <div class="wf-admin-bar">{ab(("엑셀(당일)",""),("엑셀(전일)",""),("엑셀(주간)",""),("엑셀(월간)",""))}</div>""",
    "재처리 비밀번호 오버레이. 하단 일자별 엑셀.",
)

# 8070
ADMIN["8070"] = section(
    "8070",
    "AI 운영 모니터링",
    "GPU·LLM·로그·이용자 현황 (FR-058).",
    ["FR-058", "/admin/monitor"],
    f"""        <div class="wf-title-bar"><h3>AI 운영 모니터링 [8070]</h3></div>
        <div class="wf-monitor-grid" style="padding:12px 16px">
          <div class="wf-monitor-card"><h4>GPU 사용률</h4><div class="wf-monitor-val">67%</div><span class="wf-status-badge normal">정상</span></div>
          <div class="wf-monitor-card"><h4>LLM 추출 큐</h4><div class="wf-monitor-val">12</div><span class="wf-status-badge delayed">지연</span></div>
          <div class="wf-monitor-card"><h4>오늘 처리건</h4><div class="wf-monitor-val">428</div></div>
          <div class="wf-monitor-card"><h4>모델 F1</h4><div class="wf-monitor-val">96.2%</div></div>
          <div class="wf-monitor-card"><h4>공격 탐지</h4><div class="wf-monitor-val">0</div><span class="wf-status-badge normal">Clean</span></div>
          <div class="wf-monitor-card"><h4>동시 접속</h4><div class="wf-monitor-val">24</div></div>
        </div>
        <div class="wf-table-wrap" style="padding-top:0">{table(["시간","서비스","이벤트","상태"], [["15:30:01","LLM-Extract","배치 완료 50건","OK"],["15:28:44","GPU-Node-02","메모리 82%","Warn"]])}</div>""",
    "FR-058 AI Ops 모니터링.",
)

# 7050-AUTH
ADMIN["7050-AUTH"] = section(
    "7050-AUTH",
    "업무별 권한 설정",
    "Task-User Mapping·화면접근 (FR-042, FR-054).",
    ["FR-042", "FR-054"],
    f"""        <div class="wf-title-bar"><h3>업무별 권한 설정 [7050]</h3></div>
        <div class="wf-search-v2" style="margin:12px 16px">
          <span class="wf-search-label">검색</span>
          <div class="wf-search-fields"><div class="wf-field"><label>사용자</label><select class="wf-select"><option>홍길동</option></select></div><div class="wf-field"><label>업무</label><select class="wf-select"><option>수출 심사</option><option>수입 심사</option></select></div></div>
          <div class="wf-search-actions"><button type="button" class="wf-btn-reset">초기화</button><button type="button" class="wf-btn-search">조회</button></div>
        </div>
        <div class="wf-split wf-admin-split" style="margin:0 16px 12px;min-height:220px">
          <div class="wf-split-panel"><div class="wf-split-head">업무별 역할 (FR-042)</div>{table(["업무","역할","심사단계"], [["수출 심사","S1 (1차)","1단계"],["송금 심사","S2 (2차)","2단계 필수"]])}<p class="wf-admin-hint">FR-044: 동일 업무 S1·S2 동시 부여 불가</p></div>
          <div class="wf-split-panel"><div class="wf-split-head">화면별 접근권한 (FR-054)</div>{table(["□","화면ID","화면명","접근"], [["☑","1010","본인작업 ToDo","Y"],["☑","1011","심사상세","Y"],["□","7050","업무별권한","N"]])}</div>
        </div>
        <div class="wf-admin-bar">{ab(("저장"," wf-btn-primary"))}</div>""",
    "업무 역할·화면 접근 저장.",
)

# 7090, 8060 - compact buttons only via re-patch
ADMIN["7090"] = section(
    "7090",
    "일괄결재 의견 관리",
    "일괄승인 결재 의견 템플릿.",
    ["패턴 E", "/admin/app/memo"],
    f"""        <div class="wf-title-bar"><h3>일괄결재 의견 관리 [7090]</h3></div>
        <div class="wf-split wf-admin-split" style="margin:12px 16px;min-height:200px">
          <div class="wf-split-panel" style="flex:0.38"><div class="wf-split-head">의견 목록</div>{table(["내용"], [["승인합니다"],["검토 후 승인"]])}</div>
          <div class="wf-split-panel"><div class="wf-split-head">의견 등록</div><textarea class="wf-task-log-textarea" style="min-height:100px" placeholder="최대 4000 byte"></textarea>{ab(("신규",""),("삭제"," wf-btn-danger"),("저장"," wf-btn-primary"))}</div>
        </div>""",
    "목록 선택→textarea 편집.",
)

ADMIN["8060"] = section(
    "8060",
    "후보정용어관리",
    "후보정 용어 CRUD.",
    ["패턴 E", "/admin/word/correction"],
    f"""        <div class="wf-title-bar"><h3>후보정용어관리 [8060]</h3></div>
        <p class="wf-admin-hint">OCR 후보정 시 사용할 용어를 관리합니다.</p>
        {search_row(select("구분", "전체", "수출", "수입", "공통"), select("항목", "전체"), text("용어"))}
        <div class="wf-split wf-admin-split" style="margin:0 16px">
          <div class="wf-split-panel" style="flex:1.4">{table(["구분","항목","용어"], [["수출","금액","USD"]])}</div>
          <div class="wf-split-panel"><div class="wf-split-head">용어 등록</div><div class="wf-form-panel wf-form-compact"><div class="wf-form-row"><label>구분</label><select class="wf-select"><option>수출</option></select></div><div class="wf-form-row"><label>항목</label><select class="wf-select"><option>금액</option></select></div><div class="wf-form-row"><label>용어</label><input class="wf-input"></div></div>{ab(("신규",""),("삭제"," wf-btn-danger"),("저장"," wf-btn-primary"))}</div>
        </div>
        <div class="wf-admin-bar">{ab(("엑셀다운로드",""))}</div>""",
    "좌 목록 + 우 등록 폼.",
)

ADMIN["8051"] = section(
    "8051",
    "재처리 정보 등록",
    "SQL 실행 팝업.",
    ["패턴 G", "/admin/status/reg"],
    f"""        <div class="wf-modal-overlay" style="min-height:360px;position:relative">
          <div class="wf-modal" style="width:90%;max-width:720px">
            <div class="wf-modal-head"><span>재처리 정보 등록 [8051]</span><span>×</span></div>
            <div class="wf-modal-body">
              <div class="wf-search"><div class="wf-search-row">{select("처리구분", "SELECT", "INSERT", "UPDATE", "DELETE")}<button type="button" class="wf-btn-search">실행</button></div></div>
              <div class="wf-field" style="margin-top:8px"><label>Query</label><textarea class="wf-task-log-textarea" style="min-height:72px;font-family:monospace;font-size:11px">SELECT * FROM ...</textarea></div>
              <p class="wf-admin-hint">실행결과 — 동적 컬럼 DataTable</p>
              {table(["COL1","COL2","COL3"], [["val1","val2","val3"]])}
            </div>
            <div class="wf-modal-foot">{ab(("엑셀다운로드",""),("닫기",""))}</div>
          </div>
        </div>""",
    "쿼리 실행→동적 그리드.",
)


def patch() -> int:
    html = INDEX.read_text(encoding="utf-8")
    n = 0
    for sid, block in ADMIN.items():
        pat = rf'    <!-- ===== {re.escape(sid)} ===== -->.*?    </section>\n'
        if not re.search(pat, html, re.DOTALL):
            print(f"WARN: {sid} not found")
            continue
        html = re.sub(pat, block + "\n", html, count=1, flags=re.DOTALL)
        print(f"OK: {sid}")
        n += 1
    INDEX.write_text(html, encoding="utf-8")
    return n


if __name__ == "__main__":
    print(f"Patched {patch()} admin sections")
