package com.woori.ajs.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.woori.ajs.dao.AdminSanctionMapper;
import com.woori.ajs.model.AdminSanctionRule1VO;
import com.woori.ajs.model.AdminSanctionRule2VO;
import com.woori.ajs.model.AdminSanctionRule3VO;
import com.woori.ajs.model.AdminSanctionVO;
import com.woori.ajs.model.SearchVO;
import com.woori.ajs.service.AdminSanctionService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.fdl.idgnr.EgovIdGnrService;

@Service("adminSanctionService")
public class AdminSanctionServiceImpl extends EgovAbstractServiceImpl implements AdminSanctionService{

	private static final Logger LOGGER = LoggerFactory.getLogger(AdminSanctionServiceImpl.class);

	@Resource(name = "adminSanctionMapper")
	private AdminSanctionMapper adminSanctionDAO;

	/** ID Generation */
	@Resource(name = "egovIdGnrService")
	private EgovIdGnrService egovIdGnrService;
	
	@Override
	public List<AdminSanctionRule1VO> selectListRule1(SearchVO searchVO) throws Exception {
		return adminSanctionDAO.selectListRule1(searchVO);
	}

	@Override
	public List<AdminSanctionRule2VO> selectListRule2(SearchVO searchVO) throws Exception {
		return adminSanctionDAO.selectListRule2(searchVO);
	}

	@Override
	public List<AdminSanctionRule3VO> selectListRule3(SearchVO searchVO) throws Exception {
		return adminSanctionDAO.selectListRule3(searchVO);
	}

	@Override
	public List<AdminSanctionRule1VO> selectInfoRule1(String num) throws Exception {
		return adminSanctionDAO.selectInfoRule1(num);
	}

	@Override
	public List<AdminSanctionRule2VO> selectInfoRule2(String num) throws Exception {
		return adminSanctionDAO.selectInfoRule2(num);
	}

	@Override
	public List<AdminSanctionRule3VO> selectInfoRule3(String num) throws Exception {
		return adminSanctionDAO.selectInfoRule3(num);
	}

	@Override
	public List<AdminSanctionVO> RequestTable(SearchVO searchVO) throws Exception {
		return adminSanctionDAO.RequestTable(searchVO);
	}

	@Override
	public void insertRequestTable(AdminSanctionVO vo) throws Exception {
		adminSanctionDAO.insertRequestTable(vo);
	}
	@Override
	public void insertRequestTable2(AdminSanctionVO vo) throws Exception {
		adminSanctionDAO.insertRequestTable2(vo);
	}
	@Override
	public void insertRequestTable3(AdminSanctionVO vo) throws Exception {
		adminSanctionDAO.insertRequestTable3(vo);
	}
	@Override
	public void insertRule1(AdminSanctionRule1VO vo) throws Exception {
		adminSanctionDAO.insertRule1(vo);
	}
	@Override
	public void insertRule2(AdminSanctionRule2VO vo) throws Exception {
		adminSanctionDAO.insertRule2(vo);
	}
	@Override
	public void insertRule3(AdminSanctionRule3VO vo) throws Exception {
		adminSanctionDAO.insertRule3(vo);
	}
	
	@Override
	public void deleteRule1(AdminSanctionRule1VO vo) throws Exception {
		adminSanctionDAO.deleteRule1(vo);
	}
	@Override
	public void deleteRule2(AdminSanctionRule2VO vo) throws Exception {
		adminSanctionDAO.deleteRule2(vo);
	}
	@Override
	public void deleteRule3(AdminSanctionRule3VO vo) throws Exception {
		adminSanctionDAO.deleteRule3(vo);
	}

	@Override
	public List<AdminSanctionRule1VO> selectListCheckRule1(AdminSanctionRule1VO vo) throws Exception {
		return adminSanctionDAO.selectListCheckRule1(vo);
	}

	@Override
	public List<AdminSanctionRule2VO> selectListCheckRule2(AdminSanctionRule2VO vo) throws Exception {
		return adminSanctionDAO.selectListCheckRule2(vo);
	}
	
	
	
}