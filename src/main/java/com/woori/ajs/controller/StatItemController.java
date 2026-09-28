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
public class StatItemController {
	
	/** 공통 서비스 **/
	@Resource(name = "commonCodeService")
	private CommonCodeService commonCodeService;

	@Resource(name = "adminWatchListService")
	private AdminWatchListService adminWatchListService;
	
	@RequestMapping(value = "/stat/item")
	public ModelAndView itemList(ModelAndView mv) throws Exception {
		mv.setViewName("blank/stat/item/list");

		SearchVO searchVO = new SearchVO();

		//컨트롤러에서 코드 가져오기.
		//공통그룹코드 set(제재심사항목코드목록)
		searchVO.setAiInptGrpCd("350");		//200
		List<CommonCodeVO> inptItemList = commonCodeService.selectAllCommonCodeList(searchVO);
		mv.addObject("inptItemList", inptItemList);

		//컨트롤러에서 코드 가져오기.
		//공통그룹코드 set(제재심사항목코드목록 - 수출)
		searchVO.setAiInptGrpCd("350");		//230
		List<CommonCodeVO> inptItemExpList = commonCodeService.selectAllCommonCodeList(searchVO);
		mv.addObject("inptItemExpList", inptItemExpList);

		//컨트롤러에서 코드 가져오기.
		//공통그룹코드 set(제재심사항목코드목록 - 수입)
		searchVO.setAiInptGrpCd("350");		//240
		List<CommonCodeVO> inptItemImpList = commonCodeService.selectAllCommonCodeList(searchVO);
		mv.addObject("inptItemImpList", inptItemImpList);

		//리스트 목록
		List<WatchListVO> watchList = adminWatchListService.selectGrpList(searchVO);
		mv.addObject("watchList", watchList);

		return mv;
	}

	@RequestMapping(value = "/stat/item/move")
	public ModelAndView itemMoveList(ModelAndView mv) throws Exception {
		mv.setViewName("blank/stat/item/moveList");

		SearchVO searchVO = new SearchVO();

		//컨트롤러에서 코드 가져오기.
		//공통그룹코드 set(제재심사항목코드목록)
		searchVO.setAiInptGrpCd("350");		//200
		List<CommonCodeVO> inptItemList = commonCodeService.selectAllCommonCodeList(searchVO);
		mv.addObject("inptItemList", inptItemList);

		//리스트 목록
		List<WatchListVO> watchList = adminWatchListService.selectGrpList(searchVO);
		mv.addObject("watchList", watchList);

		return mv;
	}
	
}