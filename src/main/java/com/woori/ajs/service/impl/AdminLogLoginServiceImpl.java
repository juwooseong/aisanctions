package com.woori.ajs.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.woori.ajs.dao.AdminLogLoginMapper;
import com.woori.ajs.model.SearchVO;
import com.woori.ajs.model.AdminLogLoginVO;
import com.woori.ajs.service.AdminLogLoginService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.fdl.idgnr.EgovIdGnrService;

@Service("adminLogLoginService")
public class AdminLogLoginServiceImpl extends EgovAbstractServiceImpl implements AdminLogLoginService {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(AdminLogLoginServiceImpl.class);
	
	@Resource(name = "adminLogLoginMapper")
	private AdminLogLoginMapper adminLogLoginDAO;
	
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
	public List<AdminLogLoginVO> selectList(SearchVO searchVO) throws Exception {
		return adminLogLoginDAO.selectList(searchVO);
	}
	
	/**
	 * 글 총 갯수를 조회한다. @param searchVO - 조회할 정보가 담긴 VO @return 글 총 갯수 @exception
	 */
	@Override
	public int selectListTotCnt(SearchVO searchVO) {
		return adminLogLoginDAO.selectListTotCnt(searchVO);
	}

	@Override
	public void insert(AdminLogLoginVO vo) {
		adminLogLoginDAO.insert(vo);
	}

}