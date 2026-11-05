package com.woori.ajs.model;

import java.util.ArrayList;
import java.util.List;

@SuppressWarnings("serial")
public class SearchVO extends DefaultVO {
	private String[] ids;
	private String userId;
	private String schGbn;
	private String schRefNo;
	private String schUserNo;
	private String schUserNoNm;
	private String schTerm;
	private String schAuth;
	private String schAdminYN;
	private String schUseYN;
	private String schUserNm;
	private String schSdate;
	private String schEdate;
	private String schSdate1;
	private String schEdate1;
	private String schSdate2;
	private String schEdate2;
	private String schSdate3;
	private String schEdate3;
	private String schUserIp;
	private String schText1;		//일반검색어1
	private String schText2;		//일반검색어2
	private String schText3;		//일반검색어3
	
	private String filtDtctNo;

	private String menuId;

	private String catCd;			//카테고리아이디
	private String lstCd;			//리스트아이디
	private String sncCd;			//내용아이디
	
	private int inptMstSrno;
	private String inptTaskId;
	private String inptElmtId;
	private String inptAtmcBizDscd;
	private String actlFxRefno;
	private String aiInptCsno;
	private String inptRcpDt;
	
	private String aiInptGrpCd;
	
	private String aiInptCtgrId;
	private String aiInptListId;
	
	private String inptBizAlctCrpeFnm;
	private String inptBizAlctCrpeEno;
	private String inptAtvtNm;
	private String aiInptCmnCd;
	
	private String inptAtvtCd;
	private String appvPrgStcd;
	
	private String aiInptCusNo;

	private String aiInspAtvtStsNm;
	private String aiInspAtvtStsCd;
	private String sAiInptCmnCdNm;
	private String inptAtmcBizDsNm;
	
	private String errCd;
	
	private String schTotalText;			//TotalText
	private String schInptItem;				//항목심사
	private String schSafeWatch;			//SafeWatch
	
	private String aiInptUserFaReYn;		//사용자 부재여부
	
	private String inptPrcsCd;
	
	private String aiInptClsDscd;
	
	private String aiInptClsDt;
	private String detailCallType;
	private String inptBizAlctCrpeAuth;
	
	// 통계 조회조건 항목(텍스트 선택 or 리스트 선택 여부)
	private String aiInptListChk1;
	private String aiInptListChk2;
	private String aiInptListChk3;
	private String aiInptListChk4;
	private String aiInptListChk5;
	
	private String userYn;
	
	// 업무미생성목록(조건)
	private String aiInptAplXtRncd; // 제외사유
	private String aiInptXtPrcStsDscd; // 처리상태
	private List<RevertUngeneratedVO> revertUngeneratedCondList;
	
	// 영업일관리(조건)
	private String hldyYear; // 영업일 년도
	private String hldyMonth; // 영업일 월
	private String aiInptUserYn;
	private String aiInptSrvcUserDscd;
	
	// 거래로그일련번호
	private String trnLogSrno;
	
	private String engCityRgnNm;
	private String engCityNm;
	private String nacd;
	private String cityPortDscd;
	
	// 시스템심사진행현황(조건)
	private String aiSysInptPrgStcd; // 심사진행상태
	private String aiInptProcTime; // 처리경과시간
	
	private String schUserYn;
	private String aiInptUserEno;
	private String btnFlag;
	
	private String queryTestParam;
	private String crud;
	private String table;
	
	private String textOpt;
	private String aiInptHgrnMenuId;
	private String aiInptPrgSrno;
	private String hgMenuId;
	private String screenId;
	private String aiInptMenuId;
	
	
	public String getAiInptMenuId() {
		return aiInptMenuId;
	}
	public void setAiInptMenuId(String aiInptMenuId) {
		this.aiInptMenuId = aiInptMenuId;
	}
	public String getScreenId() {
		return screenId;
	}
	public void setScreenId(String screenId) {
		this.screenId = screenId;
	}
	public String getHgMenuId() {
		return hgMenuId;
	}
	public void setHgMenuId(String hgMenuId) {
		this.hgMenuId = hgMenuId;
	}
	public String getAiInptPrgSrno() {
		return aiInptPrgSrno;
	}
	public void setAiInptPrgSrno(String aiInptPrgSrno) {
		this.aiInptPrgSrno = aiInptPrgSrno;
	}
	public String getAiInptHgrnMenuId() {
		return aiInptHgrnMenuId;
	}
	public void setAiInptHgrnMenuId(String aiInptHgrnMenuId) {
		this.aiInptHgrnMenuId = aiInptHgrnMenuId;
	}
	public String getTextOpt() {
		return textOpt;
	}
	public void setTextOpt(String textOpt) {
		this.textOpt = textOpt;
	}
	public String getTable() {
		return table;
	}
	public void setTable(String table) {
		this.table = table;
	}
	public String getCrud() {
		return crud;
	}
	public void setCrud(String crud) {
		this.crud = crud;
	}
	public String getQueryTestParam() {
		return queryTestParam;
	}
	public void setQueryTestParam(String queryTestParam) {
		this.queryTestParam = queryTestParam;
	}
	public String getBtnFlag() {
		return btnFlag;
	}
	public void setBtnFlag(String btnFlag) {
		this.btnFlag = btnFlag;
	}
	public String getCityPortDscd() {
		return cityPortDscd;
	}
	public void setCityPortDscd(String cityPortDscd) {
		this.cityPortDscd = cityPortDscd;
	}
	public String getEngCityRgnNm() {
		return engCityRgnNm;
	}
	public void setEngCityRgnNm(String engCityRgnNm) {
		this.engCityRgnNm = engCityRgnNm;
	}
	public String getAiInptUserEno() {
		return aiInptUserEno;
	}
	public void setAiInptUserEno(String aiInptUserEno) {
		this.aiInptUserEno = aiInptUserEno;
	}
	public String getSchUserYn() {
		return schUserYn;
	}
	public void setSchUserYn(String schUserYn) {
		this.schUserYn = schUserYn;
	}
	public String getEngCityNm() {
		return engCityNm;
	}
	public void setEngCityNm(String engCityNm) {
		this.engCityNm = engCityNm;
	}
	public String getNacd() {
		return nacd;
	}
	public void setNacd(String nacd) {
		this.nacd = nacd;
	}
	public String getAiSysInptPrgStcd() {
		return aiSysInptPrgStcd;
	}
	public void setAiSysInptPrgStcd(String aiSysInptPrgStcd) {
		this.aiSysInptPrgStcd = aiSysInptPrgStcd;
	}
	public String getAiInptProcTime() {
		return aiInptProcTime;
	}
	public void setAiInptProcTime(String aiInptProcTime) {
		this.aiInptProcTime = aiInptProcTime;
	}
	public String getTrnLogSrno() {
		return trnLogSrno;
	}
	public void setTrnLogSrno(String trnLogSrno) {
		this.trnLogSrno = trnLogSrno;
	}
	public String getAiInptSrvcUserDscd() {
		return aiInptSrvcUserDscd;
	}
	public void setAiInptSrvcUserDscd(String aiInptSrvcUserDscd) {
		this.aiInptSrvcUserDscd = aiInptSrvcUserDscd;
	}
	public String getAiInptUserYn() {
		return aiInptUserYn;
	}
	public void setAiInptUserYn(String aiInptUserYn) {
		this.aiInptUserYn = aiInptUserYn;
	}
	public String getHldyYear() {
		return hldyYear;
	}
	public void setHldyYear(String hldyYear) {
		this.hldyYear = hldyYear;
	}
	public String getHldyMonth() {
		return hldyMonth;
	}
	public void setHldyMonth(String hldyMonth) {
		this.hldyMonth = hldyMonth;
	}
	public List<RevertUngeneratedVO> getRevertUngeneratedCondList() {
		return revertUngeneratedCondList;
	}
	public void setRevertUngeneratedCondList(List<RevertUngeneratedVO> revertUngeneratedCondList) {
		this.revertUngeneratedCondList = revertUngeneratedCondList;
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
	public String getUserYn() {
		return userYn;
	}
	public void setUserYn(String userYn) {
		this.userYn = userYn;
	}
	public String getAiInptListChk1() {
		return aiInptListChk1;
	}
	public void setAiInptListChk1(String aiInptListChk1) {
		this.aiInptListChk1 = aiInptListChk1;
	}
	public String getAiInptListChk2() {
		return aiInptListChk2;
	}
	public void setAiInptListChk2(String aiInptListChk2) {
		this.aiInptListChk2 = aiInptListChk2;
	}
	public String getAiInptListChk3() {
		return aiInptListChk3;
	}
	public void setAiInptListChk3(String aiInptListChk3) {
		this.aiInptListChk3 = aiInptListChk3;
	}
	public String getAiInptListChk4() {
		return aiInptListChk4;
	}
	public void setAiInptListChk4(String aiInptListChk4) {
		this.aiInptListChk4 = aiInptListChk4;
	}
	public String getAiInptListChk5() {
		return aiInptListChk5;
	}
	public void setAiInptListChk5(String aiInptListChk5) {
		this.aiInptListChk5 = aiInptListChk5;
	}
	// 통계 조회조건 항목(Sanction)
	private String inptSanctionNo;
	private String inptSanctionNo1;
	private String inptSanctionNo2;
	private String inptSanctionNo3;
	private String inptSanctionNo4;
	private String inptSanctionNo5;
	private String inptSanctionNum;
	private int inptSanctionNum1;
	private int inptSanctionNum2;
	private int inptSanctionNum3;
	private int inptSanctionNum4;
	private int inptSanctionNum5;
	
	// 통계 조회조건 WatchList List
	private String aiInptListId1;
	private String aiInptListId2;
	private String aiInptListId3;
	private String aiInptListId4;
	public int getInptSanctionNum1() {
		return inptSanctionNum1;
	}
	public void setInptSanctionNum1(int inptSanctionNum1) {
		this.inptSanctionNum1 = inptSanctionNum1;
	}
	public int getInptSanctionNum2() {
		return inptSanctionNum2;
	}
	public void setInptSanctionNum2(int inptSanctionNum2) {
		this.inptSanctionNum2 = inptSanctionNum2;
	}
	public int getInptSanctionNum3() {
		return inptSanctionNum3;
	}
	public void setInptSanctionNum3(int inptSanctionNum3) {
		this.inptSanctionNum3 = inptSanctionNum3;
	}
	public int getInptSanctionNum4() {
		return inptSanctionNum4;
	}
	public void setInptSanctionNum4(int inptSanctionNum4) {
		this.inptSanctionNum4 = inptSanctionNum4;
	}
	public int getInptSanctionNum5() {
		return inptSanctionNum5;
	}
	public void setInptSanctionNum5(int inptSanctionNum5) {
		this.inptSanctionNum5 = inptSanctionNum5;
	}
	private String aiInptListId5;
	
	// 통계 조회조건 텍스트
	private String aiInptListText;
	private String aiInptListText1;
	private String aiInptListText2;
	private String aiInptListText3;
	private String aiInptListText4;
	private String aiInptListText5;
	
	private ArrayList<Integer> inptMstSrnoList;
	private ArrayList<String> rsptTxtDesTxt;
	private String inptAtmcBizDscdList;
	private String inptAtmcBizDscd2;
	private String inptAtmcBizDscd3;
	
	private String aiInptAtflSrno;
	
	//업무일지 - 업무마감 (5010) - 당일목록 건수
	//업무일지 - 업무일지 등록 (5020) - 제재심사 건수
	private int taskDatesCnt1;
	private int taskDatesCnt2;
	private int taskDatesCnt3;
	
	private String schRepYn;	//국가정보관리, 대표이름여부
	private int inptMstSrnoListSize;
	
	
	public int getInptMstSrnoListSize() {
		return inptMstSrnoListSize;
	}
	public void setInptMstSrnoListSize(int inptMstSrnoListSize) {
		this.inptMstSrnoListSize = inptMstSrnoListSize;
	}
	public String getSchSdate() {
		return schSdate;
	}
	public void setSchSdate(String schSdate) {
		this.schSdate = schSdate;
	}
	public String getSchEdate() {
		return schEdate;
	}
	public void setSchEdate(String schEdate) {
		this.schEdate = schEdate;
	}
	public String getAiInspAtvtStsNm() {
		return aiInspAtvtStsNm;
	}
	public void setAiInspAtvtStsNm(String aiInspAtvtStsNm) {
		this.aiInspAtvtStsNm = aiInspAtvtStsNm;
	}
	public String getFiltDtctNo() {
		return filtDtctNo;
	}
	public void setFiltDtctNo(String filtDtctNo) {
		this.filtDtctNo = filtDtctNo;
	}
	public String getInptAtmcBizDscdList() {
		return inptAtmcBizDscdList;
	}
	public void setInptAtmcBizDscdList(String inptAtmcBizDscdList) {
		this.inptAtmcBizDscdList = inptAtmcBizDscdList;
	}
	public String getInptAtmcBizDscd2() {
		return inptAtmcBizDscd2;
	}
	public void setInptAtmcBizDscd2(String inptAtmcBizDscd2) {
		this.inptAtmcBizDscd2 = inptAtmcBizDscd2;
	}
	public String getInptAtmcBizDscd3() {
		return inptAtmcBizDscd3;
	}
	public void setInptAtmcBizDscd3(String inptAtmcBizDscd3) {
		this.inptAtmcBizDscd3 = inptAtmcBizDscd3;
	}
	public String getAiInptAtflSrno() {
		return aiInptAtflSrno;
	}
	public void setAiInptAtflSrno(String aiInptAtflSrno) {
		this.aiInptAtflSrno = aiInptAtflSrno;
	}
	public ArrayList<Integer> getInptMstSrnoList() {
		return inptMstSrnoList;
	}
	public void setInptMstSrnoList(ArrayList<Integer> inptMstSrnoList) {
		this.inptMstSrnoList = inptMstSrnoList;
	}
	public ArrayList<String> getRsptTxtDesTxt() {
		return rsptTxtDesTxt;
	}
	public void setRsptTxtDesTxt(ArrayList<String> rsptTxtDesTxt) {
		this.rsptTxtDesTxt = rsptTxtDesTxt;
	}
	public String getInptBizAlctCrpeAuth() {
		return inptBizAlctCrpeAuth;
	}
	public void setInptBizAlctCrpeAuth(String inptBizAlctCrpeAuth) {
		this.inptBizAlctCrpeAuth = inptBizAlctCrpeAuth;
	}
	public String getDetailCallType() {
		return detailCallType;
	}
	public void setDetailCallType(String detailCallType) {
		this.detailCallType = detailCallType;
	}
	public String getInptPrcsCd() {
		return inptPrcsCd;
	}
	public void setInptPrcsCd(String inptPrcsCd) {
		this.inptPrcsCd = inptPrcsCd;
	}
	
	public String getAiInspAtvtStsCd() {
		return aiInspAtvtStsCd;
	}
	public void setAiInspAtvtStsCd(String aiInspAtvtStsCd) {
		this.aiInspAtvtStsCd = aiInspAtvtStsCd;
	}
	public String getsAiInptCmnCdNm() {
		return sAiInptCmnCdNm;
	}
	public void setsAiInptCmnCdNm(String sAiInptCmnCdNm) {
		this.sAiInptCmnCdNm = sAiInptCmnCdNm;
	}
	public String getInptAtmcBizDsNm() {
		return inptAtmcBizDsNm;
	}
	public void setInptAtmcBizDsNm(String inptAtmcBizDsNm) {
		this.inptAtmcBizDsNm = inptAtmcBizDsNm;
	}
	public String getAiInptCusNo() {
		return aiInptCusNo;
	}
	public void setAiInptCusNo(String aiInptCusNo) {
		this.aiInptCusNo = aiInptCusNo;
	}
	public String getInptAtvtCd() {
		return inptAtvtCd;
	}
	public void setInptAtvtCd(String inptAtvtCd) {
		this.inptAtvtCd = inptAtvtCd;
	}
	public String getAiInptCmnCd() {
		return aiInptCmnCd;
	}
	public void setAiInptCmnCd(String aiInptCmnCd) {
		this.aiInptCmnCd = aiInptCmnCd;
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
	public String getInptAtvtNm() {
		return inptAtvtNm;
	}
	public void setInptAtvtNm(String inptAtvtNm) {
		this.inptAtvtNm = inptAtvtNm;
	}
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public String getInptRcpDt() {
		return inptRcpDt;
	}
	public void setInptRcpDt(String inptRcpDt) {
		this.inptRcpDt = inptRcpDt;
	}
	public String getSchGbn() {
		return schGbn;
	}
	public void setSchGbn(String schGbn) {
		this.schGbn = schGbn;
	}
	public String getSchRefNo() {
		return schRefNo;
	}
	public void setSchRefNo(String schRefNo) {
		this.schRefNo = schRefNo;
	}
	public String getSchUserNo() {
		return schUserNo;
	}
	public void setSchUserNo(String schUserNo) {
		this.schUserNo = schUserNo;
	}
	public String getSchTerm() {
		return schTerm;
	}
	public void setSchTerm(String schTerm) {
		this.schTerm = schTerm;
	}
	public String getSchAuth() {
		return schAuth;
	}
	public void setSchAuth(String schAuth) {
		this.schAuth = schAuth;
	}
	public String getSchUserNm() {
		return schUserNm;
	}
	public void setSchUserNm(String schUserNm) {
		this.schUserNm = schUserNm;
	}
	public String getMenuId() {
		return menuId;
	}
	public void setMenuId(String menuId) {
		this.menuId = menuId;
	}
	public String getCatCd() {
		return catCd;
	}
	public void setCatCd(String catCd) {
		this.catCd = catCd;
	}
	public String getLstCd() {
		return lstCd;
	}
	public void setLstCd(String lstCd) {
		this.lstCd = lstCd;
	}
	public String getSchAdminYN() {
		return schAdminYN;
	}
	public void setSchAdminYN(String schAdminYN) {
		this.schAdminYN = schAdminYN;
	}
	public String getSchUseYN() {
		return schUseYN;
	}
	public void setSchUseYN(String schUseYN) {
		this.schUseYN = schUseYN;
	}
	public String getSncCd() {
		return sncCd;
	}
	public void setSncCd(String sncCd) {
		this.sncCd = sncCd;
	}
	public int getInptMstSrno() {
		return inptMstSrno;
	}
	public void setInptMstSrno(int inptMstSrno) {
		this.inptMstSrno = inptMstSrno;
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
	public String getAiInptGrpCd() {
		return aiInptGrpCd;
	}
	public void setAiInptGrpCd(String aiInptGrpCd) {
		this.aiInptGrpCd = aiInptGrpCd;
	}
	public String getSchSdate1() {
		return schSdate1;
	}
	public void setSchSdate1(String schSdate1) {
		this.schSdate1 = schSdate1;
	}
	public String getSchEdate1() {
		return schEdate1;
	}
	public void setSchEdate1(String schEdate1) {
		this.schEdate1 = schEdate1;
	}
	public String getSchSdate2() {
		return schSdate2;
	}
	public void setSchSdate2(String schSdate2) {
		this.schSdate2 = schSdate2;
	}
	public String getSchEdate2() {
		return schEdate2;
	}
	public void setSchEdate2(String schEdate2) {
		this.schEdate2 = schEdate2;
	}
	public String getSchSdate3() {
		return schSdate3;
	}
	public void setSchSdate3(String schSdate3) {
		this.schSdate3 = schSdate3;
	}
	public String getSchEdate3() {
		return schEdate3;
	}
	public void setSchEdate3(String schEdate3) {
		this.schEdate3 = schEdate3;
	}
	public String getInptAtmcBizDscd() {
		return inptAtmcBizDscd;
	}
	public void setInptAtmcBizDscd(String inptAtmcBizDscd) {
		this.inptAtmcBizDscd = inptAtmcBizDscd;
	}
	public String getActlFxRefno() {
		return actlFxRefno;
	}
	public void setActlFxRefno(String actlFxRefno) {
		this.actlFxRefno = actlFxRefno;
	}
	public String getAiInptCsno() {
		return aiInptCsno;
	}
	public void setAiInptCsno(String aiInptCsno) {
		this.aiInptCsno = aiInptCsno;
	}
	public String getAiInptCtgrId() {
		return aiInptCtgrId;
	}
	public void setAiInptCtgrId(String aiInptCtgrId) {
		this.aiInptCtgrId = aiInptCtgrId;
	}
	public String getAiInptListId() {
		return aiInptListId;
	}
	public void setAiInptListId(String aiInptListId) {
		this.aiInptListId = aiInptListId;
	}
	public String getAppvPrgStcd() {
		return appvPrgStcd;
	}
	public void setAppvPrgStcd(String appvPrgStcd) {
		this.appvPrgStcd = appvPrgStcd;
	}
	public String getErrCd() {
		return errCd;
	}
	public void setErrCd(String errCd) {
		this.errCd = errCd;
	}
	public String getSchTotalText() {
		return schTotalText;
	}
	public void setSchTotalText(String schTotalText) {
		this.schTotalText = schTotalText;
	}
	public String getSchInptItem() {
		return schInptItem;
	}
	public void setSchInptItem(String schInptItem) {
		this.schInptItem = schInptItem;
	}
	public String getSchSafeWatch() {
		return schSafeWatch;
	}
	public void setSchSafeWatch(String schSafeWatch) {
		this.schSafeWatch = schSafeWatch;
	}
	public String getSchUserNoNm() {
		return schUserNoNm;
	}
	public void setSchUserNoNm(String schUserNoNm) {
		this.schUserNoNm = schUserNoNm;
	}
	public String getAiInptUserFaReYn() {
		return aiInptUserFaReYn;
	}
	public void setAiInptUserFaReYn(String aiInptUserFaReYn) {
		this.aiInptUserFaReYn = aiInptUserFaReYn;
	}
	public String getAiInptClsDscd() {
		return aiInptClsDscd;
	}
	public void setAiInptClsDscd(String aiInptClsDscd) {
		this.aiInptClsDscd = aiInptClsDscd;
	}
	public String getAiInptClsDt() {
		return aiInptClsDt;
	}
	public void setAiInptClsDt(String aiInptClsDt) {
		this.aiInptClsDt = aiInptClsDt;
	}
	public String[] getIds() {
		return ids;
	}
	public void setIds(String[] ids) {
		this.ids = ids;
	}
	public String getInptSanctionNo() {
		return inptSanctionNo;
	}
	public void setInptSanctionNo(String inptSanctionNo) {
		this.inptSanctionNo = inptSanctionNo;
	}
	public String getInptSanctionNo1() {
		return inptSanctionNo1;
	}
	public void setInptSanctionNo1(String inptSanctionNo1) {
		this.inptSanctionNo1 = inptSanctionNo1;
	}
	public String getInptSanctionNo2() {
		return inptSanctionNo2;
	}
	public void setInptSanctionNo2(String inptSanctionNo2) {
		this.inptSanctionNo2 = inptSanctionNo2;
	}
	public String getInptSanctionNo3() {
		return inptSanctionNo3;
	}
	public void setInptSanctionNo3(String inptSanctionNo3) {
		this.inptSanctionNo3 = inptSanctionNo3;
	}
	public String getInptSanctionNo4() {
		return inptSanctionNo4;
	}
	public void setInptSanctionNo4(String inptSanctionNo4) {
		this.inptSanctionNo4 = inptSanctionNo4;
	}
	public String getInptSanctionNo5() {
		return inptSanctionNo5;
	}
	public void setInptSanctionNo5(String inptSanctionNo5) {
		this.inptSanctionNo5 = inptSanctionNo5;
	}
	
	public String getInptSanctionNum() {
		return inptSanctionNum;
	}
	public void setInptSanctionNum(String inptSanctionNum) {
		this.inptSanctionNum = inptSanctionNum;
	}
	public String getAiInptListId1() {
		return aiInptListId1;
	}
	public void setAiInptListId1(String aiInptListId1) {
		this.aiInptListId1 = aiInptListId1;
	}
	public String getAiInptListId2() {
		return aiInptListId2;
	}
	public void setAiInptListId2(String aiInptListId2) {
		this.aiInptListId2 = aiInptListId2;
	}
	public String getAiInptListId3() {
		return aiInptListId3;
	}
	public void setAiInptListId3(String aiInptListId3) {
		this.aiInptListId3 = aiInptListId3;
	}
	public String getAiInptListId4() {
		return aiInptListId4;
	}
	public void setAiInptListId4(String aiInptListId4) {
		this.aiInptListId4 = aiInptListId4;
	}
	public String getAiInptListId5() {
		return aiInptListId5;
	}
	public void setAiInptListId5(String aiInptListId5) {
		this.aiInptListId5 = aiInptListId5;
	}
	
	public String getAiInptListText() {
		return aiInptListText;
	}
	public void setAiInptListText(String aiInptListText) {
		this.aiInptListText = aiInptListText;
	}
	public String getAiInptListText1() {
		return aiInptListText1;
	}
	public void setAiInptListText1(String aiInptListText1) {
		this.aiInptListText1 = aiInptListText1;
	}
	public String getAiInptListText2() {
		return aiInptListText2;
	}
	public void setAiInptListText2(String aiInptListText2) {
		this.aiInptListText2 = aiInptListText2;
	}
	public String getAiInptListText3() {
		return aiInptListText3;
	}
	public void setAiInptListText3(String aiInptListText3) {
		this.aiInptListText3 = aiInptListText3;
	}
	public String getAiInptListText4() {
		return aiInptListText4;
	}
	public void setAiInptListText4(String aiInptListText4) {
		this.aiInptListText4 = aiInptListText4;
	}
	public String getAiInptListText5() {
		return aiInptListText5;
	}
	public void setAiInptListText5(String aiInptListText5) {
		this.aiInptListText5 = aiInptListText5;
	}
	public int getTaskDatesCnt1() {
		return taskDatesCnt1;
	}
	public void setTaskDatesCnt1(int taskDatesCnt1) {
		this.taskDatesCnt1 = taskDatesCnt1;
	}
	public int getTaskDatesCnt2() {
		return taskDatesCnt2;
	}
	public void setTaskDatesCnt2(int taskDatesCnt2) {
		this.taskDatesCnt2 = taskDatesCnt2;
	}
	public int getTaskDatesCnt3() {
		return taskDatesCnt3;
	}
	public void setTaskDatesCnt3(int taskDatesCnt3) {
		this.taskDatesCnt3 = taskDatesCnt3;
	}
	public String getSchUserIp() {
		return schUserIp;
	}
	public void setSchUserIp(String schUserIp) {
		this.schUserIp = schUserIp;
	}
	public String getSchText1() {
		return schText1;
	}
	public void setSchText1(String schText1) {
		this.schText1 = schText1;
	}
	public String getSchText2() {
		return schText2;
	}
	public void setSchText2(String schText2) {
		this.schText2 = schText2;
	}
	public String getSchText3() {
		return schText3;
	}
	public void setSchText3(String schText3) {
		this.schText3 = schText3;
	}
	public String getSchRepYn() {
		return schRepYn;
	}
	public void setSchRepYn(String schRepYn) {
		this.schRepYn = schRepYn;
	}
	
}