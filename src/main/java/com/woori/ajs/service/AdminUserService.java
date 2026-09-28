package com.woori.ajs.service;

import java.util.List;

import com.woori.ajs.model.SearchVO;
import com.woori.ajs.model.AdminUserVO;

public interface AdminUserService {

	/**
	 * 글 목록을 조회한다.
	 * @param searchVO - 조회할 정보가 담긴 VO
	 * @return 글 목록
	 * @exception Exception
	 */
	List<AdminUserVO> selectList(SearchVO searchVO) throws Exception;
	List<AdminUserVO>  selectListPop(SearchVO searchVO) throws Exception;
	List<AdminUserVO> selectOne(SearchVO searchVO) throws Exception;
	List<AdminUserVO> selectListConcat(SearchVO searchVO) throws Exception;
	/**
	 * 글 총 갯수를 조회한다.
	 * @param searchVO - 조회할 정보가 담긴 VO
	 * @return 글 총 갯수
	 * @exception
	 */
	int selectListTotCnt(SearchVO searchVO);
	
	void userInsert(AdminUserVO vo);
	/**
	 * 사용자 등록처리.
	 */
	void userUpdate(AdminUserVO vo);

	/**
	 * 사용자 삭제처리.
	 */
	void userDelete(AdminUserVO vo);
	
}