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

import com.woori.ajs.model.RevertStatAllVO;
import com.woori.ajs.model.RevertStatCompleteVO;
import com.woori.ajs.model.SearchVO;
import com.woori.ajs.service.RevertStatAllService;

import egovframework.rte.fdl.property.EgovPropertyService;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import egovframework.ui.cmmn.ComUtil;
import egovframework.ui.cmmn.DateUtil;
import egovframework.ui.cmmn.FileUtil;
import egovframework.ui.cmmn.HttpUtil;
import egovframework.ui.cmmn.StringUtil;
import egovframework.ui.cmmn.XlsUtil;

@RestController
public class RevertStatAllApiController {

	private static final Logger LOGGER = LoggerFactory.getLogger(RevertStatCompleteApiController.class);
	
	/** revertStatAllService */
	@Resource(name = "revertStatAllService")
	private RevertStatAllService revertStatAllService;

	/** EgovPropertyService */
	@Resource(name = "propertiesService")
	protected EgovPropertyService propertiesService;

	/** Validator */
	@Resource(name = "beanValidator")
	protected DefaultBeanValidator beanValidator;

	@Resource(name = "systemFileProperties")
	protected Properties sysProp;
	
	@GetMapping("/api/revert/stat/all")
	public HashMap<String, Object> list(SearchVO searchVO) throws Exception {
		HashMap<String,Object> map = new HashMap<String,Object>();
		HttpUtil.setResult(map, HttpUtil.HttpType.T200);
		map.put("searchVO",searchVO);
		
		PaginationInfo paginationInfo = ComUtil.setListPagingInfo(propertiesService, searchVO);
		List<RevertStatAllVO> list = revertStatAllService.selectList(searchVO);
		map.put("resultList", list);
		int totCnt = revertStatAllService.selectListTotCnt(searchVO);
		paginationInfo.setTotalRecordCount(totCnt);
		
		map.put("paginationInfo", paginationInfo);
		map.put("resultList", list);
		return map;
	}
	
	@GetMapping("/api/revert/stat/all/xls")
	public ModelAndView listXls(SearchVO searchVO, ModelAndView mv) throws Exception {
		mv.setViewName("downView");					//파일다운로드뷰
		String xlsDownName = StringUtil.concat(new String[] {"업무생성목록_",DateUtil.getFormatDate("yyyyMMdd"),".xlsx"});
		String tmcReq;
		searchVO.setRecordCountPerPage(-1);
		List<RevertStatAllVO> list = revertStatAllService.selectList(searchVO);
		List<String[]> xlsListsTitle = XlsUtil.createListsTitle();
		List<List<LinkedHashMap<String,String>>> xlsLists = XlsUtil.createLists();
		xlsListsTitle.add(new String[] {"생성일","업무","Ref.No","고객번호","고객명","통화","금액","생성구분","접수자","영업정명(코드)","상태"});
		if(list!=null) {
			List<LinkedHashMap<String,String>> xlsList = XlsUtil.createList();
			for(int i=0;i<list.size();i++) {
				LinkedHashMap<String,String> rowMap = new LinkedHashMap<String,String>();
				// RevertStatCompleteVO row = (RevertStatCompleteVO)list.get(i);
				RevertStatAllVO row = list.get(i);
				rowMap.put("inptRcpDt", row.getInptRcpDt());									// 생성일
				rowMap.put("inptAtmcBizDsNm", row.getInptAtmcBizDsNm()); 					// 업무
				rowMap.put("actlFxRefno", row.getActlFxRefno()); 						// Ref NO
				rowMap.put("aiInptCusNo", row.getAiInptCusNo()); 						// 고객번호
				rowMap.put("aiInptCusNm", row.getAiInptCusNm()); 						// 고객명
				rowMap.put("fcCuNm", row.getFcCuNm()); 	 								// 통화
				rowMap.put("aiInptBuyAm", row.getAiInptBuyAm()); 						// 금액
				rowMap.put("aiInspAtvtStsNm", row.getAiInspAtvtStsNm());								// 접수자ID
				rowMap.put("aiInptAtpeEno", row.getAiInptAtpeEno());							// 접수자명
				rowMap.put("aiInptBzbrNm", row.getAiInptBzbrNm());		// 영업점명
				
				if("1".equals(row.getInptAtmcReqDscd())) {
					tmcReq = "정상";
				}else if("2".equals(row.getInptAtmcReqDscd())) {
					tmcReq = "변경";
				}else if("3".equals(row.getInptAtmcReqDscd())) {
					tmcReq = "취소";
				}else {
					tmcReq = "기타";
				}
						
				rowMap.put("inptAtmcReqDscd", tmcReq);	// 스캔자명
						
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
}
