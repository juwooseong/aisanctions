package com.woori.ajs.api;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Properties;
import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springmodules.validation.commons.DefaultBeanValidator;

import com.woori.ajs.model.AdminLogProgramVO;
import com.woori.ajs.model.AdminStatusVO;
import com.woori.ajs.model.CommonHistoryListVO;
import com.woori.ajs.model.LoginVO;
import com.woori.ajs.model.SearchVO;
import com.woori.ajs.service.AdminLogProgramService;
import com.woori.ajs.service.CommonRevertHistoryService;

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
public class CommonRevertHistoryApiController {

	/** commonRevertHistoryService */
	@Resource(name = "commonRevertHistoryService")
	private CommonRevertHistoryService commonRevertHistoryService;
	
	/** EgovPropertyService */
	@Resource(name = "propertiesService")
	protected EgovPropertyService propertiesService;

	/** adminLogProgramService */
	@Resource(name = "adminLogProgramService")
	private AdminLogProgramService adminLogProgramService;
	
	/** Validator */
	@Resource(name = "beanValidator")
	protected DefaultBeanValidator beanValidator;

	@Resource(name = "systemFileProperties")
	protected Properties sysProp;
	
	@GetMapping("/api/common/revert/history")
	public HashMap<String, Object> selectList(SearchVO vo) throws Exception {
		HashMap<String,Object> map = new HashMap<String,Object>();
		HttpUtil.setResult(map, HttpUtil.HttpType.T200);
		PaginationInfo paginationInfo = ComUtil.setListPagingInfo(propertiesService, vo);
		List<CommonHistoryListVO> list = commonRevertHistoryService.selectList(vo);
		int totCnt = commonRevertHistoryService.selectListTotCnt(vo);
		paginationInfo.setTotalRecordCount(totCnt);
		map.put("searchVO",vo);
		map.put("paginationInfo",paginationInfo);
		map.put("resultList",list);
		return map;
	}
	
	
	@PostMapping("/api/common/revert/history/upload")
	public HashMap<String,Object> uploadFile(MultipartHttpServletRequest mreq, HttpServletRequest request) throws Exception {
		HashMap<String,Object> map = new HashMap<String,Object>();
		HashMap<String,Object> params = new HashMap<String,Object>();
		HttpUtil.setResult(map, HttpUtil.HttpType.T200);
		LoginVO loginInfo = LoginUtils.getLoginInfo(request);
		AdminLogProgramVO adminLogProgramVO = new AdminLogProgramVO();
		SearchVO svo = new SearchVO();
		
		StringBuffer sb = new StringBuffer();
		String inptMstSrno = request.getParameter("inptMstSrno");
		String inptAtmcBizDscd = request.getParameter("inptAtmcBizDscd");
		String MFNumS = request.getParameter("MFNum");
		int MFNum = Integer.parseInt(MFNumS);
		String inptMstSrnoStr = "inptMstSrno=";
		String inptAtmcBizDscdStr = "&inptAtmcBizDscd=";
		String MFNumStr = "&MFNumS=";
		
		sb.append(inptMstSrnoStr);
		sb.append(inptMstSrno);
		sb.append(inptAtmcBizDscdStr);
		sb.append(inptAtmcBizDscd);
		sb.append(MFNumStr);
		sb.append(MFNumS);
		String parmTxt = sb.toString();
		adminLogProgramVO.setAiInptCnctScrnNo("9080");
		adminLogProgramVO.setAiInptCnctFldCd("14");
		adminLogProgramVO.setAiInptCnctParmTxt(parmTxt);
	
		CommonHistoryListVO vo = new CommonHistoryListVO();
	
		String path = sysProp.getProperty("upload.path");
		vo.setInptMstSrno(inptMstSrno);
		vo.setInptAtmcBizDscd(inptAtmcBizDscd);
		vo.setLstDbChgId(loginInfo.getId());
		
		String trnLogSrno;
	
		File file_tmp;
		String file_string;
		String dstFileName;
		String fileOrigName;
		
		StringBuffer keyAll = null;
		StringBuffer fileAll = null;
		int UFNum =0;
		if(MFNum == 0) {
			keyAll = new StringBuffer();
			fileAll = new StringBuffer();
			List<HashMap<String,String>> files = FileUtil.uploadFiles(mreq, path, "tmp", "fileUPload");
			
			if(files.size() == 1) {
				adminLogProgramVO.setAiInptCnctActiCd("23");
			}else {
				adminLogProgramVO.setAiInptCnctActiCd("25");
			}
			trnLogSrno = adminLogProgramService.logProgramInsert(request, adminLogProgramVO, svo);
			vo.setTrnlogsrno(trnLogSrno);
			
			for(int i=0; i<files.size(); i++) {
				if(i == 10) {
					break;
				}
				HashMap<String,String> file = files.get(i);
				file_tmp = new File(file.get("fileSavePath"));
				file_string = FileBinUtil.fileToBinary(file_tmp);
				
				fileOrigName = file.get("fileOrgName");
				vo.setAiInptAtflNm(fileOrigName);
				
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
				vo.setAiInptAtflPathTxt(dstFileName);
				
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
			commonRevertHistoryService.insertFileUpload(files, vo, -1);
		}else {
			HttpUtil.setResult(map, HttpUtil.HttpType.T500);
			HttpUtil.setExResult(map, errorCode, resultMsg);
		}
		
		map.put("files",files);
	}else { // 2번을 추가했다고 치면 MFNum : 2 (리스트는 총 3개, 최종 id 값은 fileUPload1 )
		int totalCnt=0; // 1	2	10
		List<HashMap<String,String>> filesMul = null; 
		int otherCnt = 0;
		int EndcountCnt;

		adminLogProgramVO.setAiInptCnctActiCd("25");
		
		trnLogSrno = adminLogProgramService.logProgramInsert(request, adminLogProgramVO, svo);
		vo.setTrnlogsrno(trnLogSrno);
		
		//adminLogProgramVO.setAiInptCnctActiCd("25");
		for(int j=0; j<=MFNum; j++) {   // MFNum = 2
			if(totalCnt == 9) {
				break;
			}
			keyAll = new StringBuffer();
			fileAll = new StringBuffer();
			
			if(j==0) {
				filesMul = FileUtil.uploadFiles(mreq, path, "tmp", "fileUPload");
			}else {
				filesMul = FileUtil.uploadFiles(mreq, path, "tmp", "fileUPload"+UFNum); //	UFNum+1 = MFNum
				UFNum++;
			}

			for(int i=0; i<filesMul.size(); i++) {
				totalCnt++; 
				HashMap<String,String> file = filesMul.get(i);
				file_tmp = new File(file.get("fileSavePath"));
				file_string = FileBinUtil.fileToBinary(file_tmp);
				
				fileOrigName = file.get("fileOrgName");
				vo.setAiInptAtflNm(fileOrigName);
				
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
				vo.setAiInptAtflPathTxt(dstFileName);
				
				if(totalCnt == 10) {
					break;
				}
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
				if(MFNum == j) {
					EndcountCnt = 10 - otherCnt;
					commonRevertHistoryService.insertFileUpload(filesMul, vo, EndcountCnt); //i 랑 
				}else {
					otherCnt += filesMul.size();
					commonRevertHistoryService.insertFileUpload(filesMul, vo, -1); //i 랑 
				}
			}else {
				HttpUtil.setResult(map, HttpUtil.HttpType.T500);
				HttpUtil.setExResult(map, errorCode, resultMsg);
			}
			if(totalCnt == 10) {
				break;
			}
		}
		map.put("files",filesMul);
	}
		return map;
	}
	
	
	@PostMapping("/api/common/revert/history/updateOpt")
	public HashMap<String, Object> updateOpt(SearchVO searchVO) throws Exception{
		HashMap<String,Object> map = new HashMap<String,Object>();
		HttpUtil.setResult(map, HttpUtil.HttpType.T200);
		
		String errorType = null;
		CommonHistoryListVO result = commonRevertHistoryService.selectOpt(searchVO);
		
		//입력될 의견
		String newOptText = searchVO.getTextOpt();
		long time = System.currentTimeMillis(); // 현재 시간 (입력될 시간)
		SimpleDateFormat dayTime = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss", java.util.Locale.KOREA);
		String nowTime = dayTime.format(new Date(time));
	    String lstDbChgDtmFormatedStr;
		nowTime = "[".concat(nowTime);
		nowTime = nowTime.concat("] ");

		String optText = result.getAiInspPrcOpi(); //  [2020-03-06 18:12:29] e
		String lstDbChgDtm = result.getLstDbChgDtm(); //2020 0102 183340925389
		lstDbChgDtm = lstDbChgDtm.substring(0, 14);
		SimpleDateFormat dayTime2 = new SimpleDateFormat("yyyyMMddHHmmss", java.util.Locale.KOREA);
		Date lstDbChgDtmFormated = dayTime2.parse(lstDbChgDtm);
		lstDbChgDtmFormatedStr = dayTime.format(lstDbChgDtmFormated); // DB에서 가져온것
		if(!"".equals(optText)) { // db에 의견이 있는경우
			newOptText = nowTime.concat(newOptText);
			newOptText = System.getProperty("line.separator").concat(newOptText);
			if("90".equals(searchVO.getAiInspAtvtStsCd()) || "100".equals(searchVO.getAiInspAtvtStsCd()) || "120".equals(searchVO.getAiInspAtvtStsCd()) 
					|| "130".equals(searchVO.getAiInspAtvtStsCd()) || "140".equals(searchVO.getAiInspAtvtStsCd()) 
					|| "150".equals(searchVO.getAiInspAtvtStsCd()) || "160".equals(searchVO.getAiInspAtvtStsCd())) {

				if(optText.contains(lstDbChgDtmFormatedStr) 
						|| ("[".equals(optText.substring(0, 1)) && "]".equals(optText.substring(20, 21)) 
								&& ":".equals(optText.substring(17, 18)) && ":".equals(optText.substring(14, 15)))) { 
					optText = optText.concat(newOptText);
					searchVO.setTextOpt(optText);
				}else {  // [2020-03-06 18:03:38] 1
					lstDbChgDtm = "[".concat(lstDbChgDtmFormatedStr);
					lstDbChgDtm = lstDbChgDtm.concat("] ");
					
					optText = lstDbChgDtm.concat(optText);
					optText = optText.concat(newOptText);
					
					searchVO.setTextOpt(optText);
				}
			}else { // 이력상태코드가 승인 또는 상신이 아닐경우 (추가해준 후)
				optText = optText.concat(newOptText);
				searchVO.setTextOpt(optText);
			}
		}else {  										// 이력상태코드가 승인 또는 상신이 아닐경우
			newOptText = nowTime.concat(newOptText);
			searchVO.setTextOpt(newOptText);  /// 이것도 날짜를 넣을지 ??
		}
		
		try {
			commonRevertHistoryService.updateOpt(searchVO);
		} catch (DataIntegrityViolationException e2) { // DataIntegrityViolationException
			HttpUtil.setResult(map, HttpUtil.HttpType.T500);
			errorType = "DIException";
		} catch (Exception e) {
			HttpUtil.setResult(map, HttpUtil.HttpType.T500);
			errorType = "exception";
		} finally {
			map.put("exceptResult", errorType);
		}
		map.put("searchVO",searchVO);
		return map;
	}
	
	@GetMapping("/api/common/revert/history/uploadList")
	public HashMap<String,Object> selectFile(SearchVO vo) throws Exception {
		HashMap<String,Object> map = new HashMap<String,Object>();
		HttpUtil.setResult(map, HttpUtil.HttpType.T200);
		PaginationInfo paginationInfo = ComUtil.setListPagingInfo(propertiesService, vo);
		vo.setRecordCountPerPage(-1);
		List<CommonHistoryListVO> fileList = commonRevertHistoryService.selectFileList(vo);
		int totCnt = commonRevertHistoryService.selectFileListTotCnt(vo);
		paginationInfo.setTotalRecordCount(totCnt);
		map.put("searchVO",vo);
		map.put("paginationInfo",paginationInfo);
		map.put("resultList", fileList);
		
		return map;
	}
	
	@GetMapping("/api/common/revert/history/delUploadedFile")
	public HashMap<String,Object> delUploadedFile(SearchVO vo, HttpServletRequest request, AdminLogProgramVO adminLogProgramVO) throws Exception {
		HashMap<String,Object> map = new HashMap<String,Object>();
		HashMap<String,Object> params = new HashMap<String,Object>();
		HttpUtil.setResult(map, HttpUtil.HttpType.T200);
		
		List<CommonHistoryListVO> list = commonRevertHistoryService.selectFileInfo(vo);
		String fileKey = list.get(0).getAiInptAtflPathTxt();
		
		params.put("key", fileKey);
		boolean httpResult = true;
		boolean result = true;
		
		String trnLogSrno = null;
		
		trnLogSrno = adminLogProgramService.logProgramInsert(request, adminLogProgramVO, vo);
		
		try {
			HttpCallUtil.callPostUrl(PropUtil.API_FILE_DELETE_URL, params);
			commonRevertHistoryService.delUploadedFile(vo);
		}catch (Exception e) {
			result = false;
			httpResult = false;
		}
		map.put("result", result);
		map.put("httpResult", httpResult);
		return map;
	}
	
}
/*2
fileUPload0forName ?????
0
param{"file":"","key":""}
error code ~!
File Not Found
2
fileUPload1forName ?????
2
2 : filesSize
watchlistBatchReg_20191217.xlsx : fileOrigName
2 : filesSize
watchlistBatchReg_20191218.xlsx : fileOrigName*/