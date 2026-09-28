package com.woori.ajs.filters;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.method.HandlerMethod;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import com.woori.ajs.controller.DashboardController;
import com.woori.ajs.model.LoginVO;

import egovframework.ui.cmmn.ComUtil;
import egovframework.ui.cmmn.DateUtil;
import egovframework.ui.cmmn.PropUtil;
import egovframework.ui.cmmn.StringUtil;
import egovframework.ui.util.LoginUtils;

public class AuthenticationInterceptor extends HandlerInterceptorAdapter {

	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
		
		if (handler instanceof HandlerMethod) {
			HandlerMethod method = (HandlerMethod)handler;
			
			Object bean = method.getBean();
			
			if (bean instanceof DashboardController) {
				DashboardController dashboard = (DashboardController)bean;
				dashboard.setToday(DateUtil.getFormatDate("yyyyMMdd"));
			}
		}
		
		//로그인 안되어있으면
		if(!LoginUtils.isLogin(request)) {
			String curUrl = StringUtil.nvl(ComUtil.getUrl(request));
			if(curUrl.contains("/api/")) {
				response.sendRedirect("/api/common/login/forbidden");
			} else {
				//UI화면 호출시, 로그인 세션이 없으면, 로그인 페이지 이동
//				response.sendRedirect("/login");
				response.sendRedirect(PropUtil.PORTAL_LOGIN);
			}
			return false;
		}
		
		//관리자 권한이 없는데, 관리자 페이지 접근시 오류처리
		LoginVO loginVO = LoginUtils.getLoginInfo(request);
		String adminYN = StringUtil.nvl(loginVO.getAdminYN(),"N");
		if(!"Y".equals(adminYN)) {
			if(LoginUtils.isAdminUrl(request)) {
				response.sendRedirect("/error/400");
				return false;
			}
		}
		
		//properties 설정(jsp 등에서 사용)
		request.setAttribute("env_mode", PropUtil.MODE);
		request.setAttribute("portal_login", PropUtil.PORTAL_LOGIN);
		request.setAttribute("env_mode_name", PropUtil.MODE_NAME);
		request.setAttribute("domain", PropUtil.DOMAIN);
		request.setAttribute("bpr_url", PropUtil.BPR_URL);
		request.setAttribute("grid_height", PropUtil.GRID_HEIGHT);
		request.setAttribute("curtime", DateUtil.getFormatDate("yyyyMMddHHmmss"));
		
		return true;
	}
	
	@Override
	public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler,
			ModelAndView modelAndView) throws Exception {
		super.postHandle(request, response, handler, modelAndView);
	}
	
}