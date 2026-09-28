package com.woori.ajs.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.woori.ajs.dao.StatTaskMapper;
import com.woori.ajs.model.SearchVO;
import com.woori.ajs.model.StatTaskVO;
import com.woori.ajs.service.StatTaskService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.fdl.idgnr.EgovIdGnrService;

@Service("StatTaskService")
public class StatTaskServiceImpl extends EgovAbstractServiceImpl implements StatTaskService {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(StatTaskServiceImpl.class);
	
	@Resource(name = "StatTaskMapper")
	private StatTaskMapper StatTaskDAO;
	
	/** ID Generation */
	@Resource(name = "egovIdGnrService")
	private EgovIdGnrService egovIdGnrService;

	@Override
	public List<StatTaskVO> selectList(SearchVO searchVO) throws Exception {
		return StatTaskDAO.selectList(searchVO);
	}

	@Override
	public int selectListTotCnt(SearchVO searchVO) {
		// TODO Auto-generated method stub
		return StatTaskDAO.selectListTotCnt(searchVO);
	}
	
}