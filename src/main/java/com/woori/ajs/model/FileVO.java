package com.woori.ajs.model;

import java.util.HashMap;

import egovframework.ui.cmmn.StringUtil;

public class FileVO {
	private String fileOrgName;
	private long fileSize;
	private String fileExt;
	private String fileSaveName;
	private String fileSavePath;
	private String uploadPath;
	private String uploadUrl;
	
	public String getFileOrgName() {
		return fileOrgName;
	}
	public void setFileOrgName(String fileOrgName) {
		this.fileOrgName = fileOrgName;
	}
	public String getFileExt() {
		return fileExt;
	}
	public void setFileExt(String fileExt) {
		this.fileExt = fileExt;
	}
	public String getFileSaveName() {
		return fileSaveName;
	}
	public void setFileSaveName(String fileSaveName) {
		this.fileSaveName = fileSaveName;
	}
	public String getFileSavePath() {
		return fileSavePath;
	}
	public void setFileSavePath(String fileSavePath) {
		this.fileSavePath = fileSavePath;
	}
	public String getUploadPath() {
		return uploadPath;
	}
	public void setUploadPath(String uploadPath) {
		this.uploadPath = uploadPath;
	}
	public String getUploadUrl() {
		return uploadUrl;
	}
	public void setUploadUrl(String uploadUrl) {
		this.uploadUrl = uploadUrl;
	}
	public long getFileSize() {
		return fileSize;
	}
	public void setFileSize(long fileSize) {
		this.fileSize = fileSize;
	}
	
	public FileVO(HashMap<String,String> fileInfo) {
		setMap(fileInfo);
	}
	
	public void setMap(HashMap<String,String> fileInfo) {
		setFileOrgName(fileInfo.get("fileOrgName"));
		setFileSize(Long.parseLong(StringUtil.nvl(fileInfo.get("fileSize"),"0")));
		setFileExt(fileInfo.get("fileExt"));
		setFileSaveName(fileInfo.get("fileSaveName"));
		setFileSavePath(fileInfo.get("fileSavePath"));
		setUploadPath(fileInfo.get("uploadPath"));
		setUploadUrl(fileInfo.get("uploadUrl"));
	}

	public HashMap<String,String> toMap() {
		HashMap<String,String> fileInfo = new HashMap<String,String>();
		fileInfo.put("fileOrgName",getFileOrgName());
		fileInfo.put("fileSize",String.valueOf(getFileSize()));
		fileInfo.put("fileExt",getFileExt());
		fileInfo.put("fileSaveName",getFileSaveName());
		fileInfo.put("fileSavePath",getFileSavePath());
		fileInfo.put("uploadPath",getUploadPath());
		fileInfo.put("uploadUrl",getUploadUrl());
		return fileInfo;
	}
	
	@Override
	public String toString() {
		StringBuffer sb = new StringBuffer();
		
		sb.append(System.getProperty("\n fileOrgName : " + getFileOrgName()));
		sb.append(System.getProperty("\n fileSize : "+getFileSize()));
		sb.append(System.getProperty("\n fileExt : "+getFileExt()));
		sb.append(System.getProperty("\n fileSaveName : "+getFileSaveName()));
		sb.append(System.getProperty("\n fileSavePath : "+getFileSavePath()));
		sb.append(System.getProperty("\n uploadPath : "+getUploadPath()));
		sb.append(System.getProperty("\n uploadUrl : "+getUploadUrl()));
		return sb.toString();
	}
	
}