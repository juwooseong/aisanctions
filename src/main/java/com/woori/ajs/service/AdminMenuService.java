package com.woori.ajs.service;

import java.util.List;

import com.woori.ajs.model.SearchVO;
import com.woori.ajs.model.AdminMenuVO;
import com.woori.ajs.model.AdminScreenVO;

public interface AdminMenuService {

	/**
	 * 글 목록을 조회한다.
	 * @param searchVO - 조회할 정보가 담긴 VO
	 * @return 글 목록
	 * @exception Exception
	 */
	List<AdminMenuVO> selectList(SearchVO searchVO) throws Exception;

	/**
	 * 글 총 갯수를 조회한다.
	 * @param searchVO - 조회할 정보가 담긴 VO
	 * @return 글 총 갯수
	 * @exception
	 */
	int selectListTotCnt(SearchVO searchVO);

	/**
	 * 화면 목록을 조회한다.
	 * @param searchVO - 조회할 정보가 담긴 VO
	 * @return 글 목록
	 * @exception Exception
	 */
	List<AdminScreenVO> selectScreenList(SearchVO searchVO) throws Exception;
	void screenUseUpdate(AdminScreenVO vo) throws Exception;
	List<AdminMenuVO> selectListTopMenu() throws Exception;
	List<AdminMenuVO> selectListForRegMenu(SearchVO searchVO) throws Exception;
	String selectOneHg(SearchVO searchVO) throws Exception; 
	String selectOneScreenName(SearchVO searchVO) throws Exception; 	
	void regMenu(AdminMenuVO vo) throws Exception;
	void modiMenu(AdminMenuVO vo) throws Exception;
	String checkScreenNoForUpdate(AdminMenuVO vo) throws Exception;
	List<AdminMenuVO> checkMenuId(AdminMenuVO vo) throws Exception;
	List<AdminMenuVO> checkScreenNo(AdminMenuVO vo) throws Exception;	
	void insertAutAdmin(AdminMenuVO vo) throws Exception;
	void insertAutAll(AdminMenuVO vo) throws Exception;
	void deleteMenu(SearchVO searchVO) throws Exception; 	
	void deleteMenuAuth(SearchVO searchVO) throws Exception; 	 
}