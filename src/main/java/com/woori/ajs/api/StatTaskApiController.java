package com.woori.ajs.api;

import java.io.File;
import java.math.BigDecimal;
import java.text.DecimalFormat;
import java.text.NumberFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Properties;

import javax.annotation.Resource;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;
import org.springmodules.validation.commons.DefaultBeanValidator;

import com.woori.ajs.model.RevertStatAlertVO;
import com.woori.ajs.model.SearchVO;
import com.woori.ajs.model.StatTaskVO;
import com.woori.ajs.service.StatTaskService;

import egovframework.rte.fdl.property.EgovPropertyService;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import egovframework.ui.cmmn.ComUtil;
import egovframework.ui.cmmn.DateUtil;
import egovframework.ui.cmmn.FileUtil;
import egovframework.ui.cmmn.HttpUtil;
import egovframework.ui.cmmn.StringUtil;
import egovframework.ui.cmmn.XlsUtil;

@RestController
public class StatTaskApiController {

	/** StatTaskService */
	@Resource(name = "StatTaskService")
	private StatTaskService StatTaskService;

	/** EgovPropertyService */
	@Resource(name = "propertiesService")
	protected EgovPropertyService propertiesService;

	/** Validator */
	@Resource(name = "beanValidator")
	protected DefaultBeanValidator beanValidator;

	@Resource(name = "systemFileProperties")
	protected Properties sysProp;

	
	@GetMapping("/api/stat/task2")
	public HashMap<String,Object> list2(SearchVO searchVO) throws Exception {
		HashMap<String,Object> map = new HashMap<String,Object>();
		
		HttpUtil.setResult(map, HttpUtil.HttpType.T200);
		map.put("searchVO",searchVO);
		searchVO.setRecordCountPerPage(-1);
		PaginationInfo paginationInfo = ComUtil.setListPagingInfo(propertiesService, searchVO);	
		
		List<StatTaskVO> list = StatTaskService.selectList(searchVO);
		paginationInfo.setTotalRecordCount(list.size());
		map.put("resultList", list);
		map.put("paginationInfo",paginationInfo);
		return map;
	}

	@SuppressWarnings("null")
	@GetMapping("/api/stat/task")
	public HashMap<String,Object> list(SearchVO searchVO) throws Exception {
		HashMap<String,Object> map = new HashMap<String,Object>();
	//	StatTaskVO avgT = null;
		HttpUtil.setResult(map, HttpUtil.HttpType.T200);
		map.put("searchVO",searchVO);
		searchVO.setRecordCountPerPage(-1);
		PaginationInfo paginationInfo = ComUtil.setListPagingInfo(propertiesService, searchVO);	
		String inptAtmcBizDscdList = searchVO.getInptAtmcBizDscdList();
		String[] inptAtmcBizDscd = inptAtmcBizDscdList.split(",");
		int length = inptAtmcBizDscd.length;
		int imAuth = 0;
		int exAuth = 0;
		int imSugi = 0;
		int exSugi = 0;
		int qa = 0;
		int qa2 = 0;
		
		switch (length) {
		case 1:
			searchVO.setInptAtmcBizDscd(inptAtmcBizDscd[0]);
			break;
			
		case 2:
			searchVO.setInptAtmcBizDscd(inptAtmcBizDscd[0]);
			searchVO.setInptAtmcBizDscd2(inptAtmcBizDscd[1]);
			break;
			
		case 3:
			searchVO.setInptAtmcBizDscd(inptAtmcBizDscd[0]);
			searchVO.setInptAtmcBizDscd2(inptAtmcBizDscd[1]);
			searchVO.setInptAtmcBizDscd3(inptAtmcBizDscd[2]);
			break;	

		default:
			break;
		}
		List<StatTaskVO> list = StatTaskService.selectList(searchVO);
		int cnt=0;
	
	
		Double avgTime = 0.0;
		String temp1 = "";
		String temp2 = "";
		String temp3 = "";
		String totalAvgTime = "";

		String[][] imAuthDateSet = null; 
		String[][] exAuthDateSet = null;
		String[][] imSugiDateSet = null;
		String[][] exSugiDateSet = null;
		String[][] qaDateSet = null;
		String[][] qa2DateSet = null;
	
		int imAuthFordataCnt1 = 0;
		int imAuthFordataCnt2 = 0;
		int exAuthFordataCnt1 = 0;
		int exAuthFordataCnt2 = 0;
		int imSugiFordataCnt1 = 0;
		int imSugiFordataCnt2 = 0;
		int exSugiFordataCnt1 = 0;
		int exSugiFordataCnt2 = 0;
		int qaFordataCnt1 = 0;
		int qaFordataCnt2 = 0;
		int qa2FordataCnt1 = 0;
		int qa2FordataCnt2 = 0;
		
		int listSize = 0;
		int imAuthforjump = 0;
		int exAuthforjump = 0;
		int imSugiforjump = 0;
		int exSugiforjump = 0;
		int qaforjump = 0;		
		int qa2forjump = 0;

		NumberFormat f = NumberFormat.getInstance();
		f.setGroupingUsed(false);
		
		
		if(list.size() != 0) {
			listSize = list.size();
			imAuthDateSet = new String[listSize][listSize];
			exAuthDateSet = new String[listSize][listSize];
			imSugiDateSet = new String[listSize][listSize];
			exSugiDateSet = new String[listSize][listSize];
			qaDateSet = new String[listSize][listSize];
			qa2DateSet = new String[listSize][listSize];
			for(StatTaskVO n : list) {
				
				if(n.getAvg() != null) {
					
					avgTime += Double.parseDouble(n.getAvg());
				}
				
				if("수입 자동 심사".equals(n.getCate())) {
					if(imAuthFordataCnt1 == 0 && imAuthFordataCnt2 ==0 && imAuthforjump==0) {
						imAuthDateSet[imAuthFordataCnt1][imAuthFordataCnt2] = n.getInptRcpDt(); ///////////////// 2019 11 20 -  0,0
						imAuthforjump=1;
					}else {							
						if(n.getInptRcpDt().equals(imAuthDateSet[imAuthFordataCnt1][imAuthFordataCnt2])) { // 2019 11 20 -  0,0
							imAuthFordataCnt2++; //1
							imAuthDateSet[imAuthFordataCnt1][imAuthFordataCnt2] = n.getInptRcpDt(); //n : 1 , 2019 11 20 - 0,1	
						}else {
							imAuthFordataCnt1++; //1
							imAuthFordataCnt2 = 0;
							imAuthDateSet[imAuthFordataCnt1][imAuthFordataCnt2] = n.getInptRcpDt(); // n : 6, 2019 11 21 - 1 ,5
						}
					}
					imAuth++;
				}else if("수출 자동 심사".equals(n.getCate())) {
					if(exAuthFordataCnt1 == 0 && exAuthFordataCnt2 ==0 && exAuthforjump==0) {
						exAuthDateSet[exAuthFordataCnt1][exAuthFordataCnt2] = n.getInptRcpDt(); ///////////////// 2019 11 20 -  0,0
						exAuthforjump=1;
					}else {
						if(n.getInptRcpDt().equals(exAuthDateSet[exAuthFordataCnt1][exAuthFordataCnt2])) { // 2019 11 20 -  0,0
							exAuthFordataCnt2++; //1
							exAuthDateSet[exAuthFordataCnt1][exAuthFordataCnt2] = n.getInptRcpDt(); //n : 1 , 2019 11 20 - 0,1
						}else {
							exAuthFordataCnt1++; //1
							exAuthFordataCnt2 = 0;
							exAuthDateSet[exAuthFordataCnt1][exAuthFordataCnt2] = n.getInptRcpDt(); // n : 6, 2019 11 21 - 1 ,5
						}
					}
					exAuth++;
				}else if("수입 수기 심사".equals(n.getCate())) {
					if(imSugiFordataCnt1 == 0 && imSugiFordataCnt2 ==0 && imSugiforjump==0) {
						imSugiDateSet[imSugiFordataCnt1][imSugiFordataCnt2] = n.getInptRcpDt(); ///////////////// 2019 11 20 -  0,0
						imSugiforjump=1;
					}else {
						if(n.getInptRcpDt().equals(imSugiDateSet[imSugiFordataCnt1][imSugiFordataCnt2])) { // 2019 11 20 -  0,0
							imSugiFordataCnt2++; //1
							imSugiDateSet[imSugiFordataCnt1][imSugiFordataCnt2] = n.getInptRcpDt(); //n : 1 , 2019 11 20 - 0,1
						}else {
							imSugiFordataCnt1++; //1
							imSugiFordataCnt2 = 0;
							imSugiDateSet[imSugiFordataCnt1][imSugiFordataCnt2] = n.getInptRcpDt(); // n : 6, 2019 11 21 - 1 ,5
						}
					}
					imSugi++;
				}else if("수출 수기 심사".equals(n.getCate())) {
					if(exSugiFordataCnt1 == 0 && exSugiFordataCnt2 ==0 && exSugiforjump==0) {
						exSugiDateSet[exSugiFordataCnt1][exSugiFordataCnt2] = n.getInptRcpDt(); ///////////////// 2019 11 20 -  0,0
						exSugiforjump=1;
					}else {
						if(n.getInptRcpDt().equals(exSugiDateSet[exSugiFordataCnt1][exSugiFordataCnt2])) { // 2019 11 20 -  0,0
							exSugiFordataCnt2++; //1
							exSugiDateSet[exSugiFordataCnt1][exSugiFordataCnt2] = n.getInptRcpDt(); //n : 1 , 2019 11 20 - 0,1
						}else {
							exSugiFordataCnt1++; //1
							exSugiFordataCnt2 = 0;
							exSugiDateSet[exSugiFordataCnt1][exSugiFordataCnt2] = n.getInptRcpDt(); // n : 6, 2019 11 21 - 1 ,5
						}
					}
					exSugi++;
				}else if("QA 자체점검(수출)".equals(n.getCate())) { // QA 자체점검(수출)
					if(qaFordataCnt1 == 0 && qaFordataCnt2 ==0 && qaforjump==0) {
						qaDateSet[qaFordataCnt1][qaFordataCnt2] = n.getInptRcpDt(); ///////////////// 2019 11 20 -  0,0
						qaforjump=1;
					}else {
						if(n.getInptRcpDt().equals(qaDateSet[qaFordataCnt1][qaFordataCnt2])) { // 2019 11 20 -  0,0
							qaFordataCnt2++; //1
							qaDateSet[qaFordataCnt1][qaFordataCnt2] = n.getInptRcpDt(); //n : 1 , 2019 11 20 - 0,1
						}else {
							qaFordataCnt1++; //1
							qaFordataCnt2 = 0;
							qaDateSet[qaFordataCnt1][qaFordataCnt2] = n.getInptRcpDt(); // n : 6, 2019 11 21 - 1 ,5
						}
					}
					qa++;
				}
		
				else if("QA 자체점검(수입)".equals(n.getCate())) {
					if(qa2FordataCnt1 == 0 && qa2FordataCnt2 ==0 && qa2forjump==0) {
						qa2DateSet[qa2FordataCnt1][qa2FordataCnt2] = n.getInptRcpDt(); ///////////////// 2019 11 20 -  0,0
						qa2forjump=1;
					}else {
						if(n.getInptRcpDt().equals(qa2DateSet[qa2FordataCnt1][qa2FordataCnt2])) { // 2019 11 20 -  0,0
							qa2FordataCnt2++; //1
							qa2DateSet[qa2FordataCnt1][qa2FordataCnt2] = n.getInptRcpDt(); //n : 1 , 2019 11 20 - 0,1
						}else {
							qa2FordataCnt1++; //1
							qa2FordataCnt2 = 0;
							qa2DateSet[qa2FordataCnt1][qa2FordataCnt2] = n.getInptRcpDt(); // n : 6, 2019 11 21 - 1 ,5
						}
					}
					qa2++;
				}			
			}
			
			temp1 = "0000" + Math.floor(Math.floor(Math.round(avgTime) / 60)/60);
			if(temp1.split("\\.")[0].length() > 8) {
				temp1 = Double.toString(Math.floor(Math.floor(Math.round(avgTime) / 60)/60));
			}
			temp1 = temp1.substring(temp1.length()-6, temp1.length()-2);
			temp2 = "0" + Math.floor(Math.round(avgTime) / 60) % 60;
			temp2 = temp2.substring(temp2.length()-4, temp2.length()-2);
			temp3 = "0" + Math.round(avgTime) % 60;
			if(temp3.length()>2) {
				temp3 = temp3.substring(1);
			}
			StringBuffer a = new StringBuffer(temp1);
			
			a.append(':');
			a.append(temp2);
			a.append(':');
			a.append(temp3);
			totalAvgTime = a.toString();
			//totalAvgTime = temp1 + ":";
			//totalAvgTime += temp2;
			//totalAvgTime += ":";
			//totalAvgTime += temp3;
		}
		paginationInfo.setTotalRecordCount(StatTaskService.selectListTotCnt(searchVO) - 1);
	
		map.put("resultList", list);
		
		map.put("imAuth", imAuth); // 지워도 됨
		map.put("exAuth", exAuth); // 지워도 됨
		map.put("imSugi", imSugi); // 지워도 됨
		map.put("exSugi", exSugi); // 지워도 됨
		map.put("qa", qa); // 지워도 됨
		map.put("qa2", qa2);
		
		
		map.put("imAuthDateSet", imAuthDateSet); // 지워도 됨
		map.put("exAuthDateSet", exAuthDateSet); // 지워도 됨
		map.put("imSugiDateSet", imSugiDateSet); // 지워도 됨
		map.put("exSugiDateSet", exSugiDateSet); // 지워도 됨
		map.put("qaDateSet", qaDateSet); // 지워도 됨
		map.put("qa2DateSet", qa2DateSet);
		
		map.put("totalAvgTime", totalAvgTime);
		map.put("paginationInfo",paginationInfo);
		return map;
	}
	
	@GetMapping("/api/stat/task/xls")
	public ModelAndView listXls(SearchVO searchVO, ModelAndView mv) throws Exception {
		mv.setViewName("downView");
		
		String xlsDownName = StringUtil.concat(new String[] {"업무별 통계_",DateUtil.getFormatDate("yyyyMMdd"),".xlsx"});
		
		searchVO.setRecordCountPerPage(-1);
		List<StatTaskVO> dataList = StatTaskService.selectList(searchVO);
		//엑셀 데이터 만들기.
		List<String[]> xlsListsTitle = XlsUtil.createListsTitle();
		List<List<LinkedHashMap<String,String>>> xlsLists = XlsUtil.createLists();
		//리스트1
		xlsListsTitle.add(new String[] {"업무구분", "일자", "권한","직원번호","직원명","처리건","총처리 시간","평균처리 시간"});
		Double avgTime = 0.0;
		String temp1 = "";
		String temp2 = "";
		String temp3 = "";
		String totalAvgTime = "";
		
		if(dataList!=null) {
			List<LinkedHashMap<String,String>> xlsList = XlsUtil.createList();
			
			for(StatTaskVO n : dataList) {
				if(n.getAvg() != null) {
					avgTime += Double.parseDouble(n.getAvg());
				}
			}
			
			temp1 = "0000" + Math.floor(Math.floor(Math.round(avgTime) / 60)/60);
			if(temp1.split("\\.")[0].length() > 8) {
				temp1 = Double.toString(Math.floor(Math.floor(Math.round(avgTime) / 60)/60));
			}
			temp1 = temp1.substring(temp1.length()-6, temp1.length()-2);
			temp2 = "0" + Math.floor(Math.round(avgTime) / 60) % 60;
			temp2 = temp2.substring(temp2.length()-4, temp2.length()-2);
			temp3 = "0" + Math.round(avgTime) % 60;
			if(temp3.length()>2) {
				temp3 = temp3.substring(1);
			}
			
			StringBuffer a = new StringBuffer(temp1);
			
			a.append(':');
			a.append(temp2);
			a.append(':');
			a.append(temp3);
			totalAvgTime = a.toString();
			
			//totalAvgTime = temp1 + ":";
			//totalAvgTime += temp2;
			//totalAvgTime += ":";
			//totalAvgTime += temp3;
			
			for(int i=0;i<dataList.size();i++) {
				

				LinkedHashMap<String,String> rowMap = new LinkedHashMap<String,String>();
				StatTaskVO row = dataList.get(i);
				/*if(row.getAvg() != null) {
					
					avgTime += Double.parseDouble(row.getAvg());
				}*/
				rowMap.put("cate", row.getCate());
				rowMap.put("inptRcpDt", row.getInptRcpDt());
				rowMap.put("auth", row.getAuth());
				rowMap.put("userId", row.getUserId());
				rowMap.put("aiInptUserNm", row.getAiInptUserNm());
				rowMap.put("countEno", row.getCountEno());
				rowMap.put("totalTime", row.getTotalTime());
				//rowMap.put("avgTime", row.getAvgTime());
				
				if(i == dataList.size()-1) {
					rowMap.put("avgTime", totalAvgTime);
				}else {
					rowMap.put("avgTime", row.getAvgTime());
				}
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