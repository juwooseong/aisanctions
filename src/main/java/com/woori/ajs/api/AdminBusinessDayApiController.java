package com.woori.ajs.api;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springmodules.validation.commons.DefaultBeanValidator;

import com.woori.ajs.model.AdminBusinessDayVO;
import com.woori.ajs.model.AdminLogProgramVO;
import com.woori.ajs.model.CodeGrpVO;
import com.woori.ajs.model.CodeVO;
import com.woori.ajs.model.LoginVO;
import com.woori.ajs.model.RevertUngeneratedVO;
import com.woori.ajs.model.SearchVO;
import com.woori.ajs.service.AdminBusinessDayService;
import com.woori.ajs.service.AdminCodeService;
import com.woori.ajs.service.AdminLogProgramService;

import egovframework.rte.fdl.property.EgovPropertyService;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import egovframework.ui.cmmn.ComUtil;
import egovframework.ui.cmmn.HttpUtil;
import egovframework.ui.cmmn.StringUtil;
import egovframework.ui.cmmn.XssUtil;
import egovframework.ui.util.LoginUtils;

@RestController
public class AdminBusinessDayApiController {

	@Resource(name = "adminLogProgramService")
	private AdminLogProgramService adminLogProgramService;
	
	@Resource(name = "adminBusinessDayService")
	private AdminBusinessDayService adminBusinessDayService;
	
	/** EgovPropertyService */
	@Resource(name = "propertiesService")
	protected EgovPropertyService propertiesService;

	/** Validator */
	@Resource(name = "beanValidator")
	protected DefaultBeanValidator beanValidator;

	@Resource(name = "systemFileProperties")
	protected Properties sysProp;
	
	/**
	 * 영업일 목록
	 */
	@GetMapping("/api/admin/businessday/list")
	public HashMap<String,Object> grpList(SearchVO searchVO) throws Exception {
		HashMap<String,Object> map = new HashMap<String,Object>();
		
		HttpUtil.setResult(map, HttpUtil.HttpType.T200);
		
		PaginationInfo paginationInfo = ComUtil.setListPagingInfo(propertiesService, searchVO);
		searchVO.setRecordCountPerPage(-1);
		
		List<AdminBusinessDayVO> list = adminBusinessDayService.selectBusinessDayList(searchVO);
		
		int totCnt = list==null ? 0 : list.size();
		paginationInfo.setTotalRecordCount(totCnt);
		
		map.put("resultList", list);
		map.put("paginationInfo", paginationInfo);
		
		return map;
	}
	
	@PostMapping("/api/admin/businessday/save")
	public HashMap<String, Object> save(HttpServletRequest request, AdminBusinessDayVO adminBusinessDayVO, AdminLogProgramVO adminLogProgramVO) throws Exception{
		HashMap<String,Object> map = new HashMap<String,Object>();
		
		LoginVO userInfo = LoginUtils.getLoginInfo(request);

		String[] basDts = adminBusinessDayVO.getBasDts();
		String[] hldyDscds = adminBusinessDayVO.getHldyDscds();
		String[] hldyTxts = adminBusinessDayVO.getHldyTxts();
		String[] wkdCds = adminBusinessDayVO.getWkdCds();
		
		String trnLogSrno = null;
		SearchVO searchVO = new SearchVO();
		trnLogSrno = adminLogProgramService.logProgramInsert(request, adminLogProgramVO, searchVO);

		
		for(int index = 0 ; index < basDts.length ; index++) {
			AdminBusinessDayVO param = new AdminBusinessDayVO();
			param.setLstDbChgId(userInfo.getEno());
			param.setBasDt(basDts[index]);
			param.setWkdCd(wkdCds[index]);
			param.setHldyDscd(hldyDscds[index]);
			param.setHldyTxt(hldyTxts[index]);
			param.setTrnLogSrno(trnLogSrno);
			adminBusinessDayService.updateBusinessDay(param);
		}
		
		map.put("rst", "success");
		return map;
	}
	
	@PostMapping("/api/admin/businessday/delete")
	public HashMap<String, Object> delete(HttpServletRequest request) throws Exception{
		HashMap<String,Object> map = new HashMap<String,Object>();
		
		LoginVO userInfo = LoginUtils.getLoginInfo(request);
		
		map.put("rst", "success");
		return map;
	}
	
}