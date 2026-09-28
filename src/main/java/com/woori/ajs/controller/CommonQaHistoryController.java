package com.woori.ajs.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.woori.ajs.model.SearchVO;

import egovframework.ui.cmmn.PropUtil;

@Controller
public class CommonQaHistoryController {
	@RequestMapping(value = "/common/qa/history")
	public ModelAndView detail(ModelAndView mv) throws Exception {
		long uploadMaxSize = PropUtil.UPLOAD_MAX_SIZE;
		mv.setViewName("full/common/qa/history/list");
		mv.addObject("uploadMaxSize", uploadMaxSize);
		return mv;
	}
}