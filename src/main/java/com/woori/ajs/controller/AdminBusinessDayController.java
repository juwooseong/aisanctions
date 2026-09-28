package com.woori.ajs.controller;

import java.util.Calendar;
import java.util.Properties;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.woori.ajs.model.SearchVO;

import egovframework.rte.fdl.property.EgovPropertyService;

@Controller
public class AdminBusinessDayController {

	@Resource(name = "propertiesService")
	protected EgovPropertyService propertiesService;
	
	@Resource(name = "systemFileProperties")
	protected Properties sysProp;
	
	@RequestMapping(value = "/admin/businessday")
	public ModelAndView detail(ModelAndView mv) throws Exception {
		mv.setViewName("blank/admin/businessday/list");
		//mv.setViewName("blank/revert/ungenerated/list");
		
		int yyyy = Calendar.getInstance().get(Calendar.YEAR);
		int minYear = yyyy - 5;
		int maxYear = yyyy + 4;
		
		mv.addObject("minYear", minYear);
		mv.addObject("maxYear", maxYear);
		
		return mv;
	}

}