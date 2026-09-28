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

import com.woori.ajs.model.SearchVO;
import com.woori.ajs.model.TaskLogResultVO;
import com.woori.ajs.service.TaskLogResultService;

import egovframework.rte.fdl.property.EgovPropertyService;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import egovframework.ui.cmmn.ComUtil;
import egovframework.ui.cmmn.DateUtil;
import egovframework.ui.cmmn.HttpUtil;
import egovframework.ui.cmmn.StringUtil;
import egovframework.ui.cmmn.XlsUtil;

@RestController
public class TaskLogResultApiController {
	
	/** taskLogResultService */
	@Resource(name = "taskLogResultService")
	private TaskLogResultService taskLogResultService;

	/** EgovPropertyService */
	@Resource(name = "propertiesService")
	protected EgovPropertyService propertiesService;

	/** Validator */
	@Resource(name = "beanValidator")
	protected DefaultBeanValidator beanValidator;

	@Resource(name = "systemFileProperties")
	protected Properties sysProp;
	
	@GetMapping("/blank/api/task/log/result")
	public HashMap<String,Object> list(SearchVO searchVO) throws Exception {
		HashMap<String,Object> map = new HashMap<String,Object>();
		
		HttpUtil.setResult(map, HttpUtil.HttpType.T200);
		map.put("searchVO",searchVO);
		
		PaginationInfo paginationInfo = ComUtil.setListPagingInfo(propertiesService, searchVO);
		
		List<TaskLogResultVO> list = taskLogResultService.selectList(searchVO);
		map.put("resultList", list);
		
		//int totCnt =  taskLogResultService.selectListTotCnt(searchVO);
		int totCnt =  list.size();
		
		paginationInfo.setTotalRecordCount(totCnt);
		map.put("paginationInfo", paginationInfo);
		return map;
	}

	@GetMapping("/api/task/log/result/xls")
	public ModelAndView listXls(SearchVO searchVO, ModelAndView mv) throws Exception {
		mv.setViewName("downView");
		
		String xlsDownName = StringUtil.concat(new String[] {"성과관리_",DateUtil.getFormatDate("yyyyMMdd"),".xlsx"});

		//-1을 넘기면, 리스트 전체가 나옴, 페이징 안됨.
		searchVO.setRecordCountPerPage(-1);

		List<TaskLogResultVO> dataList = taskLogResultService.selectList(searchVO);

		//엑셀 데이터 만들기.
		List<String[]> xlsListsTitle = XlsUtil.createListsTitle();
		List<List<LinkedHashMap<String,String>>> xlsLists = XlsUtil.createLists();
		
		//리스트1
		xlsListsTitle.add(new String[] {"시작일","종료일","권한","직원번호","직원명","수출 - 선적서류 제재심사","수출 - 선적서류 제재심사(수기)","수출 - SafeWatch",
				"수입 - 선적서류 제재심사","수입 - 선적서류 제재심사(수기)","수입 - SafeWatch","QA","합계","일평균"});
		
		if(dataList!=null) {
			List<LinkedHashMap<String,String>> xlsList = XlsUtil.createList();
			for(int i=0;i<dataList.size();i++) {
				LinkedHashMap<String,String> rowMap = new LinkedHashMap<String,String>();
				TaskLogResultVO row = dataList.get(i);
				rowMap.put("sdate", searchVO.getSchSdate1());
				rowMap.put("edate", searchVO.getSchEdate1());
				rowMap.put("aiInptUserAutVal", row.getAiInptUserAutVal());
				rowMap.put("aiInptUserEno", row.getAiInptUserEno());
				rowMap.put("aiInptUserNm", row.getAiInptUserNm());
				rowMap.put("cnt1", row.getCnt1());
				rowMap.put("cnt2", row.getCnt2());
				rowMap.put("cnt3", row.getCnt3());
				rowMap.put("cnt4", row.getCnt4());
				rowMap.put("cnt5", row.getCnt5());
				rowMap.put("cnt6", row.getCnt6());
				rowMap.put("cnt7", row.getCnt7());
				rowMap.put("userSum", row.getUserSum());
				rowMap.put("dateAvg", row.getDateAvg());
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