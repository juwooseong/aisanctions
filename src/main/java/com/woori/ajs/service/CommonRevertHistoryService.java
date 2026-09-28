package com.woori.ajs.service;

import java.util.HashMap;
import java.util.List;

import com.woori.ajs.model.CommonHistoryListVO;
import com.woori.ajs.model.SearchVO;


public interface CommonRevertHistoryService {
	List<CommonHistoryListVO> selectList(SearchVO vo) throws Exception;
	int selectListTotCnt(SearchVO vo);
//	void insertFileUpload(List<HashMap<String,String>> files, CommonHistoryListVO vo);
	List<CommonHistoryListVO> selectFileList(SearchVO vo) throws Exception;
	int selectFileListTotCnt(SearchVO vo) throws Exception;
	void delUploadedFile(SearchVO vo);
	List<CommonHistoryListVO> selectFileInfo(SearchVO vo) throws Exception;
	void insertFileUpload(List<HashMap<String, String>> files, CommonHistoryListVO vo, int EndcountCnt);
	CommonHistoryListVO selectOpt(SearchVO vo) throws Exception;
	void updateOpt(SearchVO vo) throws Exception;
}