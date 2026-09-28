package com.woori.ajs.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

@Controller
public class StatUserController {
	
	@RequestMapping(value = "/stat/user")
	public ModelAndView detail(ModelAndView mv) throws Exception {
		mv.setViewName("blank/stat/user/list");
		
		return mv;
	}
	
}