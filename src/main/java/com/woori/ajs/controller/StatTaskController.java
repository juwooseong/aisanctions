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
public class StatTaskController {
	
	@Resource(name = "commonCodeService")
	private CommonCodeService commonCodeService;
	
	@RequestMapping(value = "/stat/task")
	public ModelAndView detail(ModelAndView mv , SearchVO vo) throws Exception {
		mv.setViewName("blank/stat/task/list");
		
		 vo.setAiInptGrpCd("120");
		 List<CommonCodeVO> inptAtmcBizDscdList = commonCodeService.selectAllCommonCodeList(vo);
		 mv.addObject("inptAtmcBizDscdList", inptAtmcBizDscdList);
		 
		 vo.setAiInptGrpCd("150");
		 List<CommonCodeVO> inptAtmcBizDscdList2 = commonCodeService.selectAllCommonCodeList(vo);
		 mv.addObject("inptAtmcBizDscdList2", inptAtmcBizDscdList2);
		 
		return mv;
	}

	@RequestMapping(value = "/stat/task2")
	public ModelAndView detail2(ModelAndView mv , SearchVO vo) throws Exception {
		mv.setViewName("blank/stat/task/list2");
		
		vo.setAiInptGrpCd("120");
		List<CommonCodeVO> inptAtmcBizDscdList = commonCodeService.selectAllCommonCodeList(vo);
		mv.addObject("inptAtmcBizDscdList", inptAtmcBizDscdList);
		
		vo.setAiInptGrpCd("150");
		List<CommonCodeVO> inptAtmcBizDscdList2 = commonCodeService.selectAllCommonCodeList(vo);
		mv.addObject("inptAtmcBizDscdList2", inptAtmcBizDscdList2);
		
		return mv;
	}
	
}