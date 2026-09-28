package com.woori.ajs.controller;

import java.time.ZoneId;
import java.time.ZonedDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Random;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.json.simple.JSONObject;
import org.json.simple.JSONValue;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.woori.ajs.model.AdminLogLoginVO;
import com.woori.ajs.model.LoginVO;
import com.woori.ajs.service.AdminLogLoginService;
import com.woori.ajs.service.CommonLoginService;

import egovframework.ui.cmmn.CastUtil;
import egovframework.ui.cmmn.Encryptor;
import egovframework.ui.cmmn.PropUtil;
import egovframework.ui.cmmn.StringUtil;
import egovframework.ui.util.LoginUtils;

@Controller
public class CommonLoginController {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(CommonLoginController.class);

	@Resource(name = "commonLoginService")
	private CommonLoginService commonLoginService;
	
	@Resource(name = "adminLogLoginService")
	private AdminLogLoginService adminLogLoginService;

	@RequestMapping(value = "/login/sso/nst")
	public ModelAndView loginSsoNst(ModelAndView model, HttpServletRequest request) throws Exception {
		
		model.addObject("domain",PropUtil.DOMAIN);
		
		String id = "" ;
	    String rand = "";
	    String decStrAES = "";
		
	    String encryptValue = request.getParameter("FINDATA");
		
		//복호화 처리
		try {
			String xKeyValue = request.getHeader("x-forwarded-for");
			String encryptionKey = Encryptor.getEncryptionKey(xKeyValue, rand);
			decStrAES = Encryptor.decryptAES(encryptValue, encryptionKey);
		} catch (Exception ex) {
			LOGGER.error("사용자 ID 복호화에 실패했습니다.");
			id = null;
			model.setViewName("redirect:/error/500");
			return model;
		}
		
		String jDataStr = CastUtil.objToStr(decStrAES);
		Object jDataObj = JSONValue.parse(jDataStr);
		JSONObject jsonObj = CastUtil.objToJSONObj(jDataObj);
		
		String userID = jsonObj.get("USER_ID").toString();
		String ENT_CODE = jsonObj.get("ENT_CODE").toString(); // 회사코드
		String UNIT_CODE = jsonObj.get("UNIT_CODE").toString(); // 부서 코드
		String REAL_UNIT_CODE = jsonObj.get("REAL_UNIT_CODE").toString(); // 점코드
		
		id = userID;
		model.addObject("id",id);
		
		//프록시 방식으로 로그인 처리
		model.setViewName("blank/login/proc");
		
		//통합로그인 프록시를 갔다가, 로그인 사용자번호를 답아서, 여기로 회귀.
		
		// sso 사용자 정보 파라미터 받아오기 (프록시 헤더값과, 비표준 방식으로, 두가지 방식으로 파라미터 받아오는 함수)
		// 먼저 프록시 방식으로 파라미터를 받아오고, 널이면, 다시 비표준 방식으로 파라미터를 받아옴.
		
		if(StringUtil.isEmpty(id)) {
			//통합그룹웨어로 이동
			model.addObject("id","");
			model.setViewName("redirect:/error/401");
			return model;
		}
		
		LoginVO vo = new LoginVO();
		vo.setId(id);
		LoginVO userInfo = commonLoginService.selectLogin(vo);
		
		if(userInfo!=null && id.equals(userInfo.getId())) {
			LoginUtils.setLoginInfo(request, userInfo);
			
			//권한에 따른 설정
			String auth = StringUtil.nvl(userInfo.getAuth()).trim();
			String name = StringUtil.nvl(userInfo.getName()).trim();
			String adminYN = StringUtil.nvl(userInfo.getAdminYN()).trim();
			
			//접속시간
			ZonedDateTime seoulDateTime = ZonedDateTime.now(ZoneId.of("Asia/Seoul"));
			String loginDtm = seoulDateTime.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
			
			//최종접속시간
			String finloginDtm = commonLoginService.selectLoginTime(vo);
			model.addObject("finloginDtm", finloginDtm);
			
			model.addObject("auth", auth);
			model.addObject("adminYN", adminYN);
			model.addObject("name", name);
			model.addObject("loginDtm", loginDtm);
			
			//로그인 성공이력
			AdminLogLoginVO adminLogLoginVO = new AdminLogLoginVO();
			adminLogLoginVO.setAiInptLginUserMchrNm(request.getHeader("User-Agent"));
			adminLogLoginVO.setAiInptLginUserNo(userInfo.getId());
			adminLogLoginVO.setAiInptLginUsgIpad(request.getRemoteAddr());
			adminLogLoginVO.setLstDbChgId(userInfo.getId());
			adminLogLoginVO.setAiInptLginYn("Y");
			adminLogLoginService.insert(adminLogLoginVO);
			
		} else {
			
			//로그인 실패이력
			AdminLogLoginVO adminLogLoginVO = new AdminLogLoginVO();
			adminLogLoginVO.setAiInptLginUserMchrNm(request.getHeader("User-Agent"));
			adminLogLoginVO.setAiInptLginUserNo(id);
			adminLogLoginVO.setAiInptLginUsgIpad(request.getRemoteAddr());
			adminLogLoginVO.setLstDbChgId(id);
			adminLogLoginVO.setAiInptLginYn("N");
			adminLogLoginService.insert(adminLogLoginVO);
			
			//통합그룹웨어로 이동
			model.addObject("id","");
			model.setViewName("redirect:/error/401");
		}
		
		return model;
	}
	
	@RequestMapping(value = "/sso/prx")
	public ModelAndView loginSsoPrx(ModelAndView model, HttpServletRequest request) throws Exception {
		
		model.setViewName("blank/login/sso");
		
		model.addObject("domain",PropUtil.DOMAIN);
		
		String id = "" ;
	    String rand = "";
		
		String SSOUserID = request.getHeader("USER_ID");
		if (SSOUserID == null || "".equals(SSOUserID)) {
			SSOUserID = request.getHeader("user_id");
		}
		
		if (SSOUserID == null || "".equals(SSOUserID)) {
			
			LOGGER.error("Header에서 사용자 ID를 얻어올 수 없습니다.");
			model.setViewName("redirect:/error/500");
			return model;
			
		} else {
			
			String xKeyValue = request.getHeader("x-forwarded-for");
			if(xKeyValue != null && !"".equals(xKeyValue) ){
				if(xKeyValue.contains(":")){
					xKeyValue = xKeyValue.substring(0,xKeyValue.indexOf(":"));
				}
			} else {
				LOGGER.error("Header에서 client IP Address 를 얻어올 수 없습니다.");
				model.setViewName("redirect:/error/500");
				return model;
			}
			Random ran = new Random();
			int tmpMax = 999999999;
			rand = String.valueOf(ran.nextInt(tmpMax));
			
			try {
				String encryptionKey = Encryptor.getEncryptionKey(xKeyValue, rand);
				id = Encryptor.encryptAES(SSOUserID, encryptionKey);
			} catch (Exception ex) {
				LOGGER.error("사용자 ID 암호화에 실패했습니다.");
			}
			
		}
		
		model.addObject("id",id);
		model.addObject("rand",rand);
		
		return model;
	}
	
	@RequestMapping(value = "/login/sso/prx2")
	public ModelAndView loginSsoPrx2(ModelAndView model, HttpServletRequest request) throws Exception {
		
		String SSOUserID = request.getParameter("userID") ;
		String id = "";
		String rand = request.getParameter("rand") ;
		String xKeyValue = "";
		
		
		xKeyValue = request.getRemoteAddr();
		if(xKeyValue == null || "".equals(xKeyValue)){
			LOGGER.error("Header에서 client IP Address 를 얻어올 수 없습니다.");
			model.setViewName("redirect:/error/500");
			return model;
		}
		
		//복호화 처리
		try {
			String encryptionKey = Encryptor.getEncryptionKey(xKeyValue, rand);
			id = Encryptor.decryptAES(SSOUserID, encryptionKey);
		} catch (Exception ex) {
			LOGGER.error("사용자 ID 복호화에 실패했습니다.");
			SSOUserID = null;
			model.setViewName("redirect:/error/500");
			return model;
		}
		
		model.addObject("id",SSOUserID);
		
		//프록시 방식으로 로그인 처리
		
		model.setViewName("blank/login/proc");
		
		//통합로그인 프록시를 갔다가, 로그인 사용자번호를 답아서, 여기로 회귀.
		
		// sso 사용자 정보 파라미터 받아오기 (프록시 헤더값과, 비표준 방식으로, 두가지 방식으로 파라미터 받아오는 함수)
		// 먼저 프록시 방식으로 파라미터를 받아오고, 널이면, 다시 비표준 방식으로 파라미터를 받아옴.
		
		if(StringUtil.isEmpty(id)) {
			//통합그룹웨어로 이동
//			model.addObject("id","");
			model.setViewName("redirect:/error/401");
			return model;
		}
		
		LoginVO vo = new LoginVO();
		vo.setId(id);
		LoginVO userInfo = commonLoginService.selectLogin(vo);
		
		if(userInfo!=null && id.equals(userInfo.getId())) {
			LoginUtils.setLoginInfo(request, userInfo);
			
			//권한에 따른 설정
			String auth = StringUtil.nvl(userInfo.getAuth()).trim();
			String name = StringUtil.nvl(userInfo.getName()).trim();
			String adminYN = StringUtil.nvl(userInfo.getAdminYN()).trim();
			
			//접속시간
			ZonedDateTime seoulDateTime = ZonedDateTime.now(ZoneId.of("Asia/Seoul"));
			String loginDtm = seoulDateTime.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
			
			//최종접속시간
			String finloginDtm = commonLoginService.selectLoginTime(vo);
			model.addObject("finloginDtm", finloginDtm);
			
			model.addObject("auth", auth);
			model.addObject("adminYN", adminYN);
			model.addObject("name", name);
			model.addObject("loginDtm", loginDtm);
			
			//로그인 성공이력
			AdminLogLoginVO adminLogLoginVO = new AdminLogLoginVO();
			adminLogLoginVO.setAiInptLginUserMchrNm(request.getHeader("User-Agent"));
			adminLogLoginVO.setAiInptLginUserNo(userInfo.getId());
			adminLogLoginVO.setAiInptLginUsgIpad(request.getRemoteAddr());
			adminLogLoginVO.setLstDbChgId(userInfo.getId());
			adminLogLoginVO.setAiInptLginYn("Y");
			adminLogLoginService.insert(adminLogLoginVO);
			
		} else {
			
			//로그인 실패이력
			AdminLogLoginVO adminLogLoginVO = new AdminLogLoginVO();
			adminLogLoginVO.setAiInptLginUserMchrNm(request.getHeader("User-Agent"));
			adminLogLoginVO.setAiInptLginUserNo(id);
			adminLogLoginVO.setAiInptLginUsgIpad(request.getRemoteAddr());
			adminLogLoginVO.setLstDbChgId(id);
			adminLogLoginVO.setAiInptLginYn("N");
			adminLogLoginService.insert(adminLogLoginVO);
			
			//통합그룹웨어로 이동
			model.addObject("id","");
			model.setViewName("redirect:/error/401");
		}
		
		return model;
	}
	

	@RequestMapping("/logout")
	public String logout(HttpServletRequest request) throws Exception {
		LoginUtils.setLoginInfo(request, null);
		
		request.getSession().invalidate();
		
//		return "redirect:/login";
		return "redirect:" + PropUtil.PORTAL_LOGIN;
	}

}