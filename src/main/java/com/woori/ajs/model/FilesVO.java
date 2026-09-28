package com.woori.ajs.model;

import java.io.File;
import java.util.HashMap;
import java.util.List;

public class FilesVO {
	private List<HashMap<String,String>> files;
	private List<FileVO> files2;
	private List<File> files3;
	
	public List<HashMap<String, String>> getFiles() {
		return files;
	}
	public void setFiles(List<HashMap<String, String>> files) {
		this.files = files;
	}
	public List<FileVO> getFiles2() {
		return files2;
	}
	public void setFiles2(List<FileVO> files2) {
		this.files2 = files2;
	}
	public List<File> getFiles3() {
		return files3;
	}
	public void setFiles3(List<File> files3) {
		this.files3 = files3;
	}
}