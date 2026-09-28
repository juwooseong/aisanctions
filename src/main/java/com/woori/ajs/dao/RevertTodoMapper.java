package com.woori.ajs.dao;

import java.util.List;

import com.woori.ajs.model.SearchVO;
import com.woori.ajs.model.ReverTodoVO;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Mapper("revertTodoMapper")
public interface RevertTodoMapper {
	
	/**
	 * 글 목록을 조회한다.
	 * @param searchVO - 조회할 정보가 담긴 VO
	 * @return 글 목록
	 * @exception Exception
	 */
	List<ReverTodoVO> selectList(SearchVO searchVO) throws Exception;

	/**
	 * 글 총 갯수를 조회한다.
	 * @param searchVO - 조회할 정보가 담긴 VO
	 * @return 글 총 갯수
	 * @exception
	 */ 
	int selectListTotCnt(SearchVO searchVO);

}