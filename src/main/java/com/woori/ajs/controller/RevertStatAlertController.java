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
public class RevertStatAlertController {

	/** 공통 서비스 **/
	@Resource(name = "commonCodeService")
	private CommonCodeService commonCodeService;

	@RequestMapping(value = "/revert/stat/alert")
	public ModelAndView detail(ModelAndView mv) throws Exception {
		mv.setViewName("blank/revert/stat/alert/list");

		SearchVO vo = new SearchVO();
		
		//컨트롤러에서 코드 가져오기.
		//공통그룹코드 set(심사자동화업무구분)
		vo.setAiInptGrpCd("150");
		List<CommonCodeVO> inptAtmcBizDscdList = commonCodeService.selectAllCommonCodeList(vo);
		mv.addObject("inptAtmcBizDscdList", inptAtmcBizDscdList);

		//컨트롤러에서 코드 가져오기.
		//공통그룹코드 set(권한코드)
		vo.setAiInptGrpCd("120");
		List<CommonCodeVO> authCdList = commonCodeService.selectAllCommonCodeList(vo);
		mv.addObject("authCdList", authCdList);

		//컨트롤러에서 코드 가져오기.
		//공통그룹코드 set(TotalText상태)
		vo.setAiInptGrpCd("170");
		List<CommonCodeVO> totalTextStatCdList = commonCodeService.selectAllCommonCodeList(vo);
		mv.addObject("totalTextStatCdList", totalTextStatCdList);

		//컨트롤러에서 코드 가져오기.
		//공통그룹코드 set(심사항목상태)
		List<CommonCodeVO> inptItemStatCdList = commonCodeService.selectAllCommonCodeList(vo);
		mv.addObject("inptItemStatCdList", inptItemStatCdList);

		//컨트롤러에서 코드 가져오기.
		//공통그룹코드 set(SafeWatch상태)
		List<CommonCodeVO> safeWatchStatCdList = commonCodeService.selectAllCommonCodeList(vo);
		mv.addObject("safeWatchStatCdList", safeWatchStatCdList);

		return mv;
	}
	
}