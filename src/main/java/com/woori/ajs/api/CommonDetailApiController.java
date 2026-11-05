package com.woori.ajs.api;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.time.ZoneId;
import java.time.ZonedDateTime;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.bind.annotation.PostMapping;
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
public class CommonDetailApiController {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(CommonDetailApiController.class);
	
	@Resource(name = "adminLogProgramService")
	private AdminLogProgramService adminLogProgramService;
	
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

	@Resource(name = "systemFileProperties")
	protected Properties sysProp;

	@PostMapping("/api/common/detail/load")
	public HashMap<String, Object> load(SearchVO vo, HttpServletRequest request, AdminLogProgramVO adminLogProgramVO) throws Exception {
		SearchVO searchVO = new SearchVO();
		HashMap<String, Object> map = new HashMap<String, Object>();

		HttpUtil.setResult(map, HttpUtil.HttpType.T200);
		LoginVO loginInfo = LoginUtils.getLoginInfo(request);
		
		//프로그램 이력 쌓기
		String trnLogSrno = null;
		
		trnLogSrno = adminLogProgramService.logProgramInsert(request, adminLogProgramVO, searchVO);
		
		String nextAiInspAtvtCd = "";
		String aiInptAcvtStsCd = "";
		
		// 가장 최근 이력 코드 반환
		String CheackCd = service.CheackCd(vo);
		String btnFlag = vo.getBtnFlag();
		
		// 가장 최근 이력 코드가 50인 경우에만 업데이트, 심사상세, 결제상세 QA심사상세 화면만.
		if ( "50".equals(CheackCd) && ("C".equals(btnFlag) || "A".equals(btnFlag) || "B".equals(btnFlag) || "D".equals(btnFlag))) {
			CommonRevertDetailVO commonRevertDetailVO = new CommonRevertDetailVO();
			
			nextAiInspAtvtCd = "90";
			aiInptAcvtStsCd = "51";
			
			commonRevertDetailVO.setInptMstSrno(vo.getInptMstSrno());
			commonRevertDetailVO.setLstDbChgId(loginInfo.getEno());
			commonRevertDetailVO.setAiInptCrpeEno(loginInfo.getEno());
			commonRevertDetailVO.setNextAiInspAtvtCd(nextAiInspAtvtCd);
			commonRevertDetailVO.setAiInptAcvtStsCd(aiInptAcvtStsCd);
			commonRevertDetailVO.setTrnLogSrno(trnLogSrno);
			
			service.updateSantionHis(commonRevertDetailVO);
		}
		
		// 기본정보
		map.put("selectStdInfo", service.selectStdInfo(vo));
		
		// 공통그룹코드 set(문서분류)
		vo.setAiInptGrpCd("100");
		// 문서분류 콤보
		map.put("imexHisCdList", commonCodeService.selectAllCommonCodeList(vo));
		// 상단 B/L 탭
		map.put("topTab", service.selectTopTab(vo));
		// 좌측 문서분류 탭
		map.put("leftTab", service.selectLeftTab(vo));
		// 이미지 영역 이미지 정보
		map.put("imgPageInfo", service.selectImgPageInfo(vo));
		// 좌표 정보
		map.put("imgCdnts", service.selectImgCdnts(vo));
		// TotalText 결과
		map.put("totalTextRst", service.selectTotalTextRst(vo));
		// SafeWatch 결과
		map.put("safeWatchRst", service.selectSafeWtchRst(vo));
		// 항목심사 결과
		map.put("sanctionRst", service.selectSancRst(vo));
		// 전달이력
		map.put("selectOpiHis", service.selectOpiHis(vo));
		// 저장 된 전달할 의견
		map.put("selectOpi", service.selectOpi(vo));

		// 공통그룹코드 set(수출입명세코드)
		searchVO.setAiInptGrpCd("100");
		map.put("imexHisCdList", commonCodeService.selectAllCommonCodeList(searchVO));

		// 공통그룹코드 set(심사결과상태)
		searchVO.setAiInptGrpCd("170");
		map.put("inptRstCdList", commonCodeService.selectAllCommonCodeList(searchVO));

		return map;
	}
	
	@PostMapping("/api/common/detail/safeWatchload")
	public HashMap<String, Object> safeWatchload(SearchVO vo, HttpServletRequest request, AdminLogProgramVO adminLogProgramVO) throws Exception {
		SearchVO searchVO = new SearchVO();
		HashMap<String, Object> map = new HashMap<String, Object>();
		
		HttpUtil.setResult(map, HttpUtil.HttpType.T200);
		LoginVO loginInfo = LoginUtils.getLoginInfo(request);
		
		//프로그램 이력 쌓기
		String trnLogSrno = null;
		
		trnLogSrno = adminLogProgramService.logProgramInsert(request, adminLogProgramVO, searchVO);
		
		// SafeWatch 결과
		map.put("safeWatchRst", service.selectSafeWtchRst(vo));
		
		// 기본정보
		map.put("selectStdInfo", service.selectStdInfo(vo));
		
		return map;
	}
	
	
	
	@PostMapping("/api/common/detail/reload")
	public HashMap<String, Object> reload(SearchVO vo, HttpServletRequest request, AdminLogProgramVO adminLogProgramVO) throws Exception {
		HashMap<String, Object> map = new HashMap<String, Object>();
		
		HttpUtil.setResult(map, HttpUtil.HttpType.T200);
		
		//프로그램 이력 쌓기
		String trnLogSrno = null;
		
		trnLogSrno = adminLogProgramService.logProgramInsert(request, adminLogProgramVO, vo);
		
		// 기본정보
		map.put("selectStdInfo", service.selectStdInfo(vo));
		// 항목심사 결과
		map.put("sanctionRst", service.selectSancRst(vo));
		// 전달이력
		map.put("selectOpiHis", service.selectOpiHis(vo));
		// 저장 된 전달할 의견
		map.put("selectOpi", service.selectOpi(vo));
		
		return map;
	}

	@PostMapping("/api/common/detail/nacrd")
	public HashMap<String, Object> selectInptNacrd(SearchVO vo) throws Exception {
		HashMap<String, Object> map = new HashMap<String, Object>();

		HttpUtil.setResult(map, HttpUtil.HttpType.T200);

		map.put("selectInptNacrd", service.selectInptNacrd(vo));

		return map;
	}
	
	@PostMapping("/api/common/detail/getNationCd")
	public HashMap<String, Object> getNationCd(CommonRevertDetailVO vo) throws Exception {
		HashMap<String, Object> map = new HashMap<String, Object>();
		
		HttpUtil.setResult(map, HttpUtil.HttpType.T200);
		
		map.put("nationCd", service.getNationCd(vo));
		
		return map;
	}

	@PostMapping("/api/common/detail/imgRest")
	public HashMap<String,Object> imgRest(SearchVO vo) throws Exception {
		HashMap<String,Object> map = new HashMap<String,Object>();
		HttpUtil.setResult(map, HttpUtil.HttpType.T200);
		
		ZonedDateTime seoulDateTime = ZonedDateTime.now(ZoneId.of("Asia/Seoul"));
		String time = seoulDateTime.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
		
		HttpURLConnection conn = null;
		OutputStream os = null;
		BufferedReader in = null;
		String sendUrl = sysProp.getProperty("img.url");
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
				
				HashMap<String, String> resultMap = new HashMap();
				resultMap.put("inpt_task_id", vo.getInptTaskId());
				resultMap.put("inpt_mst_srno", Integer.toString(vo.getInptMstSrno()));
				
				JSONObject json = new JSONObject();
				json.putAll(resultMap);
				
				os.write(json.toString().getBytes("UTF-8"));
				
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
					
					JSONParser jsonParser = new JSONParser();
					
					if (outResult == null || "".equals(outResult.toString())) {
						
						HttpUtil.setResult(map, HttpUtil.HttpType.T500);
						HttpUtil.setExResult(map, "-1", "이미지 로드가 실패했습니다.");
						
					} else {
						
						JSONObject jsonObj = CastUtil.objToJSONObj(jsonParser.parse(outResult.toString()));
						String imgStr = CastUtil.objToStr(jsonObj.get("imgStr"));
						
						map.put("imgStr", imgStr);
					}
					
				} else {
					
					HttpUtil.setResult(map, HttpUtil.HttpType.T500);
					HttpUtil.setExResult(map, "-1", "CA서버에 연결할 수 없습니다.");
					
				}
				
				conn.disconnect();
				
			}
			
		} catch (Exception e) {
			// logger.error(e.getMessage(),e);
			// 문제 발생시 에러처리와 사용자 화면에서의 안내 메세지를 어떻게 할지 정해야 한다.
			//e.printStackTrace();
			
			HttpUtil.setResult(map, HttpUtil.HttpType.T500);
			HttpUtil.setExResult(map, "-1", "이미지 처리가 지연되고 있습니다. \r잠시 후 다시 거래해 주시기 바랍니다.");
			
			if (in != null) {
				in.close();
			}
			
			if (os != null) {
				os.close();
			}
			
			if (conn != null) {
				conn.disconnect();
			}
			
		} finally {
			
			LOGGER.debug("imgRest");
			
		}
		
		
		seoulDateTime = ZonedDateTime.now(ZoneId.of("Asia/Seoul"));
		time = seoulDateTime.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
		
		return map;
	}
}
