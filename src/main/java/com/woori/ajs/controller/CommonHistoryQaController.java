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
public class CommonHistoryQaController {
	
	/** 공통 서비스 **/
	@Resource(name = "commonCodeService")
	private CommonCodeService commonCodeService;
	
	/**
	 * 공통 심사상세 조회 팝업화면.
	 * @param id	: refId, 심사아이디
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/common/history/qa")
	public ModelAndView detail(ModelAndView mv) throws Exception {
		mv.setViewName("full/common/history/qa/detail");
		
		return mv;
	}
	
}