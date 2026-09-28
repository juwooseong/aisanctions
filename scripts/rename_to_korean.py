#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""BPMN 및 프로세스 정의서 파일명 한글화"""

import os
import re
import glob

ROOT = os.path.join(os.path.dirname(__file__), "..")
BPMN_DIR = os.path.join(ROOT, "docs", "bpmn")
PROCESS_DIR = os.path.join(ROOT, "docs", "process")

# (기존 BPMN 파일명, 한글 BPMN 파일명)
BPMN_RENAMES = {
    "SCR-LOGIN-login": "로그인",
    "SCR-MAIN-index": "메인프레임",
    "SCR-DASH-dashboard": "대시보드",
    "SCR-1010-revert-todo": "1010_본인작업_ToDoList",
    "SCR-1020-revert-status": "1020_진행업무별_현재상태",
    "SCR-1030-revert-ungenerated": "1030_업무미생성목록",
    "SCR-1011-revert-detail": "1011_심사상세",
    "SCR-1011-modi-blnum": "1011_BL번호수정",
    "SCR-2010-app-todo": "2010_결재자_ToDoList",
    "SCR-2010-app-bundle": "2010_일괄승인팝업",
    "SCR-2020-app-status": "2020_결재자_진행상태",
    "SCR-2011-app-detail-revert": "2011_결재자_심사상세",
    "SCR-3010-qa-todo": "3010_QA_ToDoList",
    "SCR-3020-qa-status": "3020_QA_진행상태",
    "SCR-3011-qa-detail": "3011_QA상세",
    "SCR-4010-revert-stat-all": "4010_업무생성목록",
    "SCR-4020-revert-stat-status": "4020_담당자별_진행현황",
    "SCR-4030-revert-stat-complete": "4030_심사완료명세",
    "SCR-4040-revert-stat-error": "4040_심사오류명세",
    "SCR-4050-revert-stat-alert": "4050_경보발생명세",
    "SCR-5010-task-log-end": "5010_업무마감",
    "SCR-5020-task-log-reg": "5020_업무일지_등록",
    "SCR-5030-task-log-inquiry": "5030_업무일지_조회",
    "SCR-5040-task-log-result": "5040_성과관리",
    "SCR-6010-stat-analysis": "6010_성능분석",
    "SCR-6020-stat-task": "6020_업무별_통계",
    "SCR-6030-stat-item": "6030_항목별_통계",
    "SCR-6040-stat-cond": "6040_조건별_통계",
    "SCR-6050-stat-user": "6050_고객별_통계",
    "SCR-7010-admin-user": "7010_사용자_관리",
    "SCR-7021-admin-log-login": "7021_로그인_이력관리",
    "SCR-7022-admin-log-program": "7022_프로그램_사용이력",
    "SCR-7030-admin-menu": "7030_권한별_메뉴관리",
    "SCR-7031-admin-menu-reg": "7031_메뉴등록",
    "SCR-7040-admin-watchlist": "7040_WatchList_등록",
    "SCR-7050-admin-sanction": "7050_제재Rule_등록",
    "SCR-7060-admin-qa-target": "7060_QA선정_관리",
    "SCR-7070-admin-absence": "7070_부재_관리",
    "SCR-7080-admin-retask": "7080_업무_재할당",
    "SCR-7090-admin-app-memo": "7090_일괄결재_의견관리",
    "SCR-8010-admin-nation": "8010_국가코드관리",
    "SCR-8020-admin-code": "8020_공통코드관리",
    "SCR-8030-admin-businessday": "8030_영업일_관리",
    "SCR-8040-admin-city": "8040_도시항구관리",
    "SCR-8050-admin-status": "8050_시스템심사진행현황",
    "SCR-8051-admin-reprocessing": "8051_재처리정보_등록",
    "SCR-8060-admin-word-correction": "8060_후보정용어관리",
    "SCR-9080-common-revert-history": "9080_심사이력",
    "SCR-9090-common-qa-history": "9090_QA이력",
    "SCR-9010-common-history-detail": "9010_심사상세_이력",
    "SCR-9020-common-qa-history-detail": "9020_QA상세_이력",
    "SCR-9999-common-manual": "9999_사용자매뉴얼",
}

PROCESS_RENAMES = {
    "README.md": "목차.md",
    "00-common-entry.md": "00_공통_진입화면.md",
    "01-revert.md": "01_심사.md",
    "02-app.md": "02_결재.md",
    "03-qa.md": "03_QA.md",
    "04-revert-stat.md": "04_심사현황명세.md",
    "05-task.md": "05_업무일지.md",
    "06-stat.md": "06_통계.md",
    "07-admin.md": "07_관리자.md",
    "08-common-popup.md": "08_공통팝업.md",
}


def rename_bpmn_files():
    for old_base, new_base in BPMN_RENAMES.items():
        old_path = os.path.join(BPMN_DIR, f"{old_base}.bpmn")
        new_path = os.path.join(BPMN_DIR, f"{new_base}.bpmn")
        if os.path.exists(old_path):
            if os.path.exists(new_path):
                os.remove(new_path)
            os.rename(old_path, new_path)
            print(f"BPMN: {old_base}.bpmn -> {new_base}.bpmn")


def rename_process_files():
    for old_name, new_name in PROCESS_RENAMES.items():
        old_path = os.path.join(PROCESS_DIR, old_name)
        new_path = os.path.join(PROCESS_DIR, new_name)
        if os.path.exists(old_path):
            if os.path.exists(new_path) and old_path != new_path:
                os.remove(new_path)
            os.rename(old_path, new_path)
            print(f"DOC: {old_name} -> {new_name}")


def update_markdown_links():
    for md_path in glob.glob(os.path.join(PROCESS_DIR, "*.md")):
        with open(md_path, "r", encoding="utf-8") as f:
            content = f.read()

        for old_base, new_base in BPMN_RENAMES.items():
            content = content.replace(f"{old_base}.bpmn", f"{new_base}.bpmn")

        for old_name, new_name in PROCESS_RENAMES.items():
            content = content.replace(f"](./{old_name})", f"](./{new_name})")
            content = content.replace(f"]({old_name})", f"]({new_name})")
            content = content.replace(f"](./{old_name}#", f"](./{new_name}#")
            content = content.replace(f"]({old_name}#", f"]({new_name}#")

        with open(md_path, "w", encoding="utf-8") as f:
            f.write(content)
        print(f"Updated links: {os.path.basename(md_path)}")


def update_generate_bpmn_script():
    script_path = os.path.join(os.path.dirname(__file__), "generate_bpmn.py")
    with open(script_path, "r", encoding="utf-8") as f:
        content = f.read()

    for old_base, new_base in BPMN_RENAMES.items():
        content = content.replace(f'"{old_base}"', f'"{new_base}"')

    with open(script_path, "w", encoding="utf-8") as f:
        f.write(content)
    print("Updated generate_bpmn.py")


def update_readme_naming_section():
    readme_path = os.path.join(PROCESS_DIR, "목차.md")
    if not os.path.exists(readme_path):
        return
    with open(readme_path, "r", encoding="utf-8") as f:
        content = f.read()

    content = content.replace(
        "BPMN 파일은 `docs/bpmn/` 디렉토리에 `SCR-{화면번호}-{도메인}-{화면명}.bpmn` 형식으로 저장됩니다.",
        "BPMN 파일은 `docs/bpmn/` 디렉토리에 `{화면번호}_{화면명}.bpmn` 또는 `{화면명}.bpmn` 한글 형식으로 저장됩니다.",
    )

    with open(readme_path, "w", encoding="utf-8") as f:
        f.write(content)


if __name__ == "__main__":
    rename_bpmn_files()
    rename_process_files()
    update_markdown_links()
    update_generate_bpmn_script()
    update_readme_naming_section()
    print("Done.")
