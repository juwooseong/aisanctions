package com.woori.ajs.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.woori.ajs.dao.CommonRevertDetailMapper;
import com.woori.ajs.model.CommonCodeVO;
import com.woori.ajs.model.CommonRevertDetailVO;
import com.woori.ajs.model.DocClassException;
import com.woori.ajs.model.DocClassSaveDatasets;
import com.woori.ajs.model.DocClassSaveRequest;
import com.woori.ajs.model.SearchVO;
import com.woori.ajs.service.CommonCodeService;
import com.woori.ajs.service.CommonRevertDetailService;
import com.woori.ajs.service.DocClassService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.ui.cmmn.StringUtil;

@Service("docClassService")
public class DocClassServiceImpl extends EgovAbstractServiceImpl implements DocClassService {

	private static final String ETC_IMEX_HIS_CD = "12";

	@Resource(name = "commonRevertDetailMapper")
	private CommonRevertDetailMapper commonRevertDetailMapper;

	@Resource(name = "commonRevertDetailService")
	private CommonRevertDetailService commonRevertDetailService;

	@Resource(name = "commonCodeService")
	private CommonCodeService commonCodeService;

	@Override
	public HashMap<String, Object> load(int inptMstSrno) throws Exception {
		if (inptMstSrno <= 0) {
			throw DocClassException.of("INVALID_MST", "심사건 번호가 없습니다.");
		}

		SearchVO searchVO = new SearchVO();
		searchVO.setInptMstSrno(inptMstSrno);
		searchVO.setAiInptGrpCd("100");

		List<CommonCodeVO> codes = commonCodeService.selectAllCommonCodeList(searchVO);
		List<Map<String, Object>> documentTypes = new ArrayList<Map<String, Object>>();
		if (codes != null) {
			for (CommonCodeVO code : codes) {
				if (code == null || StringUtil.nvl(code.getAiInptCmnCd()).isEmpty()) {
					continue;
				}
				Map<String, Object> type = new HashMap<String, Object>();
				String cd = code.getAiInptCmnCd();
				type.put("key", cd);
				type.put("imexHisCd", cd);
				String abbr = StringUtil.nvl(code.getImexhissAbbr());
				type.put("imexHisAbbr", abbr);
				String label = abbr;
				if (label.isEmpty()) {
					label = StringUtil.nvl(code.getAiInptCmnCdNm());
				}
				if (label.isEmpty()) {
					label = StringUtil.nvl(code.getAiInptCmnCdEngNm());
				}
				if (label.isEmpty()) {
					label = cd;
				}
				type.put("label", label);
				documentTypes.add(type);
			}
		}

		List<CommonRevertDetailVO> pages = commonRevertDetailMapper.selectImgPageInfo(searchVO);
		Set<Integer> blNos = new LinkedHashSet<Integer>();
		List<Map<String, Object>> pageList = new ArrayList<Map<String, Object>>();
		String actlFxRefno = "";
		if (pages != null) {
			for (int i = 0; i < pages.size(); i++) {
				CommonRevertDetailVO row = pages.get(i);
				if (row == null) {
					continue;
				}
				if (actlFxRefno.isEmpty()) {
					actlFxRefno = StringUtil.nvl(row.getActlFxRefno());
				}
				int blNo = row.getInptBlGrpNo() <= 0 ? 1 : row.getInptBlGrpNo();
				blNos.add(blNo);
				String taskId = StringUtil.nvl(row.getInptTaskId());
				String imexHisCd = StringUtil.nvl(row.getImexHisCd());
				Map<String, Object> page = new HashMap<String, Object>();
				page.put("pageId", taskId);
				page.put("inptTaskId", taskId);
				page.put("inptElmtId", StringUtil.nvl(row.getInptElmtId()));
				page.put("inptMstSrno", String.valueOf(inptMstSrno));
				page.put("imexHisCd", imexHisCd);
				page.put("documentType", imexHisCd);
				page.put("groupId", toUiBlId(blNo));
				page.put("inptBlGrpNo", toUiBlId(blNo));
				page.put("sortOrder", i);
				page.put("thumbnailUrl", "/api/doc-class/thumb?inptMstSrno=" + inptMstSrno
						+ "&inptTaskId=" + taskId);
				pageList.add(page);
			}
		}

		if (blNos.isEmpty()) {
			blNos.add(1);
		}

		List<Map<String, Object>> groups = new ArrayList<Map<String, Object>>();
		int sort = 0;
		for (Integer blNo : blNos) {
			String gid = toUiBlId(blNo);
			Map<String, Object> group = new HashMap<String, Object>();
			group.put("groupId", gid);
			group.put("inptBlGrpNo", gid);
			group.put("groupType", "BL");
			group.put("label", gid);
			group.put("sortOrder", sort++);
			group.put("buckets", new ArrayList<Object>());
			groups.add(group);
		}

		String mst = String.valueOf(inptMstSrno);
		HashMap<String, Object> map = new HashMap<String, Object>();
		map.put("documentId", mst);
		map.put("inptMstSrno", mst);
		map.put("actlFxRefno", actlFxRefno);
		map.put("version", 1);
		map.put("documentTypes", documentTypes);
		map.put("groups", groups);
		map.put("pages", pageList);
		return map;
	}

	@Override
	public HashMap<String, Object> save(DocClassSaveRequest req, String loginEno, String trnLogSrno) throws Exception {
		if (req == null) {
			throw DocClassException.of("INVALID_PAYLOAD", "저장 데이터가 없습니다.");
		}
		int inptMstSrno = parseMst(req.getInptMstSrno(), req.getDocumentId());
		if (inptMstSrno <= 0) {
			throw DocClassException.of("INVALID_MST", "심사건 번호가 없습니다.");
		}

		SearchVO searchVO = new SearchVO();
		searchVO.setInptMstSrno(inptMstSrno);
		List<CommonRevertDetailVO> currentPages = commonRevertDetailMapper.selectImgPageInfo(searchVO);
		Map<String, CommonRevertDetailVO> currentByTask = new HashMap<String, CommonRevertDetailVO>();
		if (currentPages != null) {
			for (CommonRevertDetailVO row : currentPages) {
				if (row != null && !StringUtil.nvl(row.getInptTaskId()).isEmpty()) {
					currentByTask.put(row.getInptTaskId(), row);
				}
			}
		}

		DocClassSaveDatasets datasets = req.getDatasets();
		List<Map<String, Object>> pageOps = datasets == null ? null : datasets.getPages();
		int updated = 0;
		if (pageOps != null) {
			for (Map<String, Object> op : pageOps) {
				if (op == null) {
					continue;
				}
				String operation = StringUtil.nvl(str(op.get("operation"))).toUpperCase();
				if (!"UPDATE".equals(operation) && !operation.isEmpty()) {
					continue;
				}
				String taskId = firstNonEmpty(str(op.get("inptTaskId")), str(op.get("pageId")));
				if (taskId.isEmpty()) {
					continue;
				}
				CommonRevertDetailVO current = currentByTask.get(taskId);
				if (current == null) {
					throw DocClassException.of("PAGE_NOT_FOUND", "이미지(" + taskId + ")를 찾을 수 없습니다.");
				}

				String imexHisCd = firstNonEmpty(str(op.get("imexHisCd")), str(op.get("documentType")),
						current.getImexHisCd());
				if ("ETC".equalsIgnoreCase(imexHisCd) || imexHisCd.isEmpty()) {
					imexHisCd = ETC_IMEX_HIS_CD;
				}

				int blNo = toDbBlNo(firstNonEmpty(str(op.get("inptBlGrpNo")), str(op.get("groupId"))));
				if (blNo <= 0) {
					blNo = current.getInptBlGrpNo() <= 0 ? 1 : current.getInptBlGrpNo();
				}

				CommonRevertDetailVO vo = new CommonRevertDetailVO();
				vo.setInptMstSrno(inptMstSrno);
				vo.setInptTaskId(taskId);
				vo.setImexHisCd(imexHisCd);
				vo.setInptBlGrpNo(blNo);
				vo.setLstDbChgId(loginEno);
				vo.setAiInptCrpeEno(loginEno);
				vo.setTrnLogSrno(trnLogSrno);
				vo.setSpdKind(current.getInptBlGrpNo() == blNo ? "matched" : "notMatched");
				commonRevertDetailService.reCrf(vo);
				updated++;
			}
		}

		int version = req.getBaseVersion() == null ? 1 : req.getBaseVersion().intValue();
		HashMap<String, Object> map = new HashMap<String, Object>();
		map.put("ok", Boolean.TRUE);
		map.put("version", version + 1);
		map.put("updated", updated);
		return map;
	}

	private static int parseMst(String inptMstSrno, String documentId) {
		String raw = firstNonEmpty(inptMstSrno, documentId);
		if (raw.isEmpty()) {
			return 0;
		}
		try {
			return Integer.parseInt(raw.trim());
		} catch (NumberFormatException e) {
			return 0;
		}
	}

	static String toUiBlId(int blNo) {
		return "BL" + (blNo <= 0 ? 1 : blNo);
	}

	static int toDbBlNo(String raw) {
		String s = StringUtil.nvl(raw).trim();
		if (s.isEmpty()) {
			return 0;
		}
		if (s.matches("(?i)BL\\d+")) {
			try {
				return Integer.parseInt(s.substring(2));
			} catch (NumberFormatException e) {
				return 0;
			}
		}
		try {
			return Integer.parseInt(s);
		} catch (NumberFormatException e) {
			return 0;
		}
	}

	private static String str(Object v) {
		return v == null ? "" : String.valueOf(v);
	}

	private static String firstNonEmpty(String... values) {
		if (values == null) {
			return "";
		}
		for (String v : values) {
			if (v != null && !v.trim().isEmpty() && !"null".equalsIgnoreCase(v.trim())) {
				return v.trim();
			}
		}
		return "";
	}
}
