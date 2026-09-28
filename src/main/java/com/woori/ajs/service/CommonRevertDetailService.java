package com.woori.ajs.service;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import com.woori.ajs.model.CommonRevertDetailVO;
import com.woori.ajs.model.SearchVO;

public interface CommonRevertDetailService {

	List<CommonRevertDetailVO> selectTopTab(SearchVO vo) throws Exception;
	
	List<CommonRevertDetailVO> selectLeftTab(SearchVO vo) throws Exception;
	
	List<CommonRevertDetailVO> selectImgPageInfo(SearchVO vo) throws Exception;
	
	List<CommonRevertDetailVO> selectImgCdnts(SearchVO vo) throws Exception;
	
	List<CommonRevertDetailVO> selectTotalTextRst(SearchVO vo) throws Exception;
	
	List<CommonRevertDetailVO> selectSafeWtchRst(SearchVO vo) throws Exception;
	
	List<CommonRevertDetailVO> selectSancRst(SearchVO vo) throws Exception;

	List<CommonRevertDetailVO> selectInptNacrd(SearchVO vo) throws Exception;
	
	CommonRevertDetailVO selectStdInfo(SearchVO vo) throws Exception;
	
	List<CommonRevertDetailVO> selectOpiHis(SearchVO vo) throws Exception;
	
	CommonRevertDetailVO selectOpi(SearchVO vo) throws Exception;
	
	List<Map<String, String>> selectSanctionTaTargetList(CommonRevertDetailVO vo) throws Exception;
	
	void saveSantion(CommonRevertDetailVO vo) throws Exception;
	
	void inspection(CommonRevertDetailVO vo) throws Exception;
	
	void updateQaApprvHis(CommonRevertDetailVO vo) throws Exception;
	
	void updateSantionApprvHis(CommonRevertDetailVO vo) throws Exception;
	
	void updateSantionHis(CommonRevertDetailVO vo) throws Exception;
	
	List<CommonRevertDetailVO> selectAppvRecode(SearchVO vo) throws Exception;

	/**
	 * 현재 로그인한 사용자가 현재 접근하는 심사상세 팝업 페이지에 접근 가능한지, 체크해서 가능여부 반환.
	 * 접근가능시 1, 접근권한 없으면 0 반환.
	 * vo.setSchGbn("01");						//팝업종류(01 - 심사자, 03 - QA, 02 - 결재자)
	 * vo.setSchUserNo(loginInfo.getId());		//로그인한 사용자 아이디
	 * vo.setInptMstSrno(vo.getInptMstSrno());	//상세팝업의 심사번호 파라미터
	 */
	int selectCheckAccess(SearchVO vo) throws Exception;
	
	String CheackCd(SearchVO vo) throws Exception;
	
	String getNationCd(CommonRevertDetailVO vo) throws Exception;
	
	void updateCommonApprvHis(HttpServletRequest request, String[] ids, String[] aiInptAppvHstIds, String[] inptAtmcBizDscds, String[] aiInptTpySaveYns, 
			String[] aiInptCrpeEnos, String[] totaltextAiInptRstCds, String[] itmInptAiInptRstCds, String[] aiInptQlasPrgStsCds, String[] inptAtvtCds, String revertMemo, String trnLogSrno) throws Exception;

	void updateReScanNed(CommonRevertDetailVO vo) throws Exception;
	
	void reCrf(CommonRevertDetailVO vo) throws Exception;
	
    boolean ModiBlNum(CommonRevertDetailVO vo) throws Exception;

	void updateExtraction(CommonRevertDetailVO vo) throws Exception;
}
