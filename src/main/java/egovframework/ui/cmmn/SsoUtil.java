package egovframework.ui.cmmn;

import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;

import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * sso 유틸 관련 메서드
 */
public class SsoUtil {
	private static final Logger LOGGER = LoggerFactory.getLogger(FileBinUtil.class);
	/**
	 * 암호화된 json 비표준 인증정보 문자열 반환.
	 * @param request	: 파라미터 추출할 요청객체.
	 * 
	 * request.getParameter("FINDATA") : 암호화된 사용자 정보 - JSON 형태 
	 * {"ENT_CODE":"회사코드","USER_ID":"사번","REAL_UNIT_CODE":"점코드","UNIT_CODE":"부서코드"}
	 * 
	 * @return			: 추출한 암호화된 json 비표준 인증정보 문자열.
	 */
	public static String getParamJsonEncVal(HttpServletRequest request) {
		String result = null;
		
		result = request.getParameter("FINDATA");
		
		return result;
	}

	/**
	 * 암호화된 json 비표준 인증정보 문자열을 복호화한 문자열 반환.
	 * 
	 * request.getParameter("FINDATA") : 암호화된 사용자 정보 - JSON 형태 
	 * {"ENT_CODE":"회사코드","USER_ID":"사번","REAL_UNIT_CODE":"점코드","UNIT_CODE":"부서코드"}
	 * 
	 * @param request	: 파라미터 추출할 요청객체.
	 * @return			: 추출한 암호화된 json 비표준 인증정보 문자열을 복호화한 json 문자열.
	 */
	public static String getParamJsonDecVal(HttpServletRequest request) {
		String result = null;
		
		//암호화된 json 비표준 인증정보 문자열
		String jsonEnc = getParamJsonEncVal(request);
		if(jsonEnc!=null) {
			try {
				result = Encryptor.decryptAES(jsonEnc);	
			}catch(Exception e) {
				result = null;
			}
		}
		
		return result;
	}
	
	/**
	 * 암호화된 json 비표준 인증정보 맵 반환.
	 * @param request	: 파라미터 추출할 요청객체.
	 * 
	 * (암호화된 사용자 정보맵)
	 * map.get("USER_ID")			: 사번
	 * map.get("ENT_CODE")			: 회사코드
	 * map.get("REAL_UNIT_CODE")	: 점코드
	 * map.get("UNIT_CODE")			: 부서코드
	 * 
	 * @return			: 추출한 암호화된 json 비표준 인증정보 맵.
	 */
	public static HashMap<String,String> getParamMap(HttpServletRequest request) {
		HashMap<String,String> result = null;
		String jsonStr = getParamJsonDecVal(request);
		
		if(jsonStr!=null && !jsonStr.trim().equals("")) {
			result = new HashMap<String,String>();
			
			JSONParser jsonParser = new JSONParser();
			JSONObject jsonOb = null;
			
			String USER_ID = "";
			String ENT_CODE = "";
			String UNIT_CODE = "";
			String REAL_UNIT_CODE = "";
					
			try {
				
				if (jsonParser.parse(jsonStr) instanceof JSONObject) {
					jsonOb = (JSONObject)jsonParser.parse(jsonStr);
				}
				
				if (jsonOb != null) {
					
					USER_ID = CastUtil.objToStr(jsonOb.get("USER_ID"));
					ENT_CODE = CastUtil.objToStr(jsonOb.get("ENT_CODE")); // 회사코드
					UNIT_CODE = CastUtil.objToStr(jsonOb.get("UNIT_CODE")); //부서 코드
					REAL_UNIT_CODE = CastUtil.objToStr(jsonOb.get("REAL_UNIT_CODE")); //점코드
				}
				
				
				result.put("USER_ID", USER_ID);
				result.put("ENT_CODE", ENT_CODE);
				result.put("UNIT_CODE", UNIT_CODE);
				result.put("REAL_UNIT_CODE", REAL_UNIT_CODE);
			} catch (ParseException e) {
				LOGGER.error("Exception ::: " + e);
			} 
		}

		return result;
	}

	/**
	 * 사용자 인증 정보를(로그인할 사용자 번호), 프록시 방식으로 읽어오고,
	 * 프록시 서버가 장애 발생시, 비표준 방식으로 사용자 인증 정보를 읽어옴.
	 * 반환값 : 사용자 번호 (로그인 하고자 하는)
	 */
	public static String getParamUserId(HttpServletRequest request) {
		String result = null;
		
		//일반 파라미터 방식으로 사용자 번호 받기 (proxy방식 용) - proxy 2단계
		result = StringUtil.nvl(request.getParameter("USER_ID")).trim();

		//프록시 방식으로 사용자 인증 정보를 받아옴 - proxy 1단계
		if (result == null || "".equals(result)) {
			result = StringUtil.nvl(request.getHeader("USER_ID")).trim();
			if (result == null || "".equals(result)) {
				result = StringUtil.nvl(request.getHeader("user_id")).trim();
			}
			
			//복호화 처리, 필요시 주석 해제처리.
			if(StringUtil.isNotEmpty(result)) {
				try {
					result = Encryptor.decryptAES(result);
				} catch(Exception e) {
					LOGGER.error("Exception ::: " + e);
				}
			}
		}
		
		//프록시 방식이 장애시
		if(StringUtil.isEmpty(result)) {
			//비표준 방식으로 사용자 인증 정보를 가져옴.
			HashMap<String,String> paramMap = getParamMap(request);
			if(paramMap!=null) {
				result = paramMap.get("USER_ID");
			}
		}

		return result;
	}
	
}