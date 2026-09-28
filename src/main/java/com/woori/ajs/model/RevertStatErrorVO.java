package com.woori.ajs.model;

public class RevertStatErrorVO extends TaskVO {
	private String errCd;				//오류구분코드(310)
	private String errTxt;				//오류구분텍스트
	
	public String getErrCd() {
		return errCd;
	}
	public void setErrCd(String errCd) {
		this.errCd = errCd;
	}
	public String getErrTxt() {
		return errTxt;
	}
	public void setErrTxt(String errTxt) {
		this.errTxt = errTxt;
	}
}