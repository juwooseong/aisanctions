package com.woori.ajs.model;

import java.util.List;

public class RevertUngeneratedVO{
	
	private String actlFxRefno;
	private String fxRefnoSrno;
	private String inptRcpDt;
	private String inptAtmcBizDscd;
	private String aiInptDocScanChrgEno;
	private String aiInptDocScanDtm;
	private String aiInptImgKeyNo;
	private String aiInptAplXtRncd;
	private String aiInptXtPrcStsDscd;
	private String aiInptXtPrcEno;
	private String aiInptXtPrcDtm;
	private String trnLogSrno;
	private String lstDbChgId;
	private String lstDbChgDtm;
	private String aiInptXtSrno;
	
	private String trnOprNo; // 201 & 202 의 조작자 사번
	
	private String docScanNm; // 스캔자명
	private String trnOprNm; // 조작자명
	private String procNm; // 처리자 명
	
	private String aiInptAplXtRncdNm; // 제외사유명
	private String inptAtmcBizDscdNm; // 업무구분명
	private String aiInptXtPrcStsDscdNm; // 처리상태명
	
	private List<RevertUngeneratedVO> mainList;
	private String[] actlFxRefnos;
	private String[] aiInptXtSrnos;
	
	
	
	public String getAiInptAplXtRncdNm() {
		return aiInptAplXtRncdNm;
	}
	public void setAiInptAplXtRncdNm(String aiInptAplXtRncdNm) {
		this.aiInptAplXtRncdNm = aiInptAplXtRncdNm;
	}
	public String getInptAtmcBizDscdNm() {
		return inptAtmcBizDscdNm;
	}
	public void setInptAtmcBizDscdNm(String inptAtmcBizDscdNm) {
		this.inptAtmcBizDscdNm = inptAtmcBizDscdNm;
	}
	public String getAiInptXtPrcStsDscdNm() {
		return aiInptXtPrcStsDscdNm;
	}
	public void setAiInptXtPrcStsDscdNm(String aiInptXtPrcStsDscdNm) {
		this.aiInptXtPrcStsDscdNm = aiInptXtPrcStsDscdNm;
	}
	public String getTrnOprNo() {
		return trnOprNo;
	}
	public void setTrnOprNo(String trnOprNo) {
		this.trnOprNo = trnOprNo;
	}
	public String getDocScanNm() {
		return docScanNm;
	}
	public void setDocScanNm(String docScanNm) {
		this.docScanNm = docScanNm;
	}
	public String getTrnOprNm() {
		return trnOprNm;
	}
	public void setTrnOprNm(String trnOprNm) {
		this.trnOprNm = trnOprNm;
	}
	public String getProcNm() {
		return procNm;
	}
	public void setProcNm(String procNm) {
		this.procNm = procNm;
	}
	public String[] getAiInptXtSrnos() {
		return aiInptXtSrnos;
	}
	public void setAiInptXtSrnos(String[] aiInptXtSrnos) {
		this.aiInptXtSrnos = aiInptXtSrnos;
	}
	public String[] getActlFxRefnos() {
		return actlFxRefnos;
	}
	public void setActlFxRefnos(String[] actlFxRefnos) {
		this.actlFxRefnos = actlFxRefnos;
	}
	public List<RevertUngeneratedVO> getMainList() {
		return mainList;
	}
	public void setMainList(List<RevertUngeneratedVO> mainList) {
		this.mainList = mainList;
	}
	public String getActlFxRefno() {
		return actlFxRefno;
	}
	public void setActlFxRefno(String actlFxRefno) {
		this.actlFxRefno = actlFxRefno;
	}
	public String getFxRefnoSrno() {
		return fxRefnoSrno;
	}
	public void setFxRefnoSrno(String fxRefnoSrno) {
		this.fxRefnoSrno = fxRefnoSrno;
	}
	public String getInptRcpDt() {
		return inptRcpDt;
	}
	public void setInptRcpDt(String inptRcpDt) {
		this.inptRcpDt = inptRcpDt;
	}
	public String getInptAtmcBizDscd() {
		return inptAtmcBizDscd;
	}
	public void setInptAtmcBizDscd(String inptAtmcBizDscd) {
		this.inptAtmcBizDscd = inptAtmcBizDscd;
	}
	public String getAiInptDocScanChrgEno() {
		return aiInptDocScanChrgEno;
	}
	public void setAiInptDocScanChrgEno(String aiInptDocScanChrgEno) {
		this.aiInptDocScanChrgEno = aiInptDocScanChrgEno;
	}
	public String getAiInptDocScanDtm() {
		return aiInptDocScanDtm;
	}
	public void setAiInptDocScanDtm(String aiInptDocScanDtm) {
		this.aiInptDocScanDtm = aiInptDocScanDtm;
	}
	public String getAiInptImgKeyNo() {
		return aiInptImgKeyNo;
	}
	public void setAiInptImgKeyNo(String aiInptImgKeyNo) {
		this.aiInptImgKeyNo = aiInptImgKeyNo;
	}
	public String getAiInptAplXtRncd() {
		return aiInptAplXtRncd;
	}
	public void setAiInptAplXtRncd(String aiInptAplXtRncd) {
		this.aiInptAplXtRncd = aiInptAplXtRncd;
	}
	public String getAiInptXtPrcStsDscd() {
		return aiInptXtPrcStsDscd;
	}
	public void setAiInptXtPrcStsDscd(String aiInptXtPrcStsDscd) {
		this.aiInptXtPrcStsDscd = aiInptXtPrcStsDscd;
	}
	public String getAiInptXtPrcEno() {
		return aiInptXtPrcEno;
	}
	public void setAiInptXtPrcEno(String aiInptXtPrcEno) {
		this.aiInptXtPrcEno = aiInptXtPrcEno;
	}
	public String getAiInptXtPrcDtm() {
		return aiInptXtPrcDtm;
	}
	public void setAiInptXtPrcDtm(String aiInptXtPrcDtm) {
		this.aiInptXtPrcDtm = aiInptXtPrcDtm;
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
	public String getAiInptXtSrno() {
		return aiInptXtSrno;
	}
	public void setAiInptXtSrno(String aiInptXtSrno) {
		this.aiInptXtSrno = aiInptXtSrno;
	}
	
	
}