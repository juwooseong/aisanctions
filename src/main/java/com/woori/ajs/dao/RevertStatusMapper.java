package com.woori.ajs.dao;

import java.util.List;

import com.woori.ajs.model.SearchVO;
import com.woori.ajs.model.RevertStatusVO;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Mapper("revertStatusMapper")
public interface RevertStatusMapper {
	
	List<RevertStatusVO> selectList(SearchVO searchVO) throws Exception;
	
	int selectListTotCnt(SearchVO searchVO);

}