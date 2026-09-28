package com.woori.ajs.model;

public class QaTargetBatchVO extends TaskVO {
	private String aiInptQaAppvPrgStcd;		//qa결재상태코드
	private String aiInptQaPrcsCd;			//qa프로세스코드 (그룹코드 : 280), 3 - qa totaltext, 4 - qa 항목심사, 5 - qa safewatch
	private String aiInptQaInspAtvtCd;		//qa액티비티코드
	private String qlasCrpeFnm;				//QA담당자직원명
	private String qlasCrpeEno;				//QA담당자직원번호
	private String qlasAppvEno;				//품질보증결재자직원번호
	private String qlasAlocDt;				//품질보증결재자배정일
	
	private String aiInptBizDscd;			//이력-업무구분코드
	private String curtAiInspAtvtCd;		//이력-액티비티코그
	private String aiInptAcvtStsCd;			//이력-상태코드
	private String aiInptCrpeEno;			//이력-담당직원번호
	private String lstDbChgId;				//이력-변경ID
	private String trnLogSrno;				//trnLogSrno

	
	
	public String getTrnLogSrno() {
		return trnLogSrno;
	}
	public void setTrnLogSrno(String trnLogSrno) {
		this.trnLogSrno = trnLogSrno;
	}
	public String getAiInptQaAppvPrgStcd() {
		return aiInptQaAppvPrgStcd;
	}
	public void setAiInptQaAppvPrgStcd(String aiInptQaAppvPrgStcd) {
		this.aiInptQaAppvPrgStcd = aiInptQaAppvPrgStcd;
	}
	public String getAiInptQaPrcsCd() {
		return aiInptQaPrcsCd;
	}
	public void setAiInptQaPrcsCd(String aiInptQaPrcsCd) {
		this.aiInptQaPrcsCd = aiInptQaPrcsCd;
	}
	public String getAiInptQaInspAtvtCd() {
		return aiInptQaInspAtvtCd;
	}
	public void setAiInptQaInspAtvtCd(String aiInptQaInspAtvtCd) {
		this.aiInptQaInspAtvtCd = aiInptQaInspAtvtCd;
	}
	public String getQlasCrpeFnm() {
		return qlasCrpeFnm;
	}
	public void setQlasCrpeFnm(String qlasCrpeFnm) {
		this.qlasCrpeFnm = qlasCrpeFnm;
	}
	public String getQlasCrpeEno() {
		return qlasCrpeEno;
	}
	public void setQlasCrpeEno(String qlasCrpeEno) {
		this.qlasCrpeEno = qlasCrpeEno;
	}
	public String getQlasAppvEno() {
		return qlasAppvEno;
	}
	public void setQlasAppvEno(String qlasAppvEno) {
		this.qlasAppvEno = qlasAppvEno;
	}
	public String getQlasAlocDt() {
		return qlasAlocDt;
	}
	public void setQlasAlocDt(String qlasAlocDt) {
		this.qlasAlocDt = qlasAlocDt;
	}
	public String getAiInptBizDscd() {
		return aiInptBizDscd;
	}
	public void setAiInptBizDscd(String aiInptBizDscd) {
		this.aiInptBizDscd = aiInptBizDscd;
	}
	public String getCurtAiInspAtvtCd() {
		return curtAiInspAtvtCd;
	}
	public void setCurtAiInspAtvtCd(String curtAiInspAtvtCd) {
		this.curtAiInspAtvtCd = curtAiInspAtvtCd;
	}
	public String getAiInptAcvtStsCd() {
		return aiInptAcvtStsCd;
	}
	public void setAiInptAcvtStsCd(String aiInptAcvtStsCd) {
		this.aiInptAcvtStsCd = aiInptAcvtStsCd;
	}
	public String getAiInptCrpeEno() {
		return aiInptCrpeEno;
	}
	public void setAiInptCrpeEno(String aiInptCrpeEno) {
		this.aiInptCrpeEno = aiInptCrpeEno;
	}
	public String getLstDbChgId() {
		return lstDbChgId;
	}
	public void setLstDbChgId(String lstDbChgId) {
		this.lstDbChgId = lstDbChgId;
	}
	
	
}