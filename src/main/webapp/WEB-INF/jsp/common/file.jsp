<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%-- 
<c:out value="${param.pageId}" />
<script>
fileUploadControl_<c:out value="${pageId}" />.uploadCallback = function(list,errInfo){
	if(errInfo){
		//업로드 실패
		alert(errInfo.code + " : " + errInfo.msg);
	} else {
		//업로드 성공
		console.info(list);
	}
};
</script>
<jsp:include page="/common/file" flush="false">
	<jsp:param name="pageId" value="${pageId}" />
	<jsp:param name="pageTitle" value="첨부파일 업로드" />
	<jsp:param name="fileLayerId" value="primaryFileUploadModal" />
	<jsp:param name="fileFormId" value="formFile" />
	<jsp:param name="fileFormAction" value="/api/admin/watchlist/excel/upload" />
	<jsp:param name="mode" value="multiple/single" />
	<jsp:param name="fileListYN" value="Y" />
	<jsp:param name="fileExtLimit" value="xls,xlsx" />
	<jsp:param name="param1Name" value="extraParam1Name" />
	<jsp:param name="param2Name" value="extraParam2Name" />
	<jsp:param name="param3Name" value="extraParam3Name" />
	<jsp:param name="param4Name" value="extraParam4Name" />
	<jsp:param name="param5Name" value="extraParam5Name" />
</jsp:include>
--%>



<c:set var="fileListYN" value="${param.fileListYN eq 'N' ? 'N' : 'Y'}"/>
<div class="modal fade" id="<c:out value="${param.fileLayerId}" />" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-primary" role="document">
    <div class="modal-content">
      <div class="container">
        <h2 class="title">
        	<button class="close popupClose" type="button" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true" class="textXinCloseBtn">×</span>
        </button>
        	<strong><c:out value="${param.pageTitle}" /></strong>
        </h2>
        
      </div>
      <div class="modal-body">
        
       	<form method="post" enctype="multipart/form-data" id="<c:out value="${param.fileFormId}" />" name="<c:out value="${param.fileFormId}" />" action="<c:out value="${param.fileFormAction}" />">
       	<c:if test="${not empty param.paramName1}"><input type="hidden" name='<c:out value="${param.paramName1}" />' value=''/></c:if>
       	<c:if test="${not empty param.paramName2}"><input type="hidden" name='<c:out value="${param.paramName2}" />' value=''/></c:if>
       	<c:if test="${not empty param.paramName3}"><input type="hidden" name='<c:out value="${param.paramName3}" />' value=''/></c:if>
       	<c:if test="${not empty param.paramName4}"><input type="hidden" name='<c:out value="${param.paramName4}" />' value=''/></c:if>
       	<c:if test="${not empty param.paramName5}"><input type="hidden" name='<c:out value="${param.paramName5}" />' value=''/></c:if>
       	<div class="input-group">
       	  <div class="form-group row">
	              <div class="col-md-9 input-file-area">
	              	<div class="filebox">
	              		<span>파일명</span>
	              		<input type="text" class="filename_text" readonly/>
	              		<c:choose>
	              		<c:when test="${param.mode eq 'multiple'}">
	                		<input id="file-multiple-input<c:out value="${param.pageId}" />" type="file" name="upfile" multiple="multiple" style="display:none;">
	              		</c:when>
		              	<c:otherwise>
			              	<input id="file-multiple-input<c:out value="${param.pageId}" />" type="file" name="upfile" style="display:none;">
			            </c:otherwise>
		            </c:choose>
	              	</div>
	              	
	              </div>
             </div>
             <div class="footBt">
             	<span class="c">
             		<button class="btType2" type="button" onclick="uploadReset();">신규</button>
	             	<button class="btType2" type="button" id="btn-upload">파일검색</button>
	              	<button class="btn btn-sm btn-success btType1" type="button" onclick="uploadFile_<c:out value="${param.pageId}" />();">파일업로드</button>
		        </span>
		      </div>
           </div>
           </form>
           
           <div class="col-sm-12 col-xl-3" <c:if test="${fileListYN eq 'N'}"> style="display:none;" </c:if>>
			<div class="card" style="width:430px;">
				<div class="card-header" style="border-top:1px solid #cfcfcf;">
					<i class="icons font-2xl cui-settings"></i> 파일목록
				</div>
				<div class="card-body">
					<nav class="nav flex-column">
						<table style="width:100%;" id="fileListLayer<c:out value="${param.pageId}" />">
						<colgroup>
							<col style="width:80%">
							<col style="width:20%">
						</colgroup>
						<tbody></tbody>
						</table>
					</nav>
				</div>
			</div>
		</div>
      </div>
    </div>
  </div>
</div>

<form name="formDown<c:out value="${param.pageId}" />" action="/common/down" method="post">
	<input type="hidden" name="filePath" value="" />
	<input type="hidden" name="orgFileName" value="" />
</form>

<script>
/*
$(function() {
	uploadReset();
});*/

function downFile<c:out value="${param.pageId}" />(filePath,orgFileName){
	var formDown = document.formDown<c:out value="${param.pageId}" />;
	formDown.filePath.value = filePath;
	formDown.orgFileName.value = orgFileName;
	formDown.submit();
}

var fileUploadControl_<c:out value="${param.pageId}" /> = {
	fileIdx : 0,
	removeFiles : [],
	fileExtLimit : '<c:out value="${param.fileExtLimit}"/>',
	getForm : function(){
		return $("#formFile<c:out value="${param.pageId}" />");
	},
	getLayer : function(){
		return $("#fileListLayer<c:out value="${param.pageId}" />");
	},
	getFileList : function(){
		var list = this.getLayer().find("tbody > tr");
		return list;
	},
	getFileItem : function(idx){
		var result = null;
		var list = this.getFileList();
		list.each(function(idx2,obj){
			var item = $(obj);
			if( item.data('idx')==idx ){
				result = item;
				return false;
			}
		});
		return result;
	},
	getFileCnt : function(){
		var list = this.getFileList();
		return list.length - 1;
	},
	getFileItemHtml : function(idx,title,info){
		var tmpl = [];
		info = info ? info : {};
		tmpl.push('<tr data-idx="'+idx+'" data-save-filename="'+info.fileSaveName+'" data-org-filename="'+info.fileOrgName+'" data-filesize="'+info.fileSize+'" data-fileext="'+info.fileExt+'" data-fileurl="'+info.uploadUrl+'">');
		tmpl.push('<td><div style="width:100%;word-break:break-all;"><a class="nav-link active" href="javascript:downFile<c:out value="${param.pageId}" />(\''+info.uploadUrl+'\',\''+info.fileOrgName+'\');">'+title+'</a></div></td>');
		tmpl.push('<td><span class="badge badge-primary badge-pill" style="cursor:pointer;background-color:#f86c6b;z-index:0;" onclick="fileUploadControl_<c:out value="${param.pageId}" />.removeFileItem('+idx+');">삭제</span></td>');
		tmpl.push('</tr>');
		return tmpl.join('');
	},
	addFileItem : function(title,info){
		var html = this.getFileItemHtml(this.fileIdx,title,info);
		this.getLayer().find('tbody').append(html);
		this.fileIdx++;
	},
	setFileItems : function(files){
		//파일리스트를 json 으로 받아온 파일목록을 받아서,
		//해당 정보로 파일 목록정보를 셋팅함.
		//수정페이지에서 처음에 페이지 들어올때, 파일관리자 초기내용 셋팅.
	},
	removeFileItem : function(idx){
		if(confirm("파일을 삭제하시겠습니까?")){
			var item = this.getFileItem(idx);
			if(item){
				this.removeFiles.push(item.data('fileurl'));
				item.remove();
			}
		}
		//console.info(this.removeFiles);
	},
	refreshInputFile : function() {
		var inputFileArea = $('#<c:out value="${param.fileFormId}" />').find(".input-file-area");

		<c:choose>
	      	<c:when test="${param.mode eq 'multiple'}">
				inputFileArea.html('<div class="filebox"><button class="btType2" type="button" id="btn-upload">파일검색</button><input type="text" class="filename_text" readonly="" autocomplete="off"><input id="file-multiple-input<c:out value="${param.pageId}" />" type="file" name="upfile" multiple="multiple" style="display:none;" autocomplete="off"></div>');
	      	</c:when>
	      	<c:otherwise>
				inputFileArea.html('<div class="filebox"><button class="btType2" type="button" id="btn-upload">파일검색</button><input type="text" class="filename_text" readonly="" autocomplete="off"><input id="file-multiple-input<c:out value="${param.pageId}" />" type="file" name="upfile" style="display:none;" autocomplete="off"></div>');
	      	</c:otherwise>
      	</c:choose>
      	
      	var modalCloseEle = $('.popupClose');
      	modalCloseEle.click();
		
	},
	closeLayer : function() {
		var v_layer = $('#<c:out value="${param.fileLayerId}" />');
		v_layer.find('.modal-footer button.btn-secondary').trigger('click');
	}
};

$(document).on('click','#btn-upload', function(e) {
	e.preventDefault();
	$('#file-multiple-input<c:out value="${param.pageId}" />').click();
});

$(document).on('change','#file-multiple-input<c:out value="${param.pageId}" />', function(e) {
	if(window.FileReader){
		var filename = $(this)[0].files[0].name;
	}
	else{
		var filename = $(this).val().split('/').pop().split('\\').pop();
	}
	
	$(this).siblings('.filename_text').val(filename);
});

/*
$(function() {
	
	var fileElement = $('#file-multiple-input<c:out value="${param.pageId}" />');
	
	$('#btn-upload').click(function (e) {
		e.preventDefault();
		$('#file-multiple-input<c:out value="${param.pageId}" />').click();
	});
	
	fileElement.on('change', function(){
		if(window.FileReader){
			var filename = $(this)[0].files[0].name;
		}
		else{
			var filename = $(this).val().split('/').pop().split('\\').pop();
		}
		
		$(this).siblings('.filename_text').val(filename);
	});
});*/

function uploadReset(){
	$('#file-multiple-input<c:out value="${param.pageId}" />').val("");
	$('.filename_text').val("");
}

//파일 업로드 처리.
//jquery.form.js 플러그인 사용 방식.
function uploadFile_<c:out value="${param.pageId}" />(){
	var fileInput = $('#file-multiple-input<c:out value="${param.pageId}" />');
	var filePath = $.trim(fileInput.val());
	
	if(!filePath){
		alert('파일을 선택해주세요.');
		return;
	}
	
	//확장자 제한처리
	var fileExtLimit = fileUploadControl_<c:out value="${param.pageId}" />.fileExtLimit;
	if(fileExtLimit && filePath){
		fileExtLimit = fileExtLimit.toLowerCase();
		
		var fileExt = fnCmnGetFileExt(filePath);
		fileExt = fileExt ? fileExt.toLowerCase() : '';
		
		//허용확장자 목록에서, 현재 파일업로드할 확장자가 포함되어 있는지 체크.
		//허용되지 않은 확장자이면, 업로드 콜백함수에, 데이터 목록 파라미터는 널을 넘기고, 두번째 인자에 에러 정보객체를 넘김.
		if((','+fileExtLimit+',').indexOf(','+fileExt+',')==-1){
			var errInfo = {'code':'-1','msg':'허용되지 않은 확장자입니다.\n확장자가 '+fileExtLimit+'인 파일만 업로드 가능합니다.'};
			
			if(fileUploadControl_<c:out value="${param.pageId}" />.uploadCallback){
				fileUploadControl_<c:out value="${param.pageId}" />.uploadCallback(null,errInfo);
			}
			
			return;
		}
	}
	
	//파일 업로드 처리
	var options = {
		dataType: 'json',
		success:function(data){
			var list = data.files;
			for(var i=0;i<list.length;i++){
				var info = list[i];
				fileUploadControl_<c:out value="${param.pageId}" />.addFileItem(info.fileOrgName,info);
			}
			fileUploadControl_<c:out value="${param.pageId}" />.refreshInputFile();
			
			//파일업로드 완료후 콜백함수 호출.
			if(fileUploadControl_<c:out value="${param.pageId}" />.uploadCallback){
				fileUploadControl_<c:out value="${param.pageId}" />.uploadCallback(list);
			}
		},
		error: function(e){
			console.info(e.responseText);
		}
	};
	$("#<c:out value="${param.fileFormId}" />").ajaxForm(options).submit();
}
</script>