package com.woori.ajs.api;

import java.util.HashMap;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RestController;

import com.woori.ajs.model.AdminLogProgramVO;
import com.woori.ajs.model.LoginVO;
import com.woori.ajs.model.SearchVO;
import com.woori.ajs.service.AdminLogProgramService;

import egovframework.ui.cmmn.HttpUtil;
import egovframework.ui.cmmn.StringUtil;
import egovframework.ui.util.LoginUtils;

@RestController
public class CommonMainApiController {

	@Resource(name = "adminLogProgramService")
	private AdminLogProgramService adminLogProgramService;

	/**
	 * 프로그램 로그 이력 등록 API 메서드
	 */
	@PostMapping("/api/common/main/log/program/insert")
	public HashMap<String,Object> logProgramInsert(SearchVO searchVO, HttpServletRequest request, AdminLogProgramVO adminLogProgramVO) throws Exception {
		HashMap<String,Object> map = new HashMap<String,Object>();
		
		HttpUtil.setResult(map, HttpUtil.HttpType.T200);
		String userId = LoginUtils.getLoginInfo(request).getId();
		searchVO.setUserId(userId);
		
		if(StringUtil.isEmpty(adminLogProgramVO.getAiInptCnctScrnNo()) || StringUtil.isEmpty(adminLogProgramVO.getAiInptCnctActiCd())) {
			HttpUtil.setResult(map, HttpUtil.HttpType.T500);
			HttpUtil.setResultMsg(map, "정보가 부족합니다.");
			return map;
		}
		
		//프로그램 이력 쌓기
		adminLogProgramService.logProgramInsert(request, adminLogProgramVO, searchVO);
		
		return map;
	}
	
}