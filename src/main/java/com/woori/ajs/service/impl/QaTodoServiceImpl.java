package com.woori.ajs.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.woori.ajs.dao.QaTodoMapper;
import com.woori.ajs.model.SearchVO;
import com.woori.ajs.model.QaTodoVO;
import com.woori.ajs.service.QaTodoService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.fdl.idgnr.EgovIdGnrService;

@Service("qaTodoService")
public class QaTodoServiceImpl extends EgovAbstractServiceImpl implements QaTodoService{
	private static final Logger LOGGER = LoggerFactory.getLogger(QaTodoServiceImpl.class); 
	
	@Resource(name="qaTodoMapper")
	private QaTodoMapper qaTodoDAO;
	
	@Resource(name="egovIdGnrService")
	private EgovIdGnrService egovIdGnrService;

	@Override
	public List<QaTodoVO> selectList(SearchVO searchVO) throws Exception {
		return qaTodoDAO.selectList(searchVO);
	}

	@Override
	public int selectListTotCnt(SearchVO searchVO) {
		return qaTodoDAO.selectListTotCnt(searchVO);
	}
}