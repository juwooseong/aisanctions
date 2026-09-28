package com.woori.ajs.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.woori.ajs.dao.AdminAppMemoMapper;
import com.woori.ajs.model.SearchVO;
import com.woori.ajs.model.AdminAppMemoVO;
import com.woori.ajs.service.AdminAppMemoService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.fdl.idgnr.EgovIdGnrService;

@Service("AdminAppMemoService")
public class AdminAppMemoServiceImpl extends EgovAbstractServiceImpl implements AdminAppMemoService {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(AdminAppMemoServiceImpl.class);
	
	@Resource(name = "AdminAppMemoMapper")
	private AdminAppMemoMapper AdminAppMemoDAO;
	
	/** ID Generation */
	@Resource(name = "egovIdGnrService")
	private EgovIdGnrService egovIdGnrService;
	
	/**
	 * 글 목록을 조회한다.
	 * 
	 * @param searchVO
	 *            - 조회할 정보가 담긴 VO
	 * @return 글 목록
	 * @exception Exception
	 */
	@Override
	public List<AdminAppMemoVO> selectList(SearchVO searchVO) throws Exception {
		return AdminAppMemoDAO.selectList(searchVO);
	}
	
	@Override
	public void insertMemo(AdminAppMemoVO vo) {
		AdminAppMemoDAO.insertMemo(vo);
	}
	
	@Override
	public void deleteMemo(AdminAppMemoVO vo) {
		AdminAppMemoDAO.deleteMemo(vo);
	}

}