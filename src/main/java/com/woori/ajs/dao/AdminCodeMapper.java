package com.woori.ajs.dao;

import java.util.List;

import com.woori.ajs.model.CodeGrpVO;
import com.woori.ajs.model.CodeVO;
import com.woori.ajs.model.SearchVO;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Mapper("adminCodeMapper")
public interface AdminCodeMapper {
	
	List<CodeGrpVO> selectCodeGrpList(SearchVO searchVO) throws Exception;
	
	CodeGrpVO selectCodeGrp(SearchVO searchVO) throws Exception;
	
	void insertCodeGrp(CodeGrpVO vo) throws Exception;
	
	void deleteCodeGrp(CodeGrpVO vo) throws Exception;
	
	List<CodeVO> selectCodeList(SearchVO searchVO) throws Exception;
	
	CodeVO selectCode(SearchVO searchVO) throws Exception;
	
	void insertCode(CodeVO vo) throws Exception;
	
	void deleteCode(CodeVO vo) throws Exception;
	
}