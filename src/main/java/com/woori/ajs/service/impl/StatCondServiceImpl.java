package com.woori.ajs.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.woori.ajs.dao.StatCondMapper;
import com.woori.ajs.model.SearchVO;
import com.woori.ajs.model.StatCondVO;
import com.woori.ajs.service.StatCondService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.fdl.idgnr.EgovIdGnrService;

@Service("StatCondService")
public class StatCondServiceImpl extends EgovAbstractServiceImpl implements StatCondService {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(StatCondServiceImpl.class);
	
	@Resource(name = "StatCondMapper")
	private StatCondMapper StatCondDAO;
	
	/** ID Generation */
	@Resource(name = "egovIdGnrService")
	private EgovIdGnrService egovIdGnrService;

	@Override
	public List<StatCondVO> selectList(SearchVO vo) throws Exception {
		return StatCondDAO.selectList(vo);
	}

	@Override
	public int selectListTotCnt(SearchVO vo) {
		return StatCondDAO.selectListTotCnt(vo);
	}
	
}