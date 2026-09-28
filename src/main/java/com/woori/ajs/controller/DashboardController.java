package com.woori.ajs.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

@Controller
public class DashboardController {
	private String toDay = "";
	
	@RequestMapping(value = "/dashboard/dashboard")
	public ModelAndView detail(ModelAndView mv) throws Exception {
		mv.setViewName("blank/dashboard/dashboard");
		
		return mv;
	}

	public void setToday(String toDay) {
		this.toDay = toDay;
	}
	
}