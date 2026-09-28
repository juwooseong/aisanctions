package com.woori.ajs.api;

import java.util.Base64;
import java.util.HashMap;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import com.woori.ajs.model.AdminLogProgramVO;
import com.woori.ajs.model.DocClassException;
import com.woori.ajs.model.DocClassSaveRequest;
import com.woori.ajs.model.LoginVO;
import com.woori.ajs.model.SearchVO;
import com.woori.ajs.service.AdminLogProgramService;
import com.woori.ajs.service.DocClassService;

import egovframework.ui.cmmn.HttpUtil;
import egovframework.ui.cmmn.StringUtil;
import egovframework.ui.util.LoginUtils;

@RestController
public class DocClassApiController {

	private static final byte[] EMPTY_GIF = Base64.getDecoder()
			.decode("R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7");

	@Resource(name = "docClassService")
	private DocClassService docClassService;

	@Resource(name = "adminLogProgramService")
	private AdminLogProgramService adminLogProgramService;

	@Resource
	private CommonDetailApiController commonDetailApiController;

	@GetMapping("/api/doc-class/{inptMstSrno:\\d+}")
	public HashMap<String, Object> load(@PathVariable("inptMstSrno") int inptMstSrno) throws Exception {
		HashMap<String, Object> map = new HashMap<String, Object>();
		try {
			HttpUtil.setResult(map, HttpUtil.HttpType.T200);
			map.put("data", docClassService.load(inptMstSrno));
		} catch (DocClassException e) {
			applyError(map, e);
		} catch (Exception e) {
			HttpUtil.setResult(map, HttpUtil.HttpType.T500);
			HttpUtil.setExResult(map, "-1", e.getMessage());
		}
		return map;
	}

	@PostMapping("/api/doc-class/save")
	public ResponseEntity<HashMap<String, Object>> save(HttpServletRequest request, @RequestBody DocClassSaveRequest req,
			AdminLogProgramVO adminLogProgramVO) throws Exception {
		HashMap<String, Object> map = new HashMap<String, Object>();
		try {
			if (adminLogProgramVO == null) {
				adminLogProgramVO = new AdminLogProgramVO();
			}
			SearchVO searchVO = new SearchVO();
			adminLogProgramVO.setAiInptCnctScrnNo("1011");
			adminLogProgramVO.setAiInptCnctActiCd("12");
			String trnLogSrno = adminLogProgramService.logProgramInsert(request, adminLogProgramVO, searchVO);
			HttpUtil.setResult(map, HttpUtil.HttpType.T200);
			map.putAll(docClassService.save(req, loginEno(request), trnLogSrno));
			return ResponseEntity.ok(map);
		} catch (DocClassException e) {
			applyError(map, e);
			int status = e.getHttpStatus() <= 0 ? 400 : e.getHttpStatus();
			return ResponseEntity.status(status).body(map);
		} catch (Exception e) {
			HttpUtil.setResult(map, HttpUtil.HttpType.T500);
			HttpUtil.setExResult(map, "-1", e.getMessage());
			return ResponseEntity.status(500).body(map);
		}
	}

	@GetMapping("/api/doc-class/thumb")
	public void thumb(SearchVO vo, HttpServletResponse response) throws Exception {
		byte[] bytes = EMPTY_GIF;
		String contentType = "image/gif";
		try {
			HashMap<String, Object> map = commonDetailApiController.imgRest(vo);
			Object imgObj = map == null ? null : map.get("imgStr");
			String imgStr = imgObj == null ? "" : String.valueOf(imgObj);
			if (imgStr.startsWith("data:image/")) {
				int comma = imgStr.indexOf(',');
				if (comma > 0) {
					String meta = imgStr.substring(5, comma);
					int slash = meta.indexOf('/');
					int semi = meta.indexOf(';');
					if (slash > 0) {
						contentType = "image/" + meta.substring(slash + 1, semi > slash ? semi : meta.length());
					}
					imgStr = imgStr.substring(comma + 1);
				}
			}
			if (!imgStr.isEmpty()) {
				bytes = Base64.getDecoder().decode(imgStr.replaceAll("\\s+", ""));
				if (!contentType.startsWith("image/") || "image/gif".equals(contentType)) {
					contentType = "image/jpeg";
				}
			}
		} catch (Exception e) {
			bytes = EMPTY_GIF;
			contentType = "image/gif";
		}
		response.setContentType(contentType);
		response.setHeader("Cache-Control", "private, max-age=120");
		response.getOutputStream().write(bytes);
		response.getOutputStream().flush();
	}

	private String loginEno(HttpServletRequest request) {
		LoginVO loginInfo = LoginUtils.getLoginInfo(request);
		String eno = loginInfo == null ? null : StringUtil.nvl(loginInfo.getEno());
		if (eno == null || eno.isEmpty()) {
			return loginInfo == null ? "SYSTEM" : loginInfo.getId();
		}
		return eno;
	}

	private void applyError(HashMap<String, Object> map, DocClassException e) {
		if (e.getHttpStatus() == 403) {
			HttpUtil.setResult(map, HttpUtil.HttpType.T403);
		} else if (e.getHttpStatus() == 404) {
			HttpUtil.setResult(map, HttpUtil.HttpType.T404);
		} else {
			HttpUtil.setResult(map, HttpUtil.HttpType.T400);
		}
		HttpUtil.setExResult(map, e.getCode(), e.getMessage());
	}
}
