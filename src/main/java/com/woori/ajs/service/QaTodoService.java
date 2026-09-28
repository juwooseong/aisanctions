package com.woori.ajs.service;

import java.util.List;

import com.woori.ajs.model.SearchVO;
import com.woori.ajs.model.QaTodoVO;

public interface QaTodoService {

	List<QaTodoVO> selectList(SearchVO searchVO) throws Exception;
	int selectListTotCnt(SearchVO searchVO);
}