package com.woori.ajs.service.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import com.woori.ajs.dao.AdminStatusMapper;
import com.woori.ajs.model.SearchVO;
import com.woori.ajs.model.AdminStatusTablesVO;
import com.woori.ajs.model.AdminStatusVO;
import com.woori.ajs.model.CommonRevertDetailVO;
import com.woori.ajs.service.AdminStatusService;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.fdl.idgnr.EgovIdGnrService;

@Service("adminStatusService")
public class AdminStatusServiceImpl extends EgovAbstractServiceImpl implements AdminStatusService {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(AdminStatusServiceImpl.class);
	
	//@Resource(name = "revertStatCompleteMapper")
	//private RevertStatCompleteMapper revertStatCompleteDAO;
	
	@Resource(name = "adminStatusMapper")
	private AdminStatusMapper adminStatusDAO;
	
	/** ID Generation */
	@Resource(name = "egovIdGnrService")
	private EgovIdGnrService egovIdGnrService;

	@Override
	public List<AdminStatusVO> selectList(SearchVO searchVO) throws Exception {
		return adminStatusDAO.selectList(searchVO);
	}

	@Override
	public List<AdminStatusVO> selectDailyList(SearchVO searchVO) throws Exception {
		return adminStatusDAO.selectDailyList(searchVO);
	}
	
	@Override
	public int selectListTotCnt(SearchVO searchVO) {
		return adminStatusDAO.selectListTotCnt(searchVO);
	}

	@Override
	public void statusActivityUpdate(AdminStatusVO adminStatusVO) {
		adminStatusDAO.statusActivityUpdate(adminStatusVO);
	}

	@Override
	public void statusActivityModHistory(CommonRevertDetailVO commonRevertDetailVO) {
		adminStatusDAO.statusActivityModHistory(commonRevertDetailVO);
	}

	@Override
	public void statusReprocess(AdminStatusVO adminStatusVO) {
		adminStatusDAO.statusReprocess(adminStatusVO);
	}

	@Override
	public void statusDeleteMaster(AdminStatusVO adminStatusVO) {
		adminStatusDAO.statusDeleteMaster(adminStatusVO);
	}

	@Override
	public void statusDeleteMasterDetail(AdminStatusVO adminStatusVO) {
		adminStatusDAO.statusDeleteMasterDetail(adminStatusVO);		
	}

	@Override
	public void statusDeleteHistory(AdminStatusVO adminStatusVO) {
		adminStatusDAO.statusDeleteHistory(adminStatusVO);
	}

	@Override
	public void statusDeleteQueue(AdminStatusVO adminStatusVO) {
		adminStatusDAO.statusDeleteQueue(adminStatusVO);
	}
	@Override
	public List<AdminStatusTablesVO> queryTest(SearchVO vo) throws Exception {
		return adminStatusDAO.queryTest(vo);
	}

	@Override
	public void queryTestUpdate(SearchVO vo) throws Exception {
		adminStatusDAO.queryTestUpdate(vo);
		return;
	}

	@Override
	public List<AdminStatusTablesVO> queryTestDefault(SearchVO vo) throws Exception {
		return adminStatusDAO.queryTestDefault(vo);
	}

	@Override
	public void queryTestInsert(SearchVO vo) throws Exception {
		adminStatusDAO.queryTestInsert(vo);
		
	}

	@Override
	public void queryTestDelete(SearchVO vo) throws Exception {
		adminStatusDAO.queryTestDelete(vo);
		
	}

	@Override
	public List<AdminStatusVO> selectAsideList() throws Exception {
		return adminStatusDAO.selectAsideList();
	}

	@Override
	public String selectAsideInterval() throws Exception {
		return adminStatusDAO.selectAsideInterval();
	}

	@Override
	public int selectAsideUngeneratedCount() throws Exception {
		return adminStatusDAO.selectAsideUngeneratedCount();
	}

	@Override
	public List<Map<String, Object>> queryTestNew(SearchVO vo) throws Exception {
		return adminStatusDAO.queryTestNew(vo);
	}

	

}