package egovframework.ui.cmmn;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.util.HashMap;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.woori.ajs.model.FileApiVO;

/**
 * Http Url 호출 모듈
 */
public class HttpCallUtil {
	private static final Logger LOGGER = LoggerFactory.getLogger(HttpCallUtil.class);
	
	/**
	 * http 요청을 해서, 결과값을 반환
	 * @return	: http url 요청 결과값.
	 * @throws IOException 
	 * @sample
	 * HashMap<String,Object> param = new HashMap<String,Object>();
	 * param.put("strKey","val");	//문자열
	 * param.put("arrKey",new String[]{"val","val2",...});	//문자열배열
	 * HttpCallUtil.callPostUrl("http://localhost:8080/api/common/login", param);
	 */
	public static String callPostUrl(String sendUrl, HashMap<String,Object> params) throws IOException {
		StringBuffer outResult = new StringBuffer();
		HttpURLConnection conn = null;
		OutputStream os = null;
		BufferedReader in = null;
		String inputLine = null;
		
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
				conn.setConnectTimeout(10000);
				
				// COMMON Agent 서버에서 ImputStream 읽어오는 TimeOut 시간 설정
				conn.setReadTimeout(10000);
				
				// 파라미터 셋팅 (name=value&name=value2&...)
				String param = getJsonParam(params);
				
				// 파라미터를 logger 출력 시 1MB 이상 파일부터 속도저하 발생
				LOGGER.debug("HttpCallUtil.callPostUrl parameter encoded :::");
				
				
				os = conn.getOutputStream();
				os.write(param.getBytes("UTF-8"));
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
			//e.printStackTrace();
			LOGGER.debug(e.toString());
			
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
			
			LOGGER.debug("callPostUrl");
			
		}
		
		return outResult.toString();
	}
	
	/**
	 * 맵에 담긴 항목들을 json 배열 문자열로 변환처리. [{'file':'파일내용','key':'파일키문자열'},{'키':'값'},{'키',['값1','값2',...]}]
	 * @param params		: 파라미터 키,값 (값 : 문자열, 문자열배열, FileApiVO객체)
	 * @return				: json 변환 문자열
	 */
	@SuppressWarnings("unchecked")
	public static String getJsonParams(HashMap<String,Object> params) {
		JSONArray json = new JSONArray();
		
		for (String key : params.keySet()) {
			JSONObject jo = new JSONObject();
			Object val = params.get(key);
			String sval = null;
			if(val instanceof FileApiVO) {
				FileApiVO fvo = (FileApiVO)val;
				if(fvo!=null) {
					jo.put("key", fvo.getKey());
					jo.put("file", fvo.getFile());
					sval = jo.toJSONString();
				}
			} else if(val instanceof FileApiVO[]) {
				FileApiVO[] fvos = (FileApiVO[])val;
				if(fvos!=null && fvos.length > 0) {
					for(int i=0;i<fvos.length;i++) {
						JSONObject jo2 = new JSONObject();
						FileApiVO fvo = fvos[i];
						jo.put("key", fvo.getKey());
						jo.put("file", fvo.getFile());
						json.add(jo2);
					}
				}
				continue;
			} else if(val instanceof String[]) {
				sval = JSONArray.toJSONString(ArrayUtil.arrayToList((String[])val));
				jo.put(key, sval);
			} else {
				sval = CastUtil.objToStr(val);
				jo.put(key, sval);
			}
			json.add(jo);
		}
		
		return json.toJSONString();
	}

	/**
	 * 맵에 담긴 항목들을 json 항목 문자열로 변환처리. {'key':'val','arrKey':['val1','val2']}
	 * @param params		: 파라미터 키,값 (값 : 문자열, 문자열배열)
	 * @return				: json 변환 문자열
	 */
	@SuppressWarnings("unchecked")
	public static String getJsonParam(HashMap<String,Object> params) {
		JSONObject json = new JSONObject();
		
		for (String key : params.keySet()) {
			Object val = params.get(key);
			String sval = null;
			if(val instanceof String[]) {
				sval = JSONArray.toJSONString(ArrayUtil.arrayToList((String[])val));
				json.put(key, sval);
			} else {
				sval = CastUtil.objToStr(val);
				json.put(key, sval);
			}
		}
		
		return json.toJSONString();
	}
	
}