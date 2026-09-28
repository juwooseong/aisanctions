package com.woori.ajs.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.woori.ajs.dao.CommonManualMapper;
import com.woori.ajs.dao.CommonMenuMapper;
import com.woori.ajs.model.SearchVO;
import com.woori.ajs.model.CommonManualVO;
import com.woori.ajs.model.CommonMenuVO;
import com.woori.ajs.service.CommonManualService;
import com.woori.ajs.service.CommonMenuService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.fdl.idgnr.EgovIdGnrService;

@Service("commonManualService")
public class CommonManualServiceImpl extends EgovAbstractServiceImpl implements CommonManualService {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(CommonManualServiceImpl.class);
	
	@Resource(name = "commonManualMapper")
	private CommonManualMapper commonManualDAO;
	
	/** ID Generation */
	@Resource(name = "egovIdGnrService")
	private EgovIdGnrService egovIdGnrService;

	@Override
	public List<CommonManualVO> selectList(SearchVO searchVO) throws Exception {
		return commonManualDAO.selectList(searchVO);
	}

	@Override
	public int selectListTotCnt(SearchVO searchVO) {
		return commonManualDAO.selectListTotCnt(searchVO);
	}

	@Override
	public void insertFileUpload(CommonManualVO commonManualVO) throws Exception {
		commonManualDAO.insertFileUpload(commonManualVO);
	}

	@Override
	public List<CommonManualVO> selectFileInfo(SearchVO searchVO) throws Exception {
		return commonManualDAO.selectFileInfo(searchVO);
	}

	@Override
	public void delUploadedFile(SearchVO searchVO) throws Exception {
		commonManualDAO.delUploadedFile(searchVO);
	}
	
}