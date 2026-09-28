package com.woori.ajs.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.woori.ajs.dao.CommonCodeMapper;
import com.woori.ajs.model.CommonCodeVO;
import com.woori.ajs.model.SearchVO;
import com.woori.ajs.service.CommonCodeService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.fdl.idgnr.EgovIdGnrService;

@Service("commonCodeService")
public class CommonCodeServiceImpl extends EgovAbstractServiceImpl implements CommonCodeService {

	private static final Logger LOGGER = LoggerFactory.getLogger(CommonCodeServiceImpl.class);
	
	@Resource(name = "commonCodeMapper")
	private CommonCodeMapper dao;
	
	/** ID Generation */
	@Resource(name = "egovIdGnrService")
	private EgovIdGnrService egovIdGnrService;
	
	@Override
	public List<CommonCodeVO> selectAllCommonCodeList(SearchVO vo) throws Exception {
		return dao.selectAllCommonCodeList(vo);
	}

}