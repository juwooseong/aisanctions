package com.woori.ajs.model;

/**
 * TA 파일 저장,불러오기,삭제 API 모델
 */
public class FileApiVO {
	private String key;				//파일 저장,불러오기,삭제시 고유키값
	private String file;
	
	public String getKey() {
		return key;
	}
	
	public void setKey(String key) {
		this.key = key;
	}
	
	public String getFile() {
		return file;
	}

	public void setFile(String file) {
		this.file = file;
	}
	
}