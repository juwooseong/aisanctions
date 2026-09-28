package com.woori.ajs.controller;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.woori.ajs.model.CommonCodeVO;
import com.woori.ajs.model.SearchVO;
import com.woori.ajs.service.CommonCodeService;

import egovframework.ui.cmmn.StringUtil;

@Controller
public class AdminStatusController {
	
	/** 공통 서비스 **/
	@Resource(name = "commonCodeService")
	private CommonCodeService commonCodeService;

	@RequestMapping(value = "/admin/status")
	public ModelAndView detail(ModelAndView mv) throws Exception{
		
		mv.setViewName("blank/admin/status/list");
		
		SearchVO vo = new SearchVO();
		
		// 360 코드 가져오기(검색조건 selectBox)
		vo.setAiInptGrpCd("360");
		List<CommonCodeVO> processCdList = commonCodeService.selectAllCommonCodeList(vo);
		
		// 300 번 코드에서 시스템심사진행현황에서 사용하는 코드가 몇번인지 알아야함
		//vo.setAiInptGrpCd("300");
		//List<CommonCodeVO> processCdListToAdd = commonCodeService.selectAllCommonCodeList(vo);
		/*
		for(int index = 0 ; index < processCdListToAdd.size() ; index++) {
			CommonCodeVO row = processCdListToAdd.get(index);
			
			if(StringUtil.isEquals(row.getAiInptCmnCd(), "??")) {
				processCdList.add(row);
			}
		}*/
		
		mv.addObject("processCdList", processCdList);
		
		return mv;
	}
	
	
	@RequestMapping(value = "/admin/status/reg")
	public ModelAndView reprocessReg(ModelAndView mv) throws Exception {
		mv.setViewName("full/admin/status/reprocessing");
		
		return mv;
	}
	
}
