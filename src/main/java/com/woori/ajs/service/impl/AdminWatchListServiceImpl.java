package com.woori.ajs.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.woori.ajs.dao.AdminWatchListMapper;
import com.woori.ajs.model.SearchVO;
import com.woori.ajs.model.WatchListVO;
import com.woori.ajs.service.AdminWatchListService;

@Service("adminWatchListService")
public class AdminWatchListServiceImpl implements AdminWatchListService {

	private static final Logger LOGGER = LoggerFactory.getLogger(AdminWatchListServiceImpl.class);
	
	@Resource(name = "adminWatchListMapper")
	private AdminWatchListMapper adminWatchListDAO;
	
	/**
	 * 카테고리 목록을 조회한다.
	 * 
	 * @param 
	 * @return 카테고리 목록
	 * @exception Exception
	 */
	@Override
	public List<WatchListVO> selectCtgrList(SearchVO searchVO) throws Exception {
		return adminWatchListDAO.selectCtgrList(searchVO);
	}

	/**
	 * 카테고리 상세정보을 조회한다.
	 * @param 
	 * @return 
	 * @exception Exception
	 */
	@Override
	public WatchListVO selectCtgr(SearchVO searchVO) throws Exception {
		return adminWatchListDAO.selectCtgr(searchVO);
	}

	/**
	 * 리스트 목록을 조회한다.
	 * @param 
	 * @return 
	 * @exception Exception
	 */
	@Override
	public List<WatchListVO> selectGrpList(SearchVO searchVO) throws Exception {
		return adminWatchListDAO.selectGrpList(searchVO);
	}

	/**
	 * 리스트 상세정보을 조회한다.
	 * @param 
	 * @return 
	 * @exception Exception
	 */
	@Override
	public WatchListVO selectGrp(SearchVO searchVO) throws Exception {
		return adminWatchListDAO.selectGrp(searchVO);
	}

	/**
	 * 리스트 목록을 조회한다.
	 * @param 
	 * @return 
	 * @exception Exception
	 */
	@Override
	public List<WatchListVO> selectContList(SearchVO searchVO) throws Exception {
		return adminWatchListDAO.selectContList(searchVO);
	}

	/**
	 * 리스트 상세정보을 조회한다.
	 * @param 
	 * @return 
	 * @exception Exception
	 */
	@Override
	public WatchListVO selectCont(SearchVO searchVO) throws Exception {
		return adminWatchListDAO.selectCont(searchVO);
	}
	
	/**
	 * 카테고리 정보 등록/수정
	 */
	@Override
	public void insertCtgr(WatchListVO vO) throws Exception {
		adminWatchListDAO.insertCtgr(vO);
	}

	/**
	 * 카테고리 신규코드 생성
	 */
	@Override
	public String selectNewCtgrCd() throws Exception {
		return adminWatchListDAO.selectNewCtgrCd();
	}
	
	/**
	 * 카테고리 정보 삭제
	 */
	@Override
	public void deleteCtgr(WatchListVO vo) throws Exception {
		adminWatchListDAO.deleteCtgr(vo);
		adminWatchListDAO.insertDateCtgFordelete(vo);
	}

	/**
	 * 리스트 정보 등록/수정
	 */
	@Override
	public void insertGrp(WatchListVO vO) throws Exception {
		adminWatchListDAO.insertGrp(vO);
	}

	/**
	 * 리스트 신규코드 생성
	 */
	@Override
	public String selectNewGrpCd() throws Exception {
		return adminWatchListDAO.selectNewGrpCd();
	}
	
	/**
	 * 리스트 정보 삭제
	 */
	@Override
	public void deleteGrp(WatchListVO vo) throws Exception {
		adminWatchListDAO.deleteGrp(vo);
		adminWatchListDAO.insertDateGrpFordelete(vo);
	}
	
	/**
	 * 내용 정보 등록/수정
	 */
	@Override
	public void insertCont(WatchListVO vO) throws Exception {
		adminWatchListDAO.insertCont(vO);
	}

	/**
	 * 내용 신규코드 생성
	 */
	@Override
	public String selectNewContCd() throws Exception {
		return adminWatchListDAO.selectNewContCd();
	}
	
	/**
	 * 내용 정보 삭제
	 */
	@Override
	public void deleteCont(WatchListVO vo) throws Exception {
		adminWatchListDAO.deleteCont(vo);
		adminWatchListDAO.insertDateContFordelete(vo);
	}
	
}