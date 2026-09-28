package com.woori.ajs.dao;

import java.util.List;

import com.woori.ajs.model.SearchVO;
import com.woori.ajs.model.TaskLogEndVO;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Mapper("taskLogEndMapper")
public interface TaskLogEndMapper {
	
	List<TaskLogEndVO> selectList(SearchVO searchVO) throws Exception;
	
	List<TaskLogEndVO> select2List(SearchVO searchVO) throws Exception;
	
	int checkDate(SearchVO searchVO);
	int getTaskDatesCnt(SearchVO searchVO);
	
	void updateStatList(TaskLogEndVO vo) throws Exception;
	void updateStatCntList(TaskLogEndVO vo) throws Exception;
	void updateStatCntList2(TaskLogEndVO vo) throws Exception;
	
	void updateStatCntList_rvs(TaskLogEndVO vo) throws Exception;
	void updateStatCntList_qa(TaskLogEndVO vo) throws Exception;

}