package com.woori.ajs.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.woori.ajs.dao.AdminAbsenceMapper;
import com.woori.ajs.model.SearchVO;
import com.woori.ajs.model.AdminAbsenceVO;
import com.woori.ajs.service.AdminAbsenceService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.fdl.idgnr.EgovIdGnrService;

@Service("AdminAbsenceService")
public class AdminAbsenceServiceImpl extends EgovAbstractServiceImpl implements AdminAbsenceService {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(AdminAbsenceServiceImpl.class);
	
	@Resource(name = "AdminAbsenceMapper")
	private AdminAbsenceMapper AdminAbsenceDAO;
	
	/** ID Generation */
	@Resource(name = "egovIdGnrService")
	private EgovIdGnrService egovIdGnrService;
	
	/**
	 * 글 목록을 조회한다.
	 * 
	 * @param searchVO
	 *            - 조회할 정보가 담긴 VO
	 * @return 글 목록
	 * @exception Exception
	 */
	@Override
	public List<AdminAbsenceVO> selectList(SearchVO searchVO) throws Exception {
		return AdminAbsenceDAO.selectList(searchVO);
	}
	
	/**
	 * 글 총 갯수를 조회한다. @param searchVO - 조회할 정보가 담긴 VO @return 글 총 갯수 @exception
	 */
	@Override
	public int selectListTotCnt(SearchVO searchVO) {
		return AdminAbsenceDAO.selectListTotCnt(searchVO);
	}

	/**
	 * 부재여부 업데이트
	 */
	@Override
	public void existUpdate(AdminAbsenceVO vo) {
		AdminAbsenceDAO.existUpdate(vo);
	}

}