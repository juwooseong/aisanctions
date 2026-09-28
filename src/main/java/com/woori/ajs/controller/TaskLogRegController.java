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
public class TaskLogRegController {

	/** 공통 서비스 **/
	@Resource(name = "commonCodeService")
	private CommonCodeService commonCodeService;

	@RequestMapping(value = "/task/log/reg")
	public ModelAndView detail(ModelAndView mv) throws Exception {
		mv.setViewName("blank/task/log/reg/list");

		SearchVO vo = new SearchVO();
		
		//컨트롤러에서 코드 가져오기.
		//공통그룹코드 set(심사자동화업무구분)
		vo.setAiInptGrpCd("322");
		List<CommonCodeVO> apdrDsCdList = commonCodeService.selectAllCommonCodeList(vo);
		mv.addObject("apdrDsCdList", apdrDsCdList);
		
		//컨트롤러에서 코드 가져오기.
		//공통그룹코드 set(심사자동화업무구분)
		vo.setAiInptGrpCd("323");
		List<CommonCodeVO> apdrItmCdList = commonCodeService.selectAllCommonCodeList(vo);
		mv.addObject("apdrItmCdList", apdrItmCdList);
		
		return mv;
	}
	
}