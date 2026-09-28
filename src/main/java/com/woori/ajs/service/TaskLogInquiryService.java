package com.woori.ajs.service;

import java.util.List;

import com.woori.ajs.model.SearchVO;
import com.woori.ajs.model.TaskLogInquiryVO;

public interface TaskLogInquiryService {
	List<TaskLogInquiryVO> selectForChart(SearchVO searchVO) throws Exception;
	List<TaskLogInquiryVO> selectForChart2(SearchVO searchVO) throws Exception;
}