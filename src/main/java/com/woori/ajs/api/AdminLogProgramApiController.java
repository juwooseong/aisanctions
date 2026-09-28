package com.woori.ajs.api;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import javax.annotation.Resource;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springmodules.validation.commons.DefaultBeanValidator;

import com.woori.ajs.model.SearchVO;
import com.woori.ajs.model.AdminLogProgramVO;
import com.woori.ajs.service.AdminLogProgramService;

import egovframework.rte.fdl.property.EgovPropertyService;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import egovframework.ui.cmmn.ComUtil;
import egovframework.ui.cmmn.HttpUtil;

@RestController
public class AdminLogProgramApiController {

	/** EgovSampleService */
	@Resource(name = "adminLogProgramService")
	private AdminLogProgramService adminLogProgramService;

	/** EgovPropertyService */
	@Resource(name = "propertiesService")
	protected EgovPropertyService propertiesService;

	/** Validator */
	@Resource(name = "beanValidator")
	protected DefaultBeanValidator beanValidator;

	@Resource(name = "systemFileProperties")
	protected Properties sysProp;

	@GetMapping("/api/admin/log/program")
	public HashMap<String,Object> list(SearchVO searchVO) throws Exception {
		HashMap<String,Object> map = new HashMap<String,Object>();
		
		HttpUtil.setResult(map, HttpUtil.HttpType.T200);
		
		map.put("searchVO",searchVO);
		
		PaginationInfo paginationInfo = ComUtil.setListPagingInfo(propertiesService, searchVO);
		//searchVO.setRecordCountPerPage(-1);
		
		List<AdminLogProgramVO> list = adminLogProgramService.selectList(searchVO);
		map.put("resultList", list);

		int totCnt = adminLogProgramService.selectListTotCnt(searchVO);
		//int totCnt = list==null ? 0 : list.size();
		
		paginationInfo.setTotalRecordCount(totCnt);
		map.put("paginationInfo", paginationInfo);
		
		return map;
	}
	
	@GetMapping("/api/custom/query/test")
	public HashMap<String,Object> queryTest(SearchVO searchVO) throws Exception {
		HashMap<String,Object> map = new HashMap<String,Object>();
		
		System.out.println("request of /api/custom/query/test run");
		
		HttpUtil.setResult(map, HttpUtil.HttpType.T200);
		
		//searchVO.setRecordCountPerPage(-1);
		//String queryTest = "SELECT * FROM CSPD001TM, CSPD112TI WHERE ROWNUM < 20";
		//String queryTest = "SELECT COUNT(*), MAX(INPT_ATMC_BIZ_DSCD) FROM CSPD001TM, CSPD112TI WHERE ROWNUM < 20";
		String queryTest = "SELECT AI_INPT_ALL_AICR_RST_TXT FROM CSPD002TG\r\n" + 
				"WHERE INPT_MST_SRNO = '4405'";
		
		SearchVO param = new SearchVO();
		param.setQueryTestParam(queryTest);
		
		List<Map<String, Object>> resultList = adminLogProgramService.customQueryTest(param);
		
		System.out.println(resultList);
		
		System.out.println("========키값========");
		
		List<String> columnList = new ArrayList<String>();
		
		for(String keyStr : resultList.get(0).keySet()) {
			System.out.println("키값 : " + keyStr);
			System.out.println("키에 따른 값");
			System.out.println(String.valueOf(resultList.get(0).get(keyStr)));
			columnList.add(keyStr);
		}
		
		System.out.println("columnList size : " + columnList.size());
		for(String value : columnList) {
			System.out.println(value);
		}
		
		
		map.put("columnList", columnList);
		map.put("resultList", resultList);
		
		System.out.println("========================map========================");
		System.out.println(map);
		
		return map;
	}

}