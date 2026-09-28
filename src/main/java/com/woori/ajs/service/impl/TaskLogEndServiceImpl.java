package com.woori.ajs.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.woori.ajs.dao.TaskLogEndMapper;
import com.woori.ajs.model.SearchVO;
import com.woori.ajs.model.TaskLogEndVO;
import com.woori.ajs.service.TaskLogEndService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.fdl.idgnr.EgovIdGnrService;

@Service("taskLogEndService")
public class TaskLogEndServiceImpl extends EgovAbstractServiceImpl implements TaskLogEndService {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(TaskLogEndServiceImpl.class);
	
	@Resource(name = "taskLogEndMapper")
	private TaskLogEndMapper taskLogEndDAO;
	
	/** ID Generation */
	@Resource(name = "egovIdGnrService")
	private EgovIdGnrService egovIdGnrService;
	
	@Override
	public List<TaskLogEndVO> selectList(SearchVO searchVO) throws Exception {
		return taskLogEndDAO.selectList(searchVO);
	}
	
	@Override
	public List<TaskLogEndVO> select2List(SearchVO searchVO) throws Exception {
		return taskLogEndDAO.select2List(searchVO);
	}
	
	@Override
	public int checkDate(SearchVO searchVO) {
		return taskLogEndDAO.checkDate(searchVO);
	}
	
	@Override
	public int getTaskDatesCnt(SearchVO searchVO) {
		return taskLogEndDAO.getTaskDatesCnt(searchVO);
	}
	
	@Override
	public void updateStatList(TaskLogEndVO vo) throws Exception {
		taskLogEndDAO.updateStatList(vo);
	}
	
	@Override
	public void updateStatCntList(TaskLogEndVO vo) throws Exception {
		taskLogEndDAO.updateStatCntList(vo);
	}
	
	@Override
	public void updateStatCntList2(TaskLogEndVO vo) throws Exception {
		taskLogEndDAO.updateStatCntList2(vo);
	}

	@Override
	public void updateStatCntList_rvs(TaskLogEndVO vo) throws Exception {
		taskLogEndDAO.updateStatCntList_rvs(vo);
	}

	@Override
	public void updateStatCntList_qa(TaskLogEndVO vo) throws Exception {
		taskLogEndDAO.updateStatCntList_qa(vo);
	}

}