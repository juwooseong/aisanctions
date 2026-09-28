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
import org.json.simple.parser.JSONParser;
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
import egovframework.ui.util.LoginUtils;

@RestController
public class ExtractionApiController {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(ExtractionApiController.class);

	/** 심사상세 공통 서비스 **/
	@Resource(name = "commonRevertDetailService")
	private CommonRevertDetailService service;

	/** 공통 서비스 **/
	@Resource(name = "commonCodeService")
	private CommonCodeService commonCodeService;

	/** EgovPropertyService */
	@Resource(name = "propertiesService")
	protected EgovPropertyService propertiesService;

	/** adminLogProgramService */
	@Resource(name = "adminLogProgramService")
	private AdminLogProgramService adminLogProgramService;

	/** Validator */
	@Resource(name = "beanValidator")
	protected DefaultBeanValidator beanValidator;

	@Resource(name = "systemFileProperties")
	protected Properties sysProp;

	@SuppressWarnings("unchecked")
	@PostMapping("/api/extraction")
	public HashMap<String, Object> extraction(@RequestParam Map<String, Object> jsonObject, HttpServletRequest request, CommonRevertDetailVO vo, SearchVO searchVO, AdminLogProgramVO adminLogProgramVO) throws Exception {
		HashMap<String,Object> map = new HashMap<String,Object>();
		HttpUtil.setResult(map, HttpUtil.HttpType.T200);
		LoginVO loginInfo = LoginUtils.getLoginInfo(request);
		
		String jDataStr = CastUtil.objToStr(jsonObject.get("jData"));
		Object jDataObj = JSONValue.parse(jDataStr);
		JSONObject params = CastUtil.objToJSONObj(jDataObj);
		
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
		
		JSONObject jsObj = null;
		
		String inptMstSrno = CastUtil.objToStr(params.get("inptMstSrno"));
		String aiInptAcvtCd = CastUtil.objToStr(params.get("aiInptAcvtCd"));
		
		jsObj = new JSONObject();
		jsObj.put("jobId", inptMstSrno);
		jsObj.put("aiInptAcvtCd", aiInptAcvtCd);
		
		HttpURLConnection conn = null;
		OutputStream os = null;
		BufferedReader in = null;
		String sendUrl = sysProp.getProperty("extraction.url");
		String inputLine = null;
		StringBuffer outResult = new StringBuffer();
		
		vo.setLstDbChgId(loginInfo.getEno());
		vo.setInptMstSrno(Integer.valueOf(inptMstSrno));
		vo.setTrnLogSrno(trnLogSrno);
		service.updateSantionHis(vo);	
		
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
				
				os.write(jsObj.toString().getBytes("UTF-8"));
				os.flush();
				os.close();
				
				if (conn.getResponseCode() == HttpURLConnection.HTTP_OK) {
					// 리턴된 결과값 읽기
					in = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"));
					
					while (true) {
						inputLine = in.readLine();
						
						if (inputLine == null ) {
							break;
						} else {
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
			
			LOGGER.debug("extraction");
			
		}
		
		map.put("rst", outResult.toString());
		
		return map;
	}
}
