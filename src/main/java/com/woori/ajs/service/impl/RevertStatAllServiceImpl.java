package com.woori.ajs.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.woori.ajs.dao.RevertStatAllMapper;
import com.woori.ajs.model.RevertStatAllVO;
import com.woori.ajs.model.SearchVO;
import com.woori.ajs.service.RevertStatAllService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.fdl.idgnr.EgovIdGnrService;

@Service("revertStatAllService")
public class RevertStatAllServiceImpl extends EgovAbstractServiceImpl implements RevertStatAllService{

	private static final Logger LOGGER = LoggerFactory.getLogger(RevertStatAllServiceImpl.class);

	@Resource(name = "revertStatAllMapper")
	private RevertStatAllMapper revertStatAllMapperDAO;
	
	/** ID Generation */
	@Resource(name = "egovIdGnrService")
	private EgovIdGnrService egovIdGnrService;
	
	
	@Override
	public RevertStatAllVO selectInfo(SearchVO vo) throws Exception {
		RevertStatAllVO resultVO = revertStatAllMapperDAO.selectInfo(vo);
		if (resultVO == null) {
			throw processException("info.nodata.msg");
		}
		return resultVO;
	}

	@Override
	public List<RevertStatAllVO> selectList(SearchVO searchVO) throws Exception {
		return revertStatAllMapperDAO.selectList(searchVO);
	}

	@Override
	public int selectListTotCnt(SearchVO searchVO) {
		return revertStatAllMapperDAO.selectListTotCnt(searchVO);
	}

}
