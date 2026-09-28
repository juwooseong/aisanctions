package egovframework.ui.cmmn;

import java.util.HashMap;

import org.json.simple.JSONObject;

public class HttpUtil {
	
	/**
	 * T200 : Success
	 * T400 : Bad Request
	 * T401 : Unauthorized
	 * T403 : Forbidden
	 * T404 : Not Found
	 * T500 : Internal Server Error
	 */
	public enum HttpType {
		/**
		 * Success
		 */
		T200,
		/**
		 * Bad Request
		 */
		T400,
		/**
		 * Unauthorized
		 */
		T401,
		/**
		 * Forbidden
		 */
		T403,
		/**
		 * Not Found
		 */
		T404,
		/**
		 * Internal Server Error
		 */
		T500
	}
	
	/**
	 * (http요청 결과코드)
	 * 200 : 정상 
	 * 401 : 인증안됨 
	 * 403 : 제공되지 않는 데이터
	 * 404 : 페이지를 찾지 못함
	 * 500 : 요청처리시 발생한 오류
	 * 301 : url 변경됨
	 * @param map
	 * @param htp		: HttpUtil.HttpType.T200
	 * 
	 * HttpUtil.setResult(result, HttpUtil.HttpType.T200);
	 */
	public static void setResult(HashMap<String,Object> map, HttpType htp) {
		if(HttpType.T200==htp) {
			map.put("resultCode", "200");
			map.put("resultMsg", "Success");
		} else if(HttpType.T400==htp) {
			map.put("resultCode", "400");
			map.put("resultMsg", "Bad Request");
		} else if(HttpType.T401==htp) {
			map.put("resultCode", "401");
			map.put("resultMsg", "Unauthorized");
		} else if(HttpType.T403==htp) {
			map.put("resultCode", "403");
			map.put("resultMsg", "Forbidden");
		} else if(HttpType.T404==htp) {
			map.put("resultCode", "404");
			map.put("resultMsg", "Bad Request");
		} else if(HttpType.T500==htp) {
			map.put("resultCode", "500");
			map.put("resultMsg", "Internal Server Error");
		}
	}
	
	public static void setResultCode(HashMap<String,Object> map, HttpType htp) {
		map.put("resultCode", htp);
	}
	
	public static void setResultMsg(HashMap<String,Object> map, String msg) {
		map.put("resultMsg", msg);
	}
	
	/**
	 * 추가적인 처리결과 코드와 메시지를 설정
	 * @param map			: 값을 설정할 맵
	 * @param exCode		: 추가코드
	 * @param exMsg			: 추가메시지
	 */
	public static void setExResult(HashMap<String,Object> map, String exCode, String exMsg) {
		map.put("resultExCode", exCode);
		map.put("resultExMsg", exMsg);
	}
	
	/**
	 * 추가적인 처리결과 코드 설정
	 * @param map			: 값을 설정할 맵
	 * @param exCode		: 추가코드
	 */
	public static void setExCode(HashMap<String,Object> map, String exCode) {
		map.put("resultExCode", exCode);
	}

	/**
	 * 추가적인 처리결과 메시지를 설정
	 * @param map			: 값을 설정할 맵
	 * @param exMsg			: 추가메시지
	 */
	public static void setExMsg(HashMap<String,Object> map, String exMsg) {
		map.put("resultExMsg", exMsg);
	}
	
}