package com.woori.ajs.api;

import java.io.File;
import java.util.ArrayList;
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

import com.woori.ajs.model.CommonSanctionStatVO;
import com.woori.ajs.model.SearchVO;
import com.woori.ajs.model.StatCondVO;
import com.woori.ajs.model.StatItemVO;
import com.woori.ajs.service.CommonSanctionStatService;
import com.woori.ajs.service.StatCondService;
import com.woori.ajs.service.StatItemService;

import egovframework.rte.fdl.property.EgovPropertyService;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import egovframework.ui.cmmn.ComUtil;
import egovframework.ui.cmmn.DateUtil;
import egovframework.ui.cmmn.FileUtil;
import egovframework.ui.cmmn.HttpUtil;
import egovframework.ui.cmmn.StringUtil;
import egovframework.ui.cmmn.XlsUtil;

@RestController
public class CommonSanctionStatApiContoller {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(CommonSanctionStatApiContoller.class);

	/** EgovPropertyService */
	@Resource(name = "propertiesService")
	protected EgovPropertyService propertiesService;
	
	@Resource(name = "commonSanctionStatService")
	CommonSanctionStatService commonSanctionStatService;
	
	@Resource(name = "StatCondService")
	private StatCondService statCondService;

	/** StatItemService */
	@Resource(name = "StatItemService")
	private StatItemService StatItemService;

	@Resource(name = "systemFileProperties")
	protected Properties sysProp;

	/**
	 * 통계 - 조건별 통계, 차트데이터
	 * @param vo			: 검색조건
	 */
	@GetMapping("/api/common/stat/cond")
	public HashMap<String,Object> condList(SearchVO vo) throws Exception {
		HashMap<String,Object> map = new HashMap<String,Object>();
		HttpUtil.setResult(map, HttpUtil.HttpType.T200);
		
		PaginationInfo paginationInfo = ComUtil.setListPagingInfo(propertiesService, vo);
		
		// 심사원장마스터 key의 List를 vo에 할당한다.
		//getInptMstSrnoList(vo);   /// setInptMstSrnoList 셋팅 (null 일수도 있음)
		
		List<StatCondVO> list = statCondService.selectList(vo);
		int totCnt = statCondService.selectListTotCnt(vo);
		paginationInfo.setTotalRecordCount(totCnt);
		
		map.put("searchVO", vo);
		map.put("paginationInfo",paginationInfo);
		map.put("resultList", list);
		
		return map;
	}

	/**
	 * 통계 - 조건별 통계, 엑셀 다운로드
	 * @param vo			: 검색조건
	 */
	@GetMapping("/api/common/stat/cond/xls")
	public ModelAndView condListXls(SearchVO vo, ModelAndView mv) throws Exception {
		mv.setViewName("downView");					//파일다운로드뷰
		String xlsDownName = StringUtil.concat(new String[] {"조건별통계_",DateUtil.getFormatDate("yyyyMMdd"),".xlsx"});
		vo.setRecordCountPerPage(-1);
		getInptMstSrnoList(vo);		//심사원장마스터 key의 List를 vo에 할당한다.
		List<StatCondVO> list = statCondService.selectList(vo);
		List<String[]> xlsListsTitle = XlsUtil.createListsTitle();
		List<List<LinkedHashMap<String,String>>> xlsLists = XlsUtil.createLists();
		xlsListsTitle.add(new String[] {"업무구분","Ref.NO","B/L일련번호","고객번호","고객명","통화","영업점","수출상","수입상","선적항","하역항","원산지"});
		if(list!=null) {
			List<LinkedHashMap<String,String>> xlsList = XlsUtil.createList();
			for(int i=0;i<list.size();i++) {
				LinkedHashMap<String,String> rowMap = new LinkedHashMap<String,String>();
				StatCondVO row = null;
				
				if (list.get(i) instanceof StatCondVO) {
					row = (StatCondVO)list.get(i);
				}
				
				if (row != null) {
					
					rowMap.put("inptAtmcBizNm", row.getInptAtmcBizDsNm()); 				//업무구분
					rowMap.put("actlFxRefno", row.getActlFxRefno()); 					// Ref NO
					rowMap.put("imexHisNm", row.getImexHisNm()); 						// B/L일련번호
					rowMap.put("aiInptCsno", row.getAiInptCsno()); 						// 고객번호
					rowMap.put("aiInptCusNm", row.getAiInptCusNm()); 					// 고객명
					rowMap.put("fcCuNm", row.getFcCuNm()); 								// 통화
					rowMap.put("krbrNm", row.getKrbrNm()); 								// 영업점
					rowMap.put("exptNm", row.getExptNm()); 								// 수출상
					rowMap.put("imptNm", row.getImptNm()); 								// 수입상
					rowMap.put("portLoading", row.getPortLoading()); 					// 선적항
					rowMap.put("portDisch", row.getPortDisch()); 						// 하역항
					rowMap.put("orignNm", row.getOrignNm()); 							// 원산지
					xlsList.add(rowMap);
				}
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

	/**
	 * 통계 - 항목별 통계 (항목별), 차트데이터
	 * @param vo			: 검색조건
	 */
	@GetMapping("/api/common/stat/item")
	public HashMap<String,Object> item1List(SearchVO vo) throws Exception {
		HashMap<String,Object> map = new HashMap<String,Object>();
		HttpUtil.setResult(map, HttpUtil.HttpType.T200);
		
		PaginationInfo paginationInfo = ComUtil.setListPagingInfo(propertiesService, vo);
		
		// 심사원장마스터 key의 List를 vo에 할당한다.
		//getInptMstSrnoList(vo);
		
		vo.setInptSanctionNum1(0);
		vo.setInptSanctionNum2(0);
		vo.setInptSanctionNum3(0);
		// if(!vo.getInptSanctionNo1().toString().equals("")) {
		if(!"".toString().equals(vo.getInptSanctionNo1())) {
			vo.setInptSanctionNum1(Integer.parseInt(vo.getInptSanctionNo1()));
		}
		// if(!vo.getInptSanctionNo2().toString().equals("")) {
		if(!"".toString().equals(vo.getInptSanctionNo2())) {
			vo.setInptSanctionNum2(Integer.parseInt(vo.getInptSanctionNo2()));
		}
		//if(!vo.getInptSanctionNo3().toString().equals("")) {
		if(!"".toString().equals(vo.getInptSanctionNo3())) {
			vo.setInptSanctionNum3(Integer.parseInt(vo.getInptSanctionNo3()));
		}
		
		List<StatItemVO> list = StatItemService.selectList(vo);
		int totCnt = list==null ? 0 : list.size();
		paginationInfo.setTotalRecordCount(totCnt);
		
		
		
		map.put("searchVO", vo);
		map.put("paginationInfo",paginationInfo);
		
		map.put("resultList", list);
		
		return map;
	}

	/**
	 * 통계 - 항목별 통계 (기간별 추이), 차트데이터
	 * @param vo			: 검색조건
	 */
	@GetMapping("/api/common/stat/item/move")
	public HashMap<String,Object> item2List(SearchVO vo) throws Exception {
		HashMap<String,Object> map = new HashMap<String,Object>();
		HttpUtil.setResult(map, HttpUtil.HttpType.T200);
		
		PaginationInfo paginationInfo = ComUtil.setListPagingInfo(propertiesService, vo);
		
		// 심사원장마스터 key의 List를 vo에 할당한다.
		//getInptMstSrnoList(vo);
		
		vo.setInptSanctionNum1(0);
		vo.setInptSanctionNum2(0);
		vo.setInptSanctionNum3(0);
		if(!"".toString().equals(vo.getInptSanctionNo1())) {
			vo.setInptSanctionNum1(Integer.parseInt(vo.getInptSanctionNo1()));
		}
		if(!"".toString().equals(vo.getInptSanctionNo2())) {
			vo.setInptSanctionNum2(Integer.parseInt(vo.getInptSanctionNo2()));
		}
		if(!"".toString().equals(vo.getInptSanctionNo3())) {
			vo.setInptSanctionNum3(Integer.parseInt(vo.getInptSanctionNo3()));
		}
		
		List<StatItemVO> list = StatItemService.selectMoveList(vo);
		int totCnt = list==null ? 0 : list.size();
		paginationInfo.setTotalRecordCount(totCnt);
		
		map.put("searchVO", vo);
		map.put("paginationInfo",paginationInfo);
		map.put("resultList", list);
		
		return map;
	}
	
	/* getInptMstSrnoList, getWatchListItemList, sanctionTxtCompare, getStrPerct -> 항목별통계, 항목별통계-기간별추이, 조건별통계에서 공통으로 사용하는 메소드 */
	// 항목 selectBox가 하나라도 선택 된 경우 항목별로 추출 된 내용과 WatchList Item의 내용과 일치하는 심사원장마스터 key의 List를 구한후 vo에 할당한다.
	private void getInptMstSrnoList(SearchVO vo) throws Exception {
		String inptSanctionNo1 = vo.getInptSanctionNo1() == null ? "" : vo.getInptSanctionNo1();
		String inptSanctionNo2 = vo.getInptSanctionNo2() == null ? "" : vo.getInptSanctionNo2();
		String inptSanctionNo3 = vo.getInptSanctionNo3() == null ? "" : vo.getInptSanctionNo3();
		String inptSanctionNo4 = vo.getInptSanctionNo4() == null ? "" : vo.getInptSanctionNo4();
		String inptSanctionNo5 = vo.getInptSanctionNo5() == null ? "" : vo.getInptSanctionNo5();
		int inptMstSrnoListSize = 0;
		if(!("".equals(inptSanctionNo1) && "".equals(inptSanctionNo2) && "".equals(inptSanctionNo3) && "".equals(inptSanctionNo4) && "".equals(inptSanctionNo5))) {
			// 심사원장마스터키  Data
			List<CommonSanctionStatVO> selectInptMstSrnoList = commonSanctionStatService.selectInptMstSrnoList(vo); // (1)
			
			if(selectInptMstSrnoList.size() > 0) {
				// 항목추출 결과 Data
				List<CommonSanctionStatVO> sanctionRstList = commonSanctionStatService.selectSanctionList(vo);  // (2)
				
				/*
				 * 
				 *   제재 Rule 등록의 항목심사 일치율 받기 ----> 테이블 및 컬럼 생성 후 Db에서 받아오는 로직을 추가해야함.... 
				 *   double matchPerct
				 *   
				 */
				double matchPerct = 0.8;  // 임시 일치율
				
				// 텍스트 입력란 값
				String aiInptListText1 = vo.getAiInptListText1() == null ? "" : vo.getAiInptListText1();
				String aiInptListText2 = vo.getAiInptListText2() == null ? "" : vo.getAiInptListText2();
				String aiInptListText3 = vo.getAiInptListText3() == null ? "" : vo.getAiInptListText3();
				String aiInptListText4 = vo.getAiInptListText4() == null ? "" : vo.getAiInptListText4();
				String aiInptListText5 = vo.getAiInptListText5() == null ? "" : vo.getAiInptListText5();
				// WatchList Item List
				List<CommonSanctionStatVO> itemTextList1 = null;
				List<CommonSanctionStatVO> itemTextList2 = null;
				List<CommonSanctionStatVO> itemTextList3 = null;
				List<CommonSanctionStatVO> itemTextList4 = null;
				List<CommonSanctionStatVO> itemTextList5 = null;
				// 심사원장마스터 key List
				ArrayList<Integer> inptMstSrnoList = new ArrayList<>();
				
				// 항목과  WatchList의 리스트가 선택된 경우 WatchList Item를 받아온다.
				if(!"".equals(inptSanctionNo1) && "".equals(aiInptListText1)) {
					itemTextList1 = getWatchListItemList(vo, inptSanctionNo1, vo.getAiInptListId1()); // (3)
				}
				
				if(!"".equals(inptSanctionNo2) && "".equals(aiInptListText2)) {
					itemTextList2 = getWatchListItemList(vo, inptSanctionNo2, vo.getAiInptListId2());
				}
				
				if(!"".equals(inptSanctionNo3) && "".equals(aiInptListText3)) {
					itemTextList3 = getWatchListItemList(vo, inptSanctionNo3, vo.getAiInptListId3());
				}
				
				if(!"".equals(inptSanctionNo4) && "".equals(aiInptListText4)) {
					itemTextList4 = getWatchListItemList(vo, inptSanctionNo4, vo.getAiInptListId4());
				}
				
				if(!"".equals(inptSanctionNo5) && "".equals(aiInptListText5)) {
					itemTextList5 = getWatchListItemList(vo, inptSanctionNo5, vo.getAiInptListId5());
				}
				
				// 항목추출 결과 변수 초기화
				List<CommonSanctionStatVO> tmpList = null;
				String inptSanctionNo = "";
				String inptSanctionDatTxt= "";
				int maxCnt = 0;
				int matchCnt1 = 0;
				int matchCnt2 = 0;
				int matchCnt3 = 0;
				int matchCnt4 = 0;
				int matchCnt5 = 0;
				
				
				if(!"".equals(inptSanctionNo1)) {
					maxCnt++;
				}
				if(!"".equals(inptSanctionNo2)) {
					maxCnt++;
				}
				if(!"".equals(inptSanctionNo3)) {
					maxCnt++;
				}
				if(!"".equals(inptSanctionNo4)) {
					maxCnt++;
				}
				if(!"".equals(inptSanctionNo5)) {
					maxCnt++;
				}
				
				// 심사원장마스터키 순서대로 문자열 일치 로직 수행(sql order by 순서 중요)
				for(CommonSanctionStatVO map1: selectInptMstSrnoList) {
					matchCnt1 = ComUtil.intZero();
					matchCnt2 = ComUtil.intZero();
					matchCnt3 = ComUtil.intZero();
					matchCnt4 = ComUtil.intZero();
					matchCnt5 = ComUtil.intZero();
					
					// 일치하는 심사원장마스터키로만 리스트를 할당
					tmpList = new ArrayList<CommonSanctionStatVO>();
					for (CommonSanctionStatVO sanctionRstItem : sanctionRstList) {
						if(sanctionRstItem.getInptMstSrno()==map1.getInptMstSrno()) {
							tmpList.add(sanctionRstItem);
						}
					}
					
					// 문자열 일치 로직 영역
					for(CommonSanctionStatVO map2: tmpList) {
						inptSanctionNo = map2.getInptSanctionNo();
						inptSanctionDatTxt= map2.getInptSantionDatTxt();
						if(!"".equals(inptSanctionNo1) && matchCnt1 == 0) {
							if(sanctionTxtCompare(itemTextList1, aiInptListText1, inptSanctionNo, inptSanctionNo1, inptSanctionDatTxt, matchPerct)) {
								matchCnt1++;
							}
						}
						
						if(!"".equals(inptSanctionNo2) && matchCnt2 == 0) {
							if(sanctionTxtCompare(itemTextList2, aiInptListText2, inptSanctionNo, inptSanctionNo2, inptSanctionDatTxt, matchPerct)) {
								matchCnt2++;
							}
						}
						
						if(!"".equals(inptSanctionNo3) && matchCnt3 == 0) {
							
							if(sanctionTxtCompare(itemTextList3, aiInptListText3, inptSanctionNo, inptSanctionNo3, inptSanctionDatTxt, matchPerct)) {
								matchCnt3++;
							}
						}
						
						if(!"".equals(inptSanctionNo4) && matchCnt4 == 0) {
							
							if(sanctionTxtCompare(itemTextList4, aiInptListText4, inptSanctionNo, inptSanctionNo4, inptSanctionDatTxt, matchPerct)) {
								matchCnt4++;
							}
						}
						
						if(!"".equals(inptSanctionNo5) && matchCnt5 == 0) {
							if(sanctionTxtCompare(itemTextList5, aiInptListText5, inptSanctionNo, inptSanctionNo5, inptSanctionDatTxt, matchPerct)) {
								matchCnt5++;
							}
						}
					}
					if(maxCnt == matchCnt1 + matchCnt2 + matchCnt3 + matchCnt4 + matchCnt5) {
						inptMstSrnoList.add(map1.getInptMstSrno());
					}
				}
				inptMstSrnoListSize =  inptMstSrnoList.size();
				if(inptMstSrnoListSize == 0) {
					inptMstSrnoList = null;
				}
				//vo.setInptMstSrnoListSize(inptMstSrnoListSize);
				vo.setInptMstSrnoList(inptMstSrnoList);
				//vo.setInptMstSrnoList(new ArrayList(new HashSet(inptMstSrnoList)));			// 중복 제거 후 vo에 할당
			}
		}
	}
	
	// WatchList Item를 받기
	private List<CommonSanctionStatVO> getWatchListItemList(SearchVO vo, String inptSanctionNo, String aiInptListId) throws Exception {
		vo.setInptSanctionNo(inptSanctionNo);
		vo.setAiInptListId(aiInptListId);
		
		return commonSanctionStatService.selectWatchItemList(vo);
	}
	
	// 문자열 일치 여부 판단
	private boolean sanctionTxtCompare(List<CommonSanctionStatVO> itemTextList, String aiInptListText, String inptSanctionNo, String inptInptSanctionNo, String inptSanctionDatTxt, double matchPerct) {
		boolean rst = false;
		double strPerct = 0;
		
		if("".equals(aiInptListText)) { // list 로 했을 경우
			String itemSanctionNo = "";
			String aiInptRsptTxtDesTxt = "";
			
			for(CommonSanctionStatVO map: itemTextList) {
				itemSanctionNo = map.getInptSanctionNo();
				aiInptRsptTxtDesTxt = map.getAiInptRsptTxtDesTxt();
				if(itemSanctionNo.equals(inptSanctionNo)) {
					strPerct = getStrPerct(aiInptRsptTxtDesTxt, inptSanctionDatTxt);
					
					if(strPerct >= matchPerct) {
						rst = true;
						break;
					}
				}
			}
		} else {
			if(inptInptSanctionNo.equals(inptSanctionNo)) {
				strPerct = getStrPerct(aiInptListText, inptSanctionDatTxt);
				
				if(strPerct >= matchPerct) {
					rst = true;
			}
			}
		}
		
		return rst;
	}
	
	// 문자열 비교 유사도 구하기
	private double getStrPerct(String str1, String str2) {
		double result = 0.0;
		
		if(StringUtil.isNotEmpty(str1) && StringUtil.isNotEmpty(str2)) {
			str2 = str2.replace("\n", " ");
			str2 = str2.replace("\t", " ");
			str2 = str2.replace("\r", " ");
			
			//두개이상 연속 공백들을 한개의 공백으로 치환처리.
			for(int i=0;i<20;i++) {
				if(str2.indexOf("  ")==-1) {
					break;
				}
				
				str2 = str2.replace("  ", " ");
			}
			
			//단어단위로 파싱처리.
			String[] words = str2.split(" ");
			int wordsLen = words.length;
			for(int i=0;i<wordsLen;i++) {
				String word = words[i];
				result = Math.max(result,StringUtil.wordSimRate(str1, word));
				if(result >= 100) {
					break;
				}
			}
		}
		
		return result;
	}
}
