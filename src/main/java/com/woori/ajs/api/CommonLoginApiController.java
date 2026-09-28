package com.woori.ajs.api;

import java.time.ZoneId;
import java.time.ZonedDateTime;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springmodules.validation.commons.DefaultBeanValidator;

import com.woori.ajs.model.AdminLogLoginVO;
import com.woori.ajs.model.LoginVO;
import com.woori.ajs.service.AdminLogLoginService;
import com.woori.ajs.service.CommonLoginService;

import egovframework.rte.fdl.property.EgovPropertyService;
import egovframework.ui.cmmn.HttpUtil;
import egovframework.ui.cmmn.SsoUtil;
import egovframework.ui.cmmn.StringUtil;
import egovframework.ui.listener.CustomHttpSessionListener;
import egovframework.ui.util.LoginUtils;

@RestController
public class CommonLoginApiController {

	@Resource(name = "commonLoginService")
	private CommonLoginService commonLoginService;
	
	@Resource(name = "adminLogLoginService")
	private AdminLogLoginService adminLogLoginService;
	
	/** EgovPropertyService */
	@Resource(name = "propertiesService")
	protected EgovPropertyService propertiesService;

	/** Validator */
	@Resource(name = "beanValidator")
	protected DefaultBeanValidator beanValidator;

	@Resource(name = "systemFileProperties")
	protected Properties sysProp;

	@PostMapping("/api/common/login")
	public HashMap<String,Object> login(HttpServletRequest request, LoginVO vo) throws Exception {
		HashMap<String,Object> map = new HashMap<String,Object>();
		
		HttpUtil.setResult(map, HttpUtil.HttpType.T200);
		
		String id = StringUtil.nvl(vo.getId());
		if(StringUtil.isEmpty(id)) {
			HttpUtil.setResult(map, HttpUtil.HttpType.T500);
			HttpUtil.setResultMsg(map, "정보가 부족합니다.");
			return map;
		}
		
		LoginVO userInfo = commonLoginService.selectLogin(vo);
		
		if(userInfo!=null && id.equals(userInfo.getId())) {
			
			// 심사 사용자가 아닌경우
			String aiInptUserYn = userInfo.getAiInptUserYn();
			
			if ("N".equals(aiInptUserYn)) {
				
				//로그인 실패이력
				AdminLogLoginVO adminLogLoginVO = new AdminLogLoginVO();
				adminLogLoginVO.setAiInptLginUserMchrNm(request.getHeader("User-Agent"));
				adminLogLoginVO.setAiInptLginUserNo(id);
				adminLogLoginVO.setAiInptLginUsgIpad(request.getRemoteAddr());
				adminLogLoginVO.setLstDbChgId(id);
				adminLogLoginVO.setAiInptLginYn("N");
				adminLogLoginService.insert(adminLogLoginVO);
				
				HttpUtil.setResult(map, HttpUtil.HttpType.T401);
				HttpUtil.setResultMsg(map, "미등록/미사용 계정입니다.");
				
			} else {
				
				LoginUtils.setLoginInfo(request, userInfo);
				
				//권한에 따른 설정
				String auth = StringUtil.nvl(userInfo.getAuth()).trim();
				String name = StringUtil.nvl(userInfo.getName()).trim();
				String adminYN = StringUtil.nvl(userInfo.getAdminYN()).trim();
				String absence = StringUtil.nvl(userInfo.getAiInptUserFaReYn()).trim();
				String eno = StringUtil.nvl(userInfo.getEno()).trim();
				
				//접속시간
				//String loginDtm = LocalDate.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
				ZonedDateTime seoulDateTime = ZonedDateTime.now(ZoneId.of("Asia/Seoul"));
				String loginDtm = seoulDateTime.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
				
				//최종접속시간
				String finloginDtm = commonLoginService.selectLoginTime(vo);
				map.put("finloginDtm", finloginDtm);
				
				map.put("auth", auth);
				map.put("adminYN", adminYN);
				map.put("name", name);
				map.put("loginDtm", loginDtm);
				map.put("absence", absence);
				map.put("eno", eno);
				
				//로그인 성공이력
				AdminLogLoginVO adminLogLoginVO = new AdminLogLoginVO();
				adminLogLoginVO.setAiInptLginUserMchrNm(request.getHeader("User-Agent"));
				adminLogLoginVO.setAiInptLginUserNo(userInfo.getId());
				adminLogLoginVO.setAiInptLginUsgIpad(request.getRemoteAddr());
				adminLogLoginVO.setLstDbChgId(userInfo.getId());
				adminLogLoginVO.setAiInptLginYn("Y");
				adminLogLoginService.insert(adminLogLoginVO);
			}
			
			
		} else {

			//로그인 실패이력
			AdminLogLoginVO adminLogLoginVO = new AdminLogLoginVO();
			adminLogLoginVO.setAiInptLginUserMchrNm(request.getHeader("User-Agent"));
			adminLogLoginVO.setAiInptLginUserNo(id);
			adminLogLoginVO.setAiInptLginUsgIpad(request.getRemoteAddr());
			adminLogLoginVO.setLstDbChgId(id);
			adminLogLoginVO.setAiInptLginYn("N");
			adminLogLoginService.insert(adminLogLoginVO);
			
			//응답정보
			HttpUtil.setResult(map, HttpUtil.HttpType.T401);
			HttpUtil.setResultMsg(map, "로그인 정보가 일치하지 않습니다.");
		}
		
		return map;
	}
	
	@PostMapping("/api/common/getMyInfo")
	public HashMap<String,Object> getMyInfo(HttpServletRequest request) throws Exception {
		HashMap<String,Object> map = new HashMap<String,Object>();
		
		HttpUtil.setResult(map, HttpUtil.HttpType.T200);
		
		if(!LoginUtils.isLogin(request)) {
			HttpUtil.setResult(map, HttpUtil.HttpType.T403);
			return map;
		}
		
		LoginVO vo = new LoginVO();
		
		vo.setId(LoginUtils.getLoginInfo(request).getId());

		LoginVO userInfo = commonLoginService.selectLogin(vo);

		//권한에 따른 설정
		String auth = StringUtil.nvl(userInfo.getAuth()).trim();
		String name = StringUtil.nvl(userInfo.getName()).trim();
		String adminYN = StringUtil.nvl(userInfo.getAdminYN()).trim();
		String absence = StringUtil.nvl(userInfo.getAiInptUserFaReYn()).trim();
		String eno = StringUtil.nvl(userInfo.getEno()).trim();
		
		//접속시간
		ZonedDateTime seoulDateTime = ZonedDateTime.now(ZoneId.of("Asia/Seoul"));
		String loginDtm = seoulDateTime.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
		
		//최종접속시간
		String finloginDtm = commonLoginService.selectLoginTime(vo);
		map.put("finloginDtm", finloginDtm);
		
		map.put("auth", auth);
		map.put("adminYN", adminYN);
		map.put("name", name);
		map.put("loginDtm", loginDtm);
		map.put("absence", absence);
		map.put("eno", eno);
		
		return map;
	}
	
	/**
	 * 로그인 인터셉터에서, /api url 호출시, 로그인 체크, json 반환.
	 * @param request
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	@GetMapping("/api/common/login/forbidden")
	public HashMap<String,Object> login2() throws Exception {
		HashMap<String,Object> map = new HashMap<String,Object>();
		
		HttpUtil.setResult(map, HttpUtil.HttpType.T403);
		HttpUtil.setExResult(map, "-1", "세션이 만료되었습니다. 로그인화면으로 이동합니다.");
		
		return map;
	}

	@RequestMapping("/api/common/logout")
	public HashMap<String,Object> logout(HttpServletRequest request) throws Exception {
		HashMap<String,Object> map = new HashMap<String,Object>();

		HttpUtil.setResult(map, HttpUtil.HttpType.T200);
		
		LoginUtils.setLoginInfo(request, null);
		
		request.getSession().invalidate();
		
		return map;
	}

	@RequestMapping("/api/common/login/check")
	public HashMap<String,Object> loginCheck(HttpServletRequest request) throws Exception {
		HashMap<String,Object> map = new HashMap<String,Object>();

		HttpUtil.setResult(map, HttpUtil.HttpType.T200);
		
		LoginVO loginVo = LoginUtils.getLoginInfo(request);
		if(loginVo == null) {
			HttpUtil.setResult(map, HttpUtil.HttpType.T403);
			return map;
		}
		
		return map;
	}

}