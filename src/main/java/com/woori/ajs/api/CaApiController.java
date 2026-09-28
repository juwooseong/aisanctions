package com.woori.ajs.api;

import java.util.HashMap;
import java.util.Map;
import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springmodules.validation.commons.DefaultBeanValidator;

import com.woori.ajs.model.SearchVO;
import com.woori.ajs.service.CaService;

import egovframework.rte.fdl.property.EgovPropertyService;
import egovframework.ui.cmmn.CastUtil;
import egovframework.ui.cmmn.HttpUtil;
import egovframework.ui.cmmn.StringUtil;

@RestController
public class CaApiController {

	/** 심사상세 공통 서비스 **/
	@Resource(name = "caService")
	private CaService service;

	/** EgovPropertyService */
	@Resource(name = "propertiesService")
	protected EgovPropertyService propertiesService;

	/** Validator */
	@Resource(name = "beanValidator")
	protected DefaultBeanValidator beanValidator;

	@Resource(name = "systemFileProperties")
	protected Properties sysProp;
	
	@RequestMapping("/api/sancRst")
	public Map<String, Object> sancRst(@RequestBody Map<String, Object> param) throws Exception {
		HashMap<String,Object> map = new HashMap<String,Object>();
		HttpUtil.setResult(map, HttpUtil.HttpType.T200);
		
		int inptMstSrno = Integer.parseInt(StringUtil.nvl(param.get("inptMstSrno")));
		
		SearchVO searchVO = new SearchVO();
		searchVO.setInptMstSrno(inptMstSrno);
		
		// 항목심사 결과
		map.put("sanctionRst", service.selectSancRst(searchVO));
		
		return map;
	}
	
	@RequestMapping("/api/sancAnswer")
	public Map<String, Object> sancAnswer(@RequestBody Map<String, Object> param) throws Exception {
		HashMap<String,Object> map = new HashMap<String,Object>();
		HttpUtil.setResult(map, HttpUtil.HttpType.T200);
		
		int inptMstSrno = Integer.parseInt(StringUtil.nvl(param.get("inptMstSrno")));
		
		
		SearchVO searchVO = new SearchVO();
		searchVO.setInptMstSrno(inptMstSrno);
		
		// 항목심사 결과
		map.put("sanctionRst", service.selectSancAnswer(searchVO));
		
		return map;
	}
}
