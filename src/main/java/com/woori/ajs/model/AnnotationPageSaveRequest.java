package com.woori.ajs.model;

import java.util.List;
import java.util.Map;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

@JsonIgnoreProperties(ignoreUnknown = true)
public class AnnotationPageSaveRequest {

	private String inptTaskId;
	private String inptBlGrpNo;
	private String imexHisCd;
	private Integer imageWidth;
	private Integer imageHeight;
	private List<Map<String, Object>> markers;
	private List<Map<String, Object>> pins;

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
	public Integer getImageWidth() {
		return imageWidth;
	}
	public void setImageWidth(Integer imageWidth) {
		this.imageWidth = imageWidth;
	}
	public Integer getImageHeight() {
		return imageHeight;
	}
	public void setImageHeight(Integer imageHeight) {
		this.imageHeight = imageHeight;
	}
	public List<Map<String, Object>> getMarkers() {
		return markers;
	}
	public void setMarkers(List<Map<String, Object>> markers) {
		this.markers = markers;
	}
	public List<Map<String, Object>> getPins() {
		return pins;
	}
	public void setPins(List<Map<String, Object>> pins) {
		this.pins = pins;
	}
}
