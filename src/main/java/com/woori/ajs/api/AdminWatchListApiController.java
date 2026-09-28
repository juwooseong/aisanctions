package com.woori.ajs.api;

import java.io.File;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;
import org.springmodules.validation.commons.DefaultBeanValidator;

import com.woori.ajs.model.AdminLogProgramVO;
import com.woori.ajs.model.FilesVO;
import com.woori.ajs.model.LoginVO;
import com.woori.ajs.model.SearchVO;
import com.woori.ajs.model.WatchListVO;
import com.woori.ajs.service.AdminLogProgramService;
import com.woori.ajs.service.AdminWatchListService;
import com.woori.ajs.service.CommonRevertHistoryService;

import egovframework.rte.fdl.property.EgovPropertyService;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import egovframework.ui.cmmn.CastUtil;
import egovframework.ui.cmmn.ComUtil;
import egovframework.ui.cmmn.DateUtil;
import egovframework.ui.cmmn.FileUtil;
import egovframework.ui.cmmn.HttpUtil;
import egovframework.ui.cmmn.JsonUtil;
import egovframework.ui.cmmn.StringUtil;
import egovframework.ui.cmmn.XlsUtil;
import egovframework.ui.util.LoginUtils;

@RestController
public class AdminWatchListApiController {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(AdminWatchListApiController.class);

	@Resource(name = "adminLogProgramService")
	private AdminLogProgramService adminLogProgramService;
	
	@Resource(name = "adminWatchListService")
	private AdminWatchListService adminWatchListService;
	
	/** EgovPropertyService */
	@Resource(name = "propertiesService")
	protected EgovPropertyService propertiesService;

	/** Validator */
	@Resource(name = "beanValidator")
	protected DefaultBeanValidator beanValidator;

	@Resource(name = "systemFileProperties")
	protected Properties sysProp;
	
	/** commonRevertHistoryService */
	@Resource(name = "commonRevertHistoryService")
	private CommonRevertHistoryService commonRevertHistoryService;
	/**
	 * 카테고리 목록
	 */
	@GetMapping("/api/admin/watchlist/ctgrList")
	public HashMap<String,Object> ctgrList(SearchVO searchVO) throws Exception {
		HashMap<String,Object> map = new HashMap<String,Object>();
		
		HttpUtil.setResult(map, HttpUtil.HttpType.T200);
		
		PaginationInfo paginationInfo = ComUtil.setListPagingInfo(propertiesService, searchVO);
		searchVO.setRecordCountPerPage(-1);
		
		List<WatchListVO> list = adminWatchListService.selectCtgrList(searchVO);
		
		int totCnt = list==null ? 0 : list.size();
		paginationInfo.setTotalRecordCount(totCnt);
		
		map.put("resultList", list);
		map.put("paginationInfo", paginationInfo);
		
		return map;
	}
	
	/**
	 * 카테고리 정보
	 */
	@GetMapping("/api/admin/watchlist/ctgrInfo")
	public HashMap<String,Object> ctgrInfo(SearchVO searchVO) throws Exception {
		HashMap<String,Object> map = new HashMap<String,Object>();
		
		HttpUtil.setResult(map, HttpUtil.HttpType.T200);
		
		WatchListVO info = adminWatchListService.selectCtgr(searchVO);
		
		map.put("info", info);
		
		return map;
	}

	/**
	 * 카테고리 등록
	 */
	@PostMapping("/api/admin/watchlist/ctgr")
	public HashMap<String,Object> ctgrInsert(HttpServletRequest request, WatchListVO vo, AdminLogProgramVO adminLogProgramVO) throws Exception {
		HashMap<String,Object> map = new HashMap<String,Object>();
		LoginVO loginInfo = LoginUtils.getLoginInfo(request);
		
		HttpUtil.setResult(map, HttpUtil.HttpType.T200);
		
		if(StringUtil.isEmpty(vo.getCtgrCfcd())) {
			vo.setCtgrCfcd(adminWatchListService.selectNewCtgrCd());
		}
		
		String trnLogSrno = null;
		SearchVO searchVO = new SearchVO();
		trnLogSrno = adminLogProgramService.logProgramInsert(request, adminLogProgramVO, searchVO);
		
		vo.setTrnLogSrno(trnLogSrno);
		
		vo.setLstDbChgId(loginInfo.getId());
		//vo.setAiInptCtgrNm(XssUtil.escapeHtml(vo.getAiInptCtgrNm()));
		vo.setAiInptCtgrNm(vo.getAiInptCtgrNm());
		//vo.setAiInptCtgrTxt(XssUtil.escapeHtml(vo.getAiInptCtgrTxt()));
		vo.setAiInptCtgrTxt(vo.getAiInptCtgrTxt());
		adminWatchListService.insertCtgr(vo);
		
		return map;
	}

	/**
	 * 카테고리 삭제처리.
	 */
	@PostMapping("/api/admin/watchlist/ctgr/delete/{id}/{logScrNum}/{logFlag}/{logAction}/{logParam}")
	public HashMap<String,Object> ctgrDelete(@PathVariable String id,
											 @PathVariable String logScrNum,
											 @PathVariable String logFlag,
											 @PathVariable String logAction,
											 @PathVariable String logParam, WatchListVO vo, HttpServletRequest request) throws Exception {
		HashMap<String,Object> map = new HashMap<String,Object>();
		SearchVO searchVO = new SearchVO();
		LoginVO loginInfo = LoginUtils.getLoginInfo(request);
		
		String trnLogSrno = null;
		AdminLogProgramVO adminLogProgramVO = new AdminLogProgramVO();
		adminLogProgramVO.setAiInptCnctScrnNo(logScrNum);
		adminLogProgramVO.setAiInptCnctFldCd(logFlag);
		adminLogProgramVO.setAiInptCnctActiCd(logAction);
		adminLogProgramVO.setAiInptCnctParmTxt(logParam);
		//aiInptCnctParmTxt
		//aiInptCnctScrnNo
		//aiInptCnctActiCd
		//aiInptCnctFldCd
		trnLogSrno = adminLogProgramService.logProgramInsert(request, adminLogProgramVO, searchVO);
		
		HttpUtil.setResult(map, HttpUtil.HttpType.T200);
		
		vo.setTrnLogSrno(trnLogSrno);
		vo.setAiInptCtgrId(id);
		vo.setLstDbChgId(loginInfo.getId());
		//현재 카테고리의 하위 리스트 항목이 존재하는지 체크처리.
		//존재하면 삭제불가.
		boolean chk = false;
		searchVO.setAiInptCtgrId(id);
		List<WatchListVO> list = adminWatchListService.selectGrpList(searchVO);
		if(list==null || list.size()==0) {
			chk = true;
		}
		if(!chk) {
			HttpUtil.setResult(map, HttpUtil.HttpType.T500);
			HttpUtil.setExResult(map, "-1", "현재 카테고리의 하위에 종속된 리스트 항목이 존재합니다.\n종속된 리스트 항목을 모두 삭제하신 후에 삭제가 가능합니다.");
			return map;
		}
		
		//카테고리 삭제처리.
		adminWatchListService.deleteCtgr(vo);
		
		return map;
	}
	
	/**
	 * 리스트 목록
	 */
	@GetMapping("/api/admin/watchlist/groupList")
	public HashMap<String,Object> groupList(SearchVO searchVO) throws Exception {
		HashMap<String,Object> map = new HashMap<String,Object>();
		
		HttpUtil.setResult(map, HttpUtil.HttpType.T200);
		
		PaginationInfo paginationInfo = ComUtil.setListPagingInfo(propertiesService, searchVO);
		searchVO.setRecordCountPerPage(-1);
		
		List<WatchListVO> list = null;
		if(StringUtil.isNotEmpty(searchVO.getAiInptCtgrId())) {
			list = adminWatchListService.selectGrpList(searchVO);
		}
		
		int totCnt = list==null ? 0 : list.size();
		paginationInfo.setTotalRecordCount(totCnt);
		
		map.put("resultList", ComUtil.checkListNull(list));
		map.put("paginationInfo", paginationInfo);
		
		return map;
	}

	/**
	 * 리스트 정보
	 */
	@GetMapping("/api/admin/watchlist/groupInfo")
	public HashMap<String,Object> groupInfo(SearchVO searchVO) throws Exception {
		HashMap<String,Object> map = new HashMap<String,Object>();
		
		HttpUtil.setResult(map, HttpUtil.HttpType.T200);
		
		WatchListVO info = adminWatchListService.selectGrp(searchVO);
		
		map.put("info", info);
		
		return map;
	}

	/**
	 * 리스트 등록
	 */
	@PostMapping("/api/admin/watchlist/group")
	public HashMap<String,Object> groupInsert(HttpServletRequest request, WatchListVO vo, AdminLogProgramVO adminLogProgramVO) throws Exception {
		HashMap<String,Object> map = new HashMap<String,Object>();
		LoginVO loginInfo = LoginUtils.getLoginInfo(request);
		
		HttpUtil.setResult(map, HttpUtil.HttpType.T200);
		
		if(StringUtil.isEmpty(vo.getAiInptCtgrId()) || StringUtil.isEmpty(vo.getAiInptListNm())) {
			HttpUtil.setResult(map, HttpUtil.HttpType.T500);
			HttpUtil.setExResult(map, "-1", "정보가 부족합니다.");
			return map;
		}

		String trnLogSrno = null;
		SearchVO searchVO = new SearchVO();
		trnLogSrno = adminLogProgramService.logProgramInsert(request, adminLogProgramVO, searchVO);
		
		vo.setTrnLogSrno(trnLogSrno);
		
		vo.setLstDbChgId(loginInfo.getId());
		vo.setAiInptListNm(vo.getAiInptListNm());
		//vo.setAiInptListNm(XssUtil.escapeHtml(vo.getAiInptListNm()));
		adminWatchListService.insertGrp(vo);
		
		return map;
	}

	/**
	 * 리스트 삭제처리.
	 */
	@PostMapping("/api/admin/watchlist/group/delete/{id}/{id2}/{logScrNum}/{logFlag}/{logAction}/{logParam}")
	public HashMap<String,Object> groupDelete(@PathVariable String id, 
											  @PathVariable String id2, 
											  @PathVariable String logScrNum,
										   	  @PathVariable String logFlag,
										 	  @PathVariable String logAction,
											  @PathVariable String logParam, WatchListVO vo, HttpServletRequest request) throws Exception {
		HashMap<String,Object> map = new HashMap<String,Object>();
		SearchVO searchVO = new SearchVO();
		
		HttpUtil.setResult(map, HttpUtil.HttpType.T200);
		
		String trnLogSrno = null;
		AdminLogProgramVO adminLogProgramVO = new AdminLogProgramVO();
		adminLogProgramVO.setAiInptCnctScrnNo(logScrNum);
		adminLogProgramVO.setAiInptCnctFldCd(logFlag);
		adminLogProgramVO.setAiInptCnctActiCd(logAction);
		adminLogProgramVO.setAiInptCnctParmTxt(logParam);
		//aiInptCnctParmTxt
		//aiInptCnctScrnNo
		//aiInptCnctActiCd
		//aiInptCnctFldCd
		trnLogSrno = adminLogProgramService.logProgramInsert(request, adminLogProgramVO, searchVO);
		
		vo.setTrnLogSrno(trnLogSrno);
		vo.setAiInptCtgrId(id);
		vo.setAiInptListId(id2);
		
		//현재 리스트의 하위 내용 항목이 존재하는지 체크처리.
		//존재하면 삭제불가.
		boolean chk = false;
		searchVO.setAiInptCtgrId(id);
		searchVO.setAiInptListId(id2);
		searchVO.setUserYn("01");
		List<WatchListVO> list = adminWatchListService.selectContList(searchVO);
		if(list==null || list.size()==0) {
			chk = true;
		}
		if(!chk) {
			HttpUtil.setResult(map, HttpUtil.HttpType.T500);
			HttpUtil.setExResult(map, "-1", "현재 리스트의 하위에 종속된 내용 항목이 존재합니다.\n종속된 내용 항목을 모두 삭제하신 후에 삭제가 가능합니다.");
			return map;
		}
		
		//제재Rule1 체크
		/*boolean chk2 = false;
		if(!chk) {
			HttpUtil.setResult(map, HttpUtil.HttpType.T500);
			HttpUtil.setExResult(map, "-2", "현재 리스트에 관련된 제재Rule1 항목이 존재합니다.\n관련 제재Rule1 항목을 모두 삭제하신 후에 삭제가 가능합니다.");
			return map;
		}*/
		
		//제재Rule2 체크
		/*boolean chk3 = false;
		if(!chk) {
			HttpUtil.setResult(map, HttpUtil.HttpType.T500);
			HttpUtil.setExResult(map, "-3", "현재 리스트에 관련된 제재Rule2 항목이 존재합니다.\n관련 제재Rule2 항목을 모두 삭제하신 후에 삭제가 가능합니다.");
			return map;
		}*/
		
		//리스트 삭제처리.
		adminWatchListService.deleteGrp(vo);
		
		return map;
	}
	
	/**
	 * 내용 목록
	 */
	@GetMapping("/api/admin/watchlist/contList")
	public HashMap<String,Object> contList(SearchVO searchVO) throws Exception {
		HashMap<String,Object> map = new HashMap<String,Object>();
		
		HttpUtil.setResult(map, HttpUtil.HttpType.T200);
		
		PaginationInfo paginationInfo = ComUtil.setListPagingInfo(propertiesService, searchVO);
		searchVO.setRecordCountPerPage(-1);
		
		List<WatchListVO> list = null;
		if(StringUtil.isNotEmpty(searchVO.getAiInptCtgrId()) && StringUtil.isNotEmpty(searchVO.getAiInptListId())) {
			list = adminWatchListService.selectContList(searchVO);
		}
		
		int totCnt = list==null ? 0 : list.size();
		paginationInfo.setTotalRecordCount(totCnt);
		
		map.put("resultList", ComUtil.checkListNull(list));
		map.put("paginationInfo", paginationInfo);
		
		return map;
	}
	
	/**
	 * 내용 정보
	 */
	@GetMapping("/api/admin/watchlist/contInfo")
	public HashMap<String,Object> contInfo(SearchVO searchVO) throws Exception {
		HashMap<String,Object> map = new HashMap<String,Object>();
		
		HttpUtil.setResult(map, HttpUtil.HttpType.T200);
		
		WatchListVO info = adminWatchListService.selectCont(searchVO);
		
		map.put("info", info);
		
		return map;
	}

	/**
	 * 내용 등록
	 */
	@PostMapping("/api/admin/watchlist/cont")
	public HashMap<String,Object> contInsert(HttpServletRequest request, WatchListVO vo, AdminLogProgramVO adminLogProgramVO) throws Exception {
		HashMap<String,Object> map = new HashMap<String,Object>();
		LoginVO loginInfo = LoginUtils.getLoginInfo(request);
		
		HttpUtil.setResult(map, HttpUtil.HttpType.T200);
		
		if(StringUtil.isEmpty(vo.getAiInptCtgrId()) || StringUtil.isEmpty(vo.getAiInptListId()) || StringUtil.isEmpty(vo.getAiInptRsptTxtDesTxt())) {
			HttpUtil.setResult(map, HttpUtil.HttpType.T500);
			HttpUtil.setExResult(map, "-1", "정보가 부족합니다.");
			return map;
		}
		
		String trnLogSrno = null;
		SearchVO searchVO = new SearchVO();
		trnLogSrno = adminLogProgramService.logProgramInsert(request, adminLogProgramVO, searchVO);
		
		vo.setTrnLogSrno(trnLogSrno);
		
		vo.setLstDbChgId(loginInfo.getId());
		vo.setAiInptRsptTxtDesTxt(vo.getAiInptRsptTxtDesTxt());
		adminWatchListService.insertCont(vo);
		
		return map;
	}

	/**
	 * 내용 삭제처리.
	 */
	@PostMapping("/api/admin/watchlist/cont/deletee")
	public HashMap<String,Object> contDelete(HttpServletRequest request, WatchListVO vo, AdminLogProgramVO adminLogProgramVO) throws Exception {
		HashMap<String,Object> map = new HashMap<String,Object>();
		
		HttpUtil.setResult(map, HttpUtil.HttpType.T200);
		
	//	vo.setAiInptCtgrId(id);
	//	vo.setAiInptListId(id2);
	//	vo.setAiInptRsptTxtSrno(ComUtil.toInt(id3));
		
		String trnLogSrno = null;
		SearchVO searchVO = new SearchVO();
		trnLogSrno = adminLogProgramService.logProgramInsert(request, adminLogProgramVO, searchVO);
		
		vo.setTrnLogSrno(trnLogSrno);
	
		String[] aiInptRsptTxtSrnos = request.getParameterValues("aiInptRsptTxtSrnos");
		if(aiInptRsptTxtSrnos!=null && aiInptRsptTxtSrnos.length > 0) {
			for (String aiInptRsptTxtSrno : aiInptRsptTxtSrnos) {
				if(StringUtil.isNotEmpty(aiInptRsptTxtSrno)) {
					vo.setAiInptRsptTxtSrno(Integer.parseInt(aiInptRsptTxtSrno));
					//리스트 삭제처리.
					adminWatchListService.deleteCont(vo);
				}
			}
		}
		
		//리스트 삭제처리.
	//	adminWatchListService.deleteCont(vo);
		
		return map;
	}

	@PostMapping(value = "/api/admin/watchlist/excel/upload")
	@ResponseBody public HashMap<String,Object> uploadXls(MultipartHttpServletRequest mreq, HttpServletRequest request, AdminLogProgramVO adminLogProgramVO) throws Exception {
		HashMap<String,Object> map = new HashMap<String,Object>();
		LoginVO loginInfo = LoginUtils.getLoginInfo(request);
		SearchVO searchVO = new SearchVO();
		
		HttpUtil.setResult(map, HttpUtil.HttpType.T200);
		
		StringBuffer bf = new StringBuffer();
		String trnLogSrno = null;
		String cate_cdStr = "cate_cdStr=";
		String list_cdStr = "&list_cdStr=";
		String cate_cd = StringUtil.nvl(mreq.getParameter("cate_cd")).trim();
		String list_cd = StringUtil.nvl(mreq.getParameter("list_cd")).trim();
		
		bf.append(cate_cdStr);
		bf.append(cate_cd);
		bf.append(list_cdStr);
		bf.append(list_cd);
		
		if(StringUtil.isEmpty(cate_cd) || StringUtil.isEmpty(list_cd)) {
			HttpUtil.setResult(map, HttpUtil.HttpType.T500);
			HttpUtil.setExResult(map, "-1", "정보가 부족합니다.");
			return map;
		}

		//카테고리 아이디가 존재하는지 체크. 존재안하면 continue 다음처리로 건너뛰기.
		searchVO.setAiInptCtgrId(cate_cd);
		WatchListVO checkCtgr = adminWatchListService.selectCtgr(searchVO);
		if(checkCtgr==null) {
			HttpUtil.setResult(map, HttpUtil.HttpType.T500);
			HttpUtil.setExResult(map, "-2", "존재하지 않은 카테고리 아이디 입니다.");
			return map;
		}
		
		//목록 아이디가 존재하는지 체크. 존재안하면 continue 다음처리로 건너뛰기.
		searchVO.setAiInptCtgrId(cate_cd);
		searchVO.setAiInptListId(list_cd);
		WatchListVO checkLst = adminWatchListService.selectGrp(searchVO);
		if(checkLst==null) {
			HttpUtil.setResult(map, HttpUtil.HttpType.T500);
			HttpUtil.setExResult(map, "-2", "존재하지 않은 리스트 아이디 입니다.");
			return map;
		}
		
	    // Workbook.get		
		// 로컬에서 엑셀파일을 열거나 저장하면, 보안프로그램이 파일을 암호화해서,
		// 암호화된 엑셀파일을 업로드 하면, 읽기 포맷 오류가 남. 알 수 없는 포맷.
		String uploadPath = StringUtil.nvl(sysProp.getProperty("upload.path"));
		FilesVO xlsFiles = XlsUtil.getUploadedExcelFileList2(mreq, uploadPath);
		List<File> xlsFileList = xlsFiles.getFiles3();
		
		adminLogProgramVO.setAiInptCnctScrnNo("9080");
		adminLogProgramVO.setAiInptCnctFldCd("14");
		adminLogProgramVO.setAiInptCnctParmTxt(bf.toString());
		
		trnLogSrno = adminLogProgramService.logProgramInsert(request, adminLogProgramVO, searchVO);

		if(xlsFileList!=null && xlsFileList.size() > 0) {
			for(int i=0;i<xlsFileList.size();i++) {
				File xlsFile = xlsFileList.get(i);
				if(xlsFile.isFile() && xlsFile.exists()) {
				//	getXlsFileContNoTitle
					List<LinkedHashMap<String,String>> list = XlsUtil.getXlsFileCont(xlsFile);
					for (LinkedHashMap<String, String> listRow : list) {
						String content_txt = StringUtil.nvl(listRow.get("contents"));

						if(StringUtil.isEmpty(content_txt)) {
							continue;
						}
						
						//일괄등록처리
						WatchListVO vo = new WatchListVO();
						vo.setAiInptCtgrId(cate_cd);
						vo.setAiInptListId(list_cd);
						vo.setAiInptRsptTxtDesTxt(content_txt);
						vo.setLstDbChgId(loginInfo.getId());
						vo.setTrnLogSrno(trnLogSrno);
						vo.setLstDbChgId(loginInfo.getId());
						adminWatchListService.insertCont(vo);
					}
				}
				xlsFile.delete();    // 파일 바로 삭제 처리
			}
		}
		map.put("files",xlsFiles.getFiles());
		return map;
	}

	
	
	
	@GetMapping("/api/admin/watchlist/excel/dawnLoad")
	public ModelAndView listXls(ModelAndView mv) throws Exception {
		mv.setViewName("downView");					//파일다운로드뷰
		String xlsDownName = StringUtil.concat(new String[] {"watchListSample_",DateUtil.getFormatDate("yyyyMMdd"),".xlsx"});
		String[] cont = {"엑셀내용02", "엑셀내용03", "엑셀내용04", "엑셀내용05", "엑셀내용06", "엑셀내용07", "엑셀내용08", "엑셀내용09","엑셀내용10"};
		List<String[]> xlsListsTitle = XlsUtil.createListsTitle();
		
		List<List<LinkedHashMap<String,String>>> xlsLists = XlsUtil.createLists();
		List<LinkedHashMap<String,String>> xlsList = XlsUtil.createList();
		xlsListsTitle.add(new String[] {"엑셀내용01"});
		for(int i=0; i<cont.length; i++) {
			LinkedHashMap<String,String> rowMap = new LinkedHashMap<String,String>();
			rowMap.put("contents", cont[i]);
			xlsList.add(rowMap);
		}
		xlsLists.add(xlsList);
		String uploadPath = StringUtil.nvl(sysProp.getProperty("upload.path"));
		File xlsFile = XlsUtil.createXlsFile(uploadPath, xlsListsTitle, xlsLists);
		try {
			FileUtil.setFileDown(mv, xlsFile, xlsDownName);
		} catch (Exception e) {
			
			LOGGER.error("Exception ::: " + e);
		}
		
		return mv;
	}
	
	
	@PostMapping(value = "/api/admin/watchlist/json/upload")
	@ResponseBody public HashMap<String,Object> uploadJson(MultipartHttpServletRequest mreq, HttpServletRequest request) throws Exception {
		HashMap<String,Object> map = new HashMap<String,Object>();
		LoginVO loginInfo = LoginUtils.getLoginInfo(request);
		SearchVO searchVO = new SearchVO();
		
		HttpUtil.setResult(map, HttpUtil.HttpType.T200);

		String cate_cd = StringUtil.nvl(mreq.getParameter("cate_cd")).trim();
		String list_cd = StringUtil.nvl(mreq.getParameter("list_cd")).trim();
		
		if(StringUtil.isEmpty(cate_cd) || StringUtil.isEmpty(list_cd)) {
			HttpUtil.setResult(map, HttpUtil.HttpType.T500);
			HttpUtil.setExResult(map, "-1", "정보가 부족합니다.");
			return map;
		}

		//카테고리 아이디가 존재하는지 체크. 존재안하면 continue 다음처리로 건너뛰기.
		searchVO.setAiInptCtgrId(cate_cd);
		WatchListVO checkCtgr = adminWatchListService.selectCtgr(searchVO);
		if(checkCtgr==null) {
			HttpUtil.setResult(map, HttpUtil.HttpType.T500);
			HttpUtil.setExResult(map, "-2", "존재하지 않은 카테고리 아이디 입니다.");
			return map;
		}
		
		//목록 아이디가 존재하는지 체크. 존재안하면 continue 다음처리로 건너뛰기.
		searchVO.setAiInptCtgrId(cate_cd);
		searchVO.setAiInptListId(list_cd);
		WatchListVO checkLst = adminWatchListService.selectGrp(searchVO);
		if(checkLst==null) {
			HttpUtil.setResult(map, HttpUtil.HttpType.T500);
			HttpUtil.setExResult(map, "-2", "존재하지 않은 리스트 아이디 입니다.");
			return map;
		}
		
		String uploadPath = StringUtil.nvl(sysProp.getProperty("upload.path"));
		FilesVO jsonFiles = JsonUtil.getUploadedJsonFileList2(mreq, uploadPath);
		List<File> jsonFileList = jsonFiles.getFiles3();
		if(jsonFileList!=null && jsonFileList.size() > 0) {
			for(int i=0;i<jsonFileList.size();i++) {
				File jsonFile = jsonFileList.get(i);
				if(jsonFile.isFile() && jsonFile.exists()) {
					String jsonStr = StringUtil.nvl(FileUtil.readFile(jsonFile.getAbsolutePath()));
					if(StringUtil.isNotEmpty(jsonStr)) {
						JSONParser jps = new JSONParser();
						JSONArray list = CastUtil.objToJSONArr(jps.parse(jsonStr));
						for (Object object : list) {
							JSONObject obj = CastUtil.objToJSONObj(object);
							String cont = CastUtil.objToStr(obj.get("cont"));

							if(StringUtil.isEmpty(cont)) {
								continue;
							}

							//일괄등록처리
							WatchListVO vo = new WatchListVO();
							vo.setAiInptCtgrId(cate_cd);
							vo.setAiInptListId(list_cd);
							vo.setAiInptRsptTxtDesTxt(cont);
							//vo.setAiInptRsptTxtDesTxt(XssUtil.escapeHtml(cont));
							vo.setLstDbChgId(loginInfo.getId());
							adminWatchListService.insertCont(vo);
						}
					}
				}
				jsonFile.delete();
			}
		}
		
		map.put("files",jsonFiles.getFiles());
		
		return map;
	}
	
}