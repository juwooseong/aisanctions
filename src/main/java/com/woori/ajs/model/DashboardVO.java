package com.woori.ajs.model;

@SuppressWarnings("serial")
public class DashboardVO {

	//	당일 ToDo, 진행업무별 현재상태, Sanction 심사현황, QA 현황
	private String aiInptCmnCd;
	private String aiInptCmnCdNm;
	private String totalCnt;
	
	// 국가별 수출입 현황
	private String nacd;
	private String korNlNm;
	private String engNlNm;
	private String export_cnt;
	private String import_cnt;
	
	
	public String getAiInptCmnCd() {
		return aiInptCmnCd;
	}
	public void setAiInptCmnCd(String aiInptCmnCd) {
		this.aiInptCmnCd = aiInptCmnCd;
	}
	public String getAiInptCmnCdNm() {
		return aiInptCmnCdNm;
	}
	public void setAiInptCmnCdNm(String aiInptCmnCdNm) {
		this.aiInptCmnCdNm = aiInptCmnCdNm;
	}
	public String getTotalCnt() {
		return totalCnt;
	}
	public void setTotalCnt(String totalCnt) {
		this.totalCnt = totalCnt;
	}
	public String getNacd() {
		return nacd;
	}
	public void setNacd(String nacd) {
		this.nacd = nacd;
	}
	public String getKorNlNm() {
		return korNlNm;
	}
	public void setKorNlNm(String korNlNm) {
		this.korNlNm = korNlNm;
	}
	public String getEngNlNm() {
		return engNlNm;
	}
	public void setEngNlNm(String engNlNm) {
		this.engNlNm = engNlNm;
	}
	public String getExport_cnt() {
		return export_cnt;
	}
	public void setExport_cnt(String export_cnt) {
		this.export_cnt = export_cnt;
	}
	public String getImport_cnt() {
		return import_cnt;
	}
	public void setImport_cnt(String import_cnt) {
		this.import_cnt = import_cnt;
	}
	
}
