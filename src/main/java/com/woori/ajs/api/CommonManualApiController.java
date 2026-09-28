package com.woori.ajs.api;

import java.io.File;
import java.util.HashMap;
import java.util.List;
import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springmodules.validation.commons.DefaultBeanValidator;

import com.woori.ajs.model.AdminLogProgramVO;
import com.woori.ajs.model.AdminStatusVO;
import com.woori.ajs.model.CommonHistoryListVO;
import com.woori.ajs.model.CommonManualVO;
import com.woori.ajs.model.LoginVO;
import com.woori.ajs.model.SearchVO;
import com.woori.ajs.service.AdminLogProgramService;
import com.woori.ajs.service.AdminStatusService;
import com.woori.ajs.service.CommonManualService;

import egovframework.rte.fdl.property.EgovPropertyService;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import egovframework.ui.cmmn.CastUtil;
import egovframework.ui.cmmn.ComUtil;
import egovframework.ui.cmmn.DateUtil;
import egovframework.ui.cmmn.FileBinUtil;
import egovframework.ui.cmmn.FileUtil;
import egovframework.ui.cmmn.HttpCallUtil;
import egovframework.ui.cmmn.HttpUtil;
import egovframework.ui.cmmn.PropUtil;
import egovframework.ui.util.LoginUtils;

@RestController
public class CommonManualApiController {
	private static final Logger LOGGER = LoggerFactory.getLogger(CommonManualApiController.class);

	@Resource(name = "commonManualService")
	private CommonManualService commonManualService;
	
	/** EgovPropertyService */
	@Resource(name = "propertiesService")
	protected EgovPropertyService propertiesService;
	
	/** Validator */
	@Resource(name = "beanValidator")
	protected DefaultBeanValidator beanValidator;
	
	/** adminLogProgramService */
	@Resource(name = "adminLogProgramService")
	private AdminLogProgramService adminLogProgramService;
	
	@Resource(name = "systemFileProperties")
	protected Properties sysProp;
	
	@GetMapping("/common/manual/list")
	public HashMap<String,Object> list(SearchVO searchVO) throws Exception {
		HashMap<String,Object> map = new HashMap<String,Object>();
		
		HttpUtil.setResult(map, HttpUtil.HttpType.T200);
		
		map.put("searchVO",searchVO);
		
		PaginationInfo paginationInfo = ComUtil.setListPagingInfo(propertiesService, searchVO);
		//searchVO.setRecordCountPerPage(-1);
		
		List<CommonManualVO> list = commonManualService.selectList(searchVO);
		map.put("resultList", list);
		
		int totCnt = commonManualService.selectListTotCnt(searchVO);
		//int totCnt = list==null ? 0 : list.size();
		
		paginationInfo.setTotalRecordCount(totCnt);
		map.put("paginationInfo", paginationInfo);
		
		return map;
	}
	
	@PostMapping("/api/common/manual/upload")
	public HashMap<String,Object> uploadFile(MultipartHttpServletRequest mreq, HttpServletRequest request) throws Exception {
		HashMap<String,Object> map = new HashMap<String,Object>();
		HashMap<String,Object> params = new HashMap<String,Object>();
		HttpUtil.setResult(map, HttpUtil.HttpType.T200);
		LoginVO loginInfo = LoginUtils.getLoginInfo(request);
		AdminLogProgramVO adminLogProgramVO = new AdminLogProgramVO();
		String inptMstSrno = request.getParameter("inptMstSrno");
		String inptAtmcBizDscd = request.getParameter("inptAtmcBizDscd");
		
		//CommonHistoryListVO vo = new CommonHistoryListVO();
		CommonManualVO vo = new CommonManualVO();
		
		String path = sysProp.getProperty("upload.path");
		vo.setInptMstSrno("0");
		vo.setAiInptBizDscd("0");
		vo.setLstDbChgId(loginInfo.getId());
		SearchVO svo = new SearchVO();
		List<HashMap<String,String>> files = FileUtil.uploadFiles(mreq, path, "tmp", "manualFile");

		File file_tmp;
		String file_string;
		String dstFileName;
		String fileOrigName;
		
		StringBuffer keyAll = new StringBuffer();
		StringBuffer fileAll = new StringBuffer();
		
		// 로그이력
		String trnLogSrno;
		adminLogProgramVO.setAiInptCnctScrnNo("1001");
		adminLogProgramVO.setAiInptCnctActiCd("23");
		adminLogProgramVO.setAiInptCnctFldCd("");
		adminLogProgramVO.setAiInptCnctParmTxt("");
		trnLogSrno = adminLogProgramService.logProgramInsert(request, adminLogProgramVO, svo);
		vo.setTrnLogSrno(trnLogSrno);
		
		// DB INSERT
		for(int i=0; i<files.size(); i++) {
			HashMap<String,String> file = files.get(i);
			file_tmp = new File(file.get("fileSavePath"));
			file_string = FileBinUtil.fileToBinary(file_tmp);
			
			fileOrigName = file.get("fileOrgName");
			vo.setAiInptAtelNm(fileOrigName);
			// key값 생성
			StringBuffer key = new StringBuffer();
			key.append("/repository/aisac/");
			key.append(DateUtil.getFormatDate("yyyyMM/dd/"));
			key.append(DateUtil.getFormatDate("yyyyMMddHHmmss"));
			key.append('_');
			key.append(ComUtil.rand(1, 10000));
			key.append(".txt");
			dstFileName = key.toString();
			
			// db에 key값 설정 
			vo.setAiInptAtelPathTxt(dstFileName);
			
			if(i == 0) {
				keyAll.append(dstFileName);
				fileAll.append(file_string);
			} else {
				keyAll.append(',');
				keyAll.append(dstFileName);
				
				fileAll.append(',');
				fileAll.append(file_string);
			}
			file.put("uploadUrl", dstFileName);
			file_tmp.delete();
		}
		// api 파라미터 
		params.put("key", keyAll.toString());
		params.put("file", fileAll.toString());
			
		String result = HttpCallUtil.callPostUrl(PropUtil.API_FILE_UPLOAD_URL, params);
		JSONParser jsonParser = new JSONParser();
		JSONObject jsonOb = CastUtil.objToJSONObj(jsonParser.parse(result));
		String resultCode = CastUtil.objToStr(jsonOb.get("resultCode"));
		String resultMsg = CastUtil.objToStr(jsonOb.get("resultMsg"));
		String errorCode = CastUtil.objToStr(jsonOb.get("errorCode"));
		
		if("200".equals(resultCode)) {
			commonManualService.insertFileUpload(vo);
		}else {
			HttpUtil.setResult(map, HttpUtil.HttpType.T500);
			HttpUtil.setExResult(map, errorCode, resultMsg);
		}
		
		map.put("files",files);
		
		return map;
	}
	
	@GetMapping("/api/common/manual/delUploadedFile")
	public HashMap<String,Object> delUploadedFile(SearchVO vo, HttpServletRequest request, AdminLogProgramVO adminLogProgramVO) throws Exception {
		HashMap<String,Object> map = new HashMap<String,Object>();
		HashMap<String,Object> params = new HashMap<String,Object>();
		HttpUtil.setResult(map, HttpUtil.HttpType.T200);
		
		List<CommonManualVO> list = commonManualService.selectFileInfo(vo);
		String fileKey = list.get(0).getAiInptAtelPathTxt();
		
		params.put("key", fileKey);
		boolean httpResult = true;
		boolean result = true;
		
		String trnLogSrno;
		
		trnLogSrno = adminLogProgramService.logProgramInsert(request, adminLogProgramVO, vo);
		
		
		try {
			HttpCallUtil.callPostUrl(PropUtil.API_FILE_DELETE_URL, params);
			commonManualService.delUploadedFile(vo);
		}catch (Exception e) {
			result = false;
			httpResult = false;
		}
		map.put("result", result);
		map.put("httpResult", httpResult);
		return map;
	}
	
}
