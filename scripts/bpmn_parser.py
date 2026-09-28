# -*- coding: utf-8 -*-
"""BPMN 2.0 XML 파싱 — 요소·시퀀스 흐름 추출."""
from __future__ import annotations

import re
import xml.etree.ElementTree as ET
from pathlib import Path
from typing import Any

NS = {
    "bpmn": "http://www.omg.org/spec/BPMN/20100524/MODEL",
}

TYPE_MAP = {
    "startEvent": "시작",
    "endEvent": "종료",
    "task": "업무",
    "exclusiveGateway": "분기",
    "parallelGateway": "병렬",
    "subProcess": "하위프로세스",
    "intermediateCatchEvent": "중간",
}


def _local(tag: str) -> str:
    return tag.split("}")[-1] if "}" in tag else tag


def parse_bpmn_file(path: Path) -> dict[str, Any]:
    """BPMN 파일을 파싱해 프로세스 메타·요소·흐름을 반환."""
    empty: dict[str, Any] = {
        "file": str(path),
        "process_id": "",
        "process_name": "",
        "elements": [],
        "flows": [],
    }
    if not path.exists():
        return empty

    root = ET.parse(path).getroot()
    proc = root.find(".//bpmn:process", NS)
    if proc is None:
        proc = root.find(".//{http://www.omg.org/spec/BPMN/20100524/MODEL}process")
    if proc is None:
        return empty

    process_id = proc.get("id", "")
    process_name = proc.get("name", "")

    elements: list[tuple[str, str, str, str]] = []
    for child in proc:
        tag = _local(child.tag)
        if tag == "sequenceFlow":
            continue
        eid = child.get("id", "")
        name = child.get("name", eid)
        etype = TYPE_MAP.get(tag, tag)
        elements.append((eid, etype, name, tag))

    flows: list[tuple[str, str, str, str, str]] = []
    for child in proc:
        if _local(child.tag) != "sequenceFlow":
            continue
        fid = child.get("id", "")
        src = child.get("sourceRef", "")
        tgt = child.get("targetRef", "")
        label = child.get("name", "")
        flows.append((fid, src, tgt, label, _resolve_names(src, tgt, elements)))

    return {
        "file": path.name,
        "path": str(path),
        "process_id": process_id,
        "process_name": process_name,
        "elements": elements,
        "flows": flows,
    }


def _resolve_names(src: str, tgt: str, elements: list[tuple]) -> str:
    name_by_id = {e[0]: e[2] for e in elements}
    s = name_by_id.get(src, src)
    t = name_by_id.get(tgt, tgt)
    return f"{s} → {t}"


def bpmn_from_script(screen_id: str) -> dict[str, Any] | None:
    """generate_bpmn.SCREENS 에서 인메모리 BPMN 정의 조회."""
    import generate_bpmn as gb

    alias = DETAIL_ID_ALIAS.get(screen_id, screen_id)
    for entry in gb.SCREENS:
        if entry[0] == alias:
            sid, filename, name, elements, flows = entry
            elem_rows = []
            for etype, eid, ename in elements:
                bpmn_type = {
                    "start": "startEvent",
                    "end": "endEvent",
                    "task": "task",
                    "gateway": "exclusiveGateway",
                }.get(etype, etype)
                elem_rows.append((eid, TYPE_MAP.get(bpmn_type, etype), ename, bpmn_type))
            flow_rows = []
            for i, flow in enumerate(flows):
                src, tgt = flow[0], flow[1]
                label = flow[2] if len(flow) > 2 else ""
                fid = f"Flow_{i + 1}_{src}_{tgt}"
                flow_rows.append((fid, src, tgt, label, _resolve_names(src, tgt, elem_rows)))
            return {
                "file": f"{filename}.bpmn",
                "path": f"docs/bpmn/{filename}.bpmn",
                "process_id": f"Process_{sid}",
                "process_name": name,
                "elements": elem_rows,
                "flows": flow_rows,
            }
    return None


DETAIL_ID_ALIAS: dict[str, str] = {
    "1011-BL": "BLMOD",
    "2011-QA": "2011QA",
    "7050-RULE": "7050",
    "DASH-v2": "DASH",
}


def resolve_bpmn(screen_id: str, bpmn_field: str, root: Path) -> dict[str, Any]:
    """화면ID·BPMN 필드명으로 파싱 데이터 반환 (XML 우선, 스크립트 폴백)."""
    bpmn_dir = root / "docs" / "bpmn"
    candidates: list[Path] = []

    if bpmn_field and bpmn_field not in ("—", ""):
        raw = bpmn_field.replace("*.bpmn", "").strip()
        if raw.endswith(".bpmn"):
            candidates.append(bpmn_dir / raw)
        else:
            candidates.append(bpmn_dir / f"{raw}.bpmn")

    alias = DETAIL_ID_ALIAS.get(screen_id, screen_id)

    import generate_bpmn as gb

    for entry in gb.SCREENS:
        if entry[0] in (screen_id, alias):
            candidates.append(bpmn_dir / f"{entry[1]}.bpmn")
            break

    for path in candidates:
        if path.exists():
            return parse_bpmn_file(path)

    script_data = bpmn_from_script(screen_id)
    if script_data:
        return script_data

    return {
        "file": bpmn_field or "—",
        "path": "—",
        "process_id": "",
        "process_name": "",
        "elements": [],
        "flows": [],
    }
