package egovframework.ui.cmmn;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.woori.ajs.model.FileVO;
import com.woori.ajs.model.FilesVO;

public class JsonUtil {

	/**
	 * Json파일 업로드를 하고서, Json업로드 경로로 파일을 이동시킴.
	 */
	public static List<File> getUploadedJsonFileList(MultipartHttpServletRequest mreq, String uploadPath) throws Exception {
		return getUploadedJsonFileList(mreq, uploadPath, "upfile");
	}
	
	/**
	 * Json파일 업로드를 하고서, Json업로드 경로로 파일을 이동시킴.
	 */
	public static List<File> getUploadedJsonFileList(MultipartHttpServletRequest mreq, String uploadPath, String formName) throws Exception {
		List<File> result = new ArrayList<File>();
		
		uploadPath = StringUtil.nvl(uploadPath).trim();
		formName = StringUtil.nvl(formName).trim();
		
		if(uploadPath.equals("")) {
			return result;
		}
		
		String jsonPath = StringUtil.combinePath(uploadPath, "json");
		
		List<HashMap<String,String>> files = FileUtil.uploadFiles(mreq, uploadPath, "tmp", formName);
		if(files!=null) {
			for(int i=0;i<files.size();i++) {
				FileVO info = new FileVO(files.get(i));
				File file = new File(StringUtil.combinePath(uploadPath, info.getUploadUrl()));
				String fileName = StringUtil.concat(new String[] {DateUtil.getFormatDate("yyyyMMdd"),"_",info.getFileSaveName()});
				String fileExt = FileUtil.getFileExt(fileName).trim().toLowerCase();
				String filepath = StringUtil.combinePath(jsonPath, fileName);
				File jsonFile = new File(filepath);
				
				if(!fileExt.equals("json")) {
					continue;
				}
				
				if(file.renameTo(jsonFile)) {
					result.add(jsonFile);
				}
			}
		}
		
		return result;
	}

	/**
	 * Json파일 업로드를 하고서, Json업로드 경로로 파일을 이동시킴.
	 */
	public static FilesVO getUploadedJsonFileList2(MultipartHttpServletRequest mreq, String uploadPath) throws Exception {
		return getUploadedJsonFileList2(mreq, uploadPath, "upfile");
	}
	
	/**
	 * Json파일 업로드를 하고서, Json업로드 경로로 파일을 이동시킴.
	 */
	public static FilesVO getUploadedJsonFileList2(MultipartHttpServletRequest mreq, String uploadPath, String formName) throws Exception {
		FilesVO result = new FilesVO();
		
		uploadPath = StringUtil.nvl(uploadPath).trim();
		formName = StringUtil.nvl(formName).trim();
		
		if(uploadPath.equals("")) {
			return result;
		}
		
		String jsonPath = StringUtil.combinePath(uploadPath, "json");
		
		List<HashMap<String,String>> files1 = new ArrayList<HashMap<String,String>>();
		List<FileVO> files2 = new ArrayList<FileVO>();
		List<File> files3 = new ArrayList<File>();

		List<HashMap<String,String>> files = FileUtil.uploadFiles(mreq, uploadPath, "tmp", formName);
		if(files!=null) {
			for(int i=0;i<files.size();i++) {
				HashMap<String,String> row = files.get(i);
				FileVO info = new FileVO(row);
				File file = new File(StringUtil.combinePath(uploadPath, info.getUploadUrl()));
				String fileName = StringUtil.concat(new String[] {DateUtil.getFormatDate("yyyyMMdd"),"_",info.getFileSaveName()});
				String fileExt = FileUtil.getFileExt(fileName).trim().toLowerCase();
				String filepath = StringUtil.combinePath(jsonPath, fileName);
				File jsonFile = new File(filepath);
				
				if(!fileExt.equals("json")) {
					continue;
				}
				
				if(file.renameTo(jsonFile)) {
					files1.add(row);
					files2.add(info);
					files3.add(jsonFile);
				}
			}
		}
		
		result.setFiles(files1);
		result.setFiles2(files2);
		result.setFiles3(files3);
		
		return result;
	}
	
}