package com.woori.ajs.service.impl;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.woori.ajs.dao.AdminLogProgramMapper;
import com.woori.ajs.model.AdminLogProgramVO;
import com.woori.ajs.model.LoginVO;
import com.woori.ajs.model.SearchVO;
import com.woori.ajs.service.AdminLogProgramService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.fdl.idgnr.EgovIdGnrService;
import egovframework.ui.cmmn.DateUtil;
import egovframework.ui.cmmn.HttpUtil;
import egovframework.ui.cmmn.StringUtil;
import egovframework.ui.util.LoginUtils;

@Service("adminLogProgramService")
public class AdminLogProgramServiceImpl extends EgovAbstractServiceImpl implements AdminLogProgramService {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(AdminLogProgramServiceImpl.class);
	
	@Resource(name = "adminLogProgramMapper")
	private AdminLogProgramMapper adminLogProgramDAO;
	
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
	public List<AdminLogProgramVO> selectList(SearchVO searchVO) throws Exception {
		return adminLogProgramDAO.selectList(searchVO);
	}
	
	/**
	 * 글 총 갯수를 조회한다. @param searchVO - 조회할 정보가 담긴 VO @return 글 총 갯수 @exception
	 */
	@Override
	public int selectListTotCnt(SearchVO searchVO) {
		return adminLogProgramDAO.selectListTotCnt(searchVO);
	}
	
	@Override
	public String selectTrnLogSrno(SearchVO searchVO) {
		return adminLogProgramDAO.selectTrnLogSrno(searchVO);
	}

	@Override
	public String logProgramInsert(HttpServletRequest request, AdminLogProgramVO adminLogProgramVO, SearchVO searchVO) {
		HashMap<String,Object> map = new HashMap<String,Object>();
		
		HttpUtil.setResult(map, HttpUtil.HttpType.T200);
		
		LoginVO userInfo = LoginUtils.getLoginInfo(request);
		String userId = LoginUtils.getLoginInfo(request).getId();
		searchVO.setUserId(userId);
		AdminLogProgramVO vo = new AdminLogProgramVO();
		
		//프로그램 이력 쌓기
		String aiInptCnctUserNo = userInfo.getId();
		String aiInptCnctIpad = request.getRemoteAddr();
		String aiInptCnctMchrNm = request.getHeader("User-Agent");
		String aiInptCnctScrnNo = adminLogProgramVO.getAiInptCnctScrnNo();
		String aiInptCnctFldCd = adminLogProgramVO.getAiInptCnctFldCd();
		String aiInptCnctActiCd = adminLogProgramVO.getAiInptCnctActiCd();
		String aiInptCnctParmTxt = adminLogProgramVO.getAiInptCnctParmTxt();
		
		// 프로그램 로그행위코드를 112에서 조회 후 사용여부가 비활성화(N) 이면 프로그램 이력 INSERT 구문을 실행하지 않음
		// 화면으로부터 넘어오는 값인 aiInptCnctActiCd 은 하드코딩값이므로 null 체크 필요
		String checkYN = "N";
		if(aiInptCnctActiCd != null) {
			checkYN = selectCheckActionCodeUsingYN(aiInptCnctActiCd);	
		}
		
		// combinePath 거래일자(8) + 사용자ID(8) + 거래시분초(6) + 십만밀리세컨(6) + 관리번호(2)
		String trnLogSrno = selectTrnLogSrno(searchVO);
		
		String lstDbChgId = userInfo.getId();
		
		vo.setAiInptCnctUserNo(aiInptCnctUserNo);
		vo.setAiInptCnctIpad(aiInptCnctIpad);
		vo.setAiInptCnctMchrNm(aiInptCnctMchrNm);
		vo.setAiInptCnctScrnNo(aiInptCnctScrnNo);
		vo.setAiInptCnctFldCd(aiInptCnctFldCd);
		vo.setAiInptCnctActiCd(aiInptCnctActiCd);
		vo.setAiInptCnctParmTxt(aiInptCnctParmTxt);
		vo.setTrnLogSrno(trnLogSrno);
		vo.setLstDbChgId(lstDbChgId);
		
		if("Y".equals(checkYN)) {
			adminLogProgramDAO.insert(vo);	
		}
		
		return trnLogSrno;
	}


	@Override
	public void insert(AdminLogProgramVO vo) {
		// TODO Auto-generated method stub
		adminLogProgramDAO.insert(vo);
	}

	@Override
	public String selectCheckActionCodeUsingYN(String value){
		return adminLogProgramDAO.selectCheckActionCodeUsingYN(value);
	}

	@Override
	public List<Map<String, Object>> customQueryTest(SearchVO searchVO) {
		return adminLogProgramDAO.customQueryTest(searchVO);
	}

}