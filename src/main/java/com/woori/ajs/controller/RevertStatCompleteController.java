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
public class RevertStatCompleteController {
	
	@Resource(name = "commonCodeService")
	private CommonCodeService commonCodeService;
	
	@RequestMapping(value = "/revert/stat/complete")
	public ModelAndView detail(ModelAndView mv, SearchVO vo) throws Exception {
		 vo.setAiInptGrpCd("150");
		 List<CommonCodeVO> inptAtmcBizDscdList = commonCodeService.selectAllCommonCodeList(vo);
		 mv.addObject("inptAtmcBizDscdList", inptAtmcBizDscdList);
		 
		 vo.setAiInptGrpCd("120");
		 List<CommonCodeVO> inptAtmcBizDscdList2 = commonCodeService.selectAllCommonCodeList(vo);
		 mv.addObject("inptAtmcBizDscdList2", inptAtmcBizDscdList2);
		 
		 vo.setAiInptGrpCd("140");
		 List<CommonCodeVO> inptAtmcBizDscdList3 = commonCodeService.selectAllCommonCodeList(vo);
		 mv.addObject("inptAtmcBizDscdList3", inptAtmcBizDscdList3);
		mv.setViewName("blank/revert/stat/complete/list");
		
		return mv;
	}
	
}