package com.woori.ajs.service;

import java.util.List;

import com.woori.ajs.model.CommonCodeVO;
import com.woori.ajs.model.SearchVO;

public interface CommonCodeService {

	List<CommonCodeVO> selectAllCommonCodeList(SearchVO vo) throws Exception;
}