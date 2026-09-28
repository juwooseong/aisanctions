package com.woori.ajs.dao;

import java.util.List;

import com.woori.ajs.model.SearchVO;
import com.woori.ajs.model.StatTaskVO;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Mapper("StatTaskMapper")
public interface StatTaskMapper {
	List<StatTaskVO> selectList(SearchVO searchVO) throws Exception;
	int selectListTotCnt(SearchVO searchVO);
}