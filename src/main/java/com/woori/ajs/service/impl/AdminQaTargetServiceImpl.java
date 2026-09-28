package com.woori.ajs.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.woori.ajs.dao.AdminQaTargetMapper;
import com.woori.ajs.model.AdminQaTargetVO;
import com.woori.ajs.model.SearchVO;
import com.woori.ajs.service.AdminQaTargetService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.fdl.idgnr.EgovIdGnrService;

@Service("adminQaTargetService")
public class AdminQaTargetServiceImpl extends EgovAbstractServiceImpl implements AdminQaTargetService {

	private static final Logger LOGGER = LoggerFactory.getLogger(AdminQaTargetServiceImpl.class);
	
	@Resource(name = "adminQaTargetMapper")
	private AdminQaTargetMapper adminQaTargetDAO;
	
	/** ID Generation */
	@Resource(name = "egovIdGnrService")
	private EgovIdGnrService egovIdGnrService;

	@Override
	public AdminQaTargetVO selectQaExTarget(AdminQaTargetVO search) throws Exception {
		return adminQaTargetDAO.selectQaExTarget(search);
	}
	
	@Override
	public void insert(AdminQaTargetVO search) throws Exception {
		adminQaTargetDAO.insert(search);
	}
	
	@Override
	public List<AdminQaTargetVO> selectList(SearchVO search) throws Exception {
		return adminQaTargetDAO.selectList(search);
	}
	
}
