package com.woori.ajs.dao;

import java.util.List;

import com.woori.ajs.model.QaTodoVO;
import com.woori.ajs.model.SearchVO;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Mapper("qaTodoMapper")
public interface QaTodoMapper {
	QaTodoVO selectInfo(SearchVO vo) throws Exception;
	List<QaTodoVO> selectList(SearchVO vo) throws Exception;
	int selectListTotCnt(SearchVO vo);
}
