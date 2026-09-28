package egovframework.ui.cmmn;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

/**
 * @Outline Session 관리 UTIL
 * @Desction Session 관리 UTIL
 */
public class SessionUtil {

	private static Logger logger = LoggerFactory.getLogger(SessionUtil.class);

	/**
	 * Session에서 name의 Attribute 값을 리턴
	 * 
	 * @param name
	 * @return
	 */
	public static Object getAttribute(String name) {
		
		ServletRequestAttributes attr = null;
		HttpSession session = null;
		Object sessionName = new Object();
		
		if (RequestContextHolder.currentRequestAttributes() instanceof ServletRequestAttributes) {
			attr = (ServletRequestAttributes)RequestContextHolder.currentRequestAttributes();
		}
		
		if (attr != null) {

			session = attr.getRequest().getSession();
			
		}
		
		if (session != null) {
			
			sessionName = session.getAttribute(name);
			
		}
		
		return sessionName;
	}

	/**
	 * Session에서 name으로 object를 저장
	 * 
	 * @param name
	 * @param object
	 */
	public static void setAttributes(String name, Object object) {
		logger.debug("setAttributes({}, {})", name, object);
		
		ServletRequestAttributes attr = null;
		HttpSession session = null;
		
		if (RequestContextHolder.currentRequestAttributes() instanceof ServletRequestAttributes) {
			attr = (ServletRequestAttributes)RequestContextHolder.currentRequestAttributes();
		}
		
		if (attr != null) {
			
			session = attr.getRequest().getSession();
		}
		if (session != null) {
			
			session.getAttribute(name);
			
		}
	}

	/**
	 * Session에서 name의 Attribute 삭제
	 * 
	 * @param name
	 */
	public static void removeAttribute(String name) {
		logger.debug("removeAttribute({})", name);
		
		ServletRequestAttributes attr = null;
		HttpSession session = null;
		
		if (RequestContextHolder.currentRequestAttributes() instanceof ServletRequestAttributes) {
			attr = (ServletRequestAttributes)RequestContextHolder.currentRequestAttributes();
		}
		
		if (attr != null) {

			session = attr.getRequest().getSession();
			
		}
		if (session != null) {
			
			session.getAttribute(name);
			
		}
	}
	
	/**
	 * 기존 세션 ID 무효화
	 * 
	 * @param request
	 */
	public static void invalidate(HttpServletRequest request) {
		HttpSession session = request.getSession(false);
		if(session != null) {
			logger.debug("invalidate(): sessionId[{}]", session.getId());
			session.invalidate();
		}
	}
}
