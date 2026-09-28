package egovframework.ui.cmmn.web;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import egovframework.ui.cmmn.PropUtil;

@Controller
public class ErrorController {

	@RequestMapping(value = { "/error/{type}" })
	public ModelAndView mainSub(@PathVariable String type, ModelAndView model) {
		model.setViewName("full/error/" + type);
		model.addObject("portal_login", PropUtil.PORTAL_LOGIN);
		model.addObject("domain", PropUtil.DOMAIN);
		return model;
	}

}