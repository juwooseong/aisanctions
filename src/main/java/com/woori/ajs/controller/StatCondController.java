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
public class StatCondController {
	
	@Resource(name = "commonCodeService")
	private CommonCodeService commonCodeService;
	
	@Resource(name = "adminWatchListService")
	AdminWatchListService adminWatchListService;
	
	@RequestMapping(value = "/stat/cond")
	public ModelAndView detail(ModelAndView mv, SearchVO vo) throws Exception {
		// 업무구분
		vo.setAiInptGrpCd("150");
		List<CommonCodeVO> inptAtmcBizDscdList = commonCodeService.selectAllCommonCodeList(vo);
		// 항목통계
		vo.setAiInptGrpCd("350");
		List<CommonCodeVO> statiSanctionList = commonCodeService.selectAllCommonCodeList(vo);
		// WatchList list
		List<WatchListVO> lstList = adminWatchListService.selectGrpList(vo);
		//	List<CommonSanctionStatVO> watchList = commonSanctionStatService.selectWatchList();
		
		mv.addObject("inptAtmcBizDscdList", inptAtmcBizDscdList);
		mv.addObject("statiSanctionList", statiSanctionList);
		mv.addObject("watchList", lstList);
		mv.setViewName("blank/stat/cond/list");
		
		return mv;
	}
	
}