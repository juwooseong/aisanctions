package egovframework.ui.cmmn;

import javax.naming.AuthenticationException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.view.json.MappingJackson2JsonView;

/**
 * @Outline E2E ExceptionHandler
 * @Desction E2E Global Exception 처리 코드
 */
@ControllerAdvice
public class CommonExceptionHandler {
	private static Logger logger = LoggerFactory.getLogger(CommonExceptionHandler.class);

	public static final String ERROR_MSG = "시스템 오류가 발생하였습니다. 잠시후 다시 시도해 주세요.";
	
	@ExceptionHandler(value = AuthenticationException.class)
	public ModelAndView authenticationException(HttpServletRequest request, HttpServletResponse response, Exception ex) {
		logger.error("Exception ::: " + ex);
		logger.error("AuthException X-Requested-With: {}, 오류:{}", request.getHeader("X-Requested-With"), ex);
		// JSON 처리
		if ("XMLHttpRequest".equals(request.getHeader("X-Requested-With"))) {
			response.setStatus(HttpStatus.FORBIDDEN.value());
			ModelAndView mav = new ModelAndView(new MappingJackson2JsonView());
			mav.addObject("error", true);
			mav.addObject("msg", ERROR_MSG);
			return mav;
		} else {
			return new ModelAndView("redirect:/error/403");
		}
	}

	@ExceptionHandler(value = Exception.class)
	public ModelAndView bizException(HttpServletRequest request, HttpServletResponse response, Exception ex) {
		
		logger.error("Exception ::: " + ex);
		logger.error("BizException X-Requested-With: {}, 오류:{}", request.getHeader("X-Requested-With"), ex);
		// JSON 처리
		if ("XMLHttpRequest".equals(request.getHeader("X-Requested-With"))) {
			response.setStatus(HttpStatus.INTERNAL_SERVER_ERROR.value());
			ModelAndView mav = new ModelAndView(new MappingJackson2JsonView());
			mav.addObject("error", true);
			mav.addObject("msg", ERROR_MSG);
			return mav;
		} else {
			return new ModelAndView("redirect:/error/500");
		}
	}
}
