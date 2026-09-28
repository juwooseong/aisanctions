package com.woori.ajs.controller;

import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.woori.ajs.model.CommonCodeVO;
import com.woori.ajs.model.SearchVO;
import com.woori.ajs.service.CommonCodeService;

import egovframework.ui.cmmn.StringUtil;

@Controller
public class AppTodoController {

	@Resource(name = "commonCodeService")
	private CommonCodeService commonCodeService;
	
	@RequestMapping(value = "/app/todo")
	public ModelAndView detail(ModelAndView mv, SearchVO vo) throws Exception {
		mv.setViewName("blank/app/todo/list");

		vo.setAiInptGrpCd("150");
	    List<CommonCodeVO> inptAtmcBizDscdList = commonCodeService.selectAllCommonCodeList(vo);
	    mv.addObject("inptAtmcBizDscdList", inptAtmcBizDscdList);
	    
		return mv;
	}
	
	/**
	 * 일괄승인 팝업
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
	@PostMapping("/app/todo/bundle")
	public ModelAndView bundlePopup(ModelAndView mv, HttpServletRequest request) throws Exception {
		mv.setViewName("full/app/todo/bundle");
		
		String[] ids = request.getParameterValues("ids");
		mv.addObject("ids",StringUtil.joinArray(ids));
		
		return mv;
	}
	
}