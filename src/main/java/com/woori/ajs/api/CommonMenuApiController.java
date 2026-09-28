package com.woori.ajs.api;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.net.URLEncoder;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springmodules.validation.commons.DefaultBeanValidator;

import com.woori.ajs.model.SearchVO;
import com.woori.ajs.model.CommonMenuVO;
import com.woori.ajs.model.LoginVO;
import com.woori.ajs.service.CommonMenuService;

import egovframework.rte.fdl.property.EgovPropertyService;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import egovframework.ui.cmmn.ComUtil;
import egovframework.ui.cmmn.HttpUtil;
import egovframework.ui.cmmn.StringUtil;
import egovframework.ui.util.LoginUtils;

@RestController
public class CommonMenuApiController {

	/** commonMenuService */
	@Resource(name = "commonMenuService")
	private CommonMenuService commonMenuService;

	/** EgovPropertyService */
	@Resource(name = "propertiesService")
	protected EgovPropertyService propertiesService;

	/** Validator */
	@Resource(name = "beanValidator")
	protected DefaultBeanValidator beanValidator;

	@Resource(name = "systemFileProperties")
	protected Properties sysProp;

	@GetMapping("/api/common/menu")
	public HashMap<String,Object> list(HttpServletRequest request, SearchVO searchVO) throws Exception {
		HashMap<String,Object> map = new HashMap<String,Object>();
		
		LoginVO loginInfo = LoginUtils.getLoginInfo(request);
		
		HttpUtil.setResult(map, HttpUtil.HttpType.T200);
		
		searchVO.setSchAuth(loginInfo.getAuth());
		searchVO.setSchAdminYN(loginInfo.getAdminYN());
		
		map.put("searchVO",searchVO);
		
		PaginationInfo paginationInfo = ComUtil.setListPagingInfo(propertiesService, searchVO);
		//searchVO.setRecordCountPerPage(-1);
		
		List<CommonMenuVO> list = commonMenuService.selectList(searchVO);
		map.put("resultList", list);

		int totCnt = commonMenuService.selectListTotCnt(searchVO);
		//int totCnt = list==null ? 0 : list.size();
		
		paginationInfo.setTotalRecordCount(totCnt);
		map.put("paginationInfo", paginationInfo);
		
		return map;
	}
	
	//@PostMapping("/api/common/manual/download")
	@RequestMapping(value = "/api/common/manual/download")
	public void manualDownload(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> paramMap, SearchVO searchVO) throws Exception {
		// 1) 파일다운로드 경로 from properties
		// 2) 파일다운로드 이름 from properties
		String downloadPath = StringUtil.nvl(sysProp.getProperty("manual.path."+paramMap.get("fileFlag")));
		String downloadName = StringUtil.nvl(sysProp.getProperty("manual.name."+paramMap.get("fileFlag")));
		
		try {
			// 파일다운로드 경로
			request.setCharacterEncoding("UTF-8");
			downloadPath = new String(downloadPath.getBytes("UTF-8"), "UTF-8");
			File file = new File(downloadPath);
			
			if(file.isFile()) {
				int bytes = (int)file.length();
				String header = request.getHeader("User-Agent");
				
				// 브라우저 별 다운로드 파일 이름 인코딩 방식 설정
				// IE: 다운로드 파일명에 특수문자가 깨지고 한글 파일명을 가진경우 다운로드 자체가 안되는 문제
				if(header.contains("MSIE") || header.contains("Trident")) {
					downloadName = URLEncoder.encode(downloadName, "UTF-8").replaceAll("\\+", "%20");
					response.setHeader("Content-Disposition", "attachment;filename=" + downloadName + ";");
				}
				// CHROME(FIREFOX):  다운로드 파일명에 특수문자가 깨지는 문제
				else {
					downloadName = new String(downloadName.getBytes("UTF-8"), "ISO-8859-1");
					response.setHeader("Content-Disposition", "attachment;filename=\"" + downloadName + "\"");
				}
				
				response.setContentType("application/download; UTF-8");
				response.setContentLength(bytes);
				response.setHeader("Content-Type", "application/pdf");
				response.setHeader("Content-Transfer-Encoding", "binary;");
				response.setHeader("Pragma", "no-cache;");
				response.setHeader("Expires", "-1;");
				
				BufferedInputStream fin = new BufferedInputStream(new FileInputStream(file));
				BufferedOutputStream outs = new BufferedOutputStream(response.getOutputStream());
				
				byte[] readByte = new byte[4096];
				try {
					while((bytes = fin.read(readByte)) > 0) {
						outs.write(readByte, 0, bytes);
						outs.flush();
					}
				}
				catch(Exception ex) {
					
				}
				finally {
					outs.close();
					fin.close();
				}
			}
			
		}catch(Exception ex){
			
		}
		
		// 수정전 파일다운로드 
		// 1) 파일명 인코딩 문제
		// 2) 
		/*
		//********DOWN PATH: C:\eGovFrameDev-3.8.0-64bit\workspace\egov_ui\src\main\webapp\resources\files\manual\linkFlag2.pdf
		//********DOWN NAME: 사용자메뉴얼_part2_(조회,마감,통계).pdf
		
		//response.setContentType("application/octet-stream");
		response.setContentType("application/pdf");
		response.setHeader("Content-Disposition", "attachment;filename=사용자메뉴얼_part1_(심사,결재).pdf");
		//response.setHeader("Content-Disposition", "attachment;filename=downloadfilename.xlsx");
		
		LoginVO loginInfo = LoginUtils.getLoginInfo(request);
		
		
		
		searchVO.setSchAuth(loginInfo.getAuth());
		searchVO.setSchAdminYN(loginInfo.getAdminYN());
		
		File file = new File("C:\\eGovFrameDev-3.8.0-64bit\\workspace\\egov_ui\\src\\main\\webapp\\resources\\files\\manual\\linkFlag1.pdf");
		//File file = new File("C:\\eGovFrameDev-3.8.0-64bit\\workspace\\egov_ui\\src\\main\\webapp\\resources\\files\\manual\\watchlistBatchReg_20191129.xlsx");
		FileInputStream fileIn = new FileInputStream(file);
		ServletOutputStream out = response.getOutputStream();
		
		byte[] outputByte = new byte[4096];
		
		while(fileIn.read(outputByte, 0, 4096) != -1) {
			out.write(outputByte, 0, 4096);
		}
		
		fileIn.close();
		out.flush();
		out.close();
		*/
		
	}

}