package com.woori.ajs.service;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import com.woori.ajs.model.AdminLogProgramVO;
import com.woori.ajs.model.SearchVO;

public interface AdminLogProgramService {

	/**
	 * 글 목록을 조회한다.
	 * @param searchVO - 조회할 정보가 담긴 VO
	 * @return 글 목록
	 * @exception Exception
	 */
	List<AdminLogProgramVO> selectList(SearchVO searchVO) throws Exception;

	/**
	 * 글 총 갯수를 조회한다.
	 * @param searchVO - 조회할 정보가 담긴 VO
	 * @return 글 총 갯수
	 * @exception
	 */
	int selectListTotCnt(SearchVO searchVO);
	
	String selectTrnLogSrno(SearchVO searchVO);
	
	void insert(AdminLogProgramVO vo);
	
	String logProgramInsert(HttpServletRequest request, AdminLogProgramVO vo, SearchVO searchVO); 

	String selectCheckActionCodeUsingYN(String value);
	
	// QUERY TEST
	List<Map<String, Object>> customQueryTest(SearchVO searchVO);
}