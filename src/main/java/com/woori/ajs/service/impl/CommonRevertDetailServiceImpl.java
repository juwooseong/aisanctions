package com.woori.ajs.service.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.woori.ajs.dao.CommonRevertDetailMapper;
import com.woori.ajs.model.AppLogVO;
import com.woori.ajs.model.AppTodoVO;
import com.woori.ajs.model.CommonRevertDetailVO;
import com.woori.ajs.model.LoginVO;
import com.woori.ajs.model.SearchVO;
import com.woori.ajs.service.AppLogService;
import com.woori.ajs.service.AppTodoService;
import com.woori.ajs.service.CommonRevertDetailService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.fdl.idgnr.EgovIdGnrService;
import egovframework.ui.cmmn.StringUtil;
import egovframework.ui.util.LoginUtils;

@Service("commonRevertDetailService")
public class CommonRevertDetailServiceImpl extends EgovAbstractServiceImpl implements CommonRevertDetailService {

	private static final Logger LOGGER = LoggerFactory.getLogger(CommonRevertDetailServiceImpl.class);
	
	@Resource(name = "commonRevertDetailMapper")
	private CommonRevertDetailMapper dao;
	
	// 일괄승인 위해 추가한것
	@Resource(name = "appTodoService")
	private AppTodoService appTodoService;
	// 일괄승인 위해 추가한것
	@Resource(name = "appLogService")
	private AppLogService appLogService;
	
	/** ID Generation */
	@Resource(name = "egovIdGnrService")
	private EgovIdGnrService egovIdGnrService;

	@Override
	public List<CommonRevertDetailVO> selectTopTab(SearchVO vo) throws Exception {
		return dao.selectTopTab(vo);
	}

	@Override
	public List<CommonRevertDetailVO> selectLeftTab(SearchVO vo) throws Exception {
		return dao.selectLeftTab(vo);
	}

	@Override
	public List<CommonRevertDetailVO> selectImgPageInfo(SearchVO vo) throws Exception {
		return dao.selectImgPageInfo(vo);
	}
	
	@Override
	public List<CommonRevertDetailVO> selectInptNacrd(SearchVO vo) throws Exception {
		return dao.selectInptNacrd(vo);
	}

	@Override
	public List<CommonRevertDetailVO> selectImgCdnts(SearchVO vo) throws Exception {
		return dao.selectImgCdnts(vo);
	}

	@Override
	public List<CommonRevertDetailVO> selectTotalTextRst(SearchVO vo) throws Exception {
		return dao.selectTotalTextRst(vo);
	}
	
	@Override
	public List<CommonRevertDetailVO> selectSafeWtchRst(SearchVO vo) throws Exception {
		return dao.selectSafeWtchRst(vo);
	}

	@Override
	public List<CommonRevertDetailVO> selectSancRst(SearchVO vo) throws Exception {
		return dao.selectSancRst(vo);
	}
	
	@Override
	public CommonRevertDetailVO selectStdInfo(SearchVO vo) throws Exception {
		
		return dao.selectStdInfo(vo);
	}

	@Override
	public List<CommonRevertDetailVO> selectOpiHis(SearchVO vo) throws Exception {
		return dao.selectOpiHis(vo);
	}

	@Override
	public CommonRevertDetailVO selectOpi(SearchVO vo) throws Exception {
		return dao.selectOpi(vo);
	}
	
	public List<Map<String, String>> selectSanctionTaTargetList(CommonRevertDetailVO vo) throws Exception {
		return dao.selectSanctionTaTargetList(vo);
	}
	
	// [수기추가 컬럼 기능] 신규 — "수기입력" 또는 "수기 추가"(1~3) 중 하나라도 값이 있으면 true.
	// saveSantion()/inspection() 양쪽에서 항목별 insert/update 실행 여부를 판단하는 데 쓰인다.
	// (수기입력만 확인하던 기존 로직으로는 "수기 추가" 컬럼만 입력한 행이 저장되지 않는 문제가 있었음)
	private boolean hasHndgInputData(CommonRevertDetailVO sData) {
		return !StringUtil.isEmpty(sData.getItmInptHndgInpDatTxt())
				|| !StringUtil.isEmpty(sData.getItmInptHndgAdd1Txt())
				|| !StringUtil.isEmpty(sData.getItmInptHndgAdd2Txt())
				|| !StringUtil.isEmpty(sData.getItmInptHndgAdd3Txt());
	}

	@Override
	public void saveSantion(CommonRevertDetailVO vo) throws Exception {
		String checkSf = "";
		String inptTaskId = "";
		String inptSanctionNo = "";
		String itmInptHndgInpDatTxt = "";
		String aiInptTpySaveYn = vo.getAiInptTpySaveYn();
		
		if (vo.getSanctionList() != null && vo.getSanctionList().size() > 0) {
			
			// 수기입력 생성 데이터 삭제
			dao.deleteHndgInpDatTxt(vo);
			// 수기입력값 변경 데이터 초기화
			dao.initHndgInpDatTxt(vo);
			// AI_INPT_ALT_YN 초기화
			dao.initAltYn(vo);
			
			for (CommonRevertDetailVO sData: vo.getSanctionList()) {
				
				// 수기 데이터 있으면
				itmInptHndgInpDatTxt = sData.getItmInptHndgInpDatTxt();
				sData.setTrnLogSrno(vo.getTrnLogSrno());

				// [수기추가 컬럼 기능][변경] 원래는 "수기입력"(itmInptHndgInpDatTxt) 값이 있을 때만
				// insert/update가 실행됐다. "수기입력"은 비워두고 동적 "수기 추가" 컬럼만 입력한 경우도
				// 저장돼야 하므로, 4개 필드 중 하나라도 값이 있으면 실행되도록 조건을 넓혔다.
				if (hasHndgInputData(sData)) {
					
					// 그룹내 SafeWatch = 'Y' 인 해당 Sanction 이미지 조회
					checkSf = dao.checkSf(sData);
					
					if (checkSf != null) {
						
						// 그룹내 Safewatch = 'Y'인 해당 정보가 존재 할 경우
						dao.updateSantionHndgInpDatTxt(sData);
						
					} else {
						
						// 그룹내 가장 빠른 이미지 조회	
						inptTaskId = dao.selectMinTaskId(sData);
						sData.setInptTaskId(inptTaskId);
						
						// 그륩내 입력 Sanction번호 정보 존재 여부 확인(insert/update 판단)
						inptSanctionNo = dao.checkSanctionNo(sData);
						
						if (inptSanctionNo != null) {
							
							// 그룹내 입력 Sanction번호 정보 존재시, update
							dao.updateSantionHndgInpDatTxtAndSfw(sData);
							
						} else {
							
							// 그룹내 입력 Sanction번호 정보 미존재시, insert
							dao.insertSantionHndgInpDatTxt(sData);
						}
					}
				}
				
				// AI_INPT_ALT_YN = Y
				if ("Y".equals(sData.getAiInptAltYn())) {
					
					// UPDATE AI_INPT_ALT_YN = N
					// WHERE
					// inptTaskId
					// inptSanctionNo
					// inptMstSrno
					dao.updateAltYn(sData);
				}
			}
		}
		
		if (vo.getMstQltGrnAiInptRstCd() == null) {
			dao.updateSantionMasAtvt(vo);
		} else {
			dao.updateQaMasAtvt(vo);
		}
		
		if ("Y".equals(aiInptTpySaveYn)) {
			dao.updateSantionApprvHis(vo);
		}
	}
	
	@Override
	public void inspection(CommonRevertDetailVO vo) throws Exception {
		String checkSf = "";
		String inptTaskId = "";
		String inptSanctionNo = "";
		String itmInptHndgInpDatTxt = "";
		
		if (vo.getSanctionList() != null && vo.getSanctionList().size() > 0) {
			
			// 수기입력 생성 데이터 삭제
			dao.deleteHndgInpDatTxt(vo);
			// 수기입력값 변경 데이터 초기화
			dao.initHndgInpDatTxt(vo);
			// AI_INPT_ALT_YN 초기화
			dao.initAltYn(vo);
			
			for (CommonRevertDetailVO sData: vo.getSanctionList()) {
				
				// 수기 데이터 있으면
				itmInptHndgInpDatTxt = sData.getItmInptHndgInpDatTxt();
				sData.setTrnLogSrno(vo.getTrnLogSrno());

				// [수기추가 컬럼 기능][변경] 원래는 "수기입력"(itmInptHndgInpDatTxt) 값이 있을 때만
				// insert/update가 실행됐다. "수기입력"은 비워두고 동적 "수기 추가" 컬럼만 입력한 경우도
				// 저장돼야 하므로, 4개 필드 중 하나라도 값이 있으면 실행되도록 조건을 넓혔다.
				if (hasHndgInputData(sData)) {
					
					
					// 그룹내 SafeWatch = 'Y' 인 해당 Sanction 이미지 조회
					checkSf = dao.checkSf(sData);
					
					if (checkSf != null) {
						
						// 그룹내 Safewatch = 'Y'인 해당 정보가 존재 할 경우
						dao.updateSantionHndgInpDatTxt(sData);
						
					} else {
						
						// 그룹내 가장 빠른 이미지 조회	
						inptTaskId = dao.selectMinTaskId(sData);
						sData.setInptTaskId(inptTaskId);
						
						// 그륩내 입력 Sanction번호 정보 존재 여부 확인(insert/update 판단)
						inptSanctionNo = dao.checkSanctionNo(sData);
						
						if (inptSanctionNo != null) {
							
							// 그룹내 입력 Sanction번호 정보 존재시, update
							dao.updateSantionHndgInpDatTxtAndSfw(sData);
							
						} else {
							
							// 그룹내 입력 Sanction번호 정보 미존재시, insert
							dao.insertSantionHndgInpDatTxt(sData);
						}
					}
				}
				
				// AI_INPT_ALT_YN = Y
				if ("Y".equals(sData.getAiInptAltYn())) {
					
					// UPDATE AI_INPT_ALT_YN = N
					// WHERE
					// inptTaskId
					// inptSanctionNo
					// inptMstSrno
					dao.updateAltYn(sData);
				}
			}
		}
		
		if (vo.getMstQltGrnAiInptRstCd() == null) {
			dao.updateSantionMasAtvt(vo);
		} else {
			dao.updateQaMasAtvt(vo);
		}
		
		dao.updateSantionHis(vo);
		dao.updateSantionApprvHis(vo);
	}
	
	// 심사자 결재자 이력
	@Override
	public void updateSantionApprvHis(CommonRevertDetailVO vo) throws Exception {
		
		// Penging아니면 이력 추가
		String aiInptAcvtStsCd = vo.getAiInptAcvtStsCd();
		String nextAiInspAtvtCd = vo.getNextAiInspAtvtCd();
		String aiInspeEno = vo.getAiInspeEno();
		String aiInptAnpeEno = vo.getAiInptAnpeEno();
		
		dao.updateSantionMasAtvt(vo);
		dao.updateSantionApprvHis(vo);
		dao.insertSantionHis(vo);
		
		// 상신, 재상신, 반려 시 업무 대기 이력 추가
		if ("90".equals(aiInptAcvtStsCd) || "100".equals(aiInptAcvtStsCd) || "130".equals(aiInptAcvtStsCd)) {
			
			nextAiInspAtvtCd = "100";
			aiInptAcvtStsCd = "50";
			vo.setNextAiInspAtvtCd(nextAiInspAtvtCd);
			vo.setAiInptAcvtStsCd(aiInptAcvtStsCd);
			vo.setAiInptCrpeEno(aiInptAnpeEno);
			vo.setAiInptPrcOpiTxt("");
			
			dao.insertSantionHis(vo);
		}
		
		if ("120".equals(aiInptAcvtStsCd)) {
			
			nextAiInspAtvtCd = "90";
			aiInptAcvtStsCd = "50";
			vo.setNextAiInspAtvtCd(nextAiInspAtvtCd);
			vo.setAiInptAcvtStsCd(aiInptAcvtStsCd);
			vo.setAiInptCrpeEno(aiInspeEno);
			vo.setAiInptPrcOpiTxt("");
			
			dao.insertSantionHis(vo);
		}
	}
	
	@Override
	public void updateQaApprvHis(CommonRevertDetailVO vo) throws Exception {
		dao.updateQaMasAtvt(vo);
		dao.updateSantionApprvHis(vo);
		dao.insertSantionHis(vo);
		
		String aiInptAcvtStsCd = vo.getAiInptAcvtStsCd();
		String nextAiInspAtvtCd = vo.getNextAiInspAtvtCd();
		String qlasCrpeEno = vo.getQlasCrpeEno();
		String qlasSnpeEno = vo.getQlasSnpeEno();
		
		// 상신, 재상신
		if ("90".equals(aiInptAcvtStsCd) || "100".equals(aiInptAcvtStsCd)) {
			
			nextAiInspAtvtCd = "120";
			aiInptAcvtStsCd = "50";
			vo.setNextAiInspAtvtCd(nextAiInspAtvtCd);
			vo.setAiInptAcvtStsCd(aiInptAcvtStsCd);
			vo.setAiInptCrpeEno(qlasSnpeEno);
			vo.setAiInptPrcOpiTxt("");
			
			dao.insertSantionHis(vo);
		}
		
		// 반려
		if ("120".equals(aiInptAcvtStsCd)) {
			
			nextAiInspAtvtCd = "110";
			aiInptAcvtStsCd = "50";
			vo.setNextAiInspAtvtCd(nextAiInspAtvtCd);
			vo.setAiInptAcvtStsCd(aiInptAcvtStsCd);
			vo.setAiInptCrpeEno(qlasCrpeEno);
			vo.setAiInptPrcOpiTxt("");
			
			dao.insertSantionHis(vo);
		}
	}
	
	@Override
	public void updateReScanNed(CommonRevertDetailVO vo) throws Exception {
		dao.updateReScanNed(vo);
		dao.updateSantionHis(vo);
		dao.insertSantionHis(vo);
	}
	
	@Override
	public void reCrf(CommonRevertDetailVO vo) throws Exception {
		
		// 다른 BL그룹 이동일 경우
		String spdKind = vo.getSpdKind();
		if ("notMatched".equals(spdKind)) {
			dao.update3TF(vo);
			dao.update4TF(vo);
		}
		
		dao.reCrf(vo);
		dao.updateCrfYn(vo);
	}
	
	@Override
	public void updateExtraction(CommonRevertDetailVO vo) throws Exception {
		dao.insertSantionHis(vo);
	}
	
	@Override
	public void updateSantionHis(CommonRevertDetailVO vo) throws Exception {
		dao.updateSantionHis(vo);
	}
	
	@Override
	public List<CommonRevertDetailVO> selectAppvRecode(SearchVO vo) throws Exception {
		return dao.selectAppvRecode(vo);
	}

	@Override
	public int selectCheckAccess(SearchVO vo) throws Exception {
		return dao.selectCheckAccess(vo);
	}
	
	@Override
	public String CheackCd(SearchVO vo) throws Exception {
		return dao.CheackCd(vo);
	}
	
	@Override
	public String getNationCd(CommonRevertDetailVO vo) throws Exception {
		return dao.getNationCd(vo);
	}

	@Override
	public void updateCommonApprvHis(HttpServletRequest request, String[] ids, String[] aiInptAppvHstIds, String[] inptAtmcBizDscds,
			String[] aiInptTpySaveYns, String[] aiInptCrpeEnos, String[] totaltextAiInptRstCds,
			String[] itmInptAiInptRstCds, String[] aiInptQlasPrgStsCds, String[] inptAtvtCds, String revertMemo, String trnLogSrnos) throws Exception {
			
		SearchVO searchVO = new SearchVO();
		AppTodoVO vo = new AppTodoVO();
		String trnLogSrno = trnLogSrnos;
		vo.setTrnLogSrno(trnLogSrno);
		LoginVO loginInfo = LoginUtils.getLoginInfo(request);
		String RevertMemo = revertMemo;
		for(int i=0;i<ids.length;i++) {
			String id = ids[i];
			String aiInptAppvHstId = aiInptAppvHstIds[i];
			String inptAtmcBizDscd = inptAtmcBizDscds[i];
			String aiInptTpySaveYn = aiInptTpySaveYns[i];
			String totaltextAiInptRstCd = totaltextAiInptRstCds[i];
			String itmInptAiInptRstCd = itmInptAiInptRstCds[i];
			String aiInptQlasPrgStsCd;
			
			if (aiInptQlasPrgStsCds[i] == null) {
				aiInptQlasPrgStsCd = null;
			} else {
				aiInptQlasPrgStsCd = aiInptQlasPrgStsCds[i];
			}
			String inptAtvtCd = inptAtvtCds[i];
			String qltGrnAiInptRstCd;
			if(StringUtil.isNotEmpty(id)) {
				
				// 이력 업데이트
				String aiInptAcvtStsCd = "";
				
				CommonRevertDetailVO commonRevertDetailVO = new CommonRevertDetailVO();
							
				aiInptAcvtStsCd = "51";
				
				commonRevertDetailVO.setInptMstSrno(Integer.valueOf(id));
				commonRevertDetailVO.setLstDbChgId(loginInfo.getEno());
				commonRevertDetailVO.setAiInptCrpeEno(loginInfo.getEno());
				commonRevertDetailVO.setAiInptAcvtStsCd(aiInptAcvtStsCd);
				commonRevertDetailVO.setTrnLogSrno(trnLogSrno);
				
				updateSantionHis(commonRevertDetailVO);
				
				searchVO.setInptMstSrno(Integer.parseInt(id));
				
				
				qltGrnAiInptRstCd = dao.getqltGrnAiInptRstCd(searchVO);
				
				
				searchVO.setAppvPrgStcd("90");
				List<AppLogVO> logList = appLogService.selectList(searchVO);
				if(logList!=null && logList.size() > 0) {
					vo.setInptMstSrno(id);
					appTodoService.bundle(vo);
					
					CommonRevertDetailVO CommonVo = new CommonRevertDetailVO();
					
					CommonVo.setInptMstSrno(Integer.parseInt(id));
					
					CommonVo.setAiInptAppvStcd("160");
					CommonVo.setAiInptAppvSrno(Integer.parseInt(aiInptAppvHstId));
					CommonVo.setAiInptPrcOpiTxt(vo.getRevertMemo());
					CommonVo.setLstDbChgId(loginInfo.getId());
					CommonVo.setAiInptBizDscd(inptAtmcBizDscd);
					CommonVo.setAiInptTpySaveYn(aiInptTpySaveYn);
					CommonVo.setAiInptCrpeEno(loginInfo.getId());
					CommonVo.setAiInptPrcOpiTxt(RevertMemo);	
					CommonVo.setTrnLogSrno(trnLogSrno);
					
					if(("1".equals(inptAtmcBizDscd) || "2".equals(inptAtmcBizDscd)) && "30".equals(totaltextAiInptRstCd)) {
						CommonVo.setMstTotaltextAiInptRstCd("40");
					}else {
						CommonVo.setMstTotaltextAiInptRstCd(totaltextAiInptRstCd);
					}
					
					if(("1".equals(inptAtmcBizDscd) || "2".equals(inptAtmcBizDscd)) && "30".equals(itmInptAiInptRstCd)) {
						CommonVo.setMstInptItmAiInptRstCd("40");
					}else {
						CommonVo.setMstInptItmAiInptRstCd(itmInptAiInptRstCd);
					}
					CommonVo.setMstQltGrnAiInptRstCd(qltGrnAiInptRstCd); 
					CommonVo.setCurtAiInspAtvtCd(inptAtvtCd);
					CommonVo.setAiInptAcvtStsCd("160");
					CommonVo.setAiInptAcvtCd("160"); // 일괄결제 고려하여 일단 160
					if("3".equals(inptAtmcBizDscd)) {
						CommonVo.setNextAiInspAtvtCd("120"); // QA 승인 시 점검결과 확인 및 결재 상태
						updateQaApprvHis(CommonVo);
					}else {
						CommonVo.setNextAiInspAtvtCd("100"); // 심사결과 확인 및 결재 상태
						updateSantionApprvHis(CommonVo);
					}
				}
			}
		}
	}

	@Override
	public boolean ModiBlNum(CommonRevertDetailVO vo) throws Exception {
		// TODO Auto-generated method stub
		List<CommonRevertDetailVO> blGroupList = dao.ModiBlNum(vo);
		List<CommonRevertDetailVO> taskIdForBl = null;
		int inptBlGrpNoModi;
		int updateBlResult;
		boolean result = true;
		
		taskIdForBl = dao.selectTaskIdForBl(vo);
		for (int ij=0; ij<taskIdForBl.size(); ij++) {
			vo.setInptTaskId(taskIdForBl.get(ij).getInptTaskId()); 
			updateBlResult = dao.UpdateBlNumText(vo);
			if(updateBlResult <= 0) {
				return false;
			}
		}
		if (blGroupList.size() > 0) {
			// 002 테이블애서 해당 뮨서코드, 비엘크룹코드를 갖고있는 task id를 가져온후. task id 갯수로 for문을 돌리고 해당 task id를 인자값으로 반복문돌려서 update
			// dao를 추기
				for(int i=0; i<taskIdForBl.size(); i++) {
					vo.setInptTaskId(taskIdForBl.get(i).getInptTaskId()); 
					dao.UpdateSfwChange(vo);
				}

				inptBlGrpNoModi = blGroupList.get(0).getInptBlGrpNo();
				if(vo.getInptBlGrpNo() == 1) {
					vo.setInptBlGrpNo(inptBlGrpNoModi);
					vo.setInptBlGrpNoModi(1); 
				}else {
					vo.setInptBlGrpNoModi(inptBlGrpNoModi);
				}
				
				try {
					dao.ModiBlNumUpdate(vo);
				}catch (Exception e) {
					result = false;
					LOGGER.error("Exception ::: " + e);
				}
		} else {
			try {
				
				for(int i=0; i<taskIdForBl.size(); i++) {
					vo.setInptTaskId(taskIdForBl.get(i).getInptTaskId()); 
					dao.ModiBlNumNewPutSanction(vo);
				}
			}catch (Exception e) {
				result = false;
				LOGGER.error("Exception ::: " + e);
			}
		}

		return result;
	}
}