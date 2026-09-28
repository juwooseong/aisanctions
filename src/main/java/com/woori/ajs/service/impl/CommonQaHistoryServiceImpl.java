package com.woori.ajs.service.impl;

import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.woori.ajs.dao.CommonQaHistoryMapper;
import com.woori.ajs.model.CommonHistoryListVO;
import com.woori.ajs.model.SearchVO;
import com.woori.ajs.service.CommonQaHistoryService;

import egovframework.rte.fdl.idgnr.EgovIdGnrService;

@Service("commonQaHistoryService")
public class CommonQaHistoryServiceImpl implements CommonQaHistoryService {

	private static final Logger LOGGER = LoggerFactory.getLogger(CommonQaHistoryServiceImpl.class);

	@Resource(name="commonQaHistoryMapper")
	private CommonQaHistoryMapper commonQaHistoryDAO;
	
	@Resource(name="egovIdGnrService")
	private EgovIdGnrService egovIdGnrService;

	@Override
	public List<CommonHistoryListVO> selectList(SearchVO vo) throws Exception {
		return commonQaHistoryDAO.selectList(vo);
	}

	@Override
	public int selectListTotCnt(SearchVO vo) {
		return commonQaHistoryDAO.selectListTotCnt(vo);
	}

	@Override
	public void insertFileUpload(List<HashMap<String,String>> files, CommonHistoryListVO vo, int EndcountCnt) {
		String uploadUrl = null; // key 값
		String fileOrigName = null;
		if(EndcountCnt == -1) {
			for(int i=0; i<files.size(); i++) {
				HashMap<String,String> file = files.get(i);
				uploadUrl = file.get("uploadUrl");
				vo.setAiInptAtflPathTxt(uploadUrl);
				fileOrigName = file.get("fileOrgName");
				vo.setAiInptAtflNm(fileOrigName);
				commonQaHistoryDAO.insertFileUpload(vo);
				if(i == 9) {
					break;
				}
			}
		}else {
			for(int i=0; i<files.size(); i++) {
				if(i==EndcountCnt) {
					break;
				}
				HashMap<String,String> file = files.get(i);
				uploadUrl = file.get("uploadUrl");
				vo.setAiInptAtflPathTxt(uploadUrl);
				fileOrigName = file.get("fileOrgName");
				vo.setAiInptAtflNm(fileOrigName);
				commonQaHistoryDAO.insertFileUpload(vo);
			}
		}
		return;
	}

	@Override
	public List<CommonHistoryListVO> selectFileList(SearchVO vo) throws Exception {
		return commonQaHistoryDAO.selectFileList(vo);
	}

	@Override
	public int selectFileListTotCnt(SearchVO vo) throws Exception {
		return commonQaHistoryDAO.selectFileListTotCnt(vo);
	}

	@Override
	public void delUploadedFile(SearchVO vo) {
		try {
			commonQaHistoryDAO.delUploadedFile(vo);
		} catch (Exception e) {
			LOGGER.error("Exception ::: " + e);
		}
		return; 
	}

	@Override
	public List<CommonHistoryListVO> selectFileInfo(SearchVO vo) throws Exception {
		return commonQaHistoryDAO.selectFileInfo(vo);
	}
	
	@Override
	public CommonHistoryListVO selectOpt(SearchVO vo) throws Exception {
		return commonQaHistoryDAO.selectOpt(vo);
	}

	@Override
	public void updateOpt(SearchVO vo) throws Exception {
		commonQaHistoryDAO.updateOpt(vo);
		return;
	}
}