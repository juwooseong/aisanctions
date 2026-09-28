package com.woori.ajs.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.woori.ajs.dao.AdminReTaskMapper;
import com.woori.ajs.model.AdminReTaskTaskVO;
import com.woori.ajs.model.AdminReTaskUserVO;
import com.woori.ajs.model.SearchVO;
import com.woori.ajs.service.AdminReTaskService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.fdl.idgnr.EgovIdGnrService;

@Service("adminReTaskService")
public class AdminReTaskServiceImpl extends EgovAbstractServiceImpl implements AdminReTaskService {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(AdminReTaskServiceImpl.class);
	
	@Resource(name = "adminReTaskMapper")
	private AdminReTaskMapper adminReTaskDAO;
	
	/** ID Generation */
	@Resource(name = "egovIdGnrService")
	private EgovIdGnrService egovIdGnrService;
	
	/**
	 * 사용자 목록을 조회한다.
	 * 
	 * @param searchVO
	 *            - 조회할 정보가 담긴 VO
	 * @return 글 목록
	 * @exception Exception
	 */
	@Override
	public List<AdminReTaskUserVO> selectUserList(SearchVO searchVO) throws Exception {
		return adminReTaskDAO.selectUserList(searchVO);
	}
	
	/**
	 * 사용자 총 갯수를 조회한다. @param searchVO - 조회할 정보가 담긴 VO @return 글 총 갯수 @exception
	 */
	@Override
	public int selectUserListTotCnt(SearchVO searchVO) {
		return adminReTaskDAO.selectUserListTotCnt(searchVO);
	}

	/**
	 * 업무 목록을 조회한다.
	 * 
	 * @param searchVO
	 *            - 조회할 정보가 담긴 VO
	 * @return 글 목록
	 * @exception Exception
	 */
	@Override
	public List<AdminReTaskTaskVO> selectTaskList(SearchVO searchVO) throws Exception {
		return adminReTaskDAO.selectTaskList(searchVO);
	}
	
	/**
	 * 업무 총 갯수를 조회한다. @param searchVO - 조회할 정보가 담긴 VO @return 글 총 갯수 @exception
	 */
	@Override
	public int selectTaskListTotCnt(SearchVO searchVO) {
		return adminReTaskDAO.selectTaskListTotCnt(searchVO);
	}
	
	/**
	 * 업무재할당 처리
	 */
	@Override
	public void updateReTask(AdminReTaskTaskVO vo) {
		adminReTaskDAO.updateReTask(vo);
	}

	@Override
	public void updateReTaskHistory(AdminReTaskTaskVO vo) {
		adminReTaskDAO.updateReTaskHistory(vo);
	}

	@Override
	public void insertReTaskHistory(AdminReTaskTaskVO vo) {
		adminReTaskDAO.insertReTaskHistory(vo);
	}

	@Override
	public void qaDelete(AdminReTaskTaskVO vo) {
		adminReTaskDAO.qaDelete(vo);
	}

	@Override
	public void updateMaster(AdminReTaskTaskVO vo) {
		adminReTaskDAO.updateMaster(vo);
	}

	@Override
	public void delete1Table(AdminReTaskTaskVO vo) {
		adminReTaskDAO.delete1Table(vo);
	}

	@Override
	public void delete3Table(AdminReTaskTaskVO vo) {
		adminReTaskDAO.delete3Table(vo);
	}

	@Override
	public void delete4Table(AdminReTaskTaskVO vo) {
		adminReTaskDAO.delete4Table(vo);
	}

	@Override
	public void delete5Table(AdminReTaskTaskVO vo) {
		adminReTaskDAO.delete5Table(vo);
	}

	@Override
	public void delete6Table(AdminReTaskTaskVO vo) {
		adminReTaskDAO.delete6Table(vo);
	}

	@Override
	public void delete7Table(AdminReTaskTaskVO vo) {
		adminReTaskDAO.delete7Table(vo);
	}

	@Override
	public void delete8Table(AdminReTaskTaskVO vo) {
		adminReTaskDAO.delete8Table(vo);
	}

	@Override
	public void delete2Table(AdminReTaskTaskVO vo) {
		adminReTaskDAO.delete2Table(vo);
	}
	
}