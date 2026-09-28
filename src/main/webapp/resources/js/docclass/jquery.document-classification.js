/**
 * jQuery Document Classification Plugin V4
 * 문서분류·그룹 일괄 변경 UI 컴포넌트
 *
 * V3 대비 변경:
 *   - 좌측: 문서분류 세로 탭(12종 + 미분류)
 *   - 우측: BL1, BL2 … 가로 탭 + 가로 썸네일 1행
 *   - 이동: 심사상세와 같이 문서분류·BL 콤보 선택 후 [이동]
 *   - BL 탭 직접 삭제·◀▶ 화살표 없음
 *   - 저장 Payload 계약은 V2/V3와 동일
 *
 * Usage:
 *   $('#board').documentClassification({ loadUrl: '...', saveUrl: '...' });
 *   $('#board').documentClassification('moveSelectedByCombo');
 *   $('#board').documentClassification('moveSelectedToActive');
 *   $('#board').documentClassification('getSavePayload');
 *
 * @requires jQuery
 */
(function (factory) {
  'use strict';
  if (typeof window.jQuery === 'undefined') {
    console.error('[documentClassification] jQuery가 필요합니다. vendor/jquery 또는 호스트 jQuery를 먼저 로드하세요.');
    return;
  }
  factory(window.jQuery, window, document);
})(function ($, window, document) {
  'use strict';

  var PLUGIN = 'documentClassification';
  var DATA_KEY = 'dcPlugin';
  var ETC_GROUP_ID = 'ETC';
  var ETC_DOC_TYPE = 'ETC';
  var CHANGE_LOG_MAX = 100;
  var TINY_GIF = 'data:image/gif;base64,R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7';
  var BUCKET_GAP = 6;
  var PREVIEW_ZOOM_MIN = 0.25;
  var PREVIEW_ZOOM_MAX = 5;
  var PREVIEW_ZOOM_STEP = 0.1;
  var PREVIEW_ZOOM_BUTTON = 0.25;
  var DEFAULT_DOCUMENT_TYPES = [
    { key: 'BL', label: 'Bill of Lading', imexHisCd: '01' },
    { key: 'INV', label: 'Invoice', imexHisCd: '02' },
    { key: 'PL', label: 'Packing List', imexHisCd: '03' },
    { key: 'CO', label: 'Certificate of Origin', imexHisCd: '04' },
    { key: 'AWB', label: 'Air Waybill', imexHisCd: '05' },
    { key: 'LC', label: 'Letter of Credit', imexHisCd: '06' },
    { key: 'IC', label: 'Insurance Certificate', imexHisCd: '07' },
    { key: 'MF', label: 'Manifest', imexHisCd: '08' },
    { key: 'DO', label: 'Delivery Order', imexHisCd: '09' },
    { key: 'PO', label: 'Purchase Order', imexHisCd: '10' },
    { key: 'SN', label: 'Shipping Note', imexHisCd: '11' },
    { key: 'OT', label: 'Other', imexHisCd: '99' }
  ];

  var DEFAULTS = {
    loadUrl: null,
    saveUrl: null,
    data: null,
    autoLoad: true,
    mockTransport: null,
    documentTypes: null,
    groupTypes: null,
    showEmptyBuckets: true,
    confirmDelete: true,
    confirmMove: false,
    includeAllBlGroupsInMoveCombo: true,
    renumberAfterEmptyDelete: true,
    readOnly: false,
    allowDragDrop: true,
    allowBucketReorder: false,
    allowGroupAdd: true,
    allowDelete: true,
    showGuide: true,
    showChangeLog: true,
    showJsonPreview: true,
    showEtcPane: true,
    showEtcFilters: true,
    etcFilterColumns: [
      { key: 'inptMstSrno', placeholder: 'INPT_MST_SRNO', title: '심사마스터 REQ.NO' },
      { key: 'inptTaskId', placeholder: 'INPT_TASK_ID', title: '이미지 일련번호' },
      { key: 'imexHisCd', placeholder: 'IMEX_HIS_CD', title: '문서분류 코드' }
    ],
    emptyBucketMessage: '문서분류 이미지가 없습니다',
    maxGroups: null,
    allowedGroupTypes: null,
    thumbnailWidth: 128,
    thumbnailImageHeight: 96,
    sourcePaneWidth: 160,
    typeTabFontSize: 11,
    refNoFontSize: 12,
    bucketColumns: 3,
    newInflowPosition: 'top',
    showNewLabel: true,
    showThumbTitle: true,
    showThumbTaskId: true,
    saveDatasetMode: 'delta',
    includeChangeHistory: false,
    deferJsonPreview: true,
    cloneOnChange: false,
    showPerfStats: true,
    lazyThumbs: true,
    allowImagePreview: true,
    showPreviewMeta: true,
    previewMetaMessage: 'Ctrl + 휠로 확대·축소',
    showRefNoBar: true,
    refNoBarBoxed: true,
    rememberDocTypeScroll: false,
    onLoaded: null,
    onChanged: null,
    onSaved: null,
    onError: null
  };

  function deepClone(obj) {
    return JSON.parse(JSON.stringify(obj));
  }

  function escapeHtml(str) {
    return String(str == null ? '' : str)
      .replace(/&/g, '&amp;')
      .replace(/</g, '&lt;')
      .replace(/>/g, '&gt;')
      .replace(/"/g, '&quot;');
  }

  function cssEscape(value) {
    var str = String(value == null ? '' : value);
    if (window.CSS && typeof window.CSS.escape === 'function') {
      return window.CSS.escape(str);
    }
    return str.replace(/"/g, '\\"');
  }

  function nowIso() {
    return new Date().toISOString();
  }

  function nowMs() {
    return window.performance && typeof window.performance.now === 'function'
      ? window.performance.now()
      : Date.now();
  }

  function DocumentClassification($el, options) {
    this.$el = $el;
    this.options = $.extend(true, {}, DEFAULTS, options);
    this.options.saveDatasetMode = String(this.options.saveDatasetMode).toLowerCase() === 'full'
      ? 'full'
      : 'delta';
    this.options.showChangeLog = this.options.showChangeLog === true;
    this.options.showGuide = this.options.showGuide === true;
    this.options.showJsonPreview = this.options.showJsonPreview === true;
    this.state = {
      original: null,
      data: null,
      changes: [],
      changeLog: [],
      deletions: { groups: [], buckets: [], pages: [] },
      groupRenames: [],
      sessionCreatedGroups: {},
      dirty: false,
      loading: false,
      saving: false,
      dragPageId: null,
      dragSourceGroup: null,
      dragSourceDocType: null,
      dropInsertIndex: null,
      thumbCache: {},
      pageIndex: {},
      pageById: {},
      groupOrder: {},
      selected: {},
      rightSelected: {},
      blAccumulate: false,
      lastCheckedPageId: null,
      lastRightCheckedPageId: null,
      suppressBoardClick: false,
      tableFilter: {},
      activeGroupId: null,
      activeDocType: null,
      lastWorkingDocType: null,
      blockTypeChoice: {},
      bucketScroll: {},
      docTypeScroll: {},
      boardScrollTop: 0,
      sourceScrollTop: 0,
      suppressScrollCapture: false,
      jsonDirty: { loaded: false, save: false },
      lastRenderMode: 'full',
      lastRenderMs: 0,
      thumbObserver: null,
      newDocTypes: {}
    };
    this.options.newInflowPosition = this._normalizeNewInflowPosition(this.options.newInflowPosition);
    this.options.etcFilterColumns = this._normalizeEtcFilterColumns(this.options.etcFilterColumns);
    this.state.tableFilter = this._emptyTableFilter();
    this._buildShell();
    this._bindEvents();
    this._ensureThumbObserver();
    if (this.options.data) {
      this.setData(this.options.data);
    } else if (this.options.autoLoad && (this.options.loadUrl || this.options.mockTransport)) {
      this.load();
    }
  }

  DocumentClassification.prototype._buildShell = function () {
    var html =
      '<div class="dc-root">' +
      '  <div class="dc-status" hidden></div>' +
      '  <div class="dc-perf" hidden></div>' +
      '  <div class="dc-guide"></div>' +
      '  <div class="dc-refno-bar" data-dc-mst-key-wrap title="INPT_MST_SRNO">' +
      '    <span class="dc-refno-label">Ref.No</span>' +
      '    <strong class="dc-refno-value" data-dc-mst-key>-</strong>' +
      '  </div>' +
      '  <div class="dc-workspace dc-workspace-v4">' +
      '    <aside class="dc-type-pane">' +
      '      <div class="dc-type-tabs" data-dc-type-tabs></div>' +
      '    </aside>' +
      '    <section class="dc-group-pane">' +
      '      <div class="dc-move-bar">' +
      '        <label class="dc-move-field dc-move-field-doc">' +
      '          <span>문서분류</span>' +
      '          <select data-dc-move-doc-type></select>' +
      '        </label>' +
      '        <div class="dc-move-bar-end">' +
      '          <label class="dc-move-field dc-move-field-bl">' +
      '            <span>BL그룹</span>' +
      '            <select data-dc-move-group></select>' +
      '          </label>' +
      '          <button type="button" class="dc-move-apply-btn" data-dc-reclassify title="선택한 이미지를 문서분류·BL로 이동">이동</button>' +
      '        </div>' +
      '      </div>' +
      '      <div class="dc-group-head">' +
      '        <div class="dc-group-tabs" data-dc-group-tabs></div>' +
      '        <button type="button" class="dc-add-group-btn dc-add-group-inline" title="BL 그룹 추가">' +
      '          <span class="dc-add-group-icon">+</span><span>그룹</span>' +
      '        </button>' +
      '        <label class="dc-bl-accumulate" title="켜면 BL 탭을 바꿔도 이전 BL에서 고른 선택이 유지됩니다">' +
      '          <input type="checkbox" data-dc-bl-accumulate />' +
      '          <span>누적</span>' +
      '        </label>' +
      '      </div>' +
      '      <div class="dc-check-bar">' +
      '        <span class="dc-group-strip-title" data-dc-group-strip-title>이미지</span>' +
      '        <span class="dc-check-count" data-dc-selected-count>0건 선택</span>' +
      '        <button type="button" class="dc-clear-sel" data-dc-select-all title="현재 문서분류 × BL 스트립 이미지 전체 선택">전체 선택</button>' +
      '        <button type="button" class="dc-clear-sel" data-dc-clear-sel>선택 해제</button>' +
      '      </div>' +
      '      <div class="dc-board dc-section-body dc-group-strip" data-dc-group-strip data-drop-zone="group"></div>' +
      '    </section>' +
      '  </div>' +
      '  <div class="dc-log-wrap">' +
      '    <div class="dc-log-title">변경 이력 (저장 전)</div>' +
      '    <div class="dc-log"></div>' +
      '  </div>' +
      '  <div class="dc-json-wrap">' +
      '    <div class="dc-json-tabs">' +
      '      <button type="button" class="dc-json-tab active" data-dc-json="loaded">조회 JSON</button>' +
      '      <button type="button" class="dc-json-tab" data-dc-json="save">저장 Payload</button>' +
      '    </div>' +
      '    <pre class="dc-json-view" data-dc-json-pane="loaded"></pre>' +
      '    <pre class="dc-json-view" data-dc-json-pane="save" hidden></pre>' +
      '  </div>' +
      '  <div class="dc-image-preview" data-dc-image-preview hidden>' +
      '    <div class="dc-image-preview-backdrop" data-dc-preview-close></div>' +
      '    <div class="dc-image-preview-dialog" role="dialog" aria-modal="true" aria-label="이미지 미리보기">' +
      '      <div class="dc-image-preview-head">' +
      '        <div class="dc-image-preview-title" data-dc-preview-title></div>' +
      '        <div class="dc-image-preview-tools">' +
      '          <button type="button" class="dc-image-preview-zoom-btn" data-dc-preview-zoom="out" title="축소">−</button>' +
      '          <span class="dc-image-preview-zoom-label" data-dc-preview-zoom-label>100%</span>' +
      '          <button type="button" class="dc-image-preview-zoom-btn" data-dc-preview-zoom="in" title="확대">+</button>' +
      '          <button type="button" class="dc-image-preview-zoom-btn dc-image-preview-zoom-reset" data-dc-preview-zoom="reset" title="화면 맞춤 (Ctrl+0)">맞춤</button>' +
      '        </div>' +
      '        <button type="button" class="dc-image-preview-close" data-dc-preview-close title="닫기">×</button>' +
      '      </div>' +
      '      <div class="dc-image-preview-body" data-dc-preview-body></div>' +
      '      <div class="dc-image-preview-meta" data-dc-preview-meta></div>' +
      '    </div>' +
      '  </div>' +
      '</div>';
    this.$el.empty().append(html);
    this.$root = this.$el.find('.dc-root');
    this.$board = this.$root.find('[data-dc-group-strip]');
    this.$sourceThumbs = $();
    this.$tableWrap = $();
    this.$tableBody = $();
    this.$typeTabs = this.$root.find('[data-dc-type-tabs]');
    this.$groupTabs = this.$root.find('[data-dc-group-tabs]');
    this.$moveDocType = this.$root.find('[data-dc-move-doc-type]');
    this.$moveGroup = this.$root.find('[data-dc-move-group]');
    this.$log = this.$root.find('.dc-log');
    this.$status = this.$root.find('.dc-status');
    this.$perf = this.$root.find('.dc-perf');
    this.$jsonLoaded = this.$root.find('[data-dc-json-pane="loaded"]');
    this.$jsonSave = this.$root.find('[data-dc-json-pane="save"]');
    this.$guide = this.$root.find('.dc-guide');
    this.$addGroupWrap = this.$root.find('.dc-add-group-inline');
    this.$logWrap = this.$root.find('.dc-log-wrap');
    this.$jsonWrap = this.$root.find('.dc-json-wrap');
    this.$workspace = this.$root.find('.dc-workspace');
    this.$transferRail = $();
    this.$sourcePane = this.$root.find('.dc-type-pane');
    this.$sourceFilters = $();
    this.$showEtcBtn = $();
    this.$imagePreview = this.$root.find('[data-dc-image-preview]');
    this._applyOptionVisibility();
    this._renderPreviewMeta();
  };

  DocumentClassification.prototype._isEditable = function () {
    return !this.options.readOnly;
  };

  DocumentClassification.prototype._canDragDrop = function () {
    return this._isEditable() && this.options.allowDragDrop;
  };

  DocumentClassification.prototype._canBucketReorder = function () {
    return this._canDragDrop() && !!this.options.allowBucketReorder;
  };

  DocumentClassification.prototype._canAddGroup = function () {
    if (!this._isEditable() || !this.options.allowGroupAdd) return false;
    if (typeof this.options.maxGroups === 'number' &&
        this.state.data &&
        this.state.data.groups.length >= this.options.maxGroups) {
      return false;
    }
    return true;
  };

  DocumentClassification.prototype._canDelete = function () {
    return this._isEditable() && this.options.allowDelete;
  };

  DocumentClassification.prototype._canCheckMove = function () {
    return this._isEditable();
  };

  DocumentClassification.prototype._deletionKey = function (type, row) {
    if (type === 'groups') return row.groupId;
    if (type === 'buckets') return row.groupId + '::' + row.documentType;
    return row.pageId;
  };

  DocumentClassification.prototype._recordDeletion = function (type, row) {
    var list = this.state.deletions[type];
    var key = this._deletionKey(type, row);
    if (!list.some(function (item) {
      return this._deletionKey(type, item) === key;
    }, this)) {
      list.push(deepClone(row));
    }
  };

  DocumentClassification.prototype._removeDeletion = function (type, row) {
    var key = this._deletionKey(type, row);
    this.state.deletions[type] = this.state.deletions[type].filter(function (item) {
      return this._deletionKey(type, item) !== key;
    }, this);
  };

  DocumentClassification.prototype._normalizeSize = function (value, fallback, min, max) {
    var number = parseInt(value, 10);
    if (isNaN(number)) number = fallback;
    return Math.max(min, Math.min(max, number));
  };

  DocumentClassification.prototype._normalizeBucketColumns = function (value) {
    if (value == null || value === '' || value === 'auto') return null;
    var number = parseInt(value, 10);
    if (isNaN(number) || number < 1) return null;
    return Math.max(1, Math.min(6, number));
  };

  DocumentClassification.prototype._applySizeOptions = function () {
    if (!this.$root || !this.$root[0]) return;
    this.options.bucketColumns = this._normalizeBucketColumns(this.options.bucketColumns);
    var sizes = {
      thumbnailWidth: this._normalizeSize(this.options.thumbnailWidth, 128, 48, 200),
      thumbnailImageHeight: this._normalizeSize(this.options.thumbnailImageHeight, 96, 40, 240),
      sourcePaneWidth: this._normalizeSize(this.options.sourcePaneWidth, 160, 120, 280),
      typeTabFontSize: this._normalizeSize(this.options.typeTabFontSize, 11, 9, 18),
      refNoFontSize: this._normalizeSize(this.options.refNoFontSize, 12, 10, 20)
    };

    Object.keys(sizes).forEach(function (key) {
      this.options[key] = sizes[key];
    }, this);

    var tabPadY = Math.max(4, Math.round(sizes.typeTabFontSize * 0.55));
    var tabPadX = Math.max(6, Math.round(sizes.typeTabFontSize * 0.75));
    var refNoLabel = Math.max(9, sizes.refNoFontSize - 1);
    var refNoPadY = Math.max(4, Math.round(sizes.refNoFontSize * 0.5));
    var refNoPadX = Math.max(8, Math.round(sizes.refNoFontSize * 0.75));

    var style = this.$root[0].style;
    style.setProperty('--dc-thumb-width', sizes.thumbnailWidth + 'px');
    style.setProperty('--dc-thumb-image-height', sizes.thumbnailImageHeight + 'px');
    style.setProperty('--dc-thumb-label-height', '12px');
    style.setProperty('--dc-thumb-label-font', '8px');
    style.setProperty('--dc-source-pane-width', sizes.sourcePaneWidth + 'px');
    style.setProperty('--dc-type-pane-width', sizes.sourcePaneWidth + 'px');
    style.setProperty('--dc-type-tab-font', sizes.typeTabFontSize + 'px');
    style.setProperty('--dc-type-tab-pad-y', tabPadY + 'px');
    style.setProperty('--dc-type-tab-pad-x', tabPadX + 'px');
    style.setProperty('--dc-refno-font', sizes.refNoFontSize + 'px');
    style.setProperty('--dc-refno-label-font', refNoLabel + 'px');
    style.setProperty('--dc-refno-pad-y', refNoPadY + 'px');
    style.setProperty('--dc-refno-pad-x', refNoPadX + 'px');
    style.setProperty('--dc-source-gap', BUCKET_GAP + 'px');
    this.$root.attr('data-dc-bucket-cols', 'auto');
  };

  DocumentClassification.prototype._updateGuideText = function () {
    if (!this.$guide || !this.$guide.length) return;
    this.$guide.html(
      '<strong>조회</strong> — 좌측 <em>문서분류</em> 탭 → 우측 <em>BL</em> 탭(미분류도 BL1 기본) · ' +
      '<strong>이동</strong> — 이미지 선택 후 상단 <em>문서분류·BL 콤보</em>를 고르고 <em>이동</em> (BL 콤보는 해당 분류 건수+1, 다음 그룹 선택 시 생성) · ' +
      '<strong>미리보기</strong> — 썸네일 더블클릭 · ' +
      '<strong>다중 선택</strong> — Shift+클릭 · ' +
      '<strong>순서</strong> — ' +
      (this._canBucketReorder()
        ? '같은 스트립 안 가로 드래그로 정렬 · '
        : '기본 정렬 안 함 (옵션 allowBucketReorder) · ') +
      '<strong>새 BL</strong> — 이동 콤보에 다음 그룹(건수+1)이 포함됨 (BL2 선택·이동 시 생성)'
    );
  };

  DocumentClassification.prototype._applyOptionVisibility = function () {
    if (!this.$root) return;
    this._applySizeOptions();
    this._updateGuideText();
    this.$root.toggleClass('dc-read-only', !!this.options.readOnly);
    this.$guide.toggle(!!this.options.showGuide);
    if (this.$addGroupWrap && this.$addGroupWrap.length) {
      // V4: 새 BL은 이동 콤보(건수+1)로 생성·할당. +그룹 버튼은 숨김.
      this.$addGroupWrap.hide();
    }
    this.$root.toggleClass('dc-hide-changelog', !this.options.showChangeLog);
    this.$logWrap.toggle(!!this.options.showChangeLog);
    if (this.options.showChangeLog) {
      this.$logWrap.removeAttr('hidden');
    } else {
      this.$logWrap.attr('hidden', 'hidden');
    }
    this.$jsonWrap.toggle(!!this.options.showJsonPreview);
    if (!this.options.showPerfStats) {
      this.$perf.attr('hidden', true).text('');
    }
    this.$root.find('[data-dc-move-doc-type], [data-dc-reclassify]')
      .prop('disabled', !this._canCheckMove());
    this.$root.find('[data-dc-select-all], [data-dc-clear-sel], [data-dc-bl-accumulate]')
      .prop('disabled', !this._canCheckMove());
    this.$root.find('.dc-move-bar').toggle(this._isEditable());
    this.$root.find('.dc-check-bar').toggle(this._isEditable());
    this.$root.find('.dc-bl-accumulate').toggle(this._isEditable());
    this.$root.toggleClass('dc-hide-thumb-title', !this._showThumbTitle());
    this.$root.toggleClass('dc-hide-thumb-task-id', !this._showThumbTaskId());
    this._syncMoveGroupComboState();
  };

  DocumentClassification.prototype._applyEtcPaneVisibility = function () {
    // V4: ETC는 좌측 탭. 화살표 레일 없음
  };

  DocumentClassification.prototype.setEtcPaneVisible = function (visible) {
    this.options.showEtcPane = !!visible;
    this._applyEtcPaneVisibility();
    this._trigger('optionsChanged', this.getOptions());
    return this;
  };

  DocumentClassification.prototype.toggleEtcPane = function () {
    return this.setEtcPaneVisible(this.options.showEtcPane === false);
  };

  DocumentClassification.prototype._activeDocTypeLabel = function () {
    var dtype = this.state.activeDocType;
    if (!dtype) return '';
    var meta = this._getDocTypeMeta(dtype);
    return (meta && meta.label) || dtype;
  };

  DocumentClassification.prototype._groupTitleHtml = function (group) {
    var base = escapeHtml(group.label || group.groupId);
    var isActive = this.state.activeGroupId === group.groupId && !!this.state.activeDocType;
    if (!isActive) return base;
    var docLabel = this._activeDocTypeLabel();
    if (!docLabel) return base;
    return base +
      '<span class="dc-active-doc-tag" title="선택된 문서분류">' +
      escapeHtml(docLabel) +
      '</span>';
  };

  DocumentClassification.prototype._ensureActiveTarget = function () {
    if (!this.state.data) {
      this.state.activeGroupId = null;
      this.state.activeDocType = null;
      return;
    }
    if (!this.state.activeDocType) {
      this.state.activeDocType = this._defaultDocType();
    }
    if (this.state.activeDocType !== ETC_DOC_TYPE) {
      this.state.lastWorkingDocType = this.state.activeDocType;
    } else if (!this.state.lastWorkingDocType) {
      this.state.lastWorkingDocType = this._defaultDocType();
    }

    var visible = this._visibleBlGroupsForDocType(this.state.activeDocType, { includeEmptyActive: true });
    var exists = visible.some(function (g) {
      return String(g.groupId) === String(this.state.activeGroupId || '');
    }, this);
    if (!exists) {
      this.state.activeGroupId = visible.length ? visible[0].groupId : null;
    }
  };

  /**
   * 문서분류별로 사용하는 BL 그룹 목록.
   * 해당 문서분류 이미지가 1건 이상인 그룹 (+ 방금 추가한 빈 활성 그룹).
   */
  DocumentClassification.prototype._groupsForDocType = function (docType, options) {
    options = options || {};
    var includeEmptyActive = options.includeEmptyActive !== false;
    var dtype = String(docType || '');
    if (!dtype) return [];
    var groups = ((this.state.data && this.state.data.groups) || []).slice()
      .filter(function (g) {
        return g && g.groupId && g.groupId !== ETC_GROUP_ID && g.groupType !== 'ETC';
      })
      .sort(function (a, b) { return (a.sortOrder || 0) - (b.sortOrder || 0); });
    var activeId = String(this.state.activeGroupId || '');
    return groups.filter(function (g) {
      var count = this._pagesInBucket(g.groupId, dtype).length;
      if (count > 0) return true;
      // includeEmptyActive: 해당 분류 0건이어도, 그룹 전체도 0건인 활성 그룹만 표시
      // (다른 분류 이미지가 있는 그룹을 "빈 탭"으로 끌고 오지 않음)
      if (includeEmptyActive && activeId && String(g.groupId) === activeId) {
        return this._pagesInGroup(g.groupId).length === 0;
      }
      return false;
    }, this);
  };

  /** 기본 BL 그룹 ID (없으면 생성·할당 기준: BL1). */
  DocumentClassification.prototype._defaultBlGroupId = function () {
    var typeMeta = this._getGroupTypeMeta('BL');
    var prefix = (typeMeta && typeMeta.key) ? typeMeta.key : 'BL';
    return prefix + '1';
  };

  DocumentClassification.prototype._findGroupById = function (groupId) {
    groupId = String(groupId || '');
    if (!groupId || !this.state.data || !Array.isArray(this.state.data.groups)) return null;
    for (var i = 0; i < this.state.data.groups.length; i++) {
      if (String(this.state.data.groups[i].groupId) === groupId) return this.state.data.groups[i];
    }
    return null;
  };

  /**
   * 해당 문서분류 기준 다음 BL 그룹 ID (기존 최대 번호 + 1).
   * 예: BL1만 있으면 BL2, BL1·BL2면 BL3.
   */
  DocumentClassification.prototype._nextBlGroupIdForDocType = function (docType, existingGroups) {
    var typeMeta = this._getGroupTypeMeta('BL');
    var prefix = (typeMeta && typeMeta.key) ? typeMeta.key : 'BL';
    var maxNum = 0;
    var list = existingGroups || this._groupsForDocType(docType, { includeEmptyActive: false });
    list.forEach(function (g) {
      var m = String(g.groupId || '').match(new RegExp('^' + prefix + '(\\d+)$', 'i'));
      if (m) maxNum = Math.max(maxNum, parseInt(m[1], 10));
    });
    return prefix + (maxNum + 1);
  };

  /**
   * 조회 탭용 BL 목록.
   * 해당 문서분류 이미지가 있는 그룹(+ 빈 활성 그룹).
   * 건수가 하나도 없으면 기본 BL1을 화면용으로 표시한다(데이터 생성은 이동 시).
   */
  DocumentClassification.prototype._visibleBlGroupsForDocType = function (docType, options) {
    var dtype = String(docType || '');
    if (!dtype) return [];
    var groups = this._groupsForDocType(dtype, options);
    if (groups.length) return groups;
    var defaultId = this._defaultBlGroupId();
    var existing = this._findGroupById(defaultId);
    if (existing) return [existing];
    return [{ groupId: defaultId, label: defaultId, groupType: 'BL' }];
  };

  /**
   * 이동 콤보용 BL 목록.
   * - includeAllBlGroupsInMoveCombo(기본 true): 전역 기존 BL + 다음 그룹(N+1)
   * - false면 해당 분류에 이미지가 있는 그룹(+N+1). 없으면 BL1만
   */
  DocumentClassification.prototype._moveSelectableGroups = function (docType) {
    var dtype = String(docType || '');
    if (!dtype) return [];
    var includeAll = this.options.includeAllBlGroupsInMoveCombo !== false;
    var real = this._groupsForDocType(dtype, { includeEmptyActive: false });
    var list = [];
    var seen = {};

    function pushGroup(g) {
      if (!g || !g.groupId || seen[g.groupId]) return;
      seen[g.groupId] = true;
      list.push(g);
    }

    if (includeAll) {
      ((this.state.data && this.state.data.groups) || []).slice()
        .filter(function (g) {
          return g && g.groupId && g.groupId !== ETC_GROUP_ID && g.groupType !== 'ETC';
        })
        .sort(function (a, b) { return (a.sortOrder || 0) - (b.sortOrder || 0); })
        .forEach(pushGroup);
    } else {
      real.forEach(pushGroup);
    }

    if (!list.length) {
      var defaultId = this._defaultBlGroupId();
      var existing = this._findGroupById(defaultId);
      return [existing || { groupId: defaultId, label: defaultId, groupType: 'BL' }];
    }

    var nextId = this._nextBlGroupIdForDocType(
      dtype,
      this._groupsForDocType(dtype, { includeEmptyActive: false })
    );
    if (!seen[nextId]) {
      var nextExisting = this._findGroupById(nextId);
      if (!nextExisting &&
          typeof this.options.maxGroups === 'number' &&
          this.state.data &&
          this.state.data.groups.length >= this.options.maxGroups) {
        return list;
      }
      // allowGroupAdd=false 이면 신규 N+1(아직 없는 그룹)은 콤보에 넣지 않음
      if (!nextExisting && this.options.allowGroupAdd === false) {
        return list;
      }
      list.push(nextExisting || { groupId: nextId, label: nextId, groupType: 'BL' });
    }
    return list;
  };

  /**
   * 이동 대상 BL 그룹이 없으면 생성한다 (콤보에 미리 보인 BL1 등).
   * @returns {object|null} group
   */
  DocumentClassification.prototype._ensureBlGroupExists = function (groupId) {
    groupId = String(groupId || '');
    if (!groupId || groupId === ETC_GROUP_ID || !this.state.data) return null;
    var existing = this._findGroupById(groupId);
    if (existing) return existing;

    if (typeof this.options.maxGroups === 'number' &&
        this.state.data.groups.length >= this.options.maxGroups) {
      this._setStatus('최대 그룹 수(' + this.options.maxGroups + ')에 도달했습니다.', 'warn');
      return null;
    }
    if (this.options.allowGroupAdd === false) {
      this._setStatus('그룹 추가가 허용되지 않았습니다.', 'warn');
      return null;
    }

    var m = groupId.match(/^([A-Za-z]+)(\d+)$/);
    var prefix = m ? m[1].toUpperCase() : 'BL';
    var typeMeta = this._getGroupTypeMeta(prefix);
    var group = {
      groupId: groupId,
      inptBlGrpNo: groupId,
      groupType: typeMeta.key || prefix,
      label: groupId,
      sortOrder: this.state.data.groups.length,
      buckets: []
    };
    this._removeDeletion('groups', { groupId: groupId });
    this.state.deletions.buckets = this.state.deletions.buckets.filter(function (bucket) {
      return bucket.groupId !== groupId;
    });
    this._ensureGroupBuckets(group);
    this.state.data.groups.push(group);
    this.state.groupOrder[groupId] = this.state.groupOrder[groupId] || [];
    if (!this.state.sessionCreatedGroups) this.state.sessionCreatedGroups = {};
    var inOriginal = !!(this.state.original && (this.state.original.groups || []).some(function (g) {
      return String(g.groupId) === groupId;
    }));
    if (!inOriginal) {
      this.state.sessionCreatedGroups[groupId] = true;
    }
    if (!this.state.blockTypeChoice[groupId]) {
      this.state.blockTypeChoice[groupId] = this._workingDocType();
    }
    this._rebuildPageIndex();
    return group;
  };

  DocumentClassification.prototype.setActiveTarget = function (groupId, documentType) {
    if (groupId && groupId !== ETC_GROUP_ID) this.state.activeGroupId = String(groupId);
    if (documentType) {
      this.state.activeDocType = String(documentType);
      if (documentType !== ETC_DOC_TYPE) this.state.lastWorkingDocType = String(documentType);
    }
    this._syncActiveDom();
    return this;
  };

  DocumentClassification.prototype._workingDocType = function () {
    if (this.state.activeDocType && this.state.activeDocType !== ETC_DOC_TYPE) {
      return this.state.activeDocType;
    }
    return this.state.lastWorkingDocType || this._defaultDocType();
  };

  DocumentClassification.prototype._syncActiveDom = function () {
    var gid = this.state.activeGroupId;
    var dtype = this.state.activeDocType;
    if (this.$typeTabs && this.$typeTabs.length) {
      this.$typeTabs.find('.dc-type-tab').removeClass('is-active');
      if (dtype) {
        this.$typeTabs.find('.dc-type-tab[data-doc-type="' + cssEscape(dtype) + '"]').addClass('is-active');
      }
    }
    if (this.$groupTabs && this.$groupTabs.length) {
      this.$groupTabs.find('.dc-group-tab').removeClass('is-active');
      if (gid) {
        this.$groupTabs.find('.dc-group-tab[data-group-id="' + cssEscape(gid) + '"]').addClass('is-active');
      }
    }
    this.$root.toggleClass('dc-type-etc', dtype === ETC_DOC_TYPE);
  };

  DocumentClassification.prototype._bindEvents = function () {
    var self = this;

    this.$root.on('click.dc', '.dc-add-group-btn', function (e) {
      e.stopPropagation();
      if (!self._canAddGroup()) return;
      self.addGroup('BL');
    });

    this.$root.on('click.dc', '.dc-del-group', function (e) {
      e.stopPropagation();
      // V4: BL 탭 직접 삭제 비활성 (심사상세와 동일하게 콤보 이동만)
    });

    this.$root.on('click.dc', '.dc-clear-type-btn', function (e) {
      e.stopPropagation();
      if (!self._canDelete()) return;
      var groupId = String($(this).data('groupId') || '');
      var docType = String($(this).data('docType') || '');
      self.deleteDocumentBucket(groupId, docType);
    });

    this.$root.on('click.dc', '[data-dc-reclassify]', function (e) {
      e.preventDefault();
      if (!self._canCheckMove()) return;
      self.moveSelectedByCombo();
    });

    this.$root.on('change.dc', '[data-dc-move-doc-type]', function () {
      self._fillMoveGroupOptions(String($(this).val() || ''));
      self._syncMoveGroupComboState();
    });

    this.$root.on('click.dc', '.dc-type-tab', function (e) {
      e.preventDefault();
      var docType = String($(this).data('docType') || '');
      if (!docType) return;
      // 전환 전 현재 분류 스크롤 기억(옵션 on 시)
      self._saveStripScrollMemory();
      // 문서분류 탭 전환: 선택 누적 초기화
      self.clearSelection();
      self.state.activeGroupId = null;
      self.setActiveTarget(null, docType);
      self._ensureActiveTarget();
      self._syncMoveCombosFromActive();
      self._renderTypeAndGroupStrips();
      self._applyStripScrollForActive();
    });

    this.$root.on('click.dc', '.dc-group-tab', function (e) {
      e.preventDefault();
      var groupId = String($(this).data('groupId') || '');
      if (!groupId) return;
      var dtype = self.state.activeDocType || self._defaultDocType();
      self._saveStripScrollMemory();
      // BL 탭 전환: 누적 체크 OFF면 선택 초기화, ON이면 유지
      if (!self._isBlAccumulateOn()) {
        self.clearSelection();
      }
      self.setActiveTarget(groupId, dtype);
      self._syncMoveCombosFromActive();
      self._renderTypeAndGroupStrips();
      self._applyStripScrollForActive();
      self._syncSelectionDom();
    });

    this.$root.on('change.dc', '[data-dc-bl-accumulate]', function () {
      self.state.blAccumulate = !!$(this).prop('checked');
      if (!self.state.blAccumulate) {
        self._setStatus('BL 누적 선택이 꺼졌습니다. BL 탭을 바꾸면 선택이 초기화됩니다.', 'info');
      } else {
        self._setStatus('BL 누적 선택이 켜졌습니다. BL 탭을 바꿔도 선택이 유지됩니다.', 'info');
      }
    });

    this.$root.on('click.dc', '.dc-json-tab', function () {
      var key = $(this).data('dcJson');
      self.$root.find('.dc-json-tab').removeClass('active');
      $(this).addClass('active');
      self.$root.find('.dc-json-view').attr('hidden', true);
      self.$root.find('[data-dc-json-pane="' + key + '"]').removeAttr('hidden');
      if (key === 'save') self._refreshSavePreview(true);
      if (key === 'loaded') self._refreshLoadedPreview(true);
    });

    this.$root.on('click.dc', '[data-dc-select-all]', function (e) {
      e.preventDefault();
      self._toggleSelectEntireActiveGroup(true);
    });

    this.$root.on('click.dc', '[data-dc-clear-sel]', function (e) {
      e.preventDefault();
      self.clearSelection();
    });

    this.$board.on('click.dc', '.dc-thumb-card', function (e) {
      if (!self._canCheckMove()) return;
      if (self.state.suppressBoardClick) return;
      var pageId = String($(this).data('pageId') || '');
      self._toggleRightSelection(pageId, e.shiftKey);
    });

    this.$root.on('dblclick.dc', '.dc-thumb-card', function (e) {
      e.preventDefault();
      e.stopPropagation();
      if (self.options.allowImagePreview === false) return;
      self.openImagePreview(String($(this).data('pageId') || ''));
    });

    this.$root.on('click.dc', '[data-dc-preview-close]', function (e) {
      e.preventDefault();
      self.closeImagePreview();
    });

    this.$root.on('click.dc', '[data-dc-preview-zoom]', function (e) {
      e.preventDefault();
      e.stopPropagation();
      var action = String($(this).data('dcPreviewZoom') || '');
      if (action === 'in') self._nudgePreviewZoom(1, PREVIEW_ZOOM_BUTTON);
      else if (action === 'out') self._nudgePreviewZoom(-1, PREVIEW_ZOOM_BUTTON);
      else if (action === 'reset') self._setPreviewZoom(1);
    });

    this.$root.on('click.dc', '.dc-image-preview-dialog', function (e) {
      e.stopPropagation();
    });

    this._onPreviewKeydown = function (e) {
      if (e.key === 'Escape' || e.keyCode === 27) {
        self.closeImagePreview();
        return;
      }
      if (!(e.ctrlKey || e.metaKey)) return;
      var key = e.key || '';
      if (key === '+' || key === '=' || e.keyCode === 187) {
        e.preventDefault();
        self._nudgePreviewZoom(1, PREVIEW_ZOOM_BUTTON);
      } else if (key === '-' || e.keyCode === 189) {
        e.preventDefault();
        self._nudgePreviewZoom(-1, PREVIEW_ZOOM_BUTTON);
      } else if (key === '0' || e.keyCode === 48) {
        e.preventDefault();
        self._setPreviewZoom(1);
      }
    };

    this._onPreviewWheel = function (e) {
      if (!e.ctrlKey && !e.metaKey) return;
      e.preventDefault();
      self._nudgePreviewZoom(e.deltaY > 0 ? -1 : 1, PREVIEW_ZOOM_STEP);
    };

    this.$root.on('dragstart.dc', '.dc-thumb-card', function (e) {
      // 탭 드롭 재분류(allowDragDrop) 또는 스트립 정렬(allowBucketReorder)
      if (!self._canDragDrop() && !self._canBucketReorder()) {
        e.preventDefault();
        return;
      }
      self._onDragStart(e, this);
    });
    this.$root.on('dragend.dc', '.dc-thumb-card', function (e) {
      self._onDragEnd(e, this);
    });
    this.$root.on('dragover.dc', '[data-drop-zone], .dc-type-tab, .dc-group-tab', function (e) {
      if (!self._canBucketReorder() && !self._canDragDrop()) return;
      e.preventDefault();
      e.originalEvent.dataTransfer.dropEffect = 'move';
      if ($(this).is('[data-drop-zone]')) {
        self._updateDropSplitBar(this, e.originalEvent.clientX);
      } else {
        $(this).addClass('dc-drop-over');
      }
    });
    this.$root.on('dragleave.dc', '[data-drop-zone], .dc-type-tab, .dc-group-tab', function (e) {
      if ($(this).is('[data-drop-zone]')) {
        if (!$.contains(this, e.relatedTarget)) {
          self._clearDropSplitBar(this);
        }
      } else if (!$.contains(this, e.relatedTarget)) {
        $(this).removeClass('dc-drop-over');
      }
    });
    this.$root.on('drop.dc', '[data-drop-zone], .dc-type-tab, .dc-group-tab', function (e) {
      if (!self._canBucketReorder() && !self._canDragDrop()) return;
      self._onDrop(e, this);
    });

    this._onBlockScrollCapture = function (e) {
      if (self.state.suppressScrollCapture) return;
      var zone = e.target;
      if (!zone || !zone.classList) return;
      if (zone.getAttribute && zone.getAttribute('data-dc-group-strip') != null) {
        self.state.boardScrollTop = zone.scrollLeft || 0;
        if (self._rememberDocTypeScroll()) {
          var key = self._stripScrollMemoryKey();
          if (key) {
            if (!self.state.docTypeScroll) self.state.docTypeScroll = {};
            self.state.docTypeScroll[key] = self.state.boardScrollTop;
          }
        }
      }
    };
    if (this.$board[0]) {
      this.$board[0].addEventListener('scroll', this._onBlockScrollCapture, true);
    }
  };

  DocumentClassification.prototype._sectionScrollKey = function (el) {
    var $section = $(el).closest('.dc-section');
    if (!$section.length) return '';
    var key = $section.attr('data-bucket');
    if (key) return String(key);
    var groupId = String($section.attr('data-group-id') || '');
    var docType = String($section.attr('data-doc-type') || '');
    if (!groupId || !docType) return '';
    return this._bucketKey(groupId, docType);
  };

  DocumentClassification.prototype._snapshotScrollPositions = function ($scope) {
    var self = this;
    var $root = $scope && $scope.length ? $scope : this.$root;
    var snapshot = {
      boardScrollTop: this.$board && this.$board[0] ? (this.$board[0].scrollLeft || 0) : (this.state.boardScrollTop || 0),
      sourceScrollTop: this.$tableWrap && this.$tableWrap[0]
        ? (this.$tableWrap[0].scrollLeft || this.$tableWrap[0].scrollTop || 0)
        : (this.state.sourceScrollTop || 0),
      bucketScroll: $.extend({}, this.state.bucketScroll || {})
    };
    if ($root && $root.length) {
      $root.find('.dc-section-body').each(function () {
        var key = self._sectionScrollKey(this);
        if (!key) return;
        snapshot.bucketScroll[key] = this.scrollLeft || 0;
      });
    }
    this.state.boardScrollTop = snapshot.boardScrollTop;
    this.state.sourceScrollTop = snapshot.sourceScrollTop;
    this.state.bucketScroll = $.extend({}, snapshot.bucketScroll);
    return snapshot;
  };

  DocumentClassification.prototype._captureScrollPositions = function ($scope) {
    this._snapshotScrollPositions($scope);
  };

  DocumentClassification.prototype._restoreScrollPositions = function ($scope, snapshot) {
    var self = this;
    var snap = snapshot || {
      boardScrollTop: this.state.boardScrollTop,
      sourceScrollTop: this.state.sourceScrollTop,
      bucketScroll: this.state.bucketScroll
    };
    var apply = function () {
      self.state.suppressScrollCapture = true;
      try {
        var $root = $scope && $scope.length ? $scope : self.$root;
        if (self.$board && self.$board[0] && typeof snap.boardScrollTop === 'number') {
          self.$board[0].scrollLeft = snap.boardScrollTop;
        }
        if (self.$tableWrap && self.$tableWrap[0] && typeof snap.sourceScrollTop === 'number') {
          self.$tableWrap[0].scrollLeft = snap.sourceScrollTop;
        }
        if ($root && $root.length) {
          $root.find('.dc-section-body').each(function () {
            var key = self._sectionScrollKey(this);
            if (!key) return;
            if (typeof snap.bucketScroll[key] === 'number') {
              this.scrollLeft = snap.bucketScroll[key];
            }
          });
        }
        // 상태도 스냅샷 기준으로 유지 (리렌더 중 0으로 덮이지 않게)
        self.state.boardScrollTop = snap.boardScrollTop;
        self.state.sourceScrollTop = snap.sourceScrollTop;
        self.state.bucketScroll = $.extend({}, self.state.bucketScroll, snap.bucketScroll);
      } finally {
        self.state.suppressScrollCapture = false;
      }
    };
    apply();
    if (typeof window !== 'undefined' && window.requestAnimationFrame) {
      window.requestAnimationFrame(function () {
        apply();
        window.requestAnimationFrame(apply);
      });
    } else {
      window.setTimeout(apply, 0);
    }
  };

  /**
   * 신규 유입 정렬 위치에 맞춰 가로 스트립 스크롤을 맞춘다.
   * (최하단 추가 후 이전 scrollLeft 복원으로 새 이미지가 안 보이는 문제 방지)
   */
  DocumentClassification.prototype._scrollGroupStripToInflow = function (pageIds) {
    var self = this;
    if (!this.$board || !this.$board[0]) return;
    var zone = this.$board[0];
    var position = this._normalizeNewInflowPosition(this.options.newInflowPosition);
    var ids = (pageIds || []).map(String).filter(Boolean);

    var apply = function () {
      if (!self.$board || !self.$board[0]) return;
      zone = self.$board[0];
      self.state.suppressScrollCapture = true;
      try {
        var targetId = position === 'bottom'
          ? (ids.length ? ids[ids.length - 1] : null)
          : (ids.length ? ids[0] : null);
        var $card = targetId
          ? self.$board.find('.dc-thumb-card[data-page-id="' + cssEscape(targetId) + '"]')
          : $();
        if ($card.length && $card[0].scrollIntoView) {
          $card[0].scrollIntoView({
            behavior: 'auto',
            inline: position === 'bottom' ? 'end' : 'start',
            block: 'nearest'
          });
        } else if (position === 'bottom') {
          zone.scrollLeft = zone.scrollWidth;
        } else {
          zone.scrollLeft = 0;
        }
        self.state.boardScrollTop = zone.scrollLeft || 0;
      } finally {
        self.state.suppressScrollCapture = false;
      }
    };

    apply();
    // _restoreScrollPositions 의 rAF 복원보다 늦게 적용
    if (typeof window !== 'undefined' && window.requestAnimationFrame) {
      window.requestAnimationFrame(function () {
        apply();
        window.requestAnimationFrame(apply);
      });
    } else {
      window.setTimeout(apply, 0);
    }
  };

  DocumentClassification.prototype._setStatus = function (msg, type) {
    if (!msg) {
      this.$status.attr('hidden', true).text('');
      return;
    }
    this.$status
      .removeAttr('hidden')
      .removeClass('dc-status-info dc-status-warn dc-status-error dc-status-ok')
      .addClass('dc-status-' + (type || 'info'))
      .text(msg);
  };

  DocumentClassification.prototype._updatePerfStats = function (mode, startedAt) {
    var elapsed = Math.round(nowMs() - startedAt);
    this.state.lastRenderMode = mode || 'full';
    this.state.lastRenderMs = elapsed;
    if (!this.options.showPerfStats || !this.$perf) return;
    var pageCount = this.state.data && this.state.data.pages ? this.state.data.pages.length : 0;
    var groupCount = this.state.data && this.state.data.groups ? this.state.data.groups.length : 0;
    var selectedCount = this.getRightSelectedPageIds().length;
    this.$perf
      .removeAttr('hidden')
      .text(
        'perf · pages ' + pageCount +
        ' · groups ' + groupCount +
        ' · selected ' + selectedCount +
        ' · ' + elapsed + 'ms' +
        ' · ' + this.state.lastRenderMode
      );
  };

  DocumentClassification.prototype._trigger = function (name, payload) {
    var cbName = 'on' + name.charAt(0).toUpperCase() + name.slice(1);
    if (typeof this.options[cbName] === 'function') {
      this.options[cbName].call(this.$el[0], payload);
    }
    this.$el.trigger(PLUGIN + ':' + name, [payload]);
  };

  DocumentClassification.prototype._normalizeData = function (raw) {
    if (!raw || typeof raw !== 'object') {
      throw new Error('Invalid document classification JSON');
    }
    var data = deepClone(raw);
    data.documentId = data.documentId || data.refNo || '';
    data.inptMstSrno = data.inptMstSrno || data.INPT_MST_SRNO || data.documentId || data.refNo || '';
    data.version = typeof data.version === 'number' ? data.version : 1;
    data.groupTypes = data.groupTypes || this.options.groupTypes || [
      { key: 'BL', label: 'BL', desc: 'B/L 기준 그룹' },
      { key: 'VESSEL', label: 'VESSEL', desc: '선박 기준 그룹' },
      { key: 'CONTAINER', label: 'CONTAINER', desc: '컨테이너 기준 그룹' }
    ];
    data.documentTypes = (function (optionsTypes, rawTypes) {
      if (Array.isArray(optionsTypes) && optionsTypes.length) {
        return deepClone(optionsTypes);
      }
      if (Array.isArray(rawTypes) && rawTypes.length) {
        return deepClone(rawTypes);
      }
      return deepClone(DEFAULT_DOCUMENT_TYPES);
    })(this.options.documentTypes, raw.documentTypes);
    data.unclassifiedGroup = data.unclassifiedGroup || {
      groupId: ETC_GROUP_ID,
      groupType: 'ETC',
      label: 'ETC [미분류/오분류]',
      documentType: ETC_DOC_TYPE
    };
    data.groups = Array.isArray(data.groups) ? data.groups : [];
    data.pages = Array.isArray(data.pages) ? data.pages : [];

    var defaultBlId = 'BL1';
    var gtList = data.groupTypes || [];
    for (var gi = 0; gi < gtList.length; gi++) {
      if (gtList[gi] && gtList[gi].key === 'BL') {
        defaultBlId = 'BL1';
        break;
      }
    }

    var pageIds = {};
    data.pages.forEach(function (p, idx) {
      if (!p.pageId) throw new Error('pages[' + idx + '] missing pageId');
      if (pageIds[p.pageId]) throw new Error('Duplicate pageId: ' + p.pageId);
      pageIds[p.pageId] = true;

      // BL 그룹: INPT_BL_GRP_NO (UI 내부 키는 groupId 로 동기화)
      p.inptBlGrpNo = p.inptBlGrpNo || p.INPT_BL_GRP_NO || p.groupId || '';
      if (p.inptBlGrpNo) p.groupId = p.inptBlGrpNo;

      // 미분류/구 ETC 그룹 호환: groupId=ETC → BL1. documentType은 ETC일 때만 유지
      if (p.groupId === ETC_GROUP_ID) {
        p.groupId = defaultBlId;
        if (!p.documentType) p.documentType = ETC_DOC_TYPE;
      } else if (p.documentType === ETC_DOC_TYPE) {
        p.groupId = p.groupId || defaultBlId;
      } else {
        p.groupId = p.groupId || defaultBlId;
        p.documentType = p.documentType || 'OT';
      }
      p.inptBlGrpNo = p.groupId;

      p.sortOrder = typeof p.sortOrder === 'number' ? p.sortOrder : idx;
      p.thumbnailBase64 = p.thumbnailBase64 || p.imageBase64 || p.thumbnailUrl || '';
      // 하위 호환: thumbnailUrl 에 data URI/원본 base64 가 온 경우 유지
      p.thumbnailUrl = p.thumbnailUrl || '';
      p.isNew = !!p.isNew;
      // 미디어 종류: image | text (텍스트 파일 병행)
      p.contentType = p.contentType || p.mimeType || p.mediaType || p.CONTENT_TYPE || '';
      p.fileName = p.fileName || p.FILE_NM || p.fileNm || '';
      p.textContent = p.textContent != null ? String(p.textContent) : (p.TEXT_CONTENT != null ? String(p.TEXT_CONTENT) : '');
      p.textBase64 = p.textBase64 || p.TEXT_BASE64 || '';
      if (!p.contentType) {
        if (p.textContent || p.textBase64 || /^data:text\//i.test(String(p.thumbnailBase64 || ''))) {
          p.contentType = 'text/plain';
        } else if (/\.(txt|csv|log|json|xml|md)$/i.test(String(p.fileName || ''))) {
          p.contentType = 'text/plain';
        }
      }
      // CSPD002TG 기준 식별 필드
      // 이미지 구분: INPT_TASK_ID / 마스터: INPT_MST_SRNO / 문서분류코드: IMEX_HIS_CD / BL그룹: INPT_BL_GRP_NO
      p.inptMstSrno = p.inptMstSrno || p.INPT_MST_SRNO ||
        data.inptMstSrno || data.INPT_MST_SRNO || data.documentId || data.refNo || '';
      p.inptTaskId = p.inptTaskId || p.INPT_TASK_ID || p.pageId || '';
      p.imexHisCd = p.imexHisCd || p.IMEX_HIS_CD || '';
      // pageId 는 이미지 일련번호(INPT_TASK_ID)를 우선 사용
      p.pageId = p.pageId || p.inptTaskId;
      // 하위 호환(저장 페이로드): ELMT가 오면 유지, 없으면 TASK로 대체
      p.inptElmtId = p.inptElmtId || p.INPT_ELMT_ID || p.inptTaskId || p.pageId;
      if (!p.imexHisCd && p.documentType && p.documentType !== ETC_DOC_TYPE) {
        var dtMeta = null;
        for (var di = 0; di < data.documentTypes.length; di++) {
          if (data.documentTypes[di] && data.documentTypes[di].key === p.documentType) {
            dtMeta = data.documentTypes[di];
            break;
          }
        }
        p.imexHisCd = (dtMeta && dtMeta.imexHisCd) || p.documentType;
      }
      // fileId 는 사용하지 않음 (BASE64 이미지 — 파일 메타 없음)
      delete p.fileId;
    });

    data.groups.forEach(function (g) {
      g.groupId = g.groupId || g.inptBlGrpNo || g.INPT_BL_GRP_NO;
      if (!g.groupId) throw new Error('group missing groupId / INPT_BL_GRP_NO');
      g.inptBlGrpNo = g.inptBlGrpNo || g.INPT_BL_GRP_NO || g.groupId;
      g.groupId = g.inptBlGrpNo;
      g.groupType = g.groupType || 'BL';
      g.label = g.label || g.groupId;
      g.buckets = Array.isArray(g.buckets) ? g.buckets : [];
    });

    // 페이지용 ETC 그룹은 쓰지 않음 (BL 그룹 + documentType=ETC)
    data.groups = data.groups.filter(function (g) {
      return g.groupId !== ETC_GROUP_ID && g.groupType !== 'ETC';
    });

    var usedGroupIds = {};
    data.pages.forEach(function (p) {
      if (p.groupId && p.groupId !== ETC_GROUP_ID) usedGroupIds[p.groupId] = true;
    });
    Object.keys(usedGroupIds).forEach(function (gid) {
      var found = false;
      for (var i = 0; i < data.groups.length; i++) {
        if (String(data.groups[i].groupId) === String(gid)) {
          found = true;
          break;
        }
      }
      if (!found) {
        data.groups.push({
          groupId: gid,
          inptBlGrpNo: gid,
          groupType: 'BL',
          label: gid,
          sortOrder: data.groups.length,
          buckets: []
        });
      }
    });
    if (!data.groups.length) {
      data.groups.push({
        groupId: defaultBlId,
        inptBlGrpNo: defaultBlId,
        groupType: 'BL',
        label: defaultBlId,
        sortOrder: 0,
        buckets: []
      });
    }

    this._reindexSortOrders(data);
    return data;
  };

  DocumentClassification.prototype._normalizeNewInflowPosition = function (value) {
    return String(value || 'top').toLowerCase() === 'bottom' ? 'bottom' : 'top';
  };

  DocumentClassification.prototype._showNewLabel = function () {
    return this.options.showNewLabel !== false;
  };

  DocumentClassification.prototype._showThumbTitle = function () {
    return !!this.options.showThumbTitle;
  };

  DocumentClassification.prototype._showThumbTaskId = function () {
    return !!this.options.showThumbTaskId;
  };

  DocumentClassification.prototype._showPreviewMeta = function () {
    return this.options.showPreviewMeta !== false;
  };

  DocumentClassification.prototype._showRefNoBar = function () {
    return this.options.showRefNoBar !== false;
  };

  DocumentClassification.prototype._refNoBarBoxed = function () {
    return this.options.refNoBarBoxed !== false;
  };

  DocumentClassification.prototype._rememberDocTypeScroll = function () {
    return !!this.options.rememberDocTypeScroll;
  };

  DocumentClassification.prototype._stripScrollMemoryKey = function (docType, groupId) {
    var dtype = docType != null ? String(docType) : String(this.state.activeDocType || '');
    var gid = groupId != null ? String(groupId) : String(this.state.activeGroupId || '');
    if (!dtype) return '';
    return dtype + '::' + gid;
  };

  DocumentClassification.prototype._saveStripScrollMemory = function () {
    if (!this._rememberDocTypeScroll()) return;
    if (!this.$board || !this.$board[0]) return;
    var key = this._stripScrollMemoryKey();
    if (!key) return;
    var left = this.$board[0].scrollLeft || 0;
    if (!this.state.docTypeScroll) this.state.docTypeScroll = {};
    this.state.docTypeScroll[key] = left;
    this.state.boardScrollTop = left;
  };

  DocumentClassification.prototype._applyStripScrollForActive = function () {
    if (!this.$board || !this.$board[0]) return;
    var left = 0;
    if (this._rememberDocTypeScroll()) {
      var key = this._stripScrollMemoryKey();
      if (key && this.state.docTypeScroll && typeof this.state.docTypeScroll[key] === 'number') {
        left = this.state.docTypeScroll[key];
      }
    }
    this.state.suppressScrollCapture = true;
    try {
      this.$board[0].scrollLeft = left;
      this.state.boardScrollTop = left;
    } finally {
      this.state.suppressScrollCapture = false;
    }
  };

  DocumentClassification.prototype._previewMetaMessage = function () {
    var msg = this.options.previewMetaMessage;
    if (msg == null || String(msg).trim() === '') {
      return 'Ctrl + 휠로 확대·축소';
    }
    return String(msg);
  };

  DocumentClassification.prototype._renderPreviewMeta = function () {
    if (!this.$imagePreview || !this.$imagePreview.length) return;
    var msg = this._previewMetaMessage();
    var $meta = this.$imagePreview.find('[data-dc-preview-meta]');
    var $body = this.$imagePreview.find('[data-dc-preview-body]');
    if ($body.length) $body.attr('title', msg);
    if (!$meta.length) return;
    if (!this._showPreviewMeta()) {
      $meta.empty().attr('hidden', true);
      return;
    }
    $meta.removeAttr('hidden').html(
      '<span>' + escapeHtml(msg) + '</span>'
    );
  };

  DocumentClassification.prototype._defaultEtcFilterColumns = function () {
    return deepClone(DEFAULTS.etcFilterColumns);
  };

  DocumentClassification.prototype._normalizeEtcFilterColumns = function (columns) {
    var defaults = this._defaultEtcFilterColumns();
    var defaultByKey = {};
    var i;
    for (i = 0; i < defaults.length; i++) {
      defaultByKey[defaults[i].key] = defaults[i];
    }
    if (columns == null) return defaults;
    if (!Array.isArray(columns)) return defaults;
    var out = [];
    var seen = {};
    columns.forEach(function (item) {
      var key;
      var col;
      if (typeof item === 'string') {
        key = item;
        col = defaultByKey[key]
          ? deepClone(defaultByKey[key])
          : { key: key, placeholder: key, title: key };
      } else if (item && typeof item === 'object' && item.key) {
        key = String(item.key);
        var base = defaultByKey[key] ? deepClone(defaultByKey[key]) : {
          key: key,
          placeholder: key,
          title: key
        };
        col = {
          key: key,
          placeholder: item.placeholder != null ? String(item.placeholder) : base.placeholder,
          title: item.title != null ? String(item.title) : (item.placeholder != null
            ? String(item.placeholder)
            : base.title)
        };
        if (Array.isArray(item.aliases)) {
          col.aliases = item.aliases.map(function (alias) { return String(alias); });
        } else if (Array.isArray(base.aliases)) {
          col.aliases = base.aliases.slice();
        }
      } else {
        return;
      }
      if (!col.key || seen[col.key]) return;
      seen[col.key] = true;
      out.push(col);
    });
    return out;
  };

  DocumentClassification.prototype._emptyTableFilter = function () {
    var filter = {};
    (this.options.etcFilterColumns || []).forEach(function (col) {
      filter[col.key] = '';
    });
    return filter;
  };

  DocumentClassification.prototype._syncTableFilterKeys = function () {
    var next = this._emptyTableFilter();
    var prev = this.state.tableFilter || {};
    Object.keys(next).forEach(function (key) {
      if (Object.prototype.hasOwnProperty.call(prev, key)) {
        next[key] = prev[key] == null ? '' : String(prev[key]);
      }
    });
    this.state.tableFilter = next;
    return next;
  };

  DocumentClassification.prototype._activeEtcFilterColumns = function () {
    if (this.options.showEtcFilters === false) return [];
    return this.options.etcFilterColumns || [];
  };

  DocumentClassification.prototype._renderSourceFilters = function () {
    if (!this.$sourceFilters || !this.$sourceFilters.length) return;
    var columns = this._activeEtcFilterColumns();
    if (!columns.length) {
      this.$sourceFilters.empty().attr('hidden', true);
      return;
    }
    this.$sourceFilters.removeAttr('hidden');
    var filter = this.state.tableFilter || {};
    var html = columns.map(function (col) {
      var value = filter[col.key] == null ? '' : String(filter[col.key]);
      return (
        '<input type="search" data-dc-filter="' + escapeHtml(col.key) + '" ' +
        'placeholder="' + escapeHtml(col.placeholder || col.key) + '" ' +
        'title="' + escapeHtml(col.title || col.placeholder || col.key) + '" ' +
        'value="' + escapeHtml(value) + '">'
      );
    }).join('');
    this.$sourceFilters.html(html);
  };

  DocumentClassification.prototype._resolveInflowInsertIndex = function (bucketLength, preferredIndex, isInflow) {
    if (!isInflow) {
      if (typeof preferredIndex !== 'number' || preferredIndex < 0) return bucketLength;
      if (preferredIndex > bucketLength) return bucketLength;
      return preferredIndex;
    }
    return this._normalizeNewInflowPosition(this.options.newInflowPosition) === 'bottom'
      ? bucketLength
      : 0;
  };

  DocumentClassification.prototype._imexHisCdForDocType = function (documentType) {
    if (!documentType || documentType === ETC_DOC_TYPE) return '';
    var meta = this._getDocTypeMeta(documentType);
    return (meta && meta.imexHisCd) || documentType;
  };

  DocumentClassification.prototype._applyPageClassification = function (page, groupId, documentType) {
    if (!page) return;
    page.groupId = groupId;
    page.inptBlGrpNo = groupId; // INPT_BL_GRP_NO
    page.documentType = documentType;
    page.imexHisCd = this._imexHisCdForDocType(documentType);
  };

  DocumentClassification.prototype._findOriginalPage = function (pageId) {
    if (!this.state.original || !Array.isArray(this.state.original.pages)) return null;
    var id = String(pageId || '');
    for (var i = 0; i < this.state.original.pages.length; i++) {
      if (String(this.state.original.pages[i].pageId) === id) {
        return this.state.original.pages[i];
      }
    }
    return null;
  };

  /**
   * 신규(NEW): 원본과 다른 그룹·문서분류로 처음(또는 다시) 유입될 때만 표시.
   * 원본 위치(조회 시점)로 복원되면 NEW를 제거한다.
   */
  DocumentClassification.prototype._markPageNew = function (page, isInflow) {
    if (!page) return;
    if (!isInflow) return;
    var originalPage = this._findOriginalPage(page.pageId);
    if (
      originalPage &&
      String(originalPage.groupId) === String(page.groupId) &&
      String(originalPage.documentType) === String(page.documentType)
    ) {
      page.isNew = false;
      return;
    }
    page.isNew = true;
  };

  DocumentClassification.prototype._isNewDocType = function (docType) {
    return !!(this.state.newDocTypes && this.state.newDocTypes[docType]);
  };

  DocumentClassification.prototype._sortBucketsByInflowPosition = function (buckets) {
    var self = this;
    var position = this._normalizeNewInflowPosition(this.options.newInflowPosition);
    var stable = buckets.slice();
    stable.sort(function (a, b) {
      var aNew = self._isNewDocType(a.documentType) ? 1 : 0;
      var bNew = self._isNewDocType(b.documentType) ? 1 : 0;
      if (aNew === bNew) return 0;
      if (position === 'bottom') return aNew - bNew;
      return bNew - aNew;
    });
    return stable;
  };

  DocumentClassification.prototype._registerDocumentType = function (key, labelHint, options) {
    options = options || {};
    var markNew = options.markNew !== false;
    if (!this.state.data || !key || key === ETC_DOC_TYPE) return false;
    if (!Array.isArray(this.state.data.documentTypes)) {
      this.state.data.documentTypes = [];
    }
    var list = this.state.data.documentTypes;
    var i;
    for (i = 0; i < list.length; i++) {
      if (list[i].key === key) return false;
    }
    list.push({
      key: key,
      label: labelHint || key,
      imexHisCd: ''
    });
    if (markNew) {
      if (!this.state.newDocTypes) this.state.newDocTypes = {};
      this.state.newDocTypes[key] = true;
    }
    (this.state.data.groups || []).forEach(function (group) {
      this._ensureGroupBuckets(group);
    }, this);
    return true;
  };

  DocumentClassification.prototype._syncDocumentTypesFromPages = function () {
    if (!this.state.data) return false;
    var self = this;
    var added = false;
    (this.state.data.pages || []).forEach(function (page) {
      if (!page || !page.documentType || page.documentType === ETC_DOC_TYPE) return;
      if (self._registerDocumentType(page.documentType, page.documentType, { markNew: false })) {
        added = true;
      }
    });
    (this.state.data.groups || []).forEach(function (group) {
      self._ensureGroupBuckets(group);
    });
    return added;
  };

  DocumentClassification.prototype._reindexSortOrders = function (data) {
    var buckets = {};
    data.pages.forEach(function (p) {
      var key = p.groupId + '::' + p.documentType;
      if (!buckets[key]) buckets[key] = [];
      buckets[key].push(p);
    });
    Object.keys(buckets).forEach(function (key) {
      buckets[key].sort(function (a, b) { return a.sortOrder - b.sortOrder; });
      buckets[key].forEach(function (p, i) { p.sortOrder = i; });
    });
  };

  DocumentClassification.prototype._rebuildPageIndex = function () {
    var pageIndex = {};
    var pageById = {};
    if (this.state.data && Array.isArray(this.state.data.pages)) {
      this.state.data.pages.forEach(function (p) {
        pageById[p.pageId] = p;
        var key = p.groupId + '::' + p.documentType;
        if (!pageIndex[key]) pageIndex[key] = [];
        pageIndex[key].push(p);
      });
      Object.keys(pageIndex).forEach(function (key) {
        pageIndex[key].sort(function (a, b) { return a.sortOrder - b.sortOrder; });
      });
    }
    this.state.pageIndex = pageIndex;
    this.state.pageById = pageById;
  };

  DocumentClassification.prototype._docTypeRank = function (docType) {
    var list = (this.state.data && this.state.data.documentTypes) || [];
    for (var i = 0; i < list.length; i++) {
      if (list[i].key === docType) return i;
    }
    if (docType === ETC_DOC_TYPE) return 1000;
    return 999;
  };

  DocumentClassification.prototype._rebuildGroupOrder = function (reset) {
    var self = this;
    var next = {};
    if (!this.state.data) {
      this.state.groupOrder = {};
      return;
    }
    var byGroup = {};
    this.state.data.pages.forEach(function (p) {
      if (!byGroup[p.groupId]) byGroup[p.groupId] = [];
      byGroup[p.groupId].push(p);
    });
    Object.keys(byGroup).forEach(function (gid) {
      var pages = byGroup[gid].slice();
      pages.sort(function (a, b) {
        var ra = self._docTypeRank(a.documentType) - self._docTypeRank(b.documentType);
        if (ra !== 0) return ra;
        return a.sortOrder - b.sortOrder;
      });
      var prev = (!reset && self.state.groupOrder && self.state.groupOrder[gid]) || [];
      if (prev.length) {
        var map = {};
        pages.forEach(function (p) { map[p.pageId] = true; });
        var kept = [];
        prev.forEach(function (id) {
          if (map[id]) {
            kept.push(id);
            delete map[id];
          }
        });
        pages.forEach(function (p) {
          if (map[p.pageId]) kept.push(p.pageId);
        });
        next[gid] = kept;
      } else {
        next[gid] = pages.map(function (p) { return p.pageId; });
      }
    });
    this.state.groupOrder = next;
  };

  DocumentClassification.prototype._pagesInGroup = function (groupId) {
    var self = this;
    groupId = String(groupId || '');
    if (!groupId || !this.state.data || !Array.isArray(this.state.data.pages)) return [];
    var seen = {};
    var list = [];
    (this.state.groupOrder[groupId] || []).forEach(function (id) {
      var page = self.state.pageById[id];
      if (!page || seen[id] || String(page.groupId) !== groupId) return;
      seen[id] = true;
      list.push(page);
    });
    this.state.data.pages.forEach(function (page) {
      if (!page || seen[page.pageId] || String(page.groupId) !== groupId) return;
      seen[page.pageId] = true;
      list.push(page);
    });
    return list;
  };

  DocumentClassification.prototype._insertIntoGroupOrder = function (groupId, pageIds, position) {
    var incoming = (pageIds || []).filter(Boolean);
    var seen = {};
    incoming.forEach(function (id) { seen[id] = true; });
    var list = (this.state.groupOrder[groupId] || []).filter(function (id) {
      return !seen[id];
    });
    if (position === 'bottom') {
      this.state.groupOrder[groupId] = list.concat(incoming);
    } else if (typeof position === 'number') {
      var idx = Math.max(0, Math.min(list.length, position));
      this.state.groupOrder[groupId] = list.slice(0, idx).concat(incoming, list.slice(idx));
    } else {
      this.state.groupOrder[groupId] = incoming.concat(list);
    }
  };

  DocumentClassification.prototype._removeFromGroupOrder = function (groupId, pageIds) {
    var seen = {};
    (pageIds || []).forEach(function (id) { seen[id] = true; });
    this.state.groupOrder[groupId] = (this.state.groupOrder[groupId] || []).filter(function (id) {
      return !seen[id];
    });
  };

  DocumentClassification.prototype._syncSortOrderFromGroup = function (groupId) {
    var counters = {};
    this._pagesInGroup(groupId).forEach(function (page) {
      var key = page.documentType;
      if (typeof counters[key] !== 'number') counters[key] = 0;
      page.sortOrder = counters[key];
      counters[key] += 1;
    });
  };

  DocumentClassification.prototype._getDocTypeMeta = function (key) {
    var list = (this.state.data && this.state.data.documentTypes) || [];
    for (var i = 0; i < list.length; i++) {
      if (list[i].key === key) return list[i];
    }
    return null;
  };

  DocumentClassification.prototype._getGroupTypeMeta = function (key) {
    var list = (this.state.data && this.state.data.groupTypes) || [];
    for (var i = 0; i < list.length; i++) {
      if (list[i].key === key) return list[i];
    }
    return { key: key, label: key, desc: '' };
  };

  DocumentClassification.prototype._bucketKey = function (groupId, docType) {
    return groupId + '::' + docType;
  };

  DocumentClassification.prototype._pagesInBucket = function (groupId, docType) {
    var list = this.state.pageIndex[this._bucketKey(groupId, docType)];
    return list ? list.slice() : [];
  };

  DocumentClassification.prototype._findPage = function (pageId) {
    return this.state.pageById[pageId] || null;
  };

  DocumentClassification.prototype._typeBadgeClass = function (typeKey) {
    var key = String(typeKey || '').toLowerCase();
    if (key === 'vessel') return 'dc-type-vessel';
    if (key === 'container') return 'dc-type-container';
    if (key === 'etc') return 'dc-type-etc';
    if (key === 'inv') return 'dc-type-inv';
    if (key === 'pl') return 'dc-type-pl';
    if (key === 'co') return 'dc-type-co';
    if (key === 'ot') return 'dc-type-ot';
    return 'dc-type-bl';
  };

  DocumentClassification.prototype._docTypeDisplayLabel = function (pageOrType) {
    var key = pageOrType && typeof pageOrType === 'object'
      ? pageOrType.documentType
      : pageOrType;
    if (!key || key === ETC_DOC_TYPE ||
        (pageOrType && pageOrType.groupId === ETC_GROUP_ID)) {
      return '미분류';
    }
    var meta = this._getDocTypeMeta(key);
    return (meta && meta.label) || key;
  };

  DocumentClassification.prototype._shortThumbLabel = function (page) {
    if (!page) return '';
    if (page.documentType === ETC_DOC_TYPE || page.groupId === ETC_GROUP_ID) return 'ETC';
    return String(page.documentType || 'OT').slice(0, 4);
  };

  /** CSPD002TG 기준 이미지 식별 필드 */
  DocumentClassification.prototype._pageIdentity = function (page) {
    var mst = this._pageFilterValue(page, 'inptMstSrno');
    if (!mst && this.state.data) {
      mst = String(
        this.state.data.inptMstSrno ||
        this.state.data.INPT_MST_SRNO ||
        this.state.data.documentId ||
        this.state.data.refNo ||
        ''
      );
    }
    return {
      inptMstSrno: mst || '-',
      inptTaskId: this._pageFilterValue(page, 'inptTaskId') || String((page && page.pageId) || '-') || '-',
      imexHisCd: this._pageFilterValue(page, 'imexHisCd') || '-',
      inptBlGrpNo: this._pageFilterValue(page, 'inptBlGrpNo') ||
        String((page && (page.groupId || page.inptBlGrpNo)) || '-') || '-'
    };
  };

  /**
   * 썸네일 hover title: 문서분류명 + INPT_TASK_ID
   * (예: Invoice / IMG-0001)
   */
  DocumentClassification.prototype._formatThumbTitle = function (page, options) {
    options = options || {};
    if (!this._showThumbTitle()) return '';
    var id = this._pageIdentity(page);
    var label = this._docTypeDisplayLabel(page);
    var text = label + ' / ' + id.inptTaskId;
    if (options.showNew && this._showNewLabel() && page && page.isNew) {
      text += ' (NEW)';
    }
    return text;
  };

  /** 썸네일 하단 라벨: showThumbTaskId 일 때만 INPT_TASK_ID */
  DocumentClassification.prototype._thumbBottomLabel = function (page) {
    if (!this._showThumbTaskId()) return '';
    return this._pageIdentity(page).inptTaskId;
  };

  DocumentClassification.prototype._formatPageLabel = function (page) {
    if (!page) return '';
    var id = this._pageIdentity(page);
    if (page.documentType === ETC_DOC_TYPE || page.groupId === ETC_GROUP_ID) {
      return (page.groupId && page.groupId !== ETC_GROUP_ID ? page.groupId + ' / ' : '') +
        'ETC [미분류] / ' + id.inptTaskId;
    }
    var meta = this._getDocTypeMeta(page.documentType);
    return page.groupId + ' / ' + ((meta && meta.label) || page.documentType) +
      ' / ' + id.inptTaskId;
  };

  DocumentClassification.prototype._ensureThumbObserver = function () {
    var self = this;
    if (this.state.thumbObserver) {
      this.state.thumbObserver.disconnect();
      this.state.thumbObserver = null;
    }
    if (!this.options.lazyThumbs || typeof window.IntersectionObserver !== 'function') {
      return;
    }
    this.state.thumbObserver = new window.IntersectionObserver(function (entries) {
      entries.forEach(function (entry) {
        if (!entry.isIntersecting) return;
        var img = entry.target;
        var src = img.getAttribute('data-src');
        if (src) {
          img.src = src;
          img.removeAttribute('data-src');
          var pageId = img.getAttribute('data-page-id');
          if (pageId) self.state.thumbCache[pageId] = src;
        }
        if (self.state.thumbObserver) self.state.thumbObserver.unobserve(img);
      });
    }, { root: null, rootMargin: '100px 0px', threshold: 0.01 });
  };

  DocumentClassification.prototype._observeLazyThumbs = function ($scope) {
    var self = this;
    var $root = $scope && $scope.length ? $scope : this.$root;
    if (!this.options.lazyThumbs || !this.state.thumbObserver) {
      $root.find('img.dc-thumb-img[data-src]').each(function () {
        var src = this.getAttribute('data-src');
        if (src) {
          this.src = src;
          this.removeAttribute('data-src');
        }
      });
      return;
    }
    $root.find('img.dc-thumb-img[data-src]').each(function () {
      self.state.thumbObserver.observe(this);
    });
  };

  DocumentClassification.prototype._capChangeLogDom = function () {
    var $items = this.$log.children('.dc-log-item');
    var overflow = $items.length - CHANGE_LOG_MAX;
    if (overflow > 0) {
      $items.slice(0, overflow).remove();
    }
  };

  DocumentClassification.prototype._activeJsonPane = function () {
    var $tab = this.$root.find('.dc-json-tab.active');
    return $tab.length ? String($tab.data('dcJson') || '') : '';
  };

  DocumentClassification.prototype._logChange = function (msg, changeOp) {
    this.state.changeLog.push(msg);
    if (this.state.changeLog.length > CHANGE_LOG_MAX) {
      this.state.changeLog = this.state.changeLog.slice(-CHANGE_LOG_MAX);
    }
    if (changeOp) this.state.changes.push($.extend({ at: nowIso() }, changeOp));
    this.state.dirty = true;
    if (this.options.showChangeLog) {
      this.$log.append($('<div class="dc-log-item"/>').text('• ' + msg));
      this._capChangeLogDom();
      this.$log.scrollTop(this.$log[0].scrollHeight);
    }
    this._refreshSavePreview(false);
    this._trigger('changed', {
      message: msg,
      change: changeOp,
      data: this.getData({ clone: !!this.options.cloneOnChange })
    });
  };

  DocumentClassification.prototype._resolveThumbSrc = function (page) {
    if (!page) return '';
    if (this.state.thumbCache[page.pageId]) return this.state.thumbCache[page.pageId];
    var raw = page.thumbnailBase64 || page.imageBase64 || page.thumbnailUrl || '';
    raw = String(raw || '').trim();
    if (!raw) return '';
    if (/^data:text\//i.test(raw)) return ''; // 텍스트는 별도 경로
    // 이미 data URI 이면 그대로, 순수 base64 이면 JPEG 가정으로 래핑 (imgRest / CSPD002TG)
    if (/^data:image\//i.test(raw)) return raw;
    if (/^https?:\/\//i.test(raw) || raw.charAt(0) === '/') return raw;
    return 'data:image/jpeg;base64,' + raw.replace(/\s+/g, '');
  };

  DocumentClassification.prototype._decodeBase64Text = function (b64) {
    var raw = String(b64 || '').replace(/\s+/g, '');
    if (!raw) return '';
    try {
      var bin = window.atob(raw);
      if (typeof window.TextDecoder === 'function') {
        var bytes = new Uint8Array(bin.length);
        for (var i = 0; i < bin.length; i++) bytes[i] = bin.charCodeAt(i);
        return new window.TextDecoder('utf-8').decode(bytes);
      }
      return decodeURIComponent(escape(bin));
    } catch (err) {
      return '';
    }
  };

  /** 페이지 미디어 종류: image | text | empty */
  DocumentClassification.prototype._pageMediaKind = function (page) {
    if (!page) return 'empty';
    var ct = String(page.contentType || page.mimeType || '').toLowerCase();
    if (ct.indexOf('text/') === 0 || ct === 'text' || ct === 'txt') return 'text';
    if (page.textContent || page.textBase64) return 'text';
    var thumb = String(page.thumbnailBase64 || '');
    if (/^data:text\//i.test(thumb)) return 'text';
    if (/\.(txt|csv|log|json|xml|md)$/i.test(String(page.fileName || ''))) return 'text';
    if (this._resolveThumbSrc(page)) return 'image';
    if (ct.indexOf('image/') === 0) return 'image';
    return 'empty';
  };

  DocumentClassification.prototype._resolveTextContent = function (page) {
    if (!page) return '';
    if (page.textContent != null && String(page.textContent) !== '') {
      return String(page.textContent);
    }
    if (page.textBase64) {
      var fromB64 = this._decodeBase64Text(page.textBase64);
      if (fromB64) return fromB64;
    }
    var raw = String(page.thumbnailBase64 || '').trim();
    var m = raw.match(/^data:text\/[^;]+;base64,(.+)$/i);
    if (m) return this._decodeBase64Text(m[1]);
    var m2 = raw.match(/^data:text\/[^,]+,([\s\S]+)$/i);
    if (m2) {
      try { return decodeURIComponent(m2[1]); } catch (e) { return m2[1]; }
    }
    return '';
  };

  DocumentClassification.prototype._thumbTextSnippet = function (text, maxLen) {
    var s = String(text || '').replace(/\r\n/g, '\n').replace(/\t/g, '  ');
    var limit = typeof maxLen === 'number' ? maxLen : 280;
    if (s.length > limit) s = s.slice(0, limit) + '…';
    return s;
  };

  DocumentClassification.prototype._bindPreviewWheel = function (enable) {
    if (!this.$imagePreview || !this.$imagePreview.length) return;
    var body = this.$imagePreview.find('[data-dc-preview-body]')[0];
    if (!body || !this._onPreviewWheel) return;
    body.removeEventListener('wheel', this._onPreviewWheel);
    if (enable) {
      body.addEventListener('wheel', this._onPreviewWheel, { passive: false });
    }
  };

  DocumentClassification.prototype._nudgePreviewZoom = function (direction, step) {
    var delta = (typeof step === 'number' ? step : PREVIEW_ZOOM_STEP) * (direction < 0 ? -1 : 1);
    var current = typeof this.state.previewZoom === 'number' ? this.state.previewZoom : 1;
    this._setPreviewZoom(current + delta);
  };

  DocumentClassification.prototype._setPreviewZoom = function (zoom) {
    var next = Math.round(Number(zoom) * 100) / 100;
    if (isNaN(next)) next = 1;
    next = Math.max(PREVIEW_ZOOM_MIN, Math.min(PREVIEW_ZOOM_MAX, next));
    this.state.previewZoom = next;
    this._applyPreviewZoom();
    return this;
  };

  DocumentClassification.prototype._applyPreviewZoom = function () {
    if (!this.$imagePreview || !this.$imagePreview.length) return;
    var zoom = typeof this.state.previewZoom === 'number' ? this.state.previewZoom : 1;
    var baseW = this.state.previewBaseWidth || 0;
    var $label = this.$imagePreview.find('[data-dc-preview-zoom-label]');
    var $img = this.$imagePreview.find('.dc-image-preview-img');
    var $ph = this.$imagePreview.find('.dc-image-preview-ph');
    var $text = this.$imagePreview.find('.dc-text-preview');

    if ($label.length) $label.text(Math.round(zoom * 100) + '%');

    if ($img.length && baseW > 0) {
      $img.css({
        width: Math.max(1, Math.round(baseW * zoom)) + 'px',
        height: 'auto',
        maxWidth: 'none',
        maxHeight: 'none'
      });
    } else if ($text.length) {
      $text.css({
        transform: 'scale(' + zoom + ')',
        transformOrigin: 'top left'
      });
    } else if ($ph.length) {
      $ph.css({
        transform: 'scale(' + zoom + ')',
        transformOrigin: 'center center'
      });
    }

    this.$imagePreview.find('[data-dc-preview-zoom="out"]')
      .prop('disabled', zoom <= PREVIEW_ZOOM_MIN);
    this.$imagePreview.find('[data-dc-preview-zoom="in"]')
      .prop('disabled', zoom >= PREVIEW_ZOOM_MAX);
  };

  DocumentClassification.prototype._measurePreviewBaseSize = function ($img) {
    if (!$img || !$img.length) return;
    var img = $img[0];
    var $body = this.$imagePreview.find('[data-dc-preview-body]');
    var maxW = Math.max(120, ($body.innerWidth() || 640) - 24);
    var maxH = Math.max(120, ($body.innerHeight() || 480) - 24);
    var nw = img.naturalWidth || img.width || maxW;
    var nh = img.naturalHeight || img.height || maxH;
    if (!nw || !nh) {
      this.state.previewBaseWidth = maxW;
      return;
    }
    var ratio = Math.min(1, maxW / nw, maxH / nh);
    this.state.previewBaseWidth = Math.max(1, Math.round(nw * ratio));
  };

  DocumentClassification.prototype.openImagePreview = function (pageId) {
    if (this.options.allowImagePreview === false) return this;
    if (!this.$imagePreview || !this.$imagePreview.length) return this;
    var page = this._findPage(pageId);
    if (!page) return this;
    var self = this;

    var docLabel = this._docTypeDisplayLabel(page);
    var id = this._pageIdentity(page);
    var mediaKind = this._pageMediaKind(page);
    var title = docLabel + ' · ' + id.inptTaskId;
    var url = mediaKind === 'image' ? this._resolveThumbSrc(page) : '';
    var textBody = mediaKind === 'text' ? this._resolveTextContent(page) : '';
    var bodyHtml;

    this.state.previewZoom = 1;
    this.state.previewBaseWidth = 0;

    if (mediaKind === 'text') {
      bodyHtml =
        '<pre class="dc-text-preview" tabindex="0">' +
        escapeHtml(textBody || '(텍스트 내용이 없습니다)') +
        '</pre>';
    } else if (url) {
      this.state.thumbCache[page.pageId] = url;
      bodyHtml = '<img class="dc-image-preview-img" src="' + escapeHtml(url) +
        '" alt="' + escapeHtml(title) + '">';
    } else {
      bodyHtml =
        '<div class="dc-image-preview-ph">' +
        '<span class="dc-thumb-ph-lines"></span>' +
        '<p>' + escapeHtml(docLabel) + '</p>' +
        '<p>이미지/텍스트 데이터가 없어 플레이스홀더로 표시합니다.</p>' +
        '</div>';
    }

    this.$imagePreview.find('[data-dc-preview-title]').text(title);
    this.$imagePreview.find('[data-dc-preview-body]').html(bodyHtml);
    this._renderPreviewMeta();
    this.$imagePreview.removeAttr('hidden');
    this.$root.addClass('dc-preview-open');
    $('body').addClass('dc-image-preview-lock');
    $(document).off('keydown.dcPreview').on('keydown.dcPreview', this._onPreviewKeydown);
    this._bindPreviewWheel(true);

    var $img = this.$imagePreview.find('.dc-image-preview-img');
    if ($img.length) {
      var applyFit = function () {
        self._measurePreviewBaseSize($img);
        self._setPreviewZoom(1);
      };
      if ($img[0].complete && $img[0].naturalWidth) applyFit();
      else $img.one('load', applyFit);
    } else {
      this._setPreviewZoom(1);
    }
    return this;
  };

  DocumentClassification.prototype.closeImagePreview = function () {
    if (!this.$imagePreview || !this.$imagePreview.length) return this;
    if (this.$imagePreview.attr('hidden') != null) return this;
    this._bindPreviewWheel(false);
    this.$imagePreview.attr('hidden', true);
    this.$imagePreview.find('[data-dc-preview-body]').empty();
    this.$root.removeClass('dc-preview-open');
    $('body').removeClass('dc-image-preview-lock');
    this.state.previewZoom = 1;
    this.state.previewBaseWidth = 0;
    $(document).off('keydown.dcPreview');
    return this;
  };

  DocumentClassification.prototype._renderThumbMedia = function (page) {
    var kind = this._pageMediaKind(page);
    if (kind === 'text') {
      var snippet = this._thumbTextSnippet(this._resolveTextContent(page));
      return (
        '<div class="dc-thumb-text" aria-hidden="true" data-page-id="' +
        escapeHtml(page.pageId) + '">' +
        '<pre class="dc-thumb-text-body">' + escapeHtml(snippet || '(빈 텍스트)') + '</pre>' +
        '</div>'
      );
    }
    var url = kind === 'image' ? this._resolveThumbSrc(page) : '';
    if (!url) {
      // 와이어프레임/미제공 시: 배지 없는 문서형 플레이스홀더
      return (
        '<div class="dc-thumb-ph" aria-hidden="true">' +
        '<span class="dc-thumb-ph-lines"></span>' +
        '</div>'
      );
    }
    this.state.thumbCache[page.pageId] = url;
    if (this.options.lazyThumbs) {
      return '<img class="dc-thumb-img" data-src="' + escapeHtml(url) +
        '" data-page-id="' + escapeHtml(page.pageId) +
        '" src="' + TINY_GIF + '" alt="" draggable="false">';
    }
    return '<img class="dc-thumb-img" src="' + escapeHtml(url) +
      '" data-page-id="' + escapeHtml(page.pageId) +
      '" alt="" draggable="false">';
  };

  DocumentClassification.prototype._renderThumbCard = function (page) {
    var id = this._pageIdentity(page);
    var bottomLabel = this._thumbBottomLabel(page);
    var canDrag = this._canDragDrop() || this._canBucketReorder();
    var draggable = canDrag ? 'true' : 'false';
    var disabledClass = canDrag ? '' : ' dc-thumb-disabled';
    var checkedClass = this.state.rightSelected[page.pageId] ? ' dc-thumb-checked' : '';
    var showNew = this._showNewLabel() && page.isNew;
    var newBadge = showNew
      ? '<span class="dc-thumb-new" title="신규 유입">NEW</span>'
      : '';
    var titleText = this._formatThumbTitle(page, { showNew: true });
    var titleAttr = titleText ? ' title="' + escapeHtml(titleText) + '"' : '';
    var bottomHtml = bottomLabel
      ? '<span class="dc-thumb-label">' + escapeHtml(bottomLabel) + '</span>'
      : '';
    return (
      '<div class="dc-thumb-card' + disabledClass + checkedClass +
      (showNew ? ' dc-thumb-card-new' : '') +
      '" draggable="' + draggable + '" data-page-id="' + escapeHtml(page.pageId) + '" ' +
      'data-group-id="' + escapeHtml(page.groupId) + '" data-doc-type="' + escapeHtml(page.documentType) + '" ' +
      'data-inpt-task-id="' + escapeHtml(id.inptTaskId) + '" ' +
      'data-inpt-mst-srno="' + escapeHtml(id.inptMstSrno) + '" ' +
      'data-inpt-bl-grp-no="' + escapeHtml(id.inptBlGrpNo) + '" ' +
      'data-imex-his-cd="' + escapeHtml(id.imexHisCd) + '"' +
      titleAttr + '>' +
      newBadge +
      this._renderThumbMedia(page) +
      bottomHtml +
      '</div>'
    );
  };

  DocumentClassification.prototype._renderBucketCardsHtml = function (pages, start, end) {
    var html = '';
    var i;
    var from = typeof start === 'number' ? start : 0;
    var to = typeof end === 'number' ? end : pages.length;
    for (i = from; i < to; i++) {
      html += this._renderThumbCard(pages[i]);
    }
    return html;
  };

  DocumentClassification.prototype._emptyBucketMessage = function () {
    var msg = this.options.emptyBucketMessage;
    if (msg == null || String(msg).trim() === '') {
      return '문서분류 이미지가 없습니다';
    }
    return String(msg);
  };

  DocumentClassification.prototype._renderBlockBodyContent = function (groupId, pages) {
    if (!pages.length) {
      return '<div class="dc-drop-hint">' + escapeHtml(this._emptyBucketMessage()) + '</div>';
    }
    return this._renderBucketCardsHtml(pages);
  };

  DocumentClassification.prototype._defaultDocType = function () {
    var list = (this.state.data && this.state.data.documentTypes) || [];
    for (var i = 0; i < list.length; i++) {
      if (list[i] && list[i].key && list[i].key !== ETC_DOC_TYPE) return list[i].key;
    }
    return 'OT';
  };

  DocumentClassification.prototype._visibleGroupPages = function () {
    var dtype = this.state.activeDocType || this._defaultDocType();
    var gid = this.state.activeGroupId;
    if (!gid) return [];
    return this._pagesInBucket(gid, dtype);
  };

  DocumentClassification.prototype._countDocType = function (docType) {
    if (!this.state.data || !this.state.data.pages) return 0;
    var n = 0;
    this.state.data.pages.forEach(function (p) {
      if (p.documentType === docType) n += 1;
    });
    return n;
  };

  DocumentClassification.prototype._resolveInptMstSrno = function () {
    var data = this.state.data;
    if (!data) return '';
    var mst = data.actlFxRefno || data.ACTL_FX_REFNO || '';
    if (mst) return String(mst);
    var pages = data.pages || [];
    for (var i = 0; i < pages.length; i++) {
      var page = pages[i];
      if (!page) continue;
      mst = page.actlFxRefno || page.ACTL_FX_REFNO || '';
      if (mst) return String(mst);
    }
    return String(data.documentId || data.refNo || '');
  };

  DocumentClassification.prototype._renderMasterKey = function () {
    if (!this.$root || !this.$root.length) return;
    var $wrap = this.$root.find('[data-dc-mst-key-wrap]');
    var $value = this.$root.find('[data-dc-mst-key]');
    if (!$wrap.length) return;

    if (!this._showRefNoBar()) {
      $wrap.attr('hidden', true);
      return;
    }

    var mst = this._resolveInptMstSrno();
    var display = mst || '-';
    if ($value.length) $value.text(display);
    $wrap
      .removeAttr('hidden')
      .toggleClass('dc-refno-bar-boxed', this._refNoBarBoxed())
      .attr('title', mst ? ('ACTL_FX_REFNO=' + mst) : 'ACTL_FX_REFNO');
  };

  DocumentClassification.prototype._renderTypeTabs = function () {
    if (!this.$typeTabs || !this.$typeTabs.length) return;
    var types = ((this.state.data && this.state.data.documentTypes) || []).slice();
    var html = '';
    types.forEach(function (dt) {
      if (!dt || !dt.key || dt.key === ETC_DOC_TYPE) return;
      var count = this._countDocType(dt.key);
      html +=
        '<button type="button" class="dc-type-tab" data-doc-type="' + escapeHtml(dt.key) + '" ' +
        'title="' + escapeHtml(dt.label || dt.key) + '">' +
        '<span class="dc-type-badge ' + this._typeBadgeClass(dt.key) + '">' + escapeHtml(dt.key) + '</span>' +
        '<span class="dc-type-tab-label">' + escapeHtml(dt.label || dt.key) + '</span>' +
        '<span class="dc-bucket-count">' + count + '</span>' +
        '</button>';
    }, this);
    html +=
      '<button type="button" class="dc-type-tab dc-type-tab-etc" data-doc-type="' + ETC_DOC_TYPE + '" title="미분류">' +
      '<span class="dc-type-badge dc-type-etc">ETC</span>' +
      '<span class="dc-type-tab-label">미분류</span>' +
      '<span class="dc-bucket-count">' + this._countDocType(ETC_DOC_TYPE) + '</span>' +
      '</button>';
    this.$typeTabs.html(html);
  };

  DocumentClassification.prototype._renderGroupTabs = function () {
    if (!this.$groupTabs || !this.$groupTabs.length) return;
    var html = '';
    var dtype = this.state.activeDocType || this._workingDocType();
    var groups = this._visibleBlGroupsForDocType(dtype, { includeEmptyActive: true });
    groups.forEach(function (g) {
      var count = this._pagesInBucket(g.groupId, dtype).length;
      html +=
        '<button type="button" class="dc-group-tab" data-group-id="' + escapeHtml(g.groupId) + '">' +
        '<span>' + escapeHtml(g.label || g.groupId) + '</span>' +
        '<span class="dc-bucket-count">' + count + '</span>' +
        '</button>';
    }, this);
    this.$groupTabs.html(html);
  };

  DocumentClassification.prototype._fillMoveGroupOptions = function (docType, preferredGroupId) {
    if (!this.$moveGroup || !this.$moveGroup.length) return;
    var dtype = String(docType || '');
    var groupHtml = '';
    if (!dtype) {
      this.$moveGroup.html('<option value="">-</option>');
      return;
    }
    var groups = this._moveSelectableGroups(dtype);
    groups.forEach(function (g) {
      groupHtml +=
        '<option value="' + escapeHtml(g.groupId) + '">' +
        escapeHtml(g.label || g.groupId) +
        '</option>';
    });
    this.$moveGroup.html(groupHtml || '<option value="">(그룹 없음)</option>');
    var prefer = preferredGroupId || this.state.activeGroupId || '';
    if (prefer && this.$moveGroup.find('option[value="' + cssEscape(prefer) + '"]').length) {
      this.$moveGroup.val(prefer);
    } else if (groups.length) {
      this.$moveGroup.val(groups[0].groupId);
    }
  };

  DocumentClassification.prototype._renderMoveCombos = function () {
    if (!this.$moveDocType || !this.$moveDocType.length) return;
    var types = ((this.state.data && this.state.data.documentTypes) || []).slice();
    var docHtml = '';
    types.forEach(function (dt) {
      if (!dt || !dt.key || dt.key === ETC_DOC_TYPE) return;
      docHtml +=
        '<option value="' + escapeHtml(dt.key) + '">' +
        escapeHtml(dt.label || dt.key) +
        '</option>';
    });
    docHtml += '<option value="' + ETC_DOC_TYPE + '">미분류 (ETC)</option>';
    this.$moveDocType.html(docHtml);
    this._syncMoveCombosFromActive();
  };

  DocumentClassification.prototype._syncMoveCombosFromActive = function () {
    if (!this.$moveDocType || !this.$moveDocType.length) return;
    var dtype = this.state.activeDocType === ETC_DOC_TYPE
      ? ETC_DOC_TYPE
      : (this.state.activeDocType || this._defaultDocType());
    if (this.$moveDocType.find('option[value="' + cssEscape(dtype) + '"]').length) {
      this.$moveDocType.val(dtype);
    }
    this._fillMoveGroupOptions(dtype, this.state.activeGroupId);
    this._syncMoveGroupComboState();
  };

  DocumentClassification.prototype._syncMoveGroupComboState = function () {
    if (!this.$moveGroup || !this.$moveGroup.length) return;
    this.$moveGroup.prop('disabled', !this._canCheckMove());
  };

  DocumentClassification.prototype._renderTypeAndGroupStrips = function () {
    this._ensureActiveTarget();
    this._renderMasterKey();
    this._renderTypeTabs();
    this._renderGroupTabs();
    this._renderMoveCombos();
    this._syncActiveDom();
    this._renderGroupStrip();
    this._observeLazyThumbs(this.$root);
    this._syncSelectionDom();
  };

  DocumentClassification.prototype._renderGroupStrip = function () {
    if (!this.$board || !this.$board.length) return;
    var pages = this._visibleGroupPages();
    var html = '';
    if (!pages.length) {
      html = '<div class="dc-drop-hint">' +
        (this.state.activeDocType === ETC_DOC_TYPE
          ? '미분류 페이지가 없습니다.'
          : escapeHtml(this._emptyBucketMessage())) +
        '</div>';
    } else {
      html = this._renderBucketCardsHtml(pages);
    }
    this.state.suppressScrollCapture = true;
    try {
      this.$board.html(html);
    } finally {
      this.state.suppressScrollCapture = false;
    }
    var docType = this.state.activeDocType || this._defaultDocType();
    var typeLabel = this._docTypeDisplayLabel(docType);
    var titleHtml =
      '<span class="dc-section-title dc-group-strip-title-inner">' +
      '<span class="dc-group-strip-doc-label">' + escapeHtml(typeLabel) + '</span>' +
      '</span>';
    this.$root.find('[data-dc-group-strip-title]').html(titleHtml);
  };

  DocumentClassification.prototype._renderSection = function (groupId, docType, title) {
    var pages = this._pagesInBucket(groupId, docType);
    var isActive = this.state.activeGroupId === groupId && this.state.activeDocType === docType;
    var isNewType = this._showNewLabel() && this._isNewDocType(docType);
    var clearBtn = pages.length > 0 && this._canDelete()
      ? '<button type="button" class="dc-clear-type-btn" data-group-id="' + escapeHtml(groupId) +
        '" data-doc-type="' + escapeHtml(docType) + '" title="이 문서분류 → 미분류">비우기</button>'
      : '';
    var newBadge = isNewType ? '<span class="dc-bucket-new">NEW</span>' : '';
    var bodyHtml = this._renderBlockBodyContent(groupId, pages);
    var bucketKey = this._bucketKey(groupId, docType);
    return (
      '<div class="dc-section' + (isActive ? ' dc-section-active' : '') +
      (isNewType ? ' dc-bucket-new-type' : '') +
      '" data-group-id="' + escapeHtml(groupId) +
      '" data-doc-type="' + escapeHtml(docType) +
      '" data-bucket="' + escapeHtml(bucketKey) + '">' +
      '<div class="dc-section-head">' +
      '<span class="dc-section-title">' +
      '<span class="dc-type-badge ' + this._typeBadgeClass(docType) + '">' + escapeHtml(docType) + '</span>' +
      escapeHtml(title) + newBadge +
      '</span>' +
      '<span class="dc-bucket-count">' + pages.length + '</span>' +
      clearBtn +
      '</div>' +
      '<div class="dc-section-body" data-drop-zone="1">' + bodyHtml + '</div>' +
      '</div>'
    );
  };

  DocumentClassification.prototype._renderGroupBlock = function (group) {
    this._ensureGroupBuckets(group);
    var pages = this._pagesInGroup(group.groupId);
    var isActive = this.state.activeGroupId === group.groupId;
    var deleteGroupButton = this._canDelete()
      ? '<button type="button" class="dc-del-btn dc-del-group" data-group-id="' +
        escapeHtml(group.groupId) + '" title="그룹 삭제 (페이지→미분류)">×</button>'
      : '';
    var sectionsHtml = '';
    group.buckets.forEach(function (b) {
      var pageCount = this._pagesInBucket(group.groupId, b.documentType).length;
      if (!this.options.showEmptyBuckets && pageCount === 0 && !this._getDocTypeMeta(b.documentType)) {
        return;
      }
      var meta = this._getDocTypeMeta(b.documentType);
      sectionsHtml += this._renderSection(
        group.groupId,
        b.documentType,
        b.label || (meta && meta.label) || b.documentType
      );
    }, this);

    return (
      '<div class="dc-block' + (isActive ? ' dc-block-active' : '') +
      '" data-group-id="' + escapeHtml(group.groupId) +
      '" data-group-type="' + escapeHtml(group.groupType) + '">' +
      '<div class="dc-block-head">' +
      '<span class="dc-group-label">' +
      '<span class="dc-group-name">' + this._groupTitleHtml(group) + '</span>' +
      '</span>' +
      '<span class="dc-bucket-count">' + pages.length + '</span>' +
      deleteGroupButton +
      '</div>' +
      '<div class="dc-block-sections">' + sectionsHtml + '</div>' +
      '</div>'
    );
  };

  DocumentClassification.prototype._rewriteBlockDom = function (groupId, scrollSnapshot) {
    var group = (this.state.data.groups || []).filter(function (g) {
      return g.groupId === groupId;
    })[0];
    if (!group) return false;
    var $block = this.$board.find('.dc-block[data-group-id="' + cssEscape(groupId) + '"]');
    if (!$block.length) return false;
    var snapshot = scrollSnapshot || this._snapshotScrollPositions($block);
    this.state.suppressScrollCapture = true;
    try {
      $block.replaceWith(this._renderGroupBlock(group));
    } finally {
      this.state.suppressScrollCapture = false;
    }
    var $new = this.$board.find('.dc-block[data-group-id="' + cssEscape(groupId) + '"]');
    this._observeLazyThumbs($new);
    this._syncActiveDom();
    this._syncSelectionDom();
    this._restoreScrollPositions($new, snapshot);
    return true;
  };

  DocumentClassification.prototype._refreshBlocks = function (groupIds) {
    var startedAt = nowMs();
    var snapshot = this._snapshotScrollPositions();
    this._renderTypeAndGroupStrips();
    this._restoreScrollPositions(null, snapshot);
    this._applyOptionVisibility();
    this._refreshSavePreview(false);
    this._updatePerfStats('incremental', startedAt);
    return this;
  };

  DocumentClassification.prototype._finalizeVirtualBlocks = function () {
    // V3: 섹션 단위 가로 스크롤 — 가상 스크롤 미사용
  };

  DocumentClassification.prototype._ensureGroupBuckets = function (group) {
    if (!group) return;
    var catalog = (this.state.data && this.state.data.documentTypes) || [];
    var buckets = [];
    var existing = {};
    var prevByType = {};

    (group.buckets || []).forEach(function (bucket) {
      if (!bucket || !bucket.documentType) return;
      prevByType[bucket.documentType] = bucket;
    });

    catalog.forEach(function (dt) {
      if (!dt || !dt.key || dt.key === ETC_DOC_TYPE) return;
      var prev = prevByType[dt.key];
      buckets.push({
        documentType: dt.key,
        label: (prev && prev.label) || dt.label || dt.key
      });
      existing[dt.key] = true;
    });

    Object.keys(prevByType).forEach(function (key) {
      if (existing[key]) return;
      var prev = prevByType[key];
      buckets.push({
        documentType: key,
        label: (prev && prev.label) || (key === ETC_DOC_TYPE ? '미분류' : key)
      });
      existing[key] = true;
    });

    group.buckets = this._sortBucketsByInflowPosition(buckets);
  };

  DocumentClassification.prototype._allPagesSorted = function () {
    if (!this.state.data) return [];
    var self = this;
    return this.state.data.pages.slice().sort(function (a, b) {
      var ta = self._pageFilterValue(a, 'inptTaskId');
      var tb = self._pageFilterValue(b, 'inptTaskId');
      if (ta !== tb) return ta < tb ? -1 : 1;
      var ea = self._pageFilterValue(a, 'inptElmtId');
      var eb = self._pageFilterValue(b, 'inptElmtId');
      if (ea !== eb) return ea < eb ? -1 : 1;
      var ha = self._pageFilterValue(a, 'imexHisCd');
      var hb = self._pageFilterValue(b, 'imexHisCd');
      if (ha !== hb) return ha < hb ? -1 : 1;
      return String(a.pageId).localeCompare(String(b.pageId));
    });
  };

  DocumentClassification.prototype._pageFilterValue = function (page, key) {
    if (!page || !key) return '';
    if (key === 'imexHisCd') {
      return String(page.imexHisCd || page.IMEX_HIS_CD || page.documentType || '');
    }
    if (key === 'inptMstSrno') {
      return String(
        page.inptMstSrno || page.INPT_MST_SRNO ||
        (this.state.data && (this.state.data.inptMstSrno || this.state.data.INPT_MST_SRNO ||
          this.state.data.documentId || this.state.data.refNo)) ||
        ''
      );
    }
    if (key === 'inptElmtId') {
      return String(page.inptElmtId || page.INPT_ELMT_ID || page.inptTaskId || page.pageId || '');
    }
    if (key === 'inptTaskId') {
      return String(page.inptTaskId || page.INPT_TASK_ID || page.pageId || '');
    }
    if (key === 'inptBlGrpNo') {
      return String(page.inptBlGrpNo || page.INPT_BL_GRP_NO || page.groupId || '');
    }
    var columns = this.options.etcFilterColumns || [];
    var col = null;
    var i;
    for (i = 0; i < columns.length; i++) {
      if (columns[i].key === key) {
        col = columns[i];
        break;
      }
    }
    if (col && Array.isArray(col.aliases)) {
      for (i = 0; i < col.aliases.length; i++) {
        var alias = col.aliases[i];
        if (page[alias] != null && page[alias] !== '') {
          return String(page[alias]);
        }
      }
    }
    if (page[key] != null && page[key] !== '') return String(page[key]);
    var upper = String(key).toUpperCase();
    if (page[upper] != null && page[upper] !== '') return String(page[upper]);
    return '';
  };

  DocumentClassification.prototype._filteredPages = function () {
    var self = this;
    var columns = this._activeEtcFilterColumns();
    return this._allPagesSorted().filter(function (page) {
      // 우측 풀 = ETC(미분류)만 표시. BL 배정 시 목록에서 사라짐
      if (page.groupId !== ETC_GROUP_ID) return false;
      var i;
      for (i = 0; i < columns.length; i++) {
        var key = columns[i].key;
        var query = String((self.state.tableFilter && self.state.tableFilter[key]) || '')
          .trim()
          .toLowerCase();
        if (!query) continue;
        if (self._pageFilterValue(page, key).toLowerCase().indexOf(query) === -1) {
          return false;
        }
      }
      return true;
    });
  };

  DocumentClassification.prototype._renderFilterOptions = function () {
    var filter = this.state.tableFilter || {};
    this.$root.find('[data-dc-filter]').each(function () {
      var key = String($(this).data('dcFilter') || '');
      if (!key) return;
      var next = filter[key] == null ? '' : String(filter[key]);
      if ($(this).val() !== next) $(this).val(next);
    });
  };

  DocumentClassification.prototype._renderPageTable = function () {
    if (!this.$sourceThumbs || !this.$sourceThumbs.length) return;
    var sourceScrollTop = this.$tableWrap && this.$tableWrap[0]
      ? this.$tableWrap[0].scrollTop
      : this.state.sourceScrollTop;
    if (!this.state.data) {
      this.$sourceThumbs.html('<div class="dc-empty">데이터가 없습니다.</div>');
      this.$root.find('[data-dc-table-count]').text('0');
      this._updateSelectedCount();
      return;
    }
    this._renderFilterOptions();
    var pages = this._filteredPages();
    var html = '';
    var i;
    for (i = 0; i < pages.length; i++) {
      html += this._renderSourceThumbCard(pages[i]);
    }
    if (!pages.length) {
      html = '<div class="dc-empty">미분류 페이지가 없습니다. 모두 좌측 BL 블럭에 배정된 상태입니다.</div>';
    }
    this.state.suppressScrollCapture = true;
    try {
      this.$sourceThumbs.html(html);
    } finally {
      this.state.suppressScrollCapture = false;
    }
    this.$root.find('[data-dc-table-count]').text(String(pages.length));
    this._updateSelectedCount();
    this._observeLazyThumbs(this.$tableWrap);
    if (this.$tableWrap && this.$tableWrap[0] && typeof sourceScrollTop === 'number') {
      this.state.sourceScrollTop = sourceScrollTop;
      this.state.suppressScrollCapture = true;
      try {
        this.$tableWrap[0].scrollTop = sourceScrollTop;
      } finally {
        this.state.suppressScrollCapture = false;
      }
    }
  };

  DocumentClassification.prototype._renderSourceThumbCard = function (page) {
    var selected = !!this.state.selected[page.pageId];
    var id = this._pageIdentity(page);
    var showNew = this._showNewLabel() && page.isNew;
    var newBadge = showNew
      ? '<span class="dc-thumb-new" title="신규 유입">NEW</span>'
      : '';
    var titleText = this._formatThumbTitle(page, { showNew: true });
    var titleAttr = titleText ? ' title="' + escapeHtml(titleText) + '"' : '';
    var bottomHtml = this._showThumbTaskId()
      ? '<span class="dc-thumb-label">' + escapeHtml(id.inptTaskId) + '</span>' +
        '<span class="dc-thumb-page">' + escapeHtml(id.imexHisCd) + '</span>'
      : '';
    return (
      '<div class="dc-thumb-card' + (selected ? ' dc-thumb-checked' : '') +
      (showNew ? ' dc-thumb-card-new' : '') +
      '" draggable="false" data-page-id="' + escapeHtml(page.pageId) + '" ' +
      'data-group-id="' + escapeHtml(page.groupId) + '" data-doc-type="' + escapeHtml(page.documentType) + '" ' +
      'data-inpt-task-id="' + escapeHtml(id.inptTaskId) + '" ' +
      'data-inpt-mst-srno="' + escapeHtml(id.inptMstSrno) + '" ' +
      'data-inpt-bl-grp-no="' + escapeHtml(id.inptBlGrpNo) + '" ' +
      'data-imex-his-cd="' + escapeHtml(id.imexHisCd) + '"' +
      titleAttr + '>' +
      newBadge +
      this._renderThumbMedia(page) +
      bottomHtml +
      '</div>'
    );
  };

  DocumentClassification.prototype.getSelectedPageIds = function () {
    return Object.keys(this.state.selected).filter(function (id) {
      return !!this.state.selected[id];
    }, this);
  };

  DocumentClassification.prototype._updateSelectedCount = function () {
    var n = this.getRightSelectedPageIds().length;
    this.$root.find('[data-dc-selected-count]').text(n + '건 선택');
  };

  DocumentClassification.prototype._isBlAccumulateOn = function () {
    var $cb = this.$root && this.$root.find('[data-dc-bl-accumulate]');
    if ($cb && $cb.length) return !!$cb.prop('checked');
    return !!this.state.blAccumulate;
  };

  /** 현재 문서분류 × BL 스트립만 전체 선택 (누적 ON이면 기존 선택에 합침) */
  DocumentClassification.prototype._toggleSelectEntireActiveGroup = function (checked) {
    var pages = this._visibleGroupPages();
    var gid = String(this.state.activeGroupId || '');
    var dtype = String(this.state.activeDocType || this._defaultDocType() || '');
    if (!this._isBlAccumulateOn()) {
      this.state.rightSelected = {};
      this.state.selected = {};
      this.state.lastCheckedPageId = null;
      this.state.lastRightCheckedPageId = null;
    }
    pages.forEach(function (page) {
      if (checked) this.state.rightSelected[page.pageId] = true;
      else delete this.state.rightSelected[page.pageId];
    }, this);
    this.state.lastRightCheckedPageId = pages.length ? pages[pages.length - 1].pageId : null;
    this._syncSelectionDom();
    var stripN = pages.length;
    var totalN = this.getRightSelectedPageIds().length;
    if (checked) {
      var label = (dtype && gid ? (dtype + ' · ' + gid) : (gid || dtype || '스트립'));
      this._setStatus(
        stripN
          ? (label + ' ' + stripN + '건을 선택했습니다.' +
            (this._isBlAccumulateOn() && totalN > stripN ? (' (누적 합계 ' + totalN + '건)') : ''))
          : (label + '에 선택 가능한 이미지가 없습니다.'),
        stripN ? 'info' : 'warn'
      );
    }
  };

  DocumentClassification.prototype._toggleRowSelection = function (pageId, shiftKey, forceChecked) {
    if (!pageId || !this._findPage(pageId)) return;
    var next;
    if (typeof forceChecked === 'boolean') {
      next = forceChecked;
    } else {
      next = !this.state.selected[pageId];
    }
    if (shiftKey && this.state.lastCheckedPageId) {
      var pages = this._filteredPages();
      var ids = pages.map(function (p) { return p.pageId; });
      var from = ids.indexOf(this.state.lastCheckedPageId);
      var to = ids.indexOf(pageId);
      if (from !== -1 && to !== -1) {
        var start = Math.min(from, to);
        var end = Math.max(from, to);
        var i;
        for (i = start; i <= end; i++) {
          if (next) this.state.selected[ids[i]] = true;
          else delete this.state.selected[ids[i]];
        }
      }
    } else if (next) {
      this.state.selected[pageId] = true;
    } else {
      delete this.state.selected[pageId];
    }
    this.state.lastCheckedPageId = pageId;
    this._syncSelectionDom();
  };

  DocumentClassification.prototype._toggleSelectFiltered = function (checked) {
    var pages = this._filteredPages();
    pages.forEach(function (page) {
      if (checked) this.state.selected[page.pageId] = true;
      else delete this.state.selected[page.pageId];
    }, this);
    this._syncSelectionDom();
  };

  DocumentClassification.prototype.clearSelection = function () {
    this.state.selected = {};
    this.state.rightSelected = {};
    this.state.lastCheckedPageId = null;
    this.state.lastRightCheckedPageId = null;
    this._syncSelectionDom();
    return this;
  };

  DocumentClassification.prototype.getRightSelectedPageIds = function () {
    // 이동/카운트는 선택 상태 전체를 사용한다.
    // (이전: 현재 스트립 visible 만 반환 → 그룹 전체 선택이 이동에 반영되지 않음)
    return Object.keys(this.state.rightSelected || {}).filter(function (id) {
      return !!this.state.rightSelected[id] && !!this._findPage(id);
    }, this);
  };

  DocumentClassification.prototype._toggleRightSelection = function (pageId, shiftKey, forceChecked) {
    if (!pageId || !this._findPage(pageId)) return;
    var next;
    if (typeof forceChecked === 'boolean') {
      next = forceChecked;
    } else {
      next = !this.state.rightSelected[pageId];
    }
    if (shiftKey && this.state.lastRightCheckedPageId) {
      var pages = this._visibleGroupPages();
      // 같은 스트립 전체 순서 기준으로 구간 선택
      var ids = pages.map(function (p) { return p.pageId; });
      var from = ids.indexOf(this.state.lastRightCheckedPageId);
      var to = ids.indexOf(pageId);
      if (from !== -1 && to !== -1) {
        var start = Math.min(from, to);
        var end = Math.max(from, to);
        var i;
        for (i = start; i <= end; i++) {
          if (next) this.state.rightSelected[ids[i]] = true;
          else delete this.state.rightSelected[ids[i]];
        }
      } else if (next) {
        this.state.rightSelected[pageId] = true;
      } else {
        delete this.state.rightSelected[pageId];
      }
    } else if (next) {
      this.state.rightSelected[pageId] = true;
    } else {
      delete this.state.rightSelected[pageId];
    }
    this.state.lastRightCheckedPageId = pageId;
    this._syncSelectionDom();
  };

  DocumentClassification.prototype._resolveDragMoveIds = function () {
    var dragId = String(this.state.dragPageId || '');
    var selected = this.getRightSelectedPageIds();
    if (dragId && selected.indexOf(dragId) !== -1 && selected.length > 1) {
      return this._orderedMoveIds(selected);
    }
    return dragId ? [dragId] : [];
  };

  /** 보드 DOM(섹션 가로 순서) 기준으로 이동 ID 정렬 */
  DocumentClassification.prototype._orderedMoveIds = function (pageIds) {
    var set = {};
    (pageIds || []).forEach(function (id) { set[String(id)] = true; });
    var ordered = [];
    if (this.$board && this.$board.length) {
      this.$board.find('.dc-thumb-card').each(function () {
        var id = String($(this).data('pageId') || '');
        if (set[id]) {
          ordered.push(id);
          delete set[id];
        }
      });
    }
    (pageIds || []).forEach(function (id) {
      id = String(id);
      if (set[id]) ordered.push(id);
    });
    return ordered;
  };

  DocumentClassification.prototype._clearDropSplitBar = function (zone) {
    if (zone) {
      var $zone = $(zone);
      $zone.removeClass('dc-drop-over');
      $zone.children('.dc-drop-split').remove();
    } else if (this.$board) {
      this.$board.find('.dc-drop-over').removeClass('dc-drop-over');
      this.$board.find('.dc-drop-split').remove();
    }
    this.state.dropInsertIndex = null;
  };

  DocumentClassification.prototype._updateDropSplitBar = function (zone, clientX) {
    if (!zone) return;
    var $zone = $(zone);
    $zone.addClass('dc-drop-over');
    var insertIndex = this._getInsertIndex(zone, null, clientX);
    this.state.dropInsertIndex = insertIndex;

    var cards = $zone.find('.dc-thumb-card:not(.dc-dragging)').get();
    var zoneRect = zone.getBoundingClientRect();
    var left;
    if (!cards.length) {
      left = 8 + (zone.scrollLeft || 0);
    } else if (insertIndex >= cards.length) {
      var lastRect = cards[cards.length - 1].getBoundingClientRect();
      left = lastRect.right - zoneRect.left + (zone.scrollLeft || 0) + 3;
    } else {
      var nextRect = cards[insertIndex].getBoundingClientRect();
      left = nextRect.left - zoneRect.left + (zone.scrollLeft || 0) - 3;
    }

    var $bar = $zone.children('.dc-drop-split');
    if (!$bar.length) {
      $bar = $('<div class="dc-drop-split" aria-hidden="true"></div>').appendTo($zone);
    }
    $bar.css('left', Math.max(0, left) + 'px');
  };

  DocumentClassification.prototype._syncSelectionDom = function () {
    var self = this;
    this.$board.find('.dc-thumb-card').each(function () {
      var pageId = String($(this).data('pageId') || '');
      $(this).toggleClass('dc-thumb-checked', !!self.state.rightSelected[pageId]);
    });
    this._updateSelectedCount();
  };

  DocumentClassification.prototype.render = function () {
    var startedAt = nowMs();
    if (!this.state.data) {
      this.$board.html('<div class="dc-empty">데이터가 없습니다.</div>');
      this._updatePerfStats('full', startedAt);
      return this;
    }
    this._ensureActiveTarget();
    this._ensureThumbObserver();
    var snapshot = this._snapshotScrollPositions();
    this._renderTypeAndGroupStrips();
    this._restoreScrollPositions(null, snapshot);
    this._applyOptionVisibility();
    this._refreshLoadedPreview(false);
    this._refreshSavePreview(false);
    this._updatePerfStats('full', startedAt);
    return this;
  };

  DocumentClassification.prototype._refreshLoadedPreview = function (force) {
    if (!this.options.showJsonPreview) return;
    if (!this.state.original) {
      this.$jsonLoaded.text('');
      this.state.jsonDirty.loaded = false;
      return;
    }
    if (this.options.deferJsonPreview && !force && this._activeJsonPane() !== 'loaded') {
      this.state.jsonDirty.loaded = true;
      return;
    }
    this.$jsonLoaded.text(JSON.stringify(this.state.original, null, 2));
    this.state.jsonDirty.loaded = false;
  };

  DocumentClassification.prototype._refreshSavePreview = function (force) {
    if (!this.options.showJsonPreview) return;
    if (!this.state.data) {
      this.$jsonSave.text('');
      this.state.jsonDirty.save = false;
      return;
    }
    if (this.options.deferJsonPreview && !force && this._activeJsonPane() !== 'save') {
      this.state.jsonDirty.save = true;
      return;
    }
    this.$jsonSave.text(JSON.stringify(this.getSavePayload(), null, 2));
    this.state.jsonDirty.save = false;
  };

  DocumentClassification.prototype._getInsertIndex = function (zone, clientY, clientX) {
    var $zone = $(zone);
    var cards = $zone.find('.dc-thumb-card:not(.dc-dragging)');
    // 가로 썸네일 스트립: X 기준 삽입 위치
    for (var i = 0; i < cards.length; i++) {
      var rect = cards[i].getBoundingClientRect();
      var midX = rect.left + rect.width / 2;
      if ((typeof clientX === 'number' ? clientX : midX) < midX) return i;
    }
    return cards.length;
  };

  DocumentClassification.prototype._onDragStart = function (e, el) {
    if (!this._canBucketReorder()) return;
    this._snapshotScrollPositions();
    var $card = $(el);
    var pageId = String($card.data('pageId') || '');
    this.state.dragPageId = pageId;
    this.state.dragSourceGroup = String($card.data('groupId') || '');
    this.state.dragSourceDocType = String($card.data('docType') || '');
    if (pageId && !this.state.rightSelected[pageId]) {
      this.state.rightSelected = {};
      this.state.rightSelected[pageId] = true;
    }
    this.state.selected = {};
    this._syncSelectionDom();
    $card.addClass('dc-dragging');
    var moveIds = this._resolveDragMoveIds();
    var self = this;
    moveIds.forEach(function (id) {
      self.$root.find('.dc-thumb-card[data-page-id="' + cssEscape(id) + '"]').addClass('dc-dragging');
    });
    e.originalEvent.dataTransfer.effectAllowed = 'move';
    e.originalEvent.dataTransfer.setData('text/plain', pageId);
  };

  DocumentClassification.prototype._onDragEnd = function (e, el) {
    this.$root.find('.dc-thumb-card.dc-dragging').removeClass('dc-dragging');
    this.$root.find('.dc-type-tab, .dc-group-tab').removeClass('dc-drop-over');
    this._clearDropSplitBar();
    this.state.dragPageId = null;
    this.state.dragSourceGroup = null;
    this.state.dragSourceDocType = null;
    // 드래그 직후 click 토글 방지
    this.state.suppressBoardClick = true;
    var self = this;
    window.setTimeout(function () {
      self.state.suppressBoardClick = false;
    }, 50);
  };

  DocumentClassification.prototype._onDrop = function (e, zone) {
    if (!this._canBucketReorder() && !this._canDragDrop()) return;
    e.preventDefault();
    e.stopPropagation();
    if (!this.state.dragPageId) {
      this._clearDropSplitBar(zone);
      this.$root.find('.dc-type-tab, .dc-group-tab').removeClass('dc-drop-over');
      return;
    }

    var scrollSnapshot = this._snapshotScrollPositions();
    var $zone = $(zone);
    var targetGroupId = '';
    var targetDocType = '';
    var insertIndex = 0;

    if ($zone.hasClass('dc-type-tab')) {
      if (!this._canDragDrop()) {
        this._clearDropSplitBar(zone);
        this.$root.find('.dc-type-tab, .dc-group-tab').removeClass('dc-drop-over');
        return;
      }
      targetDocType = String($zone.data('docType') || '');
      targetGroupId = this.state.activeGroupId || this._defaultBlGroupId();
      if (targetDocType === ETC_DOC_TYPE) {
        this.setActiveTarget(targetGroupId, ETC_DOC_TYPE);
      } else {
        this.setActiveTarget(targetGroupId, targetDocType);
      }
    } else if ($zone.hasClass('dc-group-tab')) {
      if (!this._canDragDrop()) {
        this._clearDropSplitBar(zone);
        this.$root.find('.dc-type-tab, .dc-group-tab').removeClass('dc-drop-over');
        return;
      }
      targetGroupId = String($zone.data('groupId') || '');
      targetDocType = this.state.activeDocType || this._workingDocType();
      if (targetGroupId === ETC_GROUP_ID) {
        targetGroupId = this._defaultBlGroupId();
        targetDocType = ETC_DOC_TYPE;
      }
      this.setActiveTarget(targetGroupId, targetDocType);
    } else {
      // 스트립 안 드롭 = 순서 정렬 (allowBucketReorder)
      if (!this._canBucketReorder()) {
        this._clearDropSplitBar(zone);
        return;
      }
      targetGroupId = this.state.activeGroupId || this._defaultBlGroupId();
      targetDocType = this.state.activeDocType || this._workingDocType();
      if (targetGroupId === ETC_GROUP_ID) {
        targetGroupId = this._defaultBlGroupId();
        targetDocType = ETC_DOC_TYPE;
      }
      insertIndex = this._getInsertIndex(zone, e.originalEvent.clientY, e.originalEvent.clientX);
      if (typeof this.state.dropInsertIndex === 'number') {
        insertIndex = this.state.dropInsertIndex;
      }
    }

    this._clearDropSplitBar(zone);
    this.$root.find('.dc-type-tab, .dc-group-tab').removeClass('dc-drop-over');
    if (!targetGroupId || !targetDocType) return;

    var moveIds = this._resolveDragMoveIds();
    if (!moveIds.length) return;

    this.state.boardScrollTop = scrollSnapshot.boardScrollTop;
    this.state.sourceScrollTop = scrollSnapshot.sourceScrollTop;
    this.state.bucketScroll = $.extend({}, scrollSnapshot.bucketScroll);
    this._placePagesAt(moveIds, targetGroupId, targetDocType, insertIndex);
  };

  /**
   * 선택 페이지를 대상 섹션의 insertIndex 위치에 일괄 배치 (같은 섹션 복수 정렬 / 다른 섹션 재분류).
   */
  DocumentClassification.prototype._placePagesAt = function (pageIds, targetGroupId, targetDocType, insertIndex) {
    if (!pageIds || !pageIds.length || !this.state.data) return false;
    targetGroupId = String(targetGroupId || '');
    targetDocType = String(targetDocType || '');
    if (targetGroupId === ETC_GROUP_ID || (!targetGroupId && targetDocType === ETC_DOC_TYPE)) {
      targetGroupId = this._defaultBlGroupId();
      targetDocType = ETC_DOC_TYPE;
    }
    if (targetDocType === ETC_DOC_TYPE && (!targetGroupId || targetGroupId === ETC_GROUP_ID)) {
      targetGroupId = this._defaultBlGroupId();
    }
    if (targetGroupId && targetGroupId !== ETC_GROUP_ID) {
      if (!this._ensureBlGroupExists(targetGroupId)) return false;
    }
    var self = this;
    var moveIds = this._orderedMoveIds(pageIds);
    var targetKey = this._bucketKey(targetGroupId, targetDocType);
    var fromGroups = {};
    var fromDocTypes = {};
    var reclassifiedIds = [];
    var reorderIds = [];

    // 대상 섹션의 기존 순서(이동분 제외)를 돌연변이 전에 확보 → 드롭 위치 삽입용
    var remaining = this._pagesInBucket(targetGroupId, targetDocType)
      .map(function (p) { return p.pageId; })
      .filter(function (id) { return moveIds.indexOf(id) === -1; });

    moveIds.forEach(function (pageId) {
      var page = self._findPage(pageId);
      if (!page) return;
      fromGroups[page.groupId] = true;
      fromDocTypes[String(page.documentType || '')] = true;
      var fromKey = self._bucketKey(page.groupId, page.documentType);
      if (fromKey === targetKey) {
        reorderIds.push(pageId);
      } else {
        self._applyPageClassification(page, targetGroupId, targetDocType);
        self._markPageNew(page, true);
        reclassifiedIds.push(pageId);
      }
    });

    if (!reorderIds.length && !reclassifiedIds.length) return false;

    Object.keys(fromGroups).forEach(function (gid) {
      self._removeFromGroupOrder(gid, moveIds);
    });
    this._removeFromGroupOrder(targetGroupId, moveIds);

    var idx = typeof insertIndex === 'number' ? insertIndex : remaining.length;
    if (idx < 0) idx = 0;
    if (idx > remaining.length) idx = remaining.length;
    var nextBucket = remaining.slice(0, idx).concat(moveIds, remaining.slice(idx));

    // 드롭 위치 기준으로 대상 버킷 순서를 groupOrder에 반영
    this._rebuildGroupOrderFromBuckets(targetGroupId, targetDocType, nextBucket);
    this._syncSortOrderFromGroup(targetGroupId);
    Object.keys(fromGroups).forEach(function (gid) {
      if (gid !== targetGroupId && gid !== ETC_GROUP_ID) {
        self._syncSortOrderFromGroup(gid);
      }
    });
    this._rebuildPageIndex();
    var registeredNewType = false;
    if (reclassifiedIds.length) {
      registeredNewType = !!this._ensureTargetBucketMeta(targetGroupId, targetDocType);
    }

    this.setActiveTarget(targetGroupId, targetDocType);
    var scrollSnapshot = this._snapshotScrollPositions();
    var sample = this._findPage(moveIds[0]);
    if (reclassifiedIds.length) {
      reclassifiedIds.forEach(function (id) {
        delete self.state.rightSelected[id];
      });
      this._logChange(
        moveIds.length + '건 이동 → ' + this._formatPageLabel(sample),
        {
          op: 'MOVE_PAGE',
          pageIds: moveIds,
          to: { groupId: targetGroupId, documentType: targetDocType, insertIndex: idx }
        }
      );
      this._setStatus(
        moveIds.length + '건을 ' + targetGroupId + ' / ' + targetDocType +
        ' (' + (idx + 1) + '번째 위치) 로 이동했습니다.',
        'ok'
      );
    } else {
      this._logChange(
        moveIds.length + '건 순서 변경 → ' + this._formatPageLabel(sample),
        {
          op: 'REORDER_PAGE',
          pageIds: moveIds,
          to: { groupId: targetGroupId, documentType: targetDocType, insertIndex: idx }
        }
      );
      this._setStatus(moveIds.length + '건 순서를 변경했습니다.', 'ok');
    }

    var refresh = Object.keys(fromGroups).concat([targetGroupId]).filter(function (g) {
      return g && g !== ETC_GROUP_ID;
    });
    this.state.boardScrollTop = scrollSnapshot.boardScrollTop;
    this.state.sourceScrollTop = scrollSnapshot.sourceScrollTop;
    this.state.bucketScroll = $.extend({}, scrollSnapshot.bucketScroll);

    var prune = reclassifiedIds.length
      ? this._removeEmptyGroups(Object.keys(fromGroups), {
        silent: true,
        documentTypes: Object.keys(fromDocTypes || {}).concat([targetDocType])
      })
      : { removed: [], renames: [] };
    if (prune.renames.length) {
      targetGroupId = this._applyActiveGroupRenames(prune.renames, targetGroupId);
      this.state.activeGroupId = targetGroupId;
    }
    if (prune.removed.length || prune.renames.length) {
      var pruneSummary = this._formatPruneSummary(prune);
      if (pruneSummary) {
        this._logChange(pruneSummary, {
          op: 'DELETE_GROUP',
          groupIds: prune.removed,
          auto: true,
          renumbered: prune.renames
        });
      }
    }
    if (registeredNewType || prune.removed.length || prune.renames.length) {
      this.render();
    } else {
      this._refreshBlocks(refresh);
    }
    return true;
  };

  DocumentClassification.prototype._rebuildGroupOrderFromBuckets = function (groupId, changedDocType, orderedIds) {
    var self = this;
    var group = (this.state.data.groups || []).filter(function (g) {
      return g.groupId === groupId;
    })[0];
    if (!group) return;
    this._ensureGroupBuckets(group);
    var next = [];
    var seen = {};
    var ordered = (orderedIds || []).slice();

    group.buckets.forEach(function (b) {
      var ids;
      if (b.documentType === changedDocType) {
        ids = ordered;
      } else {
        // pageIndex가 아직 갱신되지 않아도 현재 page 필드로 소속 여부를 판별
        ids = self._pagesInBucket(groupId, b.documentType)
          .map(function (p) { return p.pageId; })
          .filter(function (id) {
            var page = self._findPage(id);
            return !!(
              page &&
              page.groupId === groupId &&
              page.documentType === b.documentType &&
              ordered.indexOf(id) === -1
            );
          });
      }
      ids.forEach(function (id) {
        if (!id || seen[id]) return;
        seen[id] = true;
        next.push(id);
      });
    });

    // 누락된 동일 그룹 페이지 보완
    (this.state.data.pages || []).forEach(function (page) {
      if (page.groupId !== groupId || seen[page.pageId]) return;
      seen[page.pageId] = true;
      next.push(page.pageId);
    });

    this.state.groupOrder[groupId] = next;
  };

  DocumentClassification.prototype._ensureTargetBucketMeta = function (targetGroupId, targetDocType) {
    if (targetGroupId === ETC_GROUP_ID) return false;
    // 미분류는 문서분류 카탈로그/버킷 메타에 넣지 않음 (페이지 필드만 ETC)
    if (!targetDocType || targetDocType === ETC_DOC_TYPE) return false;
    var registered = this._registerDocumentType(
      targetDocType,
      (this._getDocTypeMeta(targetDocType) || {}).label || targetDocType
    );
    this._removeDeletion('buckets', {
      groupId: targetGroupId,
      documentType: targetDocType
    });
    var group = this.state.data.groups.filter(function (g) { return g.groupId === targetGroupId; })[0];
    if (!group) return registered;
    this._ensureGroupBuckets(group);
    var targetBucket = group.buckets.filter(function (b) {
      return b.documentType === targetDocType;
    })[0];
    if (!targetBucket) {
      var meta = this._getDocTypeMeta(targetDocType);
      group.buckets.push({
        documentType: targetDocType,
        label: (meta && meta.label) || targetDocType
      });
    }
    return registered;
  };

  DocumentClassification.prototype._movePagesBatch = function (pageIds, targetGroupId, targetDocType) {
    var self = this;
    var result = {
      movedIds: [],
      skippedIds: [],
      registeredNewType: false,
      fromGroups: {},
      fromDocTypes: {}
    };
    if (!pageIds || !pageIds.length) return result;
    targetGroupId = String(targetGroupId || '');
    targetDocType = String(targetDocType || '');
    // 구 ETC 그룹 → BL1 + documentType=ETC
    if (targetGroupId === ETC_GROUP_ID || (!targetGroupId && targetDocType === ETC_DOC_TYPE)) {
      targetGroupId = this._defaultBlGroupId();
      targetDocType = ETC_DOC_TYPE;
    }
    if (targetDocType === ETC_DOC_TYPE && (!targetGroupId || targetGroupId === ETC_GROUP_ID)) {
      targetGroupId = this._defaultBlGroupId();
    }
    if (targetGroupId && targetGroupId !== ETC_GROUP_ID) {
      if (!this._ensureBlGroupExists(targetGroupId)) return result;
    }
    var targetKey = this._bucketKey(targetGroupId, targetDocType);
    var newcomerIds = [];
    pageIds.forEach(function (pageId) {
      var page = self._findPage(pageId);
      if (!page) return;
      var fromKey = self._bucketKey(page.groupId, page.documentType);
      if (fromKey === targetKey) {
        result.skippedIds.push(pageId);
        return;
      }
      result.fromGroups[page.groupId] = true;
      result.fromDocTypes[String(page.documentType || '')] = true;
      var isInflow = true;
      self._applyPageClassification(page, targetGroupId, targetDocType);
      self._markPageNew(page, isInflow);
      result.movedIds.push(pageId);
      newcomerIds.push(pageId);
    });
    Object.keys(result.fromGroups).forEach(function (gid) {
      self._removeFromGroupOrder(gid, result.movedIds);
    });
    this._insertIntoGroupOrder(
      targetGroupId,
      newcomerIds,
      this._normalizeNewInflowPosition(this.options.newInflowPosition)
    );
    this._syncSortOrderFromGroup(targetGroupId);
    Object.keys(result.fromGroups).forEach(function (gid) {
      self._syncSortOrderFromGroup(gid);
    });
    this._rebuildPageIndex();
    if (targetGroupId !== ETC_GROUP_ID) {
      result.registeredNewType = !!this._ensureTargetBucketMeta(targetGroupId, targetDocType);
    }
    return result;
  };

  /**
   * 해당 문서분류 페이지만 groupId 를 바꾼다. (문서분류별 BL 독립 재정렬용)
   */
  DocumentClassification.prototype._rewritePagesGroupIdForDocType = function (fromId, toId, docType) {
    fromId = String(fromId || '');
    toId = String(toId || '');
    docType = String(docType || '');
    if (!fromId || !toId || fromId === toId || !docType || !this.state.data) return;
    (this.state.data.pages || []).forEach(function (p) {
      if (String(p.groupId) === fromId && String(p.documentType) === docType) {
        p.groupId = toId;
        p.inptBlGrpNo = toId;
      }
    });
    if (
      String(this.state.activeGroupId || '') === fromId &&
      String(this.state.activeDocType || '') === docType
    ) {
      this.state.activeGroupId = toId;
    }
  };

  /** 어떤 문서분류 페이지도 없는 BL 그룹만 삭제 */
  DocumentClassification.prototype._deleteFullyEmptyGroups = function () {
    var self = this;
    var removed = [];
    if (!this.state.data || !Array.isArray(this.state.data.groups)) return removed;
    var ids = this.state.data.groups.map(function (g) { return String(g.groupId); });
    ids.forEach(function (groupId) {
      if (!groupId || groupId === ETC_GROUP_ID) return;
      if (!self._findGroupById(groupId)) return;
      var remain = self._pagesInGroup(groupId);
      if (remain.length > 0) return;

      if (self.state.sessionCreatedGroups && self.state.sessionCreatedGroups[groupId]) {
        delete self.state.sessionCreatedGroups[groupId];
      } else {
        var deletedGroup = self._findGroupById(groupId);
        self._recordDeletion('groups', { groupId: groupId });
        ((deletedGroup && deletedGroup.buckets) || []).forEach(function (bucket) {
          self._recordDeletion('buckets', {
            groupId: groupId,
            documentType: bucket.documentType
          });
        });
      }
      self.state.data.groups = self.state.data.groups.filter(function (g) {
        return String(g.groupId) !== groupId;
      });
      delete self.state.groupOrder[groupId];
      delete self.state.blockTypeChoice[groupId];
      if (String(self.state.activeGroupId || '') === groupId) {
        self.state.activeGroupId = null;
      }
      removed.push(groupId);
    });
    return removed;
  };

  /**
   * 문서분류 단위 BL 순번 재부여.
   * INV의 BL1과 PL의 BL1은 독립 — 해당 분류 페이지만 groupId 를 BL1,BL2… 로 맞춘다.
   */
  DocumentClassification.prototype._renumberDocTypeBlSequential = function (docType) {
    docType = String(docType || '');
    if (!docType || !this.state.data || !Array.isArray(this.state.data.groups)) return [];

    var typeMeta = this._getGroupTypeMeta('BL');
    var prefix = (typeMeta && typeMeta.key) ? typeMeta.key : 'BL';
    var groups = this.state.data.groups.slice().sort(function (a, b) {
      return (a.sortOrder || 0) - (b.sortOrder || 0);
    });
    var occupied = groups.filter(function (g) {
      return this._pagesInBucket(g.groupId, docType).length > 0;
    }, this);

    var renames = [];
    occupied.forEach(function (g, i) {
      var desired = prefix + (i + 1);
      if (String(g.groupId) !== desired) {
        renames.push({ from: String(g.groupId), to: desired, documentType: docType });
      }
    });
    if (!renames.length) return [];

    renames.forEach(function (r, idx) {
      r.temp = '__TMP_DT_' + docType + '_' + idx + '__';
      this._rewritePagesGroupIdForDocType(r.from, r.temp, docType);
    }, this);
    renames.forEach(function (r) {
      this._ensureBlGroupExists(r.to);
      this._rewritePagesGroupIdForDocType(r.temp, r.to, docType);
    }, this);
    this._rebuildPageIndex();

    // 그룹 identity RENAME 은 다른 문서분류 페이지에 영향을 주므로 기록하지 않는다.
    // (페이지 groupId UPDATE + 완전 빈 그룹 DELETE 로 표현)
    return renames.map(function (r) {
      return { from: r.from, to: r.to, documentType: r.documentType };
    });
  };

  /**
   * 이동 후: 관련 문서분류의 BL 순번을 재정렬하고, 완전 빈 그룹만 삭제한다.
   * 문서분류 > BL 계층이므로, 다른 분류가 같은 groupId 에 남아 있어도 해당 분류 기준으로 재정렬한다.
   *
   * @param {string[]} candidateGroupIds
   * @param {{ silent?: boolean, documentType?: string, documentTypes?: string[] }} [options]
   */
  DocumentClassification.prototype._removeEmptyGroups = function (candidateGroupIds, options) {
    options = options || {};
    if (!this.state.data || !Array.isArray(this.state.data.groups)) {
      return { removed: [], renames: [], skippedRemaining: [] };
    }

    var docTypes = [];
    var seenType = {};
    function pushType(t) {
      t = String(t || '');
      if (!t || seenType[t]) return;
      seenType[t] = true;
      docTypes.push(t);
    }
    if (Array.isArray(options.documentTypes)) {
      options.documentTypes.forEach(pushType);
    }
    pushType(options.documentType);
    if (!docTypes.length) {
      // 하위 호환: 타입 미지정 시 후보 그룹에 남아 있는 모든 분류 대상
      var self = this;
      (candidateGroupIds || []).forEach(function (gid) {
        (self.state.data.pages || []).forEach(function (p) {
          if (String(p.groupId) === String(gid)) pushType(p.documentType);
        });
      });
    }

    var renames = [];
    if (this.options.renumberAfterEmptyDelete !== false) {
      docTypes.forEach(function (dtype) {
        renames = renames.concat(this._renumberDocTypeBlSequential(dtype));
      }, this);
    }

    var removed = this._deleteFullyEmptyGroups();
    this._rebuildPageIndex();
    this._ensureActiveTarget();

    if (!options.silent && (removed.length || renames.length)) {
      this._logChange(
        (removed.length ? ('빈 그룹 자동 삭제: ' + removed.join(', ')) : '그룹 유지') +
        (renames.length
          ? ' / 분류별 재정렬 ' + renames.map(function (r) {
            return (r.documentType ? r.documentType + ':' : '') + r.from + '→' + r.to;
          }).join(', ')
          : ''),
        {
          op: 'DELETE_GROUP',
          groupIds: removed,
          auto: true,
          renumbered: renames
        }
      );
    }
    return { removed: removed, renames: renames, skippedRemaining: [] };
  };

  DocumentClassification.prototype._applyActiveGroupRenames = function (renames, groupId) {
    if (!renames || !renames.length) return groupId;
    var next = String(groupId || '');
    renames.forEach(function (r) {
      if (r.from === next) next = r.to;
    });
    return next;
  };

  /** 빈 그룹 삭제·재정렬 안내 문구 */
  DocumentClassification.prototype._formatPruneSummary = function (prune) {
    if (!prune) return '';
    var parts = [];
    if (prune.removed && prune.removed.length) {
      parts.push('빈 그룹 삭제(' + prune.removed.join(', ') + ')');
    }
    if (prune.renames && prune.renames.length) {
      parts.push(
        '분류별 순번 재정렬 ' +
        prune.renames.map(function (r) {
          return (r.documentType ? r.documentType + ' ' : '') + r.from + '→' + r.to;
        }).join(', ')
      );
    }
    return parts.join(' → ');
  };

  DocumentClassification.prototype._pruneOptionsAfterMove = function (batch, targetDocType) {
    var types = [];
    var seen = {};
    function push(t) {
      t = String(t || '');
      if (!t || seen[t]) return;
      seen[t] = true;
      types.push(t);
    }
    Object.keys((batch && batch.fromDocTypes) || {}).forEach(push);
    push(targetDocType);
    return { silent: true, documentTypes: types };
  };

  DocumentClassification.prototype.moveSelectedByCombo = function () {
    if (!this._canCheckMove()) return false;
    var ids = this.getRightSelectedPageIds();
    if (!ids.length) {
      this._setStatus('이동할 이미지를 선택하세요.', 'warn');
      return false;
    }
    var docType = String((this.$moveDocType && this.$moveDocType.val()) || '');
    var groupId = String((this.$moveGroup && this.$moveGroup.val()) || '');
    if (!docType) {
      this._setStatus('문서분류를 선택하세요.', 'warn');
      return false;
    }
    if (docType === ETC_DOC_TYPE) {
      if (!groupId || groupId === ETC_GROUP_ID) {
        groupId = this._defaultBlGroupId();
      }
    } else if (!groupId || groupId === ETC_GROUP_ID) {
      groupId = this._defaultBlGroupId();
    }

    var docLabel = this.$moveDocType.find('option:selected').text() || docType;
    var groupLabel = this.$moveGroup.find('option:selected').text() || groupId;

    var unchanged = ids.every(function (id) {
      var page = this._findPage(id);
      return page && page.groupId === groupId && page.documentType === docType;
    }, this);
    if (unchanged) {
      this._setStatus('변경된 문서분류가 없습니다.', 'info');
      return false;
    }

    if (this.options.confirmMove && !window.confirm(
      ids.length + '건을 ' + docLabel + ' [' + groupLabel + '] (으)로 변경하시겠습니까?'
    )) {
      return false;
    }

    this._snapshotScrollPositions();
    var requestedGroupId = groupId;
    if (!this._ensureBlGroupExists(groupId)) {
      return false;
    }
    var batch = this._movePagesBatch(ids, groupId, docType);
    if (!batch.movedIds.length) {
      this._setStatus('선택한 페이지는 이미 ' + groupLabel + ' / ' + docLabel + ' 에 있습니다.', 'info');
      return false;
    }
    batch.movedIds.forEach(function (id) {
      delete this.state.rightSelected[id];
    }, this);

    var prune = this._removeEmptyGroups(
      Object.keys(batch.fromGroups || {}),
      this._pruneOptionsAfterMove(batch, docType)
    );
    groupId = this._applyActiveGroupRenames(prune.renames, groupId);
    this.state.activeGroupId = groupId;
    this.state.activeDocType = docType;
    if (docType !== ETC_DOC_TYPE) {
      this.state.lastWorkingDocType = docType;
    }
    this._ensureActiveTarget();

    var finalGroup = this._findGroupById(groupId);
    var finalGroupLabel = (finalGroup && (finalGroup.label || finalGroup.groupId)) || groupId;
    var logMsg = batch.movedIds.length + '건 이동 → ' + finalGroupLabel + ' / ' + docLabel;
    if (requestedGroupId !== groupId || (prune.renames && prune.renames.length)) {
      logMsg += ' (요청 ' + requestedGroupId;
      if (requestedGroupId !== groupId) logMsg += ' → ' + groupId;
      logMsg += ')';
    }
    var pruneSummary = this._formatPruneSummary(prune);
    if (pruneSummary) logMsg += ' · ' + pruneSummary;
    // 마지막 남은 그룹을 N+1로 비운 뒤 다시 BL1로 접힌 경우 안내
    if (requestedGroupId !== groupId &&
        prune.removed.length &&
        prune.renames.some(function (r) {
          return r.from === requestedGroupId && r.to === groupId;
        })) {
      logMsg += ' · 빈 출발 그룹 삭제 후 순번이 1부터 재정렬됨';
    }

    this._logChange(logMsg, {
      op: 'MOVE_PAGE',
      pageIds: batch.movedIds,
      to: { groupId: groupId, documentType: docType },
      requestedGroupId: requestedGroupId,
      removedGroups: prune.removed,
      renames: prune.renames
    });

    var statusMsg = batch.movedIds.length + '건을 ' + docLabel + ' [' + finalGroupLabel + '] (으)로 이동했습니다.';
    if (pruneSummary) statusMsg += ' · ' + pruneSummary;
    // 마지막(또는 앞쪽) 그룹을 비워 N+1로 옮기면 출발 그룹이 사라지고 BL1부터 접힘
    if (this.options.renumberAfterEmptyDelete !== false &&
        requestedGroupId !== groupId &&
        (prune.renames || []).some(function (r) {
          return r.from === requestedGroupId && r.to === groupId;
        })) {
      statusMsg += ' · 요청 ' + requestedGroupId + '이(가) ' +
        groupId + '(으)로 순번이 재정렬되었습니다.';
    }
    this._setStatus(statusMsg, 'ok');

    if (prune.removed.length || prune.renames.length) {
      this.render();
    } else {
      this._refreshBlocks(Object.keys(batch.fromGroups).concat([groupId]));
    }
    this._scrollGroupStripToInflow(batch.movedIds);
    return { movedIds: batch.movedIds, removedGroups: prune.removed, renames: prune.renames };
  };

  DocumentClassification.prototype.moveSelectedToActive = function () {
    return this.moveSelectedByCombo();
  };

  DocumentClassification.prototype.moveRightSelectedTo = function (groupId, documentType) {
    if (!this._canCheckMove()) return false;
    if (!this.state.data) return false;
    var ids = this.getRightSelectedPageIds();
    if (!ids.length) {
      this._setStatus('이동할 페이지를 좌측 BL 블럭에서 선택하세요.', 'warn');
      return false;
    }
    var targetGroupId = String(groupId || '');
    var targetDocType = String(documentType || '');
    if (!targetGroupId || targetGroupId === ETC_GROUP_ID) {
      this._setStatus('대상 BL 블럭·문서분류 섹션을 선택하세요.', 'warn');
      return false;
    }
    if (!targetDocType) {
      this._setStatus('대상 문서분류 섹션을 선택하세요.', 'warn');
      return false;
    }
    var requestedGroupId = targetGroupId;
    var batch = this._movePagesBatch(ids, targetGroupId, targetDocType);
    if (!batch.movedIds.length) {
      this._setStatus('선택한 페이지는 이미 ' + targetGroupId + ' / ' + targetDocType + ' 에 있습니다.', 'info');
      return false;
    }
    batch.movedIds.forEach(function (id) {
      delete this.state.rightSelected[id];
    }, this);
    var prune = this._removeEmptyGroups(
      Object.keys(batch.fromGroups || {}),
      this._pruneOptionsAfterMove(batch, targetDocType)
    );
    targetGroupId = this._applyActiveGroupRenames(prune.renames, targetGroupId);
    this.state.activeGroupId = targetGroupId;
    this.state.activeDocType = targetDocType;
    var sample = this._findPage(batch.movedIds[0]);
    var pruneSummary = this._formatPruneSummary(prune);
    var logMsg = batch.movedIds.length + '건 이동 → ' + this._formatPageLabel(sample);
    if (pruneSummary) logMsg += ' · ' + pruneSummary;
    this._logChange(logMsg, {
      op: 'MOVE_PAGE',
      pageIds: batch.movedIds,
      to: { groupId: targetGroupId, documentType: targetDocType },
      requestedGroupId: requestedGroupId,
      removedGroups: prune.removed,
      renames: prune.renames
    });
    var statusMsg = batch.movedIds.length + '건을 ' + targetGroupId + ' / ' + targetDocType + ' 로 이동했습니다.';
    if (pruneSummary) statusMsg += ' · ' + pruneSummary;
    this._setStatus(statusMsg, 'ok');
    var refreshIds = Object.keys(batch.fromGroups)
      .filter(function (g) { return g !== ETC_GROUP_ID; })
      .concat([targetGroupId]);
    this._snapshotScrollPositions();
    if (batch.registeredNewType || prune.removed.length || prune.renames.length) this.render();
    else this._refreshBlocks(refreshIds);
    this._scrollGroupStripToInflow(batch.movedIds);
    return { movedIds: batch.movedIds, skippedIds: batch.skippedIds, removedGroups: prune.removed, renames: prune.renames };
  };

  DocumentClassification.prototype.moveSelectedBackToPool = function () {
    if (!this._canCheckMove()) return false;
    var ids = this.getRightSelectedPageIds();
    if (!ids.length) {
      this._setStatus('복귀할 페이지를 선택하세요.', 'warn');
      return false;
    }
    var targetGroupId = this._defaultBlGroupId();
    if (!this._ensureBlGroupExists(targetGroupId)) return false;
    this._snapshotScrollPositions();
    var batch = this._movePagesBatch(ids, targetGroupId, ETC_DOC_TYPE);
    if (!batch.movedIds.length) {
      this._setStatus('선택한 페이지는 이미 미분류에 있습니다.', 'info');
      return false;
    }
    batch.movedIds.forEach(function (id) {
      delete this.state.rightSelected[id];
    }, this);
    var prune = this._removeEmptyGroups(
      Object.keys(batch.fromGroups || {}),
      this._pruneOptionsAfterMove(batch, ETC_DOC_TYPE)
    );
    targetGroupId = this._applyActiveGroupRenames(prune.renames, targetGroupId);
    this.state.activeGroupId = targetGroupId;
    this.state.activeDocType = ETC_DOC_TYPE;
    var pruneSummary = this._formatPruneSummary(prune);
    var logMsg = batch.movedIds.length + '건 → 미분류 (' + targetGroupId + ')';
    if (pruneSummary) logMsg += ' · ' + pruneSummary;
    this._logChange(logMsg, {
      op: 'MOVE_PAGE',
      pageIds: batch.movedIds,
      to: { groupId: targetGroupId, documentType: ETC_DOC_TYPE },
      removedGroups: prune.removed,
      renames: prune.renames
    });
    var statusMsg = batch.movedIds.length + '건을 미분류(' + targetGroupId + ')로 되돌렸습니다.';
    if (pruneSummary) statusMsg += ' · ' + pruneSummary;
    this._setStatus(statusMsg, 'ok');
    if (prune.removed.length || prune.renames.length) this.render();
    else {
      var refreshIds = Object.keys(batch.fromGroups).concat([targetGroupId]);
      this._refreshBlocks(refreshIds);
    }
    this._scrollGroupStripToInflow(batch.movedIds);
    return { movedIds: batch.movedIds, removedGroups: prune.removed, renames: prune.renames };
  };

  DocumentClassification.prototype.moveSelectedTo = function (groupId, documentType) {
    if (!this._canCheckMove()) return false;
    if (!this.state.data) return false;
    var ids = this.getRightSelectedPageIds();
    if (!ids.length) ids = this.getSelectedPageIds();
    if (!ids.length) {
      this._setStatus('이동할 이미지를 선택하세요.', 'warn');
      return false;
    }
    var targetGroupId = String(groupId || '');
    var targetDocType = String(documentType || '');
    if (targetDocType === ETC_DOC_TYPE) {
      if (!targetGroupId || targetGroupId === ETC_GROUP_ID) {
        targetGroupId = this._defaultBlGroupId();
      }
    } else if (!targetGroupId || targetGroupId === ETC_GROUP_ID) {
      this._setStatus('대상 BL 그룹을 선택하세요.', 'warn');
      return false;
    }
    if (!targetDocType) {
      this._setStatus('대상 문서분류를 선택하세요.', 'warn');
      return false;
    }
    if (!this._ensureBlGroupExists(targetGroupId)) return false;

    var groupExists = this.state.data.groups.some(function (g) {
      return g.groupId === targetGroupId;
    });
    if (!groupExists) {
      this._setStatus('대상 그룹을 찾을 수 없습니다: ' + targetGroupId, 'warn');
      return false;
    }

    var requestedGroupId = targetGroupId;
    var batch = this._movePagesBatch(ids, targetGroupId, targetDocType);
    if (!batch.movedIds.length) {
      this._setStatus('선택한 페이지는 이미 ' + targetGroupId + ' / ' + targetDocType + ' 에 있습니다.', 'info');
      return false;
    }

    this.state.activeGroupId = targetGroupId;
    this.state.activeDocType = targetDocType;
    batch.movedIds.forEach(function (id) {
      delete this.state.selected[id];
      delete this.state.rightSelected[id];
    }, this);

    var prune = this._removeEmptyGroups(
      Object.keys(batch.fromGroups || {}),
      this._pruneOptionsAfterMove(batch, targetDocType)
    );
    targetGroupId = this._applyActiveGroupRenames(prune.renames, targetGroupId);
    this.state.activeGroupId = targetGroupId;

    var sample = this._findPage(batch.movedIds[0]);
    var toLabel = this._formatPageLabel(sample);
    var pruneSummary = this._formatPruneSummary(prune);
    var logMsg = batch.movedIds.length + '건 이동 → ' + toLabel;
    if (pruneSummary) logMsg += ' · ' + pruneSummary;
    this._logChange(logMsg, {
      op: 'MOVE_PAGE',
      pageIds: batch.movedIds,
      to: { groupId: targetGroupId, documentType: targetDocType },
      requestedGroupId: requestedGroupId,
      removedGroups: prune.removed,
      renames: prune.renames
    });
    var statusMsg = batch.movedIds.length + '건을 ' + targetGroupId + ' / ' + targetDocType + ' 로 이동했습니다.';
    if (pruneSummary) statusMsg += ' · ' + pruneSummary;
    this._setStatus(statusMsg, 'ok');

    var refreshIds = Object.keys(batch.fromGroups)
      .filter(function (g) { return g !== ETC_GROUP_ID; })
      .concat([targetGroupId]);
    this._snapshotScrollPositions();
    if (batch.registeredNewType || prune.removed.length || prune.renames.length) {
      this.render();
    } else {
      this._refreshBlocks(refreshIds);
    }
    this._scrollGroupStripToInflow(batch.movedIds);
    return { movedIds: batch.movedIds, skippedIds: batch.skippedIds, removedGroups: prune.removed, renames: prune.renames };
  };

  DocumentClassification.prototype.movePage = function (pageId, targetGroupId, targetDocType, insertIndex) {
    var page = this._findPage(pageId);
    if (!page) return false;
    var srcGroup = page.groupId;
    var srcDoc = page.documentType;
    var srcKey = this._bucketKey(srcGroup, srcDoc);
    var targetKey = this._bucketKey(targetGroupId, targetDocType);
    var isInflow = srcKey !== targetKey;

    var targetBucketIds = this._pagesInBucket(targetGroupId, targetDocType)
      .map(function (p) { return p.pageId; })
      .filter(function (id) { return id !== pageId; });

    this._removeFromGroupOrder(srcGroup, [pageId]);
    if (srcGroup !== targetGroupId) {
      this._removeFromGroupOrder(targetGroupId, [pageId]);
    }

    this._applyPageClassification(page, targetGroupId, targetDocType);
    this.state.pageById[pageId] = page;
    this._markPageNew(page, isInflow);

    if (typeof insertIndex === 'number') {
      if (insertIndex < 0) insertIndex = 0;
      if (insertIndex > targetBucketIds.length) insertIndex = targetBucketIds.length;
      targetBucketIds.splice(insertIndex, 0, pageId);
    } else if (this._normalizeNewInflowPosition(this.options.newInflowPosition) === 'bottom') {
      targetBucketIds.push(pageId);
    } else {
      targetBucketIds.unshift(pageId);
    }

    if (targetGroupId === ETC_GROUP_ID) {
      this._insertIntoGroupOrder(ETC_GROUP_ID, [pageId], this._normalizeNewInflowPosition(this.options.newInflowPosition));
    } else {
      this._rebuildGroupOrderFromBuckets(targetGroupId, targetDocType, targetBucketIds);
    }
    this._syncSortOrderFromGroup(srcGroup);
    this._syncSortOrderFromGroup(targetGroupId);
    this._rebuildPageIndex();

    var registeredNewType = false;
    if (targetGroupId !== ETC_GROUP_ID) {
      registeredNewType = !!this._ensureTargetBucketMeta(targetGroupId, targetDocType);
    }
    return registeredNewType ? { ok: true, registeredNewType: true } : true;
  };

  DocumentClassification.prototype.addGroup = function (typeKey) {
    typeKey = typeKey || 'BL';
    if (!this.state.data || !this._canAddGroup()) {
      if (typeof this.options.maxGroups === 'number' &&
          this.state.data &&
          this.state.data.groups.length >= this.options.maxGroups) {
        this._setStatus('최대 그룹 수(' + this.options.maxGroups + ')에 도달했습니다.', 'warn');
      }
      return null;
    }
    if (Array.isArray(this.options.allowedGroupTypes) &&
        this.options.allowedGroupTypes.indexOf(typeKey) === -1) {
      this._setStatus(typeKey + ' 그룹 유형은 허용되지 않습니다.', 'warn');
      return null;
    }
    var typeMeta = this._getGroupTypeMeta(typeKey);
    var prefix = typeMeta.key;
    var maxNum = 0;
    this.state.data.groups.forEach(function (g) {
      var m = String(g.groupId).match(new RegExp('^' + prefix + '(\\d+)$', 'i'));
      if (m) maxNum = Math.max(maxNum, parseInt(m[1], 10));
    });
    var newId = prefix + (maxNum + 1);
    var group = {
      groupId: newId,
      inptBlGrpNo: newId,
      groupType: prefix,
      label: newId,
      sortOrder: this.state.data.groups.length,
      buckets: []
    };
    this._removeDeletion('groups', { groupId: newId });
    this.state.deletions.buckets = this.state.deletions.buckets.filter(function (bucket) {
      return bucket.groupId !== newId;
    });
    this._ensureGroupBuckets(group);
    this.state.data.groups.push(group);
    this.state.groupOrder[newId] = [];
    this.state.blockTypeChoice[newId] = this._workingDocType();
    if (!this.state.sessionCreatedGroups) this.state.sessionCreatedGroups = {};
    this.state.sessionCreatedGroups[newId] = true;
    this.state.activeGroupId = newId;
    if (this.state.activeDocType === ETC_DOC_TYPE || !this.state.activeDocType) {
      this.state.activeDocType = this._workingDocType();
    }
    this.state.lastWorkingDocType = this.state.activeDocType;
    this._rebuildPageIndex();

    this._refreshBlocks([newId]);

    this._logChange(typeMeta.label + ' 그룹 ' + newId + ' 추가', {
      op: 'ADD_GROUP',
      groupId: newId,
      groupType: prefix,
      forDocumentType: this.state.activeDocType
    });

    var $added = this.$groupTabs.find('.dc-group-tab[data-group-id="' + cssEscape(newId) + '"]');
    if ($added.length && $added[0].scrollIntoView) {
      $added[0].scrollIntoView({ behavior: 'smooth', inline: 'nearest', block: 'nearest' });
    }
    this._setStatus(
      newId + ' 그룹을 추가했습니다. (' +
      ((this._getDocTypeMeta(this.state.activeDocType) || {}).label || this.state.activeDocType) +
      ')',
      'ok'
    );
    return newId;
  };

  DocumentClassification.prototype.deleteDocumentBucket = function (groupId, docType) {
    if (groupId === ETC_GROUP_ID || !this._canDelete()) return false;
    var pages = this._pagesInBucket(groupId, docType);
    var meta = this._getDocTypeMeta(docType);
    var label = (meta && meta.label) || docType;
    var msg = pages.length === 0
      ? label + ' 문서분류에 이동할 페이지가 없습니다.'
      : label + ' 문서분류를 비우시겠습니까?\n' + pages.length +
        '개 페이지가 미분류(BL1)로 이동합니다.';
    if (pages.length === 0) {
      this._setStatus(msg, 'warn');
      return false;
    }
    if (this.options.confirmDelete && !window.confirm(msg)) return false;

    var etcGroupId = this._defaultBlGroupId();
    if (!this._ensureBlGroupExists(etcGroupId)) return false;
    var batch = this._movePagesBatch(
      pages.map(function (p) { return p.pageId; }),
      etcGroupId,
      ETC_DOC_TYPE
    );
    var group = this.state.data.groups.filter(function (g) { return g.groupId === groupId; })[0];
    if (group) this._ensureGroupBuckets(group);

    this._logChange(groupId + ' / ' + label + ' 문서분류 비우기 (' + batch.movedIds.length + '건→미분류)', {
      op: 'CLEAR_DOCUMENT_BUCKET',
      groupId: groupId,
      documentType: docType,
      movedPageIds: batch.movedIds
    });
    this._refreshBlocks([groupId, etcGroupId]);
    return true;
  };

  DocumentClassification.prototype._rewriteGroupId = function (fromId, toId) {
    fromId = String(fromId || '');
    toId = String(toId || '');
    if (!fromId || !toId || fromId === toId || !this.state.data) return;
    this.state.data.groups.forEach(function (g) {
      if (String(g.groupId) !== fromId) return;
      g.groupId = toId;
      g.inptBlGrpNo = toId;
      if (!g.label || String(g.label) === fromId) g.label = toId;
    });
    (this.state.data.pages || []).forEach(function (p) {
      if (String(p.groupId) === fromId) {
        p.groupId = toId;
        p.inptBlGrpNo = toId;
      }
    });
    if (Object.prototype.hasOwnProperty.call(this.state.groupOrder, fromId)) {
      this.state.groupOrder[toId] = this.state.groupOrder[fromId];
      delete this.state.groupOrder[fromId];
    }
    if (Object.prototype.hasOwnProperty.call(this.state.blockTypeChoice, fromId)) {
      this.state.blockTypeChoice[toId] = this.state.blockTypeChoice[fromId];
      delete this.state.blockTypeChoice[fromId];
    }
    if (String(this.state.activeGroupId || '') === fromId) {
      this.state.activeGroupId = toId;
    }
    var scrollKeys = Object.keys(this.state.bucketScroll || {});
    scrollKeys.forEach(function (key) {
      if (key.indexOf(fromId + '::') === 0) {
        var rest = key.slice(fromId.length);
        this.state.bucketScroll[toId + rest] = this.state.bucketScroll[key];
        delete this.state.bucketScroll[key];
      }
    }, this);
  };

  /**
   * 그룹 유형별 순번 재부여 (예: BL1, BL3 → BL1, BL2).
   * 충돌 방지를 위해 임시 ID → 최종 ID 2단계로 변경한다.
   */
  DocumentClassification.prototype._renumberGroupsSequential = function () {
    if (!this.state.data || !Array.isArray(this.state.data.groups)) return [];
    var groups = this.state.data.groups.slice().sort(function (a, b) {
      return (a.sortOrder || 0) - (b.sortOrder || 0);
    });
    groups.forEach(function (g, idx) { g.sortOrder = idx; });
    this.state.data.groups = groups;

    var byType = {};
    groups.forEach(function (g) {
      var typeKey = String(g.groupType || 'BL');
      if (!byType[typeKey]) byType[typeKey] = [];
      byType[typeKey].push(g);
    });

    var renames = [];
    Object.keys(byType).forEach(function (typeKey) {
      byType[typeKey].forEach(function (g, i) {
        var desired = typeKey + (i + 1);
        if (String(g.groupId) !== desired) {
          renames.push({ from: String(g.groupId), to: desired });
        }
      });
    });
    if (!renames.length) return [];

    renames.forEach(function (r, idx) {
      r.temp = '__TMP_RENUM_' + idx + '__';
      this._rewriteGroupId(r.from, r.temp);
    }, this);
    renames.forEach(function (r) {
      this._rewriteGroupId(r.temp, r.to);
    }, this);
    if (!this.state.groupRenames) this.state.groupRenames = [];
    if (!this.state.sessionCreatedGroups) this.state.sessionCreatedGroups = {};
    renames.forEach(function (r) {
      // 세션에서만 만든 N+1(BL3 등)이 빈 중간 그룹 삭제 후 다시 BL2로 접히면
      // DELETE(BL2)+RENAME(BL3→BL2)는 서버에 존재하지 않는 BL3를 가리키므로 상쇄한다.
      if (this.state.sessionCreatedGroups[r.from]) {
        delete this.state.sessionCreatedGroups[r.from];
        this._removeDeletion('groups', { groupId: r.to });
        this.state.deletions.buckets = (this.state.deletions.buckets || []).filter(function (bucket) {
          return String(bucket.groupId) !== String(r.to);
        });
        return;
      }
      this.state.groupRenames.push({ from: r.from, to: r.to });
    }, this);
    return renames.map(function (r) { return { from: r.from, to: r.to }; });
  };

  DocumentClassification.prototype.deleteGroup = function (groupId) {
    if (groupId === ETC_GROUP_ID || !this._canDelete()) return false;
    var groupPages = this.state.data.pages.filter(function (p) { return p.groupId === groupId; });
    var otherHasPages = this.state.data.pages.some(function (p) {
      return p.groupId !== groupId;
    });
    if (groupPages.length > 0 && !otherHasPages) {
      this._setStatus('모든 페이지가 이 그룹에만 있습니다. 다른 그룹으로 이동 후 삭제하세요.', 'warn');
      return false;
    }
    var typeMeta = this._getGroupTypeMeta(
      (this.state.data.groups.filter(function (g) { return g.groupId === groupId; })[0] || {}).groupType || 'BL'
    );
    var etcGroupId = this._defaultBlGroupId();
    var msg = groupPages.length === 0
      ? groupId + ' (' + typeMeta.label + ') 그룹을 삭제하시겠습니까?'
      : groupId + ' (' + typeMeta.label + ') 그룹을 삭제하시겠습니까?\n' + groupPages.length +
        '개 페이지가 미분류(' + etcGroupId + ')로 이동합니다.';
    if (this.options.confirmDelete && !window.confirm(msg)) return false;

    var movedIds = groupPages.map(function (p) { return p.pageId; });
    if (movedIds.length) {
      if (!this._ensureBlGroupExists(etcGroupId)) return false;
      // 삭제 대상이 기본 BL1이면 다른 잔여 BL로 미분류 이동
      if (String(groupId) === String(etcGroupId)) {
        var alt = ((this.state.data && this.state.data.groups) || []).filter(function (g) {
          return g.groupId !== groupId && g.groupId !== ETC_GROUP_ID;
        })[0];
        if (!alt) {
          this._setStatus('미분류를 둘 다른 BL 그룹이 없습니다.', 'warn');
          return false;
        }
        etcGroupId = alt.groupId;
      }
      this._movePagesBatch(movedIds, etcGroupId, ETC_DOC_TYPE);
    }
    var deletedGroup = this.state.data.groups.filter(function (g) { return g.groupId === groupId; })[0];
    this._recordDeletion('groups', { groupId: groupId });
    ((deletedGroup && deletedGroup.buckets) || []).forEach(function (bucket) {
      this._recordDeletion('buckets', {
        groupId: groupId,
        documentType: bucket.documentType
      });
    }, this);
    this.state.data.groups = this.state.data.groups.filter(function (g) { return g.groupId !== groupId; });
    delete this.state.groupOrder[groupId];
    delete this.state.blockTypeChoice[groupId];
    if (String(this.state.activeGroupId || '') === String(groupId)) {
      this.state.activeGroupId = null;
      this.state.activeDocType = null;
    }

    var renames = this._renumberGroupsSequential();
    this._rebuildPageIndex();
    this._ensureActiveTarget();

    this._logChange(groupId + ' 그룹 삭제' + (movedIds.length ? ' (' + movedIds.length + '건→미분류)' : ''), {
      op: 'DELETE_GROUP',
      groupId: groupId,
      movedPageIds: movedIds,
      renumbered: renames
    });
    if (renames.length) {
      this._setStatus(
        groupId + ' 삭제 후 그룹 순번을 재정렬했습니다. (' +
        renames.map(function (r) { return r.from + '→' + r.to; }).join(', ') + ')',
        'ok'
      );
    }

    // groupId 재부여 시 DOM data-group-id 갱신이 필요하므로 전체 렌더
    this.render();
    return true;
  };

  DocumentClassification.prototype.setData = function (raw) {
    try {
      var normalized = this._normalizeData(raw);
      this.state.data = normalized;
      this._rebuildPageIndex();
      this._syncDocumentTypesFromPages();
      this.state.original = deepClone(this.state.data);
      this.state.data = deepClone(this.state.data);
      this.state.changes = [];
      this.state.changeLog = [];
      this.state.deletions = { groups: [], buckets: [], pages: [] };
      this.state.groupRenames = [];
      this.state.sessionCreatedGroups = {};
      this.state.dirty = false;
      this.state.thumbCache = {};
      this.state.bucketScroll = {};
      this.state.docTypeScroll = {};
      this.state.selected = {};
      this.state.rightSelected = {};
      this.state.lastCheckedPageId = null;
      this.state.lastRightCheckedPageId = null;
      this.state.suppressBoardClick = false;
      this.state.tableFilter = this._emptyTableFilter();
      this.state.activeGroupId = null;
      this.state.activeDocType = null;
      this.state.blockTypeChoice = {};
      this.state.groupOrder = {};
      this.state.boardScrollTop = 0;
      this.state.sourceScrollTop = 0;
      this.state.newDocTypes = {};
      this.state.jsonDirty = { loaded: true, save: true };
      this.$log.empty();
      this._setStatus('');
      this._rebuildPageIndex();
      this._rebuildGroupOrder(true);
      this._ensureActiveTarget();
      this.render();
      this._trigger('loaded', this.getData());
      return this;
    } catch (err) {
      this._setStatus(err.message || String(err), 'error');
      this._trigger('error', { phase: 'setData', error: err });
      return this;
    }
  };

  DocumentClassification.prototype.setOptions = function (options) {
    this.options = $.extend(true, {}, this.options, options || {});
    if (options && Object.prototype.hasOwnProperty.call(options, 'allowedGroupTypes')) {
      this.options.allowedGroupTypes = Array.isArray(options.allowedGroupTypes)
        ? options.allowedGroupTypes.slice()
        : null;
    }
    this.options.saveDatasetMode = String(this.options.saveDatasetMode).toLowerCase() === 'full'
      ? 'full'
      : 'delta';
    this.options.newInflowPosition = this._normalizeNewInflowPosition(this.options.newInflowPosition);
    // 표시 옵션은 명시적 boolean 으로 고정 (undefined/문자열 혼선 방지)
    if (options && Object.prototype.hasOwnProperty.call(options, 'showThumbTitle')) {
      this.options.showThumbTitle = !!options.showThumbTitle;
    }
    if (options && Object.prototype.hasOwnProperty.call(options, 'showThumbTaskId')) {
      this.options.showThumbTaskId = !!options.showThumbTaskId;
    }
    if (options && Object.prototype.hasOwnProperty.call(options, 'showNewLabel')) {
      this.options.showNewLabel = !!options.showNewLabel;
    }
    if (options && Object.prototype.hasOwnProperty.call(options, 'showPreviewMeta')) {
      this.options.showPreviewMeta = !!options.showPreviewMeta;
    }
    if (options && Object.prototype.hasOwnProperty.call(options, 'showChangeLog')) {
      this.options.showChangeLog = !!options.showChangeLog;
    }
    if (options && Object.prototype.hasOwnProperty.call(options, 'showGuide')) {
      this.options.showGuide = !!options.showGuide;
    }
    if (options && Object.prototype.hasOwnProperty.call(options, 'showJsonPreview')) {
      this.options.showJsonPreview = !!options.showJsonPreview;
    }
    if (options && Object.prototype.hasOwnProperty.call(options, 'showRefNoBar')) {
      this.options.showRefNoBar = !!options.showRefNoBar;
    }
    if (options && Object.prototype.hasOwnProperty.call(options, 'refNoBarBoxed')) {
      this.options.refNoBarBoxed = !!options.refNoBarBoxed;
    }
    if (options && Object.prototype.hasOwnProperty.call(options, 'rememberDocTypeScroll')) {
      this.options.rememberDocTypeScroll = !!options.rememberDocTypeScroll;
    }
    if (options && Object.prototype.hasOwnProperty.call(options, 'previewMetaMessage')) {
      this.options.previewMetaMessage = this._previewMetaMessage();
    }
    if (options && Object.prototype.hasOwnProperty.call(options, 'etcFilterColumns')) {
      this.options.etcFilterColumns = this._normalizeEtcFilterColumns(options.etcFilterColumns);
    } else {
      this.options.etcFilterColumns = this._normalizeEtcFilterColumns(this.options.etcFilterColumns);
    }
    if (Object.prototype.hasOwnProperty.call(this.options, 'showEtcFilters')) {
      this.options.showEtcFilters = this.options.showEtcFilters !== false;
    }
    this._syncTableFilterKeys();
    if (Object.prototype.hasOwnProperty.call(this.options, 'emptyBucketMessage')) {
      this.options.emptyBucketMessage = this._emptyBucketMessage();
    }
    this._ensureThumbObserver();
    this.render();
    this._renderPreviewMeta();
    return this;
  };

  DocumentClassification.prototype.getOptions = function () {
    return deepClone({
      showEmptyBuckets: this.options.showEmptyBuckets,
      confirmDelete: this.options.confirmDelete,
      confirmMove: !!this.options.confirmMove,
      includeAllBlGroupsInMoveCombo: this.options.includeAllBlGroupsInMoveCombo !== false,
      renumberAfterEmptyDelete: this.options.renumberAfterEmptyDelete !== false,
      readOnly: this.options.readOnly,
      allowDragDrop: this.options.allowDragDrop,
      allowBucketReorder: this.options.allowBucketReorder,
      allowGroupAdd: this.options.allowGroupAdd,
      allowDelete: this.options.allowDelete,
      showGuide: this.options.showGuide,
      showChangeLog: this.options.showChangeLog,
      showJsonPreview: this.options.showJsonPreview,
      showEtcPane: this.options.showEtcPane !== false,
      showEtcFilters: this.options.showEtcFilters !== false,
      etcFilterColumns: this.options.etcFilterColumns || [],
      emptyBucketMessage: this._emptyBucketMessage(),
      maxGroups: this.options.maxGroups,
      allowedGroupTypes: this.options.allowedGroupTypes,
      thumbnailWidth: this.options.thumbnailWidth,
      thumbnailImageHeight: this.options.thumbnailImageHeight,
      bucketColumns: this.options.bucketColumns,
      sourcePaneWidth: this.options.sourcePaneWidth,
      typeTabFontSize: this.options.typeTabFontSize,
      refNoFontSize: this.options.refNoFontSize,
      newInflowPosition: this.options.newInflowPosition,
      showNewLabel: !!this.options.showNewLabel,
      showThumbTitle: !!this.options.showThumbTitle,
      showThumbTaskId: !!this.options.showThumbTaskId,
      saveDatasetMode: this.options.saveDatasetMode,
      includeChangeHistory: this.options.includeChangeHistory,
      deferJsonPreview: this.options.deferJsonPreview,
      cloneOnChange: this.options.cloneOnChange,
      showPerfStats: this.options.showPerfStats,
      lazyThumbs: this.options.lazyThumbs,
      allowImagePreview: this.options.allowImagePreview !== false,
      showPreviewMeta: this.options.showPreviewMeta !== false,
      previewMetaMessage: this._previewMetaMessage(),
      showRefNoBar: this.options.showRefNoBar !== false,
      refNoBarBoxed: this.options.refNoBarBoxed !== false,
      rememberDocTypeScroll: !!this.options.rememberDocTypeScroll
    });
  };

  DocumentClassification.prototype.getData = function (options) {
    if (!this.state.data) return null;
    var shouldClone = !options || options.clone !== false;
    return shouldClone ? deepClone(this.state.data) : this.state.data;
  };

  DocumentClassification.prototype._attachChangeHistory = function (payload) {
    if (this.options.includeChangeHistory) {
      payload.changeHistory = {
        savedAt: nowIso(),
        operations: deepClone(this.state.changes),
        messages: this.state.changeLog.slice()
      };
    }
    return payload;
  };

  DocumentClassification.prototype._getFullSavePayload = function () {
    if (!this.state.data) return null;
    var data = this.state.data;
    var payload = {
      documentId: data.documentId,
      baseVersion: this.state.original ? this.state.original.version : data.version,
      datasetMode: 'FULL',
      datasets: {
        groups: data.groups.map(function (group) {
          return {
            groupId: group.groupId,
            inptBlGrpNo: group.inptBlGrpNo || group.groupId,
            groupType: group.groupType,
            label: group.label,
            sortOrder: group.sortOrder
          };
        }),
        buckets: [],
        pages: data.pages.map(function (page) {
          return {
            pageId: page.pageId,
            inptMstSrno: page.inptMstSrno,
            inptTaskId: page.inptTaskId,
            imexHisCd: page.imexHisCd,
            inptBlGrpNo: page.inptBlGrpNo || page.groupId,
            inptElmtId: page.inptElmtId,
            contentType: page.contentType || '',
            fileName: page.fileName || '',
            textContent: page.textContent || '',
            textBase64: page.textBase64 || '',
            thumbnailBase64: page.thumbnailBase64 || '',
            groupId: page.groupId,
            documentType: page.documentType,
            sortOrder: page.sortOrder
          };
        })
      }
    };

    data.groups.forEach(function (group) {
      (group.buckets || []).forEach(function (bucket, index) {
        if (bucket._virtual) return;
        payload.datasets.buckets.push({
          groupId: group.groupId,
          documentType: bucket.documentType,
          label: bucket.label || bucket.documentType,
          sortOrder: typeof bucket.sortOrder === 'number' ? bucket.sortOrder : index
        });
      });
    });
    return this._attachChangeHistory(payload);
  };

  DocumentClassification.prototype.getSavePayload = function (modeOverride) {
    if (!this.state.data) return null;
    var mode = String(modeOverride || this.options.saveDatasetMode).toLowerCase();
    if (mode === 'full') return this._getFullSavePayload();
    var data = this.state.data;
    var original = this.state.original || {
      version: data.version,
      groups: [],
      pages: []
    };
    var payload = {
      documentId: data.documentId,
      baseVersion: original.version,
      datasetMode: 'DELTA',
      datasets: {
        groups: [],
        buckets: [],
        pages: []
      }
    };

    function indexBy(rows, keyFn) {
      var result = {};
      (rows || []).forEach(function (row) { result[keyFn(row)] = row; });
      return result;
    }

    function changedRow(keyValues, current, before, fields) {
      var row = $.extend({ operation: 'UPDATE' }, keyValues);
      var changed = false;
      fields.forEach(function (field) {
        if (current[field] !== before[field]) {
          row[field] = current[field];
          changed = true;
        }
      });
      return changed ? row : null;
    }

    var originalGroups = indexBy(original.groups, function (group) { return group.groupId; });
    var currentGroups = indexBy(data.groups, function (group) { return group.groupId; });

    // 1) 세션 중 빈 그룹 삭제
    var deletedGroupIds = {};
    (this.state.deletions.groups || []).forEach(function (row) {
      var gid = String(row.groupId || '');
      if (!gid || deletedGroupIds[gid]) return;
      deletedGroupIds[gid] = true;
    });

    // 2) 순번 재정렬 RENAME (BL2→BL1 등)
    // 세션 전용 그룹(원본에 없음) → 삭제된 원본 슬롯으로 접힌 RENAME 은 DELETE와 상쇄
    var renameFrom = {};
    var renameTo = {};
    var renameRows = [];
    (this.state.groupRenames || []).forEach(function (r) {
      var fromId = String(r.from || '');
      var toId = String(r.to || '');
      if (!fromId || !toId || fromId === toId) return;
      if (!originalGroups[fromId] && deletedGroupIds[toId] && currentGroups[toId] && originalGroups[toId]) {
        delete deletedGroupIds[toId];
        return;
      }
      renameFrom[fromId] = toId;
      renameTo[toId] = fromId;
      renameRows.push({
        operation: 'RENAME',
        fromGroupId: fromId,
        toGroupId: toId
      });
    });

    Object.keys(deletedGroupIds).forEach(function (gid) {
      payload.datasets.groups.push({ operation: 'DELETE', groupId: gid });
    });
    renameRows.forEach(function (row) {
      payload.datasets.groups.push(row);
    });

    // 3) INSERT / UPDATE (RENAME·DELETE 로 이미 설명된 ID는 중복 처리하지 않음)
    data.groups.forEach(function (group) {
      var gid = String(group.groupId);
      if (renameTo[gid]) {
        // 원본 from 이 rename 되어 온 슬롯 → 메타 UPDATE만 (identity는 RENAME)
        var beforeRenamed = originalGroups[renameTo[gid]];
        if (beforeRenamed) {
          var updRenamed = changedRow(
            { groupId: gid },
            group,
            { groupType: beforeRenamed.groupType, label: gid, sortOrder: beforeRenamed.sortOrder },
            ['groupType', 'label', 'sortOrder']
          );
          // label이 새 ID로 바뀐 것은 RENAME의 자연 결과이므로 sortOrder만 의미 있게
          if (group.sortOrder !== beforeRenamed.sortOrder || group.groupType !== beforeRenamed.groupType) {
            payload.datasets.groups.push({
              operation: 'UPDATE',
              groupId: gid,
              groupType: group.groupType,
              label: group.label,
              sortOrder: group.sortOrder
            });
          }
        }
        return;
      }
      var before = originalGroups[gid];
      if (!before) {
        if (deletedGroupIds[gid]) return;
        payload.datasets.groups.push({
          operation: 'INSERT',
          groupId: group.groupId,
          inptBlGrpNo: group.inptBlGrpNo || group.groupId,
          groupType: group.groupType,
          label: group.label,
          sortOrder: group.sortOrder
        });
        return;
      }
      var update = changedRow(
        { groupId: group.groupId },
        group,
        before,
        ['groupType', 'label', 'sortOrder', 'inptBlGrpNo']
      );
      if (update) payload.datasets.groups.push(update);
    });

    // 4) 원본에만 있고 현재에 없는 그룹 → DELETE (이미 deletions/RENAME from 이면 생략)
    (original.groups || []).forEach(function (group) {
      var gid = String(group.groupId);
      if (currentGroups[gid]) return;
      if (deletedGroupIds[gid]) return;
      if (renameFrom[gid]) return;
      payload.datasets.groups.push({ operation: 'DELETE', groupId: gid });
    });

    function bucketRows(groups) {
      var rows = [];
      (groups || []).forEach(function (group) {
        (group.buckets || []).forEach(function (bucket, index) {
          if (bucket._virtual) return;
          rows.push({
            groupId: group.groupId,
            documentType: bucket.documentType,
            label: bucket.label || bucket.documentType,
            sortOrder: typeof bucket.sortOrder === 'number' ? bucket.sortOrder : index
          });
        });
      });
      return rows;
    }

    var originalBucketRows = bucketRows(original.groups);
    var currentBucketRows = bucketRows(data.groups);
    var bucketKey = function (bucket) {
      return bucket.groupId + '::' + bucket.documentType;
    };
    var originalBuckets = indexBy(originalBucketRows, bucketKey);
    var currentBuckets = indexBy(currentBucketRows, bucketKey);
    currentBucketRows.forEach(function (bucket) {
      var before = originalBuckets[bucketKey(bucket)];
      if (!before) {
        payload.datasets.buckets.push($.extend({ operation: 'INSERT' }, bucket));
        return;
      }
      var update = changedRow(
        { groupId: bucket.groupId, documentType: bucket.documentType },
        bucket,
        before,
        ['label', 'sortOrder']
      );
      if (update) payload.datasets.buckets.push(update);
    });
    originalBucketRows.forEach(function (bucket) {
      if (!currentBuckets[bucketKey(bucket)]) {
        payload.datasets.buckets.push({
          operation: 'DELETE',
          groupId: bucket.groupId,
          documentType: bucket.documentType
        });
      }
    });

    var originalPages = indexBy(original.pages, function (page) { return page.pageId; });
    var currentPages = indexBy(data.pages, function (page) { return page.pageId; });
    data.pages.forEach(function (page) {
      var before = originalPages[page.pageId];
      if (!before) {
        payload.datasets.pages.push({
          operation: 'INSERT',
          pageId: page.pageId,
          inptMstSrno: page.inptMstSrno,
          inptTaskId: page.inptTaskId,
          imexHisCd: page.imexHisCd,
          inptBlGrpNo: page.inptBlGrpNo || page.groupId,
          inptElmtId: page.inptElmtId,
          contentType: page.contentType || '',
          fileName: page.fileName || '',
          textContent: page.textContent || '',
          textBase64: page.textBase64 || '',
          thumbnailBase64: page.thumbnailBase64 || '',
          groupId: page.groupId,
          documentType: page.documentType,
          sortOrder: page.sortOrder
        });
        return;
      }
      var update = changedRow(
        { pageId: page.pageId },
        page,
        before,
        ['groupId', 'inptBlGrpNo', 'documentType', 'sortOrder', 'imexHisCd', 'inptMstSrno', 'inptTaskId', 'inptElmtId', 'contentType', 'fileName', 'textContent', 'textBase64', 'thumbnailBase64']
      );
      if (update) payload.datasets.pages.push(update);
    });
    (original.pages || []).forEach(function (page) {
      if (!currentPages[page.pageId]) {
        payload.datasets.pages.push({ operation: 'DELETE', pageId: page.pageId });
      }
    });

    return this._attachChangeHistory(payload);
  };

  DocumentClassification.prototype._hasDatasetChanges = function (payload) {
    if (!payload || !payload.datasets) return false;
    return ['groups', 'buckets', 'pages'].some(function (name) {
      return Array.isArray(payload.datasets[name]) && payload.datasets[name].length > 0;
    });
  };

  DocumentClassification.prototype.load = function () {
    var self = this;
    if (this.state.loading) return this;
    this.state.loading = true;
    this._setStatus('조회 중…', 'info');

    var done = function (data) {
      self.state.loading = false;
      self.setData(data);
      self._setStatus('조회 완료 (version ' + (data.version || 1) + ')', 'ok');
    };
    var fail = function (err) {
      self.state.loading = false;
      self._setStatus('조회 실패: ' + (err && err.message ? err.message : err), 'error');
      self._trigger('error', { phase: 'load', error: err });
    };

    if (this.options.mockTransport && typeof this.options.mockTransport.load === 'function') {
      $.when(this.options.mockTransport.load()).then(done, fail);
      return this;
    }

    if (!this.options.loadUrl) {
      fail(new Error('loadUrl이 없습니다.'));
      return this;
    }

    $.ajax({
      url: this.options.loadUrl,
      method: 'GET',
      dataType: 'json'
    }).done(done).fail(function (xhr) {
      fail(new Error(xhr.statusText || 'AJAX load failed'));
    });
    return this;
  };

  DocumentClassification.prototype.save = function () {
    var self = this;
    if (this.state.saving) return this;
    if (!this.state.data) {
      this._setStatus('저장할 데이터가 없습니다.', 'warn');
      return this;
    }
    if (!this.state.dirty && this.state.changes.length === 0) {
      this._setStatus('변경 내역이 없습니다.', 'warn');
      return this;
    }

    var deltaPayload = this.getSavePayload('delta');
    if (!this._hasDatasetChanges(deltaPayload)) {
      this.state.dirty = false;
      this.state.changes = [];
      this.state.changeLog = [];
      this.state.deletions = { groups: [], buckets: [], pages: [] };
      this.state.groupRenames = [];
      this.state.sessionCreatedGroups = {};
      this.$log.empty();
      this._refreshSavePreview(true);
      this._setStatus('실질 변경 내역이 없습니다.', 'warn');
      return this;
    }
    var payload = this.options.saveDatasetMode === 'full'
      ? this.getSavePayload('full')
      : deltaPayload;
    this.state.saving = true;
    this._setStatus('저장 중…', 'info');
    this._refreshSavePreview(true);

    var done = function (res) {
      var savedVersion = res && typeof res.version === 'number'
        ? res.version
        : payload.baseVersion + 1;
      self.state.saving = false;
      self.state.dirty = false;
      self.state.changes = [];
      self.state.changeLog = [];
      self.state.deletions = { groups: [], buckets: [], pages: [] };
      self.state.groupRenames = [];
      self.state.sessionCreatedGroups = {};
      self.$log.empty();
      if (self.state.data) {
        self.state.data.version = savedVersion;
        self.state.original = deepClone(self.state.data);
      }
      self._refreshLoadedPreview(true);
      self._refreshSavePreview(true);
      self._setStatus('저장 완료 (reCrfMulti / version ' + savedVersion + ')', 'ok');
      self._trigger('saved', { response: res, payload: payload });
    };
    var fail = function (err) {
      self.state.saving = false;
      self._setStatus('저장 실패: ' + (err && err.message ? err.message : err), 'error');
      self._trigger('error', { phase: 'save', error: err, payload: payload });
    };

    if (this.options.mockTransport && typeof this.options.mockTransport.save === 'function') {
      $.when(this.options.mockTransport.save(payload)).then(done, fail);
      return this;
    }

    if (!this.options.saveUrl) {
      window.setTimeout(function () {
        done({ ok: true, mocked: true, version: payload.baseVersion + 1 });
      }, 300);
      return this;
    }

    $.ajax({
      url: this.options.saveUrl,
      method: 'POST',
      contentType: 'application/json; charset=UTF-8',
      dataType: 'json',
      data: JSON.stringify(payload)
    }).done(done).fail(function (xhr) {
      fail(new Error(xhr.statusText || 'AJAX save failed'));
    });
    return this;
  };

  DocumentClassification.prototype.reset = function () {
    if (!this.state.original) return this;
    this.setData(this.state.original);
    this._setStatus('원본 데이터로 초기화', 'info');
    return this;
  };

  DocumentClassification.prototype.destroy = function () {
    this.closeImagePreview();
    $(document).off('keydown.dcPreview');
    if (this.$board && this.$board[0] && this._onBlockScrollCapture) {
      this.$board[0].removeEventListener('scroll', this._onBlockScrollCapture, true);
    }
    if (this.state.thumbObserver) {
      this.state.thumbObserver.disconnect();
      this.state.thumbObserver = null;
    }
    this.$root.off('.dc');
    this.$board.off('.dc');
    if (this.$sourceThumbs) this.$sourceThumbs.off('.dc');
    this.$el.removeData(DATA_KEY).empty();
  };

  $.fn[PLUGIN] = function (methodOrOptions) {
    var args = Array.prototype.slice.call(arguments, 1);
    var returnValue;

    this.each(function () {
      var $this = $(this);
      var instance = $this.data(DATA_KEY);

      if (typeof methodOrOptions === 'string') {
        if (!instance) {
          $.error('jQuery.' + PLUGIN + ' is not initialized');
          return;
        }
        if (typeof instance[methodOrOptions] !== 'function') {
          $.error('jQuery.' + PLUGIN + ' has no method "' + methodOrOptions + '"');
          return;
        }
        var result = instance[methodOrOptions].apply(instance, args);
        if (returnValue === undefined && result !== instance) {
          returnValue = result;
        }
        if (methodOrOptions === 'destroy') {
          $this.removeData(DATA_KEY);
        }
      } else {
        if (instance) instance.destroy();
        $this.data(DATA_KEY, new DocumentClassification($this, methodOrOptions || {}));
      }
    });

    return returnValue !== undefined ? returnValue : this;
  };

  $.fn[PLUGIN].defaults = DEFAULTS;
  $.fn[PLUGIN].ETC_GROUP_ID = ETC_GROUP_ID;
});
