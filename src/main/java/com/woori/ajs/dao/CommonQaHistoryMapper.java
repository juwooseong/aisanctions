package com.woori.ajs.dao;

import java.util.List;

import com.woori.ajs.model.SearchVO;
import com.woori.ajs.model.CommonHistoryListVO;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Mapper("commonQaHistoryMapper")
public interface CommonQaHistoryMapper {
	List<CommonHistoryListVO> selectList(SearchVO vo) throws Exception;
	int selectListTotCnt(SearchVO vo);
	void insertFileUpload(CommonHistoryListVO vo);
	List<CommonHistoryListVO> selectFileList(SearchVO vo) throws Exception;
	int selectFileListTotCnt(SearchVO vo) throws Exception;
	void delUploadedFile(SearchVO vo) throws Exception;
	List<CommonHistoryListVO> selectFileInfo(SearchVO vo) throws Exception;
	CommonHistoryListVO selectOpt(SearchVO vo) throws Exception;
	void updateOpt(SearchVO vo) throws Exception;
}