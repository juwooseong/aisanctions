package com.woori.ajs.dao;

import java.util.List;

import com.woori.ajs.model.SearchVO;
import com.woori.ajs.model.QaStatusVO;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Mapper("qaStatusMapper")
public interface QaStatusMapper {
	QaStatusVO selectInfo(SearchVO vo) throws Exception;
	List<QaStatusVO> selectList(SearchVO searchVO) throws Exception;
	int selectListTotCnt(SearchVO searchVO);
	String checkDate(SearchVO searchVO);
}