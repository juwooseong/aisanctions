package com.woori.ajs.model;

@SuppressWarnings("serial")
public class StatAnalysisVO{
	private String day;
	private String nomal;
	private String ta;
	private String textNonExtr;
	private String aicr;
	private String mas;
	
	
	public String getMas() {
		return mas;
	}
	public void setMas(String mas) {
		this.mas = mas;
	}
	public String getDay() {
		return day;
	}
	public void setDay(String day) {
		this.day = day;
	}
	public String getNomal() {
		return nomal;
	}
	public void setNomal(String nomal) {
		this.nomal = nomal;
	}
	public String getTa() {
		return ta;
	}
	public void setTa(String ta) {
		this.ta = ta;
	}
	public String getTextNonExtr() {
		return textNonExtr;
	}
	public void setTextNonExtr(String textNonExtr) {
		this.textNonExtr = textNonExtr;
	}
	public String getAicr() {
		return aicr;
	}
	public void setAicr(String aicr) {
		this.aicr = aicr;
	}
}