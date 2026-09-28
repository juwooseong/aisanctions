package com.woori.ajs.api;

import java.util.HashMap;
import java.util.List;
import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springmodules.validation.commons.DefaultBeanValidator;

import com.woori.ajs.model.RevertStatusVO;
import com.woori.ajs.model.SearchVO;
import com.woori.ajs.service.RevertStatusService;

import egovframework.rte.fdl.property.EgovPropertyService;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import egovframework.ui.cmmn.ComUtil;
import egovframework.ui.cmmn.HttpUtil;
import egovframework.ui.util.LoginUtils;

@RestController
public class RevertStatusApiController {
	
	/** revertStatusService */
	@Resource(name = "revertStatusService")
	private RevertStatusService revertStatusService;

	/** EgovPropertyService */
	@Resource(name = "propertiesService")
	protected EgovPropertyService propertiesService;

	/** Validator */
	@Resource(name = "beanValidator")
	protected DefaultBeanValidator beanValidator;

	@Resource(name = "systemFileProperties")
	protected Properties sysProp;
	
	@GetMapping("/api/revert/status")
	public HashMap<String,Object> list(SearchVO searchVO, HttpServletRequest request) throws Exception {
		HashMap<String,Object> map = new HashMap<String,Object>();
		
		HttpUtil.setResult(map, HttpUtil.HttpType.T200);
		
		String userId = LoginUtils.getLoginInfo(request).getId();
		
		searchVO.setUserId(userId);
		PaginationInfo paginationInfo = ComUtil.setListPagingInfo(propertiesService, searchVO);
		
		List<RevertStatusVO> list = revertStatusService.selectList(searchVO);
		int totCnt = revertStatusService.selectListTotCnt(searchVO);
		paginationInfo.setTotalRecordCount(totCnt);
		
		map.put("searchVO",searchVO);
		map.put("paginationInfo",paginationInfo);
		map.put("resultList",list);
		
		return map;
	}
}
