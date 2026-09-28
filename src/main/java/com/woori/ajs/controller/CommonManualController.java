package com.woori.ajs.controller;

import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

@Controller
public class CommonManualController {

	@Resource(name = "systemFileProperties")
	protected Properties sysProp;
	
	
	@RequestMapping(value = "/common/manual")
	public ModelAndView commonManual(ModelAndView mv, HttpServletRequest request) throws Exception {
		mv.setViewName("full/common/manual");
		
		String adminYN = request.getParameter("adminFlag");
		String uploadMaxSize = sysProp.getProperty("upload.maxSize");
		
		mv.addObject("adminYN", adminYN);
		mv.addObject("uploadMaxSize", uploadMaxSize);
		
		return mv;
	}
}
