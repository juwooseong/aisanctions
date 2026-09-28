package egovframework.ui.listener;

import java.util.Collections;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpSession;
import javax.servlet.http.HttpSessionAttributeListener;
import javax.servlet.http.HttpSessionBindingEvent;
import javax.servlet.http.HttpSessionEvent;
import javax.servlet.http.HttpSessionListener;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.woori.ajs.model.LoginVO;

public class CustomHttpSessionListener implements HttpSessionListener, HttpSessionAttributeListener {

	private static final Logger LOGGER = LoggerFactory.getLogger(CustomHttpSessionListener.class);

	public static boolean isAlreadyLogedIn(String userId, String sessionId) {
		Map<String, HttpSession> map = Collections.synchronizedMap(new HashMap<>());
		HttpSession session = map.get(userId);

		if (session != null && !session.getId().equals(sessionId)) {
			return true;
		}

		return false;
	}

	public static HttpSession getSession(String userId) {
		Map<String, HttpSession> map = Collections.synchronizedMap(new HashMap<>());
		return map.get(userId);
	}

	public static HttpSession setSession(String userId, HttpSession sessionId) {
		Map<String, HttpSession> map = Collections.synchronizedMap(new HashMap<>());
		return map.put(userId, sessionId);
	}

	@Override
	public void attributeAdded(HttpSessionBindingEvent se) {
		Map<String, HttpSession> map = Collections.synchronizedMap(new HashMap<>());
		HttpSession session = se.getSession();

		try {
			LoginVO loginVo = null;
			if (session.getAttribute("loginUserInfo") instanceof LoginVO) {
				loginVo = (LoginVO) session.getAttribute("loginUserInfo");
			}
			
			if (loginVo != null) {
				
				map.put(loginVo.getId(), session);
			}
			
			
		} catch (Exception ex) {
			LOGGER.error("CustomHttpSessionListener Exception::: " + ex);
		}

	}

	@Override
	public void attributeRemoved(HttpSessionBindingEvent arg0) {
		LOGGER.error("HttpSessionBindingEventn::: " + arg0);

	}

	@Override
	public void attributeReplaced(HttpSessionBindingEvent arg0) {
		LOGGER.error("attributeReplaced::: " + arg0);

	}

	@Override
	public void sessionCreated(HttpSessionEvent arg0) {
		LOGGER.error("sessionCreated::: " + arg0);

	}

	@Override
	public void sessionDestroyed(HttpSessionEvent se) {
		Map<String, HttpSession> map = Collections.synchronizedMap(new HashMap<>());
		HttpSession session = se.getSession();

		try {
			LoginVO loginVo = null;
			if (session.getAttribute("loginUserInfo") instanceof LoginVO) {
				loginVo = (LoginVO) session.getAttribute("loginUserInfo");
			}
			
			if (loginVo != null) {
				map.remove(loginVo.getId());
				LOGGER.error("sessionDestroyed ::: " + loginVo.getId());
			}
			
		} catch (Exception ex) {
			LOGGER.error("sessionDestroyed ::: " + ex);
		}
	}

}
