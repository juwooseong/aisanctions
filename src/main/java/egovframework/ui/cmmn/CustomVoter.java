package egovframework.ui.cmmn;

import java.util.Collection;
import java.util.HashMap;
import java.util.Map;

import org.json.simple.JSONArray;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.access.AccessDecisionVoter;
import org.springframework.security.access.ConfigAttribute;
import org.springframework.security.core.Authentication;
import org.springframework.security.web.FilterInvocation;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;

/**
 * @Outline 권한 체크
 * @Desction 인증된 사용자의 요청한 URL 권한 체크
 */
public class CustomVoter implements AccessDecisionVoter<Object> {

	private static final Logger LOGGER = LoggerFactory.getLogger(CustomVoter.class);
	
	/**
	 * 로그인 사용자가 아님
	 */
	private static final String ANONYMOUS_USER = "anonymousUser";

//	private static Logger logger = LoggerFactory.getLogger(CustomVoter.class);

	/**
	 * security-context : intercept-url 의 access 정보가 ROLE_USER 에 대해서만 체크 한다.
	 */
	public boolean supports(ConfigAttribute attribute) {
		if (attribute.getAttribute() != null && "ROLE_USER".equals(attribute.getAttribute())) {
			return true;
		}
		return false;
	}

	public boolean supports(Class<?> clazz) {
		
		LOGGER.debug(StringUtil.concat(new String[]{"CustomVoter.supports",clazz.toString()}));
		return true;
	}

	/**
	 * ROLE_USER 설정 URL 에 대해서만 권한 체크 이외에는 패스한다.
	 */
	public int vote(Authentication authentication, Object object, Collection<ConfigAttribute> attributes) {
		String userId = authentication.getName();
		
		FilterInvocation fi = null;
		String url = "";
		
		if (object instanceof FilterInvocation) {
			fi = (FilterInvocation)object;
		}
		
		if (fi != null) {
			
			url = fi.getRequestUrl();
		}
		
		
		LOGGER.debug(StringUtil.concat(new String[]{"CustomVoter.vote",attributes.toString()}));

		int result = ACCESS_DENIED;

		// String userId = authentication.getName();

		// 로그인 관련 URL PASS
		if ("/login".equals(url)) {
			return ACCESS_GRANTED;
		}

		if (ANONYMOUS_USER.equals(userId)) {
			// 비로그인 사용자 ACCESS 불허
			result = ACCESS_DENIED;
			
			// ROLE, GROUP 조회 (GET)는 허용
			// url
			// fi.getRequest().getMethod()
			if (fi != null) {
				
				if("GET".equals(fi.getRequest().getMethod())) {
					if("/core/api/role".equals(url) || "/core/api/group".equals(url)) {
						result = ACCESS_GRANTED;
					}
				}
			}
			
		} else if ("admin".equals(userId)) {
			// 슈퍼사용자 ACCESS 허가
			result = ACCESS_GRANTED;
		} else {
			// 모든 사용자 로그인 통과 시 권한 부여
			try {
				boolean isAuth = authCheck(userId, url, fi);
				if (isAuth) {
					result = ACCESS_GRANTED;
				}
			} catch (Exception e) {
				LOGGER.error("Exception ::: " + e);
				result = ACCESS_DENIED;
			}
		}
		
		try {
			writeLog(userId, url, fi);
		} catch (Exception e) {
			LOGGER.error("Exception ::: " + e);
		}

		return result;
	}

	private void writeLog(String userId, String url, FilterInvocation fi) {
		LOGGER.debug(StringUtil.concat(new String[]{"CustomVoter.writeLog",userId}));
		LOGGER.debug(StringUtil.concat(new String[]{"CustomVoter.writeLog",url}));
		LOGGER.debug(StringUtil.concat(new String[]{"CustomVoter.writeLog",fi.toString()}));
		
	}

	private boolean authCheck(String userId, String url, FilterInvocation fi) {
		LOGGER.debug(StringUtil.concat(new String[]{"CustomVoter.writeLog",userId}));
		LOGGER.debug(StringUtil.concat(new String[]{"CustomVoter.writeLog",url}));
		LOGGER.debug(StringUtil.concat(new String[]{"CustomVoter.writeLog",fi.toString()}));
		return false;
	}

	private String getWebLogString(String log_url, String log_action, String log_method, String user_id, String user_ip) throws JsonProcessingException {
		ObjectMapper om = new ObjectMapper();
		Map<String, Object> returnMap = new HashMap<String, Object>();
		Map<String, Object> dataMap = new HashMap<String, Object>();
		Map<String, String> attributes = new HashMap<String, String>();
		attributes.put("log_url", log_url);
		attributes.put("log_action", log_action);
		attributes.put("user_id", user_id);
		attributes.put("log_method", log_method);
		attributes.put("user_ip", user_ip);
		dataMap.put("attributes", attributes);
		dataMap.put("type", "web_log");
		returnMap.put("data", dataMap);
		
		//Object to JSON in String
		String jsonInString = om.writeValueAsString(returnMap);
		return jsonInString;
	}
}
