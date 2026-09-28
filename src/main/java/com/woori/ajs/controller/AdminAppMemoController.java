package com.woori.ajs.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

@Controller
public class AdminAppMemoController {
	
	@RequestMapping(value = "/admin/app/memo")
	public ModelAndView detail(ModelAndView mv) throws Exception {
		mv.setViewName("blank/admin/app/memo/list");
		
		return mv;
	}
	
}