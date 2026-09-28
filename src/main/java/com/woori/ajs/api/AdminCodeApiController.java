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
import com.woori.ajs.model.CodeGrpVO;
import com.woori.ajs.model.CodeVO;
import com.woori.ajs.model.LoginVO;
import com.woori.ajs.model.SearchVO;
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
public class AdminCodeApiController {

	@Resource(name = "adminLogProgramService")
	private AdminLogProgramService adminLogProgramService;
	
	@Resource(name = "adminCodeService")
	private AdminCodeService adminCodeService;
	
	/** EgovPropertyService */
	@Resource(name = "propertiesService")
	protected EgovPropertyService propertiesService;

	/** Validator */
	@Resource(name = "beanValidator")
	protected DefaultBeanValidator beanValidator;

	@Resource(name = "systemFileProperties")
	protected Properties sysProp;
	
	/**
	 * 코드그룹 목록
	 */
	@GetMapping("/api/admin/code/grp/list")
	public HashMap<String,Object> grpList(SearchVO searchVO) throws Exception {
		HashMap<String,Object> map = new HashMap<String,Object>();
		
		HttpUtil.setResult(map, HttpUtil.HttpType.T200);
		
		PaginationInfo paginationInfo = ComUtil.setListPagingInfo(propertiesService, searchVO);
		searchVO.setRecordCountPerPage(-1);
		
		List<CodeGrpVO> list = adminCodeService.selectCodeGrpList(searchVO);
		
		int totCnt = list==null ? 0 : list.size();
		paginationInfo.setTotalRecordCount(totCnt);
		
		map.put("resultList", list);
		map.put("paginationInfo", paginationInfo);
		
		return map;
	}
	
	/**
	 * 코드그룹 정보
	 */
//	@GetMapping("/api/admin/code/grp/info")
//	public HashMap<String,Object> grpInfo(SearchVO searchVO) throws Exception {
//		HashMap<String,Object> map = new HashMap<String,Object>();
//		
//		HttpUtil.setResult(map, HttpUtil.HttpType.T200);
//		
//		CodeGrpVO info = adminCodeService.selectCodeGrp(searchVO);
//		
//		map.put("info", info);
//		
//		return map;
//	}

	/**
	 * 코드그룹 등록
	 */
	@PostMapping("/api/admin/code/grp/insert")
	public HashMap<String,Object> grpInsert(HttpServletRequest request, CodeGrpVO vo, AdminLogProgramVO adminLogProgramVO) throws Exception {
		HashMap<String,Object> map = new HashMap<String,Object>();
		LoginVO loginInfo = LoginUtils.getLoginInfo(request);
		
		HttpUtil.setResult(map, HttpUtil.HttpType.T200);
		
		if(StringUtil.isEmpty(vo.getAiInptGrpCd()) || StringUtil.isEmpty(vo.getAiInptGrpNm())) {
			HttpUtil.setResult(map, HttpUtil.HttpType.T500);
			HttpUtil.setExResult(map, "-1", "정보가 부족합니다.");
			return map;
		}
		
		String trnLogSrno = null;
		SearchVO searchVO = new SearchVO();
		trnLogSrno = adminLogProgramService.logProgramInsert(request, adminLogProgramVO, searchVO);
		
		vo.setTrnLogSrno(trnLogSrno);
		
		vo.setLstDbChgId(loginInfo.getId());
	//	vo.setAiInptGrpNm(XssUtil.escapeHtml(vo.getAiInptGrpNm()));
		vo.setAiInptGrpNm(vo.getAiInptGrpNm());
		//vo.setAiInptRmrkTxt("-");
		adminCodeService.insertCodeGrp(vo);
		
		return map;
	}

	/**
	 * 코드그룹 삭제처리
	 */
	@PostMapping("/api/admin/code/grp/delete/{id}")
	public HashMap<String,Object> grpDelete(@PathVariable String id, CodeGrpVO vo) throws Exception {
		HashMap<String,Object> map = new HashMap<String,Object>();
		SearchVO searchVO = new SearchVO();
		
		HttpUtil.setResult(map, HttpUtil.HttpType.T200);
		
		vo.setAiInptGrpCd(id);
		
		//현재 코드그룹의 하위 리스트 항목이 존재하는지 체크처리.
		//존재하면 삭제불가.
		boolean chk = false;
		searchVO.setAiInptGrpCd(id);
		List<CodeVO> list = adminCodeService.selectCodeList(searchVO);
		if(list==null || list.size()==0) {
			chk = true;
		}
		if(!chk) {
			HttpUtil.setResult(map, HttpUtil.HttpType.T500);
			HttpUtil.setExResult(map, "-1", "현재 코드그룹 하위에 종속된 코드 항목이 존재합니다.\n종속된 코드 항목을 모두 삭제하신 후에 코드그룹의 삭제가 가능합니다.");
			return map;
		}
		
		//코드그룹 삭제처리.
		adminCodeService.deleteCodeGrp(vo);
		
		return map;
	}
	
	/**
	 * 코드 목록
	 */
	@GetMapping("/api/admin/code/cd/list")
	public HashMap<String,Object> codeList(SearchVO searchVO) throws Exception {
		HashMap<String,Object> map = new HashMap<String,Object>();
		
		HttpUtil.setResult(map, HttpUtil.HttpType.T200);
		
		PaginationInfo paginationInfo = ComUtil.setListPagingInfo(propertiesService, searchVO);
		searchVO.setRecordCountPerPage(-1);
		
		List<CodeVO> list = null;
		if(StringUtil.isNotEmpty(searchVO.getAiInptGrpCd())) {
			list = adminCodeService.selectCodeList(searchVO);
		}
		
		int totCnt = list==null ? 0 : list.size();
		paginationInfo.setTotalRecordCount(totCnt);
		
		map.put("resultList", ComUtil.checkListNull(list));
		map.put("paginationInfo", paginationInfo);
		
		return map;
	}

	/**
	 * 코드 정보
	 */
/*	@GetMapping("/api/admin/code/cd/info")
	public HashMap<String,Object> codeInfo(SearchVO searchVO) throws Exception {
		HashMap<String,Object> map = new HashMap<String,Object>();
		
		HttpUtil.setResult(map, HttpUtil.HttpType.T200);
		
		CodeVO info = adminCodeService.selectCode(searchVO);
		
		map.put("info", info);
		
		return map;
	}*/

	/**
	 * 코드 등록
	 */
	@PostMapping("/api/admin/code/cd/insert")
	public HashMap<String,Object> codeInsert(HttpServletRequest request, CodeVO vo, AdminLogProgramVO adminLogProgramVO) throws Exception {
		HashMap<String,Object> map = new HashMap<String,Object>();
		LoginVO loginInfo = LoginUtils.getLoginInfo(request);
		
		HttpUtil.setResult(map, HttpUtil.HttpType.T200);
		
		if(StringUtil.isEmpty(vo.getAiInptGrpCd()) || StringUtil.isEmpty(vo.getAiInptCmnCd())) {
			HttpUtil.setResult(map, HttpUtil.HttpType.T500);
			HttpUtil.setExResult(map, "-1", "정보가 부족합니다.");
			return map;
		}
		
		String trnLogSrno = null;
		SearchVO searchVO = new SearchVO();
		trnLogSrno = adminLogProgramService.logProgramInsert(request, adminLogProgramVO, searchVO);
		
		vo.setTrnLogSrno(trnLogSrno);
		
		vo.setLstDbChgId(loginInfo.getId());
	//	vo.setAiInptCmnCdNm(XssUtil.escapeHtml(vo.getAiInptCmnCdNm()));
		vo.setAiInptCmnCdNm(vo.getAiInptCmnCdNm());
	//	vo.setAiInptCmnCdEngNm(XssUtil.escapeHtml(vo.getAiInptCmnCdEngNm()));
		vo.setAiInptCmnCdEngNm(vo.getAiInptCmnCdEngNm());
		adminCodeService.insertCode(vo);
		
		return map;
	}

	/**
	 * 코드 삭제처리.
	 */
	@PostMapping("/api/admin/code/cd/delete/{id}/{id2}")
	public HashMap<String,Object> codeDelete(@PathVariable String id, @PathVariable String id2, CodeVO vo) throws Exception {
		HashMap<String,Object> map = new HashMap<String,Object>();
		
		HttpUtil.setResult(map, HttpUtil.HttpType.T200);

		vo.setAiInptGrpCd(id);
		vo.setAiInptCmnCd(id2);

		if(StringUtil.isEmpty(vo.getAiInptGrpCd()) || StringUtil.isEmpty(vo.getAiInptCmnCd())) {
			HttpUtil.setResult(map, HttpUtil.HttpType.T500);
			HttpUtil.setExResult(map, "-1", "정보가 부족합니다.");
			return map;
		}
		
		//리스트 삭제처리.
		adminCodeService.deleteCode(vo);
		
		return map;
	}
	
}