package com.woori.ajs.controller;

import java.util.List;
import java.util.Properties;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.woori.ajs.model.AdminWordCorrectionVO;
import com.woori.ajs.model.SearchVO;
import com.woori.ajs.service.AdminWordCorrectionService;

import egovframework.rte.fdl.property.EgovPropertyService;

@Controller
public class AdminWordCorrectionController {

	@Resource(name = "propertiesService")
	protected EgovPropertyService propertiesService;
	
	@Resource(name = "systemFileProperties")
	protected Properties sysProp;
	
	@Resource(name = "adminWordCorrectionService")
	private AdminWordCorrectionService adminWordCorrectionService;
	
	@RequestMapping(value = "admin/word/correction")
	public ModelAndView detail(ModelAndView mv) throws Exception {
		mv.setViewName("blank/admin/word/correction");
		
		SearchVO vo = new SearchVO();
		
		vo.setInptAtmcBizDscd("242");
		List<AdminWordCorrectionVO> list = adminWordCorrectionService.selectSanctionList(vo);
		mv.addObject("selectBoxList", list);
		
		return mv;
	}

}