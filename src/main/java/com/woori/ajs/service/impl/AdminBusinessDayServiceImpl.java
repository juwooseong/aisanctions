package com.woori.ajs.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.woori.ajs.dao.AdminBusinessDayMapper;
import com.woori.ajs.dao.AdminCodeMapper;
import com.woori.ajs.model.AdminBusinessDayVO;
import com.woori.ajs.model.CodeGrpVO;
import com.woori.ajs.model.CodeVO;
import com.woori.ajs.model.SearchVO;
import com.woori.ajs.service.AdminBusinessDayService;
import com.woori.ajs.service.AdminCodeService;

@Service("adminBusinessDayService")
public class AdminBusinessDayServiceImpl implements AdminBusinessDayService {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(AdminBusinessDayServiceImpl.class);
	
	@Resource(name = "adminCodeMapper")
	private AdminCodeMapper adminCodeDAO;
	
	@Resource(name = "adminBusinessDayMapper")
	private AdminBusinessDayMapper adminBusinessDayDAO;

	
	@Override
	public List<AdminBusinessDayVO> selectBusinessDayList(SearchVO searchVO) throws Exception {
		return adminBusinessDayDAO.selectBusinessDayList(searchVO);
	}

	@Override
	public void updateBusinessDay(AdminBusinessDayVO adminBusinessDayVO) throws Exception {
		adminBusinessDayDAO.updateBusinessDay(adminBusinessDayVO);
	}

	@Override
	public void deleteBusinessDay(AdminBusinessDayVO adminBusinessDayVO) throws Exception {
		adminBusinessDayDAO.deleteBusinessDay(adminBusinessDayVO);
	}

}