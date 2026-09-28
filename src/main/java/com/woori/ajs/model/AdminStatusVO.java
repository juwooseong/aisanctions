package com.woori.ajs.model;

import java.util.List;

public class AdminStatusVO{
	
	private String inptMstSrno;
	private String aiInptMstStsTxt;
	private String aiInptSvrInfTxt;
	private String trnLogSrno;
	private String lstDbChgId;
	private String lstDbChgDtm;
	private String aiInptPrcDscd;
	private String aiSysInptPrgStcd;
	private String rprocTcn;
	
	private String inptRcpDt;
	private String actlFxRefno;
	private String fxRefnoSrno;
	private String inptAtmcBizDscd;
	private String inptAtmcBizDsnm;
	private String aiInspeEno;
	private String aiInptProsCd;
	private String aiInptProsNm;
	private String aiInptAcvtCd;
	private String aiInptAcvtNm;
	private String aiInptPrcDsnm;
	private String aiSysInptPrgStnm;
	private String procSec;
	private String procMinute;
	private String procHour;
	private String procDay;
	
	private String processGroup;
	
	private String aiInptAppvStcd;
	
	private String docPageNum;
	
	// 담당자별 진행현황 하단 테이블
	private String daily1; // 스캔건수
	private String daily2; // AI자동심사
	private String daily3; // 심사중
	private String daily4; // 결재중
	private String daily5; // 완료
	private String daily6; // 총이미지수
	
	// aside 진행현황 테이블
	private String nonCrCnt; // 업무미생성 건수
	private String scanCnt; // 스캔건수
	private String errCnt; // 오류건수
	private String delayCnt; // 지연건수
	private String normalCnt; // 정상건수
	private String inspCnt; // 심사건수
	private String apprCnt; // 결재건수
	private String cmplCnt; // 완료건수
	private String totImgCnt; // 이미지수
	
	
	
	public String getNonCrCnt() {
		return nonCrCnt;
	}
	public void setNonCrCnt(String nonCrCnt) {
		this.nonCrCnt = nonCrCnt;
	}
	public String getScanCnt() {
		return scanCnt;
	}
	public void setScanCnt(String scanCnt) {
		this.scanCnt = scanCnt;
	}
	public String getErrCnt() {
		return errCnt;
	}
	public void setErrCnt(String errCnt) {
		this.errCnt = errCnt;
	}
	public String getDelayCnt() {
		return delayCnt;
	}
	public void setDelayCnt(String delayCnt) {
		this.delayCnt = delayCnt;
	}
	public String getNormalCnt() {
		return normalCnt;
	}
	public void setNormalCnt(String normalCnt) {
		this.normalCnt = normalCnt;
	}
	public String getInspCnt() {
		return inspCnt;
	}
	public void setInspCnt(String inspCnt) {
		this.inspCnt = inspCnt;
	}
	public String getApprCnt() {
		return apprCnt;
	}
	public void setApprCnt(String apprCnt) {
		this.apprCnt = apprCnt;
	}
	public String getCmplCnt() {
		return cmplCnt;
	}
	public void setCmplCnt(String cmplCnt) {
		this.cmplCnt = cmplCnt;
	}
	public String getTotImgCnt() {
		return totImgCnt;
	}
	public void setTotImgCnt(String totImgCnt) {
		this.totImgCnt = totImgCnt;
	}
	public String getDaily1() {
		return daily1;
	}
	public void setDaily1(String daily1) {
		this.daily1 = daily1;
	}
	public String getDaily2() {
		return daily2;
	}
	public void setDaily2(String daily2) {
		this.daily2 = daily2;
	}
	public String getDaily3() {
		return daily3;
	}
	public void setDaily3(String daily3) {
		this.daily3 = daily3;
	}
	public String getDaily4() {
		return daily4;
	}
	public void setDaily4(String daily4) {
		this.daily4 = daily4;
	}
	public String getDaily5() {
		return daily5;
	}
	public void setDaily5(String daily5) {
		this.daily5 = daily5;
	}
	public String getDaily6() {
		return daily6;
	}
	public void setDaily6(String daily6) {
		this.daily6 = daily6;
	}
	public String getDocPageNum() {
		return docPageNum;
	}
	public void setDocPageNum(String docPageNum) {
		this.docPageNum = docPageNum;
	}
	public String getAiInptAppvStcd() {
		return aiInptAppvStcd;
	}
	public void setAiInptAppvStcd(String aiInptAppvStcd) {
		this.aiInptAppvStcd = aiInptAppvStcd;
	}
	public String getProcSec() {
		return procSec;
	}
	public void setProcSec(String procSec) {
		this.procSec = procSec;
	}
	public String getProcessGroup() {
		return processGroup;
	}
	public void setProcessGroup(String processGroup) {
		this.processGroup = processGroup;
	}
	public String getInptRcpDt() {
		return inptRcpDt;
	}
	public void setInptRcpDt(String inptRcpDt) {
		this.inptRcpDt = inptRcpDt;
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
	public String getInptAtmcBizDscd() {
		return inptAtmcBizDscd;
	}
	public void setInptAtmcBizDscd(String inptAtmcBizDscd) {
		this.inptAtmcBizDscd = inptAtmcBizDscd;
	}
	public String getInptAtmcBizDsnm() {
		return inptAtmcBizDsnm;
	}
	public void setInptAtmcBizDsnm(String inptAtmcBizDsnm) {
		this.inptAtmcBizDsnm = inptAtmcBizDsnm;
	}
	public String getAiInspeEno() {
		return aiInspeEno;
	}
	public void setAiInspeEno(String aiInspeEno) {
		this.aiInspeEno = aiInspeEno;
	}
	public String getAiInptProsCd() {
		return aiInptProsCd;
	}
	public void setAiInptProsCd(String aiInptProsCd) {
		this.aiInptProsCd = aiInptProsCd;
	}
	public String getAiInptProsNm() {
		return aiInptProsNm;
	}
	public void setAiInptProsNm(String aiInptProsNm) {
		this.aiInptProsNm = aiInptProsNm;
	}
	public String getAiInptAcvtCd() {
		return aiInptAcvtCd;
	}
	public void setAiInptAcvtCd(String aiInptAcvtCd) {
		this.aiInptAcvtCd = aiInptAcvtCd;
	}
	public String getAiInptAcvtNm() {
		return aiInptAcvtNm;
	}
	public void setAiInptAcvtNm(String aiInptAcvtNm) {
		this.aiInptAcvtNm = aiInptAcvtNm;
	}
	public String getAiInptPrcDsnm() {
		return aiInptPrcDsnm;
	}
	public void setAiInptPrcDsnm(String aiInptPrcDsnm) {
		this.aiInptPrcDsnm = aiInptPrcDsnm;
	}
	public String getAiSysInptPrgStnm() {
		return aiSysInptPrgStnm;
	}
	public void setAiSysInptPrgStnm(String aiSysInptPrgStnm) {
		this.aiSysInptPrgStnm = aiSysInptPrgStnm;
	}
	public String getProcMinute() {
		return procMinute;
	}
	public void setProcMinute(String procMinute) {
		this.procMinute = procMinute;
	}
	public String getProcHour() {
		return procHour;
	}
	public void setProcHour(String procHour) {
		this.procHour = procHour;
	}
	public String getProcDay() {
		return procDay;
	}
	public void setProcDay(String procDay) {
		this.procDay = procDay;
	}
	public String getInptMstSrno() {
		return inptMstSrno;
	}
	public void setInptMstSrno(String inptMstSrno) {
		this.inptMstSrno = inptMstSrno;
	}
	public String getAiInptMstStsTxt() {
		return aiInptMstStsTxt;
	}
	public void setAiInptMstStsTxt(String aiInptMstStsTxt) {
		this.aiInptMstStsTxt = aiInptMstStsTxt;
	}
	public String getAiInptSvrInfTxt() {
		return aiInptSvrInfTxt;
	}
	public void setAiInptSvrInfTxt(String aiInptSvrInfTxt) {
		this.aiInptSvrInfTxt = aiInptSvrInfTxt;
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
	public String getAiInptPrcDscd() {
		return aiInptPrcDscd;
	}
	public void setAiInptPrcDscd(String aiInptPrcDscd) {
		this.aiInptPrcDscd = aiInptPrcDscd;
	}
	public String getAiSysInptPrgStcd() {
		return aiSysInptPrgStcd;
	}
	public void setAiSysInptPrgStcd(String aiSysInptPrgStcd) {
		this.aiSysInptPrgStcd = aiSysInptPrgStcd;
	}
	public String getRprocTcn() {
		return rprocTcn;
	}
	public void setRprocTcn(String rprocTcn) {
		this.rprocTcn = rprocTcn;
	}
}