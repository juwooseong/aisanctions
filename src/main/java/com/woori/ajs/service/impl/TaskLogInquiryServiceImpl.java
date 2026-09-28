package com.woori.ajs.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.woori.ajs.dao.TaskLogInquiryMapper;
import com.woori.ajs.model.SearchVO;
import com.woori.ajs.model.TaskLogInquiryVO;
import com.woori.ajs.service.TaskLogInquiryService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.fdl.idgnr.EgovIdGnrService;

@Service("taskLogInquiryService")
public class TaskLogInquiryServiceImpl extends EgovAbstractServiceImpl implements TaskLogInquiryService{

private static final Logger LOGGER = LoggerFactory.getLogger(TaskLogInquiryServiceImpl.class);
	
	@Resource(name = "taskLogInquiryMapper")
	private TaskLogInquiryMapper taskLogInquiryDAO;
	
	/** ID Generation */
	@Resource(name = "egovIdGnrService")
	private EgovIdGnrService egovIdGnrService;
	
	@Override
	public List<TaskLogInquiryVO> selectForChart(SearchVO searchVO) throws Exception {
		// TODO Auto-generated method stub
		return taskLogInquiryDAO.selectForChart(searchVO);
	}
	
	@Override
	public List<TaskLogInquiryVO> selectForChart2(SearchVO searchVO) throws Exception {
		// TODO Auto-generated method stub
		return taskLogInquiryDAO.selectForChart2(searchVO);
	}
	
}