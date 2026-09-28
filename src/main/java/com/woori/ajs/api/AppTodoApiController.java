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

import com.woori.ajs.model.AdminLogProgramVO;
import com.woori.ajs.model.AppTodoMemoVO;
import com.woori.ajs.model.AppTodoVO;
import com.woori.ajs.model.CommonManualVO;
import com.woori.ajs.model.CommonRevertDetailVO;
import com.woori.ajs.model.LoginVO;
import com.woori.ajs.model.SearchVO;
import com.woori.ajs.service.AdminLogProgramService;
import com.woori.ajs.service.AppTodoService;
import com.woori.ajs.service.CommonRevertDetailService;

import egovframework.rte.fdl.property.EgovPropertyService;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import egovframework.ui.cmmn.CastUtil;
import egovframework.ui.cmmn.ComUtil;
import egovframework.ui.cmmn.HttpUtil;
import egovframework.ui.cmmn.StringUtil;
import egovframework.ui.util.LoginUtils;

@RestController
public class AppTodoApiController {

	/** 심사상세 공통 서비스 **/
	@Resource(name = "commonRevertDetailService")
	private CommonRevertDetailService service;

	@Resource(name = "appTodoService")
	private AppTodoService appTodoService;
	
	/** adminLogProgramService */
	@Resource(name = "adminLogProgramService")
	private AdminLogProgramService adminLogProgramService;
	
	/** EgovPropertyService */
	@Resource(name = "propertiesService")
	protected EgovPropertyService propertiesService;

	/** Validator */
	@Resource(name = "beanValidator")
	protected DefaultBeanValidator beanValidator;

	@Resource(name = "systemFileProperties")
	protected Properties sysProp;

	@GetMapping("/api/app/todo")
	public HashMap<String,Object> list(HttpServletRequest request, SearchVO searchVO) throws Exception {
		HashMap<String,Object> map = new HashMap<String,Object>();
		LoginVO loginInfo = LoginUtils.getLoginInfo(request);
		
		HttpUtil.setResult(map, HttpUtil.HttpType.T200);

		searchVO.setUserId(loginInfo.getId());

		map.put("searchVO",searchVO);
		
		PaginationInfo paginationInfo = ComUtil.setListPagingInfo(propertiesService, searchVO);
		//searchVO.setRecordCountPerPage(-1);
		
		List<AppTodoVO> list = appTodoService.selectList(searchVO);
		map.put("resultList", list);

		int totCnt = appTodoService.selectListTotCnt(searchVO);
		//int totCnt = list==null ? 0 : list.size();
		
		paginationInfo.setTotalRecordCount(totCnt);
		map.put("paginationInfo", paginationInfo);
		
		return map;
	}

	@GetMapping("/api/app/todo/bundle")
	public HashMap<String,Object> bundleList(SearchVO searchVO) throws Exception {
		HashMap<String,Object> map = new HashMap<String,Object>();
		
		HttpUtil.setResult(map, HttpUtil.HttpType.T200);
		
		map.put("searchVO",searchVO);
		
		PaginationInfo paginationInfo = ComUtil.setListPagingInfo(propertiesService, searchVO);
		searchVO.setRecordCountPerPage(-1);
		
		List<AppTodoMemoVO> list = appTodoService.selectMemoList(searchVO);
		map.put("resultList", list);

		//int totCnt = appTodoService.selectListTotCnt(searchVO);
		int totCnt = list==null ? 0 : list.size();
		
		paginationInfo.setTotalRecordCount(totCnt);
		map.put("paginationInfo", paginationInfo);
		
		return map;
	}

	/**
	 * 일괄승인처리
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("null")
	@PostMapping("/api/app/todo/bundle")
	public HashMap<String,Object> bundleProc(HttpServletRequest request, AppTodoVO vo, AdminLogProgramVO adminLogProgramVO, SearchVO searchVo) throws Exception {
		HashMap<String,Object> map = new HashMap<String,Object>();
		LoginVO loginInfo = LoginUtils.getLoginInfo(request);
		SearchVO searchVO = new SearchVO();
		//List<AppTodoVO> list;
		//AppTodoVO list;
		HttpUtil.setResult(map, HttpUtil.HttpType.T200);
	//	StringBuffer sb = new StringBuffer();
		
	//	map.put("searchVO",vo);
		
		String[] ids = vo.getRevertIds();
		String[] aiInptAppvHstIds = new String[ids.length];
		String[] inptAtmcBizDscds = vo.getInptAtmcBizDscds();
		String[] aiInptTpySaveYns = new String[ids.length];
		String[] aiInptCrpeEnos = new String[ids.length];
		String[] totaltextAiInptRstCds = vo.getTotaltextAiInptRstCds();
		String[] itmInptAiInptRstCds = vo.getItmInptAiInptRstCds();
		String[] aiInptQlasPrgStsCds = new String[ids.length];
		String[] inptAtvtCds = vo.getInptAtvtCds();
		String revertMemo = vo.getRevertMemo();
		
		if(ids==null || ids.length==0) {
			HttpUtil.setResult(map, HttpUtil.HttpType.T500);
			HttpUtil.setExResult(map, "-1", "일괄 승인할 심사아이디가 없습니다.");
			return map;
		}
		
		vo.setLstDbChgId(loginInfo.getId());
		
		String trnLogSrno;
		trnLogSrno = adminLogProgramService.logProgramInsert(request, adminLogProgramVO, searchVO);
		
		vo.setTrnLogSrno(trnLogSrno);

		for(int i =0; i<ids.length; i++) {
			searchVo.setInptMstSrno(Integer.parseInt(ids[i])); 
			List<AppTodoVO> list = appTodoService.selectApprvHis(searchVo);
			if(list.size() != 0) {
			//	aiInptAppvHstIds[i] = list.getAiInptAppvHstId(); 
			//	aiInptTpySaveYns[i] = list.getAiInptTpySaveYn();
			//	aiInptCrpeEnos[i] = list.getAiInptCrpeEno();
				if(list.get(0).getAiInptAppvHstId() != null) {
					aiInptAppvHstIds[i] = list.get(0).getAiInptAppvHstId();
				}
				if(list.get(0).getAiInptTpySaveYn() != null) {
					aiInptTpySaveYns[i] = list.get(0).getAiInptTpySaveYn();
				}
				if(list.get(0).getAiInptCrpeEno() != null) {
					aiInptCrpeEnos[i] = list.get(0).getAiInptCrpeEno();
				}
				if(list.get(0).getAiInptAppvHstId() != null) {
					aiInptAppvHstIds[i] = list.get(0).getAiInptAppvHstId();
				}
			}
		}
		
		//List<AppTodoVO> list = appTodoService.selectApprvHis(ids);
		
		/////////////////trnLogSrno 추가해야함
		service.updateCommonApprvHis(request, ids, aiInptAppvHstIds, inptAtmcBizDscds, aiInptTpySaveYns, aiInptCrpeEnos,
				totaltextAiInptRstCds, itmInptAiInptRstCds, aiInptQlasPrgStsCds, inptAtvtCds, revertMemo, trnLogSrno);
		
		map.put("searchVO",vo);
		return map;
	}
	
}