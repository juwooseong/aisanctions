package com.woori.ajs.dao;

import java.util.List;

import com.woori.ajs.model.CommonCodeVO;
import com.woori.ajs.model.SearchVO;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Mapper("commonCodeMapper")
public interface CommonCodeMapper {

	List<CommonCodeVO> selectAllCommonCodeList(SearchVO vo) throws Exception;
	
}