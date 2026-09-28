
package com.woori.ajs.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.woori.ajs.dao.RevertTodoMapper;
import com.woori.ajs.model.SearchVO;
import com.woori.ajs.model.ReverTodoVO;
import com.woori.ajs.service.RevertTodoService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.fdl.idgnr.EgovIdGnrService;

@Service("revertTodoService")
public class RevertTodoServiceImpl extends EgovAbstractServiceImpl implements RevertTodoService {

	private static final Logger LOGGER = LoggerFactory.getLogger(RevertTodoServiceImpl.class);

	@Resource(name = "revertTodoMapper")
	private RevertTodoMapper revertTodoDAO;

	/** ID Generation */
	@Resource(name = "egovIdGnrService")
	private EgovIdGnrService egovIdGnrService;
	
	/**
	 * 심사자 본인작업 ToDoList 목록을 조회한다.
	 * 
	 * @param searchVO
	 *            - 조회할 정보가 담긴 VO
	 * @return 글 목록
	 * @exception Exception
	 */
	@Override
	public List<ReverTodoVO> selectList(SearchVO searchVO) throws Exception {
		return revertTodoDAO.selectList(searchVO);
	}

	/**
	 * 글 총 갯수를 조회한다. @param searchVO - 조회할 정보가 담긴 VO @return 글 총 갯수 @exception
	 */
	@Override
	public int selectListTotCnt(SearchVO searchVO) {
		return revertTodoDAO.selectListTotCnt(searchVO);
	}

}