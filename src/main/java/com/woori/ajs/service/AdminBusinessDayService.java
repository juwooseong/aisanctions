package com.woori.ajs.service;

import java.util.List;

import com.woori.ajs.model.AdminBusinessDayVO;
import com.woori.ajs.model.CodeGrpVO;
import com.woori.ajs.model.CodeVO;
import com.woori.ajs.model.SearchVO;

public interface AdminBusinessDayService {

	// 영업일 조회
	List<AdminBusinessDayVO> selectBusinessDayList(SearchVO searchVO) throws Exception;
	
	// 영업일 휴일정보 신규 및 저장(동일)
	void updateBusinessDay(AdminBusinessDayVO adminBusinessDayVO) throws Exception;
	
	// 영업일 휴일정보 삭제
	void deleteBusinessDay(AdminBusinessDayVO adminBusinessDayVO) throws Exception;
	
}