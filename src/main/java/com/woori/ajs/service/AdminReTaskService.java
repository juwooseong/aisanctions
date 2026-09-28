package com.woori.ajs.service;

import java.util.List;

import com.woori.ajs.model.SearchVO;
import com.woori.ajs.model.AdminReTaskTaskVO;
import com.woori.ajs.model.AdminReTaskUserVO;

public interface AdminReTaskService {

	/**
	 * 사용자 목록을 조회한다.
	 * @param searchVO - 조회할 정보가 담긴 VO
	 * @return 글 목록
	 * @exception Exception
	 */
	List<AdminReTaskUserVO> selectUserList(SearchVO searchVO) throws Exception;
	
	/**
	 * 사용자 총 갯수를 조회한다.
	 * @param searchVO - 조회할 정보가 담긴 VO
	 * @return 글 총 갯수
	 * @exception
	 */
	int selectUserListTotCnt(SearchVO searchVO);

	/**
	 * 업무 목록을 조회한다.
	 * @param searchVO - 조회할 정보가 담긴 VO
	 * @return 글 목록
	 * @exception Exception
	 */
	List<AdminReTaskTaskVO> selectTaskList(SearchVO searchVO) throws Exception;
	
	/**
	 * 업무 총 갯수를 조회한다.
	 * @param searchVO - 조회할 정보가 담긴 VO
	 * @return 글 총 갯수
	 * @exception
	 */
	int selectTaskListTotCnt(SearchVO searchVO);

	/**
	 * 업무재할당 처리
	 */
	void updateReTask(AdminReTaskTaskVO vo);

	void updateReTaskHistory(AdminReTaskTaskVO vo);
	
	void insertReTaskHistory(AdminReTaskTaskVO vo);
	void qaDelete(AdminReTaskTaskVO vo);
	void updateMaster(AdminReTaskTaskVO vo);
	
	void delete1Table(AdminReTaskTaskVO vo);
	void delete2Table(AdminReTaskTaskVO vo);
	void delete3Table(AdminReTaskTaskVO vo);
	void delete4Table(AdminReTaskTaskVO vo);
	void delete5Table(AdminReTaskTaskVO vo);
	void delete6Table(AdminReTaskTaskVO vo);
	void delete7Table(AdminReTaskTaskVO vo);
	void delete8Table(AdminReTaskTaskVO vo);
}