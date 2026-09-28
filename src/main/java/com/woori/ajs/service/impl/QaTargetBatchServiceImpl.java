package com.woori.ajs.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.woori.ajs.dao.QaTargetBatchMapper;
import com.woori.ajs.model.QaTargetBatchVO;
import com.woori.ajs.model.SearchVO;
import com.woori.ajs.service.QaTargetBatchService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.fdl.idgnr.EgovIdGnrService;

@Service("qaTargetBatchService")
public class QaTargetBatchServiceImpl extends EgovAbstractServiceImpl implements QaTargetBatchService {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(QaTargetBatchServiceImpl.class);
	
	@Resource(name = "qaTargetBatchMapper")
	private QaTargetBatchMapper qaTargetBatchDAO;
	
	/** ID Generation */
	@Resource(name = "egovIdGnrService")
	private EgovIdGnrService egovIdGnrService;
	
	/**
	 * 영업일 체크
	 */
	@Override
	public String selectToDate(SearchVO searchVO) {
		return qaTargetBatchDAO.selectToDate(searchVO);
	}
	
	/**
	 * 심사업무 최근일자
	 */
	@Override
	public String selectRecentDate(SearchVO searchVO) {
		return qaTargetBatchDAO.selectRecentDate(searchVO);
	}
	
	/**
	 * QA대상선정 설정정보 조회
	 */
	@Override
	public List<QaTargetBatchVO> selectList(SearchVO searchVO) throws Exception {
		return qaTargetBatchDAO.selectList(searchVO);
	}

	/**
	 * 심사업무 분류 업데이트 처리시 대상 목록
	 */
	@Override
	public List<QaTargetBatchVO> selectRuleSanctionList(SearchVO searchVO) throws Exception {
		return qaTargetBatchDAO.selectRuleSanctionList(searchVO);
	}
	
	/**
	 * 심사업무 선정처리
	 */
	@Override
	public void updateQaUser(QaTargetBatchVO vo) {
		qaTargetBatchDAO.updateQaUser(vo);
	}
	
	/**
	 * 심사업무 선정처리 초기화
	 */
	@Override
	public void resetQaUser(SearchVO searchVO) {
		qaTargetBatchDAO.resetQaUser(searchVO);
	}
	
	/**
	 * QA배정 로그추가
	 */
	@Override
	public void insertSantionHis(QaTargetBatchVO vo) {
		qaTargetBatchDAO.insertSantionHis(vo);
	}
	
}