package com.woori.ajs.api;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.springmodules.validation.commons.DefaultBeanValidator;

import com.woori.ajs.api.batch.QaTargetBatchController;
import com.woori.ajs.model.AdminLogProgramVO;
import com.woori.ajs.model.AdminUserVO;
import com.woori.ajs.model.LoginVO;
import com.woori.ajs.model.SearchVO;
import com.woori.ajs.model.TaskLogEndVO;
import com.woori.ajs.model.WordDictionaryRegBatchVO;
import com.woori.ajs.service.AdminLogProgramService;
import com.woori.ajs.service.AdminUserService;
import com.woori.ajs.service.TaskLogEndService;
import com.woori.ajs.service.WordDictionaryRegBatchService;

import egovframework.rte.fdl.property.EgovPropertyService;
import egovframework.ui.cmmn.DateUtil;
import egovframework.ui.cmmn.HttpUtil;
import egovframework.ui.cmmn.StringUtil;
import egovframework.ui.util.LoginUtils;

@RestController
public class TaskLogEndApiController {

	private static final Logger LOGGER = LoggerFactory.getLogger(QaTargetBatchController.class);
	
	@Resource(name = "adminLogProgramService")
	private AdminLogProgramService adminLogProgramService;
	
	@Resource(name = "wordDictionaryRegBatchService")
	private WordDictionaryRegBatchService wordDictionaryRegBatchService; 
	
	/** adminUserService */
	@Resource(name = "adminUserService")
	private AdminUserService adminUserService;

	/** taskLogEndService */
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
	
	@GetMapping("/api/task/log/end")
	public HashMap<String,Object> list(HttpServletRequest request, SearchVO searchVO, AdminLogProgramVO adminLogProgramVO) throws Exception {
		
		HashMap<String,Object> map = new HashMap<String,Object>();
		LoginVO loginInfo = LoginUtils.getLoginInfo(request);
		
		HttpUtil.setResult(map, HttpUtil.HttpType.T200);
		
		map.put("searchVO",searchVO);
		
		searchVO.setAiInptClsDt(searchVO.getAiInptClsDt().replace("-", ""));
		
		String trnLogSrno = null;
		trnLogSrno = adminLogProgramService.logProgramInsert(request, adminLogProgramVO, searchVO);
		
		//검색일자가 금일이거나, 검색일자에 해당하는 데이터가 존재하지 않거나, 재마감버튼을 눌렀을 때
		//통계건수를 CSPD009TA(심사업무마감) 테이블에 저장처리
		int checkDateCnt = taskLogEndService.checkDate(searchVO);
		boolean checkToday = DateUtil.getToday().equals(searchVO.getAiInptClsDt());

		
		if(checkToday || checkDateCnt==0 || "1".equals(searchVO.getInptTaskId())) {
			updateStat(loginInfo.getId(), searchVO.getAiInptClsDt(), trnLogSrno);
		}
		//updateStat(loginInfo.getId(), searchVO.getAiInptClsDt()); 테스트용
		
		//리스트 목록 데이터 로드
		searchVO.setAiInptClsDscd("01");
		List<TaskLogEndVO> list = taskLogEndService.selectList(searchVO);
		map.put("resultList", list);

		searchVO.setAiInptClsDscd("02");
		List<TaskLogEndVO> list2 = taskLogEndService.selectList(searchVO);
		map.put("result2List", list2);

		searchVO.setAiInptClsDscd("03");
		List<TaskLogEndVO> list3 = taskLogEndService.selectList(searchVO);
		map.put("result3List", list3);

		searchVO.setAiInptClsDscd("04");
		List<TaskLogEndVO> list4 = taskLogEndService.select2List(searchVO);
		map.put("result4List", list4);
		
		searchVO.setAiInptClsDscd("05");
		List<TaskLogEndVO> list5 = taskLogEndService.select2List(searchVO);
		map.put("result5List", list5);
		
		searchVO.setAiInptClsDscd("06");
		List<TaskLogEndVO> list6 = taskLogEndService.select2List(searchVO);
		map.put("result6List", list6);
		
		return map;
	}

	@PostMapping("/api/task/log/end")
	public HashMap<String,Object> reg(HttpServletRequest request, TaskLogEndVO vo, AdminLogProgramVO adminLogProgramVO) throws Exception {
		HashMap<String,Object> map = new HashMap<String,Object>();
		LoginVO loginInfo = LoginUtils.getLoginInfo(request);
		
		vo.setLstDbChgId(loginInfo.getId());
		
		HttpUtil.setResult(map, HttpUtil.HttpType.T200);
		
		vo.setAiInptClsDt(vo.getAiInptClsDt().replace("-", ""));
		
		String trnLogSrno = null;
		SearchVO searchVO = new SearchVO();
		trnLogSrno = adminLogProgramService.logProgramInsert(request, adminLogProgramVO, searchVO);
		
		vo.setTrnLogSrno(trnLogSrno);
		
		String[] stat1Memos = request.getParameterValues("stat1Memos");
		updateRmrks("01", stat1Memos, vo);

		String[] stat2Memos = request.getParameterValues("stat2Memos");
		updateRmrks("02", stat2Memos, vo);

		String[] stat3Memos = request.getParameterValues("stat3Memos");
		updateRmrks("03", stat3Memos, vo);

		String[] stat4Memos = request.getParameterValues("stat4Memos");
		updateRmrks("04", stat4Memos, vo);

		String[] stat5Memos = request.getParameterValues("stat5Memos");
		updateRmrks("05", stat5Memos, vo);

		String[] stat6Memos = request.getParameterValues("stat6Memos");
		updateRmrks("06", stat6Memos, vo);

		return map;
	}

	/**
	 * 일자별 통계건수 업데이트, 일배치로 매일 밤늦게(오후11시30분쯤) 그날 통계를 디비에 업데이트 처리가 필요.
	 * @param lstDbChgId	: 최종수정자 아이디
	 * @param aiInptClsDt	: 업데이트 일자
	 */
	public void updateStat(String lstDbChgId, String aiInptClsDt, String trnLogSrno) throws Exception {
		if(StringUtil.isEmpty(aiInptClsDt)) {
			return;
		}
		
		SearchVO svo = new SearchVO();
		int tskDatesCnt = 0;
		
		TaskLogEndVO vo = new TaskLogEndVO();
		vo.setLstDbChgId(lstDbChgId);
		vo.setAiInptClsDt(aiInptClsDt);
		vo.setTrnLogSrno(trnLogSrno);
		//=========================================================================
		//업무마감 건수저장 타입1 : CSPD009TA 테이블 AI_INPT_CLS_DSCD 컬럼값이 01,02,03 인경우
		//파라미터 : aiInptClsDt (필수), inptAtmcBizDscd (선택), aiInptClsDscd (필수), lstDbChgId (필수)
		//inptAtmcBizDscd (선택) : 전체-조건없음 / 수출-2 / 수입-1
		//=========================================================================
		
		//당일 Saction 심사 (Total)
		svo.setSchSdate1(aiInptClsDt);
		svo.setSchEdate1(aiInptClsDt);
		svo.setInptAtmcBizDscd(null);
		
		vo.setTaskDatesCnt(tskDatesCnt);
		vo.setInptAtmcBizDscd(null);
		vo.setAiInptClsDscd("01");
		taskLogEndService.updateStatCntList_rvs(vo);
		
		//당일 Saction 심사 (수출)
		svo.setSchSdate1(aiInptClsDt);
		svo.setSchEdate1(aiInptClsDt);
		svo.setInptAtmcBizDscd("2");
		//tskDatesCnt = taskLogEndService.getTaskDatesCnt(svo);

		vo.setTaskDatesCnt(tskDatesCnt);
		vo.setInptAtmcBizDscd("2");
		vo.setAiInptClsDscd("02");
		taskLogEndService.updateStatCntList_rvs(vo);
		
		//당일 Saction 심사 (수입)
		svo.setSchSdate1(aiInptClsDt);
		svo.setSchEdate1(aiInptClsDt);
		svo.setInptAtmcBizDscd("1");

		vo.setTaskDatesCnt(tskDatesCnt);
		vo.setInptAtmcBizDscd("1");
		vo.setAiInptClsDscd("03");
		taskLogEndService.updateStatCntList_rvs(vo);
		
		//=========================================================================
		//업무마감 건수저장 타입2 : CSPD009TA 테이블 AI_INPT_CLS_DSCD 컬럼값이 04,05,06 인경우
		//파라미터 : aiInptClsDt (필수), inptAtmcBizDscd (선택), aiInptClsDscd (필수), lstDbChgId (필수)
		//inptAtmcBizDscd (선택) : 전체-조건없음 / 수출-2 / 수입-1
		//=========================================================================
		
		//전일자 QA (Total)
		vo.setInptAtmcBizDscd(null);
		vo.setAiInptClsDscd("04");
		//taskLogEndService.updateStatCntList2(vo);
		taskLogEndService.updateStatCntList_qa(vo);
		
		//전일자 QA (수출)
		vo.setInptAtmcBizDscd("2");
		vo.setAiInptClsDscd("05");
		//taskLogEndService.updateStatCntList2(vo);
		taskLogEndService.updateStatCntList_qa(vo);
		
		//전일자 QA (수입)
		vo.setInptAtmcBizDscd("1");
		vo.setAiInptClsDscd("06");
		//taskLogEndService.updateStatCntList2(vo);
		taskLogEndService.updateStatCntList_qa(vo);
	}
	
	/**
	 * 일자별, 섹션구분별 메모 업데이트 처리
	 * @param aiInptClsDscd			: 섹션구분 공통코드, 01 - 당일 Saction 심사 (Total), 02 - 당일 Saction 심사 (수출), 03 - 당일 Saction 심사 (수입), 04 - 전일자 QA (Total), 05 - 전일자 QA (수출), 06 - 전일자 QA (수입)
	 * @param memoParams			: 화면에서 넘긴 메모 배열 파라미터, 섹션별로 넘어옴.
	 * @param vo					: 모델객체
	 */
	private void updateRmrks(String aiInptClsDscd, String[] memoParams, TaskLogEndVO vo) throws Exception {
		setMemoParams(aiInptClsDscd,memoParams,vo);
		vo.setAiInptClsDscd(aiInptClsDscd);
		
		if("01".equals(aiInptClsDscd) || "02".equals(aiInptClsDscd) || "03".equals(aiInptClsDscd)) {
			vo.setAiInptClsItcd("01");
			vo.setAiInptRmrk(vo.getMemo1());
			taskLogEndService.updateStatList(vo);
			
			vo.setAiInptClsItcd("02");
			vo.setAiInptRmrk(vo.getMemo2());
			taskLogEndService.updateStatList(vo);
			
			vo.setAiInptClsItcd("03");
			vo.setAiInptRmrk(vo.getMemo3());
			taskLogEndService.updateStatList(vo);
			
			vo.setAiInptClsItcd("04");
			vo.setAiInptRmrk(vo.getMemo4());
			taskLogEndService.updateStatList(vo);
			
			vo.setAiInptClsItcd("05");
			vo.setAiInptRmrk(vo.getMemo5());
			taskLogEndService.updateStatList(vo);
			
			vo.setAiInptClsItcd("06");
			vo.setAiInptRmrk(vo.getMemo6());
			taskLogEndService.updateStatList(vo);
			
			vo.setAiInptClsItcd("07");
			vo.setAiInptRmrk(vo.getMemo7());
			taskLogEndService.updateStatList(vo);
			
			vo.setAiInptClsItcd("08");
			vo.setAiInptRmrk(vo.getMemo8());
			taskLogEndService.updateStatList(vo);
			
			vo.setAiInptClsItcd("09");
			vo.setAiInptRmrk(vo.getMemo9());
			taskLogEndService.updateStatList(vo);
			
			vo.setAiInptClsItcd("10");
			vo.setAiInptRmrk(vo.getMemo10());
			taskLogEndService.updateStatList(vo);

			vo.setAiInptClsItcd("13");
			vo.setAiInptRmrk(vo.getMemo11());
			taskLogEndService.updateStatList(vo);
		} else {
			vo.setAiInptClsItcd("01");
			vo.setAiInptRmrk(vo.getMemo1());
			taskLogEndService.updateStatList(vo);
			
			vo.setAiInptClsItcd("11");
			vo.setAiInptRmrk(vo.getMemo2());
			taskLogEndService.updateStatList(vo);
			
			vo.setAiInptClsItcd("12");
			vo.setAiInptRmrk(vo.getMemo3());
			taskLogEndService.updateStatList(vo);
		}
	}
	
	/**
	 * 메모 파라미터 셋팅
	 * @param memoParams		: 화면에서 넘어온 메모배열 변수
	 * @param vo				: 메모파라미터 셋팅할 모델변수 (setMemo1 ~ setMemo10)
	 * @return
	 */
	private TaskLogEndVO setMemoParams(String aiInptClsDscd, String[] memoParams, TaskLogEndVO vo) {
		if(memoParams==null) {
			return vo;
		}
		
		vo.setMemo1("");
		vo.setMemo2("");
		vo.setMemo3("");
		vo.setMemo4("");
		vo.setMemo5("");
		vo.setMemo6("");
		vo.setMemo7("");
		vo.setMemo8("");
		vo.setMemo9("");
		vo.setMemo10("");
		vo.setMemo11("");
		
		if("01".equals(aiInptClsDscd)) {
			if(memoParams.length >= 1) {
				vo.setMemo1(memoParams[0]);
			}
			if(memoParams.length >= 2) {
				vo.setMemo2(memoParams[1]);
			}
			if(memoParams.length >= 3) {
				vo.setMemo3(memoParams[2]);
			}
			if(memoParams.length >= 4) {
				vo.setMemo4(memoParams[3]);
			}
			if(memoParams.length >= 5) {
				vo.setMemo5(memoParams[4]);
			}
			if(memoParams.length >= 6) {
				vo.setMemo6(memoParams[5]);
			}
			if(memoParams.length >= 7) {
				vo.setMemo11(memoParams[6]);
			}
			if(memoParams.length >= 8) {
				vo.setMemo7(memoParams[7]);
			}
			if(memoParams.length >= 9) {
				vo.setMemo8(memoParams[8]);
			}
			if(memoParams.length >= 10) {
				vo.setMemo9(memoParams[9]);
			}
			if(memoParams.length >= 11) {
				vo.setMemo10(memoParams[10]);
			}
		} else {
			if(memoParams.length >= 1) {
				vo.setMemo1(memoParams[0]);
			}
			if(memoParams.length >= 2) {
				vo.setMemo2(memoParams[1]);
			}
			if(memoParams.length >= 3) {
				vo.setMemo3(memoParams[2]);
			}
			if(memoParams.length >= 4) {
				vo.setMemo4(memoParams[3]);
			}
			if(memoParams.length >= 5) {
				vo.setMemo5(memoParams[4]);
			}
			if(memoParams.length >= 6) {
				vo.setMemo6(memoParams[5]);
			}
			if(memoParams.length >= 7) {
				vo.setMemo7(memoParams[6]);
			}
			if(memoParams.length >= 8) {
				vo.setMemo8(memoParams[7]);
			}
			if(memoParams.length >= 9) {
				vo.setMemo9(memoParams[8]);
			}
			if(memoParams.length >= 10) {
				vo.setMemo10(memoParams[9]);
			}
		}
		
		return vo;
	}

	/**
	 * 일자별 통계건수 업데이트 배치
	 * 일배치로 매일(21 시 00 분) 그날 통계를 디비에 업데이트 처리
	 * cron : 초 분 시간 일 월 년도 (0/20 - 0초부터 20초단위로 반복)
	 * 배치실행시 설정	: @Scheduled(cron="0 30 23 * * *")
	 * 테스트시 설정		: @GetMapping("/batch/task/log/end")
	 */
	
	//@GetMapping("/batch/task/log/end")
	//@Scheduled(cron="0 30 23 * * *")
	//@Scheduled(cron="#{systemFileProperties['batchTime.taskEnd']}")
	@ResponseBody 
	@GetMapping("/batch/task/log/end")
	public void batch() throws Exception {
		
		// 업무일지 > 업무마감 배치
		String lstDbChgId = "Batch";
		SearchVO searchVO = new SearchVO();
		searchVO.setUserId("Batch");
				
		String trnLogSrno = adminLogProgramService.selectTrnLogSrno(searchVO);
		
		updateStat(lstDbChgId, DateUtil.getToday(), trnLogSrno);
		
		// 후보정심사단어사전 배치
		wordDictionaryReg(trnLogSrno);
	}
	
	// 후보정심사단어사전 자동 등록 배치 함수
	private void wordDictionaryReg(String trnLogSrno) throws Exception {
		
		// #0 금일 날짜 get
		SimpleDateFormat paramFormat = new SimpleDateFormat("yyyyMMdd", java.util.Locale.KOREA);
		Calendar currDate = Calendar.getInstance();
		
		// #1 후보정심사단어등록 대상 건 마스터번호 get
		WordDictionaryRegBatchVO paramVO_1 = new WordDictionaryRegBatchVO();
		paramVO_1.setInptRcpDt(paramFormat.format(currDate.getTime()));
		List<WordDictionaryRegBatchVO> wordRegTargetList = wordDictionaryRegBatchService.selectTargetList(paramVO_1);
		
		
		// #2 후보정심사단어등록 대상 건 수기등록 내용 get
		for(int index = 0 ; index < wordRegTargetList.size() ; index++) {
			WordDictionaryRegBatchVO paramVO_2 = wordRegTargetList.get(index);
			List<WordDictionaryRegBatchVO> wordRegContentList = wordDictionaryRegBatchService.selectContentsToRegList(paramVO_2);
			
			for(int innerIndex = 0 ; innerIndex < wordRegContentList.size() ; innerIndex++) {
				WordDictionaryRegBatchVO paramVO_3 = wordRegContentList.get(innerIndex);
				
				// #3 후보정심사단어등록 중복 여부(건수) get
				int cnt = wordDictionaryRegBatchService.selectCountAleadyReg(paramVO_3);
				
				if(cnt == 0) {
					// #4 후보정심사단어등록
					paramVO_3.setLstDbChgId("Batch");
					paramVO_3.setTrnLogSrno(trnLogSrno);
					wordDictionaryRegBatchService.insertWordDictionary(paramVO_3);
				}
			}
		}
	}
}