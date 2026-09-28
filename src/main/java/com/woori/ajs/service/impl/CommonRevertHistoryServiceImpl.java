package com.woori.ajs.service.impl;

import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.woori.ajs.dao.CommonRevertHistoryMapper;
import com.woori.ajs.dao.QaStatusMapper;
import com.woori.ajs.model.CommonHistoryListVO;
import com.woori.ajs.model.SearchVO;
import com.woori.ajs.service.CommonRevertHistoryService;

import egovframework.rte.fdl.idgnr.EgovIdGnrService;

@Service("commonRevertHistoryService")
public class CommonRevertHistoryServiceImpl implements CommonRevertHistoryService {

	private static final Logger LOGGER = LoggerFactory.getLogger(CommonRevertHistoryServiceImpl.class);
	
	@Resource(name="commonRevertHistoryMapper")
	private CommonRevertHistoryMapper commonRevertHistoryDAO;
	
	@Resource(name="egovIdGnrService")
	private EgovIdGnrService egovIdGnrService;

	@Override
	public List<CommonHistoryListVO> selectList(SearchVO vo) throws Exception {
		return commonRevertHistoryDAO.selectList(vo);
	}

	@Override
	public int selectListTotCnt(SearchVO vo) {
		return commonRevertHistoryDAO.selectListTotCnt(vo);
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
				commonRevertHistoryDAO.insertFileUpload(vo);
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
				commonRevertHistoryDAO.insertFileUpload(vo);
			}
		}
		return;
	}

	@Override
	public List<CommonHistoryListVO> selectFileList(SearchVO vo) throws Exception {
		return commonRevertHistoryDAO.selectFileList(vo);
	}

	@Override
	public int selectFileListTotCnt(SearchVO vo) throws Exception {
		return commonRevertHistoryDAO.selectFileListTotCnt(vo);
	}

	@Override
	public void delUploadedFile(SearchVO vo) {
		try {
			commonRevertHistoryDAO.delUploadedFile(vo);
		} catch (Exception e) {
			LOGGER.error("Exception ::: " + e);
		}
		return; 
	}

	@Override
	public List<CommonHistoryListVO> selectFileInfo(SearchVO vo) throws Exception {
		return commonRevertHistoryDAO.selectFileInfo(vo);
	}

	@Override
	public CommonHistoryListVO selectOpt(SearchVO vo) throws Exception {
		return commonRevertHistoryDAO.selectOpt(vo);
	}

	@Override
	public void updateOpt(SearchVO vo) throws Exception {
		commonRevertHistoryDAO.updateOpt(vo);
		return;
	}

}