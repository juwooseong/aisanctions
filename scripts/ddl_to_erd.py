#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Parse sql/01_ddl.sql and generate ERD Editor (v3) files."""
import argparse
import json
import re
import time
import uuid
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
DDL = ROOT / "sql" / "01_ddl.sql"
DEFAULT_OUT = ROOT / "sql" / "sanction.erd"

# 논리 관계 (DDL에 FK 미정의, 매퍼 조인 기준)
LOGICAL_RELATIONSHIPS = [
    ("CSPD001TM", ["INPT_MST_SRNO"], "CSPD002TG", ["INPT_MST_SRNO"]),
    ("CSPD001TM", ["INPT_MST_SRNO"], "CSPD003TF", ["INPT_MST_SRNO"]),
    ("CSPD001TM", ["INPT_MST_SRNO"], "CSPD004TF", ["INPT_MST_SRNO"]),
    ("CSPD001TM", ["INPT_MST_SRNO"], "CSPD005TH", ["INPT_MST_SRNO"]),
    ("CSPD001TM", ["INPT_MST_SRNO"], "CSPD006TL", ["INPT_MST_SRNO"]),
    ("CSPD001TM", ["INPT_MST_SRNO"], "CSPD007TL", ["INPT_MST_SRNO"]),
    ("CSPD001TM", ["INPT_MST_SRNO"], "CSPD008TH", ["INPT_MST_SRNO"]),
    ("CSPD001TM", ["INPT_MST_SRNO"], "CSPD900TI", ["INPT_MST_SRNO"]),
    ("CSPD108TI", ["AI_INPT_MENU_ID"], "CSPD109TI", ["AI_INPT_MENU_ID"]),
    ("CSPD111TI", ["AI_INPT_GRP_CD"], "CSPD112TI", ["AI_INPT_GRP_CD"]),
    ("CSPD103TI", ["AI_INPT_LIST_ID"], "CSPD107TI", ["AI_INPT_LIST_ID"]),
    ("CSPD101TI", ["AI_INPT_USER_ID"], "CSPD810TH", ["AI_INPT_USER_ID"]),
    ("CSPD101TI", ["AI_INPT_USER_ID"], "CSPD811TH", ["AI_INPT_USER_ID"]),
]

# 도메인별 배치 (테이블 ui.color만 사용 — ERD Editor 그룹/메모 기능 아님)
LAYOUT_DEFAULT = [
    {
        "name": "심사 처리",
        "color": "#90CAF9",
        "tables": [
            "CSPD001TM", "CSPD900TI", "CSPD002TG", "CSPD003TF", "CSPD004TF",
            "CSPD005TH", "CSPD006TL", "CSPD007TL", "CSPD008TH",
        ],
        "origin": (80, 80),
        "cols": 5,
        "dx": 360,
        "row_h": 320,
    },
    {
        "name": "업무일지·통계",
        "color": "#CE93D8",
        "tables": ["CSPD009TA", "CSPD010TA", "CSPD011TL"],
        "origin": (80, 1200),
        "cols": 3,
        "dx": 380,
        "row_h": 320,
    },
    {
        "name": "기준정보",
        "color": "#A5D6A7",
        "tables": [
            "CSPD101TI", "CSPD102TI", "CSPD103TI", "CSPD104TI", "CSPD105TI",
            "CSPD106TI", "CSPD107TI", "CSPD111TI", "CSPD112TI", "CSPD113TI",
            "CSPD115TI", "CSPD116TI", "CSPD117TI", "CSPD118TI", "CSPD118TM",
        ],
        "origin": (2000, 80),
        "cols": 3,
        "dx": 380,
        "row_h": 320,
    },
    {
        "name": "메뉴·권한",
        "color": "#FFCC80",
        "tables": ["CSPD108TI", "CSPD109TI", "CSPD110TI"],
        "origin": (80, 1680),
        "cols": 3,
        "dx": 380,
        "row_h": 320,
    },
    {
        "name": "로그",
        "color": "#B0BEC5",
        "tables": ["CSPD810TH", "CSPD811TH"],
        "origin": (2000, 1680),
        "cols": 2,
        "dx": 400,
        "row_h": 320,
    },
    {
        "name": "외환 원장",
        "color": "#FFF176",
        "tables": ["CSPD201TM", "CSPD202TM"],
        "origin": (3200, 80),
        "cols": 1,
        "dx": 400,
        "row_h": 320,
    },
]

# 도메인 정의 (배치 순서·색상만 지정, 위치/열 수는 자동 계산)
DOMAIN_ZONE_CONFIG = [
    {
        "name": "심사 처리",
        "color": "#90CAF9",
        "tables": [
            "CSPD001TM", "CSPD004TF", "CSPD005TH", "CSPD008TH",
            "CSPD900TI", "CSPD002TG", "CSPD003TF", "CSPD006TL", "CSPD007TL",
        ],
    },
    {
        "name": "기준정보",
        "color": "#A5D6A7",
        "tables": [
            "CSPD101TI", "CSPD106TI", "CSPD103TI", "CSPD107TI", "CSPD104TI",
            "CSPD112TI", "CSPD102TI", "CSPD105TI", "CSPD115TI", "CSPD111TI",
            "CSPD117TI", "CSPD118TI", "CSPD118TM", "CSPD116TI", "CSPD113TI",
        ],
    },
    {
        "name": "메뉴·권한",
        "color": "#FFCC80",
        "tables": ["CSPD108TI", "CSPD109TI", "CSPD110TI"],
    },
    {
        "name": "업무일지·통계",
        "color": "#CE93D8",
        "tables": ["CSPD009TA", "CSPD010TA", "CSPD011TL"],
    },
    {
        "name": "외환 원장",
        "color": "#FFF176",
        "tables": ["CSPD201TM", "CSPD202TM"],
    },
    {
        "name": "로그",
        "color": "#B0BEC5",
        "tables": ["CSPD810TH", "CSPD811TH"],
    },
]

TABLE_WIDTH = 360
GAP_X = 200
GAP_Y = 160
BLOCK_GAP_X = 320
BLOCK_GAP_Y = 260
CANVAS_MARGIN = 120
CANVAS_WIDTH = 5000
MAX_ROW_WIDTH = CANVAS_WIDTH - CANVAS_MARGIN * 2
HEADER_H = 72
COL_LINE_H = 28

LAYOUT_PROFILES = {
    "default": LAYOUT_DEFAULT,
    "domain": DOMAIN_ZONE_CONFIG,
}

DIR_LEFT = 1
DIR_RIGHT = 2
DIR_TOP = 4
DIR_BOTTOM = 8
REL_STAGGER_STEP = 32
ROUTE_CLEARANCE = 140
ROUTE_LANE_STEP = 110
NOW = int(time.time() * 1000)

VALID_DIR_PAIRS = [
    (DIR_RIGHT, DIR_LEFT),
    (DIR_LEFT, DIR_RIGHT),
    (DIR_BOTTOM, DIR_TOP),
    (DIR_TOP, DIR_BOTTOM),
    (DIR_RIGHT, DIR_TOP),
    (DIR_RIGHT, DIR_BOTTOM),
    (DIR_LEFT, DIR_TOP),
    (DIR_LEFT, DIR_BOTTOM),
    (DIR_BOTTOM, DIR_LEFT),
    (DIR_BOTTOM, DIR_RIGHT),
    (DIR_TOP, DIR_LEFT),
    (DIR_TOP, DIR_RIGHT),
]


def table_height(tname: str, all_tables: dict) -> int:
    return estimate_table_height(len(all_tables[tname]))


def column_center_y(tname: str, col_name: str, all_tables: dict, ty: float) -> float:
    col_names = [c["name"] for c in all_tables[tname]]
    idx = col_names.index(col_name) if col_name in col_names else 0
    return ty + HEADER_H + idx * COL_LINE_H + COL_LINE_H / 2


def stagger_offset(index: int, total: int, step: int = REL_STAGGER_STEP) -> float:
    if total <= 1:
        return 0
    return (index - (total - 1) / 2) * step


def clamp(value: float, low: float, high: float) -> float:
    return max(low, min(high, value))


def anchor_on_edge(tx, ty, tw, th, direction: int, along: float):
    margin = 24
    if direction == DIR_RIGHT:
        return tx + tw, clamp(along, ty + margin, ty + th - margin)
    if direction == DIR_LEFT:
        return tx, clamp(along, ty + margin, ty + th - margin)
    if direction == DIR_BOTTOM:
        return clamp(along, tx + margin, tx + tw - margin), ty + th
    return clamp(along, tx + margin, tx + tw - margin), ty


def table_bounds(tname: str, positions: dict, all_tables: dict):
    x, y = positions[tname]
    return (x, y, x + TABLE_WIDTH, y + table_height(tname, all_tables))


def get_route_obstacles(positions: dict, all_tables: dict, exclude: set):
    return {
        t: table_bounds(t, positions, all_tables)
        for t in positions
        if t not in exclude
    }


def h_intersects_rect(xa, xb, y, rect):
    x1, x2 = min(xa, xb), max(xa, xb)
    rx1, ry1, rx2, ry2 = rect
    return not (y < ry1 or y > ry2) and not (x2 < rx1 or x1 > rx2)


def v_intersects_rect(ya, yb, x, rect):
    y1, y2 = min(ya, yb), max(ya, yb)
    rx1, ry1, rx2, ry2 = rect
    return not (x < rx1 or x > rx2) and not (y2 < ry1 or y1 > ry2)


def segments_cross_tables(segments, obstacles: dict) -> int:
    hits = 0
    for x1, y1, x2, y2 in segments:
        for rect in obstacles.values():
            if x1 == x2:
                if v_intersects_rect(y1, y2, x1, rect):
                    hits += 1
            elif y1 == y2:
                if h_intersects_rect(x1, x2, y1, rect):
                    hits += 1
    return hits


def path_length(segments) -> float:
    return sum(abs(x2 - x1) + abs(y2 - y1) for x1, y1, x2, y2 in segments)


def find_clear_horizontal_lane(x_lo, x_hi, obstacles: dict, near_y: float) -> float:
    x1, x2 = min(x_lo, x_hi), max(x_lo, x_hi)
    for delta in [
        0, 80, 160, 240, 320, 400, 520, 640, -80, -160, -240, -320,
        800, -520, 1000, -800, 1400, -1200, 1800, -1600,
    ]:
        y = near_y + delta
        if y < 40:
            continue
        if not any(h_intersects_rect(x1, x2, y, rect) for rect in obstacles.values()):
            return y
    for y in range(40, 5000, 30):
        if not any(h_intersects_rect(x1, x2, y, rect) for rect in obstacles.values()):
            return y
    return near_y


def find_clear_vertical_lane(y_lo, y_hi, obstacles: dict, near_x: float) -> float:
    y1, y2 = min(y_lo, y_hi), max(y_lo, y_hi)
    for delta in [
        0, 80, 160, 240, 320, 400, 520, 640, -80, -160, -240, -320,
        800, -520, 1000, -800, 1400, -1200, 1800, -1600,
    ]:
        x = near_x + delta
        if x < 40:
            continue
        if not any(v_intersects_rect(y1, y2, x, rect) for rect in obstacles.values()):
            return x
    for x in range(40, 5000, 30):
        if not any(v_intersects_rect(y1, y2, x, rect) for rect in obstacles.values()):
            return x
    return near_x


def build_path_segments(
    sx, sy, ex, ey, start_dir: int, end_dir: int, detour: float, obstacles: dict
):
    d = detour
    if start_dir == DIR_RIGHT:
        ox = max(sx, ex) + ROUTE_CLEARANCE + d
        lane_y = find_clear_horizontal_lane(sx, ox, obstacles, sy)
        if end_dir == DIR_LEFT:
            return [
                (sx, sy, sx, lane_y), (sx, lane_y, ox, lane_y),
                (ox, lane_y, ex, lane_y), (ex, lane_y, ex, ey),
            ]
        if end_dir == DIR_TOP:
            return [
                (sx, sy, sx, lane_y), (sx, lane_y, ox, lane_y),
                (ox, lane_y, ox, ey), (ox, ey, ex, ey),
            ]
        if end_dir == DIR_BOTTOM:
            return [
                (sx, sy, sx, lane_y), (sx, lane_y, ox, lane_y),
                (ox, lane_y, ox, ey), (ox, ey, ex, ey),
            ]
        return [(sx, sy, ox, sy), (ox, sy, ox, ey), (ox, ey, ex, ey)]

    if start_dir == DIR_LEFT:
        ox = min(sx, ex) - ROUTE_CLEARANCE - d
        lane_y = find_clear_horizontal_lane(ox, sx, obstacles, sy)
        if end_dir == DIR_RIGHT:
            return [
                (sx, sy, sx, lane_y), (sx, lane_y, ox, lane_y),
                (ox, lane_y, ex, lane_y), (ex, lane_y, ex, ey),
            ]
        return [
            (sx, sy, sx, lane_y), (sx, lane_y, ox, lane_y),
            (ox, lane_y, ox, ey), (ox, ey, ex, ey),
        ]

    if start_dir == DIR_BOTTOM:
        oy = max(sy, ey) + ROUTE_CLEARANCE + d
        lane_x = find_clear_vertical_lane(sy, oy, obstacles, sx)
        if end_dir == DIR_TOP:
            return [
                (sx, sy, lane_x, sy), (lane_x, sy, lane_x, oy),
                (lane_x, oy, ex, oy), (ex, oy, ex, ey),
            ]
        return [
            (sx, sy, lane_x, sy), (lane_x, sy, lane_x, oy),
            (lane_x, oy, ex, oy), (ex, oy, ex, ey),
        ]

    oy = min(sy, ey) - ROUTE_CLEARANCE - d
    lane_x = find_clear_vertical_lane(oy, sy, obstacles, sx)
    return [
        (sx, sy, lane_x, sy), (lane_x, sy, lane_x, oy),
        (lane_x, oy, ex, oy), (ex, oy, ex, ey),
    ]


def build_relationship_points(
    parent: str,
    child: str,
    pcols: list,
    ccols: list,
    positions: dict,
    all_tables: dict,
    parent_idx: int,
    parent_total: int,
    child_idx: int,
    child_total: int,
):
    px, py = positions[parent]
    cx, cy = positions[child]
    pw, ph = TABLE_WIDTH, table_height(parent, all_tables)
    cw, ch = TABLE_WIDTH, table_height(child, all_tables)
    obstacles = get_route_obstacles(positions, all_tables, {parent, child})

    p_stagger = stagger_offset(parent_idx, parent_total)
    c_stagger = stagger_offset(child_idx, child_total)
    lane = stagger_offset(parent_idx, parent_total, ROUTE_LANE_STEP)

    detours = [lane, -lane, 0, 120, 240, 360, 480, 600, -120, -240, 360, 720]

    best = None
    for start_dir, end_dir in VALID_DIR_PAIRS:
        if start_dir in (DIR_LEFT, DIR_RIGHT):
            start_along = column_center_y(parent, pcols[0], all_tables, py) + p_stagger
            end_along = column_center_y(child, ccols[0], all_tables, cy) + c_stagger
        else:
            start_along = px + pw / 2 + p_stagger
            end_along = cx + cw / 2 + c_stagger

        sx, sy = anchor_on_edge(px, py, pw, ph, start_dir, start_along)
        ex, ey = anchor_on_edge(cx, cy, cw, ch, end_dir, end_along)

        for detour in detours:
            segments = build_path_segments(
                sx, sy, ex, ey, start_dir, end_dir, detour, obstacles
            )
            score = segments_cross_tables(segments, obstacles)
            length = path_length(segments)
            key = (score, length)
            if best is None or key < best[0]:
                best = (key, sx, sy, start_dir, ex, ey, end_dir)

    _, sx, sy, start_dir, ex, ey, end_dir = best
    return (sx, sy, start_dir), (ex, ey, end_dir)


def build_relationship_entities(positions: dict, tables: dict):
    relationship_entities = {}
    relationship_ids = []

    valid_rels = [
        (parent, list(pcols), child, list(ccols))
        for parent, pcols, child, ccols in LOGICAL_RELATIONSHIPS
        if parent in tables and child in tables
    ]
    parent_groups: dict[tuple, list[int]] = {}
    child_groups: dict[tuple, list[int]] = {}
    for idx, (parent, pcols, child, ccols) in enumerate(valid_rels):
        parent_groups.setdefault((parent, tuple(pcols)), []).append(idx)
        child_groups.setdefault((child, tuple(ccols)), []).append(idx)

    parent_index = {}
    for group in parent_groups.values():
        total = len(group)
        for i, idx in enumerate(group):
            parent_index[idx] = (i, total)

    child_index = {}
    for group in child_groups.values():
        total = len(group)
        for i, idx in enumerate(group):
            child_index[idx] = (i, total)

    for idx, (parent, pcols, child, ccols) in enumerate(valid_rels):
        pi, pt = parent_index[idx]
        ci, ct = child_index[idx]
        (sx, sy, start_dir), (ex, ey, end_dir) = build_relationship_points(
            parent, child, pcols, ccols, positions, tables, pi, pt, ci, ct
        )
        rid = uid("rel_")
        relationship_entities[rid] = {
            "id": rid,
            "identification": False,
            "relationshipType": 16,
            "startRelationshipType": 2,
            "start": {
                "tableId": table_id(parent),
                "columnIds": [col_id(parent, c) for c in pcols],
                "x": sx,
                "y": sy,
                "direction": start_dir,
            },
            "end": {
                "tableId": table_id(child),
                "columnIds": [col_id(child, c) for c in ccols],
                "x": ex,
                "y": ey,
                "direction": end_dir,
            },
            "meta": {"updateAt": NOW, "createAt": NOW},
        }
        relationship_ids.append(rid)

    return relationship_entities, relationship_ids


def uid(prefix: str = "") -> str:
    return f"{prefix}{uuid.uuid4().hex[:20]}"


def parse_ddl(text: str):
    """CREATE TABLE ... ); 단위로 파싱 (PK 없는 테이블도 다음 테이블과 병합되지 않음)."""
    tables = {}
    table_comments = {}
    column_comments = {}
    pk_map = {}

    for m in re.finditer(r"CREATE TABLE (\w+) \((.*?)\)\s*;", text, re.DOTALL):
        tname = m.group(1)
        body = m.group(2)
        pk_cols = []
        pk_m = re.search(
            r"CONSTRAINT PK_\w+ PRIMARY KEY \(([^)]+)\)", body, re.IGNORECASE
        )
        if pk_m:
            pk_cols = [c.strip() for c in pk_m.group(1).split(",")]

        cols = []
        for line in body.splitlines():
            line = line.strip().rstrip(",")
            if not line:
                continue
            upper = line.upper()
            if upper.startswith("CONSTRAINT") or upper.startswith("--"):
                continue
            parts = re.split(r"\s+", line, maxsplit=1)
            if len(parts) == 2 and re.match(r"^[A-Z][A-Z0-9_]*$", parts[0]):
                cols.append({"name": parts[0], "dataType": parts[1]})

        tables[tname] = cols
        pk_map[tname] = pk_cols

    for m in re.finditer(r"COMMENT ON TABLE (\w+) IS '([^']*)'", text):
        table_comments[m.group(1)] = m.group(2)

    for m in re.finditer(r"COMMENT ON COLUMN (\w+)\.(\w+) IS '([^']*)'", text):
        column_comments[(m.group(1), m.group(2))] = m.group(3)

    return tables, table_comments, column_comments, pk_map


def estimate_table_height(col_count: int) -> int:
    return HEADER_H + col_count * COL_LINE_H


def zone_width(cols: int) -> int:
    return cols * TABLE_WIDTH + max(0, cols - 1) * GAP_X


def pick_column_count(table_names: list, all_tables: dict, max_cols: int = 4) -> int:
    """도메인 내 최대 컬럼 높이가 최소가 되도록 열 수 자동 선택."""
    if len(table_names) <= 1:
        return 1
    heights = [
        estimate_table_height(len(all_tables[t])) + GAP_Y for t in table_names
    ]
    best_cols = 1
    best_score = float("inf")
    upper = min(max_cols, len(table_names))
    for cols in range(1, upper + 1):
        col_heights = [0] * cols
        for h in sorted(heights, reverse=True):
            col = min(range(cols), key=lambda i: col_heights[i])
            col_heights[col] += h
        score = max(col_heights)
        if score < best_score:
            best_score = score
            best_cols = cols
    return best_cols


def layout_domain_block(
    table_names: list,
    all_tables: dict,
    color: str,
    cols: int | None = None,
):
    """가장 낮은 컬럼에 테이블을 배치 (shortest-column masonry)."""
    if cols is None:
        cols = pick_column_count(table_names, all_tables)
    col_bottoms = [0] * cols
    rel_positions = {}
    sorted_names = sorted(
        table_names, key=lambda t: len(all_tables[t]), reverse=True
    )
    for tname in sorted_names:
        col = min(range(cols), key=lambda i: col_bottoms[i])
        x = col * (TABLE_WIDTH + GAP_X)
        y = col_bottoms[col]
        rel_positions[tname] = (x, y, color)
        col_bottoms[col] = y + estimate_table_height(len(all_tables[tname])) + GAP_Y
    width = zone_width(cols)
    height = max(col_bottoms) - GAP_Y if col_bottoms else 0
    return rel_positions, width, height, cols


def build_layout_domain(all_tables: dict, zone_config: list):
    """도메인 블록 크기를 계산한 뒤 가로 흐름(shelf)으로 유연 배치."""
    blocks = []
    for group in zone_config:
        rel_pos, width, height, cols = layout_domain_block(
            group["tables"], all_tables, group["color"]
        )
        blocks.append({
            "name": group["name"],
            "rel_pos": rel_pos,
            "width": width,
            "height": height,
            "cols": cols,
        })

    blocks.sort(key=lambda b: b["height"], reverse=True)

    rows: list[list] = []
    current_row: list = []
    current_row_width = 0

    for block in blocks:
        gap = BLOCK_GAP_X if current_row else 0
        if current_row and current_row_width + gap + block["width"] > MAX_ROW_WIDTH:
            rows.append(current_row)
            current_row = [block]
            current_row_width = block["width"]
        else:
            current_row.append(block)
            current_row_width += gap + block["width"]
    if current_row:
        rows.append(current_row)

    positions = {}
    colors = {}
    y = CANVAS_MARGIN
    max_row_bottom = CANVAS_MARGIN

    for row_blocks in rows:
        row_width = sum(b["width"] for b in row_blocks)
        inner_gaps = max(len(row_blocks) - 1, 0)
        extra_gap = 0
        if inner_gaps > 0:
            spare = MAX_ROW_WIDTH - row_width
            extra_gap = max(BLOCK_GAP_X, spare // inner_gaps)

        x = CANVAS_MARGIN
        row_height = 0
        for i, block in enumerate(row_blocks):
            if i > 0:
                x += extra_gap
            for tname, (rx, ry, color) in block["rel_pos"].items():
                positions[tname] = (x + rx, y + ry)
                colors[tname] = color
            row_height = max(row_height, block["height"])
            x += block["width"]

        y += row_height + BLOCK_GAP_Y
        max_row_bottom = y

    canvas_w = CANVAS_WIDTH
    canvas_h = max(max_row_bottom, 3200)

    for tname in sorted(all_tables):
        if tname not in positions:
            positions[tname] = (canvas_w - 400, canvas_h - 200)
            colors[tname] = ""

    return positions, colors, (canvas_w, canvas_h), blocks


def build_layout(all_tables, layout_groups, layout_name="default"):
    if layout_name == "domain":
        return build_layout_domain(all_tables, layout_groups)

    positions = {}
    colors = {}
    for group in layout_groups:
        ox, oy = group["origin"]
        row_h = group.get("row_h", 320)
        for i, tname in enumerate(group["tables"]):
            col = i % group["cols"]
            row = i // group["cols"]
            positions[tname] = (ox + col * group["dx"], oy + row * row_h)
            colors[tname] = group["color"]
    y = 2000
    for tname in sorted(all_tables):
        if tname not in positions:
            positions[tname] = (3400, y)
            colors[tname] = ""
            y += 320
    return positions, colors, None


def col_id(table: str, col: str) -> str:
    return f"col_{table}_{col}"


def table_id(name: str) -> str:
    return f"tbl_{name}"


def generate_erd(out_path: Path, layout_name: str, canvas_size: tuple[int, int] | None):
    layout_groups = LAYOUT_PROFILES[layout_name]
    text = DDL.read_text(encoding="utf-8")
    tables, table_comments, column_comments, pk_map = parse_ddl(text)
    layout_result = build_layout(tables, layout_groups, layout_name)
    block_info = []
    if layout_name == "domain":
        positions, colors, computed_canvas, block_info = layout_result
        canvas_size = computed_canvas
    else:
        positions, colors, _ = layout_result
        canvas_size = canvas_size or (4000, 2800)

    table_entities = {}
    column_entities = {}
    table_ids = []
    fk_cols = set()

    for rel in LOGICAL_RELATIONSHIPS:
        for c in rel[3]:
            fk_cols.add((rel[2], c))

    for tname in sorted(tables.keys()):
        tid = table_id(tname)
        cols = tables[tname]
        pks = set(pk_map.get(tname, []))
        cids = [col_id(tname, c["name"]) for c in cols]
        x, y = positions[tname]
        table_entities[tid] = {
            "id": tid,
            "name": tname,
            "comment": table_comments.get(tname, ""),
            "columnIds": cids,
            "seqColumnIds": cids[:],
            "ui": {
                "x": x,
                "y": y,
                "zIndex": 1,
                "widthName": 120,
                "widthComment": 120,
                "color": colors.get(tname, ""),
            },
            "meta": {"updateAt": NOW, "createAt": NOW},
        }
        table_ids.append(tid)

        for c in cols:
            cname = c["name"]
            cid = col_id(tname, cname)
            opts = 0
            keys = 0
            if cname in pks:
                opts |= 2  # primaryKey
                keys |= 1
            if (tname, cname) in fk_cols:
                keys |= 2  # foreignKey

            column_entities[cid] = {
                "id": cid,
                "tableId": tid,
                "name": cname,
                "comment": column_comments.get((tname, cname), ""),
                "dataType": c["dataType"],
                "default": "",
                "options": opts,
                "ui": {
                    "keys": keys,
                    "widthName": 120,
                    "widthComment": 100,
                    "widthDataType": 100,
                    "widthDefault": 60,
                },
                "meta": {"updateAt": NOW, "createAt": NOW},
            }

    relationship_entities, relationship_ids = build_relationship_entities(
        positions, tables
    )

    doc = {
        "tableIds": table_ids,
        "relationshipIds": relationship_ids,
        "indexIds": [],
        "memoIds": [],
    }

    settings = {
        "width": canvas_size[0],
        "height": canvas_size[1],
        "scrollTop": 0,
        "scrollLeft": 0,
        "zoomLevel": 0.75,
        "show": 431,
        "database": 8,
        "databaseName": "AI_SANCTION",
        "canvasType": "ERD",
        "language": 4,
        "tableNameCase": 1,
        "columnNameCase": 1,
        "bracketType": 1,
        "relationshipDataTypeSync": True,
        "relationshipOptimization": True,
        "columnOrder": [1, 2, 4, 8, 16, 32, 64],
        "maxWidthComment": 80,
    }

    erd = {
        "$schema": "https://raw.githubusercontent.com/dineug/erd-editor/main/json-schema/schema.json",
        "version": "3.0.0",
        "settings": settings,
        "doc": doc,
        "collections": {
            "tableEntities": table_entities,
            "tableColumnEntities": column_entities,
            "relationshipEntities": relationship_entities,
            "indexEntities": {},
            "indexColumnEntities": {},
            "memoEntities": {},
        },
    }

    out_path.write_text(json.dumps(erd, ensure_ascii=False, indent=2), encoding="utf-8")
    print(f"Generated {out_path}")
    print(f"  layout: {layout_name}")
    print(f"  tables: {len(table_entities)}")
    print(f"  columns: {len(column_entities)}")
    print(f"  relationships: {len(relationship_entities)}")
    print(f"  canvas: {canvas_size[0]} x {canvas_size[1]}")
    for block in block_info:
        print(f"    {block['name']}: {block['cols']} cols, {block['width']}x{block['height']}")


def main():
    parser = argparse.ArgumentParser(description="Generate ERD Editor v3 JSON from DDL")
    parser.add_argument(
        "-o", "--output",
        default=str(DEFAULT_OUT),
        help="Output .erd file path (default: sql/sanction.erd)",
    )
    parser.add_argument(
        "--layout",
        choices=LAYOUT_PROFILES.keys(),
        default="default",
        help="Layout profile: default | domain",
    )
    args = parser.parse_args()

    out_path = Path(args.output)
    if not out_path.is_absolute():
        out_path = ROOT / out_path

    generate_erd(out_path, args.layout, None)


if __name__ == "__main__":
    main()
