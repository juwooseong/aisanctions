
package com.woori.ajs.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.woori.ajs.dao.RevertStatStatusMapper;
import com.woori.ajs.model.RevertStatStatusVO;
import com.woori.ajs.model.SearchVO;
import com.woori.ajs.service.RevertStatStatusService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.fdl.idgnr.EgovIdGnrService;

@Service("revertStatStatusService")
public class RevertStatStatusServiceImpl extends EgovAbstractServiceImpl implements RevertStatStatusService {

	private static final Logger LOGGER = LoggerFactory.getLogger(RevertStatStatusServiceImpl.class);

	@Resource(name = "revertStatStatusMapper")
	private RevertStatStatusMapper revertStatStatusDAO;

	/** ID Generation */
	@Resource(name = "egovIdGnrService")
	private EgovIdGnrService egovIdGnrService;

	@Override
	public RevertStatStatusVO selectInfo(SearchVO vo) throws Exception {
		RevertStatStatusVO resultVO = revertStatStatusDAO.selectInfo(vo);
		if (resultVO == null) {
			throw processException("info.nodata.msg");
		}
		return resultVO;
	}

	/**
	 * 글 목록을 조회한다.
	 * 
	 * @param searchVO
	 *            - 조회할 정보가 담긴 VO
	 * @return 글 목록
	 * @exception Exception
	 */
	@Override
	public List<RevertStatStatusVO> selectList(SearchVO searchVO) throws Exception {
		return revertStatStatusDAO.selectList(searchVO);
	}

	/**
	 * 글 총 갯수를 조회한다. @param searchVO - 조회할 정보가 담긴 VO @return 글 총 갯수 @exception
	 */
	@Override
	public int selectListTotCnt(SearchVO searchVO) {
		return revertStatStatusDAO.selectListTotCnt(searchVO);
	}

}