package com.woori.ajs.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.woori.ajs.model.AnnotationVO;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Mapper("annotationMapper")
public interface AnnotationMapper {

	List<AnnotationVO> selectByMst(@Param("inptMstSrno") Long inptMstSrno);

	Long nextSrno();

	int disableByPage(@Param("inptMstSrno") Long inptMstSrno, @Param("inptTaskId") String inptTaskId,
			@Param("loginEno") String loginEno);

	void insert(AnnotationVO vo);
}
