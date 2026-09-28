#!/usr/bin/env python3
"""
항목심사 테스트 코드·룰 유틸리티

근거: sql/itm_inpt_rules.json

사용 예:
  python scripts/itm_inpt_rules.py list
  python scripts/itm_inpt_rules.py item 70
  python scripts/itm_inpt_rules.py demo
  python scripts/itm_inpt_rules.py codes [230|240]
  python scripts/itm_inpt_rules.py sql-codes
"""
from __future__ import annotations

import json
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
RULES_PATH = ROOT / "sql" / "itm_inpt_rules.json"
COMMON_CODES_PATH = ROOT / "sql" / "itm_inpt_common_codes.json"


def load_rules() -> dict:
    with RULES_PATH.open(encoding="utf-8") as f:
        return json.load(f)


def find_item(rules: dict, sanction_no: str) -> dict | None:
    for item in rules["items"]:
        if item["sanctionNo"] == str(sanction_no):
            return item
    return None


def main(argv: list[str]) -> int:
    if len(argv) < 2:
        print(__doc__)
        return 1

    rules = load_rules()
    cmd = argv[1]

    if cmd == "list":
        print(f"{'No':<4} {'항목명':<28} {'우선문서':<10} {'IMEX':<4} {'속성':<10}")
        print("-" * 62)
        for item in rules["items"]:
            print(
                f"{item['sanctionNo']:<4} {item['nameEn']:<28} {item['priorityDoc']:<10} "
                f"{item['imexHisCd']:<4} {str(item.get('watchAttr') or ''):<10}"
            )
        return 0

    if cmd == "item" and len(argv) >= 3:
        item = find_item(rules, argv[2])
        if not item:
            print(f"항목 없음: {argv[2]}")
            return 1
        print(json.dumps(item, ensure_ascii=False, indent=2))
        return 0

    if cmd == "demo":
        print(json.dumps(rules["demoExtractions"], ensure_ascii=False, indent=2))
        return 0

    if cmd == "codes":
        with COMMON_CODES_PATH.open(encoding="utf-8") as f:
            codes = json.load(f)
        grp = argv[2] if len(argv) >= 3 else None
        key = "importItems" if grp == "230" else "exportItems" if grp == "240" else None
        items = codes[key] if key else codes["exportItems"] + codes["importItems"]
        print(f"{'No':<6} {'항목명':<32} {'우선문서':<10} {'속성':<10}")
        print("-" * 64)
        seen = set()
        for item in items:
            no = item["sanctionNo"]
            if no in seen:
                continue
            seen.add(no)
            print(
                f"{no:<6} {item['nameEn']:<32} {item['priorityDoc']:<10} "
                f"{str(item.get('watchAttr') or ''):<10}"
            )
        return 0

    if cmd == "sql-codes":
        import subprocess

        gen = ROOT / "scripts" / "generate_itm_inpt_common_codes.py"
        subprocess.run([sys.executable, str(gen)], check=True)
        return 0

    print(f"알 수 없는 명령: {cmd}")
    return 1


if __name__ == "__main__":
    raise SystemExit(main(sys.argv))
