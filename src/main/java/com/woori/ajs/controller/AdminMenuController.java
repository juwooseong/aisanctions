package com.woori.ajs.controller;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.woori.ajs.model.AdminMenuVO;
import com.woori.ajs.model.CommonCodeVO;
import com.woori.ajs.model.SearchVO;
import com.woori.ajs.service.AdminMenuService;
import com.woori.ajs.service.CommonCodeService;

@Controller
public class AdminMenuController {
	/** 공통 서비스 **/
	@Resource(name = "commonCodeService")
	private CommonCodeService commonCodeService;
	
	@Resource(name = "adminMenuService")
	private AdminMenuService adminMenuService;
	
	@RequestMapping(value = "/admin/menu")
	public ModelAndView detail(ModelAndView mv) throws Exception {
		
		SearchVO vo = new SearchVO();
		vo.setAiInptGrpCd("120");
		List<CommonCodeVO> authCodeList = commonCodeService.selectAllCommonCodeList(vo);
		mv.addObject("authCodeList", authCodeList);
		
		mv.setViewName("blank/admin/menu/list");
		
		return mv;
	}
	
	@RequestMapping(value = "/admin/menu/menuReg")
	public ModelAndView menuReg(ModelAndView mv) throws Exception {
		List<AdminMenuVO> adminMenuList = adminMenuService.selectListTopMenu();
		mv.addObject("adminMenuList", adminMenuList);
		mv.setViewName("blank/admin/menu/menuReg");
		return mv;
	}
}