package com.woori.ajs.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.woori.ajs.dao.AdminBusinessDayMapper;
import com.woori.ajs.dao.AdminCodeMapper;
import com.woori.ajs.dao.AdminWordCorrectionMapper;
import com.woori.ajs.model.AdminBusinessDayVO;
import com.woori.ajs.model.AdminWordCorrectionVO;
import com.woori.ajs.model.SearchVO;
import com.woori.ajs.service.AdminWordCorrectionService;

@Service("adminWordCorrectionService")
public class AdminWordCorrectionServiceImpl implements AdminWordCorrectionService {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(AdminWordCorrectionServiceImpl.class);
	
	@Resource(name = "adminCodeMapper")
	private AdminCodeMapper adminCodeDAO;
	
	@Resource(name = "adminWordCorrectionMapper")
	private AdminWordCorrectionMapper adminWordCorrectionDAO;

	@Override
	public List<AdminWordCorrectionVO> selectList(SearchVO searchVO) throws Exception {
		return adminWordCorrectionDAO.selectList(searchVO);
	}

	@Override
	public int selectListTotCnt(SearchVO searchVO) {
		return adminWordCorrectionDAO.selectListTotCnt(searchVO);
	}

	@Override
	public List<AdminWordCorrectionVO> selectSanctionList(SearchVO searchVO) throws Exception {
		return adminWordCorrectionDAO.selectSanctionList(searchVO);
	}

	@Override
	public int selectWordDuplicationCheck(AdminWordCorrectionVO adminWordCorrectionVO) {
		return adminWordCorrectionDAO.selectWordDuplicationCheck(adminWordCorrectionVO);
	}

	@Override
	public void updateWord(AdminWordCorrectionVO adminWordCorrectionVO) {
		adminWordCorrectionDAO.updateWord(adminWordCorrectionVO);
	}

	@Override
	public void insertWord(AdminWordCorrectionVO adminWordCorrectionVO) {
		adminWordCorrectionDAO.insertWord(adminWordCorrectionVO);
	}

	@Override
	public void deleteWord(AdminWordCorrectionVO adminWordCorrectionVO) {
		adminWordCorrectionDAO.deleteWord(adminWordCorrectionVO);
	}
}