package com.woori.ajs.api;

import java.util.HashMap;
import java.util.List;
import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springmodules.validation.commons.DefaultBeanValidator;

import com.woori.ajs.model.SearchVO;
import com.woori.ajs.model.AppStatusVO;
import com.woori.ajs.model.LoginVO;
import com.woori.ajs.service.AppStatusService;

import egovframework.rte.fdl.property.EgovPropertyService;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import egovframework.ui.cmmn.ComUtil;
import egovframework.ui.cmmn.HttpUtil;
import egovframework.ui.util.LoginUtils;

@RestController
public class AppStatusApiController {

	/** appStatusService */
	@Resource(name = "appStatusService")
	private AppStatusService appStatusService;
	
	/** EgovPropertyService */
	@Resource(name = "propertiesService")
	protected EgovPropertyService propertiesService;

	/** Validator */
	@Resource(name = "beanValidator")
	protected DefaultBeanValidator beanValidator;

	@Resource(name = "systemFileProperties")
	protected Properties sysProp;

	@GetMapping("/api/app/status")
	public HashMap<String,Object> list(HttpServletRequest request, SearchVO searchVO) throws Exception {
		HashMap<String,Object> map = new HashMap<String,Object>();
		LoginVO loginInfo = LoginUtils.getLoginInfo(request);

		HttpUtil.setResult(map, HttpUtil.HttpType.T200);

		searchVO.setUserId(loginInfo.getId());

		map.put("searchVO",searchVO);
		
		PaginationInfo paginationInfo = ComUtil.setListPagingInfo(propertiesService, searchVO);
		
		List<AppStatusVO> list = appStatusService.selectList(searchVO);
		map.put("resultList", list);

		int totCnt = appStatusService.selectListTotCnt(searchVO);
		
		paginationInfo.setTotalRecordCount(totCnt);
		map.put("paginationInfo", paginationInfo);
		
		return map;
	}

	/**
	 * 체크 심사항목들 홀딩처리
	 * 1) CSPD001TM(심사업무마스터 테이블)의 AI_INSP_ATVT_CD (액티비티 컬럼)을 '150' holding 상태로 업데이트
	 * 2) CSPD008TH(상태변경이력 테이블)에 상태변경 이력 입력
	 */
	@PostMapping("/api/app/status/holding")
	public HashMap<String,Object> holding(HttpServletRequest request, SearchVO searchVO) throws Exception {
		HashMap<String,Object> map = new HashMap<String,Object>();
		LoginVO loginInfo = LoginUtils.getLoginInfo(request);
		
		HttpUtil.setResult(map, HttpUtil.HttpType.T200);
		
		//홀딩처리할 심사업무번호 배열 유효건수 1건이상인지 확인처리.
		if(searchVO.getIds()==null || searchVO.getIds().length==0) {
			HttpUtil.setResult(map, HttpUtil.HttpType.T500);
			HttpUtil.setExResult(map, "-1", "정보가 부족합니다.");
			return map;
		}
		
		//선택 심사업무들 홀딩처리.
		searchVO.setUserId(loginInfo.getId());
		appStatusService.updateTaskAtvtHolding(searchVO);
		
		return map;
	}

}