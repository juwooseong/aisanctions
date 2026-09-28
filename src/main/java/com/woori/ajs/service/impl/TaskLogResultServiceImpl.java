package com.woori.ajs.service.impl;
import java.util.List;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.woori.ajs.dao.TaskLogResultMapper;
import com.woori.ajs.model.SearchVO;
import com.woori.ajs.model.TaskLogResultVO;
import com.woori.ajs.service.TaskLogResultService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.fdl.idgnr.EgovIdGnrService;

@Service("taskLogResultService")
public class TaskLogResultServiceImpl extends EgovAbstractServiceImpl implements TaskLogResultService {

private static final Logger LOGGER = LoggerFactory.getLogger(TaskLogResultServiceImpl.class);
	
	@Resource(name = "taskLogResultMapper")
	private TaskLogResultMapper taskLogResultDAO;
	
	/** ID Generation */
	@Resource(name = "egovIdGnrService")
	private EgovIdGnrService egovIdGnrService;

	@Override
	public List<TaskLogResultVO> selectList(SearchVO searchVO) throws Exception {
		// TODO Auto-generated method stub
		return taskLogResultDAO.selectList(searchVO);
	}

	@Override
	public int selectListTotCnt(SearchVO searchVO) {
		// TODO Auto-generated method stub
		return taskLogResultDAO.selectListTotCnt(searchVO);
	}
}