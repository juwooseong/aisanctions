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
public class AppStatusController {

	@Resource(name = "commonCodeService")
	private CommonCodeService commonCodeService;
	
	@RequestMapping(value = "/app/status")
	public ModelAndView detail(ModelAndView mv, SearchVO vo) throws Exception {
		mv.setViewName("blank/app/status/list");

		vo.setAiInptGrpCd("150");
	    List<CommonCodeVO> inptAtmcBizDscdList = commonCodeService.selectAllCommonCodeList(vo);
	    mv.addObject("inptAtmcBizDscdList", inptAtmcBizDscdList);
	    
		return mv;
	}
	
}