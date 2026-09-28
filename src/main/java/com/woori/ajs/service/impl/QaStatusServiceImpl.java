package com.woori.ajs.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.woori.ajs.dao.QaStatusMapper;
import com.woori.ajs.model.SearchVO;
import com.woori.ajs.model.QaStatusVO;
import com.woori.ajs.service.QaStatusService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.fdl.idgnr.EgovIdGnrService;

@Service("qaStatusService")
public class QaStatusServiceImpl extends EgovAbstractServiceImpl implements QaStatusService{
	private static final Logger LOGGER = LoggerFactory.getLogger(QaStatusServiceImpl.class); 
	
	@Resource(name="qaStatusMapper")
	private QaStatusMapper qaStatusDAO;
	
	@Resource(name="egovIdGnrService")
	private EgovIdGnrService egovIdGnrService;

	@Override
	public QaStatusVO selectInfo(SearchVO vo) throws Exception {
		QaStatusVO resultVO = qaStatusDAO.selectInfo(vo);
		return resultVO;
	}

	@Override
	public List<QaStatusVO> selectList(SearchVO searchVO) throws Exception {
		return qaStatusDAO.selectList(searchVO);
	}

	@Override
	public int selectListTotCnt(SearchVO searchVO) {
		return qaStatusDAO.selectListTotCnt(searchVO);
	}

	@Override
	public String checkDate(SearchVO searchVO) {
		// TODO Auto-generated method stub
		return qaStatusDAO.checkDate(searchVO);
	}
}