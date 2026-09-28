
package com.woori.ajs.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.woori.ajs.dao.RevertStatusMapper;
import com.woori.ajs.model.SearchVO;
import com.woori.ajs.model.RevertStatusVO;
import com.woori.ajs.service.RevertStatusService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.fdl.idgnr.EgovIdGnrService;

@Service("revertStatusService")
public class RevertStatusServiceImpl extends EgovAbstractServiceImpl implements RevertStatusService {

	private static final Logger LOGGER = LoggerFactory.getLogger(RevertStatusServiceImpl.class);

	@Resource(name = "revertStatusMapper")
	private RevertStatusMapper revertStatusDAO;

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
	public List<RevertStatusVO> selectList(SearchVO searchVO) throws Exception {
		return revertStatusDAO.selectList(searchVO);
	}

	/**
	 * 글 총 갯수를 조회한다. @param searchVO - 조회할 정보가 담긴 VO @return 글 총 갯수 @exception
	 */
	@Override
	public int selectListTotCnt(SearchVO searchVO) {
		return revertStatusDAO.selectListTotCnt(searchVO);
	}
	
}