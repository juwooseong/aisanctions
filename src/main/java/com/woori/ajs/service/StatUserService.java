package com.woori.ajs.service;

import java.util.List;

import com.woori.ajs.model.SearchVO;
import com.woori.ajs.model.StatUserVO;

public interface StatUserService {
	List<StatUserVO> select1List(SearchVO searchVO) throws Exception;
	List<StatUserVO> select2List(SearchVO searchVO) throws Exception;
	List<StatUserVO> selectChartList(SearchVO searchVO) throws Exception;
	List<StatUserVO> selectChartList2(SearchVO searchVO) throws Exception;
	List<StatUserVO> selectChartList3(SearchVO searchVO) throws Exception;
}