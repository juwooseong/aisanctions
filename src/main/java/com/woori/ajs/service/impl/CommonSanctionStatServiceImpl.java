package com.woori.ajs.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.woori.ajs.dao.CommonSanctionStatMapper;
import com.woori.ajs.model.CommonSanctionStatVO;
import com.woori.ajs.model.SearchVO;
import com.woori.ajs.service.CommonSanctionStatService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service("commonSanctionStatService")
public class CommonSanctionStatServiceImpl  extends EgovAbstractServiceImpl implements CommonSanctionStatService {

	private static final Logger LOGGER = LoggerFactory.getLogger(StatCondServiceImpl.class);
	@Resource(name = "commonSanctionStatMapper")
	private CommonSanctionStatMapper dao;
	
	@Override
	public List<CommonSanctionStatVO> selectWatchList() throws Exception {
		return dao.selectWatchList();
	}
	
	@Override
	public List<CommonSanctionStatVO> selectInptMstSrnoList(SearchVO vo) throws Exception {
		return dao.selectInptMstSrnoList(vo);
	}
	
	@Override
	public List<CommonSanctionStatVO> selectSanctionList(SearchVO vo) throws Exception {
		return dao.selectSanctionList(vo);
	}

	@Override
	public List<CommonSanctionStatVO> selectWatchItemList(SearchVO vo) throws Exception {
		return dao.selectWatchItemList(vo);
	}
}
