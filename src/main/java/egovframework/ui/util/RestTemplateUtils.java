package egovframework.ui.util;

import java.net.URI;
import java.net.URL;
import java.nio.charset.Charset;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.http.client.ClientHttpRequestFactory;
import org.springframework.http.client.HttpComponentsAsyncClientHttpRequestFactory;
import org.springframework.http.client.HttpComponentsClientHttpRequestFactory;
import org.springframework.stereotype.Component;
import org.springframework.util.concurrent.FailureCallback;
import org.springframework.util.concurrent.ListenableFuture;
import org.springframework.util.concurrent.SuccessCallback;
import org.springframework.web.client.AsyncRestTemplate;
import org.springframework.web.client.RestTemplate;

import egovframework.ui.cmmn.CastUtil;
import egovframework.ui.cmmn.WebConstant;

@Component
public class RestTemplateUtils {
	private static Logger logger = LoggerFactory.getLogger(RestTemplateUtils.class);
	
	public String get(String urlstring) throws Exception {
		return get(urlstring, null);
	}
	
	public String get(String urlstring, String token) throws Exception {
		return get(null, urlstring, token);
	}
	
	public void asyncGet(HttpServletRequest req, String urlstring, String token) throws Exception {
		AsyncRestTemplate asyncRestTemplate = new AsyncRestTemplate(new HttpComponentsAsyncClientHttpRequestFactory());
		
		HttpHeaders headers = new HttpHeaders();
		headers.setContentType(new MediaType("application", "json", Charset.forName("UTF-8")));
		if(StringUtils.isNotEmpty(token)) {
			headers.set( WebConstant.Authorization, token);
		}
		
		if(req != null) {
			Object env = req.getSession().getAttribute(WebConstant.ENV);
			if(env != null) {
				 
				headers.set( WebConstant.SYSTEM_ENV, CastUtil.objToStr(env));
			}
		}
		
		URL tmpUrl = new URL(urlstring);
		URI uri = tmpUrl.toURI();
		HttpEntity<Object> entity = new HttpEntity<Object>(headers);
		ListenableFuture<ResponseEntity<String>> out = asyncRestTemplate.exchange(uri, HttpMethod.GET, entity, String.class);
		out.addCallback(new SuccessCallback<ResponseEntity<String>>() {
			@Override
			public void onSuccess(ResponseEntity<String> result) {
				logger.info("ListenableFuture onSuccess : {}", result.getStatusCode());
			}
		}, new FailureCallback() {
			@Override
			public void onFailure(Throwable ex) {
				logger.warn("ListenableFuture FailureCallback : {}", ex.getMessage());
			}
		});
	}

	public String get(HttpServletRequest req, String urlstring, String token) throws Exception {
		String responseString = "";
		RestTemplate restTemplate = new RestTemplate();
		
		HttpHeaders headers = new HttpHeaders();
		headers.setContentType(new MediaType("application", "json", Charset.forName("UTF-8")));
		if(StringUtils.isNotEmpty(token)) {
			headers.set( WebConstant.Authorization, token);
		}
		
		if(req != null) {
			Object env = req.getSession().getAttribute(WebConstant.ENV);
			if(env != null) {
				headers.set( WebConstant.SYSTEM_ENV, CastUtil.objToStr(env));
			}
		}
		
		URL tmpUrl = new URL(urlstring);
		URI uri = tmpUrl.toURI();
		HttpEntity<Object> entity = new HttpEntity<Object>(headers);
		ResponseEntity<String> out = restTemplate.exchange(uri, HttpMethod.GET, entity, String.class);
		
		responseString = out.getBody();
		return responseString;
	}
	
	/**
	 * GET 방식 이외의 method 호출 방식
	 * @return
	 * @throws Exception 
	 */
	public String apiCall(HttpMethod method, String contentType, String urlstring, String body) throws Exception {
		return apiCall(null, method, contentType, urlstring, body, null); 
	}
	
	/**
	 * GET 방식 이외의 method 호출 방식
	 * @return
	 * @throws Exception 
	 */
	public String apiCall(HttpServletRequest request, HttpMethod method, String contentType, String urlstring, String body, String token) throws Exception {
		RestTemplate restTemplate = null; 
		HttpHeaders headers = new HttpHeaders();
		headers.setContentType(MediaType.valueOf(contentType));
		if(StringUtils.isNotEmpty(token)) {
			headers.set( WebConstant.Authorization, token);
		}
		
		if(request != null) {
			Object env = request.getSession().getAttribute(WebConstant.ENV);
			if(env != null) {
				headers.set( WebConstant.SYSTEM_ENV, CastUtil.objToStr(env));
			}
		}

		if(HttpMethod.PATCH.equals(method)) {
			ClientHttpRequestFactory httpRequestFactory = new HttpComponentsClientHttpRequestFactory();
			restTemplate = new RestTemplate(httpRequestFactory);
		}else {
			restTemplate = new RestTemplate();
		}
		
		URL tmpUrl = new URL(urlstring);
		URI uri = tmpUrl.toURI();
		HttpEntity<String> entity = new HttpEntity<String>(body, headers);
		ResponseEntity<String> responseEntity = restTemplate.exchange(uri, method, entity, String.class);
		return responseEntity.getBody();

	}
	
	/**
	 * GET 방식 이외의 method 호출 방식
	 * @return
	 * @throws Exception 
	 */
	public String apiCall(HttpServletRequest request, String urlstring, String body, String token) throws Exception {
		HttpMethod method = HttpMethod.valueOf(request.getMethod()); 
		String contentType = request.getContentType();
		return apiCall(request, method, contentType, urlstring, body, token);
	}
}



