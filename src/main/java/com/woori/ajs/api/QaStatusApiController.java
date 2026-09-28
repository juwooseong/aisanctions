package com.woori.ajs.api;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springmodules.validation.commons.DefaultBeanValidator;

import com.woori.ajs.model.SearchVO;
import com.woori.ajs.model.QaStatusVO;
import com.woori.ajs.service.QaStatusService;

import egovframework.rte.fdl.property.EgovPropertyService;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import egovframework.ui.cmmn.ComUtil;
import egovframework.ui.cmmn.HttpUtil;
import egovframework.ui.util.LoginUtils;

@RestController
public class QaStatusApiController {
	/** qaStatusService */
	@Resource(name = "qaStatusService")
	private QaStatusService qaStatusService;

	/** EgovPropertyService */
	@Resource(name = "propertiesService")
	protected EgovPropertyService propertiesService;

	/** Validator */
	@Resource(name = "beanValidator")
	protected DefaultBeanValidator beanValidator;

	@Resource(name = "systemFileProperties")
	protected Properties sysProp;
	
	@GetMapping("/api/qa/status")
	public HashMap<String,Object> list(SearchVO searchVO, HttpServletRequest request) throws Exception {
		HashMap<String,Object> map = new HashMap<String,Object>();
		HttpUtil.setResult(map, HttpUtil.HttpType.T200);
		
		String userId = LoginUtils.getLoginInfo(request).getId();
		searchVO.setUserId(userId);
		PaginationInfo paginationInfo = ComUtil.setListPagingInfo(propertiesService, searchVO);
		
		List<QaStatusVO> list = qaStatusService.selectList(searchVO);
		int totCnt = qaStatusService.selectListTotCnt(searchVO);
		paginationInfo.setTotalRecordCount(totCnt);
		
		map.put("searchVO",searchVO);
		map.put("paginationInfo",paginationInfo);
		map.put("resultList",list);

		return map;
	}
	

	@PostMapping("/api/qa/status/dateSet")
	public HashMap<String,Object> dateSet(SearchVO searchVO, HttpServletRequest request) throws Exception {
		HashMap<String,Object> map = new HashMap<String,Object>();
		HttpUtil.setResult(map, HttpUtil.HttpType.T200);
		String hldyDscd;
		String startDate;
		while(true) {
			hldyDscd = qaStatusService.checkDate(searchVO);
			if(!"0".equals(hldyDscd)) { // 공휴일 주말 등등일때
				startDate = checkDate(searchVO);
				searchVO.setSchSdate1(startDate);
			}else {
				break;
			}
		}	
		map.put("startDate",searchVO.getSchSdate1());
		return map;
	}

	
	
	public String checkDate(SearchVO searchVO) throws ParseException {
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd", java.util.Locale.KOREA);
		String dataCheck = searchVO.getSchSdate1(); 
		String startDate;
		Date date = formatter.parse(dataCheck);
		Calendar cal = new GregorianCalendar(Locale.KOREA);
		cal.setTime(date);
		cal.add(Calendar.DATE, -1);
		startDate = formatter.format(cal.getTime());
		return startDate;
	}
}
