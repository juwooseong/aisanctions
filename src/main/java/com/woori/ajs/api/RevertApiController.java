package com.woori.ajs.api;

import java.util.HashMap;
import java.util.Properties;

import javax.annotation.Resource;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springmodules.validation.commons.DefaultBeanValidator;

import com.woori.ajs.service.RevertTodoService;

import egovframework.rte.fdl.property.EgovPropertyService;
import egovframework.ui.cmmn.CastUtil;
import egovframework.ui.cmmn.HttpUtil;
import egovframework.ui.cmmn.StringUtil;

@RestController
public class RevertApiController {

	/** revertTodoService */
	@Resource(name = "revertTodoService")
	private RevertTodoService revertTodoService;

	/** EgovPropertyService */
	@Resource(name = "propertiesService")
	protected EgovPropertyService propertiesService;

	/** Validator */
	@Resource(name = "beanValidator")
	protected DefaultBeanValidator beanValidator;

	@Resource(name = "systemFileProperties")
	protected Properties sysProp;
	
	/**
	 * AI 서버에서, 심사문서 생성시, json문자열 형태로, 심사문서 기본정보들과, 심사이미지정보들을 input 명칭의 파라미터로 넘기면,
	 * 이 json 입력 문자열을 파싱하여, 심사마스터 테이블과, 심사 이미지 테이블에 데이터들을 입력처리.
	 * 심사 이미지 json 객체들을 각각 해당 심사이미지 테이블에 json 문자열 형태로 각각 저장처리. (이미지별로 좌표 정보 등등)
	 */
	//@PostMapping("/api/revert")
	@GetMapping("/api/revert")
	public HashMap<String,Object> insert(@RequestParam(value="input",required=false) String input) throws Exception {
		HashMap<String,Object> map = new HashMap<String,Object>();
		
		HttpUtil.setResult(map, HttpUtil.HttpType.T200);
		
		//##### 임시 테스트용, 입력값 수동 셋팅 (추후 파라미터로 변경처리) #####
		StringBuffer sb = new StringBuffer();
		sb.append("\n [");
		sb.append("\n 	{");
		sb.append("\n 		\"revertInfo\" : {");
		sb.append("\n 			\"refId\" : \"aaaaaaa\"");
		sb.append("\n 			,\"ai_scan_dtm\" : \"20190101222401\"");
		sb.append("\n 		}");
		sb.append("\n 		,\"imageList\" : [");
		sb.append("\n 			{");
		sb.append("\n 				\"url\" : \"http://aaaa\\.gif\"");
		sb.append("\n 				,\"loc\" : [");
		sb.append("\n 					[10,100,20,200]");
		sb.append("\n 					,[10,100,20,200]");
		sb.append("\n 				]");
		sb.append("\n 			}");
		sb.append("\n 			, {");
		sb.append("\n 				\"url\" : \"http://bbb\\.gif\"");
		sb.append("\n 				,\"loc\" : [");
		sb.append("\n 					[10,100,20,201]");
		sb.append("\n 					,[10,100,22,200]");
		sb.append("\n 				]");
		sb.append("\n 			}");
		sb.append("\n 		]");
		sb.append("\n 	}");
		sb.append("\n ]");
		input = sb.toString();
		//##### //임시 테스트용, 입력값 수동 셋팅 (추후 파라미터로 변경처리) #####
		
		if (StringUtil.isEmpty(input)) {
			HttpUtil.setResult(map, HttpUtil.HttpType.T500);
			HttpUtil.setExResult(map, "-1", "입력값이 정상적으로 전달되지 않았습니다.");
			return map;
		}
		
		JSONParser jps = new JSONParser();
		//JSONArray list = (JSONArray)jps.parse(input);
		JSONArray list = CastUtil.objToJSONArr(jps.parse(input));
		for (Object object : list) {
			//JSONObject obj = (JSONObject)object;
			JSONObject obj = CastUtil.objToJSONObj(object);
			// JSONObject revertInfo = (JSONObject)obj.get("revertInfo");
			JSONObject revertInfo = CastUtil.objToJSONObj(obj.get("revertInfo"));
			String refId = CastUtil.objToStr(revertInfo.get("refId"));
		}
		//JSONArray images = (JSONArray)jobj.get("imageList");
		
		return map;
	}
	
}