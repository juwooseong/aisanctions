package com.woori.ajs.service;

import java.util.List;

import com.woori.ajs.model.LoginVO;

public interface CommonLoginService {
	List<LoginVO> selectLoginList(LoginVO vo) throws Exception;
	int selectLoginListTotCnt(LoginVO vo);
	LoginVO selectLogin(LoginVO vo) throws Exception;
	String selectLoginTime(LoginVO vo);
}