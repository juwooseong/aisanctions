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

import com.woori.ajs.model.AdminLogProgramVO;
import com.woori.ajs.model.AdminSanctionRule1VO;
import com.woori.ajs.model.AdminSanctionRule2VO;
import com.woori.ajs.model.AdminSanctionRule3VO;
import com.woori.ajs.model.AdminSanctionVO;
import com.woori.ajs.model.LoginVO;
import com.woori.ajs.model.SearchVO;
import com.woori.ajs.service.AdminLogProgramService;
import com.woori.ajs.service.AdminSanctionService;

import egovframework.rte.fdl.property.EgovPropertyService;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import egovframework.ui.cmmn.ComUtil;
import egovframework.ui.cmmn.HttpUtil;
import egovframework.ui.cmmn.StringUtil;
import egovframework.ui.cmmn.XssUtil;
import egovframework.ui.util.LoginUtils;

@RestController
public class AdminSanctionApiController {
	
	@Resource(name = "adminLogProgramService")
	private AdminLogProgramService adminLogProgramService;
	
	@Resource(name = "adminSanctionService")
	private AdminSanctionService adminSanctionService;
	
	/** EgovPropertyService */
	@Resource(name = "propertiesService")
	protected EgovPropertyService propertiesService;

	/** Validator */
	@Resource(name = "beanValidator")
	protected DefaultBeanValidator beanValidator;

	@Resource(name = "systemFileProperties")
	protected Properties sysProp;
	
	@GetMapping("/api/admin/sanction/rule1")
	public HashMap<String,Object> listRule1(SearchVO searchVO) throws Exception {
		HashMap<String,Object> map = new HashMap<String,Object>();
		
		HttpUtil.setResult(map, HttpUtil.HttpType.T200);

		PaginationInfo paginationInfo = ComUtil.setListPagingInfo(propertiesService, searchVO);
		searchVO.setRecordCountPerPage(-1);
		
		List<AdminSanctionRule1VO> list = adminSanctionService.selectListRule1(searchVO);
		
		int totCnt = list==null ? 0 : list.size();
		paginationInfo.setTotalRecordCount(totCnt);
		
		map.put("resultList", list);
		map.put("paginationInfo", paginationInfo);
		return map;
	}

	@GetMapping("/api/admin/sanction/rule2")
	public HashMap<String,Object> listRule2(SearchVO searchVO) throws Exception {
		HashMap<String,Object> map = new HashMap<String,Object>();
		
		HttpUtil.setResult(map, HttpUtil.HttpType.T200);

		PaginationInfo paginationInfo = ComUtil.setListPagingInfo(propertiesService, searchVO);
		searchVO.setRecordCountPerPage(-1);

		List<AdminSanctionRule2VO> list = adminSanctionService.selectListRule2(searchVO);
		
		int totCnt = list==null ? 0 : list.size();
		paginationInfo.setTotalRecordCount(totCnt);
		
		map.put("resultList", list);
		map.put("paginationInfo", paginationInfo);
		return map;
	}

/*	@GetMapping("/api/admin/sanction/rule3")
	public HashMap<String,Object> listRule3(SearchVO searchVO) throws Exception {
		HashMap<String,Object> map = new HashMap<String,Object>();
		
		HttpUtil.setResult(map, HttpUtil.HttpType.T200);

		PaginationInfo paginationInfo = ComUtil.setListPagingInfo(propertiesService, searchVO);
		searchVO.setRecordCountPerPage(-1);

		List<AdminSanctionRule3VO> list = adminSanctionService.selectListRule3(searchVO);
		
		int totCnt = list==null ? 0 : list.size();
		paginationInfo.setTotalRecordCount(totCnt);
		
		map.put("resultList", list);
		map.put("paginationInfo", paginationInfo);
		return map;
	}*/

	@GetMapping("/api/admin/sanction/request")
	public HashMap<String,Object> listRequest(SearchVO searchVO) throws Exception {
		HashMap<String,Object> map = new HashMap<String,Object>();
		
		HttpUtil.setResult(map, HttpUtil.HttpType.T200);

		PaginationInfo paginationInfo = ComUtil.setListPagingInfo(propertiesService, searchVO);
		searchVO.setRecordCountPerPage(-1);

		List<AdminSanctionVO> list = adminSanctionService.RequestTable(searchVO);
		
		int totCnt = list==null ? 0 : list.size();
		paginationInfo.setTotalRecordCount(totCnt);
		
		map.put("resultList", list);
		map.put("paginationInfo", paginationInfo);
		return map;
	}
	
	/**
	 * 공통정보 저장 - 일치율 적용
	 */
	@PostMapping("/api/admin/sanction/request")
	public HashMap<String,Object> insertRequest(HttpServletRequest request, AdminSanctionVO vo, AdminLogProgramVO adminLogProgramVO) throws Exception {
		HashMap<String,Object> map = new HashMap<String,Object>();
		LoginVO loginInfo = LoginUtils.getLoginInfo(request);
		
		HttpUtil.setResult(map, HttpUtil.HttpType.T200);

		String trnLogSrno = null;
		SearchVO searchVO = new SearchVO();
		trnLogSrno = adminLogProgramService.logProgramInsert(request, adminLogProgramVO, searchVO);
		
		vo.setTrnLogSrno(trnLogSrno);
		vo.setLstDbChgId(loginInfo.getId());
		adminSanctionService.insertRequestTable(vo);
		
		return map;
	}

	
/*	@PostMapping("/api/admin/sanction/request2")
	public HashMap<String,Object> insertRequest2(HttpServletRequest request, AdminSanctionVO vo) throws Exception {
		HashMap<String,Object> map = new HashMap<String,Object>();
		LoginVO loginInfo = LoginUtils.getLoginInfo(request);
		
		HttpUtil.setResult(map, HttpUtil.HttpType.T200);

		vo.setLstDbChgId(loginInfo.getId());
		adminSanctionService.insertRequestTable2(vo);
		
		return map;
	}

	
	@PostMapping("/api/admin/sanction/request3")
	public HashMap<String,Object> insertRequest3(HttpServletRequest request, AdminSanctionVO vo) throws Exception {
		HashMap<String,Object> map = new HashMap<String,Object>();
		LoginVO loginInfo = LoginUtils.getLoginInfo(request);
		
		HttpUtil.setResult(map, HttpUtil.HttpType.T200);
		
		vo.setLstDbChgId(loginInfo.getId());
		adminSanctionService.insertRequestTable3(vo);
		
		return map;
	}*/

	/**
	 * Rule1 저장
	 */
	@PostMapping("/api/admin/sanction/rule1")
	public HashMap<String,Object> insertRule1(HttpServletRequest request, AdminSanctionRule1VO vo, AdminLogProgramVO adminLogProgramVO) throws Exception {
		HashMap<String,Object> map = new HashMap<String,Object>();
		LoginVO loginInfo = LoginUtils.getLoginInfo(request);
		HttpUtil.setResult(map, HttpUtil.HttpType.T200);
	//	SearchVO sv = new SearchVO();
		boolean result = true;
		//param.aiInptSnrl1Id = $('#num1').val();
		//param.inptSanctionNo = fnGetItemObjVal('item1');
		//param.aiInptListId = $('#list1').val();
		
		//sv.setAiInptSnrl1Id(vo.getAiInptSnrl1Id());
		//sv.setAiInptListId(vo.getAiInptListId());
		//sv.setInptSanctionNo(vo.getInptSanctionNo());
		//sNewOrMod = vo.getIsNewOrMod();
		
		String trnLogSrno = null;
		SearchVO searchVO = new SearchVO();
		trnLogSrno = adminLogProgramService.logProgramInsert(request, adminLogProgramVO, searchVO);
		
		vo.setTrnLogSrno(trnLogSrno);
		
		vo.setLstDbChgId(loginInfo.getId());
		List<AdminSanctionRule1VO> list =  adminSanctionService.selectListCheckRule1(vo);
		if (list.size() == 0) {
			adminSanctionService.insertRule1(vo);
		} else {
			result = false;
		}
		
		map.put("result", result);
		return map;
	}

	/**
	 * Rule2 저장
	 */
	@PostMapping("/api/admin/sanction/rule2")
	public HashMap<String,Object> insertRule2(HttpServletRequest request, AdminSanctionRule2VO vo, AdminLogProgramVO adminLogProgramVO) throws Exception {
		HashMap<String,Object> map = new HashMap<String,Object>();
		LoginVO loginInfo = LoginUtils.getLoginInfo(request);
		
		HttpUtil.setResult(map, HttpUtil.HttpType.T200);
		boolean result = true;
		String sNewOrMod;
		sNewOrMod = vo.getIsNewOrMod();
		
		String trnLogSrno = null;
		SearchVO searchVO = new SearchVO();
		trnLogSrno = adminLogProgramService.logProgramInsert(request, adminLogProgramVO, searchVO);
		
		vo.setTrnLogSrno(trnLogSrno);
		
		vo.setLstDbChgId(loginInfo.getId());
		vo.setAiInptSnrl2Nm(vo.getAiInptSnrl2Nm());
	//	vo.setAiInptSnrl2Nm(XssUtil.escapeHtml(vo.getAiInptSnrl2Nm()));

		if("new".equals(sNewOrMod)) {
			List<AdminSanctionRule2VO> list =  adminSanctionService.selectListCheckRule2(vo);
			if (list.size() == 0) {
				adminSanctionService.insertRule2(vo);
			} else {
				result = false;
			}
		} else {
			adminSanctionService.insertRule2(vo);
		}
		map.put("result", result);
		
		return map;
	}
	


	/**
	 * Rule1 삭제처리.
	 */
	@PostMapping("/api/admin/sanction/rule1/delete/{id}")
	public HashMap<String,Object> rule1Delete(@PathVariable String id, HttpServletRequest request, AdminSanctionRule1VO vo) throws Exception {
		HashMap<String,Object> map = new HashMap<String,Object>();
		LoginVO loginInfo = LoginUtils.getLoginInfo(request);
		
		HttpUtil.setResult(map, HttpUtil.HttpType.T200);
		
		if(StringUtil.isEmpty(id)) {
			HttpUtil.setResult(map, HttpUtil.HttpType.T500);
			HttpUtil.setExResult(map, "-1", "정보가 부족합니다.");
			return map;
		}
		
		vo.setAiInptSnrl1Id(id);
		vo.setLstDbChgId(loginInfo.getId());
		adminSanctionService.deleteRule1(vo);
		
		return map;
	}

	/**
	 * Rule2 삭제처리.
	 */
	@PostMapping("/api/admin/sanction/rule2/delete/{id}")
	public HashMap<String,Object> rule2Delete(@PathVariable String id, HttpServletRequest request, AdminSanctionRule2VO vo) throws Exception {
		HashMap<String,Object> map = new HashMap<String,Object>();
		LoginVO loginInfo = LoginUtils.getLoginInfo(request);
		
		HttpUtil.setResult(map, HttpUtil.HttpType.T200);

		if(StringUtil.isEmpty(id)) {
			HttpUtil.setResult(map, HttpUtil.HttpType.T500);
			HttpUtil.setExResult(map, "-1", "정보가 부족합니다.");
			return map;
		}
		
		vo.setAiInptSnrl2Id(id);
		vo.setLstDbChgId(loginInfo.getId());
		adminSanctionService.deleteRule2(vo);
		
		return map;
	}

	/**
	 * Rule3 삭제처리.
	 */
	/*@PostMapping("/api/admin/sanction/rule3/delete/{id}")
	public HashMap<String,Object> rule3Delete(@PathVariable String id, HttpServletRequest request, AdminSanctionRule3VO vo) throws Exception {
		HashMap<String,Object> map = new HashMap<String,Object>();
		LoginVO loginInfo = LoginUtils.getLoginInfo(request);
		
		HttpUtil.setResult(map, HttpUtil.HttpType.T200);
		
		if(StringUtil.isEmpty(id)) {
			HttpUtil.setResult(map, HttpUtil.HttpType.T500);
			HttpUtil.setExResult(map, "-1", "정보가 부족합니다.");
			return map;
		}
		
		vo.setAiInptSnrl3Id(id);
		vo.setLstDbChgId(loginInfo.getId());
		adminSanctionService.deleteRule3(vo);
		
		return map;
	}*/
	
}