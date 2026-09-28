package com.woori.ajs.service;

import java.util.List;

import com.woori.ajs.model.SearchVO;
import com.woori.ajs.model.StatItemVO;

public interface StatItemService {
	
	/**
	 * 항목별 통계
	 */
	List<StatItemVO> selectList(SearchVO searchVO) throws Exception;
	
	/**
	 * 기간별 추이
	 */
	List<StatItemVO> selectMoveList(SearchVO searchVO) throws Exception;
}