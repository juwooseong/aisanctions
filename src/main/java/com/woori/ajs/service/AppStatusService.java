package com.woori.ajs.service;

import java.util.List;

import com.woori.ajs.model.SearchVO;
import com.woori.ajs.model.AppStatusVO;
import com.woori.ajs.model.AppTodoVO;

public interface AppStatusService {

	/**
	 * 글 목록을 조회한다.
	 * @param searchVO - 조회할 정보가 담긴 VO
	 * @return 글 목록
	 * @exception Exception
	 */
	List<AppStatusVO> selectList(SearchVO searchVO) throws Exception;

	/**
	 * 글 총 갯수를 조회한다.
	 * @param searchVO - 조회할 정보가 담긴 VO
	 * @return 글 총 갯수
	 * @exception
	 */
	int selectListTotCnt(SearchVO searchVO);

	/**
	 * 심사상세정보
	 */
	AppTodoVO selectTaskInfo(SearchVO searchVO);
	
	/**
	 * 심사업무 상태를 holding 상태로 변경처리.
	 * 처리성공건수 반환.
	 */
	int updateTaskAtvtHolding(SearchVO searchVO) throws Exception;
	
}