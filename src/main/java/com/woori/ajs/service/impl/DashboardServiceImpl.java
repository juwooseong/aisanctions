
package com.woori.ajs.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.woori.ajs.dao.DashboardMapper;
import com.woori.ajs.model.DashboardVO;
import com.woori.ajs.model.SearchVO;
import com.woori.ajs.service.DashboardService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.fdl.idgnr.EgovIdGnrService;

@Service("dashboardService")
public class DashboardServiceImpl extends EgovAbstractServiceImpl implements DashboardService {

	private static final Logger LOGGER = LoggerFactory.getLogger(DashboardServiceImpl.class);

	@Resource(name = "dashboardMapper")
	private DashboardMapper dashboardDAO;

	/** ID Generation */
	@Resource(name = "egovIdGnrService")
	private EgovIdGnrService egovIdGnrService;
	
	/**
	 * 대시보드 데이터를 조회한다.
	 * 내업무 To-Do, 진행업무별 현재상태
	 * 
	 * @param searchVO
	 *            - 조회할 정보가 담긴 VO
	 * @return 글 목록
	 * @exception Exception
	 */
	@Override
	public List<DashboardVO> taskList(SearchVO searchVO) throws Exception {
		return dashboardDAO.taskList(searchVO);
	}
	
	/**
	 * 대시보드 데이터를 조회한다.
	 * 심사현황
	 * 
	 * @param searchVO
	 *            - 조회할 정보가 담긴 VO
	 * @return 글 목록
	 * @exception Exception
	 */
	@Override
	public List<DashboardVO> inptList(SearchVO searchVO) throws Exception {
		return dashboardDAO.inptList(searchVO);
	}
	
	/**
	 * 대시보드 데이터를 조회한다.
	 * 국가별 수출입 현황
	 * 
	 * @param searchVO
	 *            - 조회할 정보가 담긴 VO
	 * @return 글 목록
	 * @exception Exception
	 */
	@Override
	public List<DashboardVO> impExpList(SearchVO searchVO) throws Exception {
		return dashboardDAO.impExpList(searchVO);
	}

}