package com.woori.ajs.dao;

import java.util.List;

import com.woori.ajs.model.SearchVO;
import com.woori.ajs.model.RevertStatStatusVO;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Mapper("revertStatStatusMapper")
public interface RevertStatStatusMapper {

	RevertStatStatusVO selectInfo(SearchVO  vo) throws Exception;
	
	List<RevertStatStatusVO > selectList(SearchVO searchVO) throws Exception;

	
	int selectListTotCnt(SearchVO searchVO);

}