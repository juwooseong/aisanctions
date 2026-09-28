package com.woori.ajs.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.woori.ajs.dao.StatUserMapper;
import com.woori.ajs.model.SearchVO;
import com.woori.ajs.model.StatUserVO;
import com.woori.ajs.service.StatUserService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.fdl.idgnr.EgovIdGnrService;

@Service("StatUserService")
public class StatUserServiceImpl extends EgovAbstractServiceImpl implements StatUserService {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(StatUserServiceImpl.class);
	
	@Resource(name = "StatUserMapper")
	private StatUserMapper StatUserDAO;
	
	/** ID Generation */
	@Resource(name = "egovIdGnrService")
	private EgovIdGnrService egovIdGnrService;

	@Override
	public List<StatUserVO> select1List(SearchVO searchVO) throws Exception {
		return StatUserDAO.select1List(searchVO);
	}

	@Override
	public List<StatUserVO> select2List(SearchVO searchVO) throws Exception {
		return StatUserDAO.select2List(searchVO);
	}
	
	@Override
	public List<StatUserVO> selectChartList(SearchVO searchVO) throws Exception{
		return StatUserDAO.selectChartList(searchVO);
	}

	@Override
	public List<StatUserVO> selectChartList2(SearchVO searchVO) throws Exception{
		return StatUserDAO.selectChartList2(searchVO);
	}

	@Override
	public List<StatUserVO> selectChartList3(SearchVO searchVO) throws Exception{
		return StatUserDAO.selectChartList3(searchVO);
	}
	
}