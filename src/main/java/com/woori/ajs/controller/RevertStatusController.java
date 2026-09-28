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
public class RevertStatusController {

	/** 공통 서비스 **/
	@Resource(name = "commonCodeService")
	private CommonCodeService commonCodeService;
	
	@RequestMapping(value = "/revert/status")
	public ModelAndView list(ModelAndView mv, SearchVO vo) throws Exception {
		
		// 공통그룹코드 set(심사자동화업무구분)
	    vo.setAiInptGrpCd("150");
	    List<CommonCodeVO> inptAtmcBizDscdList = commonCodeService.selectAllCommonCodeList(vo);
	    mv.addObject("inptAtmcBizDscdList", inptAtmcBizDscdList);
		
	    mv.setViewName("blank/revert/status/list");
		
		return mv;
	}

}