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
import com.woori.ajs.model.AdminLogProgramVO;
import com.woori.ajs.model.AdminNationVO;
import com.woori.ajs.model.LoginVO;
import com.woori.ajs.service.AdminLogProgramService;
import com.woori.ajs.service.AdminNationService;

import egovframework.rte.fdl.property.EgovPropertyService;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import egovframework.ui.cmmn.ComUtil;
import egovframework.ui.cmmn.HttpUtil;
import egovframework.ui.cmmn.StringUtil;
import egovframework.ui.util.LoginUtils;

@RestController
public class AdminNationApiController {

	@Resource(name = "adminLogProgramService")
	private AdminLogProgramService adminLogProgramService;
	
	/** EgovSampleService */
	@Resource(name = "adminNationService")
	private AdminNationService adminNationService;

	/** EgovPropertyService */
	@Resource(name = "propertiesService")
	protected EgovPropertyService propertiesService;

	/** Validator */
	@Resource(name = "beanValidator")
	protected DefaultBeanValidator beanValidator;

	@Resource(name = "systemFileProperties")
	protected Properties sysProp;

	@GetMapping("/api/admin/nation")
	public HashMap<String,Object> list(SearchVO searchVO) throws Exception {
		HashMap<String,Object> map = new HashMap<String,Object>();
		
		/*String orig = searchVO.getSchText2();
		String nationNm = null;
		
		if(orig != null) {
			nationNm = new String(orig.getBytes("iso-8859-1"), "utf-8");
		}
		searchVO.setSchText2(nationNm);*/
		
		HttpUtil.setResult(map, HttpUtil.HttpType.T200);
		
		map.put("searchVO",searchVO);
		
		PaginationInfo paginationInfo = ComUtil.setListPagingInfo(propertiesService, searchVO);
		//searchVO.setRecordCountPerPage(-1);
		
		List<AdminNationVO> list = adminNationService.selectList(searchVO);
		map.put("resultList", list);

		int totCnt = adminNationService.selectListTotCnt(searchVO);
		//int totCnt = list==null ? 0 : list.size();
		
		paginationInfo.setTotalRecordCount(totCnt);
		map.put("paginationInfo", paginationInfo);
		
		return map;
	}
	
	@PostMapping("/api/admin/nation/one")
	public HashMap<String,Object> selectOne(HttpServletRequest request, SearchVO searchVO) throws Exception {
		HashMap<String,Object> map = new HashMap<String,Object>();
				
		HttpUtil.setResult(map, HttpUtil.HttpType.T200);
		map.put("searchVO",searchVO);
		
		PaginationInfo paginationInfo = ComUtil.setListPagingInfo(propertiesService, searchVO);
		
		AdminNationVO one = adminNationService.selectOne(searchVO);
		map.put("resultList", one);

		int totCnt = adminNationService.selectListTotCnt(searchVO);
		//int totCnt = list==null ? 0 : list.size();
		
		paginationInfo.setTotalRecordCount(totCnt);
		map.put("paginationInfo", paginationInfo);
		
		return map;
	}

	@PostMapping("/api/admin/nation/insert")
	public HashMap<String,Object> insert(HttpServletRequest request, AdminNationVO vo, AdminLogProgramVO adminLogProgramVO) throws Exception {
		HashMap<String,Object> map = new HashMap<String,Object>();
		LoginVO loginInfo = LoginUtils.getLoginInfo(request);

		HttpUtil.setResult(map, HttpUtil.HttpType.T200);
		
		if(StringUtil.isEmpty(vo.getNacd()) || StringUtil.isEmpty(vo.getEngNlNm())) {
			HttpUtil.setResult(map, HttpUtil.HttpType.T500);
			HttpUtil.setExResult(map, "-1", "정보가 부족합니다.");
		}
		
		String trnLogSrno = null;
		SearchVO searchVO = new SearchVO();
		trnLogSrno = adminLogProgramService.logProgramInsert(request, adminLogProgramVO, searchVO);
		
		vo.setTrnLogSrno(trnLogSrno);

		vo.setLstDbChgId(loginInfo.getId());
		
		//대표여부가 Y 인경우, 현재 NACD의 모든 대표여부를 N 으로 초기호 처리.
		if("Y".equals(StringUtil.nvl(vo.getRprsCdYn()))){
			adminNationService.updateInitRprsCdYn(vo);
		}
		
		//국가정보 등록/수정 처리
		adminNationService.insert(vo);

		return map;
	}

	@PostMapping("/api/admin/nation/delete")
	public HashMap<String,Object> delete(HttpServletRequest request, AdminNationVO vo) throws Exception {
		HashMap<String,Object> map = new HashMap<String,Object>();
		LoginVO loginInfo = LoginUtils.getLoginInfo(request);
		
		HttpUtil.setResult(map, HttpUtil.HttpType.T200);

		if(StringUtil.isEmpty(vo.getNacd()) || StringUtil.isEmpty(vo.getEngNlNm())) {
			HttpUtil.setResult(map, HttpUtil.HttpType.T500);
			HttpUtil.setExResult(map, "-1", "정보가 부족합니다.");
		}

		vo.setLstDbChgId(loginInfo.getId());
		
		//국가정보 삭제 처리
		adminNationService.delete(vo);
		
		return map;
	}

}