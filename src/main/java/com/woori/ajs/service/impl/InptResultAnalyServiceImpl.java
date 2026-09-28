package com.woori.ajs.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.woori.ajs.dao.InptResultAnalyMapper;
import com.woori.ajs.model.SearchVO;
import com.woori.ajs.model.InptResultAnalyVO;
import com.woori.ajs.service.InptResultAnalyService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.fdl.idgnr.EgovIdGnrService;

@Service("inptResultAnalyService")
public class InptResultAnalyServiceImpl extends EgovAbstractServiceImpl implements InptResultAnalyService {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(InptResultAnalyServiceImpl.class);
	
	@Resource(name = "inptResultAnalyMapper")
	private InptResultAnalyMapper inptResultAnalyDAO;
	
	/** ID Generation */
	@Resource(name = "egovIdGnrService")
	private EgovIdGnrService egovIdGnrService;

	@Override
	public List<InptResultAnalyVO> selectRefList(SearchVO searchVO) throws Exception {
		return inptResultAnalyDAO.selectRefList(searchVO);
	}

	@Override
	public List<InptResultAnalyVO> selectCategoryList(SearchVO searchVO) throws Exception {
		return inptResultAnalyDAO.selectCategoryList(searchVO);
	}

	@Override
	public List<InptResultAnalyVO> selectPerformanceList(SearchVO searchVO) throws Exception {
		return inptResultAnalyDAO.selectPerformanceList(searchVO);
	}

	@Override
	public List<InptResultAnalyVO> selectSugiList(SearchVO searchVO) throws Exception {
		return inptResultAnalyDAO.selectSugiList(searchVO);
	}

	@Override
	public List<InptResultAnalyVO> selectDailyPerformList(SearchVO searchVO) throws Exception {
		return inptResultAnalyDAO.selectDailyPerformList(searchVO);
	}
	


}