package com.woori.ajs.api;

import java.io.File;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;
import org.springmodules.validation.commons.DefaultBeanValidator;

import com.woori.ajs.model.AdminBusinessDayVO;
import com.woori.ajs.model.AdminLogProgramVO;
import com.woori.ajs.model.AdminStatusVO;
import com.woori.ajs.model.AdminWordCorrectionVO;
import com.woori.ajs.model.LoginVO;
import com.woori.ajs.model.RevertStatCompleteVO;
import com.woori.ajs.model.RevertUngeneratedVO;
import com.woori.ajs.model.SearchVO;
import com.woori.ajs.service.AdminBusinessDayService;
import com.woori.ajs.service.AdminLogProgramService;
import com.woori.ajs.service.AdminWordCorrectionService;

import egovframework.rte.fdl.property.EgovPropertyService;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import egovframework.ui.cmmn.ComUtil;
import egovframework.ui.cmmn.DateUtil;
import egovframework.ui.cmmn.FileUtil;
import egovframework.ui.cmmn.HttpUtil;
import egovframework.ui.cmmn.StringUtil;
import egovframework.ui.cmmn.XlsUtil;
import egovframework.ui.util.LoginUtils;

@RestController
public class AdminWordCorrectionApiController {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(AdminWordCorrectionApiController.class);

	@Resource(name = "adminLogProgramService")
	private AdminLogProgramService adminLogProgramService;
	
	@Resource(name = "adminWordCorrectionService")
	private AdminWordCorrectionService adminWordCorrectionService;
	
	/** EgovPropertyService */
	@Resource(name = "propertiesService")
	protected EgovPropertyService propertiesService;

	/** Validator */
	@Resource(name = "beanValidator")
	protected DefaultBeanValidator beanValidator;

	@Resource(name = "systemFileProperties")
	protected Properties sysProp;
	
	// 후보정용어 화면 조회
	@GetMapping("/api/admin/word/correction/list")
	public HashMap<String,Object> wordCorrectionList(SearchVO searchVO) throws Exception {
		HashMap<String,Object> map = new HashMap<String,Object>();
		
		HttpUtil.setResult(map, HttpUtil.HttpType.T200);
		
		map.put("searchVO",searchVO);
		
		PaginationInfo paginationInfo = ComUtil.setListPagingInfo(propertiesService, searchVO);
		//searchVO.setRecordCountPerPage(-1);
		
		List<AdminWordCorrectionVO> list = adminWordCorrectionService.selectList(searchVO);
		map.put("resultList", list);
		
		int totCnt = adminWordCorrectionService.selectListTotCnt(searchVO);
		//int totCnt = list==null ? 0 : list.size();
		
		paginationInfo.setTotalRecordCount(totCnt);
		map.put("paginationInfo", paginationInfo);
		
		return map;
	}
	
	// 후보정용어 화면 구분 선택 시 항목값 변경이벤트
	@PostMapping("/api/admin/word/correction/change/combo")
	public HashMap<String, Object> changeComboList(SearchVO searchVO) throws Exception{
		HashMap<String,Object> map = new HashMap<String,Object>();
		
		HttpUtil.setResult(map, HttpUtil.HttpType.T200);
		
		map.put("searchVO",searchVO);
		
		List<AdminWordCorrectionVO> list = adminWordCorrectionService.selectSanctionList(searchVO);
		map.put("rst", "success");
		map.put("comboList", list);
		
		return map;
	}
	
	// 후보정용어 화면 용어 업데이트 및 신규등록
	@PostMapping("/api/admin/word/correction/update")
	public HashMap<String, Object> wordUpdate(HttpServletRequest request, AdminWordCorrectionVO adminWordCorrectionVO, AdminLogProgramVO adminLogProgramVO, SearchVO searchVO) throws Exception{
		HashMap<String,Object> map = new HashMap<String,Object>();
		
		HttpUtil.setResult(map, HttpUtil.HttpType.T200);
		map.put("searchVO",searchVO);
		LoginVO userInfo = LoginUtils.getLoginInfo(request);
		
		String trnLogSrno = null;
		
		adminWordCorrectionVO.setAiInptWordTxt(adminWordCorrectionVO.getAiInptWordTxt().replaceAll("[^\\x20-\\x7E]", "").replace("\n", "").replace("\r", "").replace("\t", " "));
		
		// 1) 업데이트하려는 용어 (구분+용어) 로  중복확인 체크
		// - 중복인경우 rst false return 중복이 아닌경우 continue
		int dupCheckNum = adminWordCorrectionService.selectWordDuplicationCheck(adminWordCorrectionVO);
		
		if(dupCheckNum > 0) {
			map.put("rst", "duplication");
		}else {
			// 2) insert 인지 update 인지 확인 후 로직수행
			trnLogSrno = adminLogProgramService.logProgramInsert(request, adminLogProgramVO, searchVO);
			
			adminWordCorrectionVO.setTrnLogSrno(trnLogSrno);
			adminWordCorrectionVO.setLstDbChgId(userInfo.getId());
			
			System.out.println(adminWordCorrectionVO.getAiInptWordTxt());
			
			// 2.1) insert 인 경우
			if(adminWordCorrectionVO.getAiInptWordSrno().equals("new")) {
				adminWordCorrectionService.insertWord(adminWordCorrectionVO);
				map.put("rst", "insert-success");
			}else {
				adminWordCorrectionService.updateWord(adminWordCorrectionVO);
				map.put("rst", "update-success");
			}
		}
		
		return map;
	}
	
	// 후보정용어 화면 용어 삭제
	@PostMapping("/api/admin/word/correction/delete")
	public HashMap<String, Object> wordDelete(HttpServletRequest request, AdminWordCorrectionVO adminWordCorrectionVO, AdminLogProgramVO adminLogProgramVO, SearchVO searchVO) throws Exception{
		HashMap<String,Object> map = new HashMap<String,Object>();
		
		HttpUtil.setResult(map, HttpUtil.HttpType.T200);
		map.put("searchVO",searchVO);
		LoginVO userInfo = LoginUtils.getLoginInfo(request);
		
		String trnLogSrno = null;
		trnLogSrno = adminLogProgramService.logProgramInsert(request, adminLogProgramVO, searchVO);
		
		adminWordCorrectionService.deleteWord(adminWordCorrectionVO);
		
		map.put("rst", "delete-success");
		
		return map;
	}
	
	// 후보정화면 엑셀다운로드
	@GetMapping("/api/admin/word/correction/xls")
	public ModelAndView listXls(SearchVO searchVO, ModelAndView mv) throws Exception {
		mv.setViewName("downView");					//파일다운로드뷰
		String xlsDownName = StringUtil.concat(new String[] {"후보정용어_",DateUtil.getFormatDate("yyyyMMdd"),".xlsx"});
		searchVO.setRecordCountPerPage(-1);
		List<AdminWordCorrectionVO> list = adminWordCorrectionService.selectList(searchVO);
		List<String[]> xlsListsTitle = XlsUtil.createListsTitle();
		List<List<LinkedHashMap<String,String>>> xlsLists = XlsUtil.createLists();
		xlsListsTitle.add(new String[] {"구분","항목","용어"});
		if(list!=null) {
			List<LinkedHashMap<String,String>> xlsList = XlsUtil.createList();
			for(int i=0;i<list.size();i++) {
				LinkedHashMap<String,String> rowMap = new LinkedHashMap<String,String>();
				// RevertStatCompleteVO row = (RevertStatCompleteVO)list.get(i);
				AdminWordCorrectionVO row = list.get(i);
				rowMap.put("aiInptGrpCdNm", row.getAiInptGrpCdNm()); // 구분(수출 || 수입 || 공통)
				rowMap.put("aiInptCmnCdNm", row.getAiInptCmnCdNm()); // 후보정 항목명
				rowMap.put("aiInptWordTxt", row.getAiInptWordTxt()); // 후보정 용어
				xlsList.add(rowMap);
			} 
			xlsLists.add(xlsList);
		}
		String uploadPath = StringUtil.nvl(sysProp.getProperty("upload.path"));
		File xlsFile = XlsUtil.createXlsFile(uploadPath, xlsListsTitle, xlsLists);
		try {
			FileUtil.setFileDown(mv, xlsFile, xlsDownName);
		} catch (Exception e) {
			LOGGER.error("Exception ::: " + e);
		}
		
		return mv;
	}
}