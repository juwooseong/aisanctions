package com.woori.ajs.api;

import java.net.URLDecoder;
import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import com.woori.ajs.model.AdminUserVO;
import com.woori.ajs.model.SearchVO;
import com.woori.ajs.service.AdminUserService;
import com.woori.ajs.service.CommonCodeService;

import egovframework.rte.fdl.property.EgovPropertyService;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import egovframework.ui.cmmn.ComUtil;
import egovframework.ui.cmmn.HttpUtil;

@RestController
public class CommonUserApiController {

	/** 공통 서비스 **/
	@Resource(name = "commonCodeService")
	private CommonCodeService commonCodeService;
	
	/** adminUserService */
	@Resource(name = "adminUserService")
	private AdminUserService adminUserService;

	/** EgovPropertyService */
	@Resource(name = "propertiesService")
	protected EgovPropertyService propertiesService;

/*	@GetMapping("/api/common/user/getRoles")
	public HashMap<String,Object> getRoles() throws Exception {
		SearchVO searchVO = new SearchVO();
		HashMap<String,Object> map = new HashMap<String,Object>();
		
		HttpUtil.setResult(map, HttpUtil.HttpType.T200);
		
		searchVO.setAiInptGrpCd("120");
		map.put("imexHisCdList", commonCodeService.selectAllCommonCodeList(searchVO));
		
		map.put("searchVO",searchVO);
		
		return map;
	}*/
	
	@GetMapping("/api/common/user")
	public HashMap<String,Object> list(SearchVO searchVO) throws Exception {
		HashMap<String,Object> map = new HashMap<String,Object>();

		/*
		 * String orig = searchVO.getSchUserNm();
		String userName = null;
		String [] charSet = {"utf-8", "euc-kr", "ksc5601", "iso-8859-1", "x-windows-949"};
		for(int i=0; i<charSet.length; i++) {
			for(int j=0; i<charSet.length; i++) {
				try {
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		}
		if(orig != null) {
			userName = new String(orig.getBytes("iso-8859-1"), "utf-8");
		}
		searchVO.setSchUserNm(userName);
		*/
		HttpUtil.setResult(map, HttpUtil.HttpType.T200);
		map.put("searchVO",searchVO);
		PaginationInfo paginationInfo = ComUtil.setListPagingInfo(propertiesService, searchVO);

		List<AdminUserVO> list = adminUserService.selectListPop(searchVO);
		map.put("resultList", list);
		
		int totCnt = adminUserService.selectListTotCnt(searchVO);
		
		//paginationInfo.setTotalRecordCount(list.size());
		paginationInfo.setTotalRecordCount(totCnt);
		map.put("paginationInfo", paginationInfo);
		
		return map;
	}
	
}