package com.woori.ajs.service;

import java.util.List;

import com.woori.ajs.model.CaVO;
import com.woori.ajs.model.SearchVO;

public interface CaService {

	List<CaVO> selectSancRst(SearchVO vo) throws Exception;
	
	List<CaVO> selectSancAnswer(SearchVO vo) throws Exception;
}
