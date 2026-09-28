package com.woori.ajs.controller;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.woori.ajs.model.CommonCodeVO;
import com.woori.ajs.model.SearchVO;
import com.woori.ajs.service.CommonCodeService;

@Controller
public class CommonHistoryController {
	
	/** 공통 서비스 **/
	@Resource(name = "commonCodeService")
	private CommonCodeService commonCodeService;
	
	/**
	 * 공통 심사상세 조회 팝업화면.
	 * @param id	: refId, 심사아이디
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/common/history")
	public ModelAndView detail(ModelAndView mv) throws Exception {
		mv.setViewName("full/common/history/detail");
		
		return mv;
	}
	
	@RequestMapping(value = "/common/history/status")
	public ModelAndView statusDetail(ModelAndView mv) throws Exception {
		mv.setViewName("full/common/history/detail");
		
		
		return mv;
	}
	
}