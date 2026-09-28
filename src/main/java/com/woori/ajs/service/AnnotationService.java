package com.woori.ajs.service;

import java.util.HashMap;

import com.woori.ajs.model.AnnotationPageSaveRequest;

public interface AnnotationService {

	HashMap<String, Object> load(Long inptMstSrno) throws Exception;

	HashMap<String, Object> savePage(Long inptMstSrno, AnnotationPageSaveRequest req, String loginEno,
			String trnLogSrno) throws Exception;
}
