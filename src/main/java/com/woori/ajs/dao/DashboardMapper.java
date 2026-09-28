package com.woori.ajs.dao;

import java.util.List;

import com.woori.ajs.model.DashboardVO;
import com.woori.ajs.model.SearchVO;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Mapper("dashboardMapper")
public interface DashboardMapper {
	
	/**
	 * 대시보드 통계 데이터글 목록을 조회한다.
	 * @param searchVO - 조회할 정보가 담긴 VO
	 * @return 글 목록
	 * @exception Exception
	 */
	List<DashboardVO> taskList(SearchVO searchVO) throws Exception;

	List<DashboardVO> inptList(SearchVO searchVO) throws Exception;

	List<DashboardVO> impExpList(SearchVO searchVO) throws Exception;


}