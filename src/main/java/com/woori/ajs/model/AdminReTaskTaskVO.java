package com.woori.ajs.model;

public class AdminReTaskTaskVO extends TaskVO {
	String inptBizAlctCrpeEno;		//업무 재할당 인수자 직원번호
	String oldUserEno;				//업무 재할당 인계자 직원번호
	String trnLogSrno;
	String qlasPrgYn;
	
	
	public String getQlasPrgYn() {
		return qlasPrgYn;
	}

	public void setQlasPrgYn(String qlasPrgYn) {
		this.qlasPrgYn = qlasPrgYn;
	}

	public String getTrnLogSrno() {
		return trnLogSrno;
	}

	public void setTrnLogSrno(String trnLogSrno) {
		this.trnLogSrno = trnLogSrno;
	}

	public String getInptBizAlctCrpeEno() {
		return inptBizAlctCrpeEno;
	}

	public void setInptBizAlctCrpeEno(String inptBizAlctCrpeEno) {
		this.inptBizAlctCrpeEno = inptBizAlctCrpeEno;
	}

	public String getOldUserEno() {
		return oldUserEno;
	}

	public void setOldUserEno(String oldUserEno) {
		this.oldUserEno = oldUserEno;
	}
	
}