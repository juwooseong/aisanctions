/* 심사상세 형광펜(영역 지정) · 핀 고정 */
var DetailAnno = (function (window, $) {
	'use strict';

	// 조회 전용(결재자 화면 등): 저장된 형광펜/핀은 그대로 그려서 보여주되,
	// 그리기/이동/삭제 등 편집 인터랙션은 전부 비활성화한다.
	// 화면 jsp에서 <script>보다 먼저 window.ANNO_READONLY = true; 를 세팅해서 사용한다.
	var READONLY = window.ANNO_READONLY === true;

	var mode = 'navigate';
	var color = 'rgba(255,235,59,0.45)';
	var pinColor = '#ca8a04';
	var DEFAULT_PIN_COLOR = '#e11d48';
	var widthPx = 18;
	var markers = [];
	var pins = [];
	var loadedMst = '';
	var stroke = null;
	var dragging = false;
	var dragMoved = false;
	var dragStart = { x: 0, y: 0 };
	var moveDrag = null;
	var selected = null;
	var pinDraft = null;
	var seq = 1;
	var saveTimer = null;
	var suppressPaint = false;	// paintAfter 중 fn_clear_box 래퍼의 paint() 생략 (중복 그리기 방지)
	var DRAG_THRESHOLD = 5;

	function ctxPath() {
		return (typeof ctx === 'string') ? ctx : '';
	}

	function mst() {
		return String(typeof globalInptMstSrno !== 'undefined' ? globalInptMstSrno : '');
	}

	function taskId() {
		return String($('#active_inptTaskId').val() || '');
	}

	function rotated() {
		return typeof rotateVal !== 'undefined' && (rotateVal % 360) !== 0;
	}

	function srcSize() {
		var img = window.image_global;
		return {
			w: (img && img.width) ? img.width : 0,
			h: (img && img.height) ? img.height : 0
		};
	}

	function toCanvas(sx, sy) {
		var c = document.getElementById('canvas');
		var img = window.image_global;
		if (!c || !img || !img.width) {
			return { x: sx, y: sy };
		}
		return {
			x: sx * (c.width / img.width),
			y: sy * (c.height / img.height)
		};
	}

	function toSource(cx, cy) {
		var c = document.getElementById('canvas');
		var img = window.image_global;
		if (!c || !img || !img.width) {
			return { x: cx, y: cy };
		}
		return {
			x: cx * (img.width / c.width),
			y: cy * (img.height / c.height)
		};
	}

	function mousePos(e) {
		var c = document.getElementById('canvas');
		var rect = c.getBoundingClientRect();
		var sx = rect.width ? (c.width / rect.width) : 1;
		var sy = rect.height ? (c.height / rect.height) : 1;
		return {
			x: (e.clientX - rect.left) * sx,
			y: (e.clientY - rect.top) * sy
		};
	}

	function clamp(v, min, max) {
		if (!(max > 0)) {
			return v;
		}
		if (v < min) return min;
		if (v > max) return max;
		return v;
	}

	function findMarker(id) {
		var i;
		for (i = 0; i < markers.length; i++) {
			if (markers[i].id === id) {
				return markers[i];
			}
		}
		return null;
	}

	function findPin(id) {
		var i;
		for (i = 0; i < pins.length; i++) {
			if (pins[i].id === id) {
				return pins[i];
			}
		}
		return null;
	}

	function applyMoveDelta(dx, dy) {
		var sz, pin, mk;
		if (!moveDrag) {
			return;
		}
		sz = srcSize();
		if (moveDrag.type === 'pin') {
			pin = findPin(moveDrag.id);
			if (!pin) {
				return;
			}
			pin.x = clamp(moveDrag.origX + dx, 0, sz.w);
			pin.y = clamp(moveDrag.origY + dy, 0, sz.h);
			return;
		}
		if (moveDrag.type === 'marker') {
			mk = findMarker(moveDrag.id);
			if (!mk || !moveDrag.origPoints) {
				return;
			}
			mk.points = moveDrag.origPoints.map(function (p) {
				return [clamp(p[0] + dx, 0, sz.w), clamp(p[1] + dy, 0, sz.h)];
			});
		}
	}

	function nextId(prefix) {
		return prefix + '_' + Date.now() + '_' + (seq++);
	}

	function pageMarkers() {
		var id = taskId();
		return markers.filter(function (m) { return !m.inptTaskId || m.inptTaskId === id; });
	}

	function pagePins() {
		var id = taskId();
		return pins.filter(function (p) { return !p.inptTaskId || p.inptTaskId === id; });
	}

	var PIN_FA = '\uf08d';

	function pinFill(pin) {
		return (pin && pin.color) ? pin.color : (pinColor || DEFAULT_PIN_COLOR);
	}

	function drawThumbtack(g, p, selectedPin, fill) {
		var size = selectedPin ? 16 : 14;
		var x = Math.round(p.x);
		var y = Math.round(p.y);
		var m, right, top, h, midY;
		g.font = 'normal normal normal ' + size + 'px FontAwesome';
		g.textAlign = 'center';
		g.textBaseline = 'bottom';
		g.lineJoin = 'round';
		g.miterLimit = 2;
		g.strokeStyle = '#fff';
		g.lineWidth = 2;
		g.strokeText(PIN_FA, x, y);
		g.fillStyle = fill;
		g.fillText(PIN_FA, x, y);
		m = g.measureText(PIN_FA);
		right = (m.actualBoundingBoxRight != null) ? m.actualBoundingBoxRight : (size * 0.52);
		top = (m.actualBoundingBoxAscent != null) ? m.actualBoundingBoxAscent : size;
		h = top + ((m.actualBoundingBoxDescent != null) ? m.actualBoundingBoxDescent : 0);
		midY = y - top + (h / 2);
		return {
			boxX: x + right + 4,
			midY: midY,
			size: size
		};
	}

	// 영역 지정 : width 0 인 marker 는 대각선 두 점(points[0], points[1])으로 만든 사각형 영역
	//            (기존 형광펜 데이터는 width > 0 이라 선으로 그대로 표시)
	function isRect(mk) {
		return !!mk && Number(mk.width) === 0;
	}

	function rectOf(pts) {
		var a = toCanvas(pts[0][0], pts[0][1]);
		var b = toCanvas(pts[1][0], pts[1][1]);
		return {
			x: Math.min(a.x, b.x),
			y: Math.min(a.y, b.y),
			w: Math.abs(b.x - a.x),
			h: Math.abs(b.y - a.y)
		};
	}

	function fillRect(g, pts, fill) {
		var r = rectOf(pts);
		g.save();
		// 영역은 글자를 덮으므로 팔레트 색(알파 0.4~0.45)보다 더 투명하게 (약 0.25)
		g.globalAlpha = 0.6;
		g.fillStyle = fill;
		g.fillRect(r.x, r.y, r.w, r.h);
		g.restore();
	}

	// 선택된 형광펜 삭제 아이콘 : 이동 모드에서 형광펜 선택 시 오른쪽 상단에 표시
	var DEL_ICON_R = 9;

	function selectedMarker() {
		if (mode !== 'navigate' || !selected || selected.type !== 'marker') {
			return null;
		}
		var mk = findMarker(selected.id);
		return (mk && pageMarkers().indexOf(mk) > -1) ? mk : null;
	}

	// 형광펜 범위(캔버스 좌표) : 영역은 사각형, 기존 선 형광펜은 점들의 범위
	function boundsOf(mk) {
		var pts = mk.points || [];
		var i, cp, minX, minY, maxX, maxY;
		if (pts.length < 2) {
			return null;
		}
		if (isRect(mk)) {
			return rectOf(pts);
		}
		for (i = 0; i < pts.length; i++) {
			cp = toCanvas(pts[i][0], pts[i][1]);
			minX = (i === 0) ? cp.x : Math.min(minX, cp.x);
			minY = (i === 0) ? cp.y : Math.min(minY, cp.y);
			maxX = (i === 0) ? cp.x : Math.max(maxX, cp.x);
			maxY = (i === 0) ? cp.y : Math.max(maxY, cp.y);
		}
		return { x: minX, y: minY, w: maxX - minX, h: maxY - minY };
	}

	function delIconPos(mk) {
		var r = boundsOf(mk);
		return r ? { x: r.x + r.w, y: r.y } : null;
	}

	function hitDelIcon(cx, cy) {
		var mk = selectedMarker();
		var p = mk ? delIconPos(mk) : null;
		if (!p) {
			return null;
		}
		var dx = cx - p.x, dy = cy - p.y;
		return (dx * dx + dy * dy <= (DEL_ICON_R + 2) * (DEL_ICON_R + 2)) ? mk : null;
	}

	function paintSelectedMarker(g) {
		var mk = selectedMarker();
		var r = mk ? boundsOf(mk) : null;
		if (!r) {
			return;
		}
		g.save();
		// 선택 표시 (점선 테두리)
		g.strokeStyle = '#334155';
		g.lineWidth = 1;
		g.setLineDash([4, 3]);
		g.strokeRect(r.x, r.y, r.w, r.h);
		g.setLineDash([]);
		// 삭제 아이콘 (빨간 원 + 흰 X)
		g.beginPath();
		g.arc(r.x + r.w, r.y, DEL_ICON_R, 0, Math.PI * 2);
		g.fillStyle = '#dc2626';
		g.fill();
		g.strokeStyle = '#fff';
		g.lineWidth = 1.5;
		g.stroke();
		g.beginPath();
		g.moveTo(r.x + r.w - 3.5, r.y - 3.5);
		g.lineTo(r.x + r.w + 3.5, r.y + 3.5);
		g.moveTo(r.x + r.w + 3.5, r.y - 3.5);
		g.lineTo(r.x + r.w - 3.5, r.y + 3.5);
		g.lineWidth = 2;
		g.stroke();
		g.restore();
	}

	function deleteMarker(mk) {
		if (!mk || !window.confirm('선택한 형광펜을 삭제할까요?')) {
			return;
		}
		markers = markers.filter(function (m) { return m.id !== mk.id; });
		selected = null;
		persist();
		paintAfter();
	}

	// 핀 메모 표시 : 최대 폭 / 최대 줄 수 / 줄 높이 (캔버스 px)
	var MEMO_MAX_W = 180;
	var MEMO_MAX_LINES = 3;
	var MEMO_LINE_H = 15;

	// 메모를 줄 단위로 나눔 : 입력한 줄바꿈 유지, 한 줄이 maxW 를 넘으면 글자 단위로 다음 줄로
	// maxLines 를 넘는 내용이 있으면 마지막 줄 끝을 '…' 로 줄임
	function wrapMemo(g, text, maxW, maxLines) {
		var paras = text.replace(/\r\n?/g, '\n').split('\n');
		var lines = [];
		var over = false;
		var i, k, ch, cur, last;
		for (i = 0; i < paras.length && !over; i++) {
			cur = '';
			for (k = 0; k < paras[i].length; k++) {
				ch = paras[i].charAt(k);
				if (cur && g.measureText(cur + ch).width > maxW) {
					lines.push(cur);
					cur = '';
					if (lines.length >= maxLines) {
						over = true;
						break;
					}
				}
				cur += ch;
			}
			if (!over) {
				lines.push(cur);
				if (lines.length >= maxLines && i < paras.length - 1) {
					over = true;
				}
			}
		}
		if (lines.length > maxLines) {
			lines = lines.slice(0, maxLines);
			over = true;
		}
		if (over) {
			last = lines[lines.length - 1];
			while (last && g.measureText(last + '…').width > maxW) {
				last = last.slice(0, -1);
			}
			lines[lines.length - 1] = last + '…';
		}
		return lines;
	}

	function paint() {
		var g = window.ctx_global;
		var c = document.getElementById('canvas');
		if (!g || !c) {
			return;
		}
		var i, p, pts, j, cp, pin;
		var mks = pageMarkers();
		for (i = 0; i < mks.length; i++) {
			pts = mks[i].points || [];
			if (pts.length < 2) {
				continue;
			}
			if (isRect(mks[i])) {
				fillRect(g, pts, mks[i].color || color);
				continue;
			}
			g.save();
			g.lineCap = 'round';
			g.lineJoin = 'round';
			g.strokeStyle = mks[i].color || color;
			g.lineWidth = (mks[i].width || widthPx) * (c.width / (srcSize().w || c.width));
			g.beginPath();
			cp = toCanvas(pts[0][0], pts[0][1]);
			g.moveTo(cp.x, cp.y);
			for (j = 1; j < pts.length; j++) {
				cp = toCanvas(pts[j][0], pts[j][1]);
				g.lineTo(cp.x, cp.y);
			}
			g.stroke();
			g.restore();
		}
		// 드래그 중인 영역 미리보기
		if (stroke && stroke.points && stroke.points.length > 1) {
			fillRect(g, stroke.points, color);
		}
		var pns = pagePins();
		for (i = 0; i < pns.length; i++) {
			pin = pns[i];
			p = toCanvas(pin.x, pin.y);
			g.save();
			var fill = pinFill(pin);
			var head = drawThumbtack(g, p, !!(selected && selected.type === 'pin' && selected.id === pin.id), fill);
			if (pin.opinion) {
				// 메모 : 입력한 줄바꿈 + 폭(MEMO_MAX_W) 기준 자동 줄바꿈, 최대 MEMO_MAX_LINES 줄 넘으면 말줄임
				g.font = '11px Malgun Gothic, sans-serif';
				g.textAlign = 'left';
				g.textBaseline = 'middle';
				var lines = wrapMemo(g, String(pin.opinion), MEMO_MAX_W, MEMO_MAX_LINES);
				var tw = 0;
				for (j = 0; j < lines.length; j++) {
					tw = Math.max(tw, g.measureText(lines[j]).width);
				}
				tw += 10;
				var boxH = lines.length * MEMO_LINE_H + 4;
				// 첫 줄이 핀 머리 높이에 오도록 위쪽 기준으로 배치
				var boxY = Math.round(head.midY - MEMO_LINE_H / 2 - 2);
				g.fillStyle = '#fff';
				g.strokeStyle = fill;
				g.lineWidth = 1.5;
				g.beginPath();
				g.rect(head.boxX, boxY, tw, boxH);
				g.fill();
				g.stroke();
				g.fillStyle = '#333';
				for (j = 0; j < lines.length; j++) {
					g.fillText(lines[j], head.boxX + 5, boxY + 2 + MEMO_LINE_H * j + MEMO_LINE_H / 2);
				}
			}
			g.restore();
		}
		paintSelectedMarker(g);
	}

	function distPointSeg(px, py, ax, ay, bx, by) {
		var dx = bx - ax, dy = by - ay;
		var len2 = dx * dx + dy * dy;
		var t = len2 === 0 ? 0 : ((px - ax) * dx + (py - ay) * dy) / len2;
		if (t < 0) t = 0;
		if (t > 1) t = 1;
		var qx = ax + t * dx, qy = ay + t * dy;
		dx = px - qx; dy = py - qy;
		return Math.sqrt(dx * dx + dy * dy);
	}

	function hitMarker(cx, cy) {
		var mks = pageMarkers();
		var i, j, pts, a, b, ca, cb, thr;
		var c = document.getElementById('canvas');
		var img = window.image_global;
		var scale = (c && img && img.width) ? (c.width / img.width) : 1;
		var r;
		for (i = mks.length - 1; i >= 0; i--) {
			pts = mks[i].points || [];
			// 영역 : 안쪽 어디를 눌러도 선택 (테두리 바깥 4px 여유)
			if (isRect(mks[i])) {
				if (pts.length < 2) {
					continue;
				}
				r = rectOf(pts);
				if (cx >= r.x - 4 && cx <= r.x + r.w + 4 && cy >= r.y - 4 && cy <= r.y + r.h + 4) {
					return mks[i];
				}
				continue;
			}
			thr = Math.max(8, (mks[i].width || widthPx) * scale * 0.6);
			for (j = 1; j < pts.length; j++) {
				ca = toCanvas(pts[j - 1][0], pts[j - 1][1]);
				cb = toCanvas(pts[j][0], pts[j][1]);
				if (distPointSeg(cx, cy, ca.x, ca.y, cb.x, cb.y) <= thr) {
					return mks[i];
				}
			}
		}
		return null;
	}

	function hitPin(cx, cy) {
		var pns = pagePins();
		var i, p, dx;
		for (i = pns.length - 1; i >= 0; i--) {
			p = toCanvas(pns[i].x, pns[i].y);
			dx = cx - p.x;
			if (Math.abs(dx) <= 10 && cy >= p.y - 18 && cy <= p.y + 3) {
				return pns[i];
			}
		}
		return null;
	}

	function persist() {
		var id = mst();
		var tid = taskId();
		if (!id || id === '0' || !tid) {
			return;
		}
		if (saveTimer) {
			window.clearTimeout(saveTimer);
		}
		saveTimer = window.setTimeout(function () {
			var sz = srcSize();
			$.ajax({
				url: ctxPath() + '/api/anno/' + encodeURIComponent(id) + '/save',
				type: 'POST',
				contentType: 'application/json; charset=UTF-8',
				dataType: 'json',
				data: JSON.stringify({
					inptTaskId: tid,
					inptBlGrpNo: $('#active_inptBlGrpNo').val() || '',
					imexHisCd: $('#active_imexHisCd').val() || '',
					imageWidth: sz.w,
					imageHeight: sz.h,
					markers: pageMarkers(),
					pins: pagePins()
				})
			});
		}, 250);
	}

	function loadAll() {
		var id = mst();
		if (!id || id === '0') {
			return;
		}
		if (loadedMst === id) {
			redraw();
			return;
		}
		$.ajax({
			url: ctxPath() + '/api/anno/' + encodeURIComponent(id),
			type: 'GET',
			dataType: 'json'
		}).done(function (res) {
			if (!res || String(res.resultCode) !== '200') {
				return;
			}
			markers = res.markers || [];
			pins = res.pins || [];
			loadedMst = id;
			redraw();
		});
	}

	function syncPinColorUi(selectedColor) {
		var c = selectedColor || pinColor || DEFAULT_PIN_COLOR;
		pinColor = c;
		$('#anno_pin_colors .anno-swatch').removeClass('active');
		$('#anno_pin_colors .anno-swatch').each(function () {
			if ($(this).attr('data-pin-color') === c) {
				$(this).addClass('active');
			}
		});
		$('.anno-marker-palette .anno-swatch').each(function () {
			var on = $(this).attr('data-pin-color') === c;
			$(this).toggleClass('active', on);
			if (on && $(this).attr('data-anno-color')) {
				color = $(this).attr('data-anno-color');
			}
		});
	}

	function openPinModal(pin, isNew) {
		pinDraft = { pin: pin, isNew: !!isNew, color: pin.color || pinColor || DEFAULT_PIN_COLOR };
		$('#anno_pin_opinion').val(pin.opinion || '');
		$('#anno_pin_delete').toggle(!isNew);
		syncPinColorUi(pinDraft.color);
		$('#anno_pin_modal').addClass('open');
		$('#anno_pin_opinion').focus();
	}

	function closePinModal() {
		$('#anno_pin_modal').removeClass('open');
		pinDraft = null;
	}

	// 조회 전용 화면: 편집 모달 대신 의견 전체를 보여만 주는 뷰 모달.
	function openPinViewModal(pin) {
		$('#anno_pin_view_opinion').text(pin.opinion || '');
		$('#anno_pin_view_modal').addClass('open');
	}

	function closePinViewModal() {
		$('#anno_pin_view_modal').removeClass('open');
	}

	function bindReadonlyView() {
		var c = document.getElementById('canvas');
		if (c) {
			c.addEventListener('click', function (e) {
				var pos = mousePos(e);
				var pin = hitPin(pos.x, pos.y);
				if (pin) {
					openPinViewModal(pin);
				}
			});
		}
		$(document).on('click', '#anno_pin_view_close', function () {
			closePinViewModal();
		});
		$(document).on('click', '#anno_pin_view_modal', function (e) {
			if (e.target && e.target.id === 'anno_pin_view_modal') {
				closePinViewModal();
			}
		});
	}

	function setMode(next) {
		mode = next || 'navigate';
		$('.anno-mode-btn').removeClass('active');
		$('.anno-mode-btn[data-anno-mode="' + mode + '"]').addClass('active');
		$('#annoToolbar').toggleClass('marker-on', mode === 'marker');
		$('#annoToolbar').toggleClass('pin-on', mode === 'pin');
		var hint = '';
		if (mode === 'marker') hint = '드래그하여 형광펜 영역을 지정합니다.';
		else if (mode === 'pin') hint = '색상을 고른 뒤 클릭한 위치에 핀을 고정합니다.';
		else hint = '핀·형광펜 드래그=이동 · 형광펜 선택 후 X=삭제 · 핀 클릭=의견 · 빈 곳 드래그=화면 이동';
		$('#annoHint').text(hint);
		// 모드 전환 시 형광펜 선택(삭제 아이콘) 해제
		if (selected && selected.type === 'marker') {
			selected = null;
			paintAfter();
		}
		var c = document.getElementById('canvas');
		if (c) {
			c.style.cursor = (mode === 'navigate') ? 'grab' : 'crosshair';
		}
	}

	function resetCursor() {
		var c = document.getElementById('canvas');
		if (c) {
			c.style.cursor = (mode === 'navigate') ? 'grab' : 'crosshair';
		}
	}

	function onDown(e) {
		var pos, pin, mk, src, c;
		dragMoved = false;
		moveDrag = null;
		dragStart = { x: e.clientX, y: e.clientY };
		if (rotated()) {
			if (mode !== 'navigate') {
				alert('회전을 원위치로 맞춘 뒤 형광펜·핀을 사용하세요.');
				return true;
			}
			return false;
		}
		if (mode === 'navigate') {
			pos = mousePos(e);
			c = document.getElementById('canvas');
			// 선택된 형광펜의 삭제 아이콘 클릭
			mk = hitDelIcon(pos.x, pos.y);
			if (mk) {
				deleteMarker(mk);
				return true;
			}
			pin = hitPin(pos.x, pos.y);
			if (pin) {
				src = toSource(pos.x, pos.y);
				moveDrag = {
					type: 'pin',
					id: pin.id,
					startSrc: src,
					origX: pin.x,
					origY: pin.y
				};
				selected = { type: 'pin', id: pin.id };
				if (c) {
					c.style.cursor = 'move';
				}
				paintAfter();
				return true;
			}
			mk = hitMarker(pos.x, pos.y);
			if (mk) {
				moveDrag = {
					type: 'marker',
					id: mk.id,
					startSrc: toSource(pos.x, pos.y),
					origPoints: (mk.points || []).map(function (p) { return [p[0], p[1]]; })
				};
				selected = { type: 'marker', id: mk.id };
				if (c) {
					c.style.cursor = 'move';
				}
				paintAfter();
				return true;
			}
			// 빈 곳 클릭 : 선택 해제 (삭제 아이콘 지움)
			if (selected) {
				selected = null;
				paintAfter();
			}
			return false;
		}
		dragging = true;
		src = toSource(mousePos(e).x, mousePos(e).y);
		if (mode === 'marker') {
			// 영역 : 시작점 / 끝점(드래그 중 갱신)
			stroke = { points: [[src.x, src.y], [src.x, src.y]] };
			return true;
		}
		if (mode === 'pin') {
			pinDraft = { pending: { x: src.x, y: src.y } };
			return true;
		}
		return false;
	}

	function onMove(e) {
		var pos, src, last, dx, dy;
		dx = e.clientX - dragStart.x;
		dy = e.clientY - dragStart.y;
		if (Math.abs(dx) > DRAG_THRESHOLD || Math.abs(dy) > DRAG_THRESHOLD) {
			dragMoved = true;
		}
		if (moveDrag) {
			pos = mousePos(e);
			src = toSource(pos.x, pos.y);
			applyMoveDelta(src.x - moveDrag.startSrc.x, src.y - moveDrag.startSrc.y);
			paintAfter();
			return true;
		}
		// 삭제 아이콘 위에서는 손가락 커서
		if (!dragging && mode === 'navigate' && selected && selected.type === 'marker') {
			pos = mousePos(e);
			document.getElementById('canvas').style.cursor = hitDelIcon(pos.x, pos.y) ? 'pointer' : 'grab';
		}
		if (!dragging || mode !== 'marker' || !stroke) {
			return false;
		}
		src = toSource(mousePos(e).x, mousePos(e).y);
		last = stroke.points[1];
		if (Math.abs(last[0] - src.x) > 1 || Math.abs(last[1] - src.y) > 1) {
			stroke.points[1] = [src.x, src.y];
			paintAfter();
		}
		return true;
	}

	function onUp(e) {
		var src, pin;
		if (moveDrag) {
			if (dragMoved) {
				persist();
			} else if (moveDrag.type === 'pin') {
				pin = findPin(moveDrag.id);
				if (pin) {
					openPinModal(pin, false);
				}
			}
			moveDrag = null;
			dragging = false;
			resetCursor();
			paintAfter();
			return true;
		}
		if (mode === 'navigate') {
			return false;
		}
		dragging = false;
		if (mode === 'marker' && stroke && stroke.points && stroke.points.length >= 2) {
			var r = rectOf(stroke.points);
			var p0 = stroke.points[0], p1 = stroke.points[1];
			stroke = null;
			// 너무 작은 영역(클릭 등)은 저장하지 않음
			if (r.w < DRAG_THRESHOLD || r.h < DRAG_THRESHOLD) {
				paintAfter();
				return true;
			}
			markers.push({
				id: nextId('mk'),
				inptTaskId: taskId(),
				points: [
					[Math.min(p0[0], p1[0]), Math.min(p0[1], p1[1])],
					[Math.max(p0[0], p1[0]), Math.max(p0[1], p1[1])]
				],
				color: color,
				width: 0
			});
			persist();
			paintAfter();
			return true;
		}
		stroke = null;
		if (mode === 'pin' && pinDraft && pinDraft.pending) {
			src = toSource(mousePos(e).x, mousePos(e).y);
			openPinModal({ x: src.x, y: src.y, opinion: '' }, true);
			return true;
		}
		return mode !== 'navigate';
	}

	// 이미지·박스를 다시 그린 뒤 형광펜·핀을 맨 위에 한 번만 그림
	// (fn_clear_box 래퍼와 fn_draw_multi_box 내부 fn_clear_box 호출에서 paint() 가 겹치면
	//  반투명 형광펜이 두 번 칠해져 진해지므로 그 동안은 래퍼의 paint() 를 생략)
	// genesis.js 하이라이트 깜빡임 타이머 동작 여부 (fn_selected_blink → refresh_id_list 에 등록)
	function isBlinking() {
		return typeof refresh_id_list !== 'undefined' && refresh_id_list && refresh_id_list.length > 0;
	}

	function paintAfter() {
		suppressPaint = true;
		try {
			if (typeof fn_clear_box === 'function') {
				fn_clear_box();
			}
			// 하이라이트 깜빡임 중에는 fn_draw_multi_box 호출 금지 :
			// fn_draw_multi_box 첫 줄의 fn_remove_blink_list() 가 깜빡임 타이머를 멈춰 하이라이트가 사라짐
			// (박스·하이라이트는 0.5초마다 도는 깜빡임 타이머가 fn_clear_box 와 함께 다시 그림)
			if (typeof fn_draw_multi_box === 'function' && !isBlinking()) {
				fn_draw_multi_box();
			}
		} finally {
			suppressPaint = false;
		}
		paint();
	}

	// 이미 그려진 캔버스 위에 paint() 를 덧칠하지 않도록 이미지부터 다시 그림 (이미지 로드 전이면 paint 만)
	function redraw() {
		var img = window.image_global;
		if (window.ctx_global && img && img.width) {
			paintAfter();
		} else {
			paint();
		}
	}

	function wrapGenesis() {
		if (!READONLY && typeof fn_mouse_down === 'function') {
			var od = fn_mouse_down, om = fn_mouse_move, ou = fn_mouse_up;
			fn_mouse_down = function (e) {
				if (onDown(e)) {
					e.preventDefault();
					return;
				}
				od(e);
			};
			fn_mouse_move = function (e) {
				if (onMove(e)) {
					e.preventDefault();
					return;
				}
				om(e);
			};
			fn_mouse_up = function (e) {
				if (onUp(e)) {
					e.preventDefault();
					return;
				}
				ou(e);
			};
		}
		if (typeof fn_clear_box === 'function') {
			var oc = fn_clear_box;
			fn_clear_box = function () {
				oc.apply(this, arguments);
				if (!suppressPaint) {
					paint();
				}
			};
		}
		if (typeof fn_init_draw_image === 'function') {
			var oi = fn_init_draw_image;
			fn_init_draw_image = function () {
				oi.apply(this, arguments);
				window.setTimeout(loadAll, 50);
			};
		}
	}

	function bindUi() {
		if (READONLY) {
			return;
		}
		$(document).on('click', '.anno-mode-btn', function () {
			setMode($(this).attr('data-anno-mode'));
		});
		$(document).on('click', '.anno-marker-palette .anno-swatch', function () {
			$('.anno-marker-palette .anno-swatch').removeClass('active');
			$(this).addClass('active');
			color = $(this).attr('data-anno-color') || color;
			pinColor = $(this).attr('data-pin-color') || pinColor;
		});
		$(document).on('click', '#anno_pin_colors .anno-swatch', function () {
			var c = $(this).attr('data-pin-color');
			if (!c) {
				return;
			}
			pinColor = c;
			if (pinDraft) {
				pinDraft.color = c;
			}
			syncPinColorUi(c);
		});
		$(document).on('click', '#anno_pin_cancel', function () {
			closePinModal();
		});
		$(document).on('click', '#anno_pin_save', function () {
			if (!pinDraft) {
				return;
			}
			var text = $.trim($('#anno_pin_opinion').val() || '');
			if (pinDraft.isNew) {
				var np = {
					id: nextId('pin'),
					inptTaskId: taskId(),
					x: pinDraft.pin.x,
					y: pinDraft.pin.y,
					opinion: text,
					color: pinDraft.color || pinColor || DEFAULT_PIN_COLOR
				};
				pins.push(np);
			} else if (pinDraft.pin) {
				pinDraft.pin.opinion = text;
				pinDraft.pin.color = pinDraft.color || pinDraft.pin.color || pinColor || DEFAULT_PIN_COLOR;
			}
			closePinModal();
			persist();
			paintAfter();
		});
		$(document).on('click', '#anno_pin_delete', function () {
			if (!pinDraft || !pinDraft.pin || pinDraft.isNew) {
				return;
			}
			if (!window.confirm('이 핀을 삭제할까요?')) {
				return;
			}
			var id = pinDraft.pin.id;
			pins = pins.filter(function (p) { return p.id !== id; });
			closePinModal();
			persist();
			paintAfter();
		});
		$(document).on('keydown', function (e) {
			if (!selected || selected.type !== 'marker') {
				return;
			}
			if (e.keyCode !== 46 && e.keyCode !== 8) {
				return;
			}
			if ($(e.target).is('input, textarea, select')) {
				return;
			}
			e.preventDefault();
			deleteMarker(findMarker(selected.id));
		});
		setMode('navigate');
	}

	function init() {
		wrapGenesis();
		if (READONLY) {
			bindReadonlyView();
		} else {
			bindUi();
		}
		if (document.fonts && document.fonts.load) {
			document.fonts.load('22px FontAwesome').then(function () {
				redraw();
			});
		}
	}

	return {
		init: init,
		paint: paint,
		loadAll: loadAll
	};
})(window, window.jQuery);

if (window.jQuery) {
	window.jQuery(function () {
		DetailAnno.init();
	});
}
