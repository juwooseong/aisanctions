package com.woori.ajs.controller;

import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import egovframework.ui.cmmn.PropUtil;
import egovframework.ui.cmmn.StringUtil;
import egovframework.ui.util.LoginUtils;

@Controller
public class CommonMainController {

	@RequestMapping(value = "/index")
	public String Index() throws Exception {
		return "main/index";
	}
	
	@RequestMapping(value = "/login/sso/prx")
	public String ssoTest(HttpServletRequest request) throws Exception {
		
		String proxyUrl = PropUtil.PORTAL_PRC;
		if(!LoginUtils.isLogin(request)) {
			//sso proxy 서버로 redirect
			//프록시 서버에서 우리쪽에서 정의한 프록시 주소(/login/sso/prx)와 비표준 주소(/login/sso/nst) 둘중에,
			//상황에 따라서 선택을 해서 다시 로그인 값을 포함시켜서 보내줌.
			//로그인 처리는 해당 페이지에서 처리함.
			
			return StringUtil.concat(new String[]{"redirect:",proxyUrl});
		}
//		return "main/index";
		return StringUtil.concat(new String[]{"redirect:",proxyUrl});
	}
	
}