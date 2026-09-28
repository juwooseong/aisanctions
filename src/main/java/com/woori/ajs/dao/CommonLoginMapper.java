package com.woori.ajs.dao;

import java.util.List;

import com.woori.ajs.model.LoginVO;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Mapper("commonLoginMapper")
public interface CommonLoginMapper {
	List<LoginVO> selectLoginList(LoginVO vo) throws Exception;
	int selectLoginListTotCnt(LoginVO vo);
	LoginVO selectLogin(LoginVO vo) throws Exception;
	String selectLoginTime(LoginVO vo);
}