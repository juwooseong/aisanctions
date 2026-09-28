package com.woori.ajs.controller;

import java.util.Properties;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import egovframework.rte.fdl.property.EgovPropertyService;

@Controller
public class AdminCodeController {

	@Resource(name = "propertiesService")
	protected EgovPropertyService propertiesService;
	
	@Resource(name = "systemFileProperties")
	protected Properties sysProp;
	
	@RequestMapping(value = "/admin/code")
	public ModelAndView list(ModelAndView mv) throws Exception {
		mv.setViewName("blank/admin/code/list");
		
		return mv;
	}

}