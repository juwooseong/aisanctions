package com.woori.ajs.api;

import java.util.HashMap;
import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springmodules.validation.commons.DefaultBeanValidator;

import com.woori.ajs.model.AdminLogProgramVO;
import com.woori.ajs.model.AdminQaTargetVO;
import com.woori.ajs.model.LoginVO;
import com.woori.ajs.model.SearchVO;
import com.woori.ajs.service.AdminLogProgramService;
import com.woori.ajs.service.AdminQaTargetService;

import egovframework.rte.fdl.property.EgovPropertyService;
import egovframework.ui.cmmn.HttpUtil;
import egovframework.ui.util.LoginUtils;

@RestController
public class AdminQaTargetApiController {

	@Resource(name = "adminLogProgramService")
	private AdminLogProgramService adminLogProgramService;
	
	@Resource(name = "adminQaTargetService")
	private AdminQaTargetService adminQaTargetService;
	
	/** EgovPropertyService */
	@Resource(name = "propertiesService")
	protected EgovPropertyService propertiesService;

	/** Validator */
	@Resource(name = "beanValidator")
	protected DefaultBeanValidator beanValidator;

	@Resource(name = "systemFileProperties")
	protected Properties sysProp;
	
	@GetMapping("/api/admin/qa/target")
	public HashMap<String,Object> selectQaExTarget(AdminQaTargetVO search) throws Exception {
		HashMap<String,Object> map = new HashMap<String,Object>();
		
		HttpUtil.setResult(map, HttpUtil.HttpType.T200);

		AdminQaTargetVO info = adminQaTargetService.selectQaExTarget(search);
		if(info==null) {
			map.put("qlasItmTotCnt", "");
			map.put("qlasVolnChcCnt", "");
			map.put("aiInptListId", "choice");
			map.put("aiInptItmCd", "");
		} else {
			map.put("qlasItmTotCnt", info.getQlasItmTotCnt());
			map.put("qlasVolnChcCnt", info.getQlasVolnChcCnt());
			map.put("aiInptListId", info.getAiInptListId());
			map.put("aiInptItmCd", info.getAiInptItmCd());
		}
		
		return map;
	}

	@PostMapping("/api/admin/qa/target")
	public HashMap<String,Object> insertQaExTarget(HttpServletRequest request, AdminQaTargetVO vo, AdminLogProgramVO adminLogProgramVO) throws Exception {
		HashMap<String,Object> map = new HashMap<String,Object>();
		LoginVO loginInfo = LoginUtils.getLoginInfo(request);
		
		HttpUtil.setResult(map, HttpUtil.HttpType.T200);
		
		String trnLogSrno = null;
		SearchVO searchVO = new SearchVO();
	//	if(vo.getAiInptItmCd().equals("choice")) {
	//		vo.setAiInptItmCd("");
	//	}
		
	//	if(vo.getAiInptListId().equals("choice")) {
	//		vo.setAiInptListId("");
	//	}
		
		
		trnLogSrno = adminLogProgramService.logProgramInsert(request, adminLogProgramVO, searchVO);
		
		vo.setTrnLogSrno(trnLogSrno);
		
		vo.setLstDbChgId(loginInfo.getId());
		adminQaTargetService.insert(vo);
		
		return map;
	}
}
