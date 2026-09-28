package com.woori.ajs.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.woori.ajs.dao.CommonMenuMapper;
import com.woori.ajs.model.SearchVO;
import com.woori.ajs.model.CommonMenuVO;
import com.woori.ajs.service.CommonMenuService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.fdl.idgnr.EgovIdGnrService;

@Service("commonMenuService")
public class CommonMenuServiceImpl extends EgovAbstractServiceImpl implements CommonMenuService {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(CommonMenuServiceImpl.class);
	
	@Resource(name = "commonMenuMapper")
	private CommonMenuMapper commonMenuDAO;
	
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
	public List<CommonMenuVO> selectList(SearchVO searchVO) throws Exception {
		return commonMenuDAO.selectList(searchVO);
	}
	
	/**
	 * 글 총 갯수를 조회한다. @param searchVO - 조회할 정보가 담긴 VO @return 글 총 갯수 @exception
	 */
	@Override
	public int selectListTotCnt(SearchVO searchVO) {
		return commonMenuDAO.selectListTotCnt(searchVO);
	}

}