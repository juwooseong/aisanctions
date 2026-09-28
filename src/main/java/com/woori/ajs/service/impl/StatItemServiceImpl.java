package com.woori.ajs.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.woori.ajs.dao.StatItemMapper;
import com.woori.ajs.model.SearchVO;
import com.woori.ajs.model.StatItemVO;
import com.woori.ajs.service.StatItemService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.fdl.idgnr.EgovIdGnrService;

@Service("StatItemService")
public class StatItemServiceImpl extends EgovAbstractServiceImpl implements StatItemService {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(StatItemServiceImpl.class);
	
	@Resource(name = "StatItemMapper")
	private StatItemMapper StatItemDAO;
	
	/** ID Generation */
	@Resource(name = "egovIdGnrService")
	private EgovIdGnrService egovIdGnrService;

	@Override
	public List<StatItemVO> selectList(SearchVO searchVO) throws Exception {
		return StatItemDAO.selectList(searchVO);
	}

	@Override
	public List<StatItemVO> selectMoveList(SearchVO searchVO) throws Exception {
		return StatItemDAO.selectMoveList(searchVO);
	}
	
}