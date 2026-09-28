package com.woori.ajs.model;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

@JsonIgnoreProperties(ignoreUnknown = true)
public class DocClassSaveRequest {

	private String documentId;
	private String inptMstSrno;
	private Integer baseVersion;
	private DocClassSaveDatasets datasets;

	public String getDocumentId() {
		return documentId;
	}

	public void setDocumentId(String documentId) {
		this.documentId = documentId;
	}

	public String getInptMstSrno() {
		return inptMstSrno;
	}

	public void setInptMstSrno(String inptMstSrno) {
		this.inptMstSrno = inptMstSrno;
	}

	public Integer getBaseVersion() {
		return baseVersion;
	}

	public void setBaseVersion(Integer baseVersion) {
		this.baseVersion = baseVersion;
	}

	public DocClassSaveDatasets getDatasets() {
		return datasets;
	}

	public void setDatasets(DocClassSaveDatasets datasets) {
		this.datasets = datasets;
	}
}
