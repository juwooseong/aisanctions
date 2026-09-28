package com.woori.ajs.service;

import java.util.List;

import com.woori.ajs.model.SearchVO;
import com.woori.ajs.model.RevertStatStatusVO;


public interface RevertStatStatusService {

	RevertStatStatusVO selectInfo(SearchVO searchVo) throws Exception;

	List<RevertStatStatusVO> selectList(SearchVO searchVO) throws Exception;

	int selectListTotCnt(SearchVO searchVO);

}