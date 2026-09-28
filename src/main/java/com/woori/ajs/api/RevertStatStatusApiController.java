package com.woori.ajs.api;

import java.io.File;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Properties;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;
import org.springmodules.validation.commons.DefaultBeanValidator;

import com.woori.ajs.model.SearchVO;
import com.woori.ajs.model.RevertStatAllVO;
import com.woori.ajs.model.RevertStatStatusVO;
import com.woori.ajs.service.RevertStatStatusService;

import egovframework.rte.fdl.property.EgovPropertyService;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import egovframework.ui.cmmn.ComUtil;
import egovframework.ui.cmmn.DateUtil;
import egovframework.ui.cmmn.FileUtil;
import egovframework.ui.cmmn.HttpUtil;
import egovframework.ui.cmmn.StringUtil;
import egovframework.ui.cmmn.XlsUtil;

@RestController
public class RevertStatStatusApiController {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(RevertStatCompleteApiController.class);
	
	/** revertStatStatusService */
	@Resource(name = "revertStatStatusService")
	private RevertStatStatusService revertStatStatusService;

	/** EgovPropertyService */
	@Resource(name = "propertiesService")
	protected EgovPropertyService propertiesService;

	/** Validator */
	@Resource(name = "beanValidator")
	protected DefaultBeanValidator beanValidator;

	@Resource(name = "systemFileProperties")
	protected Properties sysProp;
	
	@GetMapping("/api/revert/stat/status")
	public HashMap<String, Object> list(SearchVO searchVO) throws Exception {
		HashMap<String,Object> map = new HashMap<String,Object>();
		HttpUtil.setResult(map, HttpUtil.HttpType.T200);
		map.put("searchVO",searchVO);
		
		PaginationInfo paginationInfo = ComUtil.setListPagingInfo(propertiesService, searchVO);
		List<RevertStatStatusVO> list = revertStatStatusService.selectList(searchVO);
		map.put("resultList", list);
		int totCnt = revertStatStatusService.selectListTotCnt(searchVO);
		paginationInfo.setTotalRecordCount(totCnt);
		map.put("paginationInfo", paginationInfo);
		map.put("resultList", list);
		return map;
	}
	
	@GetMapping("/api/revert/stat/status/xls")
	public ModelAndView listXls(SearchVO searchVO, ModelAndView mv) throws Exception {
		mv.setViewName("downView");					//파일다운로드뷰
		String xlsDownName = StringUtil.concat(new String[] {"담당자별진행현황_",DateUtil.getFormatDate("yyyyMMdd"),".xlsx"});
		searchVO.setRecordCountPerPage(-1);
		List<RevertStatStatusVO> list = revertStatStatusService.selectList(searchVO);
		List<String[]> xlsListsTitle = XlsUtil.createListsTitle();
		List<List<LinkedHashMap<String,String>>> xlsLists = XlsUtil.createLists();
		xlsListsTitle.add(new String[] {"생성일","업무","Ref.No","주의","프로세스","액티비티","고객번호","고객명","통화","금액","진행구분","담당자"});
		if(list!=null) {
			List<LinkedHashMap<String,String>> xlsList = XlsUtil.createList();
			for(int i=0;i<list.size();i++) {
				LinkedHashMap<String,String> rowMap = new LinkedHashMap<String,String>();

				RevertStatStatusVO row = list.get(i);
				rowMap.put("inptRcpDt", row.getInptRcpDt());									// 생성일
				rowMap.put("inptAtmcBizNm", row.getInptAtmcBizNm()); 					// 업무
				rowMap.put("actlFxRefno", row.getActlFxRefno());
				
				rowMap.put("wrrInfo", row.getWarrning());								// 접수자ID
				rowMap.put("inptPrcsNm", row.getInptPrcsNm());							// 접수자명
				rowMap.put("inptAtvtNm", row.getInptAtvtNm());		// 영업점명
				rowMap.put("aiInptCusNo", row.getAiInptCusNo());	// 스캔자명
				
				
				rowMap.put("aiInptCusNm", row.getAiInptCusNm()); 						// 고객명
				rowMap.put("fcCuNm", row.getFcCuNm()); 						// 금액
				rowMap.put("aiInptBuyAm", row.getAiInptBuyAm()); 						// 금액
			
				rowMap.put("jingheng", row.getJingheng()); 						// 금액
				rowMap.put("inptBizAlctCrpeFnm", row.getInptBizAlctCrpeFnm()); 						// 금액
				
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