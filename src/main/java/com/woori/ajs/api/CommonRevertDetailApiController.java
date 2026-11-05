package com.woori.ajs.api;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.JSONValue;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springmodules.validation.commons.DefaultBeanValidator;

import com.woori.ajs.model.AdminLogProgramVO;
import com.woori.ajs.model.CommonRevertDetailVO;
import com.woori.ajs.model.LoginVO;
import com.woori.ajs.model.SearchVO;
import com.woori.ajs.service.AdminLogProgramService;
import com.woori.ajs.service.CommonCodeService;
import com.woori.ajs.service.CommonRevertDetailService;

import egovframework.rte.fdl.property.EgovPropertyService;
import egovframework.ui.cmmn.CastUtil;
import egovframework.ui.cmmn.HttpUtil;
import egovframework.ui.cmmn.StringUtil;
import egovframework.ui.util.LoginUtils;

@RestController
public class CommonRevertDetailApiController {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(CommonRevertDetailApiController.class);
	
	
	/** 심사상세 공통 서비스 **/
	@Resource(name = "commonRevertDetailService")
	private CommonRevertDetailService service;

	/** 공통 서비스 **/
	@Resource(name = "commonCodeService")
	private CommonCodeService commonCodeService;

	/** EgovPropertyService */
	@Resource(name = "propertiesService")
	protected EgovPropertyService propertiesService;

	/** Validator */
	@Resource(name = "beanValidator")
	protected DefaultBeanValidator beanValidator;

	/** adminLogProgramService */
	@Resource(name = "adminLogProgramService")
	private AdminLogProgramService adminLogProgramService;
	
	@Resource(name = "systemFileProperties")
	protected Properties sysProp;
	
	private CommonRevertDetailVO setSantionTransInfoParam(Map params, HttpServletRequest request) {
		
//		List<Map<String, String>> jsonList = (List<Map<String, String>>) params.get("sanctionList");
		List<Map<String, String>> jsonList = new ArrayList<Map<String, String>>();
		JSONArray jsonListTmp = CastUtil.objToJSONArr(params.get("sanctionList"));
		if(jsonListTmp!=null && jsonListTmp.size() > 0) {
			for (Object object : jsonListTmp) {
				JSONObject row = CastUtil.objToJSONObj(object);
				Map<String, String> row2 = new HashMap<String, String>();
				
				Iterator keys = row.keySet().iterator();
				while(keys.hasNext()) {
					String key = CastUtil.objToStr(keys.next());
					String val = CastUtil.objToStr(row.get(key));
					row2.put(key, val);
				}
				jsonList.add(row2);
			}
		}
		
		List<CommonRevertDetailVO> sanctionList = new ArrayList<CommonRevertDetailVO>();
		LoginVO loginInfo = LoginUtils.getLoginInfo(request);
		CommonRevertDetailVO tmp = null;
		
		if(jsonList == null) {
			sanctionList = null;
		} else {
			for(Map jm: jsonList) {
				tmp = new CommonRevertDetailVO();
				tmp.setInptMstSrno(Integer.valueOf(CastUtil.objToStr(jm.get("inptMstSrno"))));
				tmp.setInptSanctionNo(CastUtil.objToStr(jm.get("inptSanctionNo")));
				tmp.setInptSanctionNm(CastUtil.objToStr(jm.get("inptSanctionNm")));
				tmp.setInptTaskId(CastUtil.objToStr(jm.get("inptTaskId")));
				tmp.setStRstKind(CastUtil.objToStr(jm.get("stRstKind")));
				tmp.setInptBlGrpNo(Integer.valueOf(CastUtil.objToStr(jm.get("inptBlGrpNo"))));
				tmp.setItmInptHndgInpDatTxt(CastUtil.objToStr(jm.get("itmInptHndgInpDatTxt")).replaceAll("[^\\x20-\\x7E]", " ").replace("\n", " ").replace("\r", " ").replace("\t", " ").replace("     ", " ").replace("    ", " ").replace("   ", " ".replace("  ", " ")));
				// [수기추가 컬럼 기능] 화면에서 동적으로 만든 "수기 추가" 컬럼(최대 3개) 값을 받는다.
				// JS(fn_setTmpParam)가 현재 화면에 떠 있는 컬럼 개수만큼만 itmInptHndgAdd1Txt/2/3Txt 키를
				// 채워 보내므로, 없는 키는 CastUtil.objToStr(null)이 빈 문자열을 반환해 자연히 빈 값으로 저장된다.
				tmp.setItmInptHndgAdd1Txt(CastUtil.objToStr(jm.get("itmInptHndgAdd1Txt")));
				tmp.setItmInptHndgAdd2Txt(CastUtil.objToStr(jm.get("itmInptHndgAdd2Txt")));
				tmp.setItmInptHndgAdd3Txt(CastUtil.objToStr(jm.get("itmInptHndgAdd3Txt")));
				tmp.setAiInptSanctionRuleTxt(CastUtil.objToStr(jm.get("aiInptSanctionRuleTxt")));
				tmp.setAiInptAltYn(CastUtil.objToStr(jm.get("aiInptAltYn")));
				tmp.setLstDbChgId(loginInfo.getEno());
				sanctionList.add(tmp);
			}
		}
		
		CommonRevertDetailVO vo = new CommonRevertDetailVO();
		
		vo.setInptMstSrno(Integer.valueOf(CastUtil.objToStr(params.get("inptMstSrno"))));
		vo.setAiInptAppvSrno(Integer.valueOf(CastUtil.objToStr(params.get("aiInptAppvSrno"))));
		vo.setAiInptBizDscd(CastUtil.objToStr(params.get("aiInptBizDscd")));
		vo.setAiInptPrcOpiTxt(CastUtil.objToStr(params.get("aiInptPrcOpiTxt")));
		vo.setMstTotaltextAiInptRstCd(CastUtil.objToStr(params.get("mstTotaltextAiInptRstCd")));
		vo.setMstInptItmAiInptRstCd(CastUtil.objToStr(params.get("mstInptItmAiInptRstCd")));
		vo.setMstQltGrnAiInptRstCd(CastUtil.objToStr(params.get("mstQltGrnAiInptRstCd")));
		vo.setCurtAiInspAtvtCd(CastUtil.objToStr(params.get("curtAiInspAtvtCd")));
		vo.setBtnFlag(CastUtil.objToStr(params.get("btnFlag")));
	//	vo.setItmInptHndgInpDatTxt(CastUtil.objToStr(params.get("itmInptHndgInpDatTxt")));
		vo.setLstDbChgId(loginInfo.getEno());
		vo.setSanctionList(sanctionList);
		
		return vo;
	}
	
	@PostMapping("/api/common/revertDetail/inspection")
	public HashMap<String, Object> inspection(@RequestParam Map<String, Object> jsonObject, HttpServletRequest request, SearchVO searchVO, AdminLogProgramVO adminLogProgramVO) throws Exception {
		HashMap<String,Object> map = new HashMap<String,Object>();
		HttpUtil.setResult(map, HttpUtil.HttpType.T200);
		
		LoginVO loginInfo = LoginUtils.getLoginInfo(request);
		
		String jsonStr = CastUtil.objToStr(jsonObject.get("jData"));
		JSONObject jsonObj = CastUtil.objToJSONObj(JSONValue.parse(jsonStr));
		CommonRevertDetailVO vo = setSantionTransInfoParam(jsonObj, request);
		
		String aiInptAcvtCd = CastUtil.objToStr(jsonObj.get("aiInptAcvtCd"));
		String inspectionType = CastUtil.objToStr(jsonObj.get("inspectionType"));
		
		String userId = LoginUtils.getLoginInfo(request).getId();
		searchVO.setUserId(userId);
		
		//프로그램 이력 쌓기
		String trnLogSrno = null;
		
		String aiInptCnctScrnNo = CastUtil.objToStr(jsonObj.get("aiInptCnctScrnNo"));
		String aiInptCnctFldCd = CastUtil.objToStr(jsonObj.get("aiInptCnctFldCd"));
		String aiInptCnctActiCd = CastUtil.objToStr(jsonObj.get("aiInptCnctActiCd"));
		String aiInptCnctParmTxt = CastUtil.objToStr(jsonObj.get("aiInptCnctParmTxt"));
		
		adminLogProgramVO.setAiInptCnctScrnNo(aiInptCnctScrnNo);
		adminLogProgramVO.setAiInptCnctFldCd(aiInptCnctFldCd);
		adminLogProgramVO.setAiInptCnctActiCd(aiInptCnctActiCd);
		adminLogProgramVO.setAiInptCnctParmTxt(aiInptCnctParmTxt);
		
		trnLogSrno = adminLogProgramService.logProgramInsert(request, adminLogProgramVO, searchVO);
		
		vo.setAiInptTpySaveYn("Y");
		vo.setAiInptCrpeEno(loginInfo.getEno());
		vo.setLstDbChgId(loginInfo.getEno());
		vo.setTrnLogSrno(trnLogSrno);

		service.inspection(vo);
		
		// TA 전송 시작
		JSONObject jsObj = null;
		JSONArray jsArray = new JSONArray();
		
		jsObj = new JSONObject();
		jsObj.put("jobId", vo.getInptMstSrno());
		jsObj.put("aiInptAcvtCd", aiInptAcvtCd);
		jsArray.add(jsObj);
		
		LOGGER.debug("========================= TA 전송 데이터 =========================");
		LOGGER.debug("jsArray ::: " + jsArray);
		LOGGER.debug("================================================================");
		
		HttpURLConnection conn = null;
		OutputStream os = null;
		BufferedReader in = null;
		String sendUrl = sysProp.getProperty("inspection.url");
		String inputLine = null;
		StringBuffer outResult = new StringBuffer();
		
		try {
			URL url = new URL(sendUrl);
			
			if (url.openConnection() instanceof HttpURLConnection) {
				conn = (HttpURLConnection)url.openConnection();
			}
			
			if (conn != null) {
				
				// Cache를 사용하지 않는다.
				conn.setUseCaches(false);
				conn.setDefaultUseCaches(false);
				
				conn.setDoInput(true);
				conn.setDoOutput(true);
				
				conn.setRequestMethod("POST");
				conn.setRequestProperty("Content-Type", "application/json");
				
				// Keep-Alive : false 로 설정..
				conn.setRequestProperty("Connection", "close");
				
				// COMMON Agent 서버에 연결되는 TimeOut 시간 설정
				conn.setConnectTimeout(30000);
				
				// COMMON Agent 서버에서 ImputStream 읽어오는 TimeOut 시간 설정
				conn.setReadTimeout(30000);
				
				os = conn.getOutputStream();
				
				os.write(jsArray.toString().getBytes("UTF-8"));			
				os.flush();
				os.close();
				
				if (conn.getResponseCode() == HttpURLConnection.HTTP_OK) {
					// 리턴된 결과값 읽기
					in = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"));
					
					while(true) {
						inputLine = in.readLine();
						
						if(inputLine == null ) {
							break;
						}else {
							outResult.append(inputLine);
						}
					}
					
					in.close();
				}
				
				conn.disconnect();
			}
			
		} catch (Exception e) {
			// logger.error(e.getMessage(),e);
			// 문제 발생시 에러처리와 사용자 화면에서의 안내 메세지를 어떻게 할지 정해야 한다.
			LOGGER.error("Exception ::: " + e);
			//	e.printStackTrace();
			map.put("rst", "fail");
			
			if (in != null) {
				in.close();
			}
			
			
			if (os != null) {
				os.close();
			}
			
			if (conn != null) {
				conn.disconnect();
			}
			
			return map;
			
		} finally {
			
			LOGGER.debug("inspection");
			
		}
		
		map.put("rst", outResult.toString());
		
		return map;
	}

	@PostMapping("/api/common/revertDetail/santionSave")
	public HashMap<String, Object> santionSave(@RequestParam Map<String, Object> jsonObject, HttpServletRequest request, SearchVO searchVO, AdminLogProgramVO adminLogProgramVO) throws Exception {
		HashMap<String,Object> map = new HashMap<String,Object>();
		HttpUtil.setResult(map, HttpUtil.HttpType.T200);
		
		LoginVO loginInfo = LoginUtils.getLoginInfo(request);
		String userId = LoginUtils.getLoginInfo(request).getId();
		searchVO.setUserId(userId);
		
		String jsonStr = CastUtil.objToStr(jsonObject.get("jData"));
		JSONObject jsonObj = CastUtil.objToJSONObj(JSONValue.parse(jsonStr));
		CommonRevertDetailVO vo = setSantionTransInfoParam(jsonObj, request);
		
		//프로그램 이력 쌓기
		String trnLogSrno = null;
		Object jDataObj = JSONValue.parse(jsonStr);
		JSONObject params = CastUtil.objToJSONObj(jDataObj);
		
		String aiInptCnctScrnNo = CastUtil.objToStr(params.get("aiInptCnctScrnNo"));
		String aiInptCnctFldCd = CastUtil.objToStr(params.get("aiInptCnctFldCd"));
		String aiInptCnctActiCd = CastUtil.objToStr(params.get("aiInptCnctActiCd"));
		String aiInptCnctParmTxt = CastUtil.objToStr(params.get("aiInptCnctParmTxt"));
		
		adminLogProgramVO.setAiInptCnctScrnNo(aiInptCnctScrnNo);
		adminLogProgramVO.setAiInptCnctFldCd(aiInptCnctFldCd);
		adminLogProgramVO.setAiInptCnctActiCd(aiInptCnctActiCd);
		adminLogProgramVO.setAiInptCnctParmTxt(aiInptCnctParmTxt);
		
		trnLogSrno = adminLogProgramService.logProgramInsert(request, adminLogProgramVO, searchVO);
		
		vo.setAiInptTpySaveYn("Y");
		vo.setAiInptCrpeEno(loginInfo.getEno());
		vo.setLstDbChgId(loginInfo.getEno());
		vo.setTrnLogSrno(trnLogSrno);
		service.saveSantion(vo);
		
		map.put("rst", "success");
		
		return map;
	}
	
	@PostMapping("/api/common/revertDetail/QaApprv")
	public HashMap<String, Object> QaApprv(@RequestParam Map<String, Object> jsonObject, HttpServletRequest request, SearchVO searchVO, AdminLogProgramVO adminLogProgramVO) throws Exception {
		HashMap<String,Object> map = new HashMap<String,Object>();
		HttpUtil.setResult(map, HttpUtil.HttpType.T200);
		LoginVO loginInfo = LoginUtils.getLoginInfo(request);
		
		String jsonStr = CastUtil.objToStr(jsonObject.get("jData"));
		JSONObject jsonObj = CastUtil.objToJSONObj(JSONValue.parse(jsonStr));
		CommonRevertDetailVO vo = setSantionTransInfoParam(jsonObj, request);
		
		String btnFlag = vo.getBtnFlag();
		String aiInptAcvtCd = "";
		String aiInptAppvStcd = "";
		String nextAiInspAtvtCd = "";
		String aiInptAcvtStsCd = "";
		String aiInspeEno = "";
		String aiInptAnpeEno = "";
		String qlasCrpeEno = "";
		String qlasSnpeEno = "";
		
		//프로그램 이력 쌓기
		String trnLogSrno = null;
		Object jDataObj = JSONValue.parse(jsonStr);
		JSONObject params = CastUtil.objToJSONObj(jDataObj);
		
		String aiInptCnctScrnNo = CastUtil.objToStr(params.get("aiInptCnctScrnNo"));
		String aiInptCnctFldCd = CastUtil.objToStr(params.get("aiInptCnctFldCd"));
		String aiInptCnctActiCd = CastUtil.objToStr(params.get("aiInptCnctActiCd"));
		String aiInptCnctParmTxt = CastUtil.objToStr(params.get("aiInptCnctParmTxt"));
		
		adminLogProgramVO.setAiInptCnctScrnNo(aiInptCnctScrnNo);
		adminLogProgramVO.setAiInptCnctFldCd(aiInptCnctFldCd);
		adminLogProgramVO.setAiInptCnctActiCd(aiInptCnctActiCd);
		adminLogProgramVO.setAiInptCnctParmTxt(aiInptCnctParmTxt);
		
		trnLogSrno = adminLogProgramService.logProgramInsert(request, adminLogProgramVO, searchVO);
		
		String auth = loginInfo.getAuth();
		searchVO.setInptMstSrno(vo.getInptMstSrno());
		
		CommonRevertDetailVO stdInfo = service.selectStdInfo(searchVO);
		aiInspeEno = stdInfo.getAiInspeEno();
		aiInptAnpeEno = stdInfo.getAiInptAnpeEno();
		qlasCrpeEno = stdInfo.getQlasCrpeEno();
		qlasSnpeEno = stdInfo.getQlasSnpeEno();
		
		vo.setAiInspeEno(aiInspeEno);
		vo.setAiInptAnpeEno(aiInptAnpeEno);
		vo.setQlasCrpeEno(qlasCrpeEno);
		vo.setQlasSnpeEno(qlasSnpeEno);
		vo.setTrnLogSrno(trnLogSrno);
		
		//QA
		if ("03".equals(auth)) {
			if("U".equals(btnFlag)) { // 상신
				vo.setLstDbChgId(loginInfo.getEno());
				service.updateSantionHis(vo);
				
				aiInptAcvtCd = "120";
				aiInptAppvStcd = "90";
				nextAiInspAtvtCd = "110";
				aiInptAcvtStsCd = "90";
				
			} else if("RU".equals(btnFlag)) { // 재상신
				vo.setLstDbChgId(loginInfo.getEno());
				service.updateSantionHis(vo);
				
				aiInptAcvtCd = "120";
				aiInptAppvStcd = "100";
				nextAiInspAtvtCd = "110";
				aiInptAcvtStsCd = "100";
				
			} else {
				HttpUtil.setResult(map, HttpUtil.HttpType.T403);
				HttpUtil.setExResult(map, "-1", "권한이 없습니다.");
				return map;
			}
			
		//결재자
		} else if ("02".equals(auth)){
			if("R".equals(btnFlag)) { // 반려
				aiInptAcvtCd = "110";
				aiInptAppvStcd = "120";
				nextAiInspAtvtCd = "120";
				aiInptAcvtStsCd = "120";
			} else if("A".equals(btnFlag)) { // 승인
				aiInptAcvtCd = "160";
				aiInptAppvStcd = "160";
				nextAiInspAtvtCd = "120";
				aiInptAcvtStsCd = "160";
			} else {
				HttpUtil.setResult(map, HttpUtil.HttpType.T403);
				HttpUtil.setExResult(map, "-1", "권한이 없습니다.");
				return map;
			}
			
			vo.setLstDbChgId(loginInfo.getEno());
			service.updateSantionHis(vo);
		}

		// 마스터
		vo.setAiInptAcvtCd(aiInptAcvtCd);
		vo.setAiInptAppvStcd(aiInptAppvStcd);
		
		// 이력
		vo.setNextAiInspAtvtCd(nextAiInspAtvtCd);
		vo.setAiInptAcvtStsCd(aiInptAcvtStsCd);
		
		vo.setAiInptCrpeEno(loginInfo.getEno());
		vo.setLstDbChgId(loginInfo.getEno());
		vo.setAiInptTpySaveYn("N");
		service.updateQaApprvHis(vo);
		
		map.put("rst", "success");
		
		return map;
	}
	
	@PostMapping("/api/common/revertDetail/santionApprv")
	public HashMap<String, Object> reqSantionApprv(@RequestParam Map<String, Object> jsonObject, HttpServletRequest request, SearchVO searchVO, AdminLogProgramVO adminLogProgramVO) throws Exception {
		HashMap<String,Object> map = new HashMap<String,Object>();
		HttpUtil.setResult(map, HttpUtil.HttpType.T200);
		LoginVO loginInfo = LoginUtils.getLoginInfo(request);
		
		String jsonStr = CastUtil.objToStr(jsonObject.get("jData"));
		JSONObject jsonObj = CastUtil.objToJSONObj(JSONValue.parse(jsonStr));
		CommonRevertDetailVO vo = setSantionTransInfoParam(jsonObj, request);
		
		//접근권한체크
		if(StringUtil.isNotEmpty(vo.getInptMstSrno())) {
			SearchVO vo2 = new SearchVO();
			vo2.setSchGbn(loginInfo.getAuth());						//팝업종류(01 - 심사자, 03 - QA, 02 - 결재자)
			vo2.setSchUserNo(loginInfo.getId());
			vo2.setInptMstSrno(vo.getInptMstSrno());
			int checkAccess = service.selectCheckAccess(vo2);
			if(checkAccess==0) {
				HttpUtil.setResult(map, HttpUtil.HttpType.T403);
				HttpUtil.setExResult(map, "-1", "권한이 없습니다.");
				return map;
			}
		} else {
			map.put("rst", "fail");
			map.put("msg", "정보가 부족합니다.");
			return map;
		}
		
		//프로그램 이력 쌓기
		String trnLogSrno = null;
		Object jDataObj = JSONValue.parse(jsonStr);
		JSONObject params = CastUtil.objToJSONObj(jDataObj);
		
		String aiInptCnctScrnNo = CastUtil.objToStr(params.get("aiInptCnctScrnNo"));
		String aiInptCnctFldCd = CastUtil.objToStr(params.get("aiInptCnctFldCd"));
		String aiInptCnctActiCd = CastUtil.objToStr(params.get("aiInptCnctActiCd"));
		String aiInptCnctParmTxt = CastUtil.objToStr(params.get("aiInptCnctParmTxt"));
		
		adminLogProgramVO.setAiInptCnctScrnNo(aiInptCnctScrnNo);
		adminLogProgramVO.setAiInptCnctFldCd(aiInptCnctFldCd);
		adminLogProgramVO.setAiInptCnctActiCd(aiInptCnctActiCd);
		adminLogProgramVO.setAiInptCnctParmTxt(aiInptCnctParmTxt);
		
		trnLogSrno = adminLogProgramService.logProgramInsert(request, adminLogProgramVO, searchVO);
		
		String btnFlag = vo.getBtnFlag();
		String aiInptAcvtCd = "";
		String aiInptAppvStcd = "";
		String nextAiInspAtvtCd = "";
		String aiInptAcvtStsCd = "";
		String aiInspeEno = "";
		String aiInptAnpeEno = "";
		String qlasCrpeEno = "";
		String qlasSnpeEno = "";
		
		String auth = loginInfo.getAuth();
		
		searchVO.setInptMstSrno(vo.getInptMstSrno());
		
		CommonRevertDetailVO stdInfo = service.selectStdInfo(searchVO);
		aiInspeEno = stdInfo.getAiInspeEno();
		aiInptAnpeEno = stdInfo.getAiInptAnpeEno();
		qlasCrpeEno = stdInfo.getQlasCrpeEno();
		qlasSnpeEno = stdInfo.getQlasSnpeEno();
		
		vo.setAiInspeEno(aiInspeEno);
		vo.setAiInptAnpeEno(aiInptAnpeEno);
		vo.setQlasCrpeEno(qlasCrpeEno);
		vo.setQlasSnpeEno(qlasSnpeEno);
		vo.setTrnLogSrno(trnLogSrno);
		
		//심사자
		if ("01".equals(auth)) {
			
			// 다음 액티비티 설정 및 결재상태 set
			if("U".equals(btnFlag)) { // 상신
				map.put("rst", "success");
				
				vo.setLstDbChgId(loginInfo.getEno());
				service.updateSantionHis(vo);	
				
				aiInptAcvtCd = "100";
				aiInptAppvStcd = "90";
				nextAiInspAtvtCd = "90";
				aiInptAcvtStsCd = "90";
			} else if("RU".equals(btnFlag)) { // 재상신
				map.put("rst", "success");
				
				vo.setLstDbChgId(loginInfo.getEno());
				service.updateSantionHis(vo);	
				
				aiInptAcvtCd = "100";
				aiInptAppvStcd = "100";
				nextAiInspAtvtCd = "90";
				aiInptAcvtStsCd = "100";
			} else {
				HttpUtil.setResult(map, HttpUtil.HttpType.T403);
				HttpUtil.setExResult(map, "-1", "권한이 없습니다.");
				return map;
			}
			
			//결재자
		} else if ("02".equals(auth)){
			// 다음 액티비티 설정 및 결재상태 set
			if("R".equals(btnFlag)) { // 반려
				vo.setLstDbChgId(loginInfo.getEno());
				service.updateSantionHis(vo);
				
				aiInptAcvtCd = "90";
				aiInptAppvStcd = "120";
				nextAiInspAtvtCd = "100";
				aiInptAcvtStsCd = "120";
				
			} else if("P".equals(btnFlag)) { // Pending
				vo.setLstDbChgId(loginInfo.getEno());
				service.updateSantionHis(vo);	
				
				aiInptAcvtCd = "130";
				aiInptAppvStcd = "130";
				nextAiInspAtvtCd = "100";
				aiInptAcvtStsCd = "130";
				
			} else if("B".equals(btnFlag)) { // Block
				vo.setLstDbChgId(loginInfo.getEno());
				service.updateSantionHis(vo);	
				
				aiInptAcvtCd = "140";
				aiInptAppvStcd = "140";
				nextAiInspAtvtCd = "100";
				aiInptAcvtStsCd = "140";
				
			} else if("A".equals(btnFlag)) { // 승인
				vo.setLstDbChgId(loginInfo.getEno());
				service.updateSantionHis(vo);
				
				aiInptAcvtCd = "160";
				aiInptAppvStcd = "160";
				nextAiInspAtvtCd = "100";
				aiInptAcvtStsCd = "160";
				
				
				if(!("10".equals(vo.getMstTotaltextAiInptRstCd()))) {
					vo.setMstTotaltextAiInptRstCd("40");
				}
				if(!("10".equals(vo.getMstInptItmAiInptRstCd()))) {
					vo.setMstInptItmAiInptRstCd("40");
				}
			} else {
				HttpUtil.setResult(map, HttpUtil.HttpType.T403);
				HttpUtil.setExResult(map, "-1", "권한이 없습니다.");
				return map;
			}
		}
		
		// 마스터
		vo.setAiInptAcvtCd(aiInptAcvtCd);
		vo.setAiInptAppvStcd(aiInptAppvStcd);
		
		// 이력
		vo.setNextAiInspAtvtCd(nextAiInspAtvtCd);
		vo.setAiInptAcvtStsCd(aiInptAcvtStsCd);
		
		vo.setAiInptCrpeEno(loginInfo.getEno());
		vo.setLstDbChgId(loginInfo.getEno());
		vo.setAiInptTpySaveYn("N");
		service.updateSantionApprvHis(vo);
		
		service.saveSantion(vo);
		
		return map;
	}

	@PostMapping("/api/common/revertDetail/cancelApprv")
	public HashMap<String, Object> cancelApprv(CommonRevertDetailVO vo, HttpServletRequest request, AdminLogProgramVO adminLogProgramVO) throws Exception {
		HashMap<String,Object> map = new HashMap<String,Object>();
		HttpUtil.setResult(map, HttpUtil.HttpType.T200);
		LoginVO loginInfo = LoginUtils.getLoginInfo(request);
		
		SearchVO searchVO = new SearchVO();

		//접근권한체크
		if(StringUtil.isNotEmpty(vo.getInptMstSrno())) {
			SearchVO vo2 = new SearchVO();
			vo2.setSchGbn(loginInfo.getAuth());						//팝업종류(01 - 심사자, 03 - QA, 02 - 결재자)
			vo2.setSchUserNo(loginInfo.getId());
			vo2.setInptMstSrno(vo.getInptMstSrno());
			int checkAccess = service.selectCheckAccess(vo2);
			if(checkAccess==0) {
				HttpUtil.setResult(map, HttpUtil.HttpType.T403);
				HttpUtil.setExResult(map, "-1", "권한이 없습니다.");
				return map;
			}
		} else {
			map.put("rst", "fail");
			map.put("msg", "정보가 부족합니다.");
			return map;
		}
		
		String aiInptAcvtCd = "";
		String aiInptAppvStcd = "";
		String nextAiInspAtvtCd = "";
		String aiInptAcvtStsCd = "";
		String aiInptPrcOpiTxt = "";
		String mstTotaltextAiInptRstCd = vo.getMstTotaltextAiInptRstCd();
		String mstInptItmAiInptRstCd = vo.getMstInptItmAiInptRstCd();
		
		String auth = loginInfo.getAuth();
		
		//심사자
		if ("01".equals(auth) || "03".equals(auth)) {
			
			HttpUtil.setResult(map, HttpUtil.HttpType.T403);
			HttpUtil.setExResult(map, "-1", "권한이 없습니다.");
			return map;
			
		//결재자
		} else if ("02".equals(auth)) {
			
			map.put("rst", "success");
			
			searchVO.setInptMstSrno(vo.getInptMstSrno());
			
			CommonRevertDetailVO stdInfo = service.selectStdInfo(searchVO);
			
			aiInptAcvtCd = "100";
			aiInptAppvStcd = "100";
			nextAiInspAtvtCd = "100";
			aiInptAcvtStsCd = "50";
			aiInptPrcOpiTxt = "결재취소";
			
			if ("40".equals(mstTotaltextAiInptRstCd)) {
				mstTotaltextAiInptRstCd = "30";
			}
			
			if ("40".equals(mstInptItmAiInptRstCd)) {
				mstInptItmAiInptRstCd = "30";
			}
		}

		// 마스터
		vo.setAiInptAcvtCd(aiInptAcvtCd);
		vo.setAiInptAppvStcd(aiInptAppvStcd);
		
		// 이력
		vo.setNextAiInspAtvtCd(nextAiInspAtvtCd);
		vo.setAiInptAcvtStsCd(aiInptAcvtStsCd);
		vo.setAiInptPrcOpiTxt(aiInptPrcOpiTxt);
		vo.setMstTotaltextAiInptRstCd(mstTotaltextAiInptRstCd);
		vo.setMstInptItmAiInptRstCd(mstInptItmAiInptRstCd);

		vo.setAiInptCrpeEno(loginInfo.getEno());
		vo.setLstDbChgId(loginInfo.getEno());
		vo.setAiInptTpySaveYn("N");

		
		String trnLogSrno = null;
		
		trnLogSrno = adminLogProgramService.logProgramInsert(request, adminLogProgramVO, searchVO);
		
		vo.setTrnLogSrno(trnLogSrno);
		service.updateSantionApprvHis(vo);
		
		vo.setAiInptCrpeEno(loginInfo.getEno());
		vo.setLstDbChgId(loginInfo.getEno());
		vo.setTrnLogSrno(trnLogSrno);
		service.saveSantion(vo);
		
		return map;
	}
	
	
	@PostMapping("/api/common/revertDetail/updateReScanNed")
	public HashMap<String, Object> updateReScanNed(CommonRevertDetailVO vo, HttpServletRequest request, SearchVO searchVO, AdminLogProgramVO adminLogProgramVO) throws Exception {
		HashMap<String,Object> map = new HashMap<String,Object>();
		HttpUtil.setResult(map, HttpUtil.HttpType.T200);
		LoginVO loginInfo = LoginUtils.getLoginInfo(request);
		
		//프로그램 이력 쌓기
		String trnLogSrno = null;
		trnLogSrno = adminLogProgramService.logProgramInsert(request, adminLogProgramVO, searchVO);
		
		String nextAiInspAtvtCd = "";
		String aiInptAcvtStsCd = "";
		
		vo.setLstDbChgId(loginInfo.getEno());
		vo.setAiInptCrpeEno(loginInfo.getEno());
		vo.setTrnLogSrno(trnLogSrno);
		service.updateSantionHis(vo);

		nextAiInspAtvtCd = "20";
		aiInptAcvtStsCd = "60";
		
		// 이력
		vo.setNextAiInspAtvtCd(nextAiInspAtvtCd);
		vo.setAiInptAcvtStsCd(aiInptAcvtStsCd);
		service.updateReScanNed(vo);
		
		map.put("rst", "success");
		
		return map;
	}
	
	@PostMapping("/api/common/revertDetail/ModiBlNum")
	public HashMap<String, Object> modiBlNum(CommonRevertDetailVO vo) throws Exception {
		HashMap<String, Object> map = new HashMap<String, Object>();
		HttpUtil.setResult(map, HttpUtil.HttpType.T200);
		boolean result = service.ModiBlNum(vo);
		map.put("result", result);
		return map;
	}
	
	
	@PostMapping("/api/common/revertDetail/reCrf")
	public HashMap<String, Object> reCrf(CommonRevertDetailVO vo, HttpServletRequest request, SearchVO searchVO, AdminLogProgramVO adminLogProgramVO) throws Exception {
		HashMap<String,Object> map = new HashMap<String,Object>();
		HttpUtil.setResult(map, HttpUtil.HttpType.T200);
		LoginVO loginInfo = LoginUtils.getLoginInfo(request);
		String userId = LoginUtils.getLoginInfo(request).getId();
		searchVO.setUserId(userId);

		//프로그램 이력 쌓기
		String trnLogSrno = null;
		trnLogSrno = adminLogProgramService.logProgramInsert(request, adminLogProgramVO, searchVO);
		
		vo.setLstDbChgId(loginInfo.getEno());
		vo.setAiInptCrpeEno(loginInfo.getEno());
		vo.setTrnLogSrno(trnLogSrno);
		service.reCrf(vo);
		
		map.put("rst", "success");
		
		return map;
	}
	
	
	@PostMapping("/api/common/revertDetail/reCrfMulti")
	public HashMap<String, Object> reCrfMulti(@RequestParam Map<String, Object> jsonObject, HttpServletRequest request, SearchVO searchVO, AdminLogProgramVO adminLogProgramVO) throws Exception {
		HashMap<String,Object> map = new HashMap<String,Object>();
		HttpUtil.setResult(map, HttpUtil.HttpType.T200);
		
		LoginVO loginInfo = LoginUtils.getLoginInfo(request);
		String userId = LoginUtils.getLoginInfo(request).getId();
		searchVO.setUserId(userId);
		
		String jsonStr = CastUtil.objToStr(jsonObject.get("jData"));
		Object jDataObj = JSONValue.parse(jsonStr);
		JSONObject params = CastUtil.objToJSONObj(jDataObj);
		String spdKind = CastUtil.objToStr(params.get("spdKind"));
		JSONArray reCrfList = CastUtil.objToJSONArr(params.get("reCrfList"));
		
		//프로그램 이력 쌓기
		String trnLogSrno = null;
		
		String aiInptCnctScrnNo = CastUtil.objToStr(params.get("aiInptCnctScrnNo"));
		String aiInptCnctFldCd = CastUtil.objToStr(params.get("aiInptCnctFldCd"));
		String aiInptCnctActiCd = CastUtil.objToStr(params.get("aiInptCnctActiCd"));
		String aiInptCnctParmTxt = CastUtil.objToStr(params.get("aiInptCnctParmTxt"));
		
		adminLogProgramVO.setAiInptCnctScrnNo(aiInptCnctScrnNo);
		adminLogProgramVO.setAiInptCnctFldCd(aiInptCnctFldCd);
		adminLogProgramVO.setAiInptCnctActiCd(aiInptCnctActiCd);
		adminLogProgramVO.setAiInptCnctParmTxt(aiInptCnctParmTxt);
		
		trnLogSrno = adminLogProgramService.logProgramInsert(request, adminLogProgramVO, searchVO);
		
		CommonRevertDetailVO vo = new CommonRevertDetailVO();
		
		// 데이터 파싱
		List<Map<String, String>> jsonList = new ArrayList<Map<String, String>>();
		if(reCrfList!=null && reCrfList.size() > 0) {
			for (Object object : reCrfList) {
				JSONObject row = CastUtil.objToJSONObj(object);
				Map<String, String> row2 = new HashMap<String, String>();
				
				Iterator keys = row.keySet().iterator();
				while(keys.hasNext()) {
					String key = CastUtil.objToStr(keys.next());
					String val = CastUtil.objToStr(row.get(key));
					row2.put(key, val);
				}
				jsonList.add(row2);
			}
		}
		
		if(jsonList == null) {
			map.put("rst", "fail");
		} else {
			for(Map jm: jsonList) {
				vo = new CommonRevertDetailVO();
				vo.setInptMstSrno(Integer.valueOf(CastUtil.objToStr(jm.get("inptMstSrno"))));
				vo.setInptBlGrpNo(Integer.valueOf(CastUtil.objToStr(jm.get("inptBlGrpNo"))));
				vo.setImexHisCd(CastUtil.objToStr(jm.get("imexHisCd")));
				vo.setInptTaskId(CastUtil.objToStr(jm.get("inptTaskId")));
				vo.setSpdKind(spdKind);
				
				vo.setLstDbChgId(loginInfo.getEno());
				vo.setAiInptCrpeEno(loginInfo.getEno());
				vo.setTrnLogSrno(trnLogSrno);

				service.reCrf(vo);
			}
		}
		
		map.put("rst", "success");
		
		return map;
	}
}
