package com.woori.ajs.service;

import java.util.List;

import com.woori.ajs.model.SearchVO;
import com.woori.ajs.model.AdminCityVO;

public interface AdminCityService {
	List<AdminCityVO> selectList(SearchVO searchVO) throws Exception;
	int selectListTotCnt(SearchVO searchVO);
	void insert(AdminCityVO vo);
	void delete(AdminCityVO vo);
}