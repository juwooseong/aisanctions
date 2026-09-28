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
public class RevertStatAllController {
	
	@Resource(name = "commonCodeService")
	private CommonCodeService commonCodeService;
	
	@RequestMapping(value = "/revert/stat/all")
	public ModelAndView list(ModelAndView mv, SearchVO vo) throws Exception {
		vo.setAiInptGrpCd("150");
	    List<CommonCodeVO> inptAtmcBizDscdList = commonCodeService.selectAllCommonCodeList(vo);
	    mv.addObject("inptAtmcBizDscdList", inptAtmcBizDscdList);
	    
	    vo.setAiInptGrpCd("300");
	    List<CommonCodeVO> inptAtmcBizDscdList2 = commonCodeService.selectAllCommonCodeList(vo);
	    mv.addObject("inptAtmcBizDscdList2", inptAtmcBizDscdList2);
	    
		mv.setViewName("blank/revert/stat/all/list");
		
		return mv;
	}
}
