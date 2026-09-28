package com.woori.ajs.model;

import java.util.List;

@SuppressWarnings("serial")
public class CommonRevertDetailVO {
	private int inptMstSrno;
	private int inptBlGrpNo;
	private int inptBlGrpNoOrg;
	private int inptBlGrpNoModi;
	private String imexHisCd = "";
	private String imexHisNm = "";
	private String imexhissAbbr = "";
	private String imexHisCdOrg = "";
	private String imexHisNmOrg = "";
	private String inptTaskId = "";
	private String inptElmtId = "";
	private String aiInptPapsQltScre = "";
	private String aiInptQlasProsCd = "";
	private String inptRcpDt = "";
	private String actlFxRefno = "";
	private int ffxRefnoSrno;
	private int fxRefnoSrno;
	private int pageNo;
	private String itmCoordinates = "";        // 배열형태의 좌료
	private String aiInptAltYn = "";
	private String bfrsTaExtcTxt = "";
	private String afrsTaExtcTxt = "";
	private List<CommonRevertDetailVO> sanctionList;
	private String safewatchItmYn = "";
	//blTabNm
	private String blTabNm = "";
	private String swNm = "";
	private String filtDtctDo = "";
	
	// 심사구분 = TotalText : Tot, 항목심사 : San
	private String spdKind = "";
	// 항목 결과 구분 = EXT : 추출, CMN : 공통
	private String stRstKind = "";
	
	//버튼 FALG
	private String btnFlag = "";
	
	private String aiInptBizDscd = "";
	
	// 현재 액티비티 코드
	private String curtAiInspAtvtCd = "";
	// 다음 액티비티 코드
	private String nextAiInspAtvtCd = "";
	// 심사이력처리상태코드
	private String aiInptAcvtStsCd = "";
	
	
	// TotalText 항목심사
	private int aiInptTotaltextSrno;
	private String aiInptTotaltextRvsnYn = "";
	private String inptSanctionDatTxt = "";
	private int itmInptXaxisStaCrdnCn;
	private int itmInptXaxisEndCrdnCn;
	private int itmInptYaxisStaCrdnCn;
	private int itmInptYaxisEndCrdnCn;
	private String aiInptTotaltextFindword = "";
	
	private String inptSanctionNo;
	private String inptSanctionNm = "";
	private String itmInptNacrdYn = "";
	private String itmInptRvsnYn = "";
	private String bfrsAicrExtcTxt = "";
	private String afrsAicrExtcTxt = "";
	private String itmInptHndgInpDatTxt = "";
	private String orgItmInptHndgInpDatTxt = "";
	// [수기추가 컬럼 기능] 1011 화면 "항목심사" 그리드에서 사용자가 동적으로 추가하는
	// "수기 추가" 컬럼(최대 3개, docs/feature-manual-add-column.md 참고)의 저장값.
	// CSPD004TF.ITM_INPT_HNDG_ADD1_TXT/ADD2_TXT/ADD3_TXT 와 1:1 매핑.
	private String itmInptHndgAdd1Txt = "";
	private String itmInptHndgAdd2Txt = "";
	private String itmInptHndgAdd3Txt = "";
	private String sfwcItmYn = "";
	private String aiInptSanctionRuleTxt = "";
	private String aiInptExtcSntnTxt = "";
	private String inptAtmcBizNm = "";
	private String concatImexHisCd = "";
	

	// 전달정보
	private int aiInptAppvSrno;
	private String aiInptQlasPrcStsCd = "";
	private String aiInptTotaltextRstCd = "";
	private String aiInptItmRstCd = "";
	private String aiInptCrpeEno = "";
	private String aiInptCrpeNm = "";
	private String aiInptPrcOpiTxt = "";
	private String aiInptAppvStcd = "";  // 결재이력처리상태
	private String trnLogSrno = "";
	private String lstDbChgId = "";
	private String lstDbChgDtm = "";
	private String aiInptTpySaveYn = "";
	private String mstTotaltextAiInptRstCd = "";
	private String mstInptItmAiInptRstCd = "";
	private String mstQltGrnAiInptRstCd = "";
	
	private String totrstNm = "";
	private String itmrstNm = "";
	private String qarstNm = "";
	
	private String totaltextAiInptRstCd = ""; // 다운 추가한거
	private String itmInptAiInptRstCd = "";
	private String safewatchAiInptRstCd = "";
	private String aiInptAcvtCd = "";
	
	// 재상신 버튼 보이기 여부
	private String rebtnYn = "";
	
	// CSPD001TM의 QA필드
	private String aiInptQaAppvPrgStcd = "";
	private String aiInptQaPrcsCd = "";
	private String aiInptQlasAcvtCd = "";
	
	private int imexHisSrno;
	private String aiInptWordAcrdRt = "";
	private String aiInptCmnCdEngNm = "";

	// 이미지키
	private String aiInptImgKeyNo = "";
	
	
	// safeWatch
	private String filtInptRrstRecpDtm = "";
	private String filtInptRstSrno = "";
	private String blNo = "";
	
	// 담당자
	private String aiInspeEno = "";
	private String aiInptAnpeEno = "";
	private String qlasCrpeEno = "";
	private String qlasSnpeEno = "";
	
	
	private String qltGrnAiInptRstCd ="";
	
	
	
	public String getQltGrnAiInptRstCd() {
		return qltGrnAiInptRstCd;
	}
	public void setQltGrnAiInptRstCd(String qltGrnAiInptRstCd) {
		this.qltGrnAiInptRstCd = qltGrnAiInptRstCd;
	}
	public String getAiInspeEno() {
		return aiInspeEno;
	}
	public void setAiInspeEno(String aiInspeEno) {
		this.aiInspeEno = aiInspeEno;
	}
	public String getAiInptAnpeEno() {
		return aiInptAnpeEno;
	}
	public void setAiInptAnpeEno(String aiInptAnpeEno) {
		this.aiInptAnpeEno = aiInptAnpeEno;
	}
	public String getQlasCrpeEno() {
		return qlasCrpeEno;
	}
	public void setQlasCrpeEno(String qlasCrpeEno) {
		this.qlasCrpeEno = qlasCrpeEno;
	}
	public String getQlasSnpeEno() {
		return qlasSnpeEno;
	}
	public void setQlasSnpeEno(String qlasSnpeEno) {
		this.qlasSnpeEno = qlasSnpeEno;
	}
	public String getFiltInptRrstRecpDtm() {
		return filtInptRrstRecpDtm;
	}
	public void setFiltInptRrstRecpDtm(String filtInptRrstRecpDtm) {
		this.filtInptRrstRecpDtm = filtInptRrstRecpDtm;
	}
	public String getFiltInptRstSrno() {
		return filtInptRstSrno;
	}
	public void setFiltInptRstSrno(String filtInptRstSrno) {
		this.filtInptRstSrno = filtInptRstSrno;
	}
	public String getBlNo() {
		return blNo;
	}
	public void setBlNo(String blNo) {
		this.blNo = blNo;
	}
	public int getImexHisSrno() {
		return imexHisSrno;
	}
	public String getAiInptImgKeyNo() {
		return aiInptImgKeyNo;
	}
	public void setAiInptImgKeyNo(String aiInptImgKeyNo) {
		this.aiInptImgKeyNo = aiInptImgKeyNo;
	}
	public void setImexHisSrno(int imexHisSrno) {
		this.imexHisSrno = imexHisSrno;
	}
	public String getAiInptWordAcrdRt() {
		return aiInptWordAcrdRt;
	}
	public void setAiInptWordAcrdRt(String aiInptWordAcrdRt) {
		this.aiInptWordAcrdRt = aiInptWordAcrdRt;
	}
	public String getAiInptCmnCdEngNm() {
		return aiInptCmnCdEngNm;
	}
	public void setAiInptCmnCdEngNm(String aiInptCmnCdEngNm) {
		this.aiInptCmnCdEngNm = aiInptCmnCdEngNm;
	}
	public String getSafewatchItmYn() {
		return safewatchItmYn;
	}
	public void setSafewatchItmYn(String safewatchItmYn) {
		this.safewatchItmYn = safewatchItmYn;
	}
	public String getConcatImexHisCd() {
		return concatImexHisCd;
	}
	public void setConcatImexHisCd(String concatImexHisCd) {
		this.concatImexHisCd = concatImexHisCd;
	}
	public int getInptMstSrno() {
		return inptMstSrno;
	}
	public void setInptMstSrno(int inptMstSrno) {
		this.inptMstSrno = inptMstSrno;
	}
	public int getInptBlGrpNo() {
		return inptBlGrpNo;
	}
	public void setInptBlGrpNo(int inptBlGrpNo) {
		this.inptBlGrpNo = inptBlGrpNo;
	}
	public int getInptBlGrpNoModi() {
		return inptBlGrpNoModi;
	}
	public int getInptBlGrpNoOrg() {
		return inptBlGrpNoOrg;
	}
	public void setInptBlGrpNoOrg(int inptBlGrpNoOrg) {
		this.inptBlGrpNoOrg = inptBlGrpNoOrg;
	}
	public void setInptBlGrpNoModi(int inptBlGrpNoModi) {
		this.inptBlGrpNoModi = inptBlGrpNoModi;
	}
	public String getImexHisCd() {
		return imexHisCd;
	}
	public void setImexHisCd(String imexHisCd) {
		this.imexHisCd = imexHisCd;
	}
	public String getImexHisNm() {
		return imexHisNm;
	}
	public void setImexHisNm(String imexHisNm) {
		this.imexHisNm = imexHisNm;
	}
	public String getImexhissAbbr() {
		return imexhissAbbr;
	}
	public void setImexhissAbbr(String imexhissAbbr) {
		this.imexhissAbbr = imexhissAbbr;
	}
	public String getImexHisCdOrg() {
		return imexHisCdOrg;
	}
	public void setImexHisCdOrg(String imexHisCdOrg) {
		this.imexHisCdOrg = imexHisCdOrg;
	}
	public String getImexHisNmOrg() {
		return imexHisNmOrg;
	}
	public void setImexHisNmOrg(String imexHisNmOrg) {
		this.imexHisNmOrg = imexHisNmOrg;
	}
	public String getInptTaskId() {
		return inptTaskId;
	}
	public void setInptTaskId(String inptTaskId) {
		this.inptTaskId = inptTaskId;
	}
	public String getInptElmtId() {
		return inptElmtId;
	}
	public void setInptElmtId(String inptElmtId) {
		this.inptElmtId = inptElmtId;
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
	public int getFfxRefnoSrno() {
		return ffxRefnoSrno;
	}
	public void setFfxRefnoSrno(int ffxRefnoSrno) {
		this.ffxRefnoSrno = ffxRefnoSrno;
	}
	public int getPageNo() {
		return pageNo;
	}
	public void setPageNo(int pageNo) {
		this.pageNo = pageNo;
	}
	public String getItmCoordinates() {
		return itmCoordinates;
	}
	public void setItmCoordinates(String itmCoordinates) {
		this.itmCoordinates = itmCoordinates;
	}
	public String getAiInptAltYn() {
		return aiInptAltYn;
	}
	public void setAiInptAltYn(String aiInptAltYn) {
		this.aiInptAltYn = aiInptAltYn;
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
	public List<CommonRevertDetailVO> getSanctionList() {
		return sanctionList;
	}
	public void setSanctionList(List<CommonRevertDetailVO> sanctionList) {
		this.sanctionList = sanctionList;
	}
	public String getBlTabNm() {
		return blTabNm;
	}
	public void setBlTabNm(String blTabNm) {
		this.blTabNm = blTabNm;
	}
	public String getSpdKind() {
		return spdKind;
	}
	public void setSpdKind(String spdKind) {
		this.spdKind = spdKind;
	}
	public String getStRstKind() {
		return stRstKind;
	}
	public void setStRstKind(String stRstKind) {
		this.stRstKind = stRstKind;
	}
	public String getBtnFlag() {
		return btnFlag;
	}
	public void setBtnFlag(String btnFlag) {
		this.btnFlag = btnFlag;
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
	public String getNextAiInspAtvtCd() {
		return nextAiInspAtvtCd;
	}
	public void setNextAiInspAtvtCd(String nextAiInspAtvtCd) {
		this.nextAiInspAtvtCd = nextAiInspAtvtCd;
	}
	public String getAiInptAcvtStsCd() {
		return aiInptAcvtStsCd;
	}
	public void setAiInptAcvtStsCd(String aiInptAcvtStsCd) {
		this.aiInptAcvtStsCd = aiInptAcvtStsCd;
	}
	public int getAiInptTotaltextSrno() {
		return aiInptTotaltextSrno;
	}
	public void setAiInptTotaltextSrno(int aiInptTotaltextSrno) {
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
	public int getItmInptXaxisStaCrdnCn() {
		return itmInptXaxisStaCrdnCn;
	}
	public void setItmInptXaxisStaCrdnCn(int itmInptXaxisStaCrdnCn) {
		this.itmInptXaxisStaCrdnCn = itmInptXaxisStaCrdnCn;
	}
	public int getItmInptXaxisEndCrdnCn() {
		return itmInptXaxisEndCrdnCn;
	}
	public void setItmInptXaxisEndCrdnCn(int itmInptXaxisEndCrdnCn) {
		this.itmInptXaxisEndCrdnCn = itmInptXaxisEndCrdnCn;
	}
	public int getItmInptYaxisStaCrdnCn() {
		return itmInptYaxisStaCrdnCn;
	}
	public void setItmInptYaxisStaCrdnCn(int itmInptYaxisStaCrdnCn) {
		this.itmInptYaxisStaCrdnCn = itmInptYaxisStaCrdnCn;
	}
	public int getItmInptYaxisEndCrdnCn() {
		return itmInptYaxisEndCrdnCn;
	}
	public void setItmInptYaxisEndCrdnCn(int itmInptYaxisEndCrdnCn) {
		this.itmInptYaxisEndCrdnCn = itmInptYaxisEndCrdnCn;
	}
	public String getAiInptTotaltextFindword() {
		return aiInptTotaltextFindword;
	}
	public void setAiInptTotaltextFindword(String aiInptTotaltextFindword) {
		this.aiInptTotaltextFindword = aiInptTotaltextFindword;
	}
	public String getInptSanctionNo() {
		return inptSanctionNo;
	}
	public void setInptSanctionNo(String inptSanctionNo) {
		this.inptSanctionNo = inptSanctionNo;
	}
	public String getInptSanctionNm() {
		return inptSanctionNm;
	}
	public void setInptSanctionNm(String inptSanctionNm) {
		this.inptSanctionNm = inptSanctionNm;
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
	public String getItmInptHndgInpDatTxt() {
		return itmInptHndgInpDatTxt;
	}
	public void setItmInptHndgInpDatTxt(String itmInptHndgInpDatTxt) {
		this.itmInptHndgInpDatTxt = itmInptHndgInpDatTxt;
	}
	public String getOrgItmInptHndgInpDatTxt() {
		return orgItmInptHndgInpDatTxt;
	}
	public void setOrgItmInptHndgInpDatTxt(String orgItmInptHndgInpDatTxt) {
		this.orgItmInptHndgInpDatTxt = orgItmInptHndgInpDatTxt;
	}
	// [수기추가 컬럼 기능] getter/setter — CSPD004TF.ITM_INPT_HNDG_ADD1/2/3_TXT 매핑용
	public String getItmInptHndgAdd1Txt() {
		return itmInptHndgAdd1Txt;
	}
	public void setItmInptHndgAdd1Txt(String itmInptHndgAdd1Txt) {
		this.itmInptHndgAdd1Txt = itmInptHndgAdd1Txt;
	}
	public String getItmInptHndgAdd2Txt() {
		return itmInptHndgAdd2Txt;
	}
	public void setItmInptHndgAdd2Txt(String itmInptHndgAdd2Txt) {
		this.itmInptHndgAdd2Txt = itmInptHndgAdd2Txt;
	}
	public String getItmInptHndgAdd3Txt() {
		return itmInptHndgAdd3Txt;
	}
	public void setItmInptHndgAdd3Txt(String itmInptHndgAdd3Txt) {
		this.itmInptHndgAdd3Txt = itmInptHndgAdd3Txt;
	}
	public String getSfwcItmYn() {
		return sfwcItmYn;
	}
	public void setSfwcItmYn(String sfwcItmYn) {
		this.sfwcItmYn = sfwcItmYn;
	}
	public String getAiInptSanctionRuleTxt() {
		return aiInptSanctionRuleTxt;
	}
	public void setAiInptSanctionRuleTxt(String aiInptSanctionRuleTxt) {
		this.aiInptSanctionRuleTxt = aiInptSanctionRuleTxt;
	}
	public String getAiInptExtcSntnTxt() {
		return aiInptExtcSntnTxt;
	}
	public void setAiInptExtcSntnTxt(String aiInptExtcSntnTxt) {
		this.aiInptExtcSntnTxt = aiInptExtcSntnTxt;
	}
	public int getAiInptAppvSrno() {
		return aiInptAppvSrno;
	}
	public void setAiInptAppvSrno(int aiInptAppvSrno) {
		this.aiInptAppvSrno = aiInptAppvSrno;
	}
	public String getAiInptQlasPrcStsCd() {
		return aiInptQlasPrcStsCd;
	}
	public void setAiInptQlasPrcStsCd(String aiInptQlasPrcStsCd) {
		this.aiInptQlasPrcStsCd = aiInptQlasPrcStsCd;
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
	public String getAiInptCrpeEno() {
		return aiInptCrpeEno;
	}
	public void setAiInptCrpeEno(String aiInptCrpeEno) {
		this.aiInptCrpeEno = aiInptCrpeEno;
	}
	public String getAiInptCrpeNm() {
		return aiInptCrpeNm;
	}
	public void setAiInptCrpeNm(String aiInptCrpeNm) {
		this.aiInptCrpeNm = aiInptCrpeNm;
	}
	public String getAiInptPrcOpiTxt() {
		return aiInptPrcOpiTxt;
	}
	public void setAiInptPrcOpiTxt(String aiInptPrcOpiTxt) {
		this.aiInptPrcOpiTxt = aiInptPrcOpiTxt;
	}
	public String getAiInptAppvStcd() {
		return aiInptAppvStcd;
	}
	public void setAiInptAppvStcd(String aiInptAppvStcd) {
		this.aiInptAppvStcd = aiInptAppvStcd;
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
	public String getAiInptTpySaveYn() {
		return aiInptTpySaveYn;
	}
	public void setAiInptTpySaveYn(String aiInptTpySaveYn) {
		this.aiInptTpySaveYn = aiInptTpySaveYn;
	}
	public String getMstTotaltextAiInptRstCd() {
		return mstTotaltextAiInptRstCd;
	}
	public void setMstTotaltextAiInptRstCd(String mstTotaltextAiInptRstCd) {
		this.mstTotaltextAiInptRstCd = mstTotaltextAiInptRstCd;
	}
	public String getMstInptItmAiInptRstCd() {
		return mstInptItmAiInptRstCd;
	}
	public void setMstInptItmAiInptRstCd(String mstInptItmAiInptRstCd) {
		this.mstInptItmAiInptRstCd = mstInptItmAiInptRstCd;
	}
	public String getMstQltGrnAiInptRstCd() {
		return mstQltGrnAiInptRstCd;
	}
	public void setMstQltGrnAiInptRstCd(String mstQltGrnAiInptRstCd) {
		this.mstQltGrnAiInptRstCd = mstQltGrnAiInptRstCd;
	}
	public String getTotrstNm() {
		return totrstNm;
	}
	public void setTotrstNm(String totrstNm) {
		this.totrstNm = totrstNm;
	}
	public String getItmrstNm() {
		return itmrstNm;
	}
	public void setItmrstNm(String itmrstNm) {
		this.itmrstNm = itmrstNm;
	}
	public String getQarstNm() {
		return qarstNm;
	}
	public void setQarstNm(String qarstNm) {
		this.qarstNm = qarstNm;
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
	public String getAiInptAcvtCd() {
		return aiInptAcvtCd;
	}
	public void setAiInptAcvtCd(String aiInptAcvtCd) {
		this.aiInptAcvtCd = aiInptAcvtCd;
	}
	public String getRebtnYn() {
		return rebtnYn;
	}
	public void setRebtnYn(String rebtnYn) {
		this.rebtnYn = rebtnYn;
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
	public String getAiInptQlasAcvtCd() {
		return aiInptQlasAcvtCd;
	}
	public void setAiInptQlasAcvtCd(String aiInptQlasAcvtCd) {
		this.aiInptQlasAcvtCd = aiInptQlasAcvtCd;
	}
	public String getInptAtmcBizNm() {
		return inptAtmcBizNm;
	}
	public void setInptAtmcBizNm(String inptAtmcBizNm) {
		this.inptAtmcBizNm = inptAtmcBizNm;
	}
	public String getAiInptPapsQltScre() {
		return aiInptPapsQltScre;
	}
	public void setAiInptPapsQltScre(String aiInptPapsQltScre) {
		this.aiInptPapsQltScre = aiInptPapsQltScre;
	}
	public String getSwNm() {
		return swNm;
	}
	public void setSwNm(String swNm) {
		this.swNm = swNm;
	}
	public String getFiltDtctDo() {
		return filtDtctDo;
	}
	public void setFiltDtctDo(String filtDtctDo) {
		this.filtDtctDo = filtDtctDo;
	}
	public String getSafewatchAiInptRstCd() {
		return safewatchAiInptRstCd;
	}
	public void setSafewatchAiInptRstCd(String safewatchAiInptRstCd) {
		this.safewatchAiInptRstCd = safewatchAiInptRstCd;
	}
	public String getAiInptQlasProsCd() {
		return aiInptQlasProsCd;
	}
	public void setAiInptQlasProsCd(String aiInptQlasProsCd) {
		this.aiInptQlasProsCd = aiInptQlasProsCd;
	}
	public int getFxRefnoSrno() {
		return fxRefnoSrno;
	}
	public void setFxRefnoSrno(int fxRefnoSrno) {
		this.fxRefnoSrno = fxRefnoSrno;
	}
	
	
//	aiInptAppvStcd -> aiInptAppvStcd
//	aiInptAcvtCd -> aiInptAcvtCd
//	aiInptQlasAcvtCd -> aiInptQlasAcvtCd
//	inptSanctionDatTxt -> inptSanctionDatTxt
//	itmInptXaxisStaCrdnCn -> itmInptXaxisStaCrdnCn
//	itmInptYaxisStaCrdnCn -> itmInptYaxisStaCrdnCn
//	itmInptXaxisEndCrdnCn -> itmInptXaxisEndCrdnCn
//	itmInptYaxisEndCrdnCn -> itmInptYaxisEndCrdnCn
//	aiInptSanctionRuleTxt -> aiInptSanctionRuleTxt
//	inptSanctionDatTxt -> inptSanctionDatTxt
//	aiInptExtcSntnTxt -> aiInptExtcSntnTxt
//	aiInptAppvSrno -> aiInptAppvSrno
//	aiInptPrcDtm -> aiInptPrcDtm
//	aiInspPrc_opi -> aiInptPrc_opiTxt
//	aiInptItmRstCd -> aiInptItmRstCd
//	aiInptQlasPrcStsCd -> aiInptQlasPrcStsCd
//	aiInptPrgSrno -> aiInptPrgSrno
//	aiInptAcvtStsCd -> aiInptAcvtStsCd
//	aiInptCrpeEno -> aiInptCrpeEno
//	aiInptProsStaDtm -> aiInptProsStaDtm
//	aiInptRmrkTxt -> aiInptRmrkTxtTxt

	
}
