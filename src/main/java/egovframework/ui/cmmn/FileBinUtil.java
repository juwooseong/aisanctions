package egovframework.ui.cmmn;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;

import org.apache.commons.codec.binary.Base64;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * 파일을 바이너리 문자열로 변환하고,
 * 변환했던 바이너리 문자열을 다시 파일로 변환하는 모듈
 * commons-codec.jar 파일 이용
 */
public class FileBinUtil {
	private static final Logger LOGGER = LoggerFactory.getLogger(FileBinUtil.class);
	
	/**
	 * 파일을 바이너리 스트링으로 변환
	 * @param file		: 변환할 파일 객체
	 * @return			: 변환한 파일 문자열
	 */
	public static String fileToBinary(File file) {
		if(file==null) {
			return null;
		}
		
		String out = "";
		FileInputStream fis = null;
		ByteArrayOutputStream baos = new ByteArrayOutputStream();
		
		try {
			fis = new FileInputStream(file);
			int len = 0;
			byte[] buf = new byte[1024];
					
			len = fis.read(buf);
			while(len!=-1) {
				baos.write(buf, 0, len);
				len = fis.read(buf);
			}
			
			byte[] fileArray = baos.toByteArray();
			out = new String(base64Enc(fileArray));
			
			
		} catch(FileNotFoundException e) {
			LOGGER.debug("Exception position : FileBinUtil - fileToString(File file)");
		} catch(IOException e) {
			LOGGER.debug("Exception position : FileBinUtil - fileToString(File file)");
		} finally {
			
			try {
				if (fis!=null) {
					fis.close();
				}
			} catch (IOException e) {
				// TODO Auto-generated catch block
				LOGGER.error("Exception ::: " + e);
			}
			try {
				if (baos!=null) {
					baos.close();
				}
			} catch (IOException e) {
				// TODO Auto-generated catch block
				LOGGER.error("Exception ::: " + e);
			}
		}
		
		return out;
	}
	
	/**
	 * 바이너리 스트링을 파일로 변환
	 * 
	 * @param binaryFile	: 바이너리로 변환된 파일 문자열
	 * @param filePath		: 저장할 파일 폴더경로
	 * @param fileName		: 저장할 파일명
	 * @return				: 저장된 파일 객체
	 */
	public static File binaryToFile(String binaryFile, String filePath, String fileName) {
		if((binaryFile==null || "".equals(binaryFile)) || (filePath==null || "".equals(filePath)) || (fileName==null || "".equals(fileName))) {
			return null;
		}
		
		FileOutputStream fos = null;
		
		File fileDir = new File(filePath);
		if(!fileDir.exists()) {
			fileDir.mkdirs();
		}
		String fileFullPath = StringUtil.combinePath(filePath, fileName);
		File destFile = new File(fileFullPath);
		
		byte[] buff = binaryFile.getBytes();
		String toStr = new String(buff);
		byte[] b64dec = base64Dec(toStr);
		
		try {
			fos = new FileOutputStream(destFile);
			fos.write(b64dec);
		} catch(IOException e) {
			LOGGER.debug("Exception position : FileBinUtil - binaryToFile(String binaryFile, String filePath, String fileName)");
		} finally {
			try {
				if(fos!=null) {
					fos.close();
				}
			} catch (IOException e) {
				// TODO Auto-generated catch block
				LOGGER.error("Exception ::: " + e);
			}
		}
		
		return destFile;
	}
	
	public static byte[] base64Enc(byte[] buffer) {
		return Base64.encodeBase64(buffer);
	}
	
	public static byte[] base64Dec(String buffer) {
		return Base64.decodeBase64(buffer);
	}
	
}