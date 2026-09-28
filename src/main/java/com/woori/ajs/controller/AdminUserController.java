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
public class AdminUserController {
	
	/** 공통 서비스 **/
	@Resource(name = "commonCodeService")
	private CommonCodeService commonCodeService;

	@RequestMapping(value = "/admin/user")
	public ModelAndView detail(ModelAndView mv) throws Exception {
		mv.setViewName("blank/admin/user/list");

		//컨트롤러에서 코드 가져오기.
		SearchVO vo = new SearchVO();
		vo.setAiInptGrpCd("120");
		List<CommonCodeVO> authCodeList = commonCodeService.selectAllCommonCodeList(vo);
		mv.addObject("authCodeList", authCodeList);

		vo.setAiInptGrpCd("121");
		List<CommonCodeVO> userCodeList = commonCodeService.selectAllCommonCodeList(vo);
		mv.addObject("userCodeList", userCodeList);
		
		return mv;
	}
}