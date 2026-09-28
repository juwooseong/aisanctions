package com.woori.ajs.controller;

import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.woori.ajs.model.CommonCodeVO;
import com.woori.ajs.model.SearchVO;
import com.woori.ajs.service.CommonCodeService;

import egovframework.ui.cmmn.CodeUtil;
import egovframework.ui.cmmn.StringUtil;

@Controller
public class TaskLogEndController {
	
	/** 공통 서비스 **/
	@Resource(name = "commonCodeService")
	private CommonCodeService commonCodeService;

	@RequestMapping(value = "/task/log/end")
	public ModelAndView detail(ModelAndView mv) throws Exception {
		mv.setViewName("blank/task/log/end/list");
		
		SearchVO vo = new SearchVO();
		
		//컨트롤러에서 코드 가져오기.
		//공통그룹코드 set(심사자동화업무구분)
		vo.setAiInptGrpCd("320");
		List<CommonCodeVO> taskEndGbnCd = commonCodeService.selectAllCommonCodeList(vo);
		mv.addObject("taskEndGbnCd", taskEndGbnCd);
		
		//컨트롤러에서 코드 가져오기.
		//공통그룹코드 set(심사자동화업무구분)
		vo.setAiInptGrpCd("321");
		List<CommonCodeVO> taskEndItmCd = commonCodeService.selectAllCommonCodeList(vo);
		List<CommonCodeVO> taskEndItmCdSort = new ArrayList<CommonCodeVO>();	//정렬순서 조정
		if(taskEndItmCd!=null && taskEndItmCd.size() > 0) {

			for(int i=0;i<taskEndItmCd.size();i++) {
				CommonCodeVO row = taskEndItmCd.get(i);
				
				if(StringUtil.isEquals(row.getAiInptCmnCd(), "13")) {
					continue;
				}
				
				taskEndItmCdSort.add(row);
				if(i==5) {
					taskEndItmCdSort.add(CodeUtil.getItem(taskEndItmCd, "13"));
				}
			}
		}
		mv.addObject("taskEndItmCd", taskEndItmCdSort);
		
		return mv;
	}
	
}