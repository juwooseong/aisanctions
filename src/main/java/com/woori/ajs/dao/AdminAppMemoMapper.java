package com.woori.ajs.dao;

import java.util.List;

import com.woori.ajs.model.SearchVO;
import com.woori.ajs.model.AdminAppMemoVO;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Mapper("AdminAppMemoMapper")
public interface AdminAppMemoMapper {
	
	/**
	 * 글 목록을 조회한다.
	 * @param searchVO - 조회할 정보가 담긴 VO
	 * @return 글 목록
	 * @exception Exception
	 */
	List<AdminAppMemoVO> selectList(SearchVO searchVO) throws Exception;
	
	void insertMemo(AdminAppMemoVO vo);
	
	void deleteMemo(AdminAppMemoVO vo);
	
}