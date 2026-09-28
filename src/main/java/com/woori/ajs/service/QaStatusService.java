package com.woori.ajs.service;

import java.util.List;

import com.woori.ajs.model.SearchVO;
import com.woori.ajs.model.QaStatusVO;


public interface QaStatusService {

	QaStatusVO selectInfo(SearchVO vo) throws Exception;

	List<QaStatusVO> selectList(SearchVO searchVO) throws Exception;

	int selectListTotCnt(SearchVO searchVO);

	String checkDate(SearchVO searchVO);
}