
package com.woori.ajs.dao;

import java.util.List;

import com.woori.ajs.model.SearchVO;
import com.woori.ajs.model.AdminSanctionRule1VO;
import com.woori.ajs.model.AdminSanctionRule2VO;
import com.woori.ajs.model.AdminSanctionRule3VO;
import com.woori.ajs.model.AdminSanctionVO;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Mapper("adminSanctionMapper")
public interface AdminSanctionMapper {
	List<AdminSanctionRule1VO> selectListRule1(SearchVO searchVO) throws Exception;
	List<AdminSanctionRule2VO> selectListRule2(SearchVO searchVO) throws Exception;
	List<AdminSanctionRule3VO> selectListRule3(SearchVO searchVO) throws Exception;
	List<AdminSanctionRule1VO> selectInfoRule1(String num) throws Exception;
	List<AdminSanctionRule2VO> selectInfoRule2(String num) throws Exception;
	List<AdminSanctionRule3VO> selectInfoRule3(String num) throws Exception;
	List<AdminSanctionVO> RequestTable(SearchVO searchVO) throws Exception;
	void insertRequestTable(AdminSanctionVO vo) throws Exception;
	void insertRequestTable2(AdminSanctionVO vo) throws Exception;
	void insertRequestTable3(AdminSanctionVO vo) throws Exception;
	List<AdminSanctionRule1VO> selectListCheckRule1(AdminSanctionRule1VO vo) throws Exception;
	List<AdminSanctionRule2VO> selectListCheckRule2(AdminSanctionRule2VO vo) throws Exception;
	void insertRule1(AdminSanctionRule1VO vo) throws Exception;
	void insertRule2(AdminSanctionRule2VO vo) throws Exception;
	void insertRule3(AdminSanctionRule3VO vo) throws Exception;
	void deleteRule1(AdminSanctionRule1VO vo) throws Exception;
	void deleteRule2(AdminSanctionRule2VO vo) throws Exception;
	void deleteRule3(AdminSanctionRule3VO vo) throws Exception;
}