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

import egovframework.ui.cmmn.StringUtil;

@Controller
public class AdminSanctionController {
	
	/** 공통 서비스 **/
	@Resource(name = "commonCodeService")
	private CommonCodeService commonCodeService;

	@Resource(name = "adminWatchListService")
	private AdminWatchListService adminWatchListService;
	
	@RequestMapping(value = "/admin/sanction")
	public ModelAndView list(ModelAndView mv) throws Exception {
		mv.setViewName("blank/admin/sanction/sanctionInfo");
		
		SearchVO vo = new SearchVO();
		
		//컨트롤러에서 코드 가져오기.
		//공통그룹코드 set(심사제재항목코드)
		vo.setAiInptGrpCd("200");
		List<CommonCodeVO> itmList = commonCodeService.selectAllCommonCodeList(vo);
		mv.addObject("itmList", itmList);
		
		//카테고리리스트.
		List<WatchListVO> ctgrList = adminWatchListService.selectCtgrList(vo);
		mv.addObject("ctgrList", ctgrList);
		
		
		//목록리스트.
		List<WatchListVO> lstList = adminWatchListService.selectGrpList(vo);
		mv.addObject("lstList", lstList);
		
		return mv;
	}

}