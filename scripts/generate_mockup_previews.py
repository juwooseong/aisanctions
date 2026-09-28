# -*- coding: utf-8 -*-
"""와이어프레임 HTML → PNG 미리보기 생성 (Excel 삽입용)."""
from __future__ import annotations

import re
import subprocess
from pathlib import Path

from screen_design_enrich import HUB_ID_ALIAS, STANDALONE_MOCKUP

ROOT = Path(__file__).resolve().parents[1]
WIRE = ROOT / "docs" / "wireframes"
HUB = WIRE / "index.html"
PREVIEW_DIR = ROOT / "docs" / "screen-design" / "excel" / "previews"
TEMP_DIR = PREVIEW_DIR / "_temp"

BROWSER_CANDIDATES = [
    Path(r"C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"),
    Path(r"C:\Program Files\Microsoft\Edge\Application\msedge.exe"),
    Path(r"C:\Program Files\Google\Chrome\Application\chrome.exe"),
    Path(r"C:\Program Files (x86)\Google\Chrome\Application\chrome.exe"),
]

# 화면ID → 허브 section id
HUB_SECTION_OVERRIDE: dict[str, str] = {
    "BUNDLE": "2010-BUNDLE",
    "GLOBAL": "ETC-FR005",
    "7050-RULE": "7050",
    "7050": "7050-AUTH",
}


def hub_section_id(sid: str) -> str | None:
    if sid in HUB_SECTION_OVERRIDE:
        return HUB_SECTION_OVERRIDE[sid]
    for hub_id, screen_id in HUB_ID_ALIAS.items():
        if screen_id == sid:
            return hub_id
    if HUB.exists():
        text = HUB.read_text(encoding="utf-8")
        if f'id="screen-{sid}"' in text:
            return sid
    return None


def find_browser() -> Path | None:
    for p in BROWSER_CANDIDATES:
        if p.exists():
            return p
    return None


def screenshot_html(browser: Path, html_path: Path, out_png: Path, width: int = 1280, height: int = 900) -> bool:
    out_png.parent.mkdir(parents=True, exist_ok=True)
    uri = html_path.resolve().as_uri()
    cmd = [
        str(browser),
        "--headless=new",
        "--disable-gpu",
        "--hide-scrollbars",
        f"--window-size={width},{height}",
        f"--screenshot={out_png.resolve()}",
        uri,
    ]
    try:
        subprocess.run(cmd, capture_output=True, timeout=30, check=False)
        return out_png.exists() and out_png.stat().st_size > 1000
    except (subprocess.TimeoutExpired, OSError):
        return False


def extract_hub_section_html(hub_id: str) -> str | None:
    if not HUB.exists():
        return None
    text = HUB.read_text(encoding="utf-8")
    m = re.search(
        rf'<section id="screen-{re.escape(hub_id)}" class="aid-screen wf-screen-section">(.*?)</section>',
        text,
        re.S,
    )
    if not m:
        return None
    body = m.group(1)
    return f"""<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <link rel="stylesheet" href="../../../wireframes/css/wireframe.css">
  <style>body{{margin:0;padding:12px;background:#f8fafc;}} .wf-screen-section{{display:block;}}</style>
</head>
<body>
<section class="aid-screen wf-screen-section">{body}</section>
</body>
</html>"""


def pillow_fallback(sid: str, name: str, out_png: Path, d: dict) -> bool:
    try:
        from PIL import Image, ImageDraw, ImageFont
    except ImportError:
        return False

    w, h = 900, 520
    img = Image.new("RGB", (w, h), "#f8fafc")
    draw = ImageDraw.Draw(img)
    try:
        font = ImageFont.truetype("malgun.ttf", 14)
        font_sm = ImageFont.truetype("malgun.ttf", 11)
    except OSError:
        font = ImageFont.load_default()
        font_sm = font

    draw.rectangle([0, 0, w, 48], fill="#1c5bba")
    draw.text((16, 14), f"SCR-{sid}  {name}", fill="white", font=font)
    y = 60
    mock = d.get("mockup", {})
    draw.text((16, y), f"목업: {mock.get('preview_path', '패턴 템플릿')}", fill="#64748b", font=font_sm)
    y += 28
    for comp in (d.get("ui_components") or [])[:5]:
        draw.rectangle([16, y, w - 16, y + 36], outline="#cbd5e1", fill="white")
        draw.text((24, y + 10), f"{comp[0]}  ({comp[1]})", fill="#1e293b", font=font_sm)
        y += 44
    if d.get("interaction"):
        draw.text((16, y + 8), d["interaction"][:80], fill="#144a9c", font=font_sm)
    out_png.parent.mkdir(parents=True, exist_ok=True)
    img.save(out_png, "PNG")
    return True


def resolve_html_source(sid: str, wireframe: str) -> tuple[str, Path | None]:
    """Returns ('standalone'|'hub'|'none', path)."""
    wf = wireframe if wireframe and wireframe != "—" else STANDALONE_MOCKUP.get(sid)
    if wf and wf != "—":
        p = WIRE / wf
        if p.exists():
            return "standalone", p
    hub_id = hub_section_id(sid)
    if hub_id:
        html = extract_hub_section_html(hub_id)
        if html:
            TEMP_DIR.mkdir(parents=True, exist_ok=True)
            tmp = TEMP_DIR / f"{sid}.html"
            tmp.write_text(html, encoding="utf-8")
            return "hub", tmp
    return "none", None


def preview_path(sid: str) -> Path:
    safe = sid.replace("/", "-")
    return PREVIEW_DIR / f"{safe}.png"


def generate_preview(sid: str, screen: tuple, detail: dict, browser: Path | None, force: bool = False) -> Path | None:
    out = preview_path(sid)
    if out.exists() and not force and out.stat().st_size > 1000:
        return out

    wireframe = screen[8]
    kind, html_path = resolve_html_source(sid, wireframe)

    if browser and html_path and screenshot_html(browser, html_path, out):
        return out

    if pillow_fallback(sid, screen[1], out, detail):
        return out
    return None


def generate_all_previews(screens: list[tuple], detail: dict, force: bool = False) -> dict[str, Path]:
    browser = find_browser()
    if not browser:
        print("Browser not found — Pillow fallback only")
    else:
        print(f"Browser: {browser}")

    results: dict[str, Path] = {}
    for s in screens:
        sid = s[0]
        d = detail.get(sid, {})
        p = generate_preview(sid, s, d, browser, force=force)
        if p:
            results[sid] = p
            print(f"  OK {sid} -> {p.name}")
        else:
            print(f"  SKIP {sid}")
    print(f"Previews: {len(results)}/{len(screens)} -> {PREVIEW_DIR}")
    return results


if __name__ == "__main__":
    from generate_screen_design_excel import DETAIL, SCREENS
    generate_all_previews(SCREENS, DETAIL, force=False)
