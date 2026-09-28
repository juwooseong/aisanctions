package com.woori.ajs.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.woori.ajs.dao.AdminNationMapper;
import com.woori.ajs.model.SearchVO;
import com.woori.ajs.model.AdminNationVO;
import com.woori.ajs.service.AdminNationService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.fdl.idgnr.EgovIdGnrService;

@Service("adminNationService")
public class AdminNationServiceImpl extends EgovAbstractServiceImpl implements AdminNationService {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(AdminNationServiceImpl.class);
	
	@Resource(name = "adminNationMapper")
	private AdminNationMapper adminNationDAO;
	
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
	public List<AdminNationVO> selectList(SearchVO searchVO) throws Exception {
		return adminNationDAO.selectList(searchVO);
	}
	
	/**
	 * 글 총 갯수를 조회한다. @param searchVO - 조회할 정보가 담긴 VO @return 글 총 갯수 @exception
	 */
	@Override
	public int selectListTotCnt(SearchVO searchVO) {
		return adminNationDAO.selectListTotCnt(searchVO);
	}
	
	@Override
	public void insert(AdminNationVO vo) {
		adminNationDAO.insert(vo);
	}

	@Override
	public void delete(AdminNationVO vo) {
		adminNationDAO.delete(vo);
	}
	
	@Override
	public void updateInitRprsCdYn(AdminNationVO vo) {
		adminNationDAO.updateInitRprsCdYn(vo);
	}

	@Override
	public AdminNationVO selectOne(SearchVO searchVO) throws Exception {
		// TODO Auto-generated method stub
		return adminNationDAO.selectOne(searchVO);
	}

}