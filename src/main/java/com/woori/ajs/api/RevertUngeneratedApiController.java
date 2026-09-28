package com.woori.ajs.api;

import java.io.File;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;
import org.springmodules.validation.commons.DefaultBeanValidator;

import com.woori.ajs.model.AdminLogProgramVO;
import com.woori.ajs.model.InptResultAnalyVO;
import com.woori.ajs.model.LoginVO;
import com.woori.ajs.model.RevertUngeneratedVO;
import com.woori.ajs.model.SearchVO;
import com.woori.ajs.service.AdminLogProgramService;
import com.woori.ajs.service.RevertUngeneratedService;

import egovframework.rte.fdl.property.EgovPropertyService;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import egovframework.ui.cmmn.ComUtil;
import egovframework.ui.cmmn.DateUtil;
import egovframework.ui.cmmn.FileUtil;
import egovframework.ui.cmmn.HttpUtil;
import egovframework.ui.cmmn.StringUtil;
import egovframework.ui.cmmn.XlsUtil;
import egovframework.ui.util.LoginUtils;

@RestController
public class RevertUngeneratedApiController {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(RevertUngeneratedApiController.class);

	/** revertUngeneratedService */
	@Resource(name = "revertUngeneratedService")
	private RevertUngeneratedService revertUngeneratedService;

	/** EgovPropertyService */
	@Resource(name = "propertiesService")
	protected EgovPropertyService propertiesService;

	/** Validator */
	@Resource(name = "beanValidator")
	protected DefaultBeanValidator beanValidator;
	
	/** adminLogProgramService */
	@Resource(name = "adminLogProgramService")
	private AdminLogProgramService adminLogProgramService;
	
	@Resource(name = "systemFileProperties")
	protected Properties sysProp;
	
	@GetMapping("/api/revert/ungenerated")
	public HashMap<String,Object> list(SearchVO searchVO) throws Exception {
		HashMap<String,Object> map = new HashMap<String,Object>();
		
		HttpUtil.setResult(map, HttpUtil.HttpType.T200);
		
		map.put("searchVO",searchVO);
		
		PaginationInfo paginationInfo = ComUtil.setListPagingInfo(propertiesService, searchVO);
		//searchVO.setRecordCountPerPage(-1);
		
		List<RevertUngeneratedVO> list = revertUngeneratedService.selectList(searchVO);
		map.put("resultList", list);
		
		int totCnt = revertUngeneratedService.selectListTotCnt(searchVO);
		//int totCnt = list==null ? 0 : list.size();
		
		paginationInfo.setTotalRecordCount(totCnt);
		map.put("paginationInfo", paginationInfo);
		
		return map;
	}
	
	@PostMapping("/api/revert/ungenerated/confirm")
	public HashMap<String, Object> confirm(HttpServletRequest request, RevertUngeneratedVO revertUngeneratedVO, AdminLogProgramVO adminLogProgramVO, SearchVO searchVO) throws Exception{
		HashMap<String,Object> map = new HashMap<String,Object>();
		
		LoginVO userInfo = LoginUtils.getLoginInfo(request);
		
		String[] aiInptXtSrnos = revertUngeneratedVO.getAiInptXtSrnos();
		String[] actlFxRefnos = revertUngeneratedVO.getActlFxRefnos();
		
		String trnLogSrno = null;
		
		trnLogSrno = adminLogProgramService.logProgramInsert(request, adminLogProgramVO, searchVO);
		
		for(int index = 0 ; index < aiInptXtSrnos.length ; index++) {
			RevertUngeneratedVO param = new RevertUngeneratedVO();
			param.setAiInptXtPrcStsDscd("12");
			param.setAiInptXtSrno(aiInptXtSrnos[index]);
			param.setActlFxRefno(actlFxRefnos[index]);
			param.setAiInptXtPrcEno(userInfo.getEno());
			param.setTrnLogSrno(trnLogSrno);
			
			param.setLstDbChgId(userInfo.getEno());
			revertUngeneratedService.statusUpdate(param);
		}
		
		map.put("rst", "success");
		return map;
	}
	
	@PostMapping("/api/revert/ungenerated/cancel")
	public HashMap<String, Object> cancel(HttpServletRequest request, RevertUngeneratedVO revertUngeneratedVO, AdminLogProgramVO adminLogProgramVO, SearchVO searchVO) throws Exception{
		HashMap<String,Object> map = new HashMap<String,Object>();
		
		LoginVO userInfo = LoginUtils.getLoginInfo(request);
		
		String[] aiInptXtSrnos = revertUngeneratedVO.getAiInptXtSrnos();
		String[] actlFxRefnos = revertUngeneratedVO.getActlFxRefnos();
				
		String trnLogSrno = null;
		trnLogSrno = adminLogProgramService.logProgramInsert(request, adminLogProgramVO, searchVO);
		
		for(int index = 0 ; index < aiInptXtSrnos.length ; index++) {
			RevertUngeneratedVO param = new RevertUngeneratedVO();
			param.setAiInptXtPrcStsDscd("11");
			param.setAiInptXtSrno(aiInptXtSrnos[index]);
			param.setActlFxRefno(actlFxRefnos[index]);
			param.setAiInptXtPrcEno(userInfo.getEno());
			param.setTrnLogSrno(trnLogSrno);
			
			param.setLstDbChgId(userInfo.getEno());
			revertUngeneratedService.statusUpdate(param);
		}
		
		map.put("rst", "success");
		return map;
	}
	
	@GetMapping("/api/revert/ungenerated/xls")
	public ModelAndView refListXls(SearchVO searchVO, ModelAndView mv) throws Exception {
		mv.setViewName("downView");					//파일다운로드뷰
		String xlsDownName = StringUtil.concat(new String[] {"업무미생성목록_",DateUtil.getFormatDate("yyyyMMdd"),".xlsx"});
		searchVO.setRecordCountPerPage(-1);
		List<RevertUngeneratedVO> list = revertUngeneratedService.selectList(searchVO);
		List<String[]> xlsListsTitle = XlsUtil.createListsTitle();
		List<List<LinkedHashMap<String,String>>> xlsLists = XlsUtil.createLists();
		xlsListsTitle.add(new String[] {"접수일자", "제외사유", "업무", "Ref.No", "회차", "접수자", "스캔자", "스캔일시", "처리상태", "처리자", "처리일시"});
		if(list!=null) {
			List<LinkedHashMap<String,String>> xlsList = XlsUtil.createList();
			for(int i=0;i<list.size();i++) {
				LinkedHashMap<String,String> rowMap = new LinkedHashMap<String,String>();
				RevertUngeneratedVO row = list.get(i);
				rowMap.put("inptRcpDt", row.getInptRcpDt());
				rowMap.put("aiInptAplXtRncdNm", row.getAiInptAplXtRncdNm());
				rowMap.put("inptAtmcBizDscdNm", row.getInptAtmcBizDscdNm());
				rowMap.put("actlFxRefno", row.getActlFxRefno());
				rowMap.put("fxRefnoSrno", row.getFxRefnoSrno());
				rowMap.put("trnOprNm", mergeNameAndEno(row.getTrnOprNm(), row.getTrnOprNo())); //
				rowMap.put("docScanNm", mergeNameAndEno(row.getDocScanNm(), row.getAiInptDocScanChrgEno())); //
				rowMap.put("aiInptDocScanDtm", row.getAiInptDocScanDtm());
				rowMap.put("aiInptXtPrcStsDscdNm", row.getAiInptXtPrcStsDscdNm());
				rowMap.put("procNm", mergeNameAndEno(row.getProcNm(), row.getAiInptXtPrcEno())); //
				rowMap.put("aiInptXtPrcDtm", row.getAiInptXtPrcDtm());
				
				xlsList.add(rowMap);
			} 
			xlsLists.add(xlsList);
		}
		String uploadPath = StringUtil.nvl(sysProp.getProperty("upload.path"));
		File xlsFile = XlsUtil.createXlsFile(uploadPath, xlsListsTitle, xlsLists);
		try {
			FileUtil.setFileDown(mv, xlsFile, xlsDownName);
		} catch (Exception e) {
			LOGGER.error("Exception ::: " + e);
		}
		
		return mv;
	}
	
	public String mergeNameAndEno(String name, String eno) {
		// 이름(사번) 형태로 변환함
		StringBuffer rstStrBuffer = new StringBuffer();
		
		if(name != null) {
			rstStrBuffer.append(name);
		}
		if(eno != null) {
			rstStrBuffer.append('(');
			rstStrBuffer.append(eno);
			rstStrBuffer.append(')');
		}
		
		String rstStr = rstStrBuffer.toString();
		
		return rstStr;
	}
}
