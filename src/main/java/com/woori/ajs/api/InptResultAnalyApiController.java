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
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;
import org.springmodules.validation.commons.DefaultBeanValidator;

import com.woori.ajs.model.InptResultAnalyVO;
import com.woori.ajs.model.SearchVO;
import com.woori.ajs.service.AdminLogProgramService;
import com.woori.ajs.service.InptResultAnalyService;
import com.woori.ajs.service.RevertTodoService;

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
public class InptResultAnalyApiController {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(RevertStatCompleteApiController.class);

	/** revertTodoService */
	@Resource(name = "inptResultAnalyService")
	private InptResultAnalyService inptResultAnalyService;

	/** EgovPropertyService */
	@Resource(name = "propertiesService")
	protected EgovPropertyService propertiesService;

	/** Validator */
	@Resource(name = "beanValidator")
	protected DefaultBeanValidator beanValidator;

	@Resource(name = "systemFileProperties")
	protected Properties sysProp;
	
	
	@GetMapping("/api/inpt/result/analy/xls/ref")
	public ModelAndView refListXls(SearchVO searchVO, ModelAndView mv) throws Exception {
		mv.setViewName("downView");					//파일다운로드뷰
		String xlsDownName = StringUtil.concat(new String[] {"심사결과분석_세트별_",DateUtil.getFormatDate("yyyyMMdd"),".xlsx"});
		searchVO.setRecordCountPerPage(-1);
		List<InptResultAnalyVO> list = inptResultAnalyService.selectRefList(searchVO);
		List<String[]> xlsListsTitle = XlsUtil.createListsTitle();
		List<List<LinkedHashMap<String,String>>> xlsLists = XlsUtil.createLists();
		xlsListsTitle.add(new String[] {"Ref.No", "회차", "총항목수", "추출항목수", "수기입력수","미추출수","과탐수"});
		if(list!=null) {
			List<LinkedHashMap<String,String>> xlsList = XlsUtil.createList();
			for(int i=0;i<list.size();i++) {
				LinkedHashMap<String,String> rowMap = new LinkedHashMap<String,String>();
				// RevertStatCompleteVO row = (RevertStatCompleteVO)list.get(i);
				InptResultAnalyVO row = list.get(i);
				rowMap.put("refNO", row.getRefNO());			// Ref.No
				rowMap.put("refCnt", row.getRefCnt());			// 회차
				rowMap.put("totCnt", row.getTotCnt());			// 총항목수
				rowMap.put("chuchulCnt", row.getChuchulCnt());	// 추출항목수
				rowMap.put("sugiCnt", row.getSugiCnt());		// 수기입력수
				rowMap.put("nopChuchul", row.getNopChuchul());	// 미추출수
				rowMap.put("kwaTam", row.getKwaTam());			// 과탐수
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
	
	
	@GetMapping("/api/inpt/result/analy/xls/category")
	public ModelAndView categoryListXls(SearchVO searchVO, ModelAndView mv) throws Exception {
		mv.setViewName("downView");					//파일다운로드뷰
		String xlsDownName = StringUtil.concat(new String[] {"심사결과분석_항목별_",DateUtil.getFormatDate("yyyyMMdd"),".xlsx"});
		searchVO.setRecordCountPerPage(-1);
		List<InptResultAnalyVO> list = inptResultAnalyService.selectCategoryList(searchVO);
		List<String[]> xlsListsTitle = XlsUtil.createListsTitle();
		List<List<LinkedHashMap<String,String>>> xlsLists = XlsUtil.createLists();
		xlsListsTitle.add(new String[] {"항목", "추출건수", "수기등록건", "미추출건", "과탐수"});
		if(list!=null) {
			List<LinkedHashMap<String,String>> xlsList = XlsUtil.createList();
			for(int i=0;i<list.size();i++) {
				LinkedHashMap<String,String> rowMap = new LinkedHashMap<String,String>();
				// RevertStatCompleteVO row = (RevertStatCompleteVO)list.get(i);
				InptResultAnalyVO row = list.get(i);
				rowMap.put("name", row.getName());				// 항목
				rowMap.put("chuchulCnt", row.getChuchulCnt());	// 추출건수
				rowMap.put("sugiCnt", row.getSugiCnt());		// 수기등록건 	
				rowMap.put("nopChuchul", row.getNopChuchul());	// 미추출건
				rowMap.put("kwaTam", row.getKwaTam());			// 과탐수
			
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
	
	@GetMapping("/api/inpt/result/analy/xls/performance")
	public ModelAndView listXls(SearchVO searchVO, ModelAndView mv) throws Exception {
		mv.setViewName("downView");					//파일다운로드뷰
		String xlsDownName = StringUtil.concat(new String[] {"처리성능분석_",DateUtil.getFormatDate("yyyyMMdd"),".xlsx"});
		searchVO.setRecordCountPerPage(-1);
		List<InptResultAnalyVO> list = inptResultAnalyService.selectPerformanceList(searchVO);
		List<String[]> xlsListsTitle = XlsUtil.createListsTitle();
		List<List<LinkedHashMap<String,String>>> xlsLists = XlsUtil.createLists();
		xlsListsTitle.add(new String[] {"마스터번호", "Ref.No", "회차", "이미지 페이지수", "스캔유입시각", "TA 종료시각","분","초"});
		if(list!=null) {
			List<LinkedHashMap<String,String>> xlsList = XlsUtil.createList();
			for(int i=0;i<list.size();i++) {
				LinkedHashMap<String,String> rowMap = new LinkedHashMap<String,String>();
				// RevertStatCompleteVO row = (RevertStatCompleteVO)list.get(i);
				InptResultAnalyVO row = list.get(i);
				rowMap.put("inpt_mst_srno", row.getInpt_mst_srno());	// 마스터번호
				rowMap.put("actl_fx_refno", row.getActl_fx_refno());	// Ref.No
				rowMap.put("fx_refno_srno", row.getFx_refno_srno());	// 회차
				rowMap.put("img_pg", row.getImg_pg());					// 이미지 페이지수
				rowMap.put("scan_tm", row.getScan_tm());				// 스캔유입시각
				rowMap.put("ta_tm", row.getTa_tm());					// TA 종료시각
				rowMap.put("rst_min", row.getRst_min());				// 분
				rowMap.put("rst_sec", row.getRst_sec());				// 초
	
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
	
	@GetMapping("/api/inpt/result/analy/xls/sugi")
	public ModelAndView listSugiXls(SearchVO searchVO, ModelAndView mv) throws Exception {
		mv.setViewName("downView");					//파일다운로드뷰
		String xlsDownName = StringUtil.concat(new String[] {"심사_수기등록건_조회현황_",DateUtil.getFormatDate("yyyyMMdd"),".xlsx"});
		searchVO.setRecordCountPerPage(-1);
		List<InptResultAnalyVO> list = inptResultAnalyService.selectSugiList(searchVO);
		List<String[]> xlsListsTitle = XlsUtil.createListsTitle();
		List<List<LinkedHashMap<String,String>>> xlsLists = XlsUtil.createLists();
		xlsListsTitle.add(new String[] {"마스터번호", "Ref.No", "회차", "B/L그룹", "항목명", "추출값", "수기값", "확인", "TA추출", "AICR추출", "심사자", "변경시간", "상태"});
		if(list!=null) {
			List<LinkedHashMap<String,String>> xlsList = XlsUtil.createList();
			for(int i=0;i<list.size();i++) {
				LinkedHashMap<String,String> rowMap = new LinkedHashMap<String,String>();
				// RevertStatCompleteVO row = (RevertStatCompleteVO)list.get(i);
				InptResultAnalyVO row = list.get(i);
				rowMap.put("inpt_mst_srno", row.getInpt_mst_srno());	// 마스터번호
				rowMap.put("actl_fx_refno", row.getActl_fx_refno());	// Ref.No
				rowMap.put("fx_refno_srno", row.getFx_refno_srno());	// 회차
				rowMap.put("inptBlGrpNo", row.getInptBlGrpNo());		// B/L그룹
				rowMap.put("itmNm", row.getItmNm());					// 항목명
				rowMap.put("extVal", row.getExtVal());					// 추출값
				rowMap.put("sugiVal", row.getSugiVal());				// 수기값
				rowMap.put("confNm", row.getConfNm());					// 확인
				rowMap.put("extTa", row.getExtTa());					// TA추출
				rowMap.put("extAicr", row.getExtAicr());				// AICR추출
				rowMap.put("aiInspeEno", row.getAiInspeEno());			// 심사자
				rowMap.put("lstDbChgDtm", row.getLstDbChgDtm());		// 변경시간
				rowMap.put("aiInptAcvtCd", row.getAiInptAcvtCd());		// 상태

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
	
	@GetMapping("/api/inpt/result/analy/xls/daily/performance")
	public ModelAndView listDailyPerformanceXls(SearchVO searchVO, ModelAndView mv) throws Exception {
		mv.setViewName("downView");					//파일다운로드뷰
		String xlsDownName = StringUtil.concat(new String[] {"일주요_성능지표_",DateUtil.getFormatDate("yyyyMMdd"),".xlsx"});
		searchVO.setRecordCountPerPage(-1);
		List<InptResultAnalyVO> list = inptResultAnalyService.selectDailyPerformList(searchVO);
		List<String[]> xlsListsTitle = XlsUtil.createListsTitle();
		List<List<LinkedHashMap<String,String>>> xlsLists = XlsUtil.createLists();
		xlsListsTitle.add(new String[] {"일자", "구분", "항목", "추출 항목수", "수기 입력수", "미추출 건수", "과탐 건수", "수기건 오류수", "추출 정확도"});
		if(list!=null) {
			List<LinkedHashMap<String,String>> xlsList = XlsUtil.createList();
			for(int i=0;i<list.size();i++) {
				LinkedHashMap<String,String> rowMap = new LinkedHashMap<String,String>();
				// RevertStatCompleteVO row = (RevertStatCompleteVO)list.get(i);
				InptResultAnalyVO row = list.get(i);
				rowMap.put("schDate", row.getSchDate());				// 일자			
				rowMap.put("bizName", row.getBizName());				// 구분
				rowMap.put("hName", row.gethName());					// 항목
				rowMap.put("chuchulCnt", row.getChuchulCnt());			// 추출 항목수
				rowMap.put("sugiCnt", row.getSugiCnt());				// 수기 입력수
				rowMap.put("nopChuchulCnt", row.getNopChuchulCnt());	// 미추출 건수
				rowMap.put("kwaTam", row.getKwaTam());					// 과탐 건수
				rowMap.put("sugiErrCnt", row.getSugiErrCnt());			// 수기건 오류수
				rowMap.put("extRt", row.getExtRt());					// 추출 정확도

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