package com.woori.ajs.controller;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.woori.ajs.model.CommonCodeVO;
import com.woori.ajs.model.SearchVO;
import com.woori.ajs.model.WatchListVO;
import com.woori.ajs.service.AdminWatchListService;
import com.woori.ajs.service.CommonCodeService;

@Controller
public class AdminQaTargetController {

	/** 공통 서비스 **/
	@Resource(name = "commonCodeService")
	private CommonCodeService commonCodeService;
	
	@Resource(name = "adminWatchListService")
	private AdminWatchListService adminWatchListService;
	
	@RequestMapping(value = "/admin/qa/target")
	public ModelAndView target(ModelAndView mv) throws Exception {
		mv.setViewName("blank/admin/qa/target");
		
		SearchVO searchVO = new SearchVO();
		
		//심사목록 리스트
		List<WatchListVO> grpList = adminWatchListService.selectGrpList(searchVO);
		mv.addObject("grpList", grpList);
		
		//공통그룹코드 set(심사검사항목 수출)
		searchVO.setAiInptGrpCd("230");
		List<CommonCodeVO> expItemList = commonCodeService.selectAllCommonCodeList(searchVO);
		mv.addObject("expItemList", expItemList);

		//공통그룹코드 set(심사검사항목 수입)
		searchVO.setAiInptGrpCd("240");
		List<CommonCodeVO> inpItemList = commonCodeService.selectAllCommonCodeList(searchVO);
		mv.addObject("inpItemList", inpItemList);

		return mv;
	}
	
}