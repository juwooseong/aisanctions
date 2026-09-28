package egovframework.ui.cmmn;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;

import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.hssf.util.CellReference;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.woori.ajs.model.FileVO;
import com.woori.ajs.model.FilesVO;

public class XlsUtil {

	private static final Logger LOGGER = LoggerFactory.getLogger(XlsUtil.class);

	/**
	 * 특정 엑셀파일의 워크북 객체 가져오는 함수.
	 * createXlsFile 엑셀파일로 생성한 엑셀파일만 제대로 처리함.
	 * 그냥 엑셀에서 만들면, 오류가남.
	 * 
	 * @param xlsType		: xls, xlsx
	 * @return				: 워크북 객체
	 * @throws Exception
	 */
	public static Workbook getWorkbook(File file, FileInputStream fis) throws Exception {
		Workbook result = null;
		
		if(file==null || !file.isFile() || !file.exists()) {
			return result;
		}

		String filePath = file.getPath();
		String xlsType = StringUtil.nvl(FileUtil.getFileExt(filePath)).toLowerCase().trim();
		
		try {
			if(xlsType.equals("xls")) {
				try {
					result = new HSSFWorkbook(fis);
				} catch (IOException e) {
					throw new RuntimeException(e);
				}
			} else if(xlsType.equals("xlsx")) {
				try {
					result = new XSSFWorkbook(fis);
				} catch (IOException e) {
					throw new RuntimeException(e);
				}
			}
		} catch(Exception e) {
			LOGGER.debug(e.getMessage()+" - 엑셀 읽어들일때, XlsUtil.createXlsFile 메서드로 생성한 엑셀파일만 제대로 인식이 됩니다.");
			throw new Exception(e);
		}
		
		return result;
	}

	/**
	 * 엑셀로 출력할 데이터를 엑셀파일을 만들어서, 만든 엑셀파일을 반환함.
	 * @param workbook		: 엑셀저장할 데이터가 저장된 워크북 객체.
	 * @param lists			: 엑셀에 출력할 데이터 목록
	 * @return
	 */
	public static File createXlsFile(String uploadPath, List<String[]> listsTitle, List<List<LinkedHashMap<String,String>>> lists) throws Exception {
		return createXlsFile(uploadPath, listsTitle, lists,"xlsx");
	}
	
	/**
	 * 엑셀로 출력할 데이터를 엑셀파일을 만들어서, 만든 엑셀파일을 반환함.
	 * @param workbook		: 엑셀저장할 데이터가 저장된 워크북 객체.
	 * @param xlsKind		: xls, xlsx
	 * @param lists			: 엑셀에 출력할 데이터 목록
	 * @return
	 */
	public static File createXlsFile(String uploadPath, List<String[]> listsTitle, List<List<LinkedHashMap<String,String>>> lists, String xlsKind) throws Exception {
		File result = null;
		String filePath = "";
		String xlsPath = "";
		String fileName = "";
		File xlsDir = null;
		String today = DateUtil.getFormatDate("yyyyMMdd");
		
		xlsKind = StringUtil.nvl(xlsKind).trim().toLowerCase();
		uploadPath = StringUtil.nvl(uploadPath).trim();
		//xlsPath = StringUtil.combinePath(uploadPath, "xls");
		xlsPath = StringUtil.combinePath(uploadPath, "tmp/xls/down");
		filePath = xlsPath;
		xlsDir = new File(xlsPath);
		
		if(uploadPath.equals("")) {
			LOGGER.debug("입력값이 부족합니다.");
			throw new Exception();
		}
		
		if(listsTitle==null || listsTitle.size() == 0) {
			LOGGER.debug("출력할 데이터가 존재하지 않습니다.");
			throw new Exception();
		}
		
		if(!xlsKind.equals("xls") && !xlsKind.equals("xlsx")) {
			LOGGER.debug("엑셀타입이 잘못되었습니다.(xls, xlsx)");
			throw new Exception();
		}
		
		if(!xlsDir.isDirectory() || !xlsDir.exists()) {
			LOGGER.debug("엑셀이 저장될 폴더가 존재하지 않습니다.");
			throw new Exception();
		}
		
		//엑셀 워크북 객체 생성.
		Workbook workbook = null;
		if(xlsKind.equals("xlsx")){
            workbook = new XSSFWorkbook();
        }else if(xlsKind.equals("xls")){
            workbook = new HSSFWorkbook();
        }else{
        	LOGGER.debug("invalid file name, should be xls or xlsx");
            throw new Exception();
        }
		
		//시트에 제목행 생성.
		if(listsTitle!=null && listsTitle.size() > 0) {
			for(int i=0;i<listsTitle.size();i++) {
				String[] dataTitle = listsTitle.get(i);
				if(dataTitle!=null && dataTitle.length > 0) {
					int shtNum = i + 1;
					String shtNm = "sheet"+shtNum;
					Sheet sheet = workbook.createSheet(shtNm);
					
					Row shtRowTitle = sheet.createRow(0);
					for(int k=0;k<dataTitle.length;k++) {
						String title = dataTitle[k];
						
						Cell cell = shtRowTitle.createCell(k);
						cell.setCellValue(title);
					}
				}
			}
		}

		//시트에 내용행 생성.
		if(lists!=null && lists.size() > 0) {
			for(int i=0;i<lists.size();i++) {
				List<LinkedHashMap<String,String>> dataList = lists.get(i);
				if(dataList!=null && dataList.size() > 0) {
					int shtNum = i + 1;
					String shtNm = "sheet"+shtNum;
					Sheet sheet = workbook.getSheet(shtNm);
					for(int j=0;j<dataList.size();j++) {
						LinkedHashMap<String,String> dataRow = dataList.get(j);		//데이터 행객체
						Row shtRow = sheet.createRow(j+1);							//시트 행객체
						
						fillSheetRow(shtRow, dataRow);
					}
				}
			}
		}
		
		//금일이전 파일들 존재하면 삭제처리.(어제부터,파일명 날짜체크)
		String[] oldFiles = FileUtil.getSubList(xlsPath);
		if(oldFiles!=null) {
			for(int i=0;i<oldFiles.length;i++) {
				String oldFile = oldFiles[i].trim();
				String fileExt = FileUtil.getFileExt(oldFile).toLowerCase();
				String fileDate = oldFile.substring(0,8);
				int compareStr = fileDate.compareTo(today);
				
				//파일생성일이 어제보다 이전이면, 파일을 삭제처리함.
				if(compareStr==-1 && (fileExt.contains("xls") || fileExt.contains("xlsx"))) {
					String oldFilePath = StringUtil.combinePath(xlsPath, oldFile);
					File oldFileObj = new File(oldFilePath);
					if(oldFileObj.isFile() && oldFileObj.exists()) {
						oldFileObj.delete();
					}
				}
			}
		}
		
		//파일 저장처리.
		fileName = StringUtil.concat(new String[] {DateUtil.getFormatDate("yyyyMMdd"),"_",String.valueOf(System.currentTimeMillis()),".",xlsKind});
		filePath = StringUtil.combinePath(filePath, fileName);
		
        FileOutputStream fos = null;
        try {
	        fos = new FileOutputStream(filePath);
	        workbook.write(fos);
	        
	        if (fos != null) {
	        	
	        	fos.close();
	        }
	        
        } catch (Exception e) {
        	
        	if (fos != null) {
        		
        		fos.close();
        	}
        	
        	throw new Exception(e);
        	
        } finally {
        	
        	LOGGER.debug("createXlsFile");
        	
        }
        
        result = new File(filePath);
        
		return result;
	}
	
	public static List<String[]> createListsTitle() {
		return new ArrayList<String[]>();
	}
		
	public static List<List<LinkedHashMap<String,String>>> createLists() {
		return new ArrayList<List<LinkedHashMap<String,String>>>();
	}

	public static List<LinkedHashMap<String,String>> createList() {
		return new ArrayList<LinkedHashMap<String,String>>();
	}

	/*
	public static List<File> getUploadedExcelFileList(MultipartHttpServletRequest mreq, String uploadPath) throws Exception {   // ?????????????
		return getUploadedExcelFileList(mreq, uploadPath, "upfile");
	}
	
	
	public static List<File> getUploadedExcelFileList(MultipartHttpServletRequest mreq, String uploadPath, String formName) throws Exception {
		List<File> result = new ArrayList<File>();
		
		uploadPath = StringUtil.nvl(uploadPath).trim();
		formName = StringUtil.nvl(formName).trim();
		
		if(uploadPath.equals("")) {
			return result;
		}
		
		String xlsPath = StringUtil.combinePath(uploadPath, "xls");
		
		List<HashMap<String,String>> files = FileUtil.uploadFiles(mreq, uploadPath, "tmp", formName);
		if(files!=null) {
			for(int i=0;i<files.size();i++) {
				FileVO info = new FileVO(files.get(i));
				File file = new File(StringUtil.combinePath(uploadPath, info.getUploadUrl()));
				String fileName = StringUtil.concat(new String[] {DateUtil.getFormatDate("yyyyMMdd"),"_",info.getFileSaveName()});
				String fileExt = FileUtil.getFileExt(fileName).trim().toLowerCase();
				String filepath = StringUtil.combinePath(xlsPath, fileName);
				File xlsFile = new File(filepath);
				
				if(!fileExt.equals("xls") && !fileExt.equals("xlsx")) {
					continue;
				}
				
				if(file.renameTo(xlsFile)) {
					result.add(xlsFile);
				}
			}
		}
		
		return result;
	}*/

	/**
	 * 엑셀파일 업로드를 하고서, 엑셀업로드 경로로 파일을 이동시킴.
	 */
	public static FilesVO getUploadedExcelFileList2(MultipartHttpServletRequest mreq, String uploadPath) throws Exception {
		return getUploadedExcelFileList2(mreq, uploadPath, "upfile");
	}
	
	/**
	 * 엑셀파일 업로드를 하고서, 엑셀업로드 경로로 파일을 이동시킴.
	 */
	public static FilesVO getUploadedExcelFileList2(MultipartHttpServletRequest mreq, String uploadPath, String formName) throws Exception {
		FilesVO result = new FilesVO();
		
		uploadPath = StringUtil.nvl(uploadPath).trim();
		formName = StringUtil.nvl(formName).trim();
		
		if(uploadPath.equals("")) {
			return result;
		}
		
		//String xlsPath = StringUtil.combinePath(uploadPath, "xls");
		String xlsPath = StringUtil.combinePath(uploadPath, "tmp/xls");
		List<HashMap<String,String>> files1 = new ArrayList<HashMap<String,String>>();
		List<FileVO> files2 = new ArrayList<FileVO>();
		List<File> files3 = new ArrayList<File>();

	 	List<HashMap<String,String>> files = FileUtil.uploadFiles(mreq, uploadPath, "tmp/xls/upload", formName);
		//List<HashMap<String,String>> files = FileUtil.uploadFiles(mreq, uploadPath, "tmp/xls/upload", formName);
		if(files!=null) {
			for(int i=0;i<files.size();i++) {
				HashMap<String,String> row = files.get(i);
				FileVO info = new FileVO(row);
				File file = new File(StringUtil.combinePath(uploadPath, info.getUploadUrl()));
				String fileName = StringUtil.concat(new String[] {DateUtil.getFormatDate("yyyyMMdd"),"_",info.getFileSaveName()});
				String fileExt = FileUtil.getFileExt(fileName).trim().toLowerCase();
				String filepath = StringUtil.combinePath(xlsPath, fileName); // resources\files\xls\이름.xlsx
				File xlsFile = new File(filepath);
				
				if(!fileExt.equals("xls") && !fileExt.equals("xlsx")) {
					continue;
				}
				
				if(file.renameTo(xlsFile)) {
					files1.add(row);
					files2.add(info);
					files3.add(xlsFile);
				}
			}
		}
		
		result.setFiles(files1);
		result.setFiles2(files2);
		result.setFiles3(files3);
		
		return result;
	}
	
	public static List<LinkedHashMap<String,String>> getXlsFileCont(File file) throws Exception {
		return getXlsFileCont(file,0);
	}
	
	public static List<LinkedHashMap<String,String>> getXlsFileContNoTitle(File file) throws Exception {
		return getXlsFileCont(file,0);
	}
	
	/**
	 * 엑셀파일의 내용을 읽어서, 리스트맵형태로 반환받음.
	 * @param file		: 엑셀파일
	 * @param shtIdx	: 시트인덱스(0~)
	 * @return
	 */
	public static List<LinkedHashMap<String,String>> getXlsFileCont(File file, int shtIdx) throws Exception { // 0 시트
		List<LinkedHashMap<String,String>> result = new ArrayList<LinkedHashMap<String,String>>();
		
		FileInputStream fis = null;

		try {
			if(file!=null && file.isFile() && file.exists()) {
				String fileExt = FileUtil.getFileExt(file.getName()).trim().toLowerCase();
				if(fileExt.equals("xls") || fileExt.equals("xlsx")) {
					fis = new FileInputStream(file.getPath());
					
					Workbook wb = getWorkbook(file,fis);
					Sheet sht = wb.getSheetAt(shtIdx);
					int numOfRows = sht.getPhysicalNumberOfRows();
					String[] colsTitle = null;
					
					int rowCnt = 0;
					for(int i=0;i<numOfRows;i++) {
						Row row = sht.getRow(i);
						if(row!=null) {
							LinkedHashMap<String,String> row2 = new LinkedHashMap<String,String>();
							int numOfCells = row.getPhysicalNumberOfCells();
							/*if(rowCnt==0) {
								//첫행은 컬럼명.
								colsTitle = new String[numOfCells];
								for(int j=0;j<numOfCells;j++) {
									Cell cell = row.getCell(j);
									String cellValue = getCellValue(cell);
									colsTitle[j] = cellValue;
								}
							} */
							
						//	else {
								//2행부터 내용.
								for(int j=0;j<numOfCells;j++) {
									Cell cell = row.getCell(j);
									// String cellName = colsTitle[j];
									String cellValue = getCellValue(cell);
									row2.put("contents", cellValue);
								//	row2.put(cellValue);
								}
								
								//결과목록에 행추가.
								result.add(row2);
						//	}
						//	
							rowCnt++;	
						}
					}
				}
			}
			
			if(fis!=null) {
				fis.close();
			}
			
		} catch(Exception e) {
			
			if(fis!=null) {
				fis.close();
			}
			
			LOGGER.debug("엑셀업로드 엑셀파일 읽기 오류!!");
			
			throw new Exception(e);
		} finally {
			
			LOGGER.debug("createXlsFile");
			
		}
		
		return result;
	}
	
	
	
	public static List<LinkedHashMap<String,String>> getXlsFileContNoTitle(File file, int shtIdx) throws Exception { // 0 시트
		List<LinkedHashMap<String,String>> result = new ArrayList<LinkedHashMap<String,String>>();
		
		FileInputStream fis = null;

		try {
			if(file!=null && file.isFile() && file.exists()) {
				String fileExt = FileUtil.getFileExt(file.getName()).trim().toLowerCase();
				if(fileExt.equals("xls") || fileExt.equals("xlsx")) {
					fis = new FileInputStream(file.getPath());
					
					Workbook wb = getWorkbook(file,fis);
					Sheet sht = wb.getSheetAt(shtIdx);
					int numOfRows = sht.getPhysicalNumberOfRows();
					String[] colsTitle = null;
					
					int rowCnt = 0;
					for(int i=0;i<numOfRows;i++) {
						Row row = sht.getRow(i);
						if(row!=null) {
							LinkedHashMap<String,String> row2 = new LinkedHashMap<String,String>();
							int numOfCells = row.getPhysicalNumberOfCells();
							
							if(rowCnt==0) {
								//첫행은 컬럼명.
								colsTitle = new String[numOfCells];
								for(int j=0;j<numOfCells;j++) {
									Cell cell = row.getCell(j);
									String cellValue = getCellValue(cell);
									colsTitle[j] = cellValue;
								}
							} else {
								//2행부터 내용.
								for(int j=0;j<numOfCells;j++) {
									Cell cell = row.getCell(j);
									String cellName = "";
									if (colsTitle != null) {
										
										cellName = colsTitle[j];
									}
									
									String cellValue = getCellValue(cell);
									row2.put(cellName, cellValue);
								}
								
								//결과목록에 행추가.
								result.add(row2);
							}
							
							rowCnt++;	
						}
					}
				}
			}
			
			if(fis!=null) {
				fis.close();
			}
			
		} catch(Exception e) {
			
			if(fis!=null) {
				fis.close();
			}
			
			LOGGER.debug("엑셀업로드 엑셀파일 읽기 오류!!");
			
			throw new Exception(e);
		} finally {
			
			LOGGER.debug("getXlsFileContNoTitle");
		}
		
		return result;
	}
	
	
	public static String getCellName(Cell cell, int cellIndex) {
		int cellNum = 0;
		if(cell==null) {
			cellNum = cellIndex;
		} else {
			cellNum = cell.getColumnIndex();
		}
		return CellReference.convertNumToColString(cellNum);
	}

	public static String getCellValue(Cell cell) {
		String value = "";
		if(cell!=null) {
			if(cell.getCellType()==Cell.CELL_TYPE_FORMULA) {
				value = cell.getCellFormula();
			} else if(cell.getCellType()==Cell.CELL_TYPE_NUMERIC) {
				value = String.valueOf(cell.getNumericCellValue());
			} else if(cell.getCellType()==Cell.CELL_TYPE_STRING) {
				value = cell.getStringCellValue();
			} else if(cell.getCellType()==Cell.CELL_TYPE_BOOLEAN) {
				value = String.valueOf(cell.getBooleanCellValue());
			} else if(cell.getCellType()==Cell.CELL_TYPE_ERROR) {
				value = String.valueOf(cell.getErrorCellValue());
			} else if(cell.getCellType()==Cell.CELL_TYPE_BLANK) {
				value = "";
			} else {
				value = cell.getStringCellValue();
			}
		}
		return value;
	}
	
	/**
	 * 시트 행객체에, 데이터 행을 읽어서, 컬럼들을 채우는 함수
	 * @param shtRow		: 시트 행객체 (여기다 셀을 생성해서 채움)
	 * @param dataRow		: 데이터 행객체 (여기서 데이터를 읽어서 셀을 생성함)
	 */
	public static void fillSheetRow(Row shtRow, LinkedHashMap<String, String> dataRow) {
		Iterator<String> dataRowKeys = dataRow.keySet().iterator();
		int k=0;
		while(dataRowKeys.hasNext()) {
			String key = dataRowKeys.next();
			String val = StringUtil.nvl(dataRow.get(key));
			
			Cell cell = shtRow.createCell(k);
			cell.setCellValue(val);
			
			k++;
		}
	}
	
}