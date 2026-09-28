
package com.woori.ajs.api;

import java.util.HashMap;
import java.util.List;
import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springmodules.validation.commons.DefaultBeanValidator;

import com.woori.ajs.model.AdminLogProgramVO;
import com.woori.ajs.model.LoginVO;
import com.woori.ajs.model.SearchVO;
import com.woori.ajs.model.TaskLogRegVO;
import com.woori.ajs.service.AdminLogProgramService;
import com.woori.ajs.service.TaskLogEndService;
import com.woori.ajs.service.TaskLogRegService;

import egovframework.rte.fdl.property.EgovPropertyService;
import egovframework.ui.cmmn.HttpUtil;
import egovframework.ui.cmmn.StringUtil;
import egovframework.ui.util.LoginUtils;

@RestController
public class TaskLogRegApiController {
	
	@Resource(name = "adminLogProgramService")
	private AdminLogProgramService adminLogProgramService;
	
	@Resource(name = "taskLogRegService")
	private TaskLogRegService taskLogRegService;

	@Resource(name = "taskLogEndService")
	private TaskLogEndService taskLogEndService;

	/** EgovPropertyService */
	@Resource(name = "propertiesService")
	protected EgovPropertyService propertiesService;

	/** Validator */
	@Resource(name = "beanValidator")
	protected DefaultBeanValidator beanValidator;

	@Resource(name = "systemFileProperties")
	protected Properties sysProp;
	
	@GetMapping("/api/task/log/reg")
	public HashMap<String,Object> CountList(HttpServletRequest request, SearchVO searchVO) throws Exception {
		HashMap<String,Object> map = new HashMap<String,Object>();
		HttpUtil.setResult(map, HttpUtil.HttpType.T200);
		
		searchVO.setSchEdate1(searchVO.getSchSdate1());
		
		
		//업무일지 - 업무마감 (5010) - 당일목록 건수 
		//업무일지 - 업무일지 등록 (5020) - 제재심사 건수
		SearchVO svo = new SearchVO();
		
		
		LoginVO loginInfo = LoginUtils.getLoginInfo(request);
		TaskLogRegVO vo = new TaskLogRegVO();
		
		// 010 table check // 추후에 010 테이블에 없는 새로운 날짜에(저장버튼을 누르지 않은 날짜) 미리 검사하는 로직이 필요함
		vo.setAiInptApdrDt(searchVO.getSchSdate1().replace("-", ""));
		vo.setLstDbChgId(loginInfo.getId());
		
		try {
			String[] paramKeys = getParamKeys();
			if(paramKeys!=null) {
				for(int i=0;i<paramKeys.length;i++) {
					String paramKey = paramKeys[i];
					int check = setParamByKey(request, paramKey, vo);
					if(check==1) {
						taskLogRegService.preInsert(vo);
					}
				}
			}
		} catch (Exception e) {
			HttpUtil.setResult(map, HttpUtil.HttpType.T500);
			HttpUtil.setExResult(map, "-2", e.getMessage());
		}
		
		
		svo.setSchSdate1(searchVO.getSchSdate1());
		svo.setSchEdate1(searchVO.getSchEdate1());
		svo.setInptAtmcBizDscd("2");
		searchVO.setTaskDatesCnt1(taskLogEndService.getTaskDatesCnt(svo));	//수출
		svo.setInptAtmcBizDscd("1");
		searchVO.setTaskDatesCnt2(taskLogEndService.getTaskDatesCnt(svo));	//수입
		svo.setInptAtmcBizDscd(null);
		searchVO.setTaskDatesCnt3(taskLogEndService.getTaskDatesCnt(svo));	//전체
		
		//통계건수
		List<TaskLogRegVO> list = taskLogRegService.selectList(searchVO);   // 수출입 선적서류 심사
		List<TaskLogRegVO> list2 = taskLogRegService.select2List(searchVO); // W/F 실행건 증빙서류 심사
		List<TaskLogRegVO> list3 = taskLogRegService.select3List(searchVO); // 수/발신 전문심사(SafeWatch) 
		List<TaskLogRegVO> list4 = taskLogRegService.select4List(searchVO); // 서류심사건 자체점검(Quality Assurance)
		List<TaskLogRegVO> list5 = taskLogRegService.select5List(searchVO); // 기타
		
		map.put("list", list);
		map.put("list2", list2);
		map.put("list3", list3);
		map.put("list4", list4);
		map.put("list5", list5);
		
		return map;
	}
	
	@PostMapping("/api/task/log/reg")
	public HashMap<String,Object> insert(HttpServletRequest request, TaskLogRegVO vo, AdminLogProgramVO adminLogProgramVO) throws Exception {
		HashMap<String,Object> map = new HashMap<String,Object>();
		LoginVO loginInfo = LoginUtils.getLoginInfo(request);
		
		HttpUtil.setResult(map, HttpUtil.HttpType.T200);
		
		if(StringUtil.isEmpty(vo.getAiInptApdrDt())) {
			HttpUtil.setResult(map, HttpUtil.HttpType.T500);
			HttpUtil.setExResult(map, "-1", "정보가 부족합니다.");
			return map;
		}
		String trnLogSrno = null;
		SearchVO searchVO = new SearchVO();
		trnLogSrno = adminLogProgramService.logProgramInsert(request, adminLogProgramVO, searchVO);
		
		vo.setTrnLogSrno(trnLogSrno);
		vo.setAiInptApdrDt(vo.getAiInptApdrDt().replace("-", ""));
		vo.setLstDbChgId(loginInfo.getId());
		
		try {
			String[] paramKeys = getParamKeys();
			if(paramKeys!=null) {
				for(int i=0;i<paramKeys.length;i++) {
					String paramKey = paramKeys[i];
					int check = setParamByKey(request, paramKey, vo);
					if(check==1) {
						taskLogRegService.insert(vo);
					}
				}
			}
		} catch (Exception e) {
			HttpUtil.setResult(map, HttpUtil.HttpType.T500);
			HttpUtil.setExResult(map, "-2", e.getMessage());
		}
		
		return map;
	}
	
	/**
	 * 화면에서 저장시, 입력항목들의 파라미터 전체 키값배열 반환.
	 * ["input2_1_1", ...]
	 * 파라미터명 키값 의미 : input[섹션번호 : 1~5]_[행번호 : 1~]_[열번호 : 1~]
	 */
	private String[] getParamKeys() {
		String[] keys = new String[37];
		int keysIdx = 0;
		String sectionNum = "";		//섹션번호 : 1~5
		
		/*
		======================================
		[2번섹션 키값]
		input2_1_1 ~ input2_1_5
		~
		input2_4_1 ~ input2_4_5
		파라미터 총개수 : 열수(5개) * 행수(4개) = 20개
		======================================
		[3번섹션 키값]
		- input3_1_1 ~ input3_1_2
		~
		input3_3_1 ~ input3_3_2
		파라미터 총개수 : 열수(2개) * 행수(3개) = 6개
		======================================
		[4번섹션 키값]
		- input4_1_3 ~ input4_1_4
		~
		input4_5_3 ~ input4_5_4
		파라미터 총개수 : 열수(2개) * 행수(5개) = 10개
		======================================
		[5번섹션 키값]
		- input5_1_1
		파라미터 총개수 : 열수(1개) * 행수(1개) = 1개
		======================================
		*/
		
		//2번섹션 키값 셋팅.
		sectionNum = "2";
		for(int colIdx = 1;colIdx <= 5; colIdx++) {
			for(int rowIdx = 1;rowIdx <= 4; rowIdx++) {
				String v_key = StringUtil.concat(new String[] {"input",sectionNum,"_",String.valueOf(rowIdx),"_",String.valueOf(colIdx)});
				keys[keysIdx++] = v_key;
			}
		}
		
		//3번섹션 키값 셋팅.
		sectionNum = "3";
		for(int colIdx = 1;colIdx <= 2; colIdx++) {
			for(int rowIdx = 1;rowIdx <= 3; rowIdx++) {
				String v_key = StringUtil.concat(new String[] {"input",sectionNum,"_",String.valueOf(rowIdx),"_",String.valueOf(colIdx)});
				keys[keysIdx++] = v_key;
			}
		}

		//4번섹션 키값 셋팅.
		sectionNum = "4";
		for(int colIdx = 3;colIdx <= 4; colIdx++) {
			for(int rowIdx = 1;rowIdx <= 5; rowIdx++) {
				String v_key = StringUtil.concat(new String[] {"input",sectionNum,"_",String.valueOf(rowIdx),"_",String.valueOf(colIdx)});
				keys[keysIdx++] = v_key;
			}
		}

		//5번섹션 키값 셋팅.
		sectionNum = "5";
		for(int colIdx = 1;colIdx <= 1; colIdx++) {
			for(int rowIdx = 1;rowIdx <= 1; rowIdx++) {
				String v_key = StringUtil.concat(new String[] {"input",sectionNum,"_",String.valueOf(rowIdx),"_",String.valueOf(colIdx)});
				keys[keysIdx++] = v_key;
			}
		}
		
		return keys;
	}
	
	/**
	 * 파라미터 key("input2_1_1", ...) 에 해당하는 섹션코드와 항목코드 등의 세부값들을 셋팅해서, 
	 * 데이터 등록을 할 수 있도록 값들을 셋팅함.
	 * 성공하면 1, 아니면 -1 보다 작은 음수값들. 오류번호 반환.
	 * 넘어온 객체는 새로 생성해서 할당함.
	 * @param key		: 파라미터 key("input2_1_1", ...)
	 * @param vo		: 셋팅할 파라미터 객체
	 */
	private int setParamByKey(HttpServletRequest request, String key, TaskLogRegVO vo) {
		key = key.trim();
		
		//객체값 초기화 (기존에 설정된 값이 디비에 들어가는것을 방지)
		vo.setAiInptApdrDscd(null);
		vo.setAiInptApdrItcd(null);
		vo.setAiInptXpoRelCnt(null);
		vo.setAiInptImpRelCnt(null);
		vo.setAiInptTbkIssuCnt(null);
		vo.setAiInptObkIssuCnt(null);
		vo.setAiInptEtcItmCnt(null);
		vo.setAiInptRmsgCnt(null);
		vo.setAiInptSmsgCnt(null);
		vo.setAiInptEtcOpiTxt(null);
		
		if(StringUtil.isEmpty(key) || vo==null) {
			return -1;
		}
		
		String keyOrg = key;	//원본 키값, request 파라미터 가져오기용
		
		String val = StringUtil.nvl(request.getParameter(keyOrg));
		
		key = key.replace("input", "");
		
		String[] arr = key.split("_");
		
		if(arr.length!=3) {
			return -2;
		}
		
		String sectionNum = StringUtil.nvl(arr[0]).trim();
		String rowNum = StringUtil.nvl(arr[1]).trim();
		String colNum = StringUtil.nvl(arr[2]).trim();
		
		if(StringUtil.isEmpty(sectionNum) || StringUtil.isEmpty(rowNum) || StringUtil.isEmpty(colNum)) {
			return -3;
		}
		
		//섹션번호에 따라서 업무일지구분코드값 vo객체에 설정
		//업무일지구분코드 (CSPD010TA.AI_INPT_APDR_DSCD) 설정 (그룹코드 : 322)
		if("1".equals(sectionNum)) {
			//vo.setAiInptApdrDscd("01");		//322-01 : 수출입 선적서류 심사
			return -4;						//1번 섹션엔 입력항목이 없음.
		}else if("2".equals(sectionNum)) {
			vo.setAiInptApdrDscd("02");		//322-02 : W/F 실행건 증빙서류 심사
		}else if("3".equals(sectionNum)) {
			vo.setAiInptApdrDscd("03");		//322-03 : 수/발신 전문심사(SafeWatch)
		}else if("4".equals(sectionNum)) {
			vo.setAiInptApdrDscd("04");		//322-04 : 서류심사건 자체점검(Quality Assurance)
		}else if("5".equals(sectionNum)) {
			vo.setAiInptApdrDscd("05");		//322-05 : 기타
		} else {
			return -5;
		}
		
		//섹션번호와 행번호에 따라서 업무일지항목코드값 vo객체에 설정
		//업무일지항목코드 (CSPD010TA.AI_INPT_APDR_ITCD) (그룹코드 : 323)
		if("2".equals(sectionNum)) {			//322-02 : W/F 실행건 증빙서류 심사
			if("1".equals(rowNum)) {
				vo.setAiInptApdrItcd("11");		//323-11 : 필터링등록
			} else if("2".equals(rowNum)) {
				vo.setAiInptApdrItcd("12");		//323-12 : 문면심사
			} else if("3".equals(rowNum)) {
				vo.setAiInptApdrItcd("10");		//323-10 : SafeWatch
			} else if("4".equals(rowNum)) {
				vo.setAiInptApdrItcd("13");		//323-13 : 위반(의심)거래 거절
			} else {
				return -6;
			}
		}else if("3".equals(sectionNum)) {		//322-03 : 수/발신 전문심사(SafeWatch)
			if("1".equals(rowNum)) {
				vo.setAiInptApdrItcd("14");		//323-14 : 정보발생전문건수
			} else if("2".equals(rowNum)) {
				vo.setAiInptApdrItcd("10");		//323-10 : SafeWatch
			} else if("3".equals(rowNum)) {
				vo.setAiInptApdrItcd("13");		//323-13 : 위반(의심)거래 거절
			} else {
				return -7;
			}
		}else if("4".equals(sectionNum)) {		//322-04 : 서류심사건 자체점검(Quality Assurance)
			if("1".equals(rowNum)) {
				vo.setAiInptApdrItcd("15");		//323-15 : FullText
			} else if("2".equals(rowNum)) {
				vo.setAiInptApdrItcd("16");		//323-16 : 항목별심사
			} else if("3".equals(rowNum)) {
				vo.setAiInptApdrItcd("10");		//323-10 : SafeWatch
			} else if("4".equals(rowNum)) {
				vo.setAiInptApdrItcd("17");		//323-17 : 적정
			} else if("5".equals(rowNum)) {
				vo.setAiInptApdrItcd("18");		//323-18 : 비적정
			} else {
				return -8;
			}
		}else if("5".equals(sectionNum)) {		//322-05 : 기타
			if("1".equals(rowNum)) {
				vo.setAiInptApdrItcd("19");		//323-19 : 기타의견
			}
		}
		
		//섹션번호와 열번호에 따라서, vo객체의 여러 건수컬럼중, 맞는 컬럼에다가 파라미터 값을 설정.
		if("2".equals(sectionNum)) {			//322-02 : W/F 실행건 증빙서류 심사
			if("1".equals(colNum)) {
				vo.setAiInptXpoRelCnt(val);
			} else if("2".equals(colNum)) {
				vo.setAiInptImpRelCnt(val);
			} else if("3".equals(colNum)) {
				vo.setAiInptTbkIssuCnt(val);
			} else if("4".equals(colNum)) {
				vo.setAiInptObkIssuCnt(val);
			} else if("5".equals(colNum)) {
				vo.setAiInptEtcItmCnt(val);
			} else {
				return -9;
			}
		}else if("3".equals(sectionNum)) {		//322-03 : 수/발신 전문심사(SafeWatch)
			if("1".equals(colNum)) {
				vo.setAiInptRmsgCnt(val);
			} else if("2".equals(colNum)) {
				vo.setAiInptSmsgCnt(val);
			} else {
				return -10;
			}
		}else if("4".equals(sectionNum)) {		//322-04 : 서류심사건 자체점검(Quality Assurance)
			if("3".equals(colNum)) {
				vo.setAiInptTbkIssuCnt(val);
			} else if("4".equals(colNum)) {
				vo.setAiInptObkIssuCnt(val);
			} else {
				return -11;
			}
		}else if("5".equals(sectionNum)) {		//322-05 : 기타
			if("1".equals(colNum)) {
				vo.setAiInptEtcOpiTxt(val);
			}
		}
		
		return 1;
	}
	
}