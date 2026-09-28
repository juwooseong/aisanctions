package com.woori.ajs.dao;

import java.util.List;

import com.woori.ajs.model.SearchVO;
import com.woori.ajs.model.WatchListVO;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Mapper("adminWatchListMapper")
public interface AdminWatchListMapper {

	/**
	 * 카테고리 목록을 조회한다.
	 * @param  
	 * @return 
	 * @exception Exception
	 */
	List<WatchListVO> selectCtgrList(SearchVO searchVO) throws Exception;
	
	/**
	 * 카테고리 상세정보을 조회한다.
	 * @param 
	 * @return 
	 * @exception Exception
	 */
	WatchListVO selectCtgr(SearchVO searchVO) throws Exception;
	
	/**
	 * 리스트 목록을 조회한다.
	 * @param 
	 * @return 
	 * @exception Exception
	 */
	List<WatchListVO> selectGrpList(SearchVO searchVO) throws Exception;
	/**
	 * 리스트 상세정보을 조회한다.
	 * @param 
	 * @return 
	 * @exception Exception
	 * 
	 */
	WatchListVO selectGrp(SearchVO searchVO) throws Exception;
	
	/**
	 * 리스트 목록을 조회한다.
	 * @param 
	 * @return 
	 * @exception Exception
	 */
	List<WatchListVO> selectContList(SearchVO searchVO) throws Exception;
	
	/**
	 * 리스트 상세정보을 조회한다.
	 * @param 
	 * @return 
	 * @exception Exception
	 */
	WatchListVO selectCont(SearchVO searchVO) throws Exception;
	
	/**
	 * 카테고리 정보 등록/수정
	 */
	void insertCtgr(WatchListVO vO) throws Exception;

	/**
	 * 카테고리 신규코드 생성
	 */
	String selectNewCtgrCd() throws Exception;

	/**
	 * 카테고리 정보 삭제
	 */
	void deleteCtgr(WatchListVO vO) throws Exception;
	void insertDateCtgFordelete(WatchListVO vO) throws Exception;
	/**
	 * 리스트 정보 등록/수정
	 */
	void insertGrp(WatchListVO vO) throws Exception;

	/**
	 * 리스트 신규코드 생성
	 */
	String selectNewGrpCd() throws Exception;

	/**
	 * 리스트 정보 삭제
	 */
	void deleteGrp(WatchListVO vO) throws Exception;
	void insertDateGrpFordelete(WatchListVO vO) throws Exception;
	/**
	 * 내용 정보 등록/수정
	 */
	void insertCont(WatchListVO vO) throws Exception;
	
	/**
	 * 내용 신규코드 생성
	 */
	String selectNewContCd() throws Exception;
	
	/**
	 * 내용 정보 삭제
	 */
	void deleteCont(WatchListVO vO) throws Exception;
	void insertDateContFordelete(WatchListVO vO) throws Exception;
}