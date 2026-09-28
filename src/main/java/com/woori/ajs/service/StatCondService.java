package com.woori.ajs.service;

import java.util.List;

import com.woori.ajs.model.SearchVO;
import com.woori.ajs.model.StatCondVO;

public interface StatCondService {
	List<StatCondVO> selectList(SearchVO vo) throws Exception;
	
	int selectListTotCnt(SearchVO vo);
}