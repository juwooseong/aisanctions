package com.woori.ajs.api;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springmodules.validation.commons.DefaultBeanValidator;

import com.woori.ajs.model.AdminLogProgramVO;
import com.woori.ajs.model.AdminMenuVO;
import com.woori.ajs.model.AdminScreenVO;
import com.woori.ajs.model.LoginVO;
import com.woori.ajs.model.SearchVO;
import com.woori.ajs.service.AdminLogProgramService;
import com.woori.ajs.service.AdminMenuService;

import egovframework.rte.fdl.property.EgovPropertyService;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import egovframework.ui.cmmn.ComUtil;
import egovframework.ui.cmmn.HttpUtil;
import egovframework.ui.cmmn.StringUtil;
import egovframework.ui.util.LoginUtils;

@RestController
public class AdminMenuApiController {

	@Resource(name = "adminLogProgramService")
	private AdminLogProgramService adminLogProgramService;
	
	/** adminMenuService */
	@Resource(name = "adminMenuService")
	private AdminMenuService adminMenuService;

	/** EgovPropertyService */
	@Resource(name = "propertiesService")
	protected EgovPropertyService propertiesService;

	/** Validator */
	@Resource(name = "beanValidator")
	protected DefaultBeanValidator beanValidator;

	@Resource(name = "systemFileProperties")
	protected Properties sysProp;

	@GetMapping("/api/admin/menu")
	public HashMap<String,Object> list(SearchVO searchVO) throws Exception {
		HashMap<String,Object> map = new HashMap<String,Object>();
		
		HttpUtil.setResult(map, HttpUtil.HttpType.T200);
		
		map.put("searchVO",searchVO);
		
		PaginationInfo paginationInfo = ComUtil.setListPagingInfo(propertiesService, searchVO);
		searchVO.setRecordCountPerPage(-1);
		
		List<AdminMenuVO> list = adminMenuService.selectList(searchVO);
		map.put("resultList", list);

		//int totCnt = adminMenuService.selectListTotCnt(searchVO);
		int totCnt = list==null ? 0 : list.size();
		
		paginationInfo.setTotalRecordCount(totCnt);
		map.put("paginationInfo", paginationInfo);
		
		return map;
	}

	@PostMapping("/api/admin/menu/selectOneHg")
	public HashMap<String,Object> selectOneHg(SearchVO searchVO) throws Exception {
		HashMap<String,Object> map = new HashMap<String,Object>();
		HttpUtil.setResult(map, HttpUtil.HttpType.T200);
		
		String hgNm = adminMenuService.selectOneHg(searchVO);
		map.put("hgNm", hgNm);
		
		return map;
	}
	
	@PostMapping("/api/admin/menu/selectOneScreenName")
	public HashMap<String,Object> selectOneScreenName(SearchVO searchVO) throws Exception {
		HashMap<String,Object> map = new HashMap<String,Object>();
		HttpUtil.setResult(map, HttpUtil.HttpType.T200);
		
		String screenName = adminMenuService.selectOneScreenName(searchVO);
		map.put("screenName", screenName);

		return map;
	}
	
	@PostMapping("/api/admin/menu/regMenu")
	public HashMap<String,Object> regMenu(AdminMenuVO vo, AdminLogProgramVO adminLogProgramVO ,HttpServletRequest request) throws Exception {
		HashMap<String,Object> map = new HashMap<String,Object>();
		HttpUtil.setResult(map, HttpUtil.HttpType.T200);
		SearchVO svo = new SearchVO();
		String trnLogSrno = adminLogProgramService.logProgramInsert(request, adminLogProgramVO, svo);
		vo.setTrnLogSrno(trnLogSrno);
		LoginVO loginInfo = LoginUtils.getLoginInfo(request);
		vo.setLstDbChgId(loginInfo.getId());
		
		List<AdminMenuVO> checkMenuId =  adminMenuService.checkMenuId(vo);
		List<AdminMenuVO> checkScreenNo =  adminMenuService.checkScreenNo(vo);
		String checkStr;
		if(checkMenuId.size() != 0 && checkScreenNo.size() != 0) {
			checkStr = "both";
		}else if(checkMenuId.size() != 0){
			checkStr = "menuId";
		}else if(checkScreenNo.size() != 0) {
			checkStr = "screenNo";
		}else {
			checkStr = "nomal";
			try {
				adminMenuService.regMenu(vo);
				if("Y".equals(vo.getAiInptAdminYn())) {
					adminMenuService.insertAutAdmin(vo);
				}else {
					adminMenuService.insertAutAll(vo);
				}
				map.put("result",true);
			} catch (Exception e) {
				HttpUtil.setResult(map, HttpUtil.HttpType.T500);
				map.put("result",false);
			}
		}
		map.put("checkStr", checkStr);
		return map;
	}
	
	@PostMapping("/api/admin/menu/modiMenu")
	public HashMap<String,Object> modiMenu(AdminMenuVO vo, AdminLogProgramVO adminLogProgramVO ,HttpServletRequest request) throws Exception {
		HashMap<String,Object> map = new HashMap<String,Object>();
		HttpUtil.setResult(map, HttpUtil.HttpType.T200);
		SearchVO svo = new SearchVO();
		String trnLogSrno = adminLogProgramService.logProgramInsert(request, adminLogProgramVO, svo);
		vo.setTrnLogSrno(trnLogSrno);
		LoginVO loginInfo = LoginUtils.getLoginInfo(request);
		vo.setLstDbChgId(loginInfo.getId());
		
	//	List<AdminMenuVO> checkMenuId =  adminMenuService.checkMenuId(vo);
		String checkScreenNoForUpdate =  adminMenuService.checkScreenNoForUpdate(vo);
		String checkStr;
		if(checkScreenNoForUpdate == null) {
			try {
				adminMenuService.modiMenu(vo);
				map.put("result",true);
			} catch (Exception e) {
				HttpUtil.setResult(map, HttpUtil.HttpType.T500);
				map.put("result",false);
			}
			checkStr = "nomal";
		}else {
			checkStr = "screenNo";
		}
		map.put("checkStr", checkStr);
	
		return map;
	}
	
	
	@GetMapping("/api/admin/menu/screen")
	public HashMap<String,Object> screenList(SearchVO searchVO) throws Exception {
		HashMap<String,Object> map = new HashMap<String,Object>();
		
		HttpUtil.setResult(map, HttpUtil.HttpType.T200);
		
		map.put("searchVO",searchVO);
		
		PaginationInfo paginationInfo = ComUtil.setListPagingInfo(propertiesService, searchVO);
		searchVO.setRecordCountPerPage(-1);
		
		List<AdminScreenVO> list = null;
		if(StringUtil.isNotEmpty(searchVO.getMenuId())) {
			list = adminMenuService.selectScreenList(searchVO);
		}
		
		map.put("resultList", ComUtil.checkListNull(list));
		
		//int totCnt = adminMenuService.selectListTotCnt(searchVO);
		int totCnt = list==null ? 0 : list.size();
		
		paginationInfo.setTotalRecordCount(totCnt);
		map.put("paginationInfo", paginationInfo);
		
		return map;
	}
	
	@PostMapping("/api/admin/menu/screen")
	public HashMap<String,Object> screenUseUpdate(HttpServletRequest request, AdminScreenVO vo, AdminLogProgramVO adminLogProgramVO) throws Exception {
		HashMap<String,Object> map = new HashMap<String,Object>();
		LoginVO loginVO = LoginUtils.getLoginInfo(request);
		
		HttpUtil.setResult(map, HttpUtil.HttpType.T200);
		
		if(StringUtil.isEmpty(vo.getAiInptAutCd())) {
			HttpUtil.setResult(map, HttpUtil.HttpType.T500);
			HttpUtil.setExResult(map, "-1", "정보가 부족합니다.");
			return map;
		}
		
		String[] aiInptMenuIds = request.getParameterValues("aiInptMenuIds");
		String[] aiInptAutUsgYns = request.getParameterValues("aiInptAutUsgYns");
		
		String trnLogSrno = null;
		SearchVO searchVO = new SearchVO();
		trnLogSrno = adminLogProgramService.logProgramInsert(request, adminLogProgramVO, searchVO);
		
		vo.setTrnLogSrno(trnLogSrno);
		vo.setLstDbChgId(loginVO.getId());
		
		if(aiInptMenuIds!=null && aiInptAutUsgYns!=null) {
			for(int i=0;i<aiInptMenuIds.length;i++) {
				String aiInptMenuId = aiInptMenuIds[i];
				String aiInptAutUsgYn = aiInptAutUsgYns[i];
				vo.setAiInptMenuId(aiInptMenuId);
				vo.setAiInptAutUsgYn(aiInptAutUsgYn);
				adminMenuService.screenUseUpdate(vo);
			}
		}
		
		return map;
	}
	
	@GetMapping("/api/admin/menu/reg")
	public HashMap<String,Object> selectListForRegMenu(HttpServletRequest request, AdminLogProgramVO adminLogProgramVO, SearchVO searchVO) throws Exception {
		HashMap<String,Object> map = new HashMap<String,Object>();
	//	LoginVO loginVO = LoginUtils.getLoginInfo(request);
		
		HttpUtil.setResult(map, HttpUtil.HttpType.T200);
		PaginationInfo paginationInfo = ComUtil.setListPagingInfo(propertiesService, searchVO);
		searchVO.setRecordCountPerPage(-1);
	//	String trnLogSrno = null;
	//	searchVO.setTrnLogSrno(trnLogSrno);
	//	searchVO.setLstDbChgId(loginVO.getId());
	//	trnLogSrno = adminLogProgramService.logProgramInsert(request, adminLogProgramVO, searchVO);
		
		List<AdminMenuVO> list = adminMenuService.selectListForRegMenu(searchVO);
		map.put("resultList", list);
		
		int totCnt = list==null ? 0 : list.size();
		
		paginationInfo.setTotalRecordCount(totCnt);
		map.put("paginationInfo", paginationInfo);
		
		return map;
	}
	
	@PostMapping("/api/admin/menu/delMenu")
	public HashMap<String,Object> deleteMenu(HttpServletRequest request, AdminLogProgramVO adminLogProgramVO, SearchVO searchVO) throws Exception {
		HashMap<String,Object> map = new HashMap<String,Object>();
		LoginVO loginVO = LoginUtils.getLoginInfo(request);
		
		HttpUtil.setResult(map, HttpUtil.HttpType.T200);
	//	PaginationInfo paginationInfo = ComUtil.setListPagingInfo(propertiesService, searchVO);
//		searchVO.setRecordCountPerPage(-1);
		String trnLogSrno = null;
		adminLogProgramVO.setTrnLogSrno(trnLogSrno);
		adminLogProgramVO.setLstDbChgId(loginVO.getId());
		trnLogSrno = adminLogProgramService.logProgramInsert(request, adminLogProgramVO, searchVO);
		
		try {
		adminMenuService.deleteMenu(searchVO);
		adminMenuService.deleteMenuAuth(searchVO);
		}catch (Exception e) {
			// TODO: handle exception
			HttpUtil.setResult(map, HttpUtil.HttpType.T500);
		}
		return map;
	}
}