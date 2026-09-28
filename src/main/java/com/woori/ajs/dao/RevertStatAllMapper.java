package com.woori.ajs.dao;

import java.util.List;

import com.woori.ajs.model.RevertStatAllVO;
import com.woori.ajs.model.SearchVO;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Mapper("revertStatAllMapper")
public interface RevertStatAllMapper {

	RevertStatAllVO selectInfo(SearchVO vo) throws Exception;
	List<RevertStatAllVO> selectList(SearchVO searchVO) throws Exception;
	int selectListTotCnt(SearchVO searchVO);
}
