package com.woori.ajs.dao;

import java.util.List;

import com.woori.ajs.model.SearchVO;
import com.woori.ajs.model.StatAnalysisVO;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Mapper("statAnalysisMapper")
public interface StatAnalysisMapper {
	List<StatAnalysisVO> selectList(SearchVO searchVO) throws Exception;
	int selectListTotCnt(SearchVO searchVO);
}