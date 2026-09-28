package com.woori.ajs.api;

import java.io.File;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;
import org.springmodules.validation.commons.DefaultBeanValidator;

import com.woori.ajs.model.LoginVO;
import com.woori.ajs.model.RevertStatAlertVO;
import com.woori.ajs.model.SearchVO;
import com.woori.ajs.service.RevertStatAlertService;

import egovframework.rte.fdl.property.EgovPropertyService;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import egovframework.ui.cmmn.ComUtil;
import egovframework.ui.cmmn.DateUtil;
import egovframework.ui.cmmn.HttpUtil;
import egovframework.ui.cmmn.StringUtil;
import egovframework.ui.cmmn.XlsUtil;
import egovframework.ui.util.LoginUtils;

@RestController
public class RevertStatAlertApiController {

	/** revertStatAlertService */
	@Resource(name = "revertStatAlertService")
	private RevertStatAlertService revertStatAlertService;

	/** EgovPropertyService */
	@Resource(name = "propertiesService")
	protected EgovPropertyService propertiesService;

	/** Validator */
	@Resource(name = "beanValidator")
	protected DefaultBeanValidator beanValidator;

	@Resource(name = "systemFileProperties")
	protected Properties sysProp;

	@GetMapping("/api/revert/stat/alert")
	public HashMap<String,Object> list(HttpServletRequest request, SearchVO searchVO) throws Exception {
		HashMap<String,Object> map = new HashMap<String,Object>();
		LoginVO loginInfo = LoginUtils.getLoginInfo(request);
		
		HttpUtil.setResult(map, HttpUtil.HttpType.T200);

		searchVO.setUserId(loginInfo.getId());

		map.put("searchVO",searchVO);
		
		PaginationInfo paginationInfo = ComUtil.setListPagingInfo(propertiesService, searchVO);
		//searchVO.setRecordCountPerPage(-1);
		
		List<RevertStatAlertVO> list = revertStatAlertService.selectList(searchVO);
		map.put("resultList", list);

		int totCnt = revertStatAlertService.selectListTotCnt(searchVO);
		//int totCnt = list==null ? 0 : list.size();
		
		paginationInfo.setTotalRecordCount(totCnt);
		map.put("paginationInfo", paginationInfo);
		
		return map;
	}

	@GetMapping("/api/revert/stat/alert/xls")
	public ModelAndView listXls(SearchVO searchVO, ModelAndView mv) throws Exception {
		mv.setViewName("downView");

		String xlsDownName = StringUtil.concat(new String[] {"경보건_",DateUtil.getFormatDate("yyyyMMdd"),".xlsx"});
		
		//-1을 넘기면, 리스트 전체가 나옴, 페이징 안됨.
		searchVO.setRecordCountPerPage(-1);

		List<RevertStatAlertVO> dataList = revertStatAlertService.selectList(searchVO);

		//엑셀 데이터 만들기.
		List<String[]> xlsListsTitle = XlsUtil.createListsTitle();
		List<List<LinkedHashMap<String,String>>> xlsLists = XlsUtil.createLists();
		
		//리스트1
		xlsListsTitle.add(new String[] {"생성일","업무구분","Ref.No","액티비티","고객번호","고객명","통화","금액","S1","S2","TotalText","항목심사","S/W"});
		
		if(dataList!=null) {
			List<LinkedHashMap<String,String>> xlsList = XlsUtil.createList();
			for(int i=0;i<dataList.size();i++) {
				LinkedHashMap<String,String> rowMap = new LinkedHashMap<String,String>();
				RevertStatAlertVO row = dataList.get(i);
				rowMap.put("inptRcpDtStr", row.getInptRcpDtStr());
				rowMap.put("inptAtmcBizDsNm", row.getInptAtmcBizDsNm());
				rowMap.put("actlFxRefno", row.getActlFxRefno());
				rowMap.put("inptAtvtNm", row.getInptAtvtNm());
				
				rowMap.put("aiInptCusNo", row.getAiInptCusNo());
				rowMap.put("aiInptCusNm", row.getAiInptCusNm());
				
				rowMap.put("fcCuNm", row.getFcCuNm());
				rowMap.put("aiInptBuyAm", row.getAiInptBuyAm());
				rowMap.put("aiInspeEnm", row.getAiInspeEnm());
				rowMap.put("aiAppvEnm", row.getAiAppvEnm());
				rowMap.put("totaltextAiInptRstNm", row.getTotaltextAiInptRstNm());
				rowMap.put("itmInptAiInptRstNm", row.getItmInptAiInptRstNm());
				rowMap.put("safewatchAiInptRstNm", row.getSafewatchAiInptRstNm());
				xlsList.add(rowMap);
			}
			xlsLists.add(xlsList);
		}
		
		//엑셀 다운로드 처리.
		String uploadPath = StringUtil.nvl(sysProp.getProperty("upload.path"));
		File xlsFile = XlsUtil.createXlsFile(uploadPath, xlsListsTitle, xlsLists);
		
		mv.addObject("downloadFile",xlsFile);
		mv.addObject("downloadFileName",xlsDownName);
		return mv;
	}

}