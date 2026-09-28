package com.woori.ajs.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.woori.ajs.dao.CommonLoginMapper;
import com.woori.ajs.model.LoginVO;
import com.woori.ajs.service.CommonLoginService;

import egovframework.rte.fdl.idgnr.EgovIdGnrService;

@Service("commonLoginService")
public class CommonLoginServiceImpl implements CommonLoginService {

	private static final Logger LOGGER = LoggerFactory.getLogger(CommonLoginServiceImpl.class);

	@Resource(name = "commonLoginMapper")
	private CommonLoginMapper commonLoginDAO;

	/** ID Generation */
	@Resource(name = "egovIdGnrService")
	private EgovIdGnrService egovIdGnrService;
	
	@Override
	public List<LoginVO> selectLoginList(LoginVO vo) throws Exception {
		return commonLoginDAO.selectLoginList(vo);
	}
	
	@Override
	public int selectLoginListTotCnt(LoginVO vo) {
		return commonLoginDAO.selectLoginListTotCnt(vo);
	}
	
	@Override
	public String selectLoginTime(LoginVO vo) {
		return commonLoginDAO.selectLoginTime(vo);
	}
	
	@Override
	public LoginVO selectLogin(LoginVO vo) throws Exception {
		return commonLoginDAO.selectLogin(vo);
	}
	
}