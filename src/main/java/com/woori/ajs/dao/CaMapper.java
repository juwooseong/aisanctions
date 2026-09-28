package com.woori.ajs.dao;

import java.util.List;

import com.woori.ajs.model.CaVO;
import com.woori.ajs.model.SearchVO;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Mapper("caMapper")
public interface CaMapper {

	List<CaVO> selectSancRst(SearchVO vo) throws Exception;
	
	List<CaVO> selectSancAnswer(SearchVO vo) throws Exception;
}
