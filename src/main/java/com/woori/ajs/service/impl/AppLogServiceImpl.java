package com.woori.ajs.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.woori.ajs.dao.AppLogMapper;
import com.woori.ajs.model.AppLogVO;
import com.woori.ajs.model.SearchVO;
import com.woori.ajs.service.AppLogService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.fdl.idgnr.EgovIdGnrService;

@Service("appLogService")
public class AppLogServiceImpl extends EgovAbstractServiceImpl implements AppLogService {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(AppLogServiceImpl.class);
	
	@Resource(name = "appLogMapper")
	private AppLogMapper appLogDAO;
	
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
	public List<AppLogVO> selectList(SearchVO searchVO) throws Exception {
		return appLogDAO.selectList(searchVO);
	}
	
	/**
	 * 글 총 갯수를 조회한다. @param searchVO - 조회할 정보가 담긴 VO @return 글 총 갯수 @exception
	 */
	@Override
	public int selectListTotCnt(SearchVO searchVO) {
		return appLogDAO.selectListTotCnt(searchVO);
	}
	
	/**
	 * 승인을 처리한다.
	 * @param searchVO - 승인할 정보
	 * @return 
	 * @exception
	 */
	@Override
	public void updateApprove(AppLogVO vo) {
		//dao.updateQaMasAtvt(vo);
		//dao.insertSantionHis(vo);
		appLogDAO.updateSantionApprvHis(vo);
	}
	
}