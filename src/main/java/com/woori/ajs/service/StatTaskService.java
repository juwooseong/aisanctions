package com.woori.ajs.service;

import java.util.List;

import com.woori.ajs.model.SearchVO;
import com.woori.ajs.model.StatTaskVO;

public interface StatTaskService {
	List<StatTaskVO> selectList(SearchVO searchVO) throws Exception;
	int selectListTotCnt(SearchVO searchVO);
}