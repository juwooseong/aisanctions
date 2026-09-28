package com.woori.ajs.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.woori.ajs.dao.AppStatusMapper;
import com.woori.ajs.dao.CommonRevertDetailMapper;
import com.woori.ajs.model.AppStatusVO;
import com.woori.ajs.model.AppTodoVO;
import com.woori.ajs.model.CommonRevertDetailVO;
import com.woori.ajs.model.SearchVO;
import com.woori.ajs.service.AppStatusService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.fdl.idgnr.EgovIdGnrService;
import egovframework.ui.cmmn.ArrayUtil;
import egovframework.ui.cmmn.StringUtil;

@Service("appStatusService")
public class AppStatusServiceImpl extends EgovAbstractServiceImpl implements AppStatusService {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(AppStatusServiceImpl.class);
	
	@Resource(name = "appStatusMapper")
	private AppStatusMapper appStatusDAO;
	
	/** ID Generation */
	@Resource(name = "egovIdGnrService")
	private EgovIdGnrService egovIdGnrService;
	
	@Resource(name = "commonRevertDetailMapper")
	private CommonRevertDetailMapper commonRevertDetailDao;

	/**
	 * 글 목록을 조회한다.
	 * 
	 * @param searchVO
	 *            - 조회할 정보가 담긴 VO
	 * @return 글 목록
	 * @exception Exception
	 */
	@Override
	public List<AppStatusVO> selectList(SearchVO searchVO) throws Exception {
		return appStatusDAO.selectList(searchVO);
	}
	
	/**
	 * 글 총 갯수를 조회한다. @param searchVO - 조회할 정보가 담긴 VO @return 글 총 갯수 @exception
	 */
	@Override
	public int selectListTotCnt(SearchVO searchVO) {
		return appStatusDAO.selectListTotCnt(searchVO);
	}
	
	@Override
	public AppTodoVO selectTaskInfo(SearchVO searchVO) {
		return appStatusDAO.selectTaskInfo(searchVO);
	}
	
	@Override
	public int updateTaskAtvtHolding(SearchVO searchVO) throws Exception {
		int successCnt = 0;
		
		if(ArrayUtil.isNotEmpty(searchVO.getIds())) {
			for(int i=0;i<searchVO.getIds().length;i++) {
				int inptMstSrno = Integer.parseInt(StringUtil.nvl(searchVO.getIds()[i],"0"));
				if(inptMstSrno!=0) {
					searchVO.setInptMstSrno(inptMstSrno);
					
					//심사업무 상세정보 가져오기
					AppTodoVO vo = appStatusDAO.selectTaskInfo(searchVO);
					if(vo!=null) {
						//심사업무 마스터 테이블의 액티비티 상태값을 holding 상태 코드값(150)으로 변경처리.
						vo.setInptAtvtcd("150");
						appStatusDAO.updateTaskAtvt(vo);
						
						//상태변경이력에 변경이력 입력처리.
						CommonRevertDetailVO commonRevertDetailVO = new CommonRevertDetailVO();
						commonRevertDetailVO.setInptMstSrno(inptMstSrno);
						commonRevertDetailVO.setAiInptBizDscd(vo.getInptAtmcBizDscd());
						commonRevertDetailVO.setCurtAiInspAtvtCd("150");
						commonRevertDetailVO.setAiInptAcvtStsCd("150");
						commonRevertDetailVO.setAiInptCrpeEno(searchVO.getUserId());
						commonRevertDetailVO.setAiInptPrcOpiTxt("");
						commonRevertDetailVO.setLstDbChgId(searchVO.getUserId());
						commonRevertDetailDao.insertSantionHis(commonRevertDetailVO);
						
						//성공건수 누적.
						successCnt++;
					}
				}
			}
		}
		
		return successCnt;
	}

}