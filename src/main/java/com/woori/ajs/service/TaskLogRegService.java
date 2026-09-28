package com.woori.ajs.service;

import java.util.List;

import com.woori.ajs.model.SearchVO;
import com.woori.ajs.model.TaskLogRegVO;

public interface TaskLogRegService {

	List<TaskLogRegVO> selectList(SearchVO vo) throws Exception;
	List<TaskLogRegVO> select2List(SearchVO vo) throws Exception;
	List<TaskLogRegVO> select3List(SearchVO vo) throws Exception;
	List<TaskLogRegVO> select4List(SearchVO vo) throws Exception;
	List<TaskLogRegVO> select5List(SearchVO vo) throws Exception;
	
	void insert(TaskLogRegVO taskLogRegvo);
	void preInsert(TaskLogRegVO taskLogRegvo);

}