package com.woori.ajs.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.woori.ajs.dao.AdminCityMapper;
import com.woori.ajs.model.SearchVO;
import com.woori.ajs.model.AdminCityVO;
import com.woori.ajs.service.AdminCityService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.fdl.idgnr.EgovIdGnrService;

@Service("AdminCityService")
public class AdminCityServiceImpl extends EgovAbstractServiceImpl implements AdminCityService {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(AdminCityServiceImpl.class);
	
	@Resource(name = "AdminCityMapper")
	private AdminCityMapper AdminCityDAO;
	
	/** ID Generation */
	@Resource(name = "egovIdGnrService")
	private EgovIdGnrService egovIdGnrService;
	
	@Override
	public List<AdminCityVO> selectList(SearchVO searchVO) throws Exception {
		return AdminCityDAO.selectList(searchVO);
	}

	@Override
	public int selectListTotCnt(SearchVO searchVO) {
		return AdminCityDAO.selectListTotCnt(searchVO);
	}

	@Override
	public void insert(AdminCityVO vo) {
		AdminCityDAO.insert(vo);
		
	}

	@Override
	public void delete(AdminCityVO vo) {
		AdminCityDAO.delete(vo);
		
	}

}