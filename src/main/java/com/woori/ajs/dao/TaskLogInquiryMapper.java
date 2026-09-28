package com.woori.ajs.dao;

import java.util.List;

import com.woori.ajs.model.SearchVO;
import com.woori.ajs.model.TaskLogInquiryVO;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Mapper("taskLogInquiryMapper")
public interface TaskLogInquiryMapper {
	
	/**
	 * 글 목록을 조회한다.
	 * @param searchVO - 조회할 정보가 담긴 VO
	 * @return 글 목록
	 * @exception Exception
	 */
	List<TaskLogInquiryVO> selectForChart(SearchVO searchVO) throws Exception;

	List<TaskLogInquiryVO> selectForChart2(SearchVO searchVO) throws Exception;
}