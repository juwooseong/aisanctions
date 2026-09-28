package com.woori.ajs.api;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Properties;

import javax.annotation.Resource;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;
import org.springmodules.validation.commons.DefaultBeanValidator;

import com.woori.ajs.model.SearchVO;
import com.woori.ajs.model.StatAnalysisVO;
import com.woori.ajs.service.StatAnalysisService;

import egovframework.rte.fdl.property.EgovPropertyService;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import egovframework.ui.cmmn.ComUtil;
import egovframework.ui.cmmn.DateUtil;
import egovframework.ui.cmmn.FileUtil;
import egovframework.ui.cmmn.HttpUtil;
import egovframework.ui.cmmn.StringUtil;
import egovframework.ui.cmmn.XlsUtil;

@RestController
public class StatAnalysisApiController {

	/** statAnalysisService */
	@Resource(name = "statAnalysisService")
	private StatAnalysisService statAnalysisService;

	/** EgovPropertyService */
	@Resource(name = "propertiesService")
	protected EgovPropertyService propertiesService;

	/** Validator */
	@Resource(name = "beanValidator")
	protected DefaultBeanValidator beanValidator;

	@Resource(name = "systemFileProperties")
	protected Properties sysProp;
	
	@GetMapping("/api/stat/analysis")
	public HashMap<String,Object> list(SearchVO searchVO) throws Exception {
		HashMap<String,Object> map = new HashMap<String,Object>();
		
		HttpUtil.setResult(map, HttpUtil.HttpType.T200);
		//map.put("searchVO",searchVO);
		searchVO.setRecordCountPerPage(-1);
		PaginationInfo paginationInfo = ComUtil.setListPagingInfo(propertiesService, searchVO);
		
		List<StatAnalysisVO> list = statAnalysisService.selectList(searchVO);
	    int tnt = statAnalysisService.selectListTotCnt(searchVO);
		paginationInfo.setTotalRecordCount(tnt);
		map.put("resultList", list);
		map.put("paginationInfo",paginationInfo);
		return map;
	}
	
	
	@GetMapping("/api/stat/analysis/xls")
	public ModelAndView listXls(SearchVO searchVO, ModelAndView mv) throws Exception {
		mv.setViewName("downView");
		
		String xlsDownName = StringUtil.concat(new String[] {"성능분석_",DateUtil.getFormatDate("yyyyMMdd"),".xlsx"});
		
		searchVO.setRecordCountPerPage(-1);
		List<StatAnalysisVO> dataList = statAnalysisService.selectList(searchVO);
		// 액셀 데이터 만들기
		List<String[]> xlsListsTitle = XlsUtil.createListsTitle();
		List<List<LinkedHashMap<String,String>>> xlsLists = XlsUtil.createLists();
		
		// 리스트 1
		xlsListsTitle.add(new String[] {"일자", "총 업무건수", "자동건수", "수기등록", "저품질", "재추출"});
		
		if(dataList!=null) {
			List<LinkedHashMap<String,String>> xlsList = XlsUtil.createList();
			for(int i=0;i<dataList.size();i++) {
				LinkedHashMap<String,String> rowMap = new LinkedHashMap<String,String>();
				//StatAnalysisVO row = (StatAnalysisVO)dataList.get(i);
				StatAnalysisVO row = dataList.get(i);
				rowMap.put("Dt", row.getDay());
				rowMap.put("mas", row.getMas());
				rowMap.put("nomal", row.getNomal());
				rowMap.put("textExtr", row.getTextNonExtr());
				rowMap.put("aicr", row.getAicr());
				rowMap.put("ta", row.getTa());
				xlsList.add(rowMap);
			}
			xlsLists.add(xlsList);
		}
		
		String uploadPath = StringUtil.nvl(sysProp.getProperty("upload.path"));
		File xlsFile = XlsUtil.createXlsFile(uploadPath, xlsListsTitle, xlsLists);
		
		mv.addObject("downloadFile",xlsFile);
		mv.addObject("downloadFileName",xlsDownName);
		return mv;
	}
}
