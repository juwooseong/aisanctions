package egovframework.ui.cmmn;

import java.io.IOException;
import java.nio.file.AccessDeniedException;

import javax.security.sasl.AuthenticationException;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.simple.JSONArray;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.woori.ajs.service.impl.AppTodoServiceImpl;

/**
 * @Outline [Security] Ajax Session Timeout Filter
 * @Desction Ajax 요청시 인증/권한에 대한 유효성 체크 후 반환
 */
public class AjaxSessionTimeoutFilter implements Filter {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(AjaxSessionTimeoutFilter.class);
	
	@Override
	public void doFilter(ServletRequest request, ServletResponse response,
			FilterChain chain) throws IOException, ServletException {
		HttpServletRequest req = null;
		if (request instanceof HttpServletRequest) {
			req = (HttpServletRequest)request;
		}
		HttpServletResponse res = null;
		if (response instanceof HttpServletResponse) {
			res = (HttpServletResponse)response;
		}

		if (isAjaxRequest(req)) {
			try {
				chain.doFilter(req, res);
			} catch (AccessDeniedException e) {
				res.sendError(HttpServletResponse.SC_FORBIDDEN);
			} catch (AuthenticationException e) {
				res.sendError(HttpServletResponse.SC_UNAUTHORIZED);
			}
		} else {
			chain.doFilter(req, res);
		}
	}

	private boolean isAjaxRequest(HttpServletRequest req) {
		return "XMLHttpRequest".equals(req.getHeader("X-Requested-With"));
	}

	@Override
	public void destroy() {
		LOGGER.debug("AjaxSessionTimeoutFilter.destroy");
	}

	@Override
	public void init(FilterConfig arg0) throws ServletException {
		LOGGER.debug(StringUtil.concat(new String[]{"AjaxSessionTimeoutFilter.init",arg0.toString()}));
	}
}
