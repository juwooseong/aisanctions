package com.woori.ajs.dao;

import java.util.List;

import com.woori.ajs.model.SearchVO;
import com.woori.ajs.model.AdminAbsenceVO;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Mapper("AdminAbsenceMapper")
public interface AdminAbsenceMapper {
	
	/**
	 * 글 목록을 조회한다.
	 * @param searchVO - 조회할 정보가 담긴 VO
	 * @return 글 목록
	 * @exception Exception
	 */
	List<AdminAbsenceVO> selectList(SearchVO searchVO) throws Exception;
	
	/**
	 * 글 총 갯수를 조회한다.
	 * @param searchVO - 조회할 정보가 담긴 VO
	 * @return 글 총 갯수
	 * @exception
	 */
	int selectListTotCnt(SearchVO searchVO);

	/**
	 * 부재여부 업데이트
	 */
	void existUpdate(AdminAbsenceVO vo);

}