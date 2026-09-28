package com.woori.ajs.model;

public class AdminBusinessDayVO{
	
	private String basDt; // 기준일자
	private String wkdCd; // 요일코드
	private String hldyDscd; // 휴일구분코드
	private String hldyTxt; // 휴일내용
	private String trnLogSrno; // 거래로그일련번호
	private String lstDbChgId; // 최종DB변경ID
	private String lstDbChgDtm; // 최종DB변경일시
	
	private String[] basDts;
	private String[] hldyDscds;
	private String[] hldyTxts;
	private String[] wkdCds;
	
	
	public String[] getWkdCds() {
		return wkdCds;
	}
	public void setWkdCds(String[] wkdCds) {
		this.wkdCds = wkdCds;
	}
	public String[] getBasDts() {
		return basDts;
	}
	public void setBasDts(String[] basDts) {
		this.basDts = basDts;
	}
	public String[] getHldyDscds() {
		return hldyDscds;
	}
	public void setHldyDscds(String[] hldyDscds) {
		this.hldyDscds = hldyDscds;
	}
	public String[] getHldyTxts() {
		return hldyTxts;
	}
	public void setHldyTxts(String[] hldyTxts) {
		this.hldyTxts = hldyTxts;
	}
	public String getBasDt() {
		return basDt;
	}
	public void setBasDt(String basDt) {
		this.basDt = basDt;
	}
	public String getWkdCd() {
		return wkdCd;
	}
	public void setWkdCd(String wkdCd) {
		this.wkdCd = wkdCd;
	}
	public String getHldyDscd() {
		return hldyDscd;
	}
	public void setHldyDscd(String hldyDscd) {
		this.hldyDscd = hldyDscd;
	}
	public String getHldyTxt() {
		return hldyTxt;
	}
	public void setHldyTxt(String hldyTxt) {
		this.hldyTxt = hldyTxt;
	}
	public String getTrnLogSrno() {
		return trnLogSrno;
	}
	public void setTrnLogSrno(String trnLogSrno) {
		this.trnLogSrno = trnLogSrno;
	}
	public String getLstDbChgId() {
		return lstDbChgId;
	}
	public void setLstDbChgId(String lstDbChgId) {
		this.lstDbChgId = lstDbChgId;
	}
	public String getLstDbChgDtm() {
		return lstDbChgDtm;
	}
	public void setLstDbChgDtm(String lstDbChgDtm) {
		this.lstDbChgDtm = lstDbChgDtm;
	}
	
	
}