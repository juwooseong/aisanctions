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
public class QaStatusController {
	
	/** 공통 서비스 **/
	@Resource(name = "commonCodeService")
	private CommonCodeService commonCodeService;
	
	@RequestMapping(value = "/qa/status")	
	public ModelAndView list(ModelAndView mv, SearchVO vo) throws Exception {
		
		vo.setAiInptGrpCd("280");
	    List<CommonCodeVO> inptPrcsCdList = commonCodeService.selectAllCommonCodeList(vo);
	    mv.addObject("inptPrcsCdList", inptPrcsCdList);
	    
		mv.setViewName("blank/qa/status/list");
		
		return mv;
	}
}
