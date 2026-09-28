package com.woori.ajs.service;

import java.util.List;

import com.woori.ajs.model.AdminBusinessDayVO;
import com.woori.ajs.model.AdminWordCorrectionVO;
import com.woori.ajs.model.SearchVO;

public interface AdminWordCorrectionService {

	// 후보정용어관리 리스트 조회
	List<AdminWordCorrectionVO> selectList(SearchVO searchVO) throws Exception; 
	
	// 후보정용어관리 페이징
	int selectListTotCnt(SearchVO searchVO);
	
	// 후보정항목 html selectBox 리스트 조회
	List<AdminWordCorrectionVO> selectSanctionList(SearchVO searchVO) throws Exception;
	
	// 후보정항목 업데이트 시 중복체크 조회
	int selectWordDuplicationCheck(AdminWordCorrectionVO adminWordCorrectionVO);
	
	// 후보정항목 update
	void updateWord(AdminWordCorrectionVO adminWordCorrectionVO);
	
	// 후보정항목 insert
	void insertWord(AdminWordCorrectionVO adminWordCorrectionVO);
	
	// 후보정항목 delete
	void deleteWord(AdminWordCorrectionVO adminWordCorrectionVO);
}