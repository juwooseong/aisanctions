package com.woori.ajs.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.woori.ajs.dao.AdminCodeMapper;
import com.woori.ajs.model.CodeGrpVO;
import com.woori.ajs.model.CodeVO;
import com.woori.ajs.model.SearchVO;
import com.woori.ajs.service.AdminCodeService;

@Service("adminCodeService")
public class AdminCodeServiceImpl implements AdminCodeService {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(AdminCodeServiceImpl.class);
	
	@Resource(name = "adminCodeMapper")
	private AdminCodeMapper adminCodeDAO;
	
	@Override
	public List<CodeGrpVO> selectCodeGrpList(SearchVO searchVO) throws Exception {
		return adminCodeDAO.selectCodeGrpList(searchVO);
	}
	
	@Override
	public CodeGrpVO selectCodeGrp(SearchVO searchVO) throws Exception {
		return adminCodeDAO.selectCodeGrp(searchVO);
	}
	
	@Override
	public void insertCodeGrp(CodeGrpVO vo) throws Exception {
		adminCodeDAO.insertCodeGrp(vo);
	}
	
	@Override
	public void deleteCodeGrp(CodeGrpVO vo) throws Exception {
		adminCodeDAO.deleteCodeGrp(vo);
	}
	
	@Override
	public List<CodeVO> selectCodeList(SearchVO searchVO) throws Exception {
		return adminCodeDAO.selectCodeList(searchVO);
	}
	
	@Override
	public CodeVO selectCode(SearchVO searchVO) throws Exception {
		return adminCodeDAO.selectCode(searchVO);
	}
	
	@Override
	public void insertCode(CodeVO vo) throws Exception {
		adminCodeDAO.insertCode(vo);
	}
	
	@Override
	public void deleteCode(CodeVO vo) throws Exception {
		adminCodeDAO.deleteCode(vo);
	}
	
}