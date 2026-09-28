package com.woori.ajs.dao;

import java.util.List;

import com.woori.ajs.model.CommonSanctionStatVO;
import com.woori.ajs.model.SearchVO;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Mapper("commonSanctionStatMapper")
public interface CommonSanctionStatMapper {
	// WatchList list
	List<CommonSanctionStatVO> selectWatchList() throws Exception;
	// 심사원장마스터키  Data
	List<CommonSanctionStatVO> selectInptMstSrnoList(SearchVO vo) throws Exception;
	// 항목추출 결과 Data
	List<CommonSanctionStatVO> selectSanctionList(SearchVO vo) throws Exception;
	// WatchList Item Data
	List<CommonSanctionStatVO> selectWatchItemList(SearchVO vo) throws Exception;
}
