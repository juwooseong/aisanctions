package com.woori.ajs.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.woori.ajs.dao.StatAnalysisMapper;
import com.woori.ajs.model.SearchVO;
import com.woori.ajs.model.StatAnalysisVO;
import com.woori.ajs.service.StatAnalysisService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.fdl.idgnr.EgovIdGnrService;

@Service("statAnalysisService")
public class StatAnalysisServiceImpl extends EgovAbstractServiceImpl implements StatAnalysisService{
	
	private static final Logger LOGGER = LoggerFactory.getLogger(StatAnalysisServiceImpl.class);
	
	@Resource(name = "statAnalysisMapper")
	private StatAnalysisMapper statAnalysisDAO;
	
	/** ID Generation */
	@Resource(name = "egovIdGnrService")
	private EgovIdGnrService egovIdGnrService;

	@Override
	public List<StatAnalysisVO> selectList(SearchVO searchVO) throws Exception {
		return statAnalysisDAO.selectList(searchVO);
	}

	@Override
	public int selectListTotCnt(SearchVO searchVO) {
		return statAnalysisDAO.selectListTotCnt(searchVO);
	}
	
}