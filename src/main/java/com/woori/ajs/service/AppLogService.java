package com.woori.ajs.service;

import java.util.List;

import com.woori.ajs.model.AppLogVO;
import com.woori.ajs.model.SearchVO;

public interface AppLogService {

	/**
	 * 글 목록을 조회한다.
	 * @param searchVO - 조회할 정보가 담긴 VO
	 * @return 글 목록
	 * @exception Exception
	 */
	List<AppLogVO> selectList(SearchVO searchVO) throws Exception;

	/**
	 * 글 총 갯수를 조회한다.
	 * @param searchVO - 조회할 정보가 담긴 VO
	 * @return 글 총 갯수
	 * @exception
	 */
	int selectListTotCnt(SearchVO searchVO);

	/**
	 * 승인을 처리한다.
	 * @param searchVO - 승인할 정보
	 * @return 
	 * @exception
	 */
	void updateApprove(AppLogVO vo);
	
}