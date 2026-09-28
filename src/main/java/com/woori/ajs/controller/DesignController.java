package com.woori.ajs.controller;

import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

@Controller
public class DesignController {

	@RequestMapping(value = "design/*/*")
	public ModelAndView design_1(ModelAndView mv, HttpServletRequest request) throws Exception {
		
		mv.setViewName("none/none");
		
		return mv;
	}
	
	@RequestMapping(value = "design/*/*/*")
	public ModelAndView design_2(ModelAndView mv, HttpServletRequest request) throws Exception {
		
		mv.setViewName("none/none");
		
		return mv;
	}
	
}
