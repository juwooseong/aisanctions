package com.woori.ajs.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.woori.ajs.dao.RevertStatErrorMapper;
import com.woori.ajs.model.RevertStatErrorVO;
import com.woori.ajs.model.SearchVO;
import com.woori.ajs.service.RevertStatErrorService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.fdl.idgnr.EgovIdGnrService;

@Service("revertStatErrorService")
public class RevertStatErrorServiceImpl extends EgovAbstractServiceImpl implements RevertStatErrorService {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(RevertStatErrorServiceImpl.class);
	
	@Resource(name = "revertStatErrorMapper")
	private RevertStatErrorMapper revertStatErrorDAO;
	
	/** ID Generation */
	@Resource(name = "egovIdGnrService")
	private EgovIdGnrService egovIdGnrService;
	
	/**
	 * 글 목록을 조회한다.
	 * 
	 * @param searchVO
	 *            - 조회할 정보가 담긴 VO
	 * @return 글 목록
	 * @exception Exception
	 */
	@Override
	public List<RevertStatErrorVO> selectList(SearchVO searchVO) throws Exception {
		return revertStatErrorDAO.selectList(searchVO);
	}
	
	/**
	 * 글 총 갯수를 조회한다. @param searchVO - 조회할 정보가 담긴 VO @return 글 총 갯수 @exception
	 */
	@Override
	public int selectListTotCnt(SearchVO searchVO) {
		return revertStatErrorDAO.selectListTotCnt(searchVO);
	}

}