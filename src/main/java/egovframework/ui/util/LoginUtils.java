package egovframework.ui.util;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.security.crypto.bcrypt.BCrypt;
import org.springframework.stereotype.Component;

import com.woori.ajs.model.LoginVO;

import egovframework.ui.cmmn.ComUtil;
import egovframework.ui.cmmn.StringUtil;
import egovframework.ui.listener.CustomHttpSessionListener;

@Component
public class LoginUtils {
	
	/**
	 * BCrypt 를 이용한 Hash 값 리턴
	 * 
	 * @param oriString
	 * @return
	 */
	public static String getHash(String oriString) {
		String pw_hash = BCrypt.hashpw(oriString, BCrypt.gensalt(10));
		return pw_hash;
	}
	
	public static void setLoginInfo(HttpServletRequest request, LoginVO loginVO) {
		// 로그인 시 세션에 로그인 정보 저장
		request.getSession().setAttribute("loginUserInfo", loginVO);
		if(loginVO != null) {
			CustomHttpSessionListener.setSession(loginVO.getId(), request.getSession());
		}
	}

	public static LoginVO getLoginInfo(HttpServletRequest request) {
		LoginVO vo = null;
		if (request.getSession().getAttribute("loginUserInfo") instanceof LoginVO) {
			vo = (LoginVO)request.getSession().getAttribute("loginUserInfo");
		}
		
		return vo;
	}
	
	public static boolean isLogin(HttpServletRequest request) {
		LoginVO loginVO = getLoginInfo(request);
		return loginVO==null ? false : true;
	}
	
	/**
	 * 특정 url 이 관리자 url 인지 여부 체크.
	 * @param checkUrl		: 체크할 url, 현재페이지면 request.getRequestURL().toString().toLowerCase();
	 * 						  ComUtil.getUrl(request)
	 * @return				: 관리자 페이지면 true, 아니면 false
	 */
	public static boolean isAdminUrl(String checkUrl) {
		if(StringUtil.isEmpty(checkUrl)) {
			return false;
		}
		
		List<String> adminUrls = new ArrayList<String>();
		adminUrls.add("/admin/");

		boolean adminCheck = false;

		for(int i=0;i<adminUrls.size();i++) {
			String adminUrl = adminUrls.get(i);
			if(checkUrl.contains(adminUrl)) {
				adminCheck = true;
				break;
			}
		}
		
		return adminCheck;
	}

	/**
	 * 현재 url 이 관리자 url 인지 여부 체크.
	 * @return				: 관리자 페이지면 true, 아니면 false
	 */
	public static boolean isAdminUrl(HttpServletRequest request) {
		return isAdminUrl(ComUtil.getUrl(request));
	}

}