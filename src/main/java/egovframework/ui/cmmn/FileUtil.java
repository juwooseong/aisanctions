package egovframework.ui.cmmn;

import java.io.File;
import java.io.IOException;
import java.nio.charset.Charset;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Properties;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.util.StringUtils;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

public class FileUtil {
	private static final Logger LOGGER = LoggerFactory.getLogger(FileBinUtil.class);
	/**
	 * 업로드 파일 정보를 상세하게 맵으로 받아올지 여부.
	 * 기본은 false.
	 */
//	public static boolean isSaveUploadDetailInfo = false;

	/**
	 * 다중 업로드 파일
	 * 지정된 업로드 폴더, 하위폴더안에, 현재 년월일 별로 하위폴더 생성해서 파일저장처리.
	 * 
	 * @param mreq			: 컨트롤러 메서드에 있는 인자값
	 * @param uploadPath	: sysProp.getProperty("upload.path")
	 * @param subDir		: 업로드 폴더 밑에 하위 폴더명
	 * @param formName		: 폼전송시 파일 폼이름
	 *
	 * 결과 리스트맵 키값
	 * fileOrgName			: 원본파일명
	 * fileSize				: 파일크기
	 * fileExt				: 파일확장자
	 * fileSaveName			: 파일저장명
	 * fileSavePath			: 파일저장 전체경로
	 * uploadPath			: 파일업로드 경로
	 * 
	 * List<HashMap<String,String>> files = FileUtil.uploadFiles(mreq, path, "tmp", "files");
	 */
	
	public static List<HashMap<String,String>> uploadFiles(MultipartHttpServletRequest mreq, String uploadPath, String subDir, String formName) {
		List<HashMap<String,String>> result = new ArrayList<HashMap<String,String>>();
	//	long uploadMaxSize = sysProp.getP
		
		StringBuffer uploadPathSb = new StringBuffer(uploadPath);
		String uploadPathSbConv = null;
		
		long uploadMaxSize = PropUtil.UPLOAD_MAX_SIZE;
		if(!StringUtils.isEmpty(uploadPath) && !StringUtils.isEmpty(subDir) && !StringUtils.isEmpty(formName)) {
			String uploadUrl = subDir+"/";
			
			if(!uploadPath.endsWith(File.separator)) {
				//uploadPath += File.separator;
				uploadPathSb.append(File.separator);
			}
			
			//uploadPath += subDir + File.separator;
			uploadPathSb.append(subDir).append(File.separator);
			uploadPathSbConv = uploadPathSb.toString();
			
			File uploadDir = new File(uploadPathSbConv);
			if(uploadDir.isDirectory() && uploadDir.exists()) {
				List<MultipartFile> fileList = mreq.getFiles(formName);
				//업로드 파일루프, 파일저장처리
				if(fileList!=null && fileList.size() > 0) {
					
					//업로드할 폴더 밑에 년월일 단위로 폴더를 생성함.
					String year = DateUtil.getFormatDate("yyyy");
					String mon = DateUtil.getFormatDate("MM");
					String day = DateUtil.getFormatDate("dd");
					
					String YM = year.concat(mon);
					String YMD = YM.concat(day);
					
				//	uploadPath = StringUtil.concat(new String[] {uploadPath,YMD,File.separator});
					//uploadPath = StringUtil.concat(new String[] {uploadPath,year,File.separator});
					//uploadPath = StringUtil.concat(new String[] {uploadPath,mon,File.separator});
					//uploadPath = StringUtil.concat(new String[] {uploadPath,day,File.separator});
					
			//		uploadUrl = StringUtil.concat(new String[] {uploadUrl,YMD,"/"});
					//uploadUrl = StringUtil.concat(new String[] {uploadUrl,year,"/"});
					//uploadUrl = StringUtil.concat(new String[] {uploadUrl,mon,"/"});
					//uploadUrl = StringUtil.concat(new String[] {uploadUrl,day,"/"});
					
					File uploadDir2 = new File(uploadPathSbConv);
					uploadDir2.mkdirs();

					int idx = 0;
					for(MultipartFile mf : fileList) {
						String fileOrgName = mf.getOriginalFilename();
						long fileSize = mf.getSize();
						String fileExt = getFileExt(fileOrgName);
						String fileSaveName = getSaveFilename(idx, fileExt);
						String fileSavePath = uploadPathSbConv + fileSaveName; // tmp/fileName
						String uploadUrl2 = uploadUrl + fileSaveName;
						//빈파일, 사이즈 체크, 확장자 체크(허용된 확장자만 업로드 가능처리), 최대업로드제한 사이즈 체크
						//특수문자가 포함되어 있는지 체크,
						if(mf.isEmpty() || fileSize==0 || !checkUploadFileExt(fileExt) || fileSize > uploadMaxSize || !checkUploadFileName(fileOrgName)) {
							continue;
						}
						
						//파일저장처리
						try {
							mf.transferTo(new File(fileSavePath));
						} catch (IllegalStateException e) {
							LOGGER.error("Exception ::: " + e);
						} catch (IOException e) {
							LOGGER.error("Exception ::: " + e);
						}
						
						//파일정보 생성 및 결과목록 추가
						HashMap<String,String> fileInfo = new HashMap<String,String>();
						fileInfo.put("fileOrgName", fileOrgName);
						fileInfo.put("fileSize", String.valueOf(fileSize));
						fileInfo.put("fileExt", fileExt);
						fileInfo.put("fileSaveName", fileSaveName);
						fileInfo.put("uploadUrl", uploadUrl2);
					//	if(isSaveUploadDetailInfo) {
							fileInfo.put("fileSavePath", fileSavePath);
							fileInfo.put("uploadPath", uploadPathSbConv);
					//	}
						result.add(fileInfo);
						
						idx++;
					}
				}
			}
		}
		
		return result;
	}
	
	public static String getFileExt(String fileName) {
		String result = "";
		
		if(StringUtil.isNotEmpty(fileName)) {
			int idx = fileName.lastIndexOf(".");
			if(idx!=-1) {
				result = fileName.substring(idx + 1);
			}
		}
		
		return result;
	}
	
	/**
	 * 전체파일경로에서, 폴더경로를 제외한 파일명만 반환.
	 * @param filePath		: 전체경로 문자열, /전체경로/파일명.gif
	 * @return
	 */
	public static String getFileName(String filePath) {
		String result = "";
		
		if(StringUtil.isNotEmpty(filePath)) {
			int idx = filePath.lastIndexOf(File.separator);
			if(idx!=-1) {
				result = filePath.substring(idx + 1);
			}
		}
		
		return result;
	}
	
	/**
	 * 전체파일경로에서, 파일명을 제외한, 폴더경로만 반환.
	 * @param filePath		: 전체경로 문자열, /전체경로/파일명.gif
	 * @return
	 */
	public static String getFolderPath(String filePath) {
		return getFolderPath(filePath,File.separator);
	}
	
	/**
	 * 전체파일경로에서, 파일명을 제외한, 폴더경로만 반환.
	 * @param filePath		: 전체경로 문자열, /전체경로/파일명.gif
	 * @return
	 */
	public static String getFolderPath(String filePath, String separator) {
		String result = filePath;
		
		result = StringUtil.nvl(result).trim();
		separator = StringUtil.nvl(separator,File.separator).trim();
		
		//파일이 포함된 경우만 파일명 제외처리.
		if(!StringUtils.isEmpty(result) && result.contains(".")) {
			int idx = result.lastIndexOf(separator);
			if(idx!=-1) {
				result = result.substring(0,idx + separator.length());
			}
		}
		
		return result;
	}
	
	/**
	 * 특정 폴더의 하위 파일 리스트를 반환.
	 * filelist[0] ::: custom_style.css
	 * filelist[1] ::: style.css
	 * filelist[2] ::: style.css.map
	 * filelist[3] ::: style.min.css
	 * filelist[4] ::: style.min.css.map
	 * 
	 * @param folderPath		: 폴더경로
	 * @return					: 파일경로의 하위 파일목록 배열
	 */
	public static String[] getSubList(String folderPath) {
		String[] result = null;
		
		folderPath = StringUtil.nvl(folderPath).trim();
		File folder = new File(folderPath);
		
		if(folder.isDirectory() && folder.exists()) {
			result = folder.list();
		}
		
		return result;
	}
	

	/**
	 * 파일 다운로드 셋팅
	 * @param mv
	 * @param downloadFile			: 다운로드 처리할 파일객체.
	 * @param downloadFileName		: 다운로드할 파일명.
	 */
	public static void setFileDown(ModelAndView mv, File downloadFile, String downloadFileName) {
		mv.addObject("downloadFile",downloadFile);
		mv.addObject("downloadFileName",downloadFileName);	
	}
	
	/**
	 * 파일내용을 읽어서 반환.
	 * @param filepath				: 파일경로
	 */
	public static String readFile(String filepath) throws IOException {
		return readFile(filepath, StandardCharsets.UTF_8);
	}
	
	/**
	 * 파일내용을 읽어서 반환.
	 * @param filepath				: 파일경로
	 * @param charset				: StandardCharsets.UTF_8
	 */
	public static String readFile(String filepath, Charset charset) throws IOException {
		List<String> lines = Files.readAllLines(Paths.get(filepath), charset);
		StringBuffer sb = new StringBuffer();
		
		int cnt = 0;
		for (String line : lines) {
			if(cnt > 0) {
				sb.append("\n");
			}
			sb.append(line);
			cnt++;
		}
		
		return sb.toString();
	}
	
	/**
	 * 저장할 파일명을 랜덤시간 함수로 생성해서 문자열로 반환.
	 * @param idx			: 숫자 인덱스값, 아무값이나 숫자 넘기면됨
	 * @param fileExt		: 파일 확장자.
	 */
	public static String getSaveFilename(int idx, String fileExt) {
		StringBuffer sb = new StringBuffer();
		sb.append(String.valueOf(System.currentTimeMillis()));
		sb.append("_");
		sb.append(String.valueOf(idx));
		sb.append(StringUtil.isNotEmpty(fileExt) ? "." : "");
		sb.append(StringUtil.nvl(fileExt));
		return sb.toString().replace(" ","");
	}
	
	/**
	 * 파일 확장자가 업로드 가능한 확장자인지, 환경변수에 허용된 파일확장자에 포함되는지 체크.
	 * @param fileExt		: 업르드 하는 파일 확장자.
	 * @return				: 허용된 확장자면 true, 아니면 false.
	 */
	public static boolean checkUploadFileExt(String fileExt) {
		boolean result = false;
		String[] exts = StringUtil.nvl(PropUtil.UPLOAD_EXTS).split(",");

		fileExt = StringUtil.nvl(fileExt.toLowerCase());
		
		if(StringUtil.isNotEmpty(fileExt) && exts.length > 0) {
			for(int i=0;i<exts.length;i++) {
				String v_ext = exts[i];
				if(fileExt.equals(v_ext)) {
					result = true;
					break;
				}
			}
		}
		
		return result;
	}
	
	/**
	 * 파일명에 특수문자가 포함되어 있는지 체크,
	 * 포함되어 잇으면 false, 없으면 true.
	 * 특수문자 : /\:*?"|
	 * @param fileName		: 파일명
	 */
	public static boolean checkUploadFileName(String fileName) {
		boolean result = false;
		
		if(StringUtil.isNotEmpty(fileName)) {
			result = fileName.matches("^[&.\\\\/:*?\"<>|]?[^\\\\/:*?\"<>|]*");
		}
		
		return result;
	}

}