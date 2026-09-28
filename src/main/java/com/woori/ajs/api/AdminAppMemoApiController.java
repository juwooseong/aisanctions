package com.woori.ajs.api;

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

import com.woori.ajs.model.SearchVO;
import com.woori.ajs.model.AdminAppMemoVO;
import com.woori.ajs.model.AdminLogProgramVO;
import com.woori.ajs.model.LoginVO;
import com.woori.ajs.service.AdminAppMemoService;
import com.woori.ajs.service.AdminLogProgramService;

import egovframework.rte.fdl.property.EgovPropertyService;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import egovframework.ui.cmmn.ComUtil;
import egovframework.ui.cmmn.HttpUtil;
import egovframework.ui.cmmn.StringUtil;
import egovframework.ui.cmmn.XssUtil;
import egovframework.ui.util.LoginUtils;

@RestController
public class AdminAppMemoApiController {

	@Resource(name = "adminLogProgramService")
	private AdminLogProgramService adminLogProgramService;
	
	/** AdminAppMemoService */
	@Resource(name = "AdminAppMemoService")
	private AdminAppMemoService AdminAppMemoService;

	/** EgovPropertyService */
	@Resource(name = "propertiesService")
	protected EgovPropertyService propertiesService;

	/** Validator */
	@Resource(name = "beanValidator")
	protected DefaultBeanValidator beanValidator;

	@Resource(name = "systemFileProperties")
	protected Properties sysProp;

	@GetMapping("/api/admin/app/memo")
	public HashMap<String,Object> list(SearchVO searchVO) throws Exception {
		HashMap<String,Object> map = new HashMap<String,Object>();
		
		HttpUtil.setResult(map, HttpUtil.HttpType.T200);
		
		map.put("searchVO",searchVO);
		
		PaginationInfo paginationInfo = ComUtil.setListPagingInfo(propertiesService, searchVO);
		searchVO.setRecordCountPerPage(-1);
		
		List<AdminAppMemoVO> list = AdminAppMemoService.selectList(searchVO);
		map.put("resultList", list);

		int totCnt = list==null ? 0 : list.size();
		
		paginationInfo.setTotalRecordCount(totCnt);
		map.put("paginationInfo", paginationInfo);
		
		return map;
	}

	@PostMapping("/api/admin/app/memo/save")
	public HashMap<String,Object> insertMemo(HttpServletRequest request, AdminAppMemoVO vo, AdminLogProgramVO adminLogProgramVO) throws Exception {
		HashMap<String,Object> map = new HashMap<String,Object>();
		LoginVO loginInfo = LoginUtils.getLoginInfo(request);
		
		HttpUtil.setResult(map, HttpUtil.HttpType.T200);
		
		String trnLogSrno = null;
		SearchVO searchVO = new SearchVO();
		trnLogSrno = adminLogProgramService.logProgramInsert(request, adminLogProgramVO, searchVO);
		
		vo.setTrnLogSrno(trnLogSrno);
		
		vo.setLstDbChgId(loginInfo.getId());
		vo.setAiInptAppvOpiTxt(vo.getAiInptAppvOpiTxt());
	//	vo.setAiInptAppvOpiTxt(XssUtil.escapeHtml(vo.getAiInptAppvOpiTxt()));
		AdminAppMemoService.insertMemo(vo);
		
		return map;
	}

	@PostMapping("/api/admin/app/memo/delete/{id}")
	public HashMap<String,Object> deleteMemo(@PathVariable String id, AdminAppMemoVO vo) throws Exception {
		HashMap<String,Object> map = new HashMap<String,Object>();
		
		HttpUtil.setResult(map, HttpUtil.HttpType.T200);
		
		if(StringUtil.isEmpty(id)) {
			HttpUtil.setResult(map, HttpUtil.HttpType.T500);
			HttpUtil.setExResult(map, "-1", "정보가 부족합니다.");
			return map;
		}
		
		vo.setAiInptAppvOpiSrno(id);
		
		AdminAppMemoService.deleteMemo(vo);
		
		return map;
	}
	
}