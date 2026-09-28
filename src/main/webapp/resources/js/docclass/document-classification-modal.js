(function (global) {
  'use strict';

  function merge(target, source) {
    Object.keys(source || {}).forEach(function (key) {
      target[key] = source[key];
    });
    return target;
  }

  function DocumentClassificationModal(options) {
    this.options = merge({
      modalSelector: '#documentClassificationModal',
      hostSelector: '#documentClassificationHost',
      openSelector: '[data-dc-open]',
      closeSelector: '[data-dc-close]',
      saveSelector: '[data-dc-save]',
      resetSelector: '[data-dc-reset]',
      reloadSelector: '[data-dc-reload]',
      titleSelector: '#documentClassificationTitle',
      titleBase: '문서분류 · 그룹 일괄 변경 (V4)',
      showTitleRefNo: true,
      data: null,
      pluginOptions: {},
      onOpen: null,
      onClose: null,
      onSaved: null,
      onError: null
    }, options || {});

    this.modal = document.querySelector(this.options.modalSelector);
    this.host = document.querySelector(this.options.hostSelector);
    this.$host = null;
    this.initialized = false;
    this._onDocumentClick = this._handleDocumentClick.bind(this);
  }

  DocumentClassificationModal.prototype.mount = function () {
    if (!this.modal) throw new Error('문서분류 모달 요소를 찾을 수 없습니다.');
    if (!this.host) throw new Error('문서분류 host 요소를 찾을 수 없습니다.');
    if (!global.jQuery) throw new Error('jQuery가 필요합니다.');
    if (typeof global.jQuery.fn.documentClassification !== 'function') {
      throw new Error('documentClassification 플러그인이 필요합니다.');
    }

    this.$host = global.jQuery(this.host);
    document.addEventListener('click', this._onDocumentClick);
    return this;
  };

  DocumentClassificationModal.prototype._ensurePlugin = function () {
    if (this.initialized) return;
    var self = this;
    var pluginOptions = merge({
      data: this.options.data,
      autoLoad: false,
      onSaved: function (result) {
        if (typeof self.options.onSaved === 'function') {
          self.options.onSaved(result);
        }
      },
      onError: function (error) {
        if (typeof self.options.onError === 'function') {
          self.options.onError(error);
        }
      }
    }, this.options.pluginOptions);

    this.$host.documentClassification(pluginOptions);
    this.initialized = true;
  };

  DocumentClassificationModal.prototype._matches = function (target, selector) {
    if (!target || !target.closest) return null;
    return target.closest(selector);
  };

  DocumentClassificationModal.prototype._handleDocumentClick = function (event) {
    if (this._matches(event.target, this.options.openSelector)) {
      event.preventDefault();
      this.open();
      return;
    }
    if (this._matches(event.target, this.options.closeSelector)) {
      event.preventDefault();
      this.close();
      return;
    }
    if (this._matches(event.target, this.options.saveSelector)) {
      event.preventDefault();
      this.save();
      return;
    }
    if (this._matches(event.target, this.options.resetSelector)) {
      event.preventDefault();
      this.reset();
      return;
    }
    if (this._matches(event.target, this.options.reloadSelector)) {
      event.preventDefault();
      this.reload();
      return;
    }
    if (event.target === this.modal) this.close();
  };

  DocumentClassificationModal.prototype._resolveInptMstSrno = function (data) {
    var src = data || this.getData() || this.options.data || null;
    if (!src) return '';
    var mst = src.actlFxRefno || src.ACTL_FX_REFNO || '';
    if (mst) return String(mst);
    var pages = src.pages || [];
    for (var i = 0; i < pages.length; i++) {
      var page = pages[i];
      if (!page) continue;
      mst = page.actlFxRefno || page.ACTL_FX_REFNO || '';
      if (mst) return String(mst);
    }
    return String(src.documentId || src.refNo || '');
  };

  DocumentClassificationModal.prototype._syncTitle = function (data) {
    if (!this.modal) return this;
    var titleRoot = this.modal.querySelector(this.options.titleSelector || '#documentClassificationTitle');
    if (!titleRoot) return this;

    var base = this.options.titleBase || '문서분류 · 그룹 일괄 변경 (V4)';
    var showTitleRefNo = this.options.showTitleRefNo !== false;
    var mst = showTitleRefNo ? this._resolveInptMstSrno(data) : '';
    var $base = titleRoot.querySelector('[data-dc-modal-title-base]');
    var $mst = titleRoot.querySelector('[data-dc-modal-mst]');
    var $mstValue = titleRoot.querySelector('[data-dc-modal-mst-value]');

    if ($base) $base.textContent = base;
    if ($mst && $mstValue) {
      if (mst) {
        $mstValue.textContent = mst;
        $mst.removeAttribute('hidden');
        titleRoot.setAttribute('title', base + ' · Ref.No=' + mst);
      } else {
        $mstValue.textContent = '';
        $mst.setAttribute('hidden', 'true');
        titleRoot.setAttribute('title', base);
      }
      return this;
    }

    titleRoot.textContent = mst ? (base + ' · ' + mst) : base;
    return this;
  };

  DocumentClassificationModal.prototype.open = function () {
    this._ensurePlugin();
    this._syncTitle();
    this.modal.classList.add('open');
    if (typeof this.options.onOpen === 'function') this.options.onOpen(this);
    return this;
  };

  DocumentClassificationModal.prototype.close = function () {
    this.modal.classList.remove('open');
    if (typeof this.options.onClose === 'function') this.options.onClose(this);
    return this;
  };

  DocumentClassificationModal.prototype.save = function () {
    this._ensurePlugin();
    this.$host.documentClassification('save');
    return this;
  };

  DocumentClassificationModal.prototype.reset = function () {
    this._ensurePlugin();
    this.$host.documentClassification('reset');
    this._syncTitle();
    return this;
  };

  DocumentClassificationModal.prototype.reload = function () {
    this._ensurePlugin();
    this.$host.documentClassification('load');
    this._syncTitle();
    return this;
  };

  DocumentClassificationModal.prototype.setData = function (data) {
    this.options.data = data;
    this._ensurePlugin();
    this.$host.documentClassification('setData', data);
    this._syncTitle(data);
    return this;
  };

  DocumentClassificationModal.prototype.getData = function () {
    this._ensurePlugin();
    return this.$host.documentClassification('getData');
  };

  DocumentClassificationModal.prototype.getSavePayload = function (mode) {
    this._ensurePlugin();
    return this.$host.documentClassification('getSavePayload', mode);
  };

  DocumentClassificationModal.prototype.setOptions = function (options) {
    this._ensurePlugin();
    var opts = options || {};
    if (Object.prototype.hasOwnProperty.call(opts, 'showTitleRefNo')) {
      this.options.showTitleRefNo = !!opts.showTitleRefNo;
    }
    if (Object.prototype.hasOwnProperty.call(opts, 'titleBase')) {
      this.options.titleBase = String(opts.titleBase || '');
    }
    this.options.pluginOptions = merge(this.options.pluginOptions, opts);
    this.$host.documentClassification('setOptions', opts);
    this._syncTitle();
    return this;
  };

  DocumentClassificationModal.prototype.getOptions = function () {
    this._ensurePlugin();
    var opts = this.$host.documentClassification('getOptions') || {};
    opts.showTitleRefNo = this.options.showTitleRefNo !== false;
    opts.titleBase = this.options.titleBase || '문서분류 · 그룹 일괄 변경 (V4)';
    return opts;
  };

  DocumentClassificationModal.prototype.moveSelectedTo = function (groupId, documentType) {
    this._ensurePlugin();
    return this.$host.documentClassification('moveSelectedTo', groupId, documentType);
  };

  DocumentClassificationModal.prototype.moveSelectedToActive = function () {
    this._ensurePlugin();
    return this.$host.documentClassification('moveSelectedToActive');
  };

  DocumentClassificationModal.prototype.moveSelectedByCombo = function () {
    this._ensurePlugin();
    return this.$host.documentClassification('moveSelectedByCombo');
  };

  DocumentClassificationModal.prototype.moveSelectedBackToPool = function () {
    this._ensurePlugin();
    return this.$host.documentClassification('moveSelectedBackToPool');
  };

  DocumentClassificationModal.prototype.setActiveTarget = function (groupId, documentType) {
    this._ensurePlugin();
    this.$host.documentClassification('setActiveTarget', groupId, documentType);
    return this;
  };

  DocumentClassificationModal.prototype.setEtcPaneVisible = function (visible) {
    this._ensurePlugin();
    this.options.pluginOptions = merge(this.options.pluginOptions, { showEtcPane: !!visible });
    this.$host.documentClassification('setEtcPaneVisible', visible);
    return this;
  };

  DocumentClassificationModal.prototype.toggleEtcPane = function () {
    this._ensurePlugin();
    return this.$host.documentClassification('toggleEtcPane');
  };

  DocumentClassificationModal.prototype.getSelectedPageIds = function () {
    this._ensurePlugin();
    return this.$host.documentClassification('getSelectedPageIds');
  };

  DocumentClassificationModal.prototype.getRightSelectedPageIds = function () {
    this._ensurePlugin();
    return this.$host.documentClassification('getRightSelectedPageIds');
  };

  DocumentClassificationModal.prototype.clearSelection = function () {
    this._ensurePlugin();
    this.$host.documentClassification('clearSelection');
    return this;
  };

  DocumentClassificationModal.prototype.openImagePreview = function (pageId) {
    this._ensurePlugin();
    this.$host.documentClassification('openImagePreview', pageId);
    return this;
  };

  DocumentClassificationModal.prototype.closeImagePreview = function () {
    this._ensurePlugin();
    this.$host.documentClassification('closeImagePreview');
    return this;
  };

  DocumentClassificationModal.prototype.destroy = function () {
    document.removeEventListener('click', this._onDocumentClick);
    if (this.initialized) {
      this.$host.documentClassification('destroy');
      this.initialized = false;
    }
    return this;
  };

  global.DocumentClassificationModal = DocumentClassificationModal;
})(window);
