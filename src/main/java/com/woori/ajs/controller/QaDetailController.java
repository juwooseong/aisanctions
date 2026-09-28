package com.woori.ajs.controller;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.woori.ajs.model.LoginVO;
import com.woori.ajs.model.SearchVO;
import com.woori.ajs.service.CommonCodeService;
import com.woori.ajs.service.CommonRevertDetailService;

import egovframework.ui.cmmn.ComUtil;
import egovframework.ui.cmmn.StringUtil;
import egovframework.ui.util.LoginUtils;

@Controller
public class QaDetailController {

	/** 심사상세 공통 서비스 **/
	@Resource(name = "commonRevertDetailService")
	private CommonRevertDetailService commonRevertDetailService;

	/** 공통 서비스 **/
	@Resource(name = "commonCodeService")
	private CommonCodeService commonCodeService;
	
	/**
	 * 공통 심사상세 조회 팝업화면.
	 * @param id	: refId, 심사아이디
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/qa/detail")
	public ModelAndView detail(HttpServletRequest request, ModelAndView mv, SearchVO vo) throws Exception {
		mv.setViewName("full/qa/detail/detail");
		LoginVO loginInfo = LoginUtils.getLoginInfo(request);

		//접근권한체크
		if(StringUtil.isNotEmpty(vo.getInptMstSrno())) {
			SearchVO vo2 = new SearchVO();
			vo2.setSchGbn("03");						//팝업종류(01 - 심사자, 03 - QA, 02 - 결재자)
			vo2.setSchUserNo(loginInfo.getId());
			vo2.setInptMstSrno(vo.getInptMstSrno());
			int checkAccess = commonRevertDetailService.selectCheckAccess(vo2);
			if(checkAccess==0) {
				ComUtil.alertClose(mv, "접근권한이 없습니다.");
			}
		} else {
			ComUtil.alertClose(mv, "정보가 부족합니다.");
		}

		return mv;
	}
	
}