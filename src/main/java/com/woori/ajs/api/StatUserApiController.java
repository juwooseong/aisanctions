package com.woori.ajs.api;

import java.util.HashMap;
import java.util.List;
import java.util.Properties;

import javax.annotation.Resource;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springmodules.validation.commons.DefaultBeanValidator;

import com.woori.ajs.model.SearchVO;
import com.woori.ajs.model.StatUserVO;
import com.woori.ajs.service.StatUserService;

import egovframework.rte.fdl.property.EgovPropertyService;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import egovframework.ui.cmmn.ComUtil;
import egovframework.ui.cmmn.HttpUtil;

@RestController
public class StatUserApiController {

	/** StatUserService */
	@Resource(name = "StatUserService")
	private StatUserService StatUserService;

	/** EgovPropertyService */
	@Resource(name = "propertiesService")
	protected EgovPropertyService propertiesService;

	/** Validator */
	@Resource(name = "beanValidator")
	protected DefaultBeanValidator beanValidator;

	@Resource(name = "systemFileProperties")
	protected Properties sysProp;

	@GetMapping("/api/stat/user/chart")
	public HashMap<String,Object> chart1(SearchVO searchVO) throws Exception {
		HashMap<String,Object> map = new HashMap<String,Object>();
		
		HttpUtil.setResult(map, HttpUtil.HttpType.T200);
		
		String inptAtmcBizDscd = searchVO.getInptAtmcBizDscd();

		//차트 : 거래국가(상대국)
		//국가별로 거래한 건수와 비율을 파이차트로 출력 (상위10건)
		if ("1".equals(inptAtmcBizDscd)) {
			searchVO.setInptSanctionNo("18");			//심사제재항목코드(그룹코드:200)
		} else {
			searchVO.setInptSanctionNo("22");			//심사제재항목코드(그룹코드:200)
		}
		searchVO.setRecordCountPerPage(10);
		List<StatUserVO> list1 = StatUserService.selectChartList(searchVO);
		
		//차트 : 거래상대방
		//업체별로 거래한 건수와 금액을 가로막대 차트로 출력 (상위10건)
		//X축 : 건/금액, Y축 : 업체
		if ("1".equals(inptAtmcBizDscd)) {
			searchVO.setInptSanctionNo("15");			//심사제재항목코드(그룹코드:200)
		} else {
			searchVO.setInptSanctionNo("19");			//심사제재항목코드(그룹코드:200)
		}
		searchVO.setRecordCountPerPage(10);
		List<StatUserVO> list2 = StatUserService.selectChartList(searchVO);
		
		//차트 : 선적항
		//선적항별로 거래한 건수를 세로 막대차트로 출력. (상위10건)
		//X축 : 건, Y축 : 선적항의 국가코드
		searchVO.setInptSanctionNo("57");			//심사제재항목코드(그룹코드:200)
		searchVO.setRecordCountPerPage(10);
		List<StatUserVO> list3 = StatUserService.selectChartList(searchVO);

		//차트 : 하역항
		//하역항별로 거래한 건수를 세로 막대차트로 출력. (상위10건)
		//X축 : 건, Y축 : 하역항의 국가코드
		searchVO.setInptSanctionNo("60");			//심사제재항목코드(그룹코드:200)
		searchVO.setRecordCountPerPage(10);
		List<StatUserVO> list4 = StatUserService.selectChartList(searchVO);
		
		//차트 : 물품
		//거래된 물품의 건수를 가로 막대차트로 출력. (상위 5건)
		//X축 : 건, Y축 : 물품
		searchVO.setInptSanctionNo("53");			//심사제재항목코드(그룹코드:200)
		searchVO.setRecordCountPerPage(5);
		List<StatUserVO> list5 = StatUserService.selectChartList(searchVO);
		
		//결과값
		map.put("resultList1", list1);
		map.put("resultList2", list2);
		map.put("resultList3", list3);
		map.put("resultList4", list4);
		map.put("resultList5", list5);
		
		return map;
	}

	/**
	 * 거래규모 리스트 데이터 : 거래의 건과 금액을 월별로
	 */
	@GetMapping("/api/stat/user/list1")
	public HashMap<String,Object> list(SearchVO searchVO) throws Exception {
		HashMap<String,Object> map = new HashMap<String,Object>();
		
		HttpUtil.setResult(map, HttpUtil.HttpType.T200);
		
		PaginationInfo paginationInfo = ComUtil.setListPagingInfo(propertiesService, searchVO);
		
		List<StatUserVO> list = StatUserService.select1List(searchVO);
		
		if (list == null) {
			paginationInfo.setTotalRecordCount(0);
		} else {
			paginationInfo.setTotalRecordCount(list.size());
		}
		
		map.put("resultList", list);
		map.put("paginationInfo",paginationInfo);
		return map;
	}

	/**
	 * Pending/Block 이력 리스트 데이터
	 * 해당 고객번호의 심사내역 중 Block 과 Pending 이력이 있는 심사목록을 출력
	 */
	@GetMapping("/api/stat/user/list2")
	public HashMap<String,Object> list2(SearchVO searchVO) throws Exception {
		HashMap<String,Object> map = new HashMap<String,Object>();
		
		HttpUtil.setResult(map, HttpUtil.HttpType.T200);
		
		PaginationInfo paginationInfo = ComUtil.setListPagingInfo(propertiesService, searchVO);
		
		List<StatUserVO> list = StatUserService.select2List(searchVO);
		
		if (list == null) {
			paginationInfo.setTotalRecordCount(0);
		} else {
			paginationInfo.setTotalRecordCount(list.size());
		}
		
		map.put("resultList", list);
		map.put("paginationInfo",paginationInfo);
		return map;
	}
	
}