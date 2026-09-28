package com.woori.ajs.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

@Controller
public class TaskLogResultController {
	
	@RequestMapping(value = "/task/log/result")
	public ModelAndView detail(ModelAndView mv) throws Exception {
		mv.setViewName("blank/task/log/result/list");
		
		return mv;
	}
	
}