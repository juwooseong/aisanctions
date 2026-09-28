package com.woori.ajs.api;

import java.io.File;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Properties;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;
import org.springmodules.validation.commons.DefaultBeanValidator;

import com.woori.ajs.model.RevertStatCompleteVO;
import com.woori.ajs.model.SearchVO;
import com.woori.ajs.service.RevertStatCompleteService;

import egovframework.rte.fdl.property.EgovPropertyService;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import egovframework.ui.cmmn.ComUtil;
import egovframework.ui.cmmn.DateUtil;
import egovframework.ui.cmmn.FileUtil;
import egovframework.ui.cmmn.HttpUtil;
import egovframework.ui.cmmn.StringUtil;
import egovframework.ui.cmmn.XlsUtil;

@RestController
public class RevertStatCompleteApiController {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(RevertStatCompleteApiController.class);

	/** revertStatCompleteService */
	@Resource(name = "revertStatCompleteService")
	private RevertStatCompleteService revertStatCompleteService;

	/** EgovPropertyService */
	@Resource(name = "propertiesService")
	protected EgovPropertyService propertiesService;

	/** Validator */
	@Resource(name = "beanValidator")
	protected DefaultBeanValidator beanValidator;

	@Resource(name = "systemFileProperties")
	protected Properties sysProp;

	@GetMapping("/api/revert/stat/complete")
	public HashMap<String,Object> list(SearchVO searchVO) throws Exception {
		HashMap<String,Object> map = new HashMap<String,Object>();
		
		HttpUtil.setResult(map, HttpUtil.HttpType.T200);
		
		map.put("searchVO",searchVO);
		
		PaginationInfo paginationInfo = ComUtil.setListPagingInfo(propertiesService, searchVO);
		//searchVO.setRecordCountPerPage(-1);
		
		List<RevertStatCompleteVO> list = revertStatCompleteService.selectList(searchVO);
		map.put("resultList", list);
		
		int totCnt = revertStatCompleteService.selectListTotCnt(searchVO);
		//int totCnt = list==null ? 0 : list.size();
		
		paginationInfo.setTotalRecordCount(totCnt);
		map.put("paginationInfo", paginationInfo);
		
		return map;
	}
	
	@GetMapping("/api/revert/stat/complete/xls")
	public ModelAndView listXls(SearchVO searchVO, ModelAndView mv) throws Exception {
		mv.setViewName("downView");					//파일다운로드뷰
		String xlsDownName = StringUtil.concat(new String[] {"완료건_",DateUtil.getFormatDate("yyyyMMdd"),".xlsx"});
		searchVO.setRecordCountPerPage(-1);
		List<RevertStatCompleteVO> list = revertStatCompleteService.selectList(searchVO);
		List<String[]> xlsListsTitle = XlsUtil.createListsTitle();
		List<List<LinkedHashMap<String,String>>> xlsLists = XlsUtil.createLists();
		xlsListsTitle.add(new String[] {"생성일","업무","프로세스","구분","Ref.No","고객번호","고객명","통화","금액","S1","S2","QA1","QA2","접수자","스캔자","영업점명","TotalText","항목심사","S/W"});
		if(list!=null) {
			List<LinkedHashMap<String,String>> xlsList = XlsUtil.createList();
			for(int i=0;i<list.size();i++) {
				LinkedHashMap<String,String> rowMap = new LinkedHashMap<String,String>();
				// RevertStatCompleteVO row = (RevertStatCompleteVO)list.get(i);
				RevertStatCompleteVO row = list.get(i);
				rowMap.put("day", row.getInptRcpDt());									// 생성일
				rowMap.put("inptAtmcBizNm", row.getInptAtmcBizNm()); 					// 업무
				rowMap.put("aiInptQlasProsCd", row.getAiInptQlasProsCd()); 				// 프로세스
				rowMap.put("aiInptBizNm", row.getCompleteBizNmXls()); 					// 구분
				rowMap.put("actlFxRefno", row.getActlFxRefno()); 						// Ref NO
				rowMap.put("aiInptCusNo", row.getAiInptCusNo()); 						// 고객번호
				rowMap.put("aiInptCusNm", row.getAiInptCusNm()); 						// 고객명
				rowMap.put("fcCuNm", row.getFcCuNm()); 									// 통화
				rowMap.put("aiInptBuyAm", row.getAiInptBuyAm()); 						// 금액
				rowMap.put("s1User", row.getS1User()); 									// s1
				rowMap.put("s2User", row.getS2User()); 									// s2
				
				if("3".equals(row.getAiInptCmnCd())) {
					rowMap.put("s1UserQa", row.getS1UserQa());							// qa1
					rowMap.put("s2UserQa", row.getS2UserQa());							// qa2
				}else {
					rowMap.put("s1UserQa", "");											// qa1(수출||수입)
					rowMap.put("s2UserQa", "");											// qa2(수출||수입)
				}
				
				rowMap.put("trnOprNoEr", mergeNameAndEno(row.getTrnOprNoEr(), row.getTrnOprNo()));							// 접수자
				rowMap.put("aiInptDocScanChrgEnoEr", mergeNameAndEno(row.getAiInptDocScanChrgEnoEr(), row.getAiInptDocScanChrgEno()));	// 스캔자
				rowMap.put("krbrNm", mergeNameAndEno(row.getKrbrNm(), row.getDaccBrcd()));		// 영업점명(코드)
				rowMap.put("totaltextAiInptRstNm", row.getTotaltextAiInptRstNm()); 		// TotalText
				rowMap.put("itmInptAiInptRstNm", row.getItmInptAiInptRstNm()); 			// 항목심사
				rowMap.put("safewatchAiInptRstNm", row.getSafewatchAiInptRstNm()); 		// s/w
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