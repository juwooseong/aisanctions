package com.woori.ajs.dao;

import java.util.List;

import com.woori.ajs.model.SearchVO;
import com.woori.ajs.model.StatUserVO;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Mapper("StatUserMapper")
public interface StatUserMapper {
	List<StatUserVO> select1List(SearchVO searchVO) throws Exception;
	List<StatUserVO> select2List(SearchVO searchVO) throws Exception;
	List<StatUserVO> selectChartList(SearchVO searchVO) throws Exception;
	List<StatUserVO> selectChartList2(SearchVO searchVO) throws Exception;
	List<StatUserVO> selectChartList3(SearchVO searchVO) throws Exception;
}