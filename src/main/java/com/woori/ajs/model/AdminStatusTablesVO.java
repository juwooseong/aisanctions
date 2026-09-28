package com.woori.ajs.model;

public class AdminStatusTablesVO {
	
	// 83
	// CSPD001TM AISanction심사마스터원장
	private String inptMstSrno;
	private String inptRcpDt;
	private String actlFxRefno;
	private String fxRefnoSrno;
	private String aiInptImgKeyNo;
	private String inptAtmcBizDscd;
	private String aiInptDocScanChrgEno;
	private String aiInptDocScanDtm;
	private String totaltextAiInptRstCd;
	private String itmInptAiInptRstCd;
	private String safewatchAiInptRstCd;
	private String aiInspeEno;
	private String aiInptAppvStcd;
	private String papsClfErrYn;
	private String papsReScanCmplYn;
	private String papsReScanNedYn;
	private String qlasPrgYn;
	private String qlasCrpeEno;
	private String qltGrnAiInptRstCd;
	private String aiInptProsCd;
	private String aiInptAcvtCd;
	private String aiInptSnpeEno;
	private String aiInptQlasAppvStcd;
	private String aiInptQlasProsCd;
	private String aiInptQlasAcvtCd;
	private String qlasSnpeEno;
	private String qlasAlocDt;
	private String trnLogSrno;
	private String lstDbChgId;
	private String lstDbChgDtm;

	// CSPD002TG AISanction심사문서명세
	private String inptTaskId;
	private String inptBlGrpNo;
	private String imexHisCd;
	private String imexHisSrno;
	private String shipRgsNo;
	private String aiInptCnnStsTxt;
	private String aiInptRcnnStsTxt;
	private String aiInptDsrsExeSvrTxt;
	private String inptElmtId;
	private String inptPapsFileNm;
	private String inptPapsFilePathTxt;
	private String aiInptDocTpNm;
	private String aiInptAicrRstTxt;
	private String aiInptAllAicrRstTxt;
	private String aiInptPapsQltScre;

	
	// CSPD003TF TotalText심사결과상세
	private String aiInptTotaltextSrno;
	private String aiInptTotaltextRvsnYn;
	private String inptSanctionDatTxt;
	private String bfrsTaExtcTxt;
	private String afrsTaExtcTxt;
	private String bfrsAicrExtcTxt;
	private String afrsAicrExtcTxt;
	private String itmInptXaxisStaCrdnCn;
	private String itmInptYaxisStaCrdnCn;
	private String itmInptXaxisEndCrdnCn;
	private String itmInptYaxisEndCrdnCn;
	private String aiInptAltYn;
	private String aiInptSanctionRuleTxt;
	private String aiInptWordAcrdRt;

	// CSPD004TF 항목심사결과상세
	private String inptSanctionNo;
	private String itmInptNacrdYn;
	private String itmInptRvsnYn;
	private String itmInptHndgInpDatTxt;
	private String safewatchItmYn;
	private String aiInptExtcSntnTxt;

	// CSPD005TH
	private String aiInptAppvSrno;
	private String aiInptBizDscd;
	private String aiInptCrpeEno;
	private String aiInptPrcDtm;
	private String aiInptPrcOpiTxt;
	private String aiInptTpySaveYn;
	private String aiInptTotaltextRstCd;
	private String aiInptItmRstCd;
	private String aiInptQlasPrcStsCd;

	// CSPD006TL
	private String aiInptAtflSrno;
	private String aiInptAtflNm;
	private String aiInptAtflPathTxt;

	// CSPD009TA
	private String aiInptClsDt;
	private String aiInptClsDscd;
	private String aiInptClsItcd;
	private String aiInptClsCnt;
	private String aiInptRmrkTxt;

	
	// CSPD007TL 심사Detection결과목록
	private String aiInptPrgSrno;
	private String filtInptRstSrno;
	private String aiInptBlNoNcnt;
	private String blNo;
	private String filtDtctNo;
	private String filtInptRstRecpDtm;
	private String aiInptFiltTxt;
	private String filtInptReqDtm;

	// CSPD008TH AI심사진행이력
	private String aiInptAcvtStsCd;
	private String aiInptProsStaDtm;

	// CSPD900TI 심사마스터처리정보
	private String aiInptMstStsTxt;
	private String aiInptSvrInfTxt;
	private String aiInptPrcDscd;
	private String aiSysInptPrgStcd;
	private String rprocTcn;
	
	// CSPD820TH
	private String  inptSysMntgDt;  
	private String inptSysMntgTm; 
	private String inptSysSvrNm;  
	private String inptSysPfmDatTpcd;
	private String inptSysPfmDatNm; 
	private String inptSysPfmDatTxt;
	private String inptSysPfmDatLvlTxt;
	private String inptSysMntgNmlLvlTxt;
	
	
	public String getInptSysMntgDt() {
		return inptSysMntgDt;
	}
	public void setInptSysMntgDt(String inptSysMntgDt) {
		this.inptSysMntgDt = inptSysMntgDt;
	}
	public String getInptSysMntgTm() {
		return inptSysMntgTm;
	}
	public void setInptSysMntgTm(String inptSysMntgTm) {
		this.inptSysMntgTm = inptSysMntgTm;
	}
	public String getInptSysSvrNm() {
		return inptSysSvrNm;
	}
	public void setInptSysSvrNm(String inptSysSvrNm) {
		this.inptSysSvrNm = inptSysSvrNm;
	}
	public String getInptSysPfmDatTpcd() {
		return inptSysPfmDatTpcd;
	}
	public void setInptSysPfmDatTpcd(String inptSysPfmDatTpcd) {
		this.inptSysPfmDatTpcd = inptSysPfmDatTpcd;
	}
	public String getInptSysPfmDatNm() {
		return inptSysPfmDatNm;
	}
	public void setInptSysPfmDatNm(String inptSysPfmDatNm) {
		this.inptSysPfmDatNm = inptSysPfmDatNm;
	}
	public String getInptSysPfmDatTxt() {
		return inptSysPfmDatTxt;
	}
	public void setInptSysPfmDatTxt(String inptSysPfmDatTxt) {
		this.inptSysPfmDatTxt = inptSysPfmDatTxt;
	}
	public String getInptSysPfmDatLvlTxt() {
		return inptSysPfmDatLvlTxt;
	}
	public void setInptSysPfmDatLvlTxt(String inptSysPfmDatLvlTxt) {
		this.inptSysPfmDatLvlTxt = inptSysPfmDatLvlTxt;
	}
	public String getInptSysMntgNmlLvlTxt() {
		return inptSysMntgNmlLvlTxt;
	}
	public void setInptSysMntgNmlLvlTxt(String inptSysMntgNmlLvlTxt) {
		this.inptSysMntgNmlLvlTxt = inptSysMntgNmlLvlTxt;
	}
	public String getInptMstSrno() {
		return inptMstSrno;
	}
	public void setInptMstSrno(String inptMstSrno) {
		this.inptMstSrno = inptMstSrno;
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
	public String getAiInptImgKeyNo() {
		return aiInptImgKeyNo;
	}
	public void setAiInptImgKeyNo(String aiInptImgKeyNo) {
		this.aiInptImgKeyNo = aiInptImgKeyNo;
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
	public String getAiInspeEno() {
		return aiInspeEno;
	}
	public void setAiInspeEno(String aiInspeEno) {
		this.aiInspeEno = aiInspeEno;
	}
	public String getAiInptAppvStcd() {
		return aiInptAppvStcd;
	}
	public void setAiInptAppvStcd(String aiInptAppvStcd) {
		this.aiInptAppvStcd = aiInptAppvStcd;
	}
	public String getPapsClfErrYn() {
		return papsClfErrYn;
	}
	public void setPapsClfErrYn(String papsClfErrYn) {
		this.papsClfErrYn = papsClfErrYn;
	}
	public String getPapsReScanCmplYn() {
		return papsReScanCmplYn;
	}
	public void setPapsReScanCmplYn(String papsReScanCmplYn) {
		this.papsReScanCmplYn = papsReScanCmplYn;
	}
	public String getPapsReScanNedYn() {
		return papsReScanNedYn;
	}
	public void setPapsReScanNedYn(String papsReScanNedYn) {
		this.papsReScanNedYn = papsReScanNedYn;
	}
	public String getQlasPrgYn() {
		return qlasPrgYn;
	}
	public void setQlasPrgYn(String qlasPrgYn) {
		this.qlasPrgYn = qlasPrgYn;
	}
	public String getQlasCrpeEno() {
		return qlasCrpeEno;
	}
	public void setQlasCrpeEno(String qlasCrpeEno) {
		this.qlasCrpeEno = qlasCrpeEno;
	}
	public String getQltGrnAiInptRstCd() {
		return qltGrnAiInptRstCd;
	}
	public void setQltGrnAiInptRstCd(String qltGrnAiInptRstCd) {
		this.qltGrnAiInptRstCd = qltGrnAiInptRstCd;
	}
	public String getAiInptProsCd() {
		return aiInptProsCd;
	}
	public void setAiInptProsCd(String aiInptProsCd) {
		this.aiInptProsCd = aiInptProsCd;
	}
	public String getAiInptAcvtCd() {
		return aiInptAcvtCd;
	}
	public void setAiInptAcvtCd(String aiInptAcvtCd) {
		this.aiInptAcvtCd = aiInptAcvtCd;
	}
	public String getAiInptSnpeEno() {
		return aiInptSnpeEno;
	}
	public void setAiInptSnpeEno(String aiInptSnpeEno) {
		this.aiInptSnpeEno = aiInptSnpeEno;
	}
	public String getAiInptQlasAppvStcd() {
		return aiInptQlasAppvStcd;
	}
	public void setAiInptQlasAppvStcd(String aiInptQlasAppvStcd) {
		this.aiInptQlasAppvStcd = aiInptQlasAppvStcd;
	}
	public String getAiInptQlasProsCd() {
		return aiInptQlasProsCd;
	}
	public void setAiInptQlasProsCd(String aiInptQlasProsCd) {
		this.aiInptQlasProsCd = aiInptQlasProsCd;
	}
	public String getAiInptQlasAcvtCd() {
		return aiInptQlasAcvtCd;
	}
	public void setAiInptQlasAcvtCd(String aiInptQlasAcvtCd) {
		this.aiInptQlasAcvtCd = aiInptQlasAcvtCd;
	}
	public String getQlasSnpeEno() {
		return qlasSnpeEno;
	}
	public void setQlasSnpeEno(String qlasSnpeEno) {
		this.qlasSnpeEno = qlasSnpeEno;
	}
	public String getQlasAlocDt() {
		return qlasAlocDt;
	}
	public void setQlasAlocDt(String qlasAlocDt) {
		this.qlasAlocDt = qlasAlocDt;
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
	public String getInptTaskId() {
		return inptTaskId;
	}
	public void setInptTaskId(String inptTaskId) {
		this.inptTaskId = inptTaskId;
	}
	public String getInptBlGrpNo() {
		return inptBlGrpNo;
	}
	public void setInptBlGrpNo(String inptBlGrpNo) {
		this.inptBlGrpNo = inptBlGrpNo;
	}
	public String getImexHisCd() {
		return imexHisCd;
	}
	public void setImexHisCd(String imexHisCd) {
		this.imexHisCd = imexHisCd;
	}
	public String getImexHisSrno() {
		return imexHisSrno;
	}
	public void setImexHisSrno(String imexHisSrno) {
		this.imexHisSrno = imexHisSrno;
	}
	public String getShipRgsNo() {
		return shipRgsNo;
	}
	public void setShipRgsNo(String shipRgsNo) {
		this.shipRgsNo = shipRgsNo;
	}
	public String getAiInptCnnStsTxt() {
		return aiInptCnnStsTxt;
	}
	public void setAiInptCnnStsTxt(String aiInptCnnStsTxt) {
		this.aiInptCnnStsTxt = aiInptCnnStsTxt;
	}
	public String getAiInptRcnnStsTxt() {
		return aiInptRcnnStsTxt;
	}
	public void setAiInptRcnnStsTxt(String aiInptRcnnStsTxt) {
		this.aiInptRcnnStsTxt = aiInptRcnnStsTxt;
	}
	public String getAiInptDsrsExeSvrTxt() {
		return aiInptDsrsExeSvrTxt;
	}
	public void setAiInptDsrsExeSvrTxt(String aiInptDsrsExeSvrTxt) {
		this.aiInptDsrsExeSvrTxt = aiInptDsrsExeSvrTxt;
	}
	public String getInptElmtId() {
		return inptElmtId;
	}
	public void setInptElmtId(String inptElmtId) {
		this.inptElmtId = inptElmtId;
	}
	public String getInptPapsFileNm() {
		return inptPapsFileNm;
	}
	public void setInptPapsFileNm(String inptPapsFileNm) {
		this.inptPapsFileNm = inptPapsFileNm;
	}
	public String getInptPapsFilePathTxt() {
		return inptPapsFilePathTxt;
	}
	public void setInptPapsFilePathTxt(String inptPapsFilePathTxt) {
		this.inptPapsFilePathTxt = inptPapsFilePathTxt;
	}
	public String getAiInptDocTpNm() {
		return aiInptDocTpNm;
	}
	public void setAiInptDocTpNm(String aiInptDocTpNm) {
		this.aiInptDocTpNm = aiInptDocTpNm;
	}
	public String getAiInptAicrRstTxt() {
		return aiInptAicrRstTxt;
	}
	public void setAiInptAicrRstTxt(String aiInptAicrRstTxt) {
		this.aiInptAicrRstTxt = aiInptAicrRstTxt;
	}
	public String getAiInptAllAicrRstTxt() {
		return aiInptAllAicrRstTxt;
	}
	public void setAiInptAllAicrRstTxt(String aiInptAllAicrRstTxt) {
		this.aiInptAllAicrRstTxt = aiInptAllAicrRstTxt;
	}
	public String getAiInptPapsQltScre() {
		return aiInptPapsQltScre;
	}
	public void setAiInptPapsQltScre(String aiInptPapsQltScre) {
		this.aiInptPapsQltScre = aiInptPapsQltScre;
	}
	public String getAiInptTotaltextSrno() {
		return aiInptTotaltextSrno;
	}
	public void setAiInptTotaltextSrno(String aiInptTotaltextSrno) {
		this.aiInptTotaltextSrno = aiInptTotaltextSrno;
	}
	public String getAiInptTotaltextRvsnYn() {
		return aiInptTotaltextRvsnYn;
	}
	public void setAiInptTotaltextRvsnYn(String aiInptTotaltextRvsnYn) {
		this.aiInptTotaltextRvsnYn = aiInptTotaltextRvsnYn;
	}
	public String getInptSanctionDatTxt() {
		return inptSanctionDatTxt;
	}
	public void setInptSanctionDatTxt(String inptSanctionDatTxt) {
		this.inptSanctionDatTxt = inptSanctionDatTxt;
	}
	public String getBfrsTaExtcTxt() {
		return bfrsTaExtcTxt;
	}
	public void setBfrsTaExtcTxt(String bfrsTaExtcTxt) {
		this.bfrsTaExtcTxt = bfrsTaExtcTxt;
	}
	public String getAfrsTaExtcTxt() {
		return afrsTaExtcTxt;
	}
	public void setAfrsTaExtcTxt(String afrsTaExtcTxt) {
		this.afrsTaExtcTxt = afrsTaExtcTxt;
	}
	public String getBfrsAicrExtcTxt() {
		return bfrsAicrExtcTxt;
	}
	public void setBfrsAicrExtcTxt(String bfrsAicrExtcTxt) {
		this.bfrsAicrExtcTxt = bfrsAicrExtcTxt;
	}
	public String getAfrsAicrExtcTxt() {
		return afrsAicrExtcTxt;
	}
	public void setAfrsAicrExtcTxt(String afrsAicrExtcTxt) {
		this.afrsAicrExtcTxt = afrsAicrExtcTxt;
	}
	public String getItmInptXaxisStaCrdnCn() {
		return itmInptXaxisStaCrdnCn;
	}
	public void setItmInptXaxisStaCrdnCn(String itmInptXaxisStaCrdnCn) {
		this.itmInptXaxisStaCrdnCn = itmInptXaxisStaCrdnCn;
	}
	public String getItmInptYaxisStaCrdnCn() {
		return itmInptYaxisStaCrdnCn;
	}
	public void setItmInptYaxisStaCrdnCn(String itmInptYaxisStaCrdnCn) {
		this.itmInptYaxisStaCrdnCn = itmInptYaxisStaCrdnCn;
	}
	public String getItmInptXaxisEndCrdnCn() {
		return itmInptXaxisEndCrdnCn;
	}
	public void setItmInptXaxisEndCrdnCn(String itmInptXaxisEndCrdnCn) {
		this.itmInptXaxisEndCrdnCn = itmInptXaxisEndCrdnCn;
	}
	public String getItmInptYaxisEndCrdnCn() {
		return itmInptYaxisEndCrdnCn;
	}
	public void setItmInptYaxisEndCrdnCn(String itmInptYaxisEndCrdnCn) {
		this.itmInptYaxisEndCrdnCn = itmInptYaxisEndCrdnCn;
	}
	public String getAiInptAltYn() {
		return aiInptAltYn;
	}
	public void setAiInptAltYn(String aiInptAltYn) {
		this.aiInptAltYn = aiInptAltYn;
	}
	public String getAiInptSanctionRuleTxt() {
		return aiInptSanctionRuleTxt;
	}
	public void setAiInptSanctionRuleTxt(String aiInptSanctionRuleTxt) {
		this.aiInptSanctionRuleTxt = aiInptSanctionRuleTxt;
	}
	public String getAiInptWordAcrdRt() {
		return aiInptWordAcrdRt;
	}
	public void setAiInptWordAcrdRt(String aiInptWordAcrdRt) {
		this.aiInptWordAcrdRt = aiInptWordAcrdRt;
	}
	public String getInptSanctionNo() {
		return inptSanctionNo;
	}
	public void setInptSanctionNo(String inptSanctionNo) {
		this.inptSanctionNo = inptSanctionNo;
	}
	public String getItmInptNacrdYn() {
		return itmInptNacrdYn;
	}
	public void setItmInptNacrdYn(String itmInptNacrdYn) {
		this.itmInptNacrdYn = itmInptNacrdYn;
	}
	public String getItmInptRvsnYn() {
		return itmInptRvsnYn;
	}
	public void setItmInptRvsnYn(String itmInptRvsnYn) {
		this.itmInptRvsnYn = itmInptRvsnYn;
	}
	public String getItmInptHndgInpDatTxt() {
		return itmInptHndgInpDatTxt;
	}
	public void setItmInptHndgInpDatTxt(String itmInptHndgInpDatTxt) {
		this.itmInptHndgInpDatTxt = itmInptHndgInpDatTxt;
	}
	public String getSafewatchItmYn() {
		return safewatchItmYn;
	}
	public void setSafewatchItmYn(String safewatchItmYn) {
		this.safewatchItmYn = safewatchItmYn;
	}
	public String getAiInptExtcSntnTxt() {
		return aiInptExtcSntnTxt;
	}
	public void setAiInptExtcSntnTxt(String aiInptExtcSntnTxt) {
		this.aiInptExtcSntnTxt = aiInptExtcSntnTxt;
	}
	public String getAiInptAppvSrno() {
		return aiInptAppvSrno;
	}
	public void setAiInptAppvSrno(String aiInptAppvSrno) {
		this.aiInptAppvSrno = aiInptAppvSrno;
	}
	public String getAiInptBizDscd() {
		return aiInptBizDscd;
	}
	public void setAiInptBizDscd(String aiInptBizDscd) {
		this.aiInptBizDscd = aiInptBizDscd;
	}
	public String getAiInptCrpeEno() {
		return aiInptCrpeEno;
	}
	public void setAiInptCrpeEno(String aiInptCrpeEno) {
		this.aiInptCrpeEno = aiInptCrpeEno;
	}
	public String getAiInptPrcDtm() {
		return aiInptPrcDtm;
	}
	public void setAiInptPrcDtm(String aiInptPrcDtm) {
		this.aiInptPrcDtm = aiInptPrcDtm;
	}
	public String getAiInptPrcOpiTxt() {
		return aiInptPrcOpiTxt;
	}
	public void setAiInptPrcOpiTxt(String aiInptPrcOpiTxt) {
		this.aiInptPrcOpiTxt = aiInptPrcOpiTxt;
	}
	public String getAiInptTpySaveYn() {
		return aiInptTpySaveYn;
	}
	public void setAiInptTpySaveYn(String aiInptTpySaveYn) {
		this.aiInptTpySaveYn = aiInptTpySaveYn;
	}
	public String getAiInptTotaltextRstCd() {
		return aiInptTotaltextRstCd;
	}
	public void setAiInptTotaltextRstCd(String aiInptTotaltextRstCd) {
		this.aiInptTotaltextRstCd = aiInptTotaltextRstCd;
	}
	public String getAiInptItmRstCd() {
		return aiInptItmRstCd;
	}
	public void setAiInptItmRstCd(String aiInptItmRstCd) {
		this.aiInptItmRstCd = aiInptItmRstCd;
	}
	public String getAiInptQlasPrcStsCd() {
		return aiInptQlasPrcStsCd;
	}
	public void setAiInptQlasPrcStsCd(String aiInptQlasPrcStsCd) {
		this.aiInptQlasPrcStsCd = aiInptQlasPrcStsCd;
	}
	public String getAiInptAtflSrno() {
		return aiInptAtflSrno;
	}
	public void setAiInptAtflSrno(String aiInptAtflSrno) {
		this.aiInptAtflSrno = aiInptAtflSrno;
	}
	public String getAiInptAtflNm() {
		return aiInptAtflNm;
	}
	public void setAiInptAtflNm(String aiInptAtflNm) {
		this.aiInptAtflNm = aiInptAtflNm;
	}
	public String getAiInptAtflPathTxt() {
		return aiInptAtflPathTxt;
	}
	public void setAiInptAtflPathTxt(String aiInptAtflPathTxt) {
		this.aiInptAtflPathTxt = aiInptAtflPathTxt;
	}
	public String getAiInptClsDt() {
		return aiInptClsDt;
	}
	public void setAiInptClsDt(String aiInptClsDt) {
		this.aiInptClsDt = aiInptClsDt;
	}
	public String getAiInptClsDscd() {
		return aiInptClsDscd;
	}
	public void setAiInptClsDscd(String aiInptClsDscd) {
		this.aiInptClsDscd = aiInptClsDscd;
	}
	public String getAiInptClsItcd() {
		return aiInptClsItcd;
	}
	public void setAiInptClsItcd(String aiInptClsItcd) {
		this.aiInptClsItcd = aiInptClsItcd;
	}
	public String getAiInptClsCnt() {
		return aiInptClsCnt;
	}
	public void setAiInptClsCnt(String aiInptClsCnt) {
		this.aiInptClsCnt = aiInptClsCnt;
	}
	public String getAiInptRmrkTxt() {
		return aiInptRmrkTxt;
	}
	public void setAiInptRmrkTxt(String aiInptRmrkTxt) {
		this.aiInptRmrkTxt = aiInptRmrkTxt;
	}
	public String getAiInptPrgSrno() {
		return aiInptPrgSrno;
	}
	public void setAiInptPrgSrno(String aiInptPrgSrno) {
		this.aiInptPrgSrno = aiInptPrgSrno;
	}
	public String getFiltInptRstSrno() {
		return filtInptRstSrno;
	}
	public void setFiltInptRstSrno(String filtInptRstSrno) {
		this.filtInptRstSrno = filtInptRstSrno;
	}
	public String getAiInptBlNoNcnt() {
		return aiInptBlNoNcnt;
	}
	public void setAiInptBlNoNcnt(String aiInptBlNoNcnt) {
		this.aiInptBlNoNcnt = aiInptBlNoNcnt;
	}
	public String getBlNo() {
		return blNo;
	}
	public void setBlNo(String blNo) {
		this.blNo = blNo;
	}
	public String getFiltDtctNo() {
		return filtDtctNo;
	}
	public void setFiltDtctNo(String filtDtctNo) {
		this.filtDtctNo = filtDtctNo;
	}
	public String getFiltInptRstRecpDtm() {
		return filtInptRstRecpDtm;
	}
	public void setFiltInptRstRecpDtm(String filtInptRstRecpDtm) {
		this.filtInptRstRecpDtm = filtInptRstRecpDtm;
	}
	public String getAiInptFiltTxt() {
		return aiInptFiltTxt;
	}
	public void setAiInptFiltTxt(String aiInptFiltTxt) {
		this.aiInptFiltTxt = aiInptFiltTxt;
	}
	public String getFiltInptReqDtm() {
		return filtInptReqDtm;
	}
	public void setFiltInptReqDtm(String filtInptReqDtm) {
		this.filtInptReqDtm = filtInptReqDtm;
	}
	public String getAiInptAcvtStsCd() {
		return aiInptAcvtStsCd;
	}
	public void setAiInptAcvtStsCd(String aiInptAcvtStsCd) {
		this.aiInptAcvtStsCd = aiInptAcvtStsCd;
	}
	public String getAiInptProsStaDtm() {
		return aiInptProsStaDtm;
	}
	public void setAiInptProsStaDtm(String aiInptProsStaDtm) {
		this.aiInptProsStaDtm = aiInptProsStaDtm;
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