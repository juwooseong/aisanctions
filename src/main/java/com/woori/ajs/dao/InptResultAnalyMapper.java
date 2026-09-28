package com.woori.ajs.dao;

import java.util.List;

import com.woori.ajs.model.SearchVO;
import com.woori.ajs.model.AdminAbsenceVO;
import com.woori.ajs.model.InptResultAnalyVO;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Mapper("inptResultAnalyMapper")
public interface InptResultAnalyMapper {

	// 관리자메뉴 > 시스템심사진행현황 > 심사결과분석(세트별) 
	List<InptResultAnalyVO> selectRefList(SearchVO searchVO) throws Exception;
	
	// 관리자메뉴 > 시스템심사진행현황 > 심사결과분석(항목별)
	List<InptResultAnalyVO> selectCategoryList(SearchVO searchVO) throws Exception;
	
	// 관리자메뉴 > 시스템심사진행현황 > 처리성능 분석
	List<InptResultAnalyVO> selectPerformanceList(SearchVO searchVO) throws Exception;
	
	// 관리자메뉴 > 시스템심사진행현황 > 심사수기등록 현황
	List<InptResultAnalyVO> selectSugiList(SearchVO searchVO) throws Exception;
	
	// 통계 > 성능분석 > 일 주요 성능지표
	List<InptResultAnalyVO> selectDailyPerformList(SearchVO searchVO) throws Exception;
}