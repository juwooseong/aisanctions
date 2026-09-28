package com.woori.ajs.controller;

import java.io.File;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Properties;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import egovframework.rte.fdl.property.EgovPropertyService;
import egovframework.rte.psl.dataaccess.util.EgovMap;
import egovframework.ui.cmmn.DateUtil;
import egovframework.ui.cmmn.FileUtil;
import egovframework.ui.cmmn.StringUtil;
import egovframework.ui.cmmn.XlsUtil;

@Controller
public class AdminWatchListController {

	@Resource(name = "propertiesService")
	protected EgovPropertyService propertiesService;
	
	@Resource(name = "systemFileProperties")
	protected Properties sysProp;
	
	@RequestMapping(value = "/admin/watchlist")
	public ModelAndView list(ModelAndView mv) throws Exception {
		mv.setViewName("blank/admin/watchlist/watchInfo");
		
		return mv;
	}

/*	@RequestMapping(value = "/admin/watchlist/excel/download")
	public ModelAndView downExcelSample(ModelAndView mv) throws Exception {
		mv.setViewName("downView");
		
		String today = DateUtil.getFormatDate("yyyyMMdd");

		//downFilePath		: 다운로드할 파일 경로, xls/watchlist/watchlistSample.xlsx
		//downFileName		: 다운로드할 파일 명칭, 홍길동.jpg
		String downFilePath = StringUtil.nvl("xls/watchlist/watchlistSample.xlsx");
		String downFileName = StringUtil.nvl(StringUtil.concat(new String[] {"watchlistBatchReg_",today,".xlsx"}));
		
		String uploadPath = StringUtil.nvl(sysProp.getProperty("upload.path"));
		String fullPath = StringUtil.combinePath(uploadPath, downFilePath, File.separator);

		if(uploadPath.equals("") || downFilePath.equals("") || downFileName.equals("")) {
			throw new Exception("정보가 부족합니다.");
		}
		
		File downloadFile = new File(fullPath);
		
		if(!downloadFile.isFile() || !downloadFile.exists()) {
			throw new Exception("파일이 존재하지 않습니다.");
		}
		
		FileUtil.setFileDown(mv, downloadFile, downFileName);
		
		return mv;
	}*/

	@RequestMapping(value = "/admin/watchlist/json/download")
	public ModelAndView downJsonSample(ModelAndView mv) throws Exception {
		mv.setViewName("downView");
		
		String today = DateUtil.getFormatDate("yyyyMMdd");

		//downFilePath		: 다운로드할 파일 경로, xls/watchlist/watchlistSample.xlsx
		//downFileName		: 다운로드할 파일 명칭, 홍길동.jpg
		String downFilePath = StringUtil.nvl("json/watchlist/watchlistBatchReg_sample.json");
		String downFileName = StringUtil.nvl(StringUtil.concat(new String[] {"watchlistBatchReg_",today,".json"}));
		
		String uploadPath = StringUtil.nvl(sysProp.getProperty("upload.path"));
		String fullPath = StringUtil.combinePath(uploadPath, downFilePath, File.separator);

		if("".equals(uploadPath) || "".equals(downFilePath) || "".equals(downFileName)) {
			throw new Exception("정보가 부족합니다.");
		}
		
		File downloadFile = new File(fullPath);
		
		if(!downloadFile.isFile() || !downloadFile.exists()) {
			throw new Exception("파일이 존재하지 않습니다.");
		}
		
		FileUtil.setFileDown(mv, downloadFile, downFileName);
		
		return mv;
	}

	@RequestMapping(value = "/admin/watchlist/excel/download2")
	public ModelAndView downExcelSample2(ModelAndView mv) throws Exception {
		mv.setViewName("downView");

		String today = DateUtil.getFormatDate("yyyyMMdd");
		String downFileName = StringUtil.nvl(StringUtil.concat(new String[] {"watchlistBatchReg_",today,".xlsx"}));
		
		//데이터셋팅.
		List<EgovMap> dataList = new ArrayList<EgovMap>();
		EgovMap dataRow = null;

		dataRow = new EgovMap();
		dataRow.put("cont", "엑셀텍스트01");
		dataList.add(dataRow);
		
		dataRow = new EgovMap();
		dataRow.put("cont", "엑셀텍스트02");
		dataList.add(dataRow);
		
		dataRow = new EgovMap();
		dataRow.put("cont", "엑셀텍스트03");
		dataList.add(dataRow);
		
		dataRow = new EgovMap();
		dataRow.put("cont", "엑셀텍스트04");
		dataList.add(dataRow);
		
		dataRow = new EgovMap();
		dataRow.put("cont", "엑셀텍스트05");
		dataList.add(dataRow);
		
		dataRow = new EgovMap();
		dataRow.put("cont", "엑셀텍스트06");
		dataList.add(dataRow);

		dataRow = new EgovMap();
		dataRow.put("cont", "엑셀텍스트07");
		dataList.add(dataRow);

		dataRow = new EgovMap();
		dataRow.put("cont", "엑셀텍스트08");
		dataList.add(dataRow);

		dataRow = new EgovMap();
		dataRow.put("cont", "엑셀텍스트09");
		dataList.add(dataRow);
		
		//엑셀 데이터 만들기.
		List<String[]> xlsListsTitle = XlsUtil.createListsTitle();
		List<List<LinkedHashMap<String,String>>> xlsLists = XlsUtil.createLists();
		
		//리스트1
		xlsListsTitle.add(new String[] {"content_txt"});
		
		if(dataList!=null) {
			List<LinkedHashMap<String,String>> xlsList = XlsUtil.createList();
			for(int i=0;i<dataList.size();i++) {
				LinkedHashMap<String,String> rowMap = new LinkedHashMap<String,String>();
				
				EgovMap row = null;
				if (dataList.get(i) instanceof EgovMap) {
					row = (EgovMap)dataList.get(i);
				}
				
				if (row != null) {
					
					rowMap.put("cont", row.get("cont").toString());
					xlsList.add(rowMap);
				}
				
			}
			xlsLists.add(xlsList);
		}
		
		//엑셀 다운로드 처리.
		String uploadPath = StringUtil.nvl(sysProp.getProperty("upload.path"));
		File xlsFile = XlsUtil.createXlsFile(uploadPath, xlsListsTitle, xlsLists);
		
		mv.addObject("downloadFile",xlsFile);
		mv.addObject("downloadFileName",downFileName);
		return mv;
	}

}