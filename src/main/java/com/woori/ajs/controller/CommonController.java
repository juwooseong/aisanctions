package com.woori.ajs.controller;

import java.io.File;
import java.util.HashMap;
import java.util.List;
import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.json.simple.JSONObject;
import org.json.simple.JSONValue;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.woori.ajs.model.CommonCodeVO;
import com.woori.ajs.model.CommonHistoryListVO;
import com.woori.ajs.model.SearchVO;
import com.woori.ajs.service.CommonCodeService;
import com.woori.ajs.service.CommonRevertHistoryService;

import egovframework.ui.cmmn.CastUtil;
import egovframework.ui.cmmn.DateUtil;
import egovframework.ui.cmmn.FileBinUtil;
import egovframework.ui.cmmn.FileUtil;
import egovframework.ui.cmmn.HttpCallUtil;
import egovframework.ui.cmmn.PropUtil;
import egovframework.ui.cmmn.StringUtil;

@Controller
public class CommonController {

	@Resource(name = "systemFileProperties")
	protected Properties sysProp;
	
	@Resource(name = "commonCodeService")
	private CommonCodeService commonCodeService;
	
	@Resource(name = "commonRevertHistoryService")
	CommonRevertHistoryService service;
	/**
	 * 그리드 리스트 공통 스크립트.
	 * 타입파라미터에 따라서, 뷰를 다양하게 선택가능함.
	 */
	@RequestMapping(value = "/common/grid")
	public ModelAndView grid(ModelAndView model) throws Exception {
		model.setViewName("blank/common/grid");
		return model;
	}
	
	/**
	 * 첨부파일 업로드 스크립트.
	 * 타입파라미터에 따라서, 뷰를 다양하게 선택가능함.
	 */
	@RequestMapping(value = "/common/file")
	public String file() throws Exception {
		return "blank/common/file";
	}
	
	@RequestMapping(value = "/common/loading")
	public ModelAndView loading(ModelAndView model) throws Exception{
		model.setViewName("blank/common/loading");
		return model;
	}

	@RequestMapping(value = "/common/down")
	public ModelAndView download(ModelAndView mv,
			@RequestParam("inptMstSrno") String inptMstSrno,
			@RequestParam("aiInptAtflSrno") String aiInptAtflSrno) throws Exception {

		mv.setViewName("downView");

		
		HashMap<String,Object> params = new HashMap<String,Object>();
		
		SearchVO vo = new SearchVO();
		vo.setInptMstSrno(Integer.parseInt(inptMstSrno));
		vo.setAiInptAtflSrno(aiInptAtflSrno);
		List<CommonHistoryListVO> list = service.selectFileInfo(vo);
		String fileKey = list.get(0).getAiInptAtflPathTxt();
		
		params.put("key", fileKey);
		String result = HttpCallUtil.callPostUrl(PropUtil.API_FILE_DOWNLOAD_URL, params);
		
		JSONObject json_data = CastUtil.objToJSONObj(JSONValue.parse(result));
		String json_file = CastUtil.objToStr(json_data.get("file"));
		
		StringBuffer stringBuffer = new StringBuffer();
		
		stringBuffer.append(DateUtil.getFormatDate("yyyyMMddHHmmss"));
		stringBuffer.append('.');
		stringBuffer.append(FileUtil.getFileExt(list.get(0).getAiInptAtflNm()));
		
		
	//	String customTmp = StringUtil.combinePath(PropUtil.UPLOAD_PATH, "tmp");
		
		
		File downloadFile = FileBinUtil.binaryToFile(json_file, PropUtil.UPLOAD_PATH_DOWN, stringBuffer.toString());
		//File downloadFile = FileBinUtil.binaryToFile(json_file, StringUtil.combinePath(PropUtil.UPLOAD_PATH, "tmp"), stringBuffer.toString());
		
		if(!downloadFile.isFile() || !downloadFile.exists()) {
			throw new Exception("파일이 존재하지 않습니다.");
		}
		FileUtil.setFileDown(mv, downloadFile, list.get(0).getAiInptAtflNm());
		
		
		
		String uploadPath = StringUtil.nvl(sysProp.getProperty("upload.path"));
		String xlsPath = StringUtil.combinePath(uploadPath, "tmp/xls/down");
		String today = DateUtil.getFormatDate("yyyyMMdd");
		
		String[] oldFiles = FileUtil.getSubList(xlsPath);
		if(oldFiles!=null) {
			for(int i=0;i<oldFiles.length;i++) {
				String oldFile = oldFiles[i].trim();
				String fileExt = FileUtil.getFileExt(oldFile).toLowerCase();
				String fileDate = oldFile.substring(0,8);
				int compareStr = fileDate.compareTo(today);
				
				//파일생성일이 어제보다 이전이면, 파일을 삭제처리함.
				if(compareStr==-1 && (fileExt.contains("xls") || fileExt.contains("xlsx") || fileExt.contains("pdf"))) {
					String oldFilePath = StringUtil.combinePath(xlsPath, oldFile);
					File oldFileObj = new File(oldFilePath);
					if(oldFileObj.isFile() && oldFileObj.exists()) {
						oldFileObj.delete();
					}
				}
			}
		}
		
		
		
		return mv;
	}

	/**
	 * 사용자 팝업
	 */
	@RequestMapping(value = "/common/user")
	public ModelAndView user(ModelAndView model, SearchVO vo) throws Exception {
		
		 vo.setAiInptGrpCd("120");
		 List<CommonCodeVO> inptAtmcBizDscdList = commonCodeService.selectAllCommonCodeList(vo);
		 model.addObject("inptAtmcBizDscdList", inptAtmcBizDscdList);
		model.setViewName("blank/common/user");
		return model;
	}

	/**
	 * 세계지도 표시
	 */
	@RequestMapping(value = "/common/map")
	public String map() throws Exception {
		return "blank/common/map";
	}

}