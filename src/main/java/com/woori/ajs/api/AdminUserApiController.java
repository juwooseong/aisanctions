package com.woori.ajs.api;

import java.lang.reflect.Parameter;
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

import com.woori.ajs.model.AdminLogProgramVO;
import com.woori.ajs.model.AdminUserVO;
import com.woori.ajs.model.LoginVO;
import com.woori.ajs.model.SearchVO;
import com.woori.ajs.service.AdminLogProgramService;
import com.woori.ajs.service.AdminUserService;
import com.woori.ajs.service.CommonCodeService;

import egovframework.rte.fdl.property.EgovPropertyService;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import egovframework.ui.cmmn.ComUtil;
import egovframework.ui.cmmn.HttpUtil;
import egovframework.ui.util.LoginUtils;

@RestController
public class AdminUserApiController {

	@Resource(name = "adminLogProgramService")
	private AdminLogProgramService adminLogProgramService;
		
	/** 공통 서비스 **/
	@Resource(name = "commonCodeService")
	private CommonCodeService commonCodeService;
	
	/** adminUserService */
	@Resource(name = "adminUserService")
	private AdminUserService adminUserService;

	/** EgovPropertyService */
	@Resource(name = "propertiesService")
	protected EgovPropertyService propertiesService;

	/** Validator */
	@Resource(name = "beanValidator")
	protected DefaultBeanValidator beanValidator;

	@Resource(name = "systemFileProperties")
	protected Properties sysProp;

	
	
	@GetMapping("/api/admin/user")
	public HashMap<String,Object> list(SearchVO searchVO) throws Exception {
		HashMap<String,Object> map = new HashMap<String,Object>();
		
		HttpUtil.setResult(map, HttpUtil.HttpType.T200);
		map.put("searchVO",searchVO);
		PaginationInfo paginationInfo = ComUtil.setListPagingInfo(propertiesService, searchVO);

		List<AdminUserVO> list = adminUserService.selectList(searchVO);
		map.put("resultList", list);
		
		int totCnt = adminUserService.selectListTotCnt(searchVO);
		//int totCnt = list==null ? 0 : list.size();
		
		paginationInfo.setTotalRecordCount(totCnt);
		map.put("paginationInfo", paginationInfo);
		
		return map;
	}
	

	
	@PostMapping("/api/admin/user/update")
	public HashMap<String,Object> userUpdate(HttpServletRequest request, AdminUserVO vo, AdminLogProgramVO adminLogProgramVO) throws Exception {
		HashMap<String,Object> map = new HashMap<String,Object>();		
		HttpUtil.setResult(map, HttpUtil.HttpType.T200);
		LoginVO loginInfo = LoginUtils.getLoginInfo(request);

		String trnLogSrno = null;
		SearchVO searchVO = new SearchVO();
		trnLogSrno = adminLogProgramService.logProgramInsert(request, adminLogProgramVO, searchVO);
		
		vo.setLstDbChgId(loginInfo.getId());
		vo.setTrnLogSrno(trnLogSrno);
		if(vo.getAiInptUserAutCd() == null) {
			vo.setAiInptUserAutCd("N");
		}
		try {
			adminUserService.userUpdate(vo);
		} catch (Exception e) {
			HttpUtil.setResult(map, HttpUtil.HttpType.T500);
			HttpUtil.setExResult(map, "-1", e.getMessage());
		}
		
		return map;
	}

	@PostMapping("/api/admin/user/insert")
	public HashMap<String,Object> userInsert(HttpServletRequest request, AdminUserVO vo, AdminLogProgramVO adminLogProgramVO) throws Exception {
		HashMap<String,Object> map = new HashMap<String,Object>();		
		HttpUtil.setResult(map, HttpUtil.HttpType.T200);
		LoginVO loginInfo = LoginUtils.getLoginInfo(request);

		String trnLogSrno = null;
		SearchVO searchVO = new SearchVO();
		searchVO.setAiInptUserEno(vo.getAiInptUserEno());
		List<AdminUserVO> list = adminUserService.selectOne(searchVO);
		if(list.size() > 0) {
			map.put("result", false);
			
		}else {
		
			trnLogSrno = adminLogProgramService.logProgramInsert(request, adminLogProgramVO, searchVO);
			
			vo.setLstDbChgId(loginInfo.getId());
			vo.setTrnLogSrno(trnLogSrno);
	
			try {
				adminUserService.userInsert(vo);
				map.put("result", true);
			} catch (Exception e) {
				HttpUtil.setResult(map, HttpUtil.HttpType.T500);
				HttpUtil.setExResult(map, "-1", e.getMessage());
				map.put("result", false);
			}
		}
		return map;
	}
	
	@PostMapping("/api/admin/user/delete/{id}")
	public HashMap<String,Object> userDelete(HttpServletRequest request, AdminUserVO vo, @PathVariable String id, AdminLogProgramVO adminLogProgramVO) throws Exception {
		HashMap<String,Object> map = new HashMap<String,Object>();		
		HttpUtil.setResult(map, HttpUtil.HttpType.T200);
		LoginVO loginInfo = LoginUtils.getLoginInfo(request);
		String parmeter = "id=";
		parmeter = parmeter.concat(id);
	
		adminLogProgramVO.setAiInptCnctScrnNo("7010");
		adminLogProgramVO.setAiInptCnctFldCd("");
		adminLogProgramVO.setAiInptCnctActiCd("06");
		adminLogProgramVO.setAiInptCnctParmTxt(parmeter);
		
		vo.setLstDbChgId(loginInfo.getId());
		vo.setAiInptUserId(id);
		
		try {
			adminUserService.userDelete(vo);
		} catch (Exception e) {
			HttpUtil.setResult(map, HttpUtil.HttpType.T500);
			HttpUtil.setExResult(map, "-1", e.getMessage());
		}
		
		return map;
	}
	
}