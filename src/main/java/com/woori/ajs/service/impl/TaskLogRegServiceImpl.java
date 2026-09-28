package com.woori.ajs.service.impl;
import java.util.List;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.woori.ajs.dao.TaskLogRegMapper;
import com.woori.ajs.model.SearchVO;
import com.woori.ajs.model.TaskLogRegVO;
import com.woori.ajs.service.TaskLogRegService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.fdl.idgnr.EgovIdGnrService;

@Service("taskLogRegService")
public class TaskLogRegServiceImpl extends EgovAbstractServiceImpl implements TaskLogRegService {

private static final Logger LOGGER = LoggerFactory.getLogger(TaskLogRegServiceImpl.class);
	
	@Resource(name = "taskLogRegMapper")
	private TaskLogRegMapper taskLogRegDAO;
	
	/** ID Generation */
	@Resource(name = "egovIdGnrService")
	private EgovIdGnrService egovIdGnrService;
	
	@Override
	public List<TaskLogRegVO> selectList(SearchVO vo) throws Exception {
		return taskLogRegDAO.selectList(vo);
	}

	@Override
	public List<TaskLogRegVO> select2List(SearchVO vo) throws Exception {
		return taskLogRegDAO.select2List(vo);
	}

	@Override
	public List<TaskLogRegVO> select3List(SearchVO vo) throws Exception {
		return taskLogRegDAO.select3List(vo);
	}
	@Override
	public List<TaskLogRegVO> select4List(SearchVO vo) throws Exception {
		return taskLogRegDAO.select4List(vo);
	}
	@Override
	public List<TaskLogRegVO> select5List(SearchVO vo) throws Exception {
		return taskLogRegDAO.select5List(vo);
	}
	
	@Override
	public void insert(TaskLogRegVO taskTaskVOvo) {
		taskLogRegDAO.insert(taskTaskVOvo);
		return;
	}

	@Override
	public void preInsert(TaskLogRegVO taskLogRegvo) {
		taskLogRegDAO.preInsert(taskLogRegvo);
		return;
	}
	
}