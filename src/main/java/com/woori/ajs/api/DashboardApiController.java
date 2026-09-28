package com.woori.ajs.api;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springmodules.validation.commons.DefaultBeanValidator;

import com.woori.ajs.model.DashboardVO;
import com.woori.ajs.model.LoginVO;
import com.woori.ajs.model.SearchVO;
import com.woori.ajs.service.DashboardService;
import com.woori.ajs.service.QaTargetBatchService;

import egovframework.rte.fdl.property.EgovPropertyService;
import egovframework.ui.cmmn.DateUtil;
import egovframework.ui.cmmn.HttpUtil;
import egovframework.ui.util.LoginUtils;

@RestController
public class DashboardApiController {

	/** dashboardService */
	@Resource(name = "dashboardService")
	private DashboardService dashboardService;

	@Resource(name = "qaTargetBatchService")
	private QaTargetBatchService qaTargetBatchService;	
	
	/** EgovPropertyService */
	@Resource(name = "propertiesService")
	protected EgovPropertyService propertiesService;

	/** Validator */
	@Resource(name = "beanValidator")
	protected DefaultBeanValidator beanValidator;

	@Resource(name = "systemFileProperties")
	protected Properties sysProp;
	
	@PostMapping("/api/dashboard")
	public HashMap<String,Object> list(SearchVO searchVO, HttpServletRequest request) throws Exception {
		HashMap<String,Object> map = new HashMap<String,Object>();
		
		LoginVO loginInfo = LoginUtils.getLoginInfo(request);
		
		HttpUtil.setResult(map, HttpUtil.HttpType.T200);
		
		Calendar cal = Calendar.getInstance();
		cal.setTime(new Date());
		SimpleDateFormat df = new SimpleDateFormat("yyyyMMdd" , java.util.Locale.KOREA);
		
		String dDay = df.format(cal.getTime());
		
		searchVO.setInptRcpDt(dDay);
		
		// 영업일 조회
		String businessDate = qaTargetBatchService.selectRecentDate(searchVO);
		map.put("businessDate", businessDate);
		
		searchVO.setInptRcpDt(businessDate);
		searchVO.setUserId(loginInfo.getId());
		searchVO.setSchAuth(loginInfo.getAuth());
		
		// 권한이 심사자 : 01, 결재자 : 02, QA : 03일때만 조회
		String userAuth = loginInfo.getAuth();
		if ("01".equals(userAuth) || "02".equals(userAuth) || "03".equals(userAuth)) {
			
			// 대시보드 내업무Todo
			searchVO.setSchGbn("todo");
			List<DashboardVO> todoList = dashboardService.taskList(searchVO);
			map.put("todoList", todoList);
			
			// 진행업무별 현재상태 조회
			searchVO.setSchGbn("status");
			List<DashboardVO> statusList = dashboardService.taskList(searchVO);
			map.put("statusList", statusList);
			
		}
		// 심사현황 조회
		List<DashboardVO> inptList = dashboardService.inptList(searchVO);
		map.put("inptList", inptList);
		
		// 국가별 수출입 현황
		List<DashboardVO> impExpList = dashboardService.impExpList(searchVO);
		map.put("impExpList", impExpList);
		

		return map;
	}
	
}