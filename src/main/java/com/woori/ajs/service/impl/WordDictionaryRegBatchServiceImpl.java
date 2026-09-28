package com.woori.ajs.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.woori.ajs.dao.QaTargetBatchMapper;
import com.woori.ajs.dao.WordDictionaryRegBatchMapper;
import com.woori.ajs.model.QaTargetBatchVO;
import com.woori.ajs.model.SearchVO;
import com.woori.ajs.model.WordDictionaryRegBatchVO;
import com.woori.ajs.service.QaTargetBatchService;
import com.woori.ajs.service.WordDictionaryRegBatchService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.fdl.idgnr.EgovIdGnrService;

@Service("wordDictionaryRegBatchService")
public class WordDictionaryRegBatchServiceImpl extends EgovAbstractServiceImpl implements WordDictionaryRegBatchService {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(WordDictionaryRegBatchServiceImpl.class);
	
	@Resource(name = "wordDictionaryRegBatchMapper")
	private WordDictionaryRegBatchMapper wordDictionaryRegBatchMapperDAO;
	
	/** ID Generation */
	@Resource(name = "egovIdGnrService")
	private EgovIdGnrService egovIdGnrService;

	@Override
	public List<WordDictionaryRegBatchVO> selectTargetList(WordDictionaryRegBatchVO wordDictionaryRegBatchVO) throws Exception {
		return wordDictionaryRegBatchMapperDAO.selectTargetList(wordDictionaryRegBatchVO);
	}

	@Override
	public List<WordDictionaryRegBatchVO> selectContentsToRegList(WordDictionaryRegBatchVO wordDictionaryRegBatchVO) throws Exception {
		return wordDictionaryRegBatchMapperDAO.selectContentsToRegList(wordDictionaryRegBatchVO);
	}

	@Override
	public int selectCountAleadyReg(WordDictionaryRegBatchVO wordDictionaryRegBatchVO) throws Exception {
		return wordDictionaryRegBatchMapperDAO.selectCountAleadyReg(wordDictionaryRegBatchVO);
	}

	@Override
	public void insertWordDictionary(WordDictionaryRegBatchVO wordDictionaryRegBatchVO) throws Exception {
		wordDictionaryRegBatchMapperDAO.insertWordDictionary(wordDictionaryRegBatchVO);
	}
	
}