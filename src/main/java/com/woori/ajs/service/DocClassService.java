package com.woori.ajs.service;

import java.util.HashMap;

import com.woori.ajs.model.DocClassSaveRequest;

public interface DocClassService {

	HashMap<String, Object> load(int inptMstSrno) throws Exception;

	HashMap<String, Object> save(DocClassSaveRequest req, String loginEno, String trnLogSrno) throws Exception;
}
