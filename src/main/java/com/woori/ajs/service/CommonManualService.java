package com.woori.ajs.service;

import java.util.List;

import com.woori.ajs.model.SearchVO;
import com.woori.ajs.model.CommonManualVO;
import com.woori.ajs.model.CommonMenuVO;

public interface CommonManualService {

	/**
	 * 글 목록을 조회한다.
	 * @param searchVO - 조회할 정보가 담긴 VO
	 * @return 글 목록
	 * @exception Exception
	 */
	List<CommonManualVO> selectList(SearchVO searchVO) throws Exception;

	/**
	 * 글 총 갯수를 조회한다.
	 * @param searchVO - 조회할 정보가 담긴 VO
	 * @return 글 총 갯수
	 * @exception
	 */
	int selectListTotCnt(SearchVO searchVO);

	void insertFileUpload(CommonManualVO commonManualVO) throws Exception;
	
	List<CommonManualVO> selectFileInfo(SearchVO searchVO) throws Exception;
	
	void delUploadedFile(SearchVO searchVO) throws Exception;
}