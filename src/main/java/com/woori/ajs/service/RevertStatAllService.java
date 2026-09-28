package com.woori.ajs.service;

import java.util.List;

import com.woori.ajs.model.RevertStatAllVO;
import com.woori.ajs.model.SearchVO;


public interface RevertStatAllService {

	RevertStatAllVO selectInfo(SearchVO searchVo) throws Exception;

	List<RevertStatAllVO> selectList(SearchVO searchVO) throws Exception;

	int selectListTotCnt(SearchVO searchVO);
}
