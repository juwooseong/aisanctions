package com.woori.ajs.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.woori.ajs.dao.CaMapper;
import com.woori.ajs.model.CaVO;
import com.woori.ajs.model.SearchVO;
import com.woori.ajs.service.CaService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.fdl.idgnr.EgovIdGnrService;

@Service("caService")
public class CaServiceImpl extends EgovAbstractServiceImpl implements CaService {

	private static final Logger LOGGER = LoggerFactory.getLogger(CaServiceImpl.class);
	
	@Resource(name = "caMapper")
	private CaMapper dao;
	
	/** ID Generation */
	@Resource(name = "egovIdGnrService")
	private EgovIdGnrService egovIdGnrService;

	@Override
	public List<CaVO> selectSancRst(SearchVO vo) throws Exception {
		return dao.selectSancRst(vo);
	}
	
	@Override
	public List<CaVO> selectSancAnswer(SearchVO vo) throws Exception {
		return dao.selectSancAnswer(vo);
	}
}