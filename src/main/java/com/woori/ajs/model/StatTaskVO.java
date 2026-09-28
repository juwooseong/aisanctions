package com.woori.ajs.model;

public class StatTaskVO {

	private String cate;
	private String inptRcpDt;
	private String auth;
	private String aiInptUserAutCd;
	private String userId;
	private String aiInptUserNm;
	private String countEno;
	private String totalTime;
	private String avgTime;	
	private int imAuth = 0;
	private int exAuth = 0;
	private int imSugi = 0;
	private int exSugi = 0;
	private int qa = 0;
	private int qa2 = 0;
	private String avg;
	private String[][] dateCnt;
	private String[][] imAuthDateSet;
	private String[][] exAuthDateSet;
	private String[][] imSugiDateSet;
	private String[][] exSugiDateSet;
	private String[][] qaDateSet;
	private String[][] qa2DateSet;
	
	
	public int getQa2() {
		return qa2;
	}
	public void setQa2(int qa2) {
		this.qa2 = qa2;
	}
	public String[][] getQa2DateSet() {
		return qa2DateSet;
	}
	public void setQa2DateSet(String[][] qa2DateSet) {
		this.qa2DateSet = qa2DateSet;
	}
	public String[][] getImAuthDateSet() {
		return imAuthDateSet;
	}
	public void setImAuthDateSet(String[][] imAuthDateSet) {
		this.imAuthDateSet = imAuthDateSet;
	}
	public String[][] getExAuthDateSet() {
		return exAuthDateSet;
	}
	public void setExAuthDateSet(String[][] exAuthDateSet) {
		this.exAuthDateSet = exAuthDateSet;
	}
	public String[][] getImSugiDateSet() {
		return imSugiDateSet;
	}
	public void setImSugiDateSet(String[][] imSugiDateSet) {
		this.imSugiDateSet = imSugiDateSet;
	}
	public String[][] getExSugiDateSet() {
		return exSugiDateSet;
	}
	public void setExSugiDateSet(String[][] exSugiDateSet) {
		this.exSugiDateSet = exSugiDateSet;
	}
	public String[][] getQaDateSet() {
		return qaDateSet;
	}
	public void setQaDateSet(String[][] qaDateSet) {
		this.qaDateSet = qaDateSet;
	}
	public String getAvg() {
		return avg;
	}
	public void setAvg(String avg) {
		this.avg = avg;
	}
	public String[][] getDateCnt() {
		return dateCnt;
	}
	public void setDateCnt(String[][] dateCnt) {
		this.dateCnt = dateCnt;
	}
	public String getCate() {
		return cate;
	}
	public void setCate(String cate) {
		this.cate = cate;
	}
	public String getInptRcpDt() {
		return inptRcpDt;
	}
	public void setInptRcpDt(String inptRcpDt) {
		this.inptRcpDt = inptRcpDt;
	}
	public String getAuth() {
		return auth;
	}
	public void setAuth(String auth) {
		this.auth = auth;
	}
	public String getAiInptUserAutCd() {
		return aiInptUserAutCd;
	}
	public void setAiInptUserAutCd(String aiInptUserAutCd) {
		this.aiInptUserAutCd = aiInptUserAutCd;
	}
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public String getAiInptUserNm() {
		return aiInptUserNm;
	}
	public void setAiInptUserNm(String aiInptUserNm) {
		this.aiInptUserNm = aiInptUserNm;
	}
	public String getCountEno() {
		return countEno;
	}
	public void setCountEno(String countEno) {
		this.countEno = countEno;
	}
	public String getTotalTime() {
		return totalTime;
	}
	public void setTotalTime(String totalTime) {
		this.totalTime = totalTime;
	}
	public String getAvgTime() {
		return avgTime;
	}
	public void setAvgTime(String avgTime) {
		this.avgTime = avgTime;
	}
	public int getImAuth() {
		return imAuth;
	}
	public void setImAuth(int imAuth) {
		this.imAuth = imAuth;
	}
	public int getExAuth() {
		return exAuth;
	}
	public void setExAuth(int exAuth) {
		this.exAuth = exAuth;
	}
	public int getImSugi() {
		return imSugi;
	}
	public void setImSugi(int imSugi) {
		this.imSugi = imSugi;
	}
	public int getExSugi() {
		return exSugi;
	}
	public void setExSugi(int exSugi) {
		this.exSugi = exSugi;
	}
	public int getQa() {
		return qa;
	}
	public void setQa(int qa) {
		this.qa = qa;
	}
}