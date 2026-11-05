/* 심사상세 형광펜 · 핀 고정 */
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

	function paint() {
		var g = window.ctx_global;
		var c = document.getElementById('canvas');
		if (!g || !c) {
			return;
		}
		var i, p, pts, j, cp, pin, txt;
		var mks = pageMarkers();
		for (i = 0; i < mks.length; i++) {
			pts = mks[i].points || [];
			if (pts.length < 2) {
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
		if (stroke && stroke.points && stroke.points.length > 1) {
			pts = stroke.points;
			g.save();
			g.lineCap = 'round';
			g.lineJoin = 'round';
			g.strokeStyle = color;
			g.lineWidth = widthPx * (c.width / (srcSize().w || c.width));
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
		var pns = pagePins();
		for (i = 0; i < pns.length; i++) {
			pin = pns[i];
			p = toCanvas(pin.x, pin.y);
			g.save();
			var fill = pinFill(pin);
			var head = drawThumbtack(g, p, !!(selected && selected.type === 'pin' && selected.id === pin.id), fill);
			if (pin.opinion) {
				txt = String(pin.opinion);
				if (txt.length > 28) {
					txt = txt.slice(0, 28) + '…';
				}
				g.font = '11px Malgun Gothic, sans-serif';
				g.textAlign = 'left';
				g.textBaseline = 'middle';
				var tw = g.measureText(txt).width + 10;
				var boxH = 18;
				var boxY = Math.round(head.midY - boxH / 2);
				g.fillStyle = '#fff';
				g.strokeStyle = fill;
				g.lineWidth = 1.5;
				g.beginPath();
				g.rect(head.boxX, boxY, tw, boxH);
				g.fill();
				g.stroke();
				g.fillStyle = '#333';
				g.fillText(txt, head.boxX + 5, head.midY);
			}
			g.restore();
		}
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
		for (i = mks.length - 1; i >= 0; i--) {
			pts = mks[i].points || [];
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
			paint();
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
			paint();
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
		if (mode === 'marker') hint = '드래그하여 형광펜을 그립니다.';
		else if (mode === 'pin') hint = '색상을 고른 뒤 클릭한 위치에 핀을 고정합니다.';
		else hint = '핀·형광펜 드래그=이동 · 핀 클릭=의견 · 빈 곳 드래그=화면 이동';
		$('#annoHint').text(hint);
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
			selected = null;
			return false;
		}
		dragging = true;
		src = toSource(mousePos(e).x, mousePos(e).y);
		if (mode === 'marker') {
			stroke = { points: [[src.x, src.y]] };
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
		if (!dragging || mode !== 'marker' || !stroke) {
			return false;
		}
		src = toSource(mousePos(e).x, mousePos(e).y);
		last = stroke.points[stroke.points.length - 1];
		if (!last || Math.abs(last[0] - src.x) > 1 || Math.abs(last[1] - src.y) > 1) {
			stroke.points.push([src.x, src.y]);
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
			markers.push({
				id: nextId('mk'),
				inptTaskId: taskId(),
				points: stroke.points,
				color: color,
				width: widthPx
			});
			stroke = null;
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

	function paintAfter() {
		if (typeof fn_clear_box === 'function') {
			fn_clear_box();
		}
		if (typeof fn_draw_multi_box === 'function') {
			fn_draw_multi_box();
		}
		paint();
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
				paint();
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
			if (!window.confirm('선택한 형광펜을 삭제할까요?')) {
				return;
			}
			var id = selected.id;
			markers = markers.filter(function (m) { return m.id !== id; });
			selected = null;
			persist();
			paintAfter();
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
				paint();
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
