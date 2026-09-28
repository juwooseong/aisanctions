package com.woori.ajs.dao;

import java.util.List;

import com.woori.ajs.model.SearchVO;
import com.woori.ajs.model.TaskLogRegVO;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Mapper("taskLogRegMapper")
public interface TaskLogRegMapper {
	
	List<TaskLogRegVO> selectList(SearchVO vo) throws Exception;
	List<TaskLogRegVO> select2List(SearchVO vo) throws Exception;
	List<TaskLogRegVO> select3List(SearchVO vo) throws Exception;
	List<TaskLogRegVO> select4List(SearchVO vo) throws Exception;
	List<TaskLogRegVO> select5List(SearchVO vo) throws Exception;
	
	void insert(TaskLogRegVO taskLogRegvo);
	void preInsert(TaskLogRegVO taskLogRegvo);
	
}