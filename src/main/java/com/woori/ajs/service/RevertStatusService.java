package com.woori.ajs.service;

import java.util.List;

import com.woori.ajs.model.SearchVO;
import com.woori.ajs.model.RevertStatusVO;

public interface RevertStatusService {

	List<RevertStatusVO> selectList(SearchVO searchVO) throws Exception;

	int selectListTotCnt(SearchVO searchVO);

}