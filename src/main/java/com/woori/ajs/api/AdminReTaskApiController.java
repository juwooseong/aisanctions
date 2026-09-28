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
import com.woori.ajs.model.AdminReTaskTaskVO;
import com.woori.ajs.model.AdminReTaskUserVO;
import com.woori.ajs.model.AdminUserVO;
import com.woori.ajs.model.AppTodoVO;
import com.woori.ajs.model.LoginVO;
import com.woori.ajs.model.QaTodoVO;
import com.woori.ajs.model.ReverTodoVO;
import com.woori.ajs.model.SearchVO;
import com.woori.ajs.model.WatchListVO;
import com.woori.ajs.service.AdminLogProgramService;
import com.woori.ajs.service.AdminReTaskService;
import com.woori.ajs.service.AdminUserService;
import com.woori.ajs.service.AppTodoService;
import com.woori.ajs.service.QaTodoService;
import com.woori.ajs.service.RevertTodoService;

import egovframework.rte.fdl.property.EgovPropertyService;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import egovframework.ui.cmmn.ComUtil;
import egovframework.ui.cmmn.HttpUtil;
import egovframework.ui.cmmn.StringUtil;
import egovframework.ui.util.LoginUtils;

@RestController
public class AdminReTaskApiController {

	@Resource(name = "adminLogProgramService")
	private AdminLogProgramService adminLogProgramService;
	
	/** adminReTaskService */
	@Resource(name = "adminReTaskService")
	private AdminReTaskService adminReTaskService;

	/** EgovPropertyService */
	@Resource(name = "propertiesService")
	protected EgovPropertyService propertiesService;

	/** adminUserService */
	@Resource(name = "adminUserService")
	private AdminUserService adminUserService;

	/** revertTodoService */
	@Resource(name = "revertTodoService")
	private RevertTodoService revertTodoService;
	
	/** qaTodoService */
	@Resource(name = "qaTodoService")
	private QaTodoService qaTodoService;
	
	/** appTodoService */
	@Resource(name = "appTodoService")
	private AppTodoService appTodoService;
	
	/** Validator */
	@Resource(name = "beanValidator")
	protected DefaultBeanValidator beanValidator;

	@Resource(name = "systemFileProperties")
	protected Properties sysProp;

	/**
	 * 사용자 목록
	 */
	@GetMapping("/api/admin/retask/user")
	public HashMap<String,Object> list(SearchVO searchVO) throws Exception {
		HashMap<String,Object> map = new HashMap<String,Object>();
		
		HttpUtil.setResult(map, HttpUtil.HttpType.T200);
		
		map.put("searchVO",searchVO);
		
		PaginationInfo paginationInfo = ComUtil.setListPagingInfo(propertiesService, searchVO);
		
		List<AdminReTaskUserVO> list = adminReTaskService.selectUserList(searchVO);
		map.put("resultList", list);
		
		int totCnt = adminReTaskService.selectUserListTotCnt(searchVO);
		
		paginationInfo.setTotalRecordCount(totCnt);
		map.put("paginationInfo", paginationInfo);
		
		return map;
	}

	/**
	 * 업무목록
	 */
	@GetMapping("/api/admin/retask/task")
	public HashMap<String,Object> listTask(SearchVO searchVO) throws Exception {
		HashMap<String,Object> map = new HashMap<String,Object>();
		
		HttpUtil.setResult(map, HttpUtil.HttpType.T200);
		
		map.put("searchVO",searchVO);
		
		PaginationInfo paginationInfo = ComUtil.setListPagingInfo(propertiesService, searchVO);
		searchVO.setRecordCountPerPage(-1);
		
	//	List<AdminReTaskTaskVO> list = null;
		List<ReverTodoVO> revertList = null;
		List<AppTodoVO> appList = null;
		List<QaTodoVO> qaList = null;
		int totCnt = 0;
		if(StringUtil.isNotEmpty(searchVO.getUserId())) {
			if(searchVO.getSchAuth().equals("01")){
				revertList = revertTodoService.selectList(searchVO);
				map.put("resultList", ComUtil.checkListNull(revertList));
				totCnt = revertList==null ? 0 : revertList.size();
			}else if(searchVO.getSchAuth().equals("02")){
				appList = appTodoService.selectList(searchVO);
				map.put("resultList", ComUtil.checkListNull(appList));
				totCnt = appList==null ? 0 : appList.size();
			}else {
				qaList = qaTodoService.selectList(searchVO);
				map.put("resultList", ComUtil.checkListNull(qaList));
				totCnt = qaList==null ? 0 : qaList.size();
			}
			// list = adminReTaskService.selectTaskList(searchVO);
		}else {
			map.put("resultList", ComUtil.checkListNull(revertList));
		}

		
		paginationInfo.setTotalRecordCount(totCnt);
		map.put("paginationInfo", paginationInfo);
		
		return map;
	}

	/**
	 * 업무담당자 변경처리.
	 */
	@PostMapping("/api/admin/retask/task/change")
	public HashMap<String,Object> updateRetask(HttpServletRequest request, AdminReTaskTaskVO vo, AdminLogProgramVO adminLogProgramVO) throws Exception {
		HashMap<String,Object> map = new HashMap<String,Object>();
		SearchVO searchVO = new SearchVO();
		LoginVO loginInfo = LoginUtils.getLoginInfo(request);
		
		String trnLogSrno = null;
		trnLogSrno = adminLogProgramService.logProgramInsert(request, adminLogProgramVO, searchVO);
		
		vo.setTrnLogSrno(trnLogSrno);
		vo.setLstDbChgId(loginInfo.getId());
		
		HttpUtil.setResult(map, HttpUtil.HttpType.T200);
		
		//인계자 번호 : vo.getOldUserEno()
		//인수자 번호 : vo.getInptBizAlctCrpeEno()
		
		//유효성 체크
		if(StringUtil.isEmpty(vo.getOldUserEno()) || StringUtil.isEmpty(vo.getInptBizAlctCrpeEno())) {
			HttpUtil.setResult(map, HttpUtil.HttpType.T500);
			HttpUtil.setExResult(map, "-1", "업무를 변경할 담당자 정보가 부족합니다.");
			return map;
		}
		
		//인수자와 인계자가 동일하면, 인수인계 불가
		if(StringUtil.isEquals(vo.getOldUserEno(),vo.getInptBizAlctCrpeEno())) {
			HttpUtil.setResult(map, HttpUtil.HttpType.T500);
			HttpUtil.setExResult(map, "-6", "인계자와 인수자가 동일합니다.");
			return map;
		}
		
		//인수자 사용자 정보 가져오기
		AdminUserVO userInfo = null;
		searchVO.setSchUserNo(vo.getInptBizAlctCrpeEno());
		List<AdminUserVO> listUser = adminUserService.selectList(searchVO);
		if(listUser!=null && listUser.size() > 0) {
			userInfo = listUser.get(0);
		}

		//인수자 사용자 정보 체크.
		if(userInfo==null) {
			HttpUtil.setResult(map, HttpUtil.HttpType.T500);
			HttpUtil.setExResult(map, "-2", "인수자 정보가 존재하지 않습니다.");
			return map;
		}
		
		//인계자 사용자 정보 가져오기
		AdminUserVO oldUserInfo = null;
		searchVO.setSchUserNo(vo.getOldUserEno());
		List<AdminUserVO> listOldUser = adminUserService.selectList(searchVO);
		if(listOldUser!=null && listOldUser.size() > 0) {
			oldUserInfo = listOldUser.get(0);
		}
		
		//인계자 사용자 정보 체크.
		if(oldUserInfo==null) {
			HttpUtil.setResult(map, HttpUtil.HttpType.T500);
			HttpUtil.setExResult(map, "-3", "인계자 정보가 존재하지 않습니다.");
			return map;
		}

		/* 인수자와 인계자의 권한이 다르면, 작업 인수인계 불가 */
		if( StringUtil.isNotEquals(userInfo.getAiInptUserAutCd(), oldUserInfo.getAiInptUserAutCd()) ) {
			HttpUtil.setResult(map, HttpUtil.HttpType.T500);
			HttpUtil.setExResult(map, "-4", "인수자와 인계자의 권한이 다르면, 담당자 변경이 불가합니다.");
			return map;
		}
		
		/* 일반사용자는, 작업 인수인계 불가 */
		if( StringUtil.isEquals(userInfo.getAiInptUserAutCd(),"04") || StringUtil.isEquals(oldUserInfo.getAiInptUserAutCd(),"04") ) {
			HttpUtil.setResult(map, HttpUtil.HttpType.T500);
			HttpUtil.setExResult(map, "-5", "일반사용자는 작업자가 아닙니다.");
			return map;
		}
		
		//작업 변경처리
		String[] inptMstSrnos = request.getParameterValues("inptMstSrnos");
		String[] inptAtmcBizDscd = request.getParameterValues("inptAtmcBizDscds");
		
		if(inptMstSrnos!=null && inptMstSrnos.length > 0) {
			for (int i=0; i<inptMstSrnos.length; i++) { // String inptMstSrno : inptMstSrnos
				if(StringUtil.isNotEmpty(inptMstSrnos[i])) {
					vo.setInptMstSrno(inptMstSrnos[i]);
					vo.setInptAtmcBizDscd(inptAtmcBizDscd[i]);
					if(inptAtmcBizDscd[i].equals("3")) {
						vo.setQlasPrgYn("Y");
					}else {
						vo.setQlasPrgYn("N");
					}
					adminReTaskService.updateReTask(vo);
					adminReTaskService.updateReTaskHistory(vo);
					adminReTaskService.insertReTaskHistory(vo);
				}
			}
		}
		
		return map;
	}

	@PostMapping("/api/admin/retask/delete/qa")
	public HashMap<String,Object> qaDelete(HttpServletRequest request, AdminReTaskTaskVO vo, AdminLogProgramVO adminLogProgramVO) throws Exception {
		HashMap<String,Object> map = new HashMap<String,Object>();
		SearchVO searchVO = new SearchVO();
		HttpUtil.setResult(map, HttpUtil.HttpType.T200);
		LoginVO loginInfo = LoginUtils.getLoginInfo(request);
		vo.setLstDbChgId(loginInfo.getId());
		String trnLogSrno;
		trnLogSrno = adminLogProgramService.logProgramInsert(request, adminLogProgramVO, searchVO);
		vo.setTrnLogSrno(trnLogSrno);
		String[] inptMstSrnos = request.getParameterValues("inptMstSrno");
		if(inptMstSrnos!=null && inptMstSrnos.length > 0) {
			for (String inptMstSrno : inptMstSrnos) {
				if(StringUtil.isNotEmpty(inptMstSrno)) {
					vo.setInptMstSrno(inptMstSrno);
					//리스트 삭제처리.
					adminReTaskService.qaDelete(vo);
					adminReTaskService.updateMaster(vo);
				}
			}
		}	
		return map;
	}
	
	@PostMapping("/api/admin/retask/delete/sOne")
	public HashMap<String,Object> sOneDelete(HttpServletRequest request, AdminReTaskTaskVO vo, AdminLogProgramVO adminLogProgramVO) throws Exception {
		HashMap<String,Object> map = new HashMap<String,Object>();
		SearchVO searchVO = new SearchVO();
		HttpUtil.setResult(map, HttpUtil.HttpType.T200);
		LoginVO loginInfo = LoginUtils.getLoginInfo(request);
		vo.setLstDbChgId(loginInfo.getId());
		String trnLogSrno;
		trnLogSrno = adminLogProgramService.logProgramInsert(request, adminLogProgramVO, searchVO);
		vo.setTrnLogSrno(trnLogSrno);
		String[] inptMstSrnos = request.getParameterValues("inptMstSrno");
		if(inptMstSrnos!=null && inptMstSrnos.length > 0) {
			for (String inptMstSrno : inptMstSrnos) {
				if(StringUtil.isNotEmpty(inptMstSrno)) {
					vo.setInptMstSrno(inptMstSrno);
					//리스트 삭제처리.
					try {
						adminReTaskService.delete1Table(vo);
						adminReTaskService.delete2Table(vo);
						adminReTaskService.delete3Table(vo);
						adminReTaskService.delete4Table(vo);
						adminReTaskService.delete5Table(vo);
						adminReTaskService.delete6Table(vo);
						adminReTaskService.delete7Table(vo);
						adminReTaskService.delete8Table(vo);
					}catch (Exception e) {
						HttpUtil.setResult(map, HttpUtil.HttpType.T500);
					}

				}
			}
		}	
		return map;
	}
}