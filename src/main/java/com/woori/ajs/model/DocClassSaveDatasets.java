package com.woori.ajs.model;

import java.util.List;
import java.util.Map;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

@JsonIgnoreProperties(ignoreUnknown = true)
public class DocClassSaveDatasets {

	private List<Map<String, Object>> pages;
	private List<Map<String, Object>> groups;
	private List<Map<String, Object>> buckets;

	public List<Map<String, Object>> getPages() {
		return pages;
	}

	public void setPages(List<Map<String, Object>> pages) {
		this.pages = pages;
	}

	public List<Map<String, Object>> getGroups() {
		return groups;
	}

	public void setGroups(List<Map<String, Object>> groups) {
		this.groups = groups;
	}

	public List<Map<String, Object>> getBuckets() {
		return buckets;
	}

	public void setBuckets(List<Map<String, Object>> buckets) {
		this.buckets = buckets;
	}
}
