package com.woori.ajs.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.woori.ajs.dao.AdminMenuMapper;
import com.woori.ajs.model.AdminMenuVO;
import com.woori.ajs.model.AdminScreenVO;
import com.woori.ajs.model.SearchVO;
import com.woori.ajs.service.AdminMenuService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.fdl.idgnr.EgovIdGnrService;

@Service("adminMenuService")
public class AdminMenuServiceImpl extends EgovAbstractServiceImpl implements AdminMenuService {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(AdminMenuServiceImpl.class);
	
	@Resource(name = "adminMenuMapper")
	private AdminMenuMapper adminMenuDAO;
	
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
	public List<AdminMenuVO> selectList(SearchVO searchVO) throws Exception {
		return adminMenuDAO.selectList(searchVO);
	}
	
	/**
	 * 글 총 갯수를 조회한다. @param searchVO - 조회할 정보가 담긴 VO @return 글 총 갯수 @exception
	 */
	@Override
	public int selectListTotCnt(SearchVO searchVO) {
		return adminMenuDAO.selectListTotCnt(searchVO);
	}
	
	/**
	 * 화면 목록을 조회한다.
	 * @param searchVO - 조회할 정보가 담긴 VO
	 * @return 글 목록
	 * @exception Exception
	 */
	public List<AdminScreenVO> selectScreenList(SearchVO searchVO) throws Exception {
		return adminMenuDAO.selectScreenList(searchVO);
	}

	@Override
	public void screenUseUpdate(AdminScreenVO vo) throws Exception {
		// TODO Auto-generated method stub
		adminMenuDAO.screenUseUpdate(vo);
		return;
	}

	@Override
	public List<AdminMenuVO> selectListTopMenu() throws Exception {
		return adminMenuDAO.selectListTopMenu();
	}

	@Override
	public List<AdminMenuVO> selectListForRegMenu(SearchVO searchVO) throws Exception {
		return adminMenuDAO.selectListForRegMenu(searchVO);
	}

	@Override
	public String selectOneHg(SearchVO searchVO) throws Exception {
		// TODO Auto-generated method stub
		return adminMenuDAO.selectOneHg(searchVO);
	}

	@Override
	public void regMenu(AdminMenuVO vo) throws Exception {
		adminMenuDAO.regMenu(vo);
		
	}

	@Override
	public String selectOneScreenName(SearchVO searchVO) throws Exception {
		// TODO Auto-generated method stub
		return adminMenuDAO.selectOneScreenName(searchVO);
	}

	@Override
	public List<AdminMenuVO> checkMenuId(AdminMenuVO vo) throws Exception {
		// TODO Auto-generated method stub
		return adminMenuDAO.checkMenuId(vo);
	}

	@Override
	public List<AdminMenuVO> checkScreenNo(AdminMenuVO vo) throws Exception {
		return adminMenuDAO.checkScreenNo(vo);
	}

	@Override
	public void modiMenu(AdminMenuVO vo) throws Exception {
		adminMenuDAO.modiMenu(vo);
	}

	@Override
	public String checkScreenNoForUpdate(AdminMenuVO vo) throws Exception {
		return adminMenuDAO.checkScreenNoForUpdate(vo);
	}

	@Override
	public void insertAutAdmin(AdminMenuVO vo) throws Exception {
		adminMenuDAO.insertAutAdmin(vo);
	}

	@Override
	public void insertAutAll(AdminMenuVO vo) throws Exception {
		adminMenuDAO.insertAutAll(vo);
	}

	@Override
	public void deleteMenu(SearchVO searchVO) throws Exception {
		adminMenuDAO.deleteMenu(searchVO);
	}
	@Override
	public void deleteMenuAuth(SearchVO searchVO) throws Exception {
		adminMenuDAO.deleteMenuAuth(searchVO);
	}
	
}