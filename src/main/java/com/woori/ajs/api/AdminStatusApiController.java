package com.woori.ajs.api;

import java.io.BufferedReader;
import java.io.File;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.sql.Clob;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import javax.annotation.Resource;
import javax.naming.Context;
import javax.naming.InitialContext;
import javax.servlet.http.HttpServletRequest;
import javax.sql.DataSource;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.JSONValue;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.BeanFactory;
import org.springframework.beans.factory.xml.XmlBeanFactory;
import org.springframework.core.io.FileSystemResource;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;
import org.springmodules.validation.commons.DefaultBeanValidator;

import com.woori.ajs.model.AdminLogProgramVO;
import com.woori.ajs.model.AdminStatusTablesVO;
import com.woori.ajs.model.AdminStatusVO;
import com.woori.ajs.model.AdminWordCorrectionVO;
import com.woori.ajs.model.CommonRevertDetailVO;
import com.woori.ajs.model.LoginVO;
import com.woori.ajs.model.RevertStatCompleteVO;
import com.woori.ajs.model.SearchVO;
import com.woori.ajs.service.AdminLogProgramService;
import com.woori.ajs.service.AdminStatusService;

import egovframework.rte.fdl.property.EgovPropertyService;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import egovframework.ui.cmmn.CastUtil;
import egovframework.ui.cmmn.ComUtil;
import egovframework.ui.cmmn.DateUtil;
import egovframework.ui.cmmn.FileUtil;
import egovframework.ui.cmmn.HttpUtil;
import egovframework.ui.cmmn.StringUtil;
import egovframework.ui.cmmn.XlsUtil;
import egovframework.ui.util.LoginUtils;

@RestController
public class AdminStatusApiController {
	private static final Logger LOGGER = LoggerFactory.getLogger(RevertStatCompleteApiController.class);
	/** adminStatusService */
	@Resource(name = "adminStatusService")
	private AdminStatusService adminStatusService;

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
	
	@GetMapping("/api/admin/status")
	public HashMap<String,Object> list(SearchVO searchVO) throws Exception {
		HashMap<String,Object> map = new HashMap<String,Object>();
		
		HttpUtil.setResult(map, HttpUtil.HttpType.T200);
		
		map.put("searchVO",searchVO);
		
		PaginationInfo paginationInfo = ComUtil.setListPagingInfo(propertiesService, searchVO);
		//searchVO.setRecordCountPerPage(-1);
		
		List<AdminStatusVO> list = adminStatusService.selectList(searchVO);
		map.put("resultList", list);
		
		int totCnt = adminStatusService.selectListTotCnt(searchVO);
		//int totCnt = list==null ? 0 : list.size();
		
		paginationInfo.setTotalRecordCount(totCnt);
		map.put("paginationInfo", paginationInfo);
		
		return map;
	}
	
	
	@PostMapping("/api/admin/status/inspection")
	public HashMap<String, Object> inspection(@RequestParam Map<String, Object> jsonObject, HttpServletRequest request, SearchVO searchVO, AdminLogProgramVO adminLogProgramVO) throws Exception {
		HashMap<String,Object> map = new HashMap<String,Object>();
		HttpUtil.setResult(map, HttpUtil.HttpType.T200);
		
		LoginVO loginInfo = LoginUtils.getLoginInfo(request);
		
		String jsonStr = CastUtil.objToStr(jsonObject.get("jData"));
		JSONObject jsonObj = CastUtil.objToJSONObj(JSONValue.parse(jsonStr));
		String inptMstSrno = CastUtil.objToStr(jsonObj.get("inptMstSrno"));
		String aiInptAcvtCd = CastUtil.objToStr(jsonObj.get("aiInptAcvtCd"));
		
		String userId = LoginUtils.getLoginInfo(request).getId();
		searchVO.setUserId(userId);
		
		//프로그램 이력 쌓기
		String aiInptCnctScrnNo = CastUtil.objToStr(jsonObj.get("aiInptCnctScrnNo"));
		String aiInptCnctFldCd = CastUtil.objToStr(jsonObj.get("aiInptCnctFldCd"));
		String aiInptCnctActiCd = CastUtil.objToStr(jsonObj.get("aiInptCnctActiCd"));
		String aiInptCnctParmTxt = CastUtil.objToStr(jsonObj.get("aiInptCnctParmTxt"));
		
		adminLogProgramVO.setAiInptCnctScrnNo(aiInptCnctScrnNo);
		adminLogProgramVO.setAiInptCnctFldCd(aiInptCnctFldCd);
		adminLogProgramVO.setAiInptCnctActiCd(aiInptCnctActiCd);
		adminLogProgramVO.setAiInptCnctParmTxt(aiInptCnctParmTxt);
		
		adminLogProgramService.logProgramInsert(request, adminLogProgramVO, searchVO);
		
		// TA 전송 시작
		JSONObject jsObj = null;
		JSONArray jsArray = new JSONArray();
		
		jsObj = new JSONObject();
		jsObj.put("jobId", inptMstSrno);
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
	
	
	@PostMapping("/api/admin/status/extraction")
	public HashMap<String, Object> extraction(@RequestParam Map<String, Object> jsonObject, HttpServletRequest request, CommonRevertDetailVO vo, SearchVO searchVO, AdminLogProgramVO adminLogProgramVO) throws Exception {
		HashMap<String,Object> map = new HashMap<String,Object>();
		HttpUtil.setResult(map, HttpUtil.HttpType.T200);
		LoginVO loginInfo = LoginUtils.getLoginInfo(request);
		
		String jDataStr = CastUtil.objToStr(jsonObject.get("jData"));
		Object jDataObj = JSONValue.parse(jDataStr);
		JSONObject params = CastUtil.objToJSONObj(jDataObj);
		
		//프로그램 이력 쌓기
		String aiInptCnctScrnNo = CastUtil.objToStr(params.get("aiInptCnctScrnNo"));
		String aiInptCnctFldCd = CastUtil.objToStr(params.get("aiInptCnctFldCd"));
		String aiInptCnctActiCd = CastUtil.objToStr(params.get("aiInptCnctActiCd"));
		String aiInptCnctParmTxt = CastUtil.objToStr(params.get("aiInptCnctParmTxt"));
		
		adminLogProgramVO.setAiInptCnctScrnNo(aiInptCnctScrnNo);
		adminLogProgramVO.setAiInptCnctFldCd(aiInptCnctFldCd);
		adminLogProgramVO.setAiInptCnctActiCd(aiInptCnctActiCd);
		adminLogProgramVO.setAiInptCnctParmTxt(aiInptCnctParmTxt);
		
		adminLogProgramService.logProgramInsert(request, adminLogProgramVO, searchVO);
		
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
	
	
	@PostMapping("/api/common/status/daily")
	public HashMap<String, Object> listDaily(SearchVO searchVO) throws Exception{
		HashMap<String,Object> map = new HashMap<String,Object>();
		
		HttpUtil.setResult(map, HttpUtil.HttpType.T200);
		
		map.put("searchVO",searchVO);
		
		List<AdminStatusVO> list = adminStatusService.selectDailyList(searchVO);
		map.put("resultList", list);
		
		return map;
	}
	
	@PostMapping("/api/common/status/aside")
	public HashMap<String, Object> listAside(SearchVO searchVO) throws Exception{
		HashMap<String,Object> map = new HashMap<String,Object>();
		
		HttpUtil.setResult(map, HttpUtil.HttpType.T200);
		
		map.put("searchVO",searchVO);
		
		List<AdminStatusVO> list = adminStatusService.selectAsideList();
		int cnt_ungen = adminStatusService.selectAsideUngeneratedCount();
		
		map.put("rst", "success");
		map.put("resultAsideList", list);
		map.put("cnt_ungen", cnt_ungen);
		
		return map;
	}
	
	@PostMapping("/api/common/status/aside/interval")
	public HashMap<String, Object> listAsideInterval(SearchVO searchVO) throws Exception{
		HashMap<String,Object> map = new HashMap<String,Object>();
		
		HttpUtil.setResult(map, HttpUtil.HttpType.T200);
		
		map.put("searchVO",searchVO);
		
		String asideInterval = adminStatusService.selectAsideInterval();
		
		map.put("rst", "success");
		map.put("asideInterval", asideInterval);
		
		return map;
	}
	
	@PostMapping("/api/admin/status/activty/mod")
	public HashMap<String, Object> confirm(HttpServletRequest request, AdminStatusVO adminStatusVO, AdminLogProgramVO adminLogProgramVO, SearchVO searchVO) throws Exception{
		HashMap<String,Object> map = new HashMap<String,Object>();
		
		LoginVO userInfo = LoginUtils.getLoginInfo(request);
		
		String trnLogSrno = null;
		trnLogSrno = adminLogProgramService.logProgramInsert(request, adminLogProgramVO, searchVO);
		adminStatusVO.setTrnLogSrno(trnLogSrno);
		adminStatusVO.setLstDbChgId(userInfo.getId());
		
		adminStatusService.statusDeleteQueue(adminStatusVO);
		adminStatusService.statusActivityUpdate(adminStatusVO);
		
		CommonRevertDetailVO commonRevertDetailVO = new CommonRevertDetailVO();
		commonRevertDetailVO.setInptMstSrno(Integer.parseInt(adminStatusVO.getInptMstSrno()));
		commonRevertDetailVO.setAiInptBizDscd(adminStatusVO.getInptAtmcBizDscd());
		commonRevertDetailVO.setNextAiInspAtvtCd(adminStatusVO.getAiInptAcvtCd());
		commonRevertDetailVO.setAiInptAcvtStsCd(adminStatusVO.getAiSysInptPrgStcd());
		commonRevertDetailVO.setAiInptCrpeEno(userInfo.getEno());
		commonRevertDetailVO.setAiInptPrcOpiTxt("액티비티 강제변경");
		commonRevertDetailVO.setTrnLogSrno(trnLogSrno);
		commonRevertDetailVO.setLstDbChgId(userInfo.getId());
		
		adminStatusService.statusActivityModHistory(commonRevertDetailVO);
		
		map.put("rst", "success");
		return map;
	}
	
	@PostMapping("/api/admin/status/reprocess")
	public HashMap<String, Object> reprocess(HttpServletRequest request, AdminStatusVO adminStatusVO, AdminLogProgramVO adminLogProgramVO, SearchVO searchVO) throws Exception{
		HashMap<String,Object> map = new HashMap<String,Object>();
		
		LoginVO userInfo = LoginUtils.getLoginInfo(request);
		
		String trnLogSrno = null;
		trnLogSrno = adminLogProgramService.logProgramInsert(request, adminLogProgramVO, searchVO);
		
		adminStatusVO.setTrnLogSrno(trnLogSrno);
		adminStatusVO.setLstDbChgId(userInfo.getId());
		
		adminStatusService.statusReprocess(adminStatusVO);
		
		map.put("rst", "success");
		return map;
	}
	
	@PostMapping("/api/admin/status/delete")
	public HashMap<String, Object> deleteProcess(HttpServletRequest request, AdminStatusVO adminStatusVO, AdminLogProgramVO adminLogProgramVO, SearchVO searchVO) throws Exception{
		HashMap<String,Object> map = new HashMap<String,Object>();
		
		LoginVO userInfo = LoginUtils.getLoginInfo(request);
		
		String trnLogSrno = null;
		trnLogSrno = adminLogProgramService.logProgramInsert(request, adminLogProgramVO, searchVO);
		
		adminStatusService.statusDeleteMaster(adminStatusVO);
		adminStatusService.statusDeleteMasterDetail(adminStatusVO);
		adminStatusService.statusDeleteHistory(adminStatusVO);
		adminStatusService.statusDeleteQueue(adminStatusVO);
		
		map.put("rst", "success");
		return map;
	}
	
	@PostMapping("/api/admin/status/reg/confirm")
	public HashMap<String,Object> regConfirm(HttpServletRequest request, SearchVO searchVO) throws Exception {
		HashMap<String,Object> map = new HashMap<String,Object>();
		
		HttpUtil.setResult(map, HttpUtil.HttpType.T200);
		
		map.put("searchVO",searchVO);
		
		if("20200120".equals(searchVO.getAiInptUserYn())) {
			map.put("rst", "success");
		}else {
			map.put("rst", "fail");
		}
		
		return map;
	}
	
	@GetMapping("/api/admin/status/queryUse")
	public HashMap<String,Object> queryUse(SearchVO vo) throws Exception {
		HashMap<String,Object> map = new HashMap<String,Object>();
		HttpUtil.setResult(map, HttpUtil.HttpType.T200);
		PaginationInfo paginationInfo = ComUtil.setListPagingInfo(propertiesService, vo);
		List<AdminStatusTablesVO> queryUse = null;
		vo.setRecordCountPerPage(-1);
		
		if(vo.getQueryTestParam() == null || "".equals(vo.getQueryTestParam())) {
			queryUse = adminStatusService.queryTestDefault(vo);
		}else {
			queryUse = adminStatusService.queryTest(vo);
		}
		paginationInfo.setTotalRecordCount(queryUse.size());
		
		
		
		map.put("searchVO",vo);
		map.put("paginationInfo",paginationInfo);
		map.put("resultList", queryUse);
		
		return map;
	}
	
	@GetMapping("/api/admin/status/queryUse/new")
	public HashMap<String,Object> queryUseNew(HttpServletRequest request,SearchVO vo) throws Exception {
		HashMap<String,Object> map = new HashMap<String,Object>();
		HttpUtil.setResult(map, HttpUtil.HttpType.T200);
		PaginationInfo paginationInfo = ComUtil.setListPagingInfo(propertiesService, vo);
		List<Map<String, Object>> queryUse = null;
		vo.setRecordCountPerPage(-1);
		
		int errorFlag = 0;
		
		List<String> columnList = jdbcMainConnection(vo.getQueryTestParam());
		
		try {
			
			if(vo.getQueryTestParam() == null || "".equals(vo.getQueryTestParam())) {
				queryUse = adminStatusService.queryTestNew(vo);
			}else {
				queryUse = adminStatusService.queryTestNew(vo);
			}
			
		}catch(Exception e){
			LOGGER.debug(e.toString());
			errorFlag = 1;
		}
		
		if(queryUse != null && queryUse.size() == 0) {
			errorFlag = 2;
		}else if(queryUse != null && queryUse.size() > 0) {
			paginationInfo.setTotalRecordCount(queryUse.size());
			
			/*
			List<String> columnList = new ArrayList<String>();
			
			for(String keyStr : queryUse.get(0).keySet()) {
				columnList.add(keyStr);
			}*/
			
			// Clob DB타입 to String check
			for(int index = 0 ; index < queryUse.size() ; index++) {
				for(int inner = 0 ; inner < columnList.size() ; inner++) {
					if(queryUse.get(index) != null && queryUse.get(index).get(columnList.get(inner)) instanceof java.sql.Clob) {
						queryUse.get(index).put(columnList.get(inner), clobToString((Clob) queryUse.get(index).get(columnList.get(inner))));
					}
					
					if(queryUse.get(index).get(columnList.get(inner)) == null) {
						queryUse.get(index).put(columnList.get(inner), " ");
					}
				}
			}
			
			map.put("searchVO",vo);
			map.put("paginationInfo",paginationInfo);
			map.put("columnList", columnList);
			map.put("resultList", queryUse);	
		}
			
		
		
		if (errorFlag == 0) {
			map.put("rstCode", "success");
		} else if (errorFlag == 2) {
			map.put("rstCode", "zero");
		} else {
			map.put("rstCode", "error");
		}
		
		return map;
	}
	
	// Connect to jdbc for Get Column
	public List<String> jdbcMainConnection(String paramSql) {
		Connection conn = null;
		PreparedStatement stmt = null;
		ResultSet rs = null;
		
		List<String> columnList = new ArrayList<String>();
		
		try {
			
			
			// 아래 3 줄은 로컬용 설정
			
			Class.forName("com.tmax.tibero.jdbc.TbDriver");
			String url = "jdbc:tibero:thin:@10.232.181.109:8639:SPDDBT";
			conn = DriverManager.getConnection(url, "SPDAPP", "!w01apdev");
			
			
			
			// JNDI 서버 객체 생성
			/*
			InitialContext ic = new InitialContext();
			// lookup
			DataSource ds = (DataSource) ic.lookup("jdbc/spddbt");
			conn = ds.getConnection();
			*/
			
			StringBuffer sqlSb = new StringBuffer();
			String sqlPrefix = "SELECT INNER.* FROM (";
			String sqlStatement = paramSql;
			String sqlSuffix = " ) INNER WHERE ROWNUM = 1";
			sqlSb.append(sqlPrefix).append(sqlStatement).append(sqlSuffix);
			String sql = sqlSb.toString();
			
			stmt = conn.prepareStatement(sql);
			rs = stmt.executeQuery();
			
			ResultSetMetaData rsmd = rs.getMetaData();
			
			for(int i = 1; i <= rsmd.getColumnCount() ; i++) {
				columnList.add(rsmd.getColumnName(i));
			}
			
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			try {
				if(conn != null && !conn.isClosed()) {
					conn.close();
				}
				if(stmt != null && !stmt.isClosed()) {
					stmt.close();
				}
				if(rs != null && !rs.isClosed()) {
					rs.close();
				}
			}catch(SQLException e) {
				e.printStackTrace();
			}
		}
		
		return columnList;
	}
	
	// Clob to String
	public String clobToString(Clob clob) throws Exception{
		if(clob == null) {
			return " ";
		}
		
		StringBuffer sb = new StringBuffer();
		String str = "";
		BufferedReader br = new BufferedReader(clob.getCharacterStream());
		while((str = br.readLine()) != null) {
			sb.append(str);
		}
		return sb.toString();
	}
	
	@PostMapping("/api/admin/status/queryUse")
	public HashMap<String,Object> queryUseCUD(SearchVO vo) throws Exception {
		HashMap<String,Object> map = new HashMap<String,Object>();
		HttpUtil.setResult(map, HttpUtil.HttpType.T200);
		PaginationInfo paginationInfo = ComUtil.setListPagingInfo(propertiesService, vo);
		List<AdminStatusTablesVO> queryUse = null;
		vo.setRecordCountPerPage(-1);
		
		if("C".equals(vo.getCrud())) {
			adminStatusService.queryTestInsert(vo);
		}/*else if(vo.getCrud().equals("R")) {
			queryUse = adminStatusService.queryTest(vo);
		}*/else if("U".equals(vo.getCrud())) {
			System.out.println("JAVA 업데이트 부분입니다 !");
			adminStatusService.queryTestUpdate(vo);
		}else {
			adminStatusService.queryTestDelete(vo);
		}

		map.put("searchVO",vo);
		map.put("paginationInfo",paginationInfo);
		map.put("resultList", queryUse);
		
		return map;
	}
	
	@GetMapping("/api/admin/status/xls/new")
	public ModelAndView listXlsNew(SearchVO searchVO, ModelAndView mv) throws Exception {
		mv.setViewName("downView");					//파일다운로드뷰
		String tableStr = "테이블데이터_";
		String xlsDownName = StringUtil.concat(new String[] {tableStr,DateUtil.getFormatDate("yyyyMMdd"),".xlsx"});
		searchVO.setRecordCountPerPage(-1);
		
		List<Map<String, Object>> list = adminStatusService.queryTestNew(searchVO);
		
		List<String> columnList = jdbcMainConnection(searchVO.getQueryTestParam());
		
		List<String[]> xlsListsTitle = XlsUtil.createListsTitle();
		List<List<LinkedHashMap<String,String>>> xlsLists = XlsUtil.createLists();
		
		// Clob DB타입 to String check
		for(int index = 0 ; index < list.size() ; index++) {
			for(int inner = 0 ; inner < columnList.size() ; inner++) {
				if(list.get(index) != null && list.get(index).get(columnList.get(inner)) instanceof java.sql.Clob) {
					list.get(index).put(columnList.get(inner), clobToString((Clob) list.get(index).get(columnList.get(inner))));
				}
				
				if(list.get(index).get(columnList.get(inner)) == null) {
					list.get(index).put(columnList.get(inner), " ");
				}
			}
		}
		
		xlsListsTitle.add(columnList.toArray(new String[columnList.size()]));
		
		if(list!=null) {
			List<LinkedHashMap<String,String>> xlsList = XlsUtil.createList();
			for(int i=0;i<list.size();i++) {
				
				LinkedHashMap<String,String> rowMap = new LinkedHashMap<String,String>();
				Map<String, Object> row = list.get(i);
				
				for(String getKey : columnList) {
					rowMap.put(getKey, String.valueOf(row.get(getKey))); // 꺼내온 칼럼값
					
				}
				xlsList.add(rowMap);
				
			} 
			xlsLists.add(xlsList);
			
		}
		String uploadPath = StringUtil.nvl(sysProp.getProperty("upload.path"));
		File xlsFile = XlsUtil.createXlsFile(uploadPath, xlsListsTitle, xlsLists);
		try {
			FileUtil.setFileDown(mv, xlsFile, xlsDownName);
		} catch (Exception e) {
			LOGGER.error("Exception ::: " + e);
		}
		
		return mv;
		
	}
	
	@GetMapping("/api/admin/status/xls")
	public ModelAndView listXls(SearchVO searchVO, ModelAndView mv) throws Exception {
		mv.setViewName("downView");					//파일다운로드뷰
		String tableId = searchVO.getTable();
		String tableStr = "테이블데이터_";
		tableStr = tableStr.concat(tableId);
		String xlsDownName = StringUtil.concat(new String[] {tableStr,DateUtil.getFormatDate("yyyyMMdd"),".xlsx"});
		searchVO.setRecordCountPerPage(-1);
		
		List<AdminStatusTablesVO> list = adminStatusService.queryTest(searchVO);
		List<String[]> xlsListsTitle = XlsUtil.createListsTitle();
		List<List<LinkedHashMap<String,String>>> xlsLists = XlsUtil.createLists();
		
		if("CSPD001TM".equals(tableId)) {
			xlsListsTitle.add(new String[] {"심사마스터일련번호", "심사접수일자", "ACTUAL외환참조번호", "외환참조번호일련번호", "AI심사이미지키번호", "심사자동화업무구분코드", "AI심사서류스캔담당직원번호", "AI심사서류스캔일시", "TOTALTEXTAI심사결과코드", 
					"항목심사AI심사결과코드", "SAFEWATCHAI심사결과코드", "AI심사자직원번호", "AI심사결재상태코드", "문서분류오류여부", "문서재스캔완료여부", "문서재스캔필요여부", "품질보증진행여부", "품질보증담당자직원번호", 
					"품질보증AI심사결과코드", "AI심사프로세스코드", "AI심사활동코드", "AI심사결재자직원번호", "AI심사품질보증결재상태코드", "AI심사품질보증프로세스코드", "AI심사품질보증활동코드", "품질보증결재자직원번호", "품질보증배정일자", "거래로그일련번호", "최종DB변경ID", "최종DB변경일시"});
			if(list!=null) {
				List<LinkedHashMap<String,String>> xlsList = XlsUtil.createList();
				for(int i=0;i<list.size();i++) {
					LinkedHashMap<String,String> rowMap = new LinkedHashMap<String,String>();
					// RevertStatCompleteVO row = (RevertStatCompleteVO)list.get(i);
					AdminStatusTablesVO row = list.get(i);
					rowMap.put("inptMstSrno" 			, row.getInptMstSrno()); 		
					rowMap.put("inptRcpDt"  			, row.getInptRcpDt());  		
					rowMap.put("actlFxRefno"  			, row.getActlFxRefno());  		
					rowMap.put("fxRefnoSrno"  			, row.getFxRefnoSrno());  		
					rowMap.put("aiInptImgKeyNo"  		, row.getAiInptImgKeyNo());  	
					rowMap.put("inptAtmcBizDscd"  		, row.getInptAtmcBizDscd());  	
					rowMap.put("aiInptDocScanChrgEno"	, row.getAiInptDocScanChrgEno()); 
					rowMap.put("aiInptDocScanDtm"  		, row.getAiInptDocScanDtm());  	
					rowMap.put("totaltextAiInptRstCd"	, row.getTotaltextAiInptRstCd()); 
					rowMap.put("itmInptAiInptRstCd"  	, row.getItmInptAiInptRstCd()); 
					rowMap.put("safewatchAiInptRstCd"	, row.getSafewatchAiInptRstCd()); 
					rowMap.put("aiInspeEno"  			, row.getAiInspeEno());  		
					rowMap.put("aiInptAppvStcd"  		, row.getAiInptAppvStcd());  	
					rowMap.put("papsClfErrYn"  			, row.getPapsClfErrYn());  		
					rowMap.put("papsReScanCmplYn"  		, row.getPapsReScanCmplYn());  	
					rowMap.put("papsReScanNedYn"  		, row.getPapsReScanNedYn());  	
					rowMap.put("qlasPrgYn"  			, row.getQlasPrgYn());  		
					rowMap.put("qlasCrpeEno"  			, row.getQlasCrpeEno());  		
					rowMap.put("qltGrnAiInptRstCd"  	, row.getQltGrnAiInptRstCd());  
					rowMap.put("aiInptProsCd"  			, row.getAiInptProsCd());  		
					rowMap.put("aiInptAcvtCd"  			, row.getAiInptAcvtCd());  		
					rowMap.put("aiInptSnpeEno"  		, row.getAiInptSnpeEno());  	
					rowMap.put("aiInptQlasAppvStcd"  	, row.getAiInptQlasAppvStcd()); 
					rowMap.put("aiInptQlasProsCd"  		, row.getAiInptQlasProsCd());  	
					rowMap.put("aiInptQlasAcvtCd"  		, row.getAiInptQlasAcvtCd());  	
					rowMap.put("qlasSnpeEno"  			, row.getQlasSnpeEno());  		
					rowMap.put("qlasAlocDt"  			, row.getQlasAlocDt());  		
					rowMap.put("trnLogSrno"  			, row.getTrnLogSrno());  		
					rowMap.put("lstDbChgId"  			, row.getLstDbChgId());  		
					rowMap.put("lstDbChgDtm" 			, row.getLstDbChgDtm()); 	

					xlsList.add(rowMap);
				} 
				xlsLists.add(xlsList);
			}
		}
		
		
		if("CSPD002TG".equals(tableId)) {
			xlsListsTitle.add(new String[] {"심사마스터일련번호", "심사태스크ID", "심사선하증권그룹번호", "수출입명세코드", "수출입명세일련번호", "선박등록번호", "AI심사CNN상태내용"
					, "AI심사RCNN상태내용", "AI심사분산실행서버내용", "심사요소ID", "심사문서파일명", "심사문서파일경로내용", "AI심사서류유형명", "AI심사AICR결과내용"
					, "AI심사전체AICR결과내용", "AI심사문서품질점수", "거래로그일련번호", "최종DB변경ID", "최종DB변경일시"});
			if(list!=null) {
				List<LinkedHashMap<String,String>> xlsList = XlsUtil.createList();
				for(int i=0;i<list.size();i++) {
					LinkedHashMap<String,String> rowMap = new LinkedHashMap<String,String>();
					// RevertStatCompleteVO row = (RevertStatCompleteVO)list.get(i);
					AdminStatusTablesVO row = list.get(i);
					rowMap.put("inptMstSrno" ,row.getInptMstSrno());
					rowMap.put("inptTaskId" ,row.getInptTaskId());
					rowMap.put("inptBlGrpNo" ,row.getInptBlGrpNo());
					rowMap.put("imexHisCd" ,row.getImexHisCd());
					rowMap.put("imexHisSrno" ,row.getImexHisSrno());
					rowMap.put("shipRgsNo" ,row.getShipRgsNo());
					rowMap.put("aiInptCnnStsTxt" ,row.getAiInptCnnStsTxt());
					rowMap.put("aiInptRcnnStsTxt" ,row.getAiInptRcnnStsTxt());
					rowMap.put("aiInptDsrsExeSvrTxt" ,row.getAiInptDsrsExeSvrTxt());
					rowMap.put("inptElmtId" ,row.getInptElmtId());
					rowMap.put("inptPapsFileNm" ,row.getInptPapsFileNm());
					rowMap.put("inptPapsFilePathTxt" ,row.getInptPapsFilePathTxt());
					rowMap.put("aiInptDocTpNm" ,row.getAiInptDocTpNm());
					rowMap.put("aiInptAicrRstTxt" ,row.getAiInptAicrRstTxt());
					rowMap.put("aiInptAllAicrRstTxt" ,row.getAiInptAllAicrRstTxt());
					rowMap.put("aiInptPapsQltScre" ,row.getAiInptPapsQltScre());
					rowMap.put("trnLogSrno" ,row.getTrnLogSrno());
					rowMap.put("lstDbChgId" ,row.getLstDbChgId());
					rowMap.put("lstDbChgDtm", row.getLstDbChgDtm());
					
					xlsList.add(rowMap);
				} 
				xlsLists.add(xlsList);
			}
		}
		
		if("CSPD003TF".equals(tableId)) {
			xlsListsTitle.add(new String[] {"심사마스터일련번호", "심사태스크ID", "AI심사TOTALTEXT일련번호", "AI심사TOTALTEXT보정여부", "심사SANCTION데이터내용", "보정전텍스트분석추출내용",
			 "보정후텍스트분석추출내용", "보정전AICR추출내용", "보정후AICR추출내용", "항목심사X축시작좌표수", "항목심사Y축시작좌표수", "항목심사X축종료좌표수", "항목심사Y축종료좌표수", "AI심사ALERT여부", "AI심사SANCTION규칙내용",
			 "AI심사단어일치율", "거래로그일련번호", "최종DB변경ID", "최종DB변경일시"});
			if(list!=null) {
				List<LinkedHashMap<String,String>> xlsList = XlsUtil.createList();
				for(int i=0;i<list.size();i++) {
					LinkedHashMap<String,String> rowMap = new LinkedHashMap<String,String>();
					// RevertStatCompleteVO row = (RevertStatCompleteVO)list.get(i);
					AdminStatusTablesVO row = list.get(i);

					rowMap.put("inptMstSrno"			, row.getInptMstSrno());
					rowMap.put("inptTaskId"				, row.getInptTaskId());
					rowMap.put("aiInptTotaltextSrno"	, row.getAiInptTotaltextSrno());
					rowMap.put("aiInptTotaltextRvsnYn"	, row.getAiInptTotaltextRvsnYn());
					rowMap.put("inptSanctionDatTxt"		, row.getInptSanctionDatTxt());
					rowMap.put("bfrsTaExtcTxt"			, row.getBfrsTaExtcTxt());
					rowMap.put("afrsTaExtcTxt"			, row.getAfrsTaExtcTxt());
					rowMap.put("bfrsAicrExtcTxt"		, row.getBfrsAicrExtcTxt());
					rowMap.put("afrsAicrExtcTxt"		, row.getAfrsAicrExtcTxt());
					rowMap.put("itmInptXaxisStaCrdnCn"	, row.getItmInptXaxisStaCrdnCn());
					rowMap.put("itmInptYaxisStaCrdnCn"	, row.getItmInptYaxisStaCrdnCn());
					rowMap.put("itmInptXaxisEndCrdnCn"	, row.getItmInptXaxisEndCrdnCn());
					rowMap.put("itmInptYaxisEndCrdnCn"	, row.getItmInptYaxisEndCrdnCn());
					rowMap.put("aiInptAltYn"			, row.getAiInptAltYn());
					rowMap.put("aiInptSanctionRuleTxt"	, row.getAiInptSanctionRuleTxt());
					rowMap.put("aiInptWordAcrdRt"		, row.getAiInptWordAcrdRt());
					rowMap.put("trnLogSrno"				, row.getTrnLogSrno());
					rowMap.put("lstDbChgId"				, row.getLstDbChgId());
					rowMap.put("lstDbChgDtm"			, row.getLstDbChgDtm());

					xlsList.add(rowMap);
				} 
				xlsLists.add(xlsList);
			}
		}
		
		if("CSPD004TF".equals(tableId)) {
			xlsListsTitle.add(new String[] { "심사마스터일련번호" , "심사태스크ID" , "심사SANCTION번호" , "항목심사불일치여부" , "항목심사보정여부" , "심사SANCTION데이터내용" , "보정전AICR추출내용" ,
											"보정후AICR추출내용" , "보정전텍스트분석추출내용", "보정후텍스트분석추출내용"  , "항목심사수기입력데이터내용" , "SAFEWATCH항목여부" , "항목심사X축시작좌표수"  , "항목심사Y축시작좌표수"  ,
											"항목심사X축종료좌표수"  , "항목심사Y축종료좌표수" , "AI심사ALERT여부" , "AI심사SANCTION규칙내용" , "AI심사단어일치율" , "AI심사추출문구내용" , "거래로그일련번호" , "최종DB변경ID" , "최종DB변경일시" });
			if(list!=null) {
				List<LinkedHashMap<String,String>> xlsList = XlsUtil.createList();
				for(int i=0;i<list.size();i++) {
					LinkedHashMap<String,String> rowMap = new LinkedHashMap<String,String>();
					// RevertStatCompleteVO row = (RevertStatCompleteVO)list.get(i);
					AdminStatusTablesVO row = list.get(i);

					rowMap.put("inptMstSrno"			, row.getInptMstSrno());
					rowMap.put("inptTaskId"				, row.getInptTaskId());
					rowMap.put("inptSanctionNo"			, row.getInptSanctionNo());
					rowMap.put("itmInptNacrdYn"			, row.getItmInptNacrdYn());
					rowMap.put("itmInptRvsnYn"			, row.getItmInptRvsnYn());
					rowMap.put("inptSanctionDatTxt"		, row.getInptSanctionDatTxt());
					rowMap.put("bfrsAicrExtcTxt"		, row.getBfrsAicrExtcTxt());
					rowMap.put("afrsAicrExtcTxt"		, row.getAfrsAicrExtcTxt());
					rowMap.put("bfrsTaExtcTxt"			, row.getBfrsTaExtcTxt());
					rowMap.put("afrsTaExtcTxt"			, row.getAfrsTaExtcTxt());
					rowMap.put("itmInptHndgInpDatTxt"	, row.getItmInptHndgInpDatTxt());
					rowMap.put("safewatchItmYn"			, row.getSafewatchItmYn());
					rowMap.put("itmInptXaxisStaCrdnCn"	, row.getItmInptXaxisStaCrdnCn());
					rowMap.put("itmInptYaxisStaCrdnCn"	, row.getItmInptYaxisStaCrdnCn());
					rowMap.put("itmInptXaxisEndCrdnCn"	, row.getItmInptXaxisEndCrdnCn());
					rowMap.put("itmInptYaxisEndCrdnCn"	, row.getItmInptYaxisEndCrdnCn());
					rowMap.put("aiInptAltYn"			, row.getAiInptAltYn());
					rowMap.put("aiInptSanctionRuleTxt"	, row.getAiInptSanctionRuleTxt());
					rowMap.put("aiInptWordAcrdRt"		, row.getAiInptWordAcrdRt());
					rowMap.put("aiInptExtcSntnTxt"		, row.getAiInptExtcSntnTxt());
					rowMap.put("trnLogSrno"				, row.getTrnLogSrno());
					rowMap.put("lstDbChgId"				, row.getLstDbChgId());
					rowMap.put("lstDbChgDtm"			, row.getLstDbChgDtm());
					xlsList.add(rowMap);
				} 
				xlsLists.add(xlsList);
			}
		}
		
		if("CSPD005TH".equals(tableId)) {
			xlsListsTitle.add(new String[] {"AI심사결재일련번호", "심사마스터일련번호", "AI심사업무구분코드", "담당자직원번호", "심사처리일시", "심사처리의견내용", "임시저장여부", "결재상태코드", "TOTALTEXT결과코드", 
					"항목심사결과코드", "품질보증처리상태코드", "거래로그일련번호", "최종DB변경ID", "최종DB변경일시"});
			if(list!=null) {
				List<LinkedHashMap<String,String>> xlsList = XlsUtil.createList();
				for(int i=0;i<list.size();i++) {
					LinkedHashMap<String,String> rowMap = new LinkedHashMap<String,String>();
					AdminStatusTablesVO row = list.get(i);
					rowMap.put("aiInptAppvSrno", row.getAiInptAppvSrno()); 		
					rowMap.put("inptMstSrno", row.getInptMstSrno());  		
					rowMap.put("aiInptBizDscd", row.getAiInptBizDscd());  	
					rowMap.put("aiInptCrpeEno", row.getAiInptCrpeEno());  		
					rowMap.put("aiInptPrcDtm", row.getAiInptPrcDtm());  	
					rowMap.put("aiInptPrcOpiTxt", row.getAiInptPrcOpiTxt());  	
					rowMap.put("aiInptTpySaveYn", row.getAiInptTpySaveYn()); 
					rowMap.put("aiInptAppvStcd", row.getAiInptAppvStcd());  	
					rowMap.put("aiInptTotaltextRstCd", row.getAiInptTotaltextRstCd()); 
					rowMap.put("aiInptItmRstCd", row.getAiInptItmRstCd()); 
					rowMap.put("aiInptQlasPrcStsCd"	, row.getAiInptQlasPrcStsCd()); 
					rowMap.put("trnLogSrno", row.getTrnLogSrno());  		
					rowMap.put("lstDbChgId", row.getLstDbChgId());  		
					rowMap.put("lstDbChgDtm", row.getLstDbChgDtm()); 	

					xlsList.add(rowMap);
				} 
				xlsLists.add(xlsList);
			}
		}
		
		if("CSPD007TL".equals(tableId)) {
			xlsListsTitle.add(new String[] {"AI심사진행일련번호", "심사선하증권그룹번호", "심사마스터일련번호", "필터링심사결과일련번호", "AI심사선하증권번호개수", "선하증권번호", "필터링DETECTION번호"
					, "필터링심사결과수신일시", "SAFEWATCHAI심사결과코드", "AI심사필터링내용", "필터링심사요청일시", "거래로그일련번호", "최종DB변경일시", "최종DB변경ID"});
			if(list!=null) {
				List<LinkedHashMap<String,String>> xlsList = XlsUtil.createList();
				for(int i=0;i<list.size();i++) {
					LinkedHashMap<String,String> rowMap = new LinkedHashMap<String,String>();
					// RevertStatCompleteVO row = (RevertStatCompleteVO)list.get(i);
					AdminStatusTablesVO row = list.get(i);
					rowMap.put("aiInptPrgSrno"        ,row.getAiInptPrgSrno()); 
					rowMap.put("inptBlGrpNo"          ,row.getInptBlGrpNo());  
					rowMap.put("inptMstSrno"          ,row.getInptMstSrno());  
					rowMap.put("filtInptRstSrno"      ,row.getFiltInptRstSrno());  
					rowMap.put("aiInptBlNoNcnt"       ,row.getAiInptBlNoNcnt());  
					rowMap.put("blNo"                 ,row.getBlNo());  
					rowMap.put("filtDtctNo"           ,row.getFiltDtctNo());  
					rowMap.put("filtInptRstRecpDtm"   ,row.getFiltInptRstRecpDtm());  
					rowMap.put("safewatchAiInptRstCd" ,row.getSafewatchAiInptRstCd()); 
					rowMap.put("aiInptFiltTxt"        ,row.getAiInptFiltTxt());  
					rowMap.put("filtInptReqDtm"       ,row.getFiltInptReqDtm()); 
					rowMap.put("trnLogSrno"           ,row.getTrnLogSrno());  
					rowMap.put("lstDbChgDtm"          ,row.getLstDbChgDtm());  
					rowMap.put("lstDbChgId"           ,row.getLstDbChgId());      

					xlsList.add(rowMap);
				} 
				xlsLists.add(xlsList);
			}
		}
		
		if("CSPD008TH".equals(tableId)) {
			xlsListsTitle.add(new String[] {"AI심사진행일련번호", "심사마스터일련번호", "AI심사업무구분코드", "AI심사활동코드"
					, "AI심사활동상태코드", "AI심사담당자직원번호", "AI심사프로세스시작일시"
					, "AI심사처리의견내용", "거래로그일련번호", "최종DB변경ID", "최종DB변경일시"});
			if(list!=null) {
				List<LinkedHashMap<String,String>> xlsList = XlsUtil.createList();
				for(int i=0;i<list.size();i++) {
					LinkedHashMap<String,String> rowMap = new LinkedHashMap<String,String>();
					// RevertStatCompleteVO row = (RevertStatCompleteVO)list.get(i);
					AdminStatusTablesVO row = list.get(i);
					rowMap.put("aiInptPrgSrno", row.getAiInptPrgSrno());   
					rowMap.put("inptMstSrno", row.getInptMstSrno());     
					rowMap.put("aiInptBizDscd", row.getAiInptBizDscd());   
					rowMap.put("aiInptAcvtCd", row.getAiInptAcvtCd());    
					rowMap.put("aiInptAcvtStsCd", row.getAiInptAcvtStsCd());
					rowMap.put("aiInptCrpeEno", row.getAiInptCrpeEno());   
					rowMap.put("aiInptProsStaDtm", row.getAiInptProsStaDtm());
					rowMap.put("aiInptPrcOpiTxt", row.getAiInptPrcOpiTxt()); 
					rowMap.put("trnLogSrno", row.getTrnLogSrno());      
					rowMap.put("lstDbChgId", row.getLstDbChgId());      
					rowMap.put("lstDbChgDtm", row.getLstDbChgDtm());     

					
					xlsList.add(rowMap);
				} 
				xlsLists.add(xlsList);
			}
		}
		
		if("CSPD900TM".equals(tableId)) {
			xlsListsTitle.add(new String[] {"심사마스터일련번호", "AI심사마스터상태내용", "AI심사서버정보내용", "AI심사처리구분코드"
												,"AI시스템심사진행상태코드", "재처리횟수", "거래로그일련번호", "최종DB변경ID", "최종DB변경일시"});
			if(list!=null) {
				List<LinkedHashMap<String,String>> xlsList = XlsUtil.createList();
				for(int i=0;i<list.size();i++) {
					LinkedHashMap<String,String> rowMap = new LinkedHashMap<String,String>();
					// RevertStatCompleteVO row = (RevertStatCompleteVO)list.get(i);
					AdminStatusTablesVO row = list.get(i);
					rowMap.put("inptMstSrno", row.getInptMstSrno()); 
					rowMap.put("aiInptMstStsTxt", row.getAiInptMstStsTxt());
					rowMap.put("aiInptSvrInfTxt", row.getAiInptSvrInfTxt()); 
					rowMap.put("aiInptPrcDscd", row.getAiInptPrcDscd()); 
					rowMap.put("aiSysInptPrgStcd", row.getAiSysInptPrgStcd()); 
					rowMap.put("rprocTcn", row.getRprocTcn()); 
					rowMap.put("trnLogSrno", row.getTrnLogSrno()); 
					rowMap.put("lstDbChgId", row.getLstDbChgId());
					rowMap.put("lstDbChgDtm", row.getLstDbChgDtm()); 

					xlsList.add(rowMap);
				} 
				xlsLists.add(xlsList);
			}
		}
		
		if("CSPD820TH".equals(tableId)) {
			xlsListsTitle.add(new String[] {"심사시스템모니터링일자", "심사시스템모니터링시각","심사시스템서버명","심사시스템성능데이터타입코드"
					,"심사시스템성능데이터명","심사시스템성능데이터내용","심사시스템성능데이터수준내용", "심사시스템모니터링정상수준내용"
					,"거래로그일련번호", "최종DB변경ID", "최종DB변경일시"});
			if(list!=null) {
				List<LinkedHashMap<String,String>> xlsList = XlsUtil.createList();
				for(int i=0;i<list.size();i++) {
					LinkedHashMap<String,String> rowMap = new LinkedHashMap<String,String>();
					// RevertStatCompleteVO row = (RevertStatCompleteVO)list.get(i);
					AdminStatusTablesVO row = list.get(i);
					rowMap.put("inptSysMntgDt" 			, row.getInptSysMntgDt()); 		
					rowMap.put("inptSysMntgTm"  		, row.getInptSysMntgTm());  		
					rowMap.put("inptSysSvrNm"  			, row.getInptSysSvrNm());  		
					rowMap.put("inptSysPfmDatTpcd"  	, row.getInptSysPfmDatTpcd());  		
					rowMap.put("inptSysPfmDatNm"  		, row.getInptSysPfmDatNm());  	
					rowMap.put("inptSysPfmDatTxt"  		, row.getInptSysPfmDatTxt());  	
					rowMap.put("inptSysPfmDatLvlTxt"	, row.getInptSysPfmDatLvlTxt()); 
					rowMap.put("inptSysMntgNmlLvlTxt"  	, row.getInptSysMntgNmlLvlTxt());  	
					rowMap.put("trnLogSrno"  			, row.getTrnLogSrno());  		
					rowMap.put("lstDbChgId"  			, row.getLstDbChgId());  		
					rowMap.put("lstDbChgDtm" 			, row.getLstDbChgDtm()); 	

					xlsList.add(rowMap);
				} 
				xlsLists.add(xlsList);
			}
		}
		
		String uploadPath = StringUtil.nvl(sysProp.getProperty("upload.path"));
		File xlsFile = XlsUtil.createXlsFile(uploadPath, xlsListsTitle, xlsLists);
		try {
			FileUtil.setFileDown(mv, xlsFile, xlsDownName);
		} catch (Exception e) {
			LOGGER.error("Exception ::: " + e);
		}
		
		return mv;
	}
	
}
