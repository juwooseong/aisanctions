package com.woori.ajs.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.woori.ajs.dao.AdminUserMapper;
import com.woori.ajs.model.AdminUserVO;
import com.woori.ajs.model.SearchVO;
import com.woori.ajs.service.AdminUserService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.fdl.idgnr.EgovIdGnrService;

@Service("adminUserService")
public class AdminUserServiceImpl extends EgovAbstractServiceImpl implements AdminUserService {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(AdminUserServiceImpl.class);
	
	@Resource(name = "adminUserMapper")
	private AdminUserMapper adminUserDAO;
	
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
	public List<AdminUserVO> selectList(SearchVO searchVO) throws Exception {
		return adminUserDAO.selectList(searchVO);
	}
	
	@Override
	public List<AdminUserVO> selectOne(SearchVO searchVO) throws Exception {
		return adminUserDAO.selectOne(searchVO);
	}
	
	/**
	 * 글 총 갯수를 조회한다. @param searchVO - 조회할 정보가 담긴 VO @return 글 총 갯수 @exception
	 */
	@Override
	public int selectListTotCnt(SearchVO searchVO) {
		return adminUserDAO.selectListTotCnt(searchVO);
	}

	@Override
	public void userUpdate(AdminUserVO vo) {
		adminUserDAO.userUpdate(vo);
	}

	@Override
	public void userDelete(AdminUserVO vo) {
		adminUserDAO.userDelete(vo);
	}

	@Override
	public List<AdminUserVO> selectListConcat(SearchVO searchVO) throws Exception {
		// TODO Auto-generated method stub
		return adminUserDAO.selectListConcat(searchVO);
	}

	@Override
	public List<AdminUserVO> selectListPop(SearchVO searchVO) throws Exception {
		// TODO Auto-generated method stub
		return adminUserDAO.selectListPop(searchVO);
	}

	@Override
	public void userInsert(AdminUserVO vo) {
		adminUserDAO.userInsert(vo);
		
	}

}