package com.woori.ajs.dao;

import java.util.List;
import java.util.Map;

import com.woori.ajs.model.CommonRevertDetailVO;
import com.woori.ajs.model.SearchVO;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Mapper("commonRevertDetailMapper")
public interface CommonRevertDetailMapper {

	List<CommonRevertDetailVO> selectTopTab(SearchVO vo) throws Exception;
	
	List<CommonRevertDetailVO> selectLeftTab(SearchVO vo) throws Exception;
	
	List<CommonRevertDetailVO> selectImgPageInfo(SearchVO vo) throws Exception;
	
	List<CommonRevertDetailVO> selectImgCdnts(SearchVO vo) throws Exception;
	
	List<CommonRevertDetailVO> selectTotalTextRst(SearchVO vo) throws Exception;
	
	List<CommonRevertDetailVO> selectSafeWtchRst(SearchVO vo) throws Exception;
	
	List<CommonRevertDetailVO> selectSancRst(SearchVO vo) throws Exception;
	
	CommonRevertDetailVO selectStdInfo(SearchVO vo) throws Exception;
	
	List<CommonRevertDetailVO> selectOpiHis(SearchVO vo) throws Exception;
	
	CommonRevertDetailVO selectOpi(SearchVO vo) throws Exception;
	
	List<Map<String, String>> selectSanctionTaTargetList(CommonRevertDetailVO vo) throws Exception;
	
	void updateSantionApprvHis(CommonRevertDetailVO vo) throws Exception;
	
	void updateSantionMasAtvt(CommonRevertDetailVO vo) throws Exception;
	
	void updateQaMasAtvt(CommonRevertDetailVO vo) throws Exception;
	
	void updateSantionHndgInpDatTxt(CommonRevertDetailVO vo) throws Exception;
	
	void insertSantionHndgInpDatTxt(CommonRevertDetailVO vo) throws Exception;
	
	List<CommonRevertDetailVO> checkSfwIsNullOrNo(CommonRevertDetailVO vo) throws Exception;
	
	void insertSantionHis(CommonRevertDetailVO vo) throws Exception;
	
	List<CommonRevertDetailVO> selectAppvRecode(SearchVO vo) throws Exception;
	
	int selectCheckAccess(SearchVO vo) throws Exception;
	
	String CheackCd(SearchVO vo) throws Exception;
	
	String getNationCd(CommonRevertDetailVO vo) throws Exception;

	void updateReScanNed(CommonRevertDetailVO vo) throws Exception;
	
	void reCrf(CommonRevertDetailVO vo) throws Exception;
	
	void updateCrfYn(CommonRevertDetailVO vo) throws Exception;
	
	void update3TF(CommonRevertDetailVO vo) throws Exception;
	
	void update4TF(CommonRevertDetailVO vo) throws Exception;
	
	void updateSantionHis(CommonRevertDetailVO vo) throws Exception;

	List<CommonRevertDetailVO> selectInptNacrd(SearchVO vo);
	
	List<CommonRevertDetailVO> ModiBlNum(CommonRevertDetailVO vo) throws Exception;
	
	void ModiBlNumUpdate(CommonRevertDetailVO vo) throws Exception;
	
	void ModiBlNumUpdateSanction(CommonRevertDetailVO vo) throws Exception;

	void ModiBlNumNewPut(CommonRevertDetailVO vo) throws Exception;
	
	void ModiBlNumNewPutSanction(CommonRevertDetailVO vo) throws Exception;
	
	int UpdateBlNumText(CommonRevertDetailVO vo) throws Exception;
	
	int UpdateSfwChange(CommonRevertDetailVO vo) throws Exception;
	
	int updateSantionHndgInpDatTxtAndSfw(CommonRevertDetailVO vo) throws Exception;
	
	String getqltGrnAiInptRstCd(SearchVO vo) throws Exception;
	
	List<CommonRevertDetailVO> selectTaskIdForBl(CommonRevertDetailVO vo) throws Exception;
	
	void deleteHndgInpDatTxt(CommonRevertDetailVO vo) throws Exception;
	
	void initHndgInpDatTxt(CommonRevertDetailVO vo) throws Exception;
	
	void initAltYn(CommonRevertDetailVO vo) throws Exception;
	
	void updateAltYn(CommonRevertDetailVO vo) throws Exception;
	
	String checkSf(CommonRevertDetailVO vo) throws Exception;
	
	String selectMinTaskId(CommonRevertDetailVO vo) throws Exception;
	
	String checkSanctionNo(CommonRevertDetailVO vo) throws Exception;
	
	String checkOrigItem(CommonRevertDetailVO vo) throws Exception;
	
	void updateSantionHndgInpDatTxtByOrigItem(CommonRevertDetailVO vo) throws Exception;
	
	void mergeSantionHndgAddRow(CommonRevertDetailVO vo) throws Exception;
	
	Integer selectMaxItmInptValSeq(CommonRevertDetailVO vo) throws Exception;
	
}
