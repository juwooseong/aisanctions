package com.woori.ajs.dao;

import java.util.List;

import com.woori.ajs.model.SearchVO;
import com.woori.ajs.model.StatItemVO;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Mapper("StatItemMapper")
public interface StatItemMapper {
	List<StatItemVO> selectList(SearchVO searchVO) throws Exception;
	List<StatItemVO> selectMoveList(SearchVO searchVO) throws Exception;
}