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

import com.woori.ajs.model.AdminAbsenceVO;
import com.woori.ajs.model.AdminLogProgramVO;
import com.woori.ajs.model.LoginVO;
import com.woori.ajs.model.SearchVO;
import com.woori.ajs.service.AdminAbsenceService;
import com.woori.ajs.service.AdminLogProgramService;

import egovframework.rte.fdl.property.EgovPropertyService;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import egovframework.ui.cmmn.ComUtil;
import egovframework.ui.cmmn.HttpUtil;
import egovframework.ui.cmmn.StringUtil;
import egovframework.ui.util.LoginUtils;

@RestController
public class AdminAbsenceApiController {

	@Resource(name = "adminLogProgramService")
	private AdminLogProgramService adminLogProgramService;
	
	/** AdminAbsenceService */
	@Resource(name = "AdminAbsenceService")
	private AdminAbsenceService AdminAbsenceService;

	/** EgovPropertyService */
	@Resource(name = "propertiesService")
	protected EgovPropertyService propertiesService;

	/** Validator */
	@Resource(name = "beanValidator")
	protected DefaultBeanValidator beanValidator;

	@Resource(name = "systemFileProperties")
	protected Properties sysProp;

	@GetMapping("/api/admin/absence")
	public HashMap<String,Object> list(SearchVO searchVO) throws Exception {
		HashMap<String,Object> map = new HashMap<String,Object>();
		
		/*String orig = searchVO.getSchUserNm();
		String userName = null;
		
		if(orig != null) {
			userName = new String(orig.getBytes("iso-8859-1"), "utf-8");
		}
		searchVO.setSchUserNm(userName);*/
		HttpUtil.setResult(map, HttpUtil.HttpType.T200);
		
		map.put("searchVO",searchVO);
		
		PaginationInfo paginationInfo = ComUtil.setListPagingInfo(propertiesService, searchVO);
		//searchVO.setRecordCountPerPage(-1);
		
		List<AdminAbsenceVO> list = AdminAbsenceService.selectList(searchVO);
		map.put("resultList", list);

		int totCnt = AdminAbsenceService.selectListTotCnt(searchVO);
		//int totCnt = list==null ? 0 : list.size();
		
		paginationInfo.setTotalRecordCount(totCnt);
		map.put("paginationInfo", paginationInfo);
		
		return map;
	}

	/**
	 * 부재여부 업데이트 처리.
	 */
	@PostMapping("/api/admin/absence/update")
	public HashMap<String,Object> updateExist(HttpServletRequest request, AdminAbsenceVO vo, AdminLogProgramVO adminLogProgramVO) throws Exception {
		HashMap<String,Object> map = new HashMap<String,Object>();
		LoginVO loginInfo = LoginUtils.getLoginInfo(request);
		
		HttpUtil.setResult(map, HttpUtil.HttpType.T200);
		
		if(StringUtil.isEmpty(vo.getAiInptUserFaReYn())) {
			HttpUtil.setResult(map, HttpUtil.HttpType.T500);
			HttpUtil.setExResult(map, "-1", "부재 해제여부 정보가 부족합니다.");
			return map;
		}
		
		String trnLogSrno = null;
		SearchVO searchVO = new SearchVO();
		trnLogSrno = adminLogProgramService.logProgramInsert(request, adminLogProgramVO, searchVO);
		
		vo.setTrnLogSrno(trnLogSrno);
		
		vo.setLstDbChgId(loginInfo.getId());
		
		//부재여부를 변경할 직원 번호 배열
		String[] userNos = request.getParameterValues("userNos");
		
		if(userNos!=null && userNos.length > 0) {
			for (String userNo : userNos) {
				if(StringUtil.isNotEmpty(userNo)) {
					vo.setAiInptUserEno(userNo);
					AdminAbsenceService.existUpdate(vo);
				}
			}
		}
		
		return map;
	}

	/**
	 * 부재여부 업데이트 처리.
	 */
	@PostMapping("/common/self/absence/update")
	public HashMap<String,Object> updateExistSelf(HttpServletRequest request, AdminAbsenceVO vo, AdminLogProgramVO adminLogProgramVO) throws Exception {
		HashMap<String,Object> map = new HashMap<String,Object>();
		LoginVO loginInfo = LoginUtils.getLoginInfo(request);
		
		HttpUtil.setResult(map, HttpUtil.HttpType.T200);
		
		if(StringUtil.isEmpty(vo.getAiInptUserFaReYn())) {
			HttpUtil.setResult(map, HttpUtil.HttpType.T500);
			HttpUtil.setExResult(map, "-1", "부재 해제여부 정보가 부족합니다.");
			return map;
		}
		
		String trnLogSrno = null;
		SearchVO searchVO = new SearchVO();
		trnLogSrno = adminLogProgramService.logProgramInsert(request, adminLogProgramVO, searchVO);
		
		vo.setTrnLogSrno(trnLogSrno);
		
		vo.setLstDbChgId(loginInfo.getId());
		
		//부재여부를 변경할 직원 번호 배열
		String[] userNos = request.getParameterValues("userNos");
		
		if(userNos!=null && userNos.length > 0) {
			for (String userNo : userNos) {
				if(StringUtil.isNotEmpty(userNo)) {
					vo.setAiInptUserEno(userNo);
					AdminAbsenceService.existUpdate(vo);
				}
			}
		}
		
		return map;
	}
}