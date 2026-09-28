package com.woori.ajs.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.woori.ajs.dao.RevertStatCompleteMapper;
import com.woori.ajs.dao.RevertUngeneratedMapper;
import com.woori.ajs.model.SearchVO;
import com.woori.ajs.model.RevertStatCompleteVO;
import com.woori.ajs.model.RevertUngeneratedVO;
import com.woori.ajs.service.RevertStatCompleteService;
import com.woori.ajs.service.RevertUngeneratedService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.fdl.idgnr.EgovIdGnrService;

@Service("revertUngeneratedService")
public class RevertUngeneratedServiceImpl extends EgovAbstractServiceImpl implements RevertUngeneratedService {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(RevertUngeneratedServiceImpl.class);
	
	//@Resource(name = "revertStatCompleteMapper")
	//private RevertStatCompleteMapper revertStatCompleteDAO;
	
	@Resource(name = "revertUngeneratedMapper")
	private RevertUngeneratedMapper revertUngeneratedDAO;
	
	/** ID Generation */
	@Resource(name = "egovIdGnrService")
	private EgovIdGnrService egovIdGnrService;
	
	@Override
	public List<RevertUngeneratedVO> selectList(SearchVO searchVO) throws Exception {
		return revertUngeneratedDAO.selectList(searchVO);
	}
	
	/**
	 * 글 총 갯수를 조회한다. @param searchVO - 조회할 정보가 담긴 VO @return 글 총 갯수 @exception
	 */
	@Override
	public int selectListTotCnt(SearchVO searchVO) {
		return revertUngeneratedDAO.selectListTotCnt(searchVO);
	}

	@Override
	public void statusUpdate(RevertUngeneratedVO revertUngeneratedVO) {
		revertUngeneratedDAO.statusUpdate(revertUngeneratedVO);
	}
	


}