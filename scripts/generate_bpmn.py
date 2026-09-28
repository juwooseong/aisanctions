#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""화면별 BPMN 2.0 XML 생성 스크립트"""

import os
import xml.sax.saxutils as xml_escape

OUTPUT_DIR = os.path.join(os.path.dirname(__file__), "..", "docs", "bpmn")

SCREENS = [
    # (id, filename, name, steps[(type, id, name), ...])
    # type: start, task, gateway, end, subprocess
    ("LOGIN", "로그인", "로그인", [
        ("start", "Start", "시작"),
        ("task", "T1", "로그인 화면 표시"),
        ("gateway", "G1", "인증 방식"),
        ("task", "T2", "SSO 인증 처리"),
        ("task", "T3", "로컬 로그인 API 호출"),
        ("gateway", "G2", "인증 성공 여부"),
        ("task", "T4", "세션 생성 및 메뉴 권한 로드"),
        ("task", "T5", "에러 화면 표시"),
        ("end", "End", "메인 화면 이동"),
    ], [("Start", "T1"), ("T1", "G1"), ("G1", "T2", "SSO"), ("G1", "T3", "로컬"),
        ("T2", "G2"), ("T3", "G2"), ("G2", "T4", "성공"), ("G2", "T5", "실패"),
        ("T4", "End"), ("T5", "End")]),
    ("MAIN", "메인프레임", "메인 프레임", [
        ("start", "Start", "시작"),
        ("task", "T1", "메뉴 API 조회"),
        ("task", "T2", "GNB-LNB 렌더링"),
        ("task", "T3", "기본 탭 Dashboard 로드"),
        ("task", "T4", "탭-iframe 화면 전환"),
        ("end", "End", "종료"),
    ], [("Start", "T1"), ("T1", "T2"), ("T2", "T3"), ("T3", "T4"), ("T4", "End")]),
    ("DASH", "대시보드", "대시보드", [
        ("start", "Start", "시작"),
        ("task", "T1", "대시보드 API 호출"),
        ("task", "T2", "To-Do 차트 렌더링"),
        ("task", "T3", "진행상태 차트 렌더링"),
        ("task", "T4", "당일심사현황 차트 렌더링"),
        ("task", "T5", "국가별 수출입 지도 렌더링"),
        ("gateway", "G1", "새로고침 클릭"),
        ("end", "End", "종료"),
    ], [("Start", "T1"), ("T1", "T2"), ("T2", "T3"), ("T3", "T4"), ("T4", "T5"),
        ("T5", "G1"), ("G1", "T1", "예"), ("G1", "End", "아니오")]),
    ("1010", "1010_본인작업_ToDoList", "본인작업 ToDoList", [
        ("start", "Start", "시작"),
        ("task", "T1", "검색조건 초기화"),
        ("task", "T2", "ToDo 목록 API 조회"),
        ("task", "T3", "DataTable 목록 표시"),
        ("gateway", "G1", "행 클릭 유형"),
        ("task", "T4", "심사상세 팝업 오픈"),
        ("task", "T5", "심사이력 팝업 오픈"),
        ("end", "End", "종료"),
    ], [("Start", "T1"), ("T1", "T2"), ("T2", "T3"), ("T3", "G1"),
        ("G1", "T4", "프로세스-액티비티"), ("G1", "T5", "Ref.No 더블클릭"),
        ("G1", "T2", "재조회"), ("T4", "T2"), ("T5", "End"), ("T2", "End")]),
    ("1020", "1020_진행업무별_현재상태", "진행업무별 현재상태", [
        ("start", "Start", "시작"),
        ("task", "T1", "검색조건 설정"),
        ("task", "T2", "진행상태 API 조회"),
        ("task", "T3", "목록 표시"),
        ("gateway", "G1", "상세 이동"),
        ("task", "T4", "심사상세 팝업"),
        ("end", "End", "종료"),
    ], [("Start", "T1"), ("T1", "T2"), ("T2", "T3"), ("T3", "G1"),
        ("G1", "T4", "예"), ("G1", "T2", "재조회"), ("T4", "T2"), ("G1", "End", "아니오")]),
    ("1030", "1030_업무미생성목록", "업무미생성목록", [
        ("start", "Start", "시작"),
        ("task", "T1", "미생성 업무 API 조회"),
        ("task", "T2", "목록 표시"),
        ("gateway", "G1", "처리 선택"),
        ("task", "T3", "업무생성 확인 API"),
        ("task", "T4", "업무생성 취소 API"),
        ("end", "End", "종료"),
    ], [("Start", "T1"), ("T1", "T2"), ("T2", "G1"),
        ("G1", "T3", "확인"), ("G1", "T4", "취소"), ("T3", "T1"), ("T4", "T1"), ("G1", "End", "닫기")]),
    ("1011", "1011_심사상세", "심사상세", [
        ("start", "Start", "시작"),
        ("task", "T1", "접근권한 검증"),
        ("gateway", "G0", "권한 여부"),
        ("task", "T2", "상세 데이터 로드 API"),
        ("task", "T3", "문서이미지-TotalText-항목-SafeWatch 표시"),
        ("gateway", "G1", "사용자 액션"),
        ("task", "T4", "임시저장 inspection API"),
        ("task", "T5", "결재상신 santionSave API"),
        ("task", "T6", "재스캔-재추출 요청"),
        ("task", "T7", "B/L번호 수정"),
        ("end", "End", "종료"),
    ], [("Start", "T1"), ("T1", "G0"), ("G0", "T2", "허용"), ("G0", "End", "거부"),
        ("T2", "T3"), ("T3", "G1"), ("G1", "T4", "저장"), ("G1", "T5", "결재상신"),
        ("G1", "T6", "재처리"), ("G1", "T7", "B/L수정"), ("G1", "End", "닫기"),
        ("T4", "T2"), ("T5", "End"), ("T6", "T2"), ("T7", "T2")]),
    ("2010", "2010_결재자_ToDoList", "결재자 ToDoList", [
        ("start", "Start", "시작"),
        ("task", "T1", "결재 대상 API 조회"),
        ("task", "T2", "목록 표시"),
        ("gateway", "G1", "처리 유형"),
        ("task", "T3", "심사상세 팝업"),
        ("task", "T4", "일괄승인 팝업"),
        ("task", "T5", "일괄승인 API 처리"),
        ("end", "End", "종료"),
    ], [("Start", "T1"), ("T1", "T2"), ("T2", "G1"),
        ("G1", "T3", "건당결재"), ("G1", "T4", "일괄승인"), ("T4", "T5"),
        ("T3", "T1"), ("T5", "T1"), ("G1", "End", "닫기")]),
    ("2020", "2020_결재자_진행상태", "결재자 진행상태", [
        ("start", "Start", "시작"),
        ("task", "T1", "검색조건 설정"),
        ("task", "T2", "결재이력 API 조회"),
        ("task", "T3", "목록 표시"),
        ("gateway", "G1", "보류 처리"),
        ("task", "T4", "보류 API 호출"),
        ("end", "End", "종료"),
    ], [("Start", "T1"), ("T1", "T2"), ("T2", "T3"), ("T3", "G1"),
        ("G1", "T4", "보류"), ("G1", "T2", "재조회"), ("T4", "T2"), ("G1", "End", "닫기")]),
    ("2011", "2011_결재자_심사상세", "결재자 심사상세", [
        ("start", "Start", "시작"),
        ("task", "T1", "상세 로드"),
        ("task", "T2", "심사결과 검토"),
        ("gateway", "G1", "결재 처리"),
        ("task", "T3", "승인 santionApprv API"),
        ("task", "T4", "반려 cancelApprv API"),
        ("task", "T5", "Block 처리"),
        ("end", "End", "종료"),
    ], [("Start", "T1"), ("T1", "T2"), ("T2", "G1"),
        ("G1", "T3", "승인"), ("G1", "T4", "반려"), ("G1", "T5", "Block"),
        ("T3", "End"), ("T4", "End"), ("T5", "End")]),
    ("3010", "3010_QA_ToDoList", "QA ToDoList", [
        ("start", "Start", "시작"),
        ("task", "T1", "QA 대상 API 조회"),
        ("task", "T2", "목록 표시"),
        ("gateway", "G1", "행 선택"),
        ("task", "T3", "QA상세 팝업"),
        ("end", "End", "종료"),
    ], [("Start", "T1"), ("T1", "T2"), ("T2", "G1"),
        ("G1", "T3", "선택"), ("G1", "T1", "재조회"), ("T3", "T1"), ("G1", "End", "닫기")]),
    ("3020", "3020_QA_진행상태", "QA 진행상태", [
        ("start", "Start", "시작"),
        ("task", "T1", "검색조건 설정"),
        ("task", "T2", "QA 진행 API 조회"),
        ("task", "T3", "목록 표시"),
        ("gateway", "G1", "기준일 변경"),
        ("task", "T4", "dateSet API"),
        ("end", "End", "종료"),
    ], [("Start", "T1"), ("T1", "T2"), ("T2", "T3"), ("T3", "G1"),
        ("G1", "T4", "변경"), ("G1", "End", "닫기"), ("T4", "T2")]),
    ("3011", "3011_QA상세", "QA상세", [
        ("start", "Start", "시작"),
        ("task", "T1", "QA 상세 로드"),
        ("task", "T2", "자체점검 수행"),
        ("gateway", "G1", "처리"),
        ("task", "T3", "저장 inspection API"),
        ("task", "T4", "결재상신"),
        ("end", "End", "종료"),
    ], [("Start", "T1"), ("T1", "T2"), ("T2", "G1"),
        ("G1", "T3", "저장"), ("G1", "T4", "상신"), ("T3", "T1"), ("T4", "End"), ("G1", "End", "닫기")]),
    ("4010", "4010_업무생성목록", "업무생성목록", [
        ("start", "Start", "시작"),
        ("task", "T1", "검색조건 설정"),
        ("task", "T2", "업무생성목록 API 조회"),
        ("task", "T3", "목록 표시"),
        ("gateway", "G1", "엑셀 다운로드"),
        ("task", "T4", "XLS 다운로드"),
        ("end", "End", "종료"),
    ], [("Start", "T1"), ("T1", "T2"), ("T2", "T3"), ("T3", "G1"),
        ("G1", "T4", "예"), ("G1", "T2", "재조회"), ("T4", "End"), ("G1", "End", "아니오")]),
    ("4020", "4020_담당자별_진행현황", "담당자별 진행현황", [
        ("start", "Start", "시작"),
        ("task", "T1", "검색조건 설정"),
        ("task", "T2", "진행현황 API 조회"),
        ("task", "T3", "목록 표시"),
        ("gateway", "G1", "엑셀"),
        ("task", "T4", "XLS 다운로드"),
        ("end", "End", "종료"),
    ], [("Start", "T1"), ("T1", "T2"), ("T2", "T3"), ("T3", "G1"),
        ("G1", "T4", "예"), ("G1", "End", "아니오"), ("T4", "End")]),
    ("4030", "4030_심사완료명세", "심사완료명세", [
        ("start", "Start", "시작"),
        ("task", "T1", "검색조건 설정"),
        ("task", "T2", "완료명세 API 조회"),
        ("task", "T3", "목록 표시"),
        ("gateway", "G1", "추가 처리"),
        ("task", "T4", "결재취소 API"),
        ("task", "T5", "엑셀 다운로드"),
        ("end", "End", "종료"),
    ], [("Start", "T1"), ("T1", "T2"), ("T2", "T3"), ("T3", "G1"),
        ("G1", "T4", "결재취소"), ("G1", "T5", "엑셀"), ("T4", "T2"), ("T5", "End"), ("G1", "End", "닫기")]),
    ("4040", "4040_심사오류명세", "심사오류명세", [
        ("start", "Start", "시작"),
        ("task", "T1", "검색조건 설정"),
        ("task", "T2", "오류명세 API 조회"),
        ("task", "T3", "목록 표시"),
        ("task", "T4", "엑셀 다운로드"),
        ("end", "End", "종료"),
    ], [("Start", "T1"), ("T1", "T2"), ("T2", "T3"), ("T3", "T4"), ("T4", "End")]),
    ("4050", "4050_경보발생명세", "경보발생명세", [
        ("start", "Start", "시작"),
        ("task", "T1", "검색조건 설정"),
        ("task", "T2", "경보명세 API 조회"),
        ("task", "T3", "목록 표시"),
        ("task", "T4", "엑셀 다운로드"),
        ("end", "End", "종료"),
    ], [("Start", "T1"), ("T1", "T2"), ("T2", "T3"), ("T3", "T4"), ("T4", "End")]),
    ("5010", "5010_업무마감", "업무마감", [
        ("start", "Start", "시작"),
        ("task", "T1", "마감일 선택"),
        ("task", "T2", "마감정보 API 조회"),
        ("task", "T3", "마감 데이터 표시"),
        ("gateway", "G1", "저장"),
        ("task", "T4", "마감 저장 API"),
        ("end", "End", "종료"),
    ], [("Start", "T1"), ("T1", "T2"), ("T2", "T3"), ("T3", "G1"),
        ("G1", "T4", "저장"), ("G1", "T2", "일자변경"), ("T4", "T2"), ("G1", "End", "닫기")]),
    ("5020", "5020_업무일지_등록", "업무일지 등록", [
        ("start", "Start", "시작"),
        ("task", "T1", "기준일 선택"),
        ("task", "T2", "일지 데이터 API 조회"),
        ("task", "T3", "건수 수기입력"),
        ("gateway", "G1", "저장"),
        ("task", "T4", "등록 API 저장"),
        ("end", "End", "종료"),
    ], [("Start", "T1"), ("T1", "T2"), ("T2", "T3"), ("T3", "G1"),
        ("G1", "T4", "저장"), ("G1", "T2", "일자변경"), ("T4", "T2"), ("G1", "End", "닫기")]),
    ("5030", "5030_업무일지_조회", "업무일지 조회", [
        ("start", "Start", "시작"),
        ("task", "T1", "기간 검색조건 설정"),
        ("task", "T2", "일지 API 조회"),
        ("task", "T3", "목록-차트 표시"),
        ("task", "T4", "엑셀 다운로드"),
        ("end", "End", "종료"),
    ], [("Start", "T1"), ("T1", "T2"), ("T2", "T3"), ("T3", "T4"), ("T4", "End")]),
    ("5040", "5040_성과관리", "성과관리", [
        ("start", "Start", "시작"),
        ("task", "T1", "기간-직원 검색"),
        ("task", "T2", "성과 API 조회"),
        ("task", "T3", "처리건수 표시"),
        ("task", "T4", "엑셀 다운로드"),
        ("end", "End", "종료"),
    ], [("Start", "T1"), ("T1", "T2"), ("T2", "T3"), ("T3", "T4"), ("T4", "End")]),
    ("6010", "6010_성능분석", "성능분석", [
        ("start", "Start", "시작"),
        ("task", "T1", "기간 검색"),
        ("task", "T2", "성능분석 API 조회"),
        ("task", "T3", "일자별 차트 표시"),
        ("task", "T4", "엑셀 다운로드"),
        ("end", "End", "종료"),
    ], [("Start", "T1"), ("T1", "T2"), ("T2", "T3"), ("T3", "T4"), ("T4", "End")]),
    ("6020", "6020_업무별_통계", "업무별 통계", [
        ("start", "Start", "시작"),
        ("task", "T1", "기간-담당자 검색"),
        ("task", "T2", "업무별 통계 API"),
        ("task", "T3", "건수-시간 표시"),
        ("task", "T4", "엑셀 다운로드"),
        ("end", "End", "종료"),
    ], [("Start", "T1"), ("T1", "T2"), ("T2", "T3"), ("T3", "T4"), ("T4", "End")]),
    ("6030", "6030_항목별_통계", "항목별 통계", [
        ("start", "Start", "시작"),
        ("task", "T1", "기간-항목 검색"),
        ("task", "T2", "항목별 통계 API"),
        ("task", "T3", "그래프 표시"),
        ("task", "T4", "이동뷰 전환"),
        ("end", "End", "종료"),
    ], [("Start", "T1"), ("T1", "T2"), ("T2", "T3"), ("T3", "T4"), ("T4", "End")]),
    ("6040", "6040_조건별_통계", "조건별 통계", [
        ("start", "Start", "시작"),
        ("task", "T1", "조건 검색"),
        ("task", "T2", "조건별 API 조회"),
        ("task", "T3", "명세 표시"),
        ("task", "T4", "엑셀 다운로드"),
        ("end", "End", "종료"),
    ], [("Start", "T1"), ("T1", "T2"), ("T2", "T3"), ("T3", "T4"), ("T4", "End")]),
    ("6050", "6050_고객별_통계", "고객별 통계", [
        ("start", "Start", "시작"),
        ("task", "T1", "고객-기간 검색"),
        ("task", "T2", "차트 API 조회"),
        ("task", "T3", "거래현황 그래프"),
        ("task", "T4", "Pending-Block 목록"),
        ("end", "End", "종료"),
    ], [("Start", "T1"), ("T1", "T2"), ("T2", "T3"), ("T3", "T4"), ("T4", "End")]),
    ("7010", "7010_사용자_관리", "사용자 관리", [
        ("start", "Start", "시작"),
        ("task", "T1", "사용자 목록 API 조회"),
        ("gateway", "G1", "CRUD 선택"),
        ("task", "T2", "사용자 등록 API"),
        ("task", "T3", "사용자 수정 API"),
        ("task", "T4", "사용자 삭제 API"),
        ("end", "End", "종료"),
    ], [("Start", "T1"), ("T1", "G1"), ("G1", "T2", "등록"), ("G1", "T3", "수정"),
        ("G1", "T4", "삭제"), ("T2", "T1"), ("T3", "T1"), ("T4", "T1"), ("G1", "End", "닫기")]),
    ("7021", "7021_로그인_이력관리", "로그인 이력", [
        ("start", "Start", "시작"),
        ("task", "T1", "검색조건 설정"),
        ("task", "T2", "로그인 이력 API"),
        ("task", "T3", "목록 표시"),
        ("end", "End", "종료"),
    ], [("Start", "T1"), ("T1", "T2"), ("T2", "T3"), ("T3", "End")]),
    ("7022", "7022_프로그램_사용이력", "프로그램 사용 이력", [
        ("start", "Start", "시작"),
        ("task", "T1", "검색조건 설정"),
        ("task", "T2", "사용이력 API"),
        ("task", "T3", "목록 표시"),
        ("end", "End", "종료"),
    ], [("Start", "T1"), ("T1", "T2"), ("T2", "T3"), ("T3", "End")]),
    ("7030", "7030_권한별_메뉴관리", "권한별 메뉴 관리", [
        ("start", "Start", "시작"),
        ("task", "T1", "권한-메뉴 목록 조회"),
        ("task", "T2", "화면 권한 매핑"),
        ("task", "T3", "권한 저장 API"),
        ("end", "End", "종료"),
    ], [("Start", "T1"), ("T1", "T2"), ("T2", "T3"), ("T3", "T1"), ("T3", "End")]),
    ("7031", "7031_메뉴등록", "메뉴등록", [
        ("start", "Start", "시작"),
        ("task", "T1", "메뉴 목록 조회"),
        ("gateway", "G1", "처리"),
        ("task", "T2", "메뉴 등록 API"),
        ("task", "T3", "메뉴 수정 API"),
        ("task", "T4", "메뉴 삭제 API"),
        ("end", "End", "종료"),
    ], [("Start", "T1"), ("T1", "G1"), ("G1", "T2", "등록"), ("G1", "T3", "수정"),
        ("G1", "T4", "삭제"), ("T2", "T1"), ("T3", "T1"), ("T4", "T1"), ("G1", "End", "닫기")]),
    ("7040", "7040_WatchList_등록", "WatchList 관리", [
        ("start", "Start", "시작"),
        ("task", "T1", "카테고리 목록 조회"),
        ("task", "T2", "리스트-내용 조회"),
        ("gateway", "G1", "CRUD-업로드"),
        ("task", "T3", "카테고리-리스트-내용 저장"),
        ("task", "T4", "엑셀-JSON 업로드"),
        ("task", "T5", "엑셀 다운로드"),
        ("end", "End", "종료"),
    ], [("Start", "T1"), ("T1", "T2"), ("T2", "G1"),
        ("G1", "T3", "저장"), ("G1", "T4", "업로드"), ("G1", "T5", "다운로드"),
        ("T3", "T1"), ("T4", "T1"), ("T5", "End"), ("G1", "End", "닫기")]),
    ("7050", "7050_제재Rule_등록", "제재 Rule 등록", [
        ("start", "Start", "시작"),
        ("task", "T1", "Rule 목록 조회"),
        ("gateway", "G1", "Rule 유형"),
        ("task", "T2", "TotalText Rule 저장"),
        ("task", "T3", "항목심사 Rule 저장"),
        ("task", "T4", "Rule 적용 요청"),
        ("end", "End", "종료"),
    ], [("Start", "T1"), ("T1", "G1"), ("G1", "T2", "Rule1"),
        ("G1", "T3", "Rule2"), ("G1", "T4", "적용요청"),
        ("T2", "T1"), ("T3", "T1"), ("T4", "T1"), ("G1", "End", "닫기")]),
    ("7060", "7060_QA선정_관리", "QA선정 관리", [
        ("start", "Start", "시작"),
        ("task", "T1", "QA Rule 조회"),
        ("task", "T2", "Rule 수정"),
        ("task", "T3", "QA Rule 저장 API"),
        ("end", "End", "종료"),
    ], [("Start", "T1"), ("T1", "T2"), ("T2", "T3"), ("T3", "T1"), ("T3", "End")]),
    ("7070", "7070_부재_관리", "부재 관리", [
        ("start", "Start", "시작"),
        ("task", "T1", "부재 목록 API"),
        ("task", "T2", "부재정보 수정"),
        ("task", "T3", "부재 저장 API"),
        ("end", "End", "종료"),
    ], [("Start", "T1"), ("T1", "T2"), ("T2", "T3"), ("T3", "T1"), ("T3", "End")]),
    ("7080", "7080_업무_재할당", "업무 재할당", [
        ("start", "Start", "시작"),
        ("task", "T1", "사용자 목록 조회"),
        ("task", "T2", "배정 업무 조회"),
        ("gateway", "G1", "처리"),
        ("task", "T3", "재배정 API"),
        ("task", "T4", "QA-심사 업무 삭제"),
        ("end", "End", "종료"),
    ], [("Start", "T1"), ("T1", "T2"), ("T2", "G1"),
        ("G1", "T3", "재배정"), ("G1", "T4", "삭제"),
        ("T3", "T2"), ("T4", "T2"), ("G1", "End", "닫기")]),
    ("7090", "7090_일괄결재_의견관리", "일괄결재 의견", [
        ("start", "Start", "시작"),
        ("task", "T1", "의견 목록 API"),
        ("gateway", "G1", "CRUD"),
        ("task", "T2", "의견 저장"),
        ("task", "T3", "의견 삭제"),
        ("end", "End", "종료"),
    ], [("Start", "T1"), ("T1", "G1"), ("G1", "T2", "저장"),
        ("G1", "T3", "삭제"), ("T2", "T1"), ("T3", "T1"), ("G1", "End", "닫기")]),
    ("8010", "8010_국가코드관리", "국가코드관리", [
        ("start", "Start", "시작"),
        ("task", "T1", "국가코드 API 조회"),
        ("gateway", "G1", "CRUD"),
        ("task", "T2", "등록 API"),
        ("task", "T3", "삭제 API"),
        ("end", "End", "종료"),
    ], [("Start", "T1"), ("T1", "G1"), ("G1", "T2", "등록"),
        ("G1", "T3", "삭제"), ("T2", "T1"), ("T3", "T1"), ("G1", "End", "닫기")]),
    ("8020", "8020_공통코드관리", "공통코드관리", [
        ("start", "Start", "시작"),
        ("task", "T1", "그룹코드 API"),
        ("task", "T2", "상세코드 API"),
        ("gateway", "G1", "CRUD"),
        ("task", "T3", "그룹-코드 저장"),
        ("task", "T4", "그룹-코드 삭제"),
        ("end", "End", "종료"),
    ], [("Start", "T1"), ("T1", "T2"), ("T2", "G1"),
        ("G1", "T3", "저장"), ("G1", "T4", "삭제"),
        ("T3", "T1"), ("T4", "T1"), ("G1", "End", "닫기")]),
    ("8030", "8030_영업일_관리", "영업일 관리", [
        ("start", "Start", "시작"),
        ("task", "T1", "영업일 목록 API"),
        ("gateway", "G1", "처리"),
        ("task", "T2", "영업일 저장"),
        ("task", "T3", "영업일 삭제"),
        ("end", "End", "종료"),
    ], [("Start", "T1"), ("T1", "G1"), ("G1", "T2", "저장"),
        ("G1", "T3", "삭제"), ("T2", "T1"), ("T3", "T1"), ("G1", "End", "닫기")]),
    ("8040", "8040_도시항구관리", "도시항구관리", [
        ("start", "Start", "시작"),
        ("task", "T1", "도시항구 API"),
        ("gateway", "G1", "CRUD"),
        ("task", "T2", "등록 API"),
        ("task", "T3", "삭제 API"),
        ("end", "End", "종료"),
    ], [("Start", "T1"), ("T1", "G1"), ("G1", "T2", "등록"),
        ("G1", "T3", "삭제"), ("T2", "T1"), ("T3", "T1"), ("G1", "End", "닫기")]),
    ("8050", "8050_시스템심사진행현황", "시스템심사진행현황", [
        ("start", "Start", "시작"),
        ("task", "T1", "진행현황 API 조회"),
        ("gateway", "G1", "관리자 액션"),
        ("task", "T2", "심사 재처리 API"),
        ("task", "T3", "재추출 API"),
        ("task", "T4", "업무 삭제 API"),
        ("task", "T5", "액티비티 수정"),
        ("end", "End", "종료"),
    ], [("Start", "T1"), ("T1", "G1"), ("G1", "T2", "재처리"),
        ("G1", "T3", "재추출"), ("G1", "T4", "삭제"), ("G1", "T5", "액티비티"),
        ("T2", "T1"), ("T3", "T1"), ("T4", "T1"), ("T5", "T1"), ("G1", "End", "닫기")]),
    ("8051", "8051_재처리정보_등록", "재처리 정보 등록", [
        ("start", "Start", "시작"),
        ("task", "T1", "재처리 SQL 조회"),
        ("task", "T2", "SQL 등록-수정"),
        ("task", "T3", "확인 API 저장"),
        ("end", "End", "종료"),
    ], [("Start", "T1"), ("T1", "T2"), ("T2", "T3"), ("T3", "End")]),
    ("8060", "8060_후보정용어관리", "후보정용어관리", [
        ("start", "Start", "시작"),
        ("task", "T1", "용어 목록 API"),
        ("gateway", "G1", "CRUD"),
        ("task", "T2", "용어 저장"),
        ("task", "T3", "용어 삭제"),
        ("task", "T4", "엑셀 다운로드"),
        ("end", "End", "종료"),
    ], [("Start", "T1"), ("T1", "G1"), ("G1", "T2", "저장"),
        ("G1", "T3", "삭제"), ("G1", "T4", "엑셀"),
        ("T2", "T1"), ("T3", "T1"), ("T4", "End"), ("G1", "End", "닫기")]),
    ("9080", "9080_심사이력", "심사이력", [
        ("start", "Start", "시작"),
        ("task", "T1", "이력 API 조회"),
        ("task", "T2", "이력 목록 표시"),
        ("gateway", "G1", "첨부"),
        ("task", "T3", "파일 업로드"),
        ("task", "T4", "의견 수정"),
        ("end", "End", "종료"),
    ], [("Start", "T1"), ("T1", "T2"), ("T2", "G1"),
        ("G1", "T3", "업로드"), ("G1", "T4", "수정"),
        ("T3", "T1"), ("T4", "T1"), ("G1", "End", "닫기")]),
    ("9090", "9090_QA이력", "QA이력", [
        ("start", "Start", "시작"),
        ("task", "T1", "QA 이력 API"),
        ("task", "T2", "이력 표시"),
        ("gateway", "G1", "첨부"),
        ("task", "T3", "파일 업로드"),
        ("end", "End", "종료"),
    ], [("Start", "T1"), ("T1", "T2"), ("T2", "G1"),
        ("G1", "T3", "업로드"), ("G1", "End", "닫기"), ("T3", "T1")]),
    ("9010", "9010_심사상세_이력", "심사상세(이력)", [
        ("start", "Start", "시작"),
        ("task", "T1", "이력 기반 상세 로드"),
        ("task", "T2", "읽기전용 심사정보 표시"),
        ("end", "End", "종료"),
    ], [("Start", "T1"), ("T1", "T2"), ("T2", "End")]),
    ("9020", "9020_QA상세_이력", "QA상세(이력)", [
        ("start", "Start", "시작"),
        ("task", "T1", "이력 기반 QA 로드"),
        ("task", "T2", "읽기전용 QA 표시"),
        ("end", "End", "종료"),
    ], [("Start", "T1"), ("T1", "T2"), ("T2", "End")]),
    ("9999", "9999_사용자매뉴얼", "사용자매뉴얼", [
        ("start", "Start", "시작"),
        ("task", "T1", "매뉴얼 목록 API"),
        ("gateway", "G1", "액션"),
        ("task", "T2", "매뉴얼 다운로드"),
        ("task", "T3", "매뉴얼 업로드(관리자)"),
        ("end", "End", "종료"),
    ], [("Start", "T1"), ("T1", "G1"), ("G1", "T2", "다운로드"),
        ("G1", "T3", "업로드"), ("T2", "End"), ("T3", "T1"), ("G1", "End", "닫기")]),
    ("BUNDLE", "2010_일괄승인팝업", "일괄승인 팝업", [
        ("start", "Start", "시작"),
        ("task", "T1", "일괄대상 목록 로드"),
        ("task", "T2", "결재의견 입력"),
        ("gateway", "G1", "승인"),
        ("task", "T3", "일괄승인 API"),
        ("end", "End", "종료"),
    ], [("Start", "T1"), ("T1", "T2"), ("T2", "G1"),
        ("G1", "T3", "확인"), ("G1", "End", "취소"), ("T3", "End")]),
    ("BLMOD", "1011_BL번호수정", "B/L번호 수정", [
        ("start", "Start", "시작"),
        ("task", "T1", "B/L번호 입력"),
        ("gateway", "G1", "저장"),
        ("task", "T2", "ModiBlNum API"),
        ("end", "End", "종료"),
    ], [("Start", "T1"), ("T1", "G1"), ("G1", "T2", "저장"), ("G1", "End", "취소"), ("T2", "End")]),
]


def esc(text):
    return xml_escape.escape(str(text), {'"': '&quot;', "'": '&apos;'})


def node_size(etype):
    if etype == "start":
        return 36, 36
    if etype == "end":
        return 36, 36
    if etype == "gateway":
        return 50, 50
    return 120, 80


MARGIN_X = 80
MARGIN_Y = 80
COL_GAP = 200
ROW_GAP = 150
LOOP_OFFSET = 55


def anchor(bounds, side):
    x, y, w, h = bounds
    if side == "left":
        return (x, y + h // 2)
    if side == "right":
        return (x + w, y + h // 2)
    if side == "top":
        return (x + w // 2, y)
    if side == "bottom":
        return (x + w // 2, y + h)
    cx, cy = x + w // 2, y + h // 2
    return (cx, cy)


def build_graph(elements, flows):
    types = {eid: etype for etype, eid, _ in elements}
    outgoing = {eid: [] for _, eid, _ in elements}
    incoming = {eid: [] for _, eid, _ in elements}
    flow_list = []
    for idx, flow in enumerate(flows):
        src, tgt = flow[0], flow[1]
        label = flow[2] if len(flow) > 2 else ""
        outgoing[src].append((tgt, label, idx))
        incoming[tgt].append((src, label, idx))
        flow_list.append((src, tgt, label, idx))
    start = next(eid for etype, eid, _ in elements if etype == "start")
    end = next(eid for etype, eid, _ in elements if etype == "end")
    return types, outgoing, incoming, flow_list, start, end


def find_main_path(start, end, outgoing):
    """레이아웃용 주 경로: 종료까지 최장 단순 경로 (노드 15개 이하)."""
    best = [start]

    def dfs(node, path):
        nonlocal best
        if node == end:
            if len(path) > len(best):
                best = path[:]
            return
        if len(path) >= 15:
            return
        for tgt, _, _ in outgoing.get(node, []):
            if tgt not in path:
                dfs(tgt, path + [tgt])

    dfs(start, [start])
    if end not in best:
        best.append(end)
    return best


def compute_layout(elements, flows):
    types, outgoing, incoming, _, start, end = build_graph(elements, flows)
    main_path = find_main_path(start, end, outgoing)
    main_set = set(main_path)

    col = {}
    row = {}

    # 주 경로: 가로 일렬 (row=0)
    for i, nid in enumerate(main_path):
        col[nid] = i
        row[nid] = 0

    # 게이트웨이 분기 노드: 주 경로 아래 행에 배치
    for nid in main_path:
        if types.get(nid) != "gateway":
            continue
        g_col = col[nid]
        branch_idx = 1
        for tgt, _, _ in outgoing.get(nid, []):
            if tgt in main_set and col.get(tgt, 0) < g_col:
                continue
            if tgt not in col:
                col[tgt] = g_col + 1
                row[tgt] = branch_idx
                branch_idx += 1
            elif tgt not in main_set:
                if row.get(tgt, 0) == 0:
                    row[tgt] = branch_idx
                    branch_idx += 1

    # 미배치 노드
    next_col = max(col.values()) + 1 if col else 0
    for _, eid, _ in elements:
        if eid not in col:
            col[eid] = next_col
            row[eid] = 1
            next_col += 1

    # 동일 (col, row) 겹침 방지
    occupied = set()
    for eid in sorted(types.keys(), key=lambda n: (col.get(n, 0), row.get(n, 0))):
        c, r = col.get(eid, 0), row.get(eid, 0)
        while (c, r) in occupied:
            r += 1
        row[eid] = r
        occupied.add((c, r))

    positions = {}
    for eid, etype in ((e, types[e]) for e in types):
        w, h = node_size(etype)
        x = MARGIN_X + col.get(eid, 0) * COL_GAP
        y = MARGIN_Y + row.get(eid, 0) * ROW_GAP
        positions[eid] = (x, y, w, h)

    return positions, types


def route_edge(src_bounds, tgt_bounds, flow_idx=0, is_back=False):
    sx, sy, sw, sh = src_bounds
    tx, ty, tw, th = tgt_bounds
    src_cx = sx + sw // 2
    tgt_cx = tx + tw // 2
    src_cy = sy + sh // 2
    tgt_cy = ty + th // 2
    dx = tgt_cx - src_cx
    dy = tgt_cy - src_cy

    # 역방향(루프): 하단 우회
    if is_back or dx < -30:
        p_out = anchor(src_bounds, "bottom")
        p_in = anchor(tgt_bounds, "left")
        base_y = max(sy + sh, ty + th) + LOOP_OFFSET + flow_idx * 28
        return [
            p_out,
            (p_out[0], base_y),
            (p_in[0], base_y),
            p_in,
        ]

    # 장거리 수평 건너뛰기는 호출측에서 열 간격 기준으로 판단
    if abs(dy) < 25 and dx > 10:
        return [anchor(src_bounds, "right"), anchor(tgt_bounds, "left")]

    # 하향 분기: 하단 -> 상단
    if dy > 20:
        p_out = anchor(src_bounds, "bottom")
        p_in = anchor(tgt_bounds, "top")
        if abs(p_out[0] - p_in[0]) < 8:
            return [p_out, p_in]
        mid_y = (p_out[1] + p_in[1]) // 2
        return [p_out, (p_out[0], mid_y), (p_in[0], mid_y), p_in]

    # 상향 연결
    if dy < -20:
        p_out = anchor(src_bounds, "top")
        p_in = anchor(tgt_bounds, "bottom")
        mid_y = (p_out[1] + p_in[1]) // 2
        return [p_out, (p_out[0], mid_y), (p_in[0], mid_y), p_in]

    # 대각/혼합: 우측 -> 중간 -> 좌측
    p_out = anchor(src_bounds, "right")
    p_in = anchor(tgt_bounds, "left")
    mid_x = (p_out[0] + p_in[0]) // 2
    return [p_out, (mid_x, p_out[1]), (mid_x, p_in[1]), p_in]


def is_backward_edge(src, tgt, positions):
    sx, _, sw, _ = positions[src]
    tx, _, _, _ = positions[tgt]
    return tx < sx + sw // 2


def generate_bpmn(screen_id, filename, name, elements, flows):
    process_id = f"Process_{screen_id}"
    lines = [
        '<?xml version="1.0" encoding="UTF-8"?>',
        '<bpmn:definitions xmlns:bpmn="http://www.omg.org/spec/BPMN/20100524/MODEL"',
        '  xmlns:bpmndi="http://www.omg.org/spec/BPMN/20100524/DI"',
        '  xmlns:dc="http://www.omg.org/spec/DD/20100524/DC"',
        '  xmlns:di="http://www.omg.org/spec/DD/20100524/DI"',
        f'  id="Definitions_{screen_id}"',
        '  targetNamespace="http://woori.ajs/process">',
        f'  <bpmn:process id="{process_id}" name="{esc(name)}" isExecutable="false">',
    ]

    flow_ids = []
    for idx, flow in enumerate(flows):
        src, tgt = flow[0], flow[1]
        label = flow[2] if len(flow) > 2 else ""
        fid = f"Flow_{idx+1}_{src}_{tgt}"
        flow_ids.append((fid, src, tgt, label))
        if label:
            lines.append(
                f'    <bpmn:sequenceFlow id="{fid}" sourceRef="{src}" targetRef="{tgt}" name="{esc(label)}"/>'
            )
        else:
            lines.append(
                f'    <bpmn:sequenceFlow id="{fid}" sourceRef="{src}" targetRef="{tgt}"/>'
            )

    for etype, eid, ename in elements:
        if etype == "start":
            lines.append(f'    <bpmn:startEvent id="{eid}" name="{esc(ename)}">')
            out = [f for f in flow_ids if f[1] == eid]
            if out:
                lines.append(f'      <bpmn:outgoing>{out[0][0]}</bpmn:outgoing>')
            lines.append('    </bpmn:startEvent>')
        elif etype == "end":
            inc = [f for f in flow_ids if f[2] == eid]
            lines.append(f'    <bpmn:endEvent id="{eid}" name="{esc(ename)}">')
            for f in inc:
                lines.append(f'      <bpmn:incoming>{f[0]}</bpmn:incoming>')
            lines.append('    </bpmn:endEvent>')
        elif etype == "gateway":
            inc = [f for f in flow_ids if f[2] == eid]
            out = [f for f in flow_ids if f[1] == eid]
            lines.append(f'    <bpmn:exclusiveGateway id="{eid}" name="{esc(ename)}">')
            for f in inc:
                lines.append(f'      <bpmn:incoming>{f[0]}</bpmn:incoming>')
            for f in out:
                lines.append(f'      <bpmn:outgoing>{f[0]}</bpmn:outgoing>')
            lines.append('    </bpmn:exclusiveGateway>')
        else:
            inc = [f for f in flow_ids if f[2] == eid]
            out = [f for f in flow_ids if f[1] == eid]
            lines.append(f'    <bpmn:task id="{eid}" name="{esc(ename)}">')
            for f in inc:
                lines.append(f'      <bpmn:incoming>{f[0]}</bpmn:incoming>')
            for f in out:
                lines.append(f'      <bpmn:outgoing>{f[0]}</bpmn:outgoing>')
            lines.append('    </bpmn:task>')

    lines.append('  </bpmn:process>')
    lines.append(f'  <bpmndi:BPMNDiagram id="BPMNDiagram_{screen_id}">')
    lines.append(f'    <bpmndi:BPMNPlane id="BPMNPlane_{screen_id}" bpmnElement="{process_id}">')

    positions, types = compute_layout(elements, flows)

    for etype, eid, ename in elements:
        x, y, w, h = positions[eid]
        marker = ' isMarkerVisible="true"' if etype == "gateway" else ""
        lines.append(
            f'      <bpmndi:BPMNShape id="Shape_{eid}" bpmnElement="{eid}"{marker}>'
            f'<dc:Bounds x="{x}" y="{y}" width="{w}" height="{h}"/></bpmndi:BPMNShape>'
        )

    route_lane = 0
    for fid, src, tgt, _ in flow_ids:
        src_bounds = positions[src]
        tgt_bounds = positions[tgt]
        is_back = is_backward_edge(src, tgt, positions)
        sx, sy, sw, sh = src_bounds
        tx, ty, tw, th = tgt_bounds
        src_col = round((sx - MARGIN_X) / COL_GAP)
        tgt_col = round((tx - MARGIN_X) / COL_GAP)
        same_row = abs(sy - ty) < 30
        long_skip = (tgt_col - src_col > 1) and same_row and not is_back

        if is_back or long_skip:
            waypoints = route_edge(src_bounds, tgt_bounds, route_lane, is_back=True)
            route_lane += 1
        else:
            waypoints = route_edge(src_bounds, tgt_bounds)
        lines.append(f'      <bpmndi:BPMNEdge id="Edge_{fid}" bpmnElement="{fid}">')
        for wx, wy in waypoints:
            lines.append(f'        <di:waypoint x="{wx}" y="{wy}"/>')
        lines.append('      </bpmndi:BPMNEdge>')

    lines.append('    </bpmndi:BPMNPlane>')
    lines.append('  </bpmndi:BPMNDiagram>')
    lines.append('</bpmn:definitions>')
    return "\n".join(lines) + "\n"


def main():
    os.makedirs(OUTPUT_DIR, exist_ok=True)
    count = 0
    for item in SCREENS:
        screen_id, filename, name, elements, flows = item
        content = generate_bpmn(screen_id, filename, name, elements, flows)
        path = os.path.join(OUTPUT_DIR, f"{filename}.bpmn")
        with open(path, "w", encoding="utf-8") as f:
            f.write(content)
        count += 1
        print(f"Generated: {path}")
    print(f"Total: {count} BPMN files")


if __name__ == "__main__":
    main()
