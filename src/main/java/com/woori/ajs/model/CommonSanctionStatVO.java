package com.woori.ajs.model;

public class CommonSanctionStatVO {

	/* 
	 * 일치율 ----> 테이블 및 컬럼 생성 후 변수 추가해야함....
	 * 
	 * private 변수명!!!
	 */
	
	// WatchList List id
	private String aiInptListId;
	// WatchList List name
	private String aiInptListNm;
	// WatchList Item Text
	private String aiInptRsptTxtDesTxt;
	// 항목추출 필드
	private int inptMstSrno;
	private String inptSanctionNo;
	private String inptSantionDatTxt;
	
	
	public String getAiInptListId() {
		return aiInptListId;
	}
	public void setAiInptListId(String aiInptListId) {
		this.aiInptListId = aiInptListId;
	}
	public String getAiInptListNm() {
		return aiInptListNm;
	}
	public void setAiInptListNm(String aiInptListNm) {
		this.aiInptListNm = aiInptListNm;
	}
	public String getAiInptRsptTxtDesTxt() {
		return aiInptRsptTxtDesTxt;
	}
	public void setAiInptRsptTxtDesTxt(String aiInptRsptTxtDesTxt) {
		this.aiInptRsptTxtDesTxt = aiInptRsptTxtDesTxt;
	}
	public int getInptMstSrno() {
		return inptMstSrno;
	}
	public void setInptMstSrno(int inptMstSrno) {
		this.inptMstSrno = inptMstSrno;
	}
	public String getInptSanctionNo() {
		return inptSanctionNo;
	}
	public void setInptSanctionNo(String inptSanctionNo) {
		this.inptSanctionNo = inptSanctionNo;
	}
	public String getInptSantionDatTxt() {
		return inptSantionDatTxt;
	}
	public void setInptSantionDatTxt(String inptSantionDatTxt) {
		this.inptSantionDatTxt = inptSantionDatTxt;
	}
	
}
