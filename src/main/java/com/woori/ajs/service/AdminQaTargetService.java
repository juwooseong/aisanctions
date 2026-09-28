package com.woori.ajs.service;

import java.util.List;

import com.woori.ajs.model.AdminQaTargetVO;
import com.woori.ajs.model.SearchVO;

public interface AdminQaTargetService {

	/**
	 * QA선정 정보을 조회한다.
	 * @param 
	 * @return QA선정 정보
	 * @exception Exception
	 */
	AdminQaTargetVO selectQaExTarget(AdminQaTargetVO search) throws Exception;
	
	void insert(AdminQaTargetVO search) throws Exception;

	List<AdminQaTargetVO> selectList(SearchVO search) throws Exception;
	
}
