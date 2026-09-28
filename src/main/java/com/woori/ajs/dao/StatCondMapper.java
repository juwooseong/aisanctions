package com.woori.ajs.dao;

import java.util.List;

import com.woori.ajs.model.SearchVO;
import com.woori.ajs.model.StatCondVO;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Mapper("StatCondMapper")
public interface StatCondMapper {
	List<StatCondVO> selectList(SearchVO vo) throws Exception;
	
	int selectListTotCnt(SearchVO vo);
}