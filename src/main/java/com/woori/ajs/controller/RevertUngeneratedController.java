package com.woori.ajs.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.woori.ajs.model.SearchVO;

@Controller
public class RevertUngeneratedController {

	@RequestMapping(value = "/revert/ungenerated")
	public ModelAndView detail(ModelAndView mv) throws Exception{
		
		mv.setViewName("blank/revert/ungenerated/list");
		
		return mv;
	}
	
}
