package com.woori.ajs.controller;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.woori.ajs.service.AdminLogLoginService;
import com.woori.ajs.service.CommonLoginService;

@Controller
public class CommonLoginDController {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(CommonLoginDController.class);

	@Resource(name = "commonLoginService")
	private CommonLoginService commonLoginService;
	
	@Resource(name = "adminLogLoginService")
	private AdminLogLoginService adminLogLoginService;
	
	@RequestMapping(value = "/login")
	public ModelAndView login(ModelAndView model) throws Exception {
		
		model.setViewName("full/login/login");
		return model;
	}

}