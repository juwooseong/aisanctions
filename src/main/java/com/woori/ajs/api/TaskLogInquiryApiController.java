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

import com.woori.ajs.model.CommonCodeVO;
import com.woori.ajs.model.SearchVO;
import com.woori.ajs.model.TaskLogInquiryVO;
import com.woori.ajs.model.TaskLogRegVO;
import com.woori.ajs.service.CommonCodeService;
import com.woori.ajs.service.TaskLogEndService;
import com.woori.ajs.service.TaskLogInquiryService;
import com.woori.ajs.service.TaskLogRegService;

import egovframework.rte.fdl.property.EgovPropertyService;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import egovframework.ui.cmmn.CodeUtil;
import egovframework.ui.cmmn.ComUtil;
import egovframework.ui.cmmn.DateUtil;
import egovframework.ui.cmmn.HttpUtil;
import egovframework.ui.cmmn.StringUtil;
import egovframework.ui.cmmn.XlsUtil;

@RestController
public class TaskLogInquiryApiController {
	
	@Resource(name = "taskLogInquiryService")
	private TaskLogInquiryService taskLogInquiryService;
	
	@Resource(name = "taskLogRegService")
	private TaskLogRegService taskLogRegService;

	@Resource(name = "taskLogEndService")
	private TaskLogEndService taskLogEndService;

	/** EgovPropertyService */
	@Resource(name = "propertiesService")
	protected EgovPropertyService propertiesService;
	
	/** Validator */
	@Resource(name = "beanValidator")
	protected DefaultBeanValidator beanValidator;
	
	@Resource(name = "systemFileProperties")
	protected Properties sysProp;
	
	/** 공통 서비스 **/
	@Resource(name = "commonCodeService")
	private CommonCodeService commonCodeService;

	@GetMapping("/api/task/log/inquiry")
	public HashMap<String,Object> list(SearchVO searchVO) throws Exception {
		HashMap<String,Object> map = new HashMap<String,Object>();
		
		HttpUtil.setResult(map, HttpUtil.HttpType.T200);

		//업무일지 - 업무마감 (5010) - 당일목록 건수 
		//업무일지 - 업무일지 등록 (5020) - 제재심사 건수
		SearchVO svo = new SearchVO();
		svo.setSchSdate1(searchVO.getSchSdate1());
		svo.setSchEdate1(searchVO.getSchEdate1());
		svo.setInptAtmcBizDscd("2");
		searchVO.setTaskDatesCnt1(taskLogEndService.getTaskDatesCnt(svo));	//수출
		svo.setInptAtmcBizDscd("1");
		searchVO.setTaskDatesCnt2(taskLogEndService.getTaskDatesCnt(svo));	//수입
		svo.setInptAtmcBizDscd(null);
		searchVO.setTaskDatesCnt3(taskLogEndService.getTaskDatesCnt(svo));	//전체
		
		//통계건수
		List<TaskLogRegVO> list = taskLogRegService.selectList(searchVO);
		List<TaskLogRegVO> list2 = taskLogRegService.select2List(searchVO);
		List<TaskLogRegVO> list3 = taskLogRegService.select3List(searchVO);
		List<TaskLogRegVO> list4 = taskLogRegService.select4List(searchVO);
		List<TaskLogRegVO> list5 = taskLogRegService.select5List(searchVO);
		map.put("list", list);
		map.put("list2", list2);
		map.put("list3", list3);
		map.put("list4", list4);
		map.put("list5", list5);
		
		return map;
	}

	@GetMapping("/api/task/log/inquiry/chart1")
	public HashMap<String,Object> chart1(SearchVO searchVO) throws Exception {
		HashMap<String,Object> map = new HashMap<String,Object>();
		
		HttpUtil.setResult(map, HttpUtil.HttpType.T200);
		
		List<TaskLogInquiryVO> chartList = taskLogInquiryService.selectForChart(searchVO);
		map.put("chartList", chartList);
		
		return map;
	}

	@GetMapping("/api/task/log/inquiry/chart2")
	public HashMap<String,Object> chart2(SearchVO searchVO) throws Exception {
		HashMap<String,Object> map = new HashMap<String,Object>();
		
		HttpUtil.setResult(map, HttpUtil.HttpType.T200);
		
		List<TaskLogInquiryVO> chartList = taskLogInquiryService.selectForChart2(searchVO);
		map.put("chartList", chartList);
		
		return map;
	}

	@GetMapping("/api/task/log/inquiry/etc")
	public HashMap<String,Object> etcList(SearchVO searchVO) throws Exception {
		HashMap<String,Object> map = new HashMap<String,Object>();
		
		HttpUtil.setResult(map, HttpUtil.HttpType.T200);
		
		PaginationInfo paginationInfo = ComUtil.setListPagingInfo(propertiesService, searchVO);
		
		List<TaskLogRegVO> list = taskLogRegService.select5List(searchVO);
		map.put("resultList", list);
		
		int totCnt = list==null ? 0 : list.size();
		
		paginationInfo.setTotalRecordCount(totCnt);
		map.put("paginationInfo", paginationInfo);
		
		return map;
	}

	@GetMapping("/api/task/log/inquiry/xls")
	public ModelAndView listXls(SearchVO searchVO, ModelAndView mv) throws Exception {
		mv.setViewName("downView");

		SearchVO vo = new SearchVO();
		
		String xlsDownName = StringUtil.concat(new String[] {"업무일지_",DateUtil.getFormatDate("yyyyMMdd"),".xlsx"});

		//-1을 넘기면, 리스트 전체가 나옴, 페이징 안됨.
		searchVO.setRecordCountPerPage(-1);

		//업무일지 - 업무마감 (5010) - 당일목록 건수 
		//업무일지 - 업무일지 등록 (5020) - 제재심사 건수
		SearchVO svo = new SearchVO();
		svo.setSchSdate1(searchVO.getSchSdate1());
		svo.setSchEdate1(searchVO.getSchEdate1());
		svo.setInptAtmcBizDscd("2");
		searchVO.setTaskDatesCnt1(taskLogEndService.getTaskDatesCnt(svo));	//수출
		svo.setInptAtmcBizDscd("1");
		searchVO.setTaskDatesCnt2(taskLogEndService.getTaskDatesCnt(svo));	//수입
		svo.setInptAtmcBizDscd(null);
		searchVO.setTaskDatesCnt3(taskLogEndService.getTaskDatesCnt(svo));	//전체

		//통계건수
		List<TaskLogRegVO> dataList = taskLogRegService.selectList(searchVO);
		List<TaskLogRegVO> dataList2 = taskLogRegService.select2List(searchVO);
		List<TaskLogRegVO> dataList3 = taskLogRegService.select3List(searchVO);
		List<TaskLogRegVO> dataList4 = taskLogRegService.select4List(searchVO);
		List<TaskLogRegVO> dataList5 = taskLogRegService.select5List(searchVO);

		//컨트롤러에서 코드 가져오기.
		//공통그룹코드 set(업무일지구분코드)
		vo.setAiInptGrpCd("322");
		List<CommonCodeVO> taskLogGrpCodeList = commonCodeService.selectAllCommonCodeList(vo);

		//컨트롤러에서 코드 가져오기.
		//공통그룹코드 set(업무일지항목코드)
		vo.setAiInptGrpCd("323");
		List<CommonCodeVO> taskLogItmCodeList = commonCodeService.selectAllCommonCodeList(vo);

		//엑셀 데이터 만들기.
		List<String[]> xlsListsTitle = XlsUtil.createListsTitle();
		List<List<LinkedHashMap<String,String>>> xlsLists = XlsUtil.createLists();
		
		//리스트1
		String listTitle1 = CodeUtil.getVal(taskLogGrpCodeList, "01");
		xlsListsTitle.add(new String[] {listTitle1,"시작일","종료일","수출","수입","합계"});
		if(dataList!=null) {
			List<LinkedHashMap<String,String>> xlsList = XlsUtil.createList();
			for(int i=0;i<dataList.size();i++) {
				LinkedHashMap<String,String> rowMap = new LinkedHashMap<String,String>();
				TaskLogRegVO row = dataList.get(i);
				String rowTitle = getXlsRowTitle(1, i+1, taskLogGrpCodeList, taskLogItmCodeList);
				rowMap.put("gbn", rowTitle);
				rowMap.put("sdate", searchVO.getSchSdate1());
				rowMap.put("edate", searchVO.getSchEdate1());
				rowMap.put("col1", row.getCol1());
				rowMap.put("col2", row.getCol2());
				rowMap.put("col3", row.getCol3());
				xlsList.add(rowMap);
			}
			xlsLists.add(xlsList);
		}

		//리스트2
		String listTitle2 = CodeUtil.getVal(taskLogGrpCodeList, "02");
		xlsListsTitle.add(new String[] {listTitle2,"시작일","종료일","수출","수입","당발","타발","기타","합계"});
		if(dataList2!=null) {
			List<LinkedHashMap<String,String>> xlsList = XlsUtil.createList();
			for(int i=0;i<dataList2.size();i++) {
				LinkedHashMap<String,String> rowMap = new LinkedHashMap<String,String>();
				TaskLogRegVO row = dataList2.get(i);
				String rowTitle = getXlsRowTitle(2, i+1, taskLogGrpCodeList, taskLogItmCodeList);
				rowMap.put("gbn", rowTitle);
				rowMap.put("sdate", searchVO.getSchSdate1());
				rowMap.put("edate", searchVO.getSchEdate1());
				rowMap.put("col1", row.getCol1());
				rowMap.put("col2", row.getCol2());
				rowMap.put("col3", row.getCol3());
				rowMap.put("col4", row.getCol4());
				rowMap.put("col5", row.getCol5());
				rowMap.put("col6", row.getCol6());
				xlsList.add(rowMap);
			}
			xlsLists.add(xlsList);
		}

		//리스트3
		String listTitle3 = CodeUtil.getVal(taskLogGrpCodeList, "03");
		xlsListsTitle.add(new String[] {listTitle3,"시작일","종료일","수신전문","발신전문","합계"});
		if(dataList3!=null) {
			List<LinkedHashMap<String,String>> xlsList = XlsUtil.createList();
			for(int i=0;i<dataList3.size();i++) {
				LinkedHashMap<String,String> rowMap = new LinkedHashMap<String,String>();
				TaskLogRegVO row = dataList3.get(i);
				String rowTitle = getXlsRowTitle(3, i+1, taskLogGrpCodeList, taskLogItmCodeList);
				rowMap.put("gbn", rowTitle);
				rowMap.put("sdate", searchVO.getSchSdate1());
				rowMap.put("edate", searchVO.getSchEdate1());
				rowMap.put("col1", row.getCol1());
				rowMap.put("col2", row.getCol2());
				rowMap.put("col3", row.getCol3());
				xlsList.add(rowMap);
			}
			xlsLists.add(xlsList);
		}

		//리스트4
		String listTitle4 = CodeUtil.getVal(taskLogGrpCodeList, "04");
		xlsListsTitle.add(new String[] {listTitle4,"시작일","종료일","수출","수입","당발","타발","합계"});
		if(dataList4!=null) {
			List<LinkedHashMap<String,String>> xlsList = XlsUtil.createList();
			for(int i=0;i<dataList4.size();i++) {
				LinkedHashMap<String,String> rowMap = new LinkedHashMap<String,String>();
				TaskLogRegVO row = dataList4.get(i);
				String rowTitle = getXlsRowTitle(4, i+1, taskLogGrpCodeList, taskLogItmCodeList);
				rowMap.put("gbn", rowTitle);
				rowMap.put("sdate", searchVO.getSchSdate1());
				rowMap.put("edate", searchVO.getSchEdate1());
				rowMap.put("col1", row.getCol1());
				rowMap.put("col2", row.getCol2());
				rowMap.put("col3", row.getCol3());
				rowMap.put("col4", row.getCol4());
				rowMap.put("col5", row.getCol5());
				xlsList.add(rowMap);
			}
			xlsLists.add(xlsList);
		}

		//리스트5
		String listTitle5 = CodeUtil.getVal(taskLogGrpCodeList, "05");
		xlsListsTitle.add(new String[] {"시작일","종료일","업무생성일",listTitle5+"내용"});
		if(dataList5!=null) {
			List<LinkedHashMap<String,String>> xlsList = XlsUtil.createList();
			for(int i=0;i<dataList5.size();i++) {
				LinkedHashMap<String,String> rowMap = new LinkedHashMap<String,String>();
				TaskLogRegVO row = dataList5.get(i);
				rowMap.put("sdate", searchVO.getSchSdate1());
				rowMap.put("edate", searchVO.getSchEdate1());
				rowMap.put("col2", row.getCol2());
				rowMap.put("col1", row.getCol1());
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
	
	/**
	 * 엑셀 다운로드 시 리스트별 행별 제목 코드값 가져오기.
	 * 업무일지구분코드  : 그룹코드 322
	 * 업무일지항목코드  : 그룹코드 323
	 * @param listNum		: 리스트 번호, 1 ~ 5
	 * @param rowNum		: 리스트별 행번호, 1 ~ 
	 * @return
	 */
	private String getXlsRowTitle(int listNum, int rowNum, List<CommonCodeVO> taskLogGrpCodeList, List<CommonCodeVO> taskLogItmCodeList) {
		String result = "";
		
		if(taskLogGrpCodeList!=null && taskLogItmCodeList!=null) {
			if(listNum==1) {
				switch(rowNum) {
				case 1: 
					result = CodeUtil.getVal(taskLogItmCodeList, "01"); 
					break;
				case 2: 
					result = CodeUtil.getVal(taskLogItmCodeList, "02"); 
					break;
				case 3: 
					result = CodeUtil.getVal(taskLogItmCodeList, "03"); 
					break;
				case 4: 
					result = CodeUtil.getVal(taskLogItmCodeList, "04"); 
					break;
				case 5: 
					result = CodeUtil.getVal(taskLogItmCodeList, "05"); 
					break;
				case 6: 
					result = CodeUtil.getVal(taskLogItmCodeList, "06"); 
					break;
				case 7: 
					result = CodeUtil.getVal(taskLogItmCodeList, "07"); 
					break;
				case 8: 
					result = CodeUtil.getVal(taskLogItmCodeList, "20"); 
					break;
				case 9: 
					result = CodeUtil.getVal(taskLogItmCodeList, "08"); 
					break;
				case 10: 
					result = CodeUtil.getVal(taskLogItmCodeList, "09"); 
					break;
				case 11: 
					result = CodeUtil.getVal(taskLogItmCodeList, "10"); 
					break;
				default: 
					return result;
				}
			} else if(listNum==2) {
				switch(rowNum) {
				case 1: 
					result = CodeUtil.getVal(taskLogItmCodeList, "11"); 
					break;
				case 2: 
					result = CodeUtil.getVal(taskLogItmCodeList, "12"); 
					break;
				case 3: 
					result = CodeUtil.getVal(taskLogItmCodeList, "10"); 
					break;
				case 4: 
					result = CodeUtil.getVal(taskLogItmCodeList, "13"); 
					break;
				default: 
					return result;
				}
			} else if(listNum==3) {
				switch(rowNum) {
				case 1: 
					result = CodeUtil.getVal(taskLogItmCodeList, "14"); 
					break;
				case 2: 
					result = CodeUtil.getVal(taskLogItmCodeList, "10"); 
					break;
				case 3: 
					result = CodeUtil.getVal(taskLogItmCodeList, "13"); 
					break;
				default: 
					return result;
				}
			} else if(listNum==4) {
				switch(rowNum) {
				case 1: 
					result = CodeUtil.getVal(taskLogItmCodeList, "15"); 
					break;
				case 2: 
					result = CodeUtil.getVal(taskLogItmCodeList, "16"); 
					break;
				case 3: 
					result = CodeUtil.getVal(taskLogItmCodeList, "10"); 
					break;
				case 4: 
					result = CodeUtil.getVal(taskLogItmCodeList, "17"); 
					break;
				case 5: 
					result = CodeUtil.getVal(taskLogItmCodeList, "18"); 
					break;
				default: 
					return result;
				}
			}
		}
		
		return result;
	}

}