package com.woori.ajs.service;

import java.util.List;
import java.util.Map;

import com.woori.ajs.model.SearchVO;
import com.woori.ajs.model.AdminStatusTablesVO;
import com.woori.ajs.model.AdminStatusVO;
import com.woori.ajs.model.CommonRevertDetailVO;

public interface AdminStatusService {

	/**
	 * 글 목록을 조회한다.
	 * @param searchVO - 조회할 정보가 담긴 VO
	 * @return 글 목록
	 * @exception Exception
	 */
	List<AdminStatusVO> selectList(SearchVO searchVO) throws Exception;

	List<AdminStatusVO> selectDailyList(SearchVO searchVO) throws Exception;
	
	List<AdminStatusVO> selectAsideList() throws Exception;
	
	int selectAsideUngeneratedCount() throws Exception;
	
	String selectAsideInterval() throws Exception;
	/**
	 * 글 총 갯수를 조회한다.
	 * @param searchVO - 조회할 정보가 담긴 VO
	 * @return 글 총 갯수
	 * @exception
	 */
	int selectListTotCnt(SearchVO searchVO);
	
	void statusActivityUpdate(AdminStatusVO adminStatusVO);
	
	void statusActivityModHistory(CommonRevertDetailVO commonRevertDetailVO);
	
	void statusReprocess(AdminStatusVO adminStatusVO);
	
	void statusDeleteMaster(AdminStatusVO adminStatusVO);
	void statusDeleteMasterDetail(AdminStatusVO adminStatusVO);
	void statusDeleteHistory(AdminStatusVO adminStatusVO);
	void statusDeleteQueue(AdminStatusVO adminStatusVO);
	void queryTestUpdate(SearchVO vo) throws Exception;
	List<AdminStatusTablesVO> queryTest(SearchVO vo) throws Exception;
	List<AdminStatusTablesVO> queryTestDefault(SearchVO vo) throws Exception;
	void queryTestInsert(SearchVO vo) throws Exception;
	void queryTestDelete(SearchVO vo) throws Exception;
	
	List<Map<String, Object>> queryTestNew(SearchVO vo) throws Exception;
}