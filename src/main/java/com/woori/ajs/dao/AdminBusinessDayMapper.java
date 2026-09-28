package com.woori.ajs.dao;

import java.util.List;

import com.woori.ajs.model.AdminBusinessDayVO;
import com.woori.ajs.model.SearchVO;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Mapper("adminBusinessDayMapper")
public interface AdminBusinessDayMapper {
	
	List<AdminBusinessDayVO> selectBusinessDayList(SearchVO searchVO) throws Exception;
	
	void updateBusinessDay(AdminBusinessDayVO adminBusinessDayVO) throws Exception;
	
	void deleteBusinessDay(AdminBusinessDayVO adminBusinessDayVO) throws Exception;
	
}