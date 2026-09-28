package com.woori.ajs.service;

import java.util.List;

import com.woori.ajs.model.WordDictionaryRegBatchVO;

public interface WordDictionaryRegBatchService {

	/**
	 * 완료건(최종액티비티 Block, 승인) 들의 마스터번호 조회
	 * @param wordDictionaryRegBatchVO
	 * @return
	 * @throws Exception
	 */
	List<WordDictionaryRegBatchVO> selectTargetList(WordDictionaryRegBatchVO wordDictionaryRegBatchVO) throws Exception;
	
	/**
	 * 완료건(최종액티비티 Block, 승인) 들의 수기등록 데이터 조회
	 * @param wordDictionaryRegBatchVO
	 * @return
	 * @throws Exception
	 */
	List<WordDictionaryRegBatchVO> selectContentsToRegList(WordDictionaryRegBatchVO wordDictionaryRegBatchVO) throws Exception;
	
	/**
	 * 완료건(최종액티비티 Block, 승인) 들의 수기등록 데이터가 이미 DB 에 등록되어 있는지 조회
	 * @param wordDictionaryRegBatchVO
	 * @return
	 * @throws Exception
	 */
	int selectCountAleadyReg(WordDictionaryRegBatchVO wordDictionaryRegBatchVO) throws Exception;
	
	/**
	 * 완료건(최종액티비티 Block, 승인) 들의 수기등록 데이터를 단어사전 DB 테이블에 INSERT
	 * @param wordDictionaryRegBatchVO
	 * @throws Exception
	 */
	void insertWordDictionary(WordDictionaryRegBatchVO wordDictionaryRegBatchVO) throws Exception;
	
}