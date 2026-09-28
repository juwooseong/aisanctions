package com.woori.ajs.api;

import java.util.HashMap;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import com.woori.ajs.model.AdminLogProgramVO;
import com.woori.ajs.model.AnnotationPageSaveRequest;
import com.woori.ajs.model.LoginVO;
import com.woori.ajs.model.SearchVO;
import com.woori.ajs.service.AdminLogProgramService;
import com.woori.ajs.service.AnnotationService;

import egovframework.ui.cmmn.HttpUtil;
import egovframework.ui.cmmn.StringUtil;
import egovframework.ui.util.LoginUtils;

@RestController
public class AnnotationApiController {

	@Resource(name = "annotationService")
	private AnnotationService annotationService;

	@Resource(name = "adminLogProgramService")
	private AdminLogProgramService adminLogProgramService;

	@GetMapping("/api/anno/{inptMstSrno:\\d+}")
	public HashMap<String, Object> load(@PathVariable("inptMstSrno") Long inptMstSrno) throws Exception {
		HashMap<String, Object> map = new HashMap<String, Object>();
		try {
			HttpUtil.setResult(map, HttpUtil.HttpType.T200);
			map.putAll(annotationService.load(inptMstSrno));
		} catch (Exception e) {
			HttpUtil.setResult(map, HttpUtil.HttpType.T500);
			HttpUtil.setExResult(map, "-1", e.getMessage());
		}
		return map;
	}

	@PostMapping("/api/anno/{inptMstSrno:\\d+}/save")
	public HashMap<String, Object> save(HttpServletRequest request, @PathVariable("inptMstSrno") Long inptMstSrno,
			@RequestBody AnnotationPageSaveRequest req, AdminLogProgramVO adminLogProgramVO) throws Exception {
		HashMap<String, Object> map = new HashMap<String, Object>();
		try {
			if (adminLogProgramVO == null) {
				adminLogProgramVO = new AdminLogProgramVO();
			}
			SearchVO searchVO = new SearchVO();
			adminLogProgramVO.setAiInptCnctScrnNo("1011");
			adminLogProgramVO.setAiInptCnctActiCd("14");
			String trnLogSrno = adminLogProgramService.logProgramInsert(request, adminLogProgramVO, searchVO);
			HttpUtil.setResult(map, HttpUtil.HttpType.T200);
			map.putAll(annotationService.savePage(inptMstSrno, req, loginEno(request), trnLogSrno));
		} catch (Exception e) {
			HttpUtil.setResult(map, HttpUtil.HttpType.T500);
			HttpUtil.setExResult(map, "-1", e.getMessage());
		}
		return map;
	}

	private String loginEno(HttpServletRequest request) {
		LoginVO loginInfo = LoginUtils.getLoginInfo(request);
		String eno = loginInfo == null ? null : StringUtil.nvl(loginInfo.getEno());
		if (eno == null || eno.isEmpty()) {
			return loginInfo == null ? "SYSTEM" : loginInfo.getId();
		}
		return eno;
	}
}
