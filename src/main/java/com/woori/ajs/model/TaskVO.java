package com.woori.ajs.model;

/**
 * 작업정보
 */
public class TaskVO {
	private String inptAtmcBizDscd;
	private String aiInptCmnCd;
	private String inptAtmcBizDsVal;
	private String inptMstSrno;
	private String aiInptAppvStcd;
	private String appvPrgStVal;
	private String appvActStcd;
	private String appvActStVal;
	private String aiInptCsno;
	private String aiInptCusNm;
	private String totaltextAiInptRstCd;
	private String itmInptAiInptRstCd;
	private String safewatchAiInptRstCd;
	private String totaltextAiInptRstVal;
	private String itmInptAiInptRstVal;
	private String safewatchAiInptRstVal;
	private String inptPrcscd;
	private String inptPrcsVal;
	private String inptAtvtcd;
	private String inptAtvtVal;
	private String inptRcpDt;
	private String actlFxRefno;
	private String ffxRefnoSrno;
	private String aiInptImgKeyNo;
	private String inptAtmcBizDsNm;
	private String wrrInfo;
	private String inptPrcsCd;
	private String inptPrcsNm;
	private String inptAtvtCd;
	private String inptAtvtNm;
	private String fcCucd;
	private String fcCuNm;
	private String aiInptBuyAm;
	private String totaltextAiInptRstNm;
	private String itmInptAiInptRstNm;
	private String safewatchAiInptRstNm;
	private String filtInptRstSrno;
	private String filtDtctNo;
	private String lstDbChgId;
	private String inptRcpDtStr;
	private String inptBizAlctCrpeFnm;				//심사업무할당담당자성명
	private String inptBizAlctCrpeEno;				//심사업무할당담당자직원번호
	private String aiAppvEno;						//담당결재자직원번호(S2)
	private String aiAppvEnm;						//담당결재자직원성명(S2)
	private String aiInspeEno;						//S1						
	private String aiInspeEnm;						//S1
	
	private String aiInptBizDscd; // 다우니 추가
	private String aiInptAppvHstId;
	private String aiInptCusNo;
	
	private String aiInptTpySaveYn;
	private String aiInptCrpeEno;
	private String aiInptQlasPrgStsCd;
	private String aiInptQaPrcsCd;

	
	
	public String getAiInptCusNo() {
		return aiInptCusNo;
	}
	public void setAiInptCusNo(String aiInptCusNo) {
		this.aiInptCusNo = aiInptCusNo;
	}
	
	public String getAiInptCmnCd() {
		return aiInptCmnCd;
	}
	public void setAiInptCmnCd(String aiInptCmnCd) {
		this.aiInptCmnCd = aiInptCmnCd;
	}
	public String getAiInptTpySaveYn() {
		return aiInptTpySaveYn;
	}
	public void setAiInptTpySaveYn(String aiInptTpySaveYn) {
		this.aiInptTpySaveYn = aiInptTpySaveYn;
	}
	public String getAiInptCrpeEno() {
		return aiInptCrpeEno;
	}
	public void setAiInptCrpeEno(String aiInptCrpeEno) {
		this.aiInptCrpeEno = aiInptCrpeEno;
	}
	public String getAiInptQlasPrgStsCd() {
		return aiInptQlasPrgStsCd;
	}
	public void setAiInptQlasPrgStsCd(String aiInptQlasPrgStsCd) {
		this.aiInptQlasPrgStsCd = aiInptQlasPrgStsCd;
	}
	public String getAiInptAppvHstId() {
		return aiInptAppvHstId;
	}
	public void setAiInptAppvHstId(String aiInptAppvHstId) {
		this.aiInptAppvHstId = aiInptAppvHstId;
	}
	public String getAiInptBizDscd() {
		return aiInptBizDscd;
	}
	public void setAiInptBizDscd(String aiInptBizDscd) {
		this.aiInptBizDscd = aiInptBizDscd;
	}
	public String getInptAtmcBizDscd() {
		return inptAtmcBizDscd;
	}
	public void setInptAtmcBizDscd(String inptAtmcBizDscd) {
		this.inptAtmcBizDscd = inptAtmcBizDscd;
	}
	public String getInptMstSrno() {
		return inptMstSrno;
	}
	public void setInptMstSrno(String inptMstSrno) {
		this.inptMstSrno = inptMstSrno;
	}
	public String getAiInptAppvStcd() {
		return aiInptAppvStcd;
	}
	public void setAiInptAppvStcd(String aiInptAppvStcd) {
		this.aiInptAppvStcd = aiInptAppvStcd;
	}
	public String getAiInptCsno() {
		return aiInptCsno;
	}
	public void setAiInptCsno(String aiInptCsno) {
		this.aiInptCsno = aiInptCsno;
	}
	public String getAiInptCusNm() {
		return aiInptCusNm;
	}
	public void setAiInptCusNm(String aiInptCusNm) {
		this.aiInptCusNm = aiInptCusNm;
	}
	public String getTotaltextAiInptRstCd() {
		return totaltextAiInptRstCd;
	}
	public void setTotaltextAiInptRstCd(String totaltextAiInptRstCd) {
		this.totaltextAiInptRstCd = totaltextAiInptRstCd;
	}
	public String getItmInptAiInptRstCd() {
		return itmInptAiInptRstCd;
	}
	public void setItmInptAiInptRstCd(String itmInptAiInptRstCd) {
		this.itmInptAiInptRstCd = itmInptAiInptRstCd;
	}
	public String getSafewatchAiInptRstCd() {
		return safewatchAiInptRstCd;
	}
	public void setSafewatchAiInptRstCd(String safewatchAiInptRstCd) {
		this.safewatchAiInptRstCd = safewatchAiInptRstCd;
	}
	public String getAppvActStcd() {
		return appvActStcd;
	}
	public void setAppvActStcd(String appvActStcd) {
		this.appvActStcd = appvActStcd;
	}
	public String getInptAtmcBizDsVal() {
		return inptAtmcBizDsVal;
	}
	public void setInptAtmcBizDsVal(String inptAtmcBizDsVal) {
		this.inptAtmcBizDsVal = inptAtmcBizDsVal;
	}
	public String getAppvPrgStVal() {
		return appvPrgStVal;
	}
	public void setAppvPrgStVal(String appvPrgStVal) {
		this.appvPrgStVal = appvPrgStVal;
	}
	public String getAppvActStVal() {
		return appvActStVal;
	}
	public void setAppvActStVal(String appvActStVal) {
		this.appvActStVal = appvActStVal;
	}
	public String getTotaltextAiInptRstVal() {
		return totaltextAiInptRstVal;
	}
	public void setTotaltextAiInptRstVal(String totaltextAiInptRstVal) {
		this.totaltextAiInptRstVal = totaltextAiInptRstVal;
	}
	public String getItmInptAiInptRstVal() {
		return itmInptAiInptRstVal;
	}
	public void setItmInptAiInptRstVal(String itmInptAiInptRstVal) {
		this.itmInptAiInptRstVal = itmInptAiInptRstVal;
	}
	public String getSafewatchAiInptRstVal() {
		return safewatchAiInptRstVal;
	}
	public void setSafewatchAiInptRstVal(String safewatchAiInptRstVal) {
		this.safewatchAiInptRstVal = safewatchAiInptRstVal;
	}
	public String getInptPrcscd() {
		return inptPrcscd;
	}
	public void setInptPrcscd(String inptPrcscd) {
		this.inptPrcscd = inptPrcscd;
	}
	public String getInptPrcsVal() {
		return inptPrcsVal;
	}
	public void setInptPrcsVal(String inptPrcsVal) {
		this.inptPrcsVal = inptPrcsVal;
	}
	public String getInptAtvtcd() {
		return inptAtvtcd;
	}
	public void setInptAtvtcd(String inptAtvtcd) {
		this.inptAtvtcd = inptAtvtcd;
	}
	public String getInptAtvtVal() {
		return inptAtvtVal;
	}
	public void setInptAtvtVal(String inptAtvtVal) {
		this.inptAtvtVal = inptAtvtVal;
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
	public String getFfxRefnoSrno() {
		return ffxRefnoSrno;
	}
	public void setFfxRefnoSrno(String ffxRefnoSrno) {
		this.ffxRefnoSrno = ffxRefnoSrno;
	}
	public String getAiInptImgKeyNo() {
		return aiInptImgKeyNo;
	}
	public void setAiInptImgKeyNo(String aiInptImgKeyNo) {
		this.aiInptImgKeyNo = aiInptImgKeyNo;
	}
	public String getInptAtmcBizDsNm() {
		return inptAtmcBizDsNm;
	}
	public void setInptAtmcBizDsNm(String inptAtmcBizDsNm) {
		this.inptAtmcBizDsNm = inptAtmcBizDsNm;
	}
	public String getWrrInfo() {
		return wrrInfo;
	}
	public void setWrrInfo(String wrrInfo) {
		this.wrrInfo = wrrInfo;
	}
	public String getInptPrcsCd() {
		return inptPrcsCd;
	}
	public void setInptPrcsCd(String inptPrcsCd) {
		this.inptPrcsCd = inptPrcsCd;
	}
	public String getInptPrcsNm() {
		return inptPrcsNm;
	}
	public void setInptPrcsNm(String inptPrcsNm) {
		this.inptPrcsNm = inptPrcsNm;
	}
	public String getInptAtvtCd() {
		return inptAtvtCd;
	}
	public void setInptAtvtCd(String inptAtvtCd) {
		this.inptAtvtCd = inptAtvtCd;
	}
	public String getInptAtvtNm() {
		return inptAtvtNm;
	}
	public void setInptAtvtNm(String inptAtvtNm) {
		this.inptAtvtNm = inptAtvtNm;
	}
	public String getFcCucd() {
		return fcCucd;
	}
	public void setFcCucd(String fcCucd) {
		this.fcCucd = fcCucd;
	}
	public String getFcCuNm() {
		return fcCuNm;
	}
	public void setFcCuNm(String fcCuNm) {
		this.fcCuNm = fcCuNm;
	}
	public String getAiInptBuyAm() {
		return aiInptBuyAm;
	}
	public void setAiInptBuyAm(String aiInptBuyAm) {
		this.aiInptBuyAm = aiInptBuyAm;
	}
	public String getTotaltextAiInptRstNm() {
		return totaltextAiInptRstNm;
	}
	public void setTotaltextAiInptRstNm(String totaltextAiInptRstNm) {
		this.totaltextAiInptRstNm = totaltextAiInptRstNm;
	}
	public String getItmInptAiInptRstNm() {
		return itmInptAiInptRstNm;
	}
	public void setItmInptAiInptRstNm(String itmInptAiInptRstNm) {
		this.itmInptAiInptRstNm = itmInptAiInptRstNm;
	}
	public String getSafewatchAiInptRstNm() {
		return safewatchAiInptRstNm;
	}
	public void setSafewatchAiInptRstNm(String safewatchAiInptRstNm) {
		this.safewatchAiInptRstNm = safewatchAiInptRstNm;
	}
	public String getFiltInptRstSrno() {
		return filtInptRstSrno;
	}
	public void setFiltInptRstSrno(String filtInptRstSrno) {
		this.filtInptRstSrno = filtInptRstSrno;
	}
	public String getFiltDtctNo() {
		return filtDtctNo;
	}
	public void setFiltDtctNo(String filtDtctNo) {
		this.filtDtctNo = filtDtctNo;
	}
	public String getLstDbChgId() {
		return lstDbChgId;
	}
	public void setLstDbChgId(String lstDbChgId) {
		this.lstDbChgId = lstDbChgId;
	}
	public String getInptRcpDtStr() {
		return inptRcpDtStr;
	}
	public void setInptRcpDtStr(String inptRcpDtStr) {
		this.inptRcpDtStr = inptRcpDtStr;
	}
	public String getInptBizAlctCrpeFnm() {
		return inptBizAlctCrpeFnm;
	}
	public void setInptBizAlctCrpeFnm(String inptBizAlctCrpeFnm) {
		this.inptBizAlctCrpeFnm = inptBizAlctCrpeFnm;
	}
	public String getInptBizAlctCrpeEno() {
		return inptBizAlctCrpeEno;
	}
	public void setInptBizAlctCrpeEno(String inptBizAlctCrpeEno) {
		this.inptBizAlctCrpeEno = inptBizAlctCrpeEno;
	}
	public String getAiAppvEno() {
		return aiAppvEno;
	}
	public void setAiAppvEno(String aiAppvEno) {
		this.aiAppvEno = aiAppvEno;
	}
	public String getAiAppvEnm() {
		return aiAppvEnm;
	}
	public void setAiAppvEnm(String aiAppvEnm) {
		this.aiAppvEnm = aiAppvEnm;
	}
	public String getAiInspeEno() {
		return aiInspeEno;
	}
	public void setAiInspeEno(String aiInspeEno) {
		this.aiInspeEno = aiInspeEno;
	}
	public String getAiInspeEnm() {
		return aiInspeEnm;
	}
	public void setAiInspeEnm(String aiInspeEnm) {
		this.aiInspeEnm = aiInspeEnm;
	}
	public String getAiInptQaPrcsCd() {
		return aiInptQaPrcsCd;
	}
	public void setAiInptQaPrcsCd(String aiInptQaPrcsCd) {
		this.aiInptQaPrcsCd = aiInptQaPrcsCd;
	}
	
}