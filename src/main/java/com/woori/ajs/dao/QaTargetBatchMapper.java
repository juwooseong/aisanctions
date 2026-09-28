package com.woori.ajs.dao;

import java.util.List;

import com.woori.ajs.model.QaTargetBatchVO;
import com.woori.ajs.model.SearchVO;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Mapper("qaTargetBatchMapper")
public interface QaTargetBatchMapper {
	
	/**
	 * 영업일 체크
	 */
	String selectToDate(SearchVO searchVO);
	
	/**
	 * 심사업무 최근일자
	 */
	String selectRecentDate(SearchVO searchVO);
	
	/**
	 * QA대상선정 설정정보 조회
	 */
	List<QaTargetBatchVO> selectList(SearchVO searchVO) throws Exception;
	
	/**
	 * 심사업무 분류 업데이트 처리시 대상 목록
	 */
	List<QaTargetBatchVO> selectRuleSanctionList(SearchVO searchVO) throws Exception;
	
	/**
	 * 심사업무 선정처리
	 */
	void updateQaUser(QaTargetBatchVO vo);
	
	/**
	 * 심사업무 선정처리 초기화
	 */
	void resetQaUser(SearchVO searchVO);
	
	/**
	 * QA배정 로그추가
	 */
	void insertSantionHis(QaTargetBatchVO vo);
	
}