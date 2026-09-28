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
import com.woori.ajs.model.StatCondVO;
import com.woori.ajs.service.StatCondService;

import egovframework.rte.fdl.property.EgovPropertyService;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import egovframework.ui.cmmn.ComUtil;
import egovframework.ui.cmmn.DateUtil;
import egovframework.ui.cmmn.HttpUtil;
import egovframework.ui.cmmn.StringUtil;
import egovframework.ui.cmmn.XlsUtil;

@RestController
public class StatCondApiController {

	private static final Logger LOGGER = LoggerFactory.getLogger(StatCondApiController.class);
	
	/** StatCondService */
	@Resource(name = "StatCondService")
	private StatCondService StatCondService;

	/** EgovPropertyService */
	@Resource(name = "propertiesService")
	protected EgovPropertyService propertiesService;

	/** Validator */
	@Resource(name = "beanValidator")
	protected DefaultBeanValidator beanValidator;

	@Resource(name = "systemFileProperties")
	protected Properties sysProp;

	@GetMapping("/api/stat/cond")
	public HashMap<String,Object> list(SearchVO searchVO) throws Exception {
		HashMap<String,Object> map = new HashMap<String,Object>();
		
		HttpUtil.setResult(map, HttpUtil.HttpType.T200);
		map.put("searchVO",searchVO);
	//	searchVO.setRecordCountPerPage(-1);
		PaginationInfo paginationInfo = ComUtil.setListPagingInfo(propertiesService, searchVO);
		
		
		if(!searchVO.getInptSanctionNo1().equals("")) {
			searchVO.setInptSanctionNum1(Integer.parseInt(searchVO.getInptSanctionNo1()));
		}
		if(!searchVO.getInptSanctionNo2().equals("")) {
			searchVO.setInptSanctionNum2(Integer.parseInt(searchVO.getInptSanctionNo2()));
		}
		if(!searchVO.getInptSanctionNo3().equals("")) {
			searchVO.setInptSanctionNum3(Integer.parseInt(searchVO.getInptSanctionNo3()));
		}
		if(!searchVO.getInptSanctionNo4().equals("")) {
			searchVO.setInptSanctionNum4(Integer.parseInt(searchVO.getInptSanctionNo4()));
		}
		if(!searchVO.getInptSanctionNo5().equals("")) {
			searchVO.setInptSanctionNum5(Integer.parseInt(searchVO.getInptSanctionNo5()));
		}
		
		List<StatCondVO> list = StatCondService.selectList(searchVO);
		int totCnt = StatCondService.selectListTotCnt(searchVO);
		
		paginationInfo.setTotalRecordCount(totCnt);
		map.put("resultList", list);
		map.put("paginationInfo", paginationInfo);
		return map;
	}
	
	@GetMapping("/api/stat/cond/xls")
	public ModelAndView listXls(SearchVO searchVO, ModelAndView mv) throws Exception {
		mv.setViewName("downView");
		
		String xlsDownName = StringUtil.concat(new String[] {"조건별통계_",DateUtil.getFormatDate("yyyyMMdd"),".xlsx"});
		
		//-1을 넘기면, 리스트 전체가 나옴, 페이징 안됨.
		searchVO.setRecordCountPerPage(-1);
		
		if(!searchVO.getInptSanctionNo1().equals("")) {
			searchVO.setInptSanctionNum1(Integer.parseInt(searchVO.getInptSanctionNo1()));
		}
		if(!searchVO.getInptSanctionNo2().equals("")) {
			searchVO.setInptSanctionNum2(Integer.parseInt(searchVO.getInptSanctionNo2()));
		}
		if(!searchVO.getInptSanctionNo3().equals("")) {
			searchVO.setInptSanctionNum3(Integer.parseInt(searchVO.getInptSanctionNo3()));
		}
		if(!searchVO.getInptSanctionNo4().equals("")) {
			searchVO.setInptSanctionNum4(Integer.parseInt(searchVO.getInptSanctionNo4()));
		}
		if(!searchVO.getInptSanctionNo5().equals("")) {
			searchVO.setInptSanctionNum5(Integer.parseInt(searchVO.getInptSanctionNo5()));
		}
		
		List<StatCondVO> dataList = StatCondService.selectList(searchVO);
		//엑셀 데이터 만들기.
		List<String[]> xlsListsTitle = XlsUtil.createListsTitle();
		List<List<LinkedHashMap<String,String>>> xlsLists = XlsUtil.createLists();
		//리스트1
		xlsListsTitle.add(new String[] {"업무","Ref.No","R/N 일련번호","고객번호","고객명","통화","영업점","수출상","수입상","선적항","하역항","원산지"});
		
		if(dataList!=null) {
			List<LinkedHashMap<String,String>> xlsList = XlsUtil.createList();
			for(int i=0;i<dataList.size();i++) {
				LinkedHashMap<String,String> rowMap = new LinkedHashMap<String,String>();
				
				StatCondVO row = null;
				if (dataList.get(i) instanceof StatCondVO) {
					row = (StatCondVO) dataList.get(i);
				}
				
				if (row != null) {
					
					rowMap.put("inptAtmcBizDsNm", row.getInptAtmcBizDsNm());
					rowMap.put("actlFxRefno", row.getActlFxRefno());
					rowMap.put("fxRefnoSrno", row.getFxRefnoSrno());
					rowMap.put("aiInptCsno", row.getAiInptCsno());
					rowMap.put("aiInptCusNm", row.getAiInptCusNm());
					rowMap.put("fcCuNm", row.getFcCuNm());
					rowMap.put("krbrNm", row.getKrbrNm());
					rowMap.put("exptNm", row.getExptNm());
					rowMap.put("imptNm", row.getImptNm());
					rowMap.put("portLoading", row.getPortLoading());
					rowMap.put("portDisch", row.getPortDisch());
					rowMap.put("orignNm", row.getOrignNm());
					xlsList.add(rowMap);
				}
				
			}
			xlsLists.add(xlsList);
		}
		
		//엑셀 다운로드 처리.
		String uploadPath = StringUtil.nvl(sysProp.getProperty("upload.path"));
		File xlsFile = XlsUtil.createXlsFile(uploadPath, xlsListsTitle, xlsLists);
		try {
			mv.addObject("downloadFile",xlsFile);
			mv.addObject("downloadFileName",xlsDownName);
		} catch (Exception e) {
			// TODO: handle exception
			LOGGER.error("Exception ::: " + e);
		}
	
		return mv;
	
	}
}