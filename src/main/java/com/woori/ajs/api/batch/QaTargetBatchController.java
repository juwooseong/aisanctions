package com.woori.ajs.api.batch;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Properties;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springmodules.validation.commons.DefaultBeanValidator;

import com.woori.ajs.model.AdminQaTargetVO;
import com.woori.ajs.model.AdminUserVO;
import com.woori.ajs.model.QaTargetBatchVO;
import com.woori.ajs.model.SearchVO;
import com.woori.ajs.service.AdminLogProgramService;
import com.woori.ajs.service.AdminQaTargetService;
import com.woori.ajs.service.AdminUserService;
import com.woori.ajs.service.QaTargetBatchService;

import egovframework.rte.fdl.property.EgovPropertyService;
import egovframework.ui.cmmn.ComUtil;
import egovframework.ui.cmmn.DateUtil;
import egovframework.ui.cmmn.IndexList;
import egovframework.ui.cmmn.ListUtil;
import egovframework.ui.cmmn.StringUtil;

@Controller
public class QaTargetBatchController {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(QaTargetBatchController.class);

	/** adminLogProgramService */
	@Resource(name = "adminLogProgramService")
	private AdminLogProgramService adminLogProgramService;
	
	@Resource(name = "adminQaTargetService")
	private AdminQaTargetService adminQaTargetService;

	@Resource(name = "qaTargetBatchService")
	private QaTargetBatchService qaTargetBatchService;
	
	@Resource(name = "adminUserService")
	private AdminUserService adminUserService;
	
	/** EgovPropertyService */
	@Resource(name = "propertiesService")
	protected EgovPropertyService propertiesService;

	/** Validator */
	@Resource(name = "beanValidator")
	protected DefaultBeanValidator beanValidator;

	@Resource(name = "systemFileProperties")
	protected Properties sysProp;
	
	/**
	* 내용
	- 인자로 넘어온 심사번호에 해당하는 심사의 QA선정 분류값 반환
	- 테스트 : SELECT INPT_MST_SRNO, FN_QA_GET_PRCS_CD(INPT_MST_SRNO) AS PRCS_CD FROM CSPD001TM
	* 반환
	- 3 - QA TotalText, 4 - QA 항목심사, 5 - QA SafeWatch
	* 관련디비
	- CSPD001TM.AI_INPT_QA_PRCS_CD
	* 코드
	- 그룹코드(280)
	- 코드 : 3 - QA TotalText, 4 - QA 항목심사, 5 - QA SafeWatch
	* 사용처
	- QA선정배치
	* 참조
	- TotalText
	  QA선정관리 테이블의 리스트 텍스트, CSPD003TF.AI_INPT_TOTALTEXT_TXT, LIKE 검색
	- 항목심사
	  QA선정관리 테이블의 항목심사 코드와 일치하고, 
	  CSPD004TF.INPT_SANTION_DAT_TXT, 리스트 텍스트와 LIKE 검색
	  CSPD004TF.INPT_SANCTION_NO 컬럼은, 심사항목코드 컬럼임. 세이프와치 심사항목 여부체크시 사용.
	  코드그룹 250(SW검사항목(수출)), 260(SW검사항목(수입)) 코드그룹이 세이프와치 대상 심사항목 코드들임.
	- SafeWatch
	   항목심사와 동일한데, 세이프와치 항목만 체크
	  CSPD004TF.SAFEWATCH_ITM_YN 세이프와치 항목 여부
	- INPT_ATMC_BIZ_DSCD : 1 - 수입, 2 - 수출, 3 - QA
	- 리스트 테이블 : CSPD103TI
	* 수정이력
	- 2019/08/12
	(세이프와치 체크방식 변경처리)
	CSPD004TF (항목심사결과상세) 테이블
	CSPD004TF.SAFEWATCH_ITM_YN 은 사용안함. 데이터 입력시 업데이트 안됨.
	CSPD004TF.INPT_SANCTION_NO 심사항목 체크.
	250(SW검사항목(수출)), 260(SW검사항목(수입)) 코드그룹이 세이프와치 대상 심사항목 코드들임.
	CSPD111TI(코드그룹), CSPD112TI(공통코드)
	*/
	
	/**
	 * QA 대상선정 배치
	 * QA선정건수 (총건수 * 3) : TotalText, 항목심사, SafeWatch(Detection ID가 존재하는건에 한함)
	 * 선정 우선순위 : 조건 > Random (조건에 해당되는 건수가 미달되는 경우 Random으로 선정)
	 * cron : 초 분 시간 일 월 년도 (0/20 - 0초부터 20초단위로 반복)
	 * 배치실행시 설정	: @Scheduled(cron="0 0 6 * * *")
	 * 테스트시 설정		: @ResponseBody @GetMapping("/batch/qa/target")
	 */
	@ResponseBody 
	@GetMapping("/batch/qa/target")
	public void batch() throws Exception {
		printGenLog(0, "############## 배치시작 ##############");
		
		SearchVO search = new SearchVO();
		
		int expTotCnt = 0;						//수출 총건수
		int expRndCnt = 0;						//수출 랜덤건수
		String expInptCd = "";					//수출 조건 심사항목 코드
		String expListId = "";					//수출 조건 리스트 코드
		int inpTotCnt = 0;						//수입 총건수
		int inpRndCnt = 0;						//수입 랜덤건수
		String inpInptCd = "";					//수입 조건 심사항목 코드
		String inpListId = "";					//수입 조건 리스트 코드
		
		String today = DateUtil.getFormatDate("yyyyMMdd");
		
		search.setInptRcpDt(today);
		
		String toDate = qaTargetBatchService.selectToDate(search);
		
		if(StringUtil.isEmpty(toDate)) {
			printLog(5,"영업일이 아닙니다.");
			return;
		}
		
		String recentDate = qaTargetBatchService.selectRecentDate(search);
		
		if(StringUtil.isEmpty(recentDate)) {
			printLog(5,"설정정보가 존재하지 않습니다.");
			return;
		}
		
		// QA 배정 배치 초기화
		search.setLstCd("QaBatch");
		qaTargetBatchService.resetQaUser(search);
		
		//********** QA 대상 선정할 사용자 목록 가져오기 (QA 사용자 중에 부재중 사용자는 제외) **********
		search.setRecordCountPerPage(-1);	//페이징 없이 전체목록 가져오기
		
		//일단 테스트 하는동안 아래조건 비활성화, 현재 사용자 전체에게 배정테스트.
		search.setSchAuth("03");			//QA사용자
		search.setAiInptUserFaReYn("N");	//사용자 부재여부
		
		List<AdminUserVO> userList = adminUserService.selectList(search);
		if(userList==null || userList.size()==0) {
			printLog(3,"선정할 직원이 존재하지 않습니다.");
			return;
		}
		
		//********** QA대상선정 설정정보 가져오기. (CSPD107TI - 품질관리선정대상관리) **********
		List<AdminQaTargetVO> qaTargetConfigList = adminQaTargetService.selectList(search);
		if(qaTargetConfigList == null || qaTargetConfigList.size() == 0) {
			printLog(4,"QA선정할 심사가 없습니다.");
			return;
		} else if(qaTargetConfigList.size() < 2) {
			printLog(2,"설정정보가 잘 못 되었습니다.");
			return;
		} else {
			
			for(int i = 0; i<2; i++) {
				AdminQaTargetVO row = qaTargetConfigList.get(i);
				String aiInptImexDscd = StringUtil.nvl(row.getAiInptImexDscd()).trim();
				int qlasItmTotCnt = Integer.parseInt(StringUtil.nvl(row.getQlasItmTotCnt(),"0").trim());
				int qlasVolnChcCnt = Integer.parseInt(StringUtil.nvl(row.getQlasVolnChcCnt(),"0").trim());
				String aiInptItmCd = StringUtil.nvl(row.getAiInptItmCd()).trim();
				String aiInptListId = StringUtil.nvl(row.getAiInptListId()).trim();
				
				if("1".equals(aiInptImexDscd)) {
					//수입
					inpTotCnt = qlasItmTotCnt;
					inpRndCnt = qlasVolnChcCnt;
					inpInptCd = aiInptItmCd;
					inpListId = aiInptListId;
				} else {
					//수출
					expTotCnt = qlasItmTotCnt;
					expRndCnt = qlasVolnChcCnt;
					expInptCd = aiInptItmCd;
					expListId = aiInptListId;
				}
			}
		}
		
		
		LOGGER.debug("========================= start =========================");
		LOGGER.debug("expTotCnt ::: " + expTotCnt);
		LOGGER.debug("expRndCnt ::: " + expRndCnt);
		LOGGER.debug("expInptCd ::: " + expInptCd);
		LOGGER.debug("expListId ::: " + expListId);
		LOGGER.debug("inpTotCnt ::: " + inpTotCnt);
		LOGGER.debug("inpRndCnt ::: " + inpRndCnt);
		LOGGER.debug("inpInptCd ::: " + inpInptCd);
		LOGGER.debug("inpListId ::: " + inpListId);
		LOGGER.debug("========================= end =========================");
		
		//********** 수출/수입 업무구분별 처리 **********
		String[] bizDsCds = {"1","2"};				//1 : 수입, 2 : 수출
		int sanctionCnt = 0;						// 항목심사 건수
		int totalTextCnt = 0;						// TotalText 건수
		int safeWatchCnt = 0;						// SafeWatch 건수
		int selCnt = 0;								// 조건 건수
		int totCnt = 0;								// 총건수
		int rndCnt = 0;								// 랜덤건수
		int finTotCnt = 0;							// 최종 총건수
		int finRndCnt = 0;							// 최종 랜덤건수
		int finSelCnt = 0;							// 최종 조건 건수
		
		String inptCd = "";
		String listId = "";
		String v_bizDscd = "";
		
		for(int i = 0; i<bizDsCds.length; i++) {
			String bizDsCd = bizDsCds[i];
			
			//********** 업무구분에 따른 설정값 설정 **********
			
			if("1".equals(bizDsCd)) {			//1 : 수입
				
				LOGGER.debug("========================= 수입 start =========================");
				
				totCnt = inpTotCnt;
				rndCnt = inpRndCnt;
				inptCd = inpInptCd;
				listId = inpListId;
				
			} else {							//2 : 수출
				
				LOGGER.debug("========================= 수출 start =========================");
				
				totCnt = expTotCnt;
				rndCnt = expRndCnt;
				inptCd = expInptCd;
				listId = expListId;
			}
			
			finTotCnt = totCnt * 3;
			finRndCnt = rndCnt * 3;
			finSelCnt = finTotCnt - finRndCnt;
			selCnt = totCnt - rndCnt;
			
			//********** QA 대상 선정할 심사업무 목록 가져오기 **********
				
			//********** QA 대상 선정 처리 **********
			//* QA선정 : 심사업무 마스터 테이블에, 품질보증 관련 컬럼정보 업데이트 처리.
			//* 선정조건
			//- QA선정건수 (총건수 * 3) : TotalText, 항목심사, SafeWatch(Detection ID가 존재하는건에 한함)
			//- 선정 우선순위 : 조건 > Random (조건에 해당되는 건수가 미달되는 경우 Random으로 선정)
			
			//업무배정 대상 전체  심사목록
			//(조건1)배치일시 기준, 전날심사업무
			//(조건2)심사결제상태가 승인인것만 가져옴
			search.setInptRcpDt(recentDate);
			search.setInptAtmcBizDscd(bizDsCd);
			search.setInptSanctionNo(inptCd);
			search.setLstCd(listId);
			
			IndexList<AdminUserVO> ul = new IndexList<AdminUserVO>(userList);
			
			//배치대상 개수가 배치 전체 건수보다 작으면 배치대상 개수만큼 업테이트 후 나머지 재 조회후 업데이트
			//배치대상 개수가 배치 전체 건수보다 크면 배치 전체 건수만큼 업데이트

			
			// 항목심사 조건 처리
			LOGGER.debug("========================= 항목심사 조건 처리 start =========================");
			
			// 항목심사 건수 초기화
			sanctionCnt = 0;
			
			// 항목심사 (3: totaltext, 4: 항목심사, 5: safeSatch)
			v_bizDscd = "4";
			search.setSchGbn(v_bizDscd);
			// 결과코드 Release
			search.setErrCd("40");

			List<QaTargetBatchVO> ruleSanctionList = qaTargetBatchService.selectRuleSanctionList(search);
			int ruleSanctionListSize = ruleSanctionList.size();
			
			LOGGER.debug("========================= 항목심사 조건 개수 =========================");
			LOGGER.debug("ruleSanctionListSize ::: " + ruleSanctionListSize);
			LOGGER.debug("================================================================");
			
			for(int j = 0; j < ruleSanctionListSize; j++) {
				
				if (selCnt > sanctionCnt) {
					
					// 사용자정보 세팅
					AdminUserVO user = ul.getRotateItem();
					String v_qlasCrpeEno = user.getAiInptUserEno();
					
					// 항목심사 조회목록 랜덤처리
					int idx = ComUtil.rand(0, ruleSanctionList.size() - 1);
					QaTargetBatchVO row = ruleSanctionList.get(idx);
					ruleSanctionList.remove(idx);
					
					// 랜덤으로 선택된 마스터번호
					String v_inptMstSrno = row.getInptMstSrno();
					
					// QA 배정
					assignQaTask(v_bizDscd, v_inptMstSrno, v_qlasCrpeEno, today);
					
					sanctionCnt ++;
				}
			}
			
			// 항목심사 조건 개수가 부족할때
			if (selCnt > sanctionCnt) {
				
				LOGGER.debug("========================= 항목심사 조건 처리 추가 start =========================");
				
				// 결과코드 Clean
				search.setErrCd("10");
				ruleSanctionList = qaTargetBatchService.selectRuleSanctionList(search);
				ruleSanctionListSize = ruleSanctionList.size();
				
				LOGGER.debug("========================= 항목심사 조건 추가 개수 =========================");
				LOGGER.debug("ruleSanctionListSize ::: " + ruleSanctionListSize);
				LOGGER.debug("================================================================");
				
				for(int j = 0; j < ruleSanctionListSize; j++) {
					
					if (selCnt > sanctionCnt) {
						
						// 사용자정보 세팅
						AdminUserVO user = ul.getRotateItem();
						String v_qlasCrpeEno = user.getAiInptUserEno();
						
						// 항목심사 조회목록 랜덤처리
						int idx = ComUtil.rand(0, ruleSanctionList.size() - 1);
						QaTargetBatchVO row = ruleSanctionList.get(idx);
						ruleSanctionList.remove(idx);
						
						// 랜덤으로 선택된 마스터번호
						String v_inptMstSrno = row.getInptMstSrno();
						
						// QA 배정
						assignQaTask(v_bizDscd, v_inptMstSrno, v_qlasCrpeEno, today);
						
						sanctionCnt ++;
					}
				}
			}
			
			LOGGER.debug("========================= 항목심사 조건 처리 end =========================");
			
			
			// TotalText 조건 처리
			LOGGER.debug("========================= TotalText 조건 처리 start =========================");
			
			// TotalText 건수 초기화
			totalTextCnt = 0;
			
			// TotalText (3: totaltext, 4: 항목심사, 5: safeSatch)
			v_bizDscd = "3";
			search.setSchGbn(v_bizDscd);
			// 결과코드 Release
			search.setErrCd("40");
			
			ruleSanctionList = qaTargetBatchService.selectRuleSanctionList(search);
			ruleSanctionListSize = ruleSanctionList.size();
			
			LOGGER.debug("========================= TotalText 조건 개수 =========================");
			LOGGER.debug("ruleSanctionListSize ::: " + ruleSanctionListSize);
			LOGGER.debug("================================================================");
			
			for(int j = 0; j < ruleSanctionListSize; j++) {
				
				if (selCnt > totalTextCnt) {
					
					// 사용자정보 세팅
					AdminUserVO user = ul.getRotateItem();
					String v_qlasCrpeEno = user.getAiInptUserEno();
					
					// TotalText 조회목록 랜덤처리
					int idx = ComUtil.rand(0, ruleSanctionList.size() - 1);
					QaTargetBatchVO row = ruleSanctionList.get(idx);
					ruleSanctionList.remove(idx);
					
					// 랜덤으로 선택된 마스터번호
					String v_inptMstSrno = row.getInptMstSrno();
					
					// QA 배정
					assignQaTask(v_bizDscd, v_inptMstSrno, v_qlasCrpeEno, today);
					
					totalTextCnt ++;
				}
			}
			
			// TotalText 조건 개수가 부족할때
			if (selCnt > totalTextCnt) {
				
				LOGGER.debug("========================= TotalText 조건 처리 추가 start =========================");
				
				// 결과코드 Clean
				search.setErrCd("10");
				ruleSanctionList = qaTargetBatchService.selectRuleSanctionList(search);
				ruleSanctionListSize = ruleSanctionList.size();
				
				LOGGER.debug("========================= TotalText 조건 추가 개수 =========================");
				LOGGER.debug("ruleSanctionListSize ::: " + ruleSanctionListSize);
				LOGGER.debug("================================================================");
				
				for(int j = 0; j < ruleSanctionListSize; j++) {
					
					if (selCnt > totalTextCnt) {
						
						// 사용자정보 세팅
						AdminUserVO user = ul.getRotateItem();
						String v_qlasCrpeEno = user.getAiInptUserEno();
						
						// TotalText 조회목록 랜덤처리
						int idx = ComUtil.rand(0, ruleSanctionList.size() - 1);
						QaTargetBatchVO row = ruleSanctionList.get(idx);
						ruleSanctionList.remove(idx);
						
						// 랜덤으로 선택된 마스터번호
						String v_inptMstSrno = row.getInptMstSrno();
						
						// QA 배정
						assignQaTask(v_bizDscd, v_inptMstSrno, v_qlasCrpeEno, today);
						
						totalTextCnt ++;
					}
				}
			}
			
			LOGGER.debug("========================= TotalText 조건 처리 end =========================");
			
			
			// SafeWatch 조건 처리
			LOGGER.debug("========================= SafeWatch 조건 처리 start =========================");
			
			// SafeWatch 건수 초기화
			safeWatchCnt = 0;
			
			// SafeWatch (3: totaltext, 4: 항목심사, 5: safeSatch)
			v_bizDscd = "5";
			search.setSchGbn(v_bizDscd);
			// 결과코드 Release
			search.setErrCd("40");
			
			ruleSanctionList = qaTargetBatchService.selectRuleSanctionList(search);
			ruleSanctionListSize = ruleSanctionList.size();
			
			LOGGER.debug("========================= SafeWatch 조건 개수 =========================");
			LOGGER.debug("ruleSanctionListSize ::: " + ruleSanctionListSize);
			LOGGER.debug("================================================================");
			
			for(int j = 0; j < ruleSanctionListSize; j++) {
				
				if (selCnt > safeWatchCnt) {
					
					// 사용자정보 세팅
					AdminUserVO user = ul.getRotateItem();
					String v_qlasCrpeEno = user.getAiInptUserEno();
					
					// SafeWatch 조회목록 랜덤처리
					int idx = ComUtil.rand(0, ruleSanctionList.size() - 1);
					QaTargetBatchVO row = ruleSanctionList.get(idx);
					ruleSanctionList.remove(idx);
					
					// 랜덤으로 선택된 마스터번호
					String v_inptMstSrno = row.getInptMstSrno();
					
					// QA 배정
					assignQaTask(v_bizDscd, v_inptMstSrno, v_qlasCrpeEno, today);
					
					safeWatchCnt ++;
				}
			}
			
			// SafeWatch 조건 개수가 부족할때
			if (selCnt > safeWatchCnt) {
				
				LOGGER.debug("========================= SafeWatch 조건 처리 추가 start =========================");
				
				// 결과코드 Clean
				search.setErrCd("10");
				ruleSanctionList = qaTargetBatchService.selectRuleSanctionList(search);
				ruleSanctionListSize = ruleSanctionList.size();
				
				LOGGER.debug("========================= SafeWatch 조건 추가 개수 =========================");
				LOGGER.debug("ruleSanctionListSize ::: " + ruleSanctionListSize);
				LOGGER.debug("================================================================");
				
				for(int j = 0; j < ruleSanctionListSize; j++) {
					
					if (selCnt > safeWatchCnt) {
						
						// 사용자정보 세팅
						AdminUserVO user = ul.getRotateItem();
						String v_qlasCrpeEno = user.getAiInptUserEno();
						
						// SafeWatch 조회목록 랜덤처리
						int idx = ComUtil.rand(0, ruleSanctionList.size() - 1);
						QaTargetBatchVO row = ruleSanctionList.get(idx);
						ruleSanctionList.remove(idx);
						
						// 랜덤으로 선택된 마스터번호
						String v_inptMstSrno = row.getInptMstSrno();
						
						// QA 배정
						assignQaTask(v_bizDscd, v_inptMstSrno, v_qlasCrpeEno, today);
						
						safeWatchCnt ++;
					}
				}
			}
			
			LOGGER.debug("========================= SafeWatch 조건 처리 end =========================");
			
			
			
			// 항목심사 랜덤 처리
			LOGGER.debug("========================= 항목심사 랜덤 처리 start =========================");
			
			// 카운트 초기화
			
			// 항목심사 (3: totaltext, 4: 항목심사, 5: safeSatch)
			v_bizDscd = "4";
			search.setSchGbn(v_bizDscd);
			// 결과코드 Release
			search.setErrCd("40");

			ruleSanctionList = qaTargetBatchService.selectList(search);
			ruleSanctionListSize = ruleSanctionList.size();
			
			LOGGER.debug("========================= 항목심사 랜덤 개수 =========================");
			LOGGER.debug("ruleSanctionListSize ::: " + ruleSanctionListSize);
			LOGGER.debug("================================================================");
			
			for(int j = 0; j < ruleSanctionListSize; j++) {
				
				if (totCnt > sanctionCnt) {
					
					// 사용자정보 세팅
					AdminUserVO user = ul.getRotateItem();
					String v_qlasCrpeEno = user.getAiInptUserEno();
					
					// 항목심사 조회목록 랜덤처리
					int idx = ComUtil.rand(0, ruleSanctionList.size() - 1);
					QaTargetBatchVO row = ruleSanctionList.get(idx);
					ruleSanctionList.remove(idx);
					
					// 랜덤으로 선택된 마스터번호
					String v_inptMstSrno = row.getInptMstSrno();
					
					// QA 배정
					assignQaTask(v_bizDscd, v_inptMstSrno, v_qlasCrpeEno, today);
					
					sanctionCnt ++;
				}
			}
			
			// 항목심사 랜덤 개수가 부족할때
			if (totCnt > sanctionCnt) {
				
				LOGGER.debug("========================= 항목심사 랜덤 처리 추가 start =========================");
				
				// 결과코드 Clean
				search.setErrCd("10");
				ruleSanctionList = qaTargetBatchService.selectList(search);
				ruleSanctionListSize = ruleSanctionList.size();
				
				LOGGER.debug("========================= 항목심사 랜덤 추가 개수 =========================");
				LOGGER.debug("ruleSanctionListSize ::: " + ruleSanctionListSize);
				LOGGER.debug("================================================================");
				
				for(int j = 0; j < ruleSanctionListSize; j++) {
					
					if (totCnt > sanctionCnt) {
						
						// 사용자정보 세팅
						AdminUserVO user = ul.getRotateItem();
						String v_qlasCrpeEno = user.getAiInptUserEno();
						
						// 항목심사 조회목록 랜덤처리
						int idx = ComUtil.rand(0, ruleSanctionList.size() - 1);
						QaTargetBatchVO row = ruleSanctionList.get(idx);
						ruleSanctionList.remove(idx);
						
						// 랜덤으로 선택된 마스터번호
						String v_inptMstSrno = row.getInptMstSrno();
						
						// QA 배정
						assignQaTask(v_bizDscd, v_inptMstSrno, v_qlasCrpeEno, today);
						
						sanctionCnt ++;
					}
				}
			}
			
			LOGGER.debug("========================= 항목심사 랜덤 처리 end =========================");
			
			
			// TotalText 랜덤 처리
			LOGGER.debug("========================= TotalText 랜덤 처리 start =========================");
			
			// TotalText (3: totaltext, 4: 항목심사, 5: safeSatch)
			v_bizDscd = "3";
			search.setSchGbn(v_bizDscd);
			// 결과코드 Release
			search.setErrCd("40");
			
			ruleSanctionList = qaTargetBatchService.selectList(search);
			ruleSanctionListSize = ruleSanctionList.size();
			
			LOGGER.debug("========================= TotalText 랜덤 개수 =========================");
			LOGGER.debug("ruleSanctionListSize ::: " + ruleSanctionListSize);
			LOGGER.debug("================================================================");
			
			for(int j = 0; j < ruleSanctionListSize; j++) {
				
				if (totCnt > totalTextCnt) {
					
					// 사용자정보 세팅
					AdminUserVO user = ul.getRotateItem();
					String v_qlasCrpeEno = user.getAiInptUserEno();
					
					// TotalText 조회목록 랜덤처리
					int idx = ComUtil.rand(0, ruleSanctionList.size() - 1);
					QaTargetBatchVO row = ruleSanctionList.get(idx);
					ruleSanctionList.remove(idx);
					
					// 랜덤으로 선택된 마스터번호
					String v_inptMstSrno = row.getInptMstSrno();
					
					// QA 배정
					assignQaTask(v_bizDscd, v_inptMstSrno, v_qlasCrpeEno, today);
					
					totalTextCnt ++;
				}
			}
			
			// TotalText 랜덤 개수가 부족할때
			if (totCnt > totalTextCnt) {
				
				LOGGER.debug("========================= TotalText 랜덤 처리 추가 start =========================");
				
				// 결과코드 Clean
				search.setErrCd("10");
				ruleSanctionList = qaTargetBatchService.selectList(search);
				ruleSanctionListSize = ruleSanctionList.size();
				
				LOGGER.debug("========================= TotalText 랜덤 추가 개수 =========================");
				LOGGER.debug("ruleSanctionListSize ::: " + ruleSanctionListSize);
				LOGGER.debug("================================================================");
				
				for(int j = 0; j < ruleSanctionListSize; j++) {
					
					if (totCnt > totalTextCnt) {
						
						// 사용자정보 세팅
						AdminUserVO user = ul.getRotateItem();
						String v_qlasCrpeEno = user.getAiInptUserEno();
						
						// TotalText 조회목록 랜덤처리
						int idx = ComUtil.rand(0, ruleSanctionList.size() - 1);
						QaTargetBatchVO row = ruleSanctionList.get(idx);
						ruleSanctionList.remove(idx);
						
						// 랜덤으로 선택된 마스터번호
						String v_inptMstSrno = row.getInptMstSrno();
						
						// QA 배정
						assignQaTask(v_bizDscd, v_inptMstSrno, v_qlasCrpeEno, today);
						
						totalTextCnt ++;
					}
				}
			}
			
			LOGGER.debug("========================= TotalText 랜덤 처리 end =========================");
			
			
			// SafeWatch 랜덤 처리
			LOGGER.debug("========================= SafeWatch 랜덤 처리 start =========================");
			
			// SafeWatch (3: totaltext, 4: 항목심사, 5: safeSatch)
			v_bizDscd = "5";
			search.setSchGbn(v_bizDscd);
			// 결과코드 Release
			search.setErrCd("40");
			
			ruleSanctionList = qaTargetBatchService.selectList(search);
			ruleSanctionListSize = ruleSanctionList.size();
			
			LOGGER.debug("========================= SafeWatch 랜덤 개수 =========================");
			LOGGER.debug("ruleSanctionListSize ::: " + ruleSanctionListSize);
			LOGGER.debug("================================================================");
			
			for(int j = 0; j < ruleSanctionListSize; j++) {
				
				if (totCnt > safeWatchCnt) {
					
					// 사용자정보 세팅
					AdminUserVO user = ul.getRotateItem();
					String v_qlasCrpeEno = user.getAiInptUserEno();
					
					// SafeWatch 조회목록 랜덤처리
					int idx = ComUtil.rand(0, ruleSanctionList.size() - 1);
					QaTargetBatchVO row = ruleSanctionList.get(idx);
					ruleSanctionList.remove(idx);
					
					// 랜덤으로 선택된 마스터번호
					String v_inptMstSrno = row.getInptMstSrno();
					
					// QA 배정
					assignQaTask(v_bizDscd, v_inptMstSrno, v_qlasCrpeEno, today);
					
					safeWatchCnt ++;
				}
			}
			
			// SafeWatch 랜덤 개수가 부족할때
			if (totCnt > safeWatchCnt) {
				
				LOGGER.debug("========================= SafeWatch 랜덤 처리 추가 start =========================");
				
				// 결과코드 Clean
				search.setErrCd("10");
				ruleSanctionList = qaTargetBatchService.selectList(search);
				ruleSanctionListSize = ruleSanctionList.size();
				
				LOGGER.debug("========================= SafeWatch 랜덤 추가 개수 =========================");
				LOGGER.debug("ruleSanctionListSize ::: " + ruleSanctionListSize);
				LOGGER.debug("================================================================");
				
				for(int j = 0; j < ruleSanctionListSize; j++) {
					
					if (totCnt > safeWatchCnt) {
						
						// 사용자정보 세팅
						AdminUserVO user = ul.getRotateItem();
						String v_qlasCrpeEno = user.getAiInptUserEno();
						
						// SafeWatch 조회목록 랜덤처리
						int idx = ComUtil.rand(0, ruleSanctionList.size() - 1);
						QaTargetBatchVO row = ruleSanctionList.get(idx);
						ruleSanctionList.remove(idx);
						
						// 랜덤으로 선택된 마스터번호
						String v_inptMstSrno = row.getInptMstSrno();
						
						// QA 배정
						assignQaTask(v_bizDscd, v_inptMstSrno, v_qlasCrpeEno, today);
						
						safeWatchCnt ++;
					}
				}
			}
			
			LOGGER.debug("========================= SafeWatch 랜덤 처리 end =========================");
			
		}
		
		printGenLog(10000, "############## 배치종료 ##############");

	}
	
	/**
	 * 오류출력
	 * @param num			: 오류번호
	 * @param msg			: 오류내용
	 */
	private void printLog(int num, String msg) {
		LOGGER.debug("[QA 대상설정 배치 오류]");
		LOGGER.debug("* 오류번호 : "+num);
		LOGGER.debug("* 오류일시 : "+DateUtil.getFormatDate("yyyy-MM-dd hh:mm:ss"));
		LOGGER.debug("* 오류내용 : "+msg);
	}

	/**
	 * 로그출력
	 * @param num			: 오류번호
	 * @param msg			: 오류내용
	 */
	private void printGenLog(int num, String msg) {
		LOGGER.debug("[QA 대상설정 배치 로그]");
		LOGGER.debug("* 로그번호 : "+num);
		LOGGER.debug("* 로그일시 : "+DateUtil.getFormatDate("yyyy-MM-dd hh:mm:ss"));
		LOGGER.debug("* 로그내용 : "+msg);
	}

	/**
	 * QA배치 업데이트
	 * @param taskList		: 할당할 심사목록
	 * @param userList		: IndexList<AdminUserVO> userList
	 */
	private void assignQaTask(String inptAtmcBizDscd, String inptMstSrno, String qlasCrpeEno, String qlasAlocDt) {
		
		QaTargetBatchVO vo = new QaTargetBatchVO();
		
		//심사업무별 QA사용자 선정처리
		vo.setQlasCrpeEno(qlasCrpeEno);		//QA담당자 직원번호
		vo.setAiInptQaPrcsCd(inptAtmcBizDscd);
		vo.setQlasAlocDt(qlasAlocDt);
		vo.setInptMstSrno(inptMstSrno);		//심사마스터 번호
		
		vo.setAiInptBizDscd("3");
		vo.setCurtAiInspAtvtCd("110");
		vo.setAiInptAcvtStsCd("50");
		vo.setLstDbChgId("QaBatch");
		
		SearchVO searchVO = new SearchVO();
		searchVO.setUserId("QaBatch");
		
		String trnLogSrno = adminLogProgramService.selectTrnLogSrno(searchVO);
		
		vo.setTrnLogSrno(trnLogSrno);
		
		LOGGER.debug("========================= assignQaTask start =========================");
		LOGGER.debug("inptMstSrno ::: " + inptMstSrno);
		LOGGER.debug("inptAtmcBizDscd ::: " + inptAtmcBizDscd);
		LOGGER.debug("qlasCrpeEno ::: " + qlasCrpeEno);
		LOGGER.debug("qlasAlocDt ::: " + qlasAlocDt);
		LOGGER.debug("========================= assignQaTask end =========================");
		
		qaTargetBatchService.updateQaUser(vo);
//		qaTargetBatchService.insertSantionHis(vo);
	}
	
}