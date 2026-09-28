package com.woori.ajs.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.woori.ajs.dao.AppTodoMapper;
import com.woori.ajs.model.AppTodoMemoVO;
import com.woori.ajs.model.AppTodoVO;
import com.woori.ajs.model.SearchVO;
import com.woori.ajs.service.AppTodoService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.fdl.idgnr.EgovIdGnrService;

@Service("appTodoService")
public class AppTodoServiceImpl extends EgovAbstractServiceImpl implements AppTodoService {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(AppTodoServiceImpl.class);
	
	@Resource(name = "appTodoMapper")
	private AppTodoMapper appTodoDAO;
	
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
	public List<AppTodoVO> selectList(SearchVO searchVO) throws Exception {
		return appTodoDAO.selectList(searchVO);
	}
	
	/**
	 * 글 총 갯수를 조회한다. @param searchVO - 조회할 정보가 담긴 VO @return 글 총 갯수 @exception
	 */
	@Override
	public int selectListTotCnt(SearchVO searchVO) {
		return appTodoDAO.selectListTotCnt(searchVO);
	}

	/**
	 * 승인을 처리한다.
	 * @param searchVO - 승인할 정보
	 * @return 
	 * @exception
	 */
	@Override
	public void bundle(AppTodoVO searchVO) {
		String[] ids = searchVO.getRevertIds();
		if(ids!=null) {
			for (String id : ids) {
				//searchVO.setCol1("111");
				//searchVO.setId(id);
				appTodoDAO.update(searchVO);
			}
		}
	}

	/**
	 * 메모리스트
	 */
	@Override
	public List<AppTodoMemoVO> selectMemoList(SearchVO searchVO) throws Exception {
		return appTodoDAO.selectMemoList(searchVO);
	}

	@Override
	public List<AppTodoVO> selectApprvHis(SearchVO searchVO) throws Exception {
		// TODO Auto-generated method stub
		return appTodoDAO.selectApprvHis(searchVO);
	}
	
}