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
public class AdminReTaskController {
	
	/** 공통 서비스 **/
	@Resource(name = "commonCodeService")
	private CommonCodeService commonCodeService;

	@RequestMapping(value = "/admin/retask")
	public ModelAndView detail(ModelAndView mv) throws Exception {
		mv.setViewName("blank/admin/retask/list");

		//컨트롤러에서 코드 가져오기.
		//공통그룹코드 set(권한코드)
		SearchVO vo = new SearchVO();
		vo.setAiInptGrpCd("120");
		List<CommonCodeVO> userAuthList = commonCodeService.selectAllCommonCodeList(vo);
		mv.addObject("userAuthList", userAuthList);

		return mv;
	}
	
}