package com.woori.ajs.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.woori.ajs.dao.RevertStatAlertMapper;
import com.woori.ajs.model.RevertStatAlertVO;
import com.woori.ajs.model.SearchVO;
import com.woori.ajs.service.RevertStatAlertService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.fdl.idgnr.EgovIdGnrService;
import egovframework.ui.cmmn.StringUtil;

@Service("revertStatAlertService")
public class RevertStatAlertServiceImpl extends EgovAbstractServiceImpl implements RevertStatAlertService {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(RevertStatAlertServiceImpl.class);
	
	@Resource(name = "revertStatAlertMapper")
	private RevertStatAlertMapper revertStatAlertDAO;
	
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
	public List<RevertStatAlertVO> selectList(SearchVO searchVO) throws Exception {
		List<RevertStatAlertVO> list = revertStatAlertDAO.selectList(searchVO);
		
		
		/*//보안관련 처리
		if(list!=null && list.size() > 0) {
			for(int i=0;i<list.size();i++) {
				RevertStatAlertVO row = list.get(i);
				row.setAiInspeEnm(StringUtil.getUserNm(row.getAiInspeEnm()));
				row.setAiAppvEnm(StringUtil.getUserNm(row.getAiAppvEnm()));
			}
		}*/
		return list;
	}
	
	/**
	 * 글 총 갯수를 조회한다. @param searchVO - 조회할 정보가 담긴 VO @return 글 총 갯수 @exception
	 */
	@Override
	public int selectListTotCnt(SearchVO searchVO) {
		return revertStatAlertDAO.selectListTotCnt(searchVO);
	}

}