package com.woori.ajs.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.woori.ajs.dao.AnnotationMapper;
import com.woori.ajs.model.AnnotationPageSaveRequest;
import com.woori.ajs.model.AnnotationVO;
import com.woori.ajs.service.AnnotationService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.ui.cmmn.StringUtil;

@Service("annotationService")
public class AnnotationServiceImpl extends EgovAbstractServiceImpl implements AnnotationService {

	private static final ObjectMapper MAPPER = new ObjectMapper();

	@Resource(name = "annotationMapper")
	private AnnotationMapper annotationMapper;

	@Override
	public HashMap<String, Object> load(Long inptMstSrno) throws Exception {
		if (inptMstSrno == null || inptMstSrno.longValue() <= 0) {
			throw new IllegalArgumentException("심사건 번호가 없습니다.");
		}
		List<AnnotationVO> rows = annotationMapper.selectByMst(inptMstSrno);
		List<Map<String, Object>> markers = new ArrayList<Map<String, Object>>();
		List<Map<String, Object>> pins = new ArrayList<Map<String, Object>>();
		if (rows != null) {
			for (AnnotationVO row : rows) {
				if (row == null) {
					continue;
				}
				if ("PIN".equals(row.getAnnoTypCd())) {
					pins.add(toPinMap(row));
				} else {
					markers.add(toMarkerMap(row));
				}
			}
		}
		HashMap<String, Object> map = new HashMap<String, Object>();
		map.put("inptMstSrno", String.valueOf(inptMstSrno));
		map.put("markers", markers);
		map.put("pins", pins);
		return map;
	}

	@Override
	public HashMap<String, Object> savePage(Long inptMstSrno, AnnotationPageSaveRequest req, String loginEno,
			String trnLogSrno) throws Exception {
		if (inptMstSrno == null || inptMstSrno.longValue() <= 0) {
			throw new IllegalArgumentException("심사건 번호가 없습니다.");
		}
		if (req == null || StringUtil.nvl(req.getInptTaskId()).isEmpty()) {
			throw new IllegalArgumentException("이미지 아이디가 없습니다.");
		}
		String taskId = req.getInptTaskId().trim();
		annotationMapper.disableByPage(inptMstSrno, taskId, loginEno);

		List<Map<String, Object>> markers = req.getMarkers();
		if (markers != null) {
			for (Map<String, Object> mk : markers) {
				if (mk == null) {
					continue;
				}
				AnnotationVO vo = baseVo(inptMstSrno, req, loginEno, trnLogSrno);
				vo.setAnnoTypCd("MK");
				vo.setAnnoId(first(str(mk.get("id")), "mk_" + vo.getAnnoSrno()));
				vo.setColorVal(first(str(mk.get("color")), "rgba(255,235,59,0.45)"));
				vo.setLineWd(toDouble(mk.get("width"), 18d));
				vo.setPointsTxt(trimPoints(mk.get("points")));
				annotationMapper.insert(vo);
			}
		}
		List<Map<String, Object>> pins = req.getPins();
		if (pins != null) {
			for (Map<String, Object> pin : pins) {
				if (pin == null) {
					continue;
				}
				AnnotationVO vo = baseVo(inptMstSrno, req, loginEno, trnLogSrno);
				vo.setAnnoTypCd("PIN");
				vo.setAnnoId(first(str(pin.get("id")), "pin_" + vo.getAnnoSrno()));
				vo.setColorVal(first(str(pin.get("color")), "#e11d48"));
				vo.setPinX(toDouble(pin.get("x"), 0d));
				vo.setPinY(toDouble(pin.get("y"), 0d));
				String opinion = str(pin.get("opinion"));
				if (opinion.length() > 1000) {
					opinion = opinion.substring(0, 1000);
				}
				vo.setOpinionTxt(opinion);
				annotationMapper.insert(vo);
			}
		}

		HashMap<String, Object> map = new HashMap<String, Object>();
		map.put("ok", Boolean.TRUE);
		map.put("inptTaskId", taskId);
		return map;
	}

	private AnnotationVO baseVo(Long inptMstSrno, AnnotationPageSaveRequest req, String loginEno, String trnLogSrno) {
		AnnotationVO vo = new AnnotationVO();
		vo.setAnnoSrno(annotationMapper.nextSrno());
		vo.setInptMstSrno(inptMstSrno);
		vo.setInptTaskId(req.getInptTaskId());
		vo.setInptBlGrpNo(req.getInptBlGrpNo());
		vo.setImexHisCd(req.getImexHisCd());
		vo.setImgWd(req.getImageWidth());
		vo.setImgHt(req.getImageHeight());
		vo.setLstDbChgId(loginEno);
		vo.setTrnLogSrno(trnLogSrno);
		return vo;
	}

	private Map<String, Object> toMarkerMap(AnnotationVO row) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("id", row.getAnnoId());
		map.put("inptTaskId", row.getInptTaskId());
		map.put("color", first(row.getColorVal(), "rgba(255,235,59,0.45)"));
		map.put("width", row.getLineWd() == null ? 18d : row.getLineWd());
		map.put("points", parsePoints(row.getPointsTxt()));
		return map;
	}

	private Map<String, Object> toPinMap(AnnotationVO row) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("id", row.getAnnoId());
		map.put("inptTaskId", row.getInptTaskId());
		map.put("x", row.getPinX() == null ? 0d : row.getPinX());
		map.put("y", row.getPinY() == null ? 0d : row.getPinY());
		map.put("color", first(row.getColorVal(), "#e11d48"));
		map.put("opinion", StringUtil.nvl(row.getOpinionTxt()));
		return map;
	}

	private List<List<Number>> parsePoints(String txt) {
		try {
			if (txt == null || txt.trim().isEmpty()) {
				return new ArrayList<List<Number>>();
			}
			return MAPPER.readValue(txt, new TypeReference<List<List<Number>>>() {
			});
		} catch (Exception e) {
			return new ArrayList<List<Number>>();
		}
	}

	private String trimPoints(Object points) {
		try {
			String json = MAPPER.writeValueAsString(points == null ? new ArrayList<Object>() : points);
			if (json.length() > 4000) {
				json = json.substring(0, 4000);
			}
			return json;
		} catch (Exception e) {
			return "[]";
		}
	}

	private static String str(Object v) {
		return v == null ? "" : String.valueOf(v).trim();
	}

	private static String first(String a, String b) {
		return (a == null || a.isEmpty()) ? b : a;
	}

	private static Double toDouble(Object v, Double def) {
		if (v == null) {
			return def;
		}
		if (v instanceof Number) {
			return ((Number) v).doubleValue();
		}
		try {
			return Double.valueOf(String.valueOf(v));
		} catch (Exception e) {
			return def;
		}
	}
}
