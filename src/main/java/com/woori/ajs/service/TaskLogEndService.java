package com.woori.ajs.service;

import java.util.List;

import com.woori.ajs.model.SearchVO;
import com.woori.ajs.model.TaskLogEndVO;

public interface TaskLogEndService {

	List<TaskLogEndVO> selectList(SearchVO searchVO) throws Exception;
	
	List<TaskLogEndVO> select2List(SearchVO searchVO) throws Exception;
	
	int checkDate(SearchVO searchVO);
	
	/**
	 * 업무일지 - 업무마감 (5010) - 당일목록 건수
	 * 업무일지 - 업무일지 등록 (5020) - 제재심사 건수
	 * @param searchVO		: setSchSdate1(""), setSchEdate1(""), setInptAtmcBizDscd("")
	 * @return				: 건수
	 */
	int getTaskDatesCnt(SearchVO searchVO);
	
	void updateStatList(TaskLogEndVO vo) throws Exception;
	void updateStatCntList(TaskLogEndVO vo) throws Exception;
	void updateStatCntList2(TaskLogEndVO vo) throws Exception;
	
	void updateStatCntList_rvs(TaskLogEndVO vo) throws Exception;
	void updateStatCntList_qa(TaskLogEndVO vo) throws Exception;

}