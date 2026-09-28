<link rel="stylesheet" type="text/css" href="${ctx_res}/css/document-classification.css"/>
<link rel="stylesheet" type="text/css" href="${ctx_res}/css/document-classification-modal.css"/>

<div class="demo-modal" id="documentClassificationModal">
	<div class="demo-modal-box">
		<div class="demo-modal-head">
			<div class="demo-modal-title" id="documentClassificationTitle">
				<span data-dc-modal-title-base>문서분류 · 그룹 일괄 변경</span>
				<span class="demo-modal-title-mst" data-dc-modal-mst hidden>
					<span class="demo-modal-title-mst-label">Ref.No</span>
					<span class="demo-modal-title-mst-value" data-dc-modal-mst-value></span>
				</span>
			</div>
			<button type="button" class="demo-modal-close" data-dc-close title="닫기">&times;</button>
		</div>
		<div class="demo-modal-body">
			<div id="documentClassificationHost"></div>
		</div>
		<div class="demo-modal-foot">
			<button type="button" class="demo-btn" data-dc-reload>다시 불러오기</button>
			<button type="button" class="demo-btn" data-dc-reset>초기화</button>
			<button type="button" class="demo-btn" data-dc-close>닫기</button>
			<button type="button" class="demo-btn demo-btn-primary" data-dc-save>저장</button>
		</div>
	</div>
</div>

<script type="text/javascript" src="${ctx_res}/js/docclass/jquery.document-classification.js"></script>
<script type="text/javascript" src="${ctx_res}/js/docclass/document-classification-modal.js"></script>
<script type="text/javascript" src="${ctx_res}/js/docclass/document-classification-host.js"></script>
