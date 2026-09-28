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
import com.woori.ajs.model.StatItemVO;
import com.woori.ajs.service.StatItemService;

import egovframework.rte.fdl.property.EgovPropertyService;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import egovframework.ui.cmmn.ComUtil;
import egovframework.ui.cmmn.FileUtil;
import egovframework.ui.cmmn.HttpUtil;
import egovframework.ui.cmmn.StringUtil;
import egovframework.ui.cmmn.XlsUtil;

@RestController
public class StatItemApiController {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(StatItemApiController.class);

	/** StatItemService */
	@Resource(name = "StatItemService")
	private StatItemService StatItemService;

	/** EgovPropertyService */
	@Resource(name = "propertiesService")
	protected EgovPropertyService propertiesService;

	/** Validator */
	@Resource(name = "beanValidator")
	protected DefaultBeanValidator beanValidator;

	@Resource(name = "systemFileProperties")
	protected Properties sysProp;

	@GetMapping("/api/stat/item")
	public HashMap<String,Object> list(SearchVO searchVO) throws Exception {
		HashMap<String,Object> map = new HashMap<String,Object>();
		
		HttpUtil.setResult(map, HttpUtil.HttpType.T200);
		//map.put("searchVO",searchVO);
		searchVO.setRecordCountPerPage(-1);
		PaginationInfo paginationInfo = ComUtil.setListPagingInfo(propertiesService, searchVO);
		
		List<StatItemVO> list = StatItemService.selectList(searchVO);
		
		//list = list.subList(0, 20);
		
		paginationInfo.setTotalRecordCount(list.size());
		
		
		map.put("resultList", list);
		map.put("paginationInfo",paginationInfo);
		
		return map;
	}
	
	@GetMapping("/api/stat/item/xls")
	public ModelAndView listXls(SearchVO searchVO, ModelAndView mv) throws Exception {
		//mv.setViewName("downView");
		//-1을 넘기면, 리스트 전체가 나옴, 페이징 안됨.
		searchVO.setRecordCountPerPage(-1);
		List<StatItemVO> dataList = StatItemService.selectList(searchVO);
		//엑셀 데이터 만들기.
		List<String[]> xlsListsTitle = XlsUtil.createListsTitle();
		List<List<LinkedHashMap<String,String>>> xlsLists = XlsUtil.createLists();
		//리스트1
		xlsListsTitle.add(new String[] {"일자","정상건수","문서분류","문자인식","Text 미추출","단어보정(AICR)","단어보정(TA)","제인식 프로세스"});
		
		if(dataList!=null) {
			List<LinkedHashMap<String,String>> xlsList = XlsUtil.createList();
			for(int i=0;i<dataList.size();i++) {
				LinkedHashMap<String,String> rowMap = new LinkedHashMap<String,String>();
				//StatItemVO row = (StatItemVO)dataList.get(i);
				StatItemVO row = dataList.get(i);
				rowMap.put("day", row.getDay());
				rowMap.put("nomal", row.getNomal());
				rowMap.put("classify", row.getClassify());
				rowMap.put("cognition", row.getCognition());
				rowMap.put("noextrac", row.getNoextrac());
				rowMap.put("aicr", row.getAicr());
				rowMap.put("ta", row.getTa());
				rowMap.put("reprocess", row.getReprocess());
				xlsList.add(rowMap);
			}
			xlsLists.add(xlsList);
		}
		
		//엑셀 다운로드 처리.
		String uploadPath = StringUtil.nvl(sysProp.getProperty("upload.path"));
		File xlsFile = XlsUtil.createXlsFile(uploadPath, xlsListsTitle, xlsLists);
		try {
			FileUtil.setFileDown(mv, xlsFile, "본인작업TODO리스트2.xlsx");
		} catch (Exception e) {
			LOGGER.error("Exception ::: " + e);
		}
		FileUtil.setFileDown(mv, xlsFile, "본인작업TODO리스트2.xlsx");
		return mv;
	}

	/**
	 * 기간별 추이 통계
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
	@GetMapping("/api/stat/item/move")
	public HashMap<String,Object> moveList(SearchVO searchVO) throws Exception {
		HashMap<String,Object> map = new HashMap<String,Object>();
		
		HttpUtil.setResult(map, HttpUtil.HttpType.T200);
		//map.put("searchVO",searchVO);
		searchVO.setRecordCountPerPage(-1);
		PaginationInfo paginationInfo = ComUtil.setListPagingInfo(propertiesService, searchVO);
		
		List<StatItemVO> list = StatItemService.selectList(searchVO);
		
		paginationInfo.setTotalRecordCount(list.size());
		map.put("resultList", list);
		map.put("paginationInfo",paginationInfo);
		return map;
	}
	
}