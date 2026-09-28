package com.woori.ajs.model;

@SuppressWarnings("serial")
public class LoginVO extends DefaultVO {
	private String id;
	private String eno;
	private String pw;
	private String name;
	private String auth;		//사용자권한 : S1(심사자), S2(결재자), QA, GN(일반)
	private String adminYN;		//Y,N
	private String aiInptUserYn;		//Y,N
	private String aiInptUserFaReYn;
	
	
	public String getAiInptUserFaReYn() {
		return aiInptUserFaReYn;
	}
	public void setAiInptUserFaReYn(String aiInptUserFaReYn) {
		this.aiInptUserFaReYn = aiInptUserFaReYn;
	}
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getEno() {
		return eno;
	}
	public void setEno(String eno) {
		this.eno = eno;
	}
	public String getPw() {
		return pw;
	}
	public void setPw(String pw) {
		this.pw = pw;
	}
	/**
	 * 사용자권한 : S1(심사자), S2(결재자), QA, GN(일반)
	 */
	public String getAuth() {
		return auth;
	}
	/**
	 * 사용자권한 : S1(심사자), S2(결재자), QA, GN(일반)
	 */
	public void setAuth(String auth) {
		this.auth = auth;
	}
	/**
	 * 결재자중에서, 관리권한 보유여부(Y/N)
	 * 관리권한 없을때는 : 관리자메뉴에서 사용중인 메뉴만 노출
	 * 관리권한 있을때는 : 관리자메뉴 전체노출
	 */
	public String getAdminYN() {
		return adminYN;
	}
	/**
	 * 결재자중에서, 관리권한 보유여부(Y/N)
	 * 관리권한 없을때는 : 관리자메뉴에서 사용중인 메뉴만 노출
	 * 관리권한 있을때는 : 관리자메뉴 전체노출
	 */
	public void setAdminYN(String adminYN) {
		this.adminYN = adminYN;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	
	
	public String getAiInptUserYn() {
		return aiInptUserYn;
	}
	public void setAiInptUserYn(String aiInptUserYn) {
		this.aiInptUserYn = aiInptUserYn;
	}
	@Override
	public String toString() {
		StringBuffer sb = new StringBuffer();
		
		sb.append(System.getProperty("\n id : "+getId()));
		sb.append(System.getProperty("\n eno : "+getEno()));
		sb.append(System.getProperty("\n pw : "+getPw()));
		sb.append(System.getProperty("\n name : "+getName()));
		sb.append(System.getProperty("\n auth : "+getAuth()));
		sb.append(System.getProperty("\n adminYN : "+getAdminYN()));
		return sb.toString();
	}
}