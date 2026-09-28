package com.woori.ajs.model;

/**
 * 문서분류 일괄변경 검증 실패.
 */
public class DocClassException extends RuntimeException {

	private static final long serialVersionUID = 1L;

	private final String code;
	private final int httpStatus;

	public DocClassException(String code, String message) {
		this(code, message, 400);
	}

	public DocClassException(String code, String message, int httpStatus) {
		super(message);
		this.code = code;
		this.httpStatus = httpStatus;
	}

	public String getCode() {
		return code;
	}

	public int getHttpStatus() {
		return httpStatus;
	}

	public static DocClassException of(String code, String message) {
		return new DocClassException(code, message);
	}

	public static DocClassException of(String code, String message, int httpStatus) {
		return new DocClassException(code, message, httpStatus);
	}
}
