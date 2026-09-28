package egovframework.ui.cmmn;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

public class CastUtil {
	
	/**
	 * Object 타입 변수를 문자열로 캐스팅
	 * 
	 * String cont = (String)obj.get("cont");
	 * ==> String cont = CastUtil.objToStr(obj.get("cont"));
	 */
	public static String objToStr(Object object) {
		String st = null;
		if (object instanceof String) {
		    st = (String)object;
		}
		return st;
	}
	
	/**
	 * jsonStr 타입 변수를 JSONArray로 캐스팅
	 * 
	 * JSONArray list = (JSONArray)jps.parse(jsonStr);
	 * ==> JSONArray list = CastUtil.objToJSONArr(jps.parse(jsonStr));
	 */
	public static JSONArray objToJSONArr(Object jsonStr) {
		JSONArray list = null;
		if (jsonStr instanceof JSONArray) {
			list = (JSONArray)jsonStr;
		}
		return list;
	}
	
	/**
	 * Object 타입 변수를 JSONObject로 캐스팅
	 * 
	 * JSONObject obj = (JSONObject)object;
	 * ==> JSONObject obj = CastUtil.objToJSONObj(object);
	 */
	public static JSONObject objToJSONObj(Object object) {
		JSONObject obj = null;
		if (object instanceof JSONObject) {
			obj = (JSONObject)object;
		}
		return obj;
	}
	
	public static double intToDbl(int val) {
		return Double.valueOf(String.valueOf(val));
	}

	@SuppressWarnings("rawtypes")
	public static List<Map<String, String>> jsonArrToListMap(JSONArray jsonListTmp) {
		List<Map<String, String>> jsonList = null;
		
		if(jsonListTmp!=null && jsonListTmp.size() > 0) {
			jsonList = new ArrayList<Map<String, String>>();
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
		
		return jsonList;
	}
	
	public static byte intToByte(int val) {
		return Byte.valueOf(String.valueOf(val));
		//return Double.valueOf(String.valueOf(val));
	}
	
	
	/**
	 * 한글 byte 길이로 자르기
	 * 
	 */
	public static String cutString(String str, int len) {

		byte[] by = str.getBytes();
		int count = 0;
		
		try {
			for (int i = 0; i < len; i ++) {
				if ((by[i] & 0x80) == 0x80) {
					count ++;
				}
			}
			
			if ((by[len - 1] & 0x80) == 0x80 && (count % 2) == 1) {
				len --;
			}
			
			return new String( by, 0, len);
		} catch (Exception e) {
			return "";
		}
	}
	
}