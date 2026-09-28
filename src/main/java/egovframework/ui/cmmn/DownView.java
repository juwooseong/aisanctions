package egovframework.ui.cmmn;

import java.io.File;
import java.io.FileInputStream;
import java.io.OutputStream;
import java.net.URLEncoder;
import java.util.Map;
import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.servlet.view.AbstractView;

@Component
public class DownView extends AbstractView {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(DownView.class);

	@Resource(name = "systemFileProperties")
	protected Properties sysProp;
	
	@Override
	protected void renderMergedOutputModel(Map<String,Object>model,
			HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		String mode = StringUtil.nvl(sysProp.getProperty("mode")).trim();
		
		//response.setContentType("application/download; charset=utf-8");
		response.setContentType("application/octet-stream");
		
		File file = null;
		Long fileLength = 0L;
		
		if (model.get("downloadFile") instanceof File) {
			file = (File)model.get("downloadFile");
		}
		
		String downloadFileName = String.valueOf(model.get("downloadFileName"));

		response.setContentType(getContentType());
		
		if (file != null) {
			
			fileLength = file.length();
		}
		
		response.setContentLength(fileLength.intValue());
		
		String userAgent = request.getHeader("User-Agent");
		
		boolean ie = userAgent.indexOf("MSIE") > -1 || userAgent.indexOf("Trident") > -1;
		
		String fileName = downloadFileName;

		if(ie) {
			fileName = URLEncoder.encode(fileName,"utf-8").replace("\\", "%20");
			response.setHeader("Content-Disposition", StringUtil.concat(new String[] {"attachment; filename=",fileName,";"}));
		} else {
			if(mode.equals("dev")) {
				fileName = URLEncoder.encode(fileName,"utf-8").replace("\\", "%20");
			} else if(mode.equals("op")) {
				fileName = URLEncoder.encode(fileName,"utf-8").replace("\\", "%20");
			} else {
				fileName = new String(fileName.getBytes("utf-8"),"iso-8859-1");
			}
			
			response.setHeader("Content-Disposition", StringUtil.concat(new String[] {"attachment; filename=\"",fileName,"\";"}));
		}
		
		response.setHeader("Content-Transfer-Encoding", "binary");
		
		OutputStream out = response.getOutputStream();
		FileInputStream fis = null;
		
		try {
			fis = new FileInputStream(file);
			FileCopyUtils.copy(fis, out);
			
			if(fis!=null) {
				fis.close();
			}
			
		} catch(Exception e) {
			LOGGER.error("Exception ::: " + e);
			FileCopyUtils.copy(fis, out);
			
		} finally {
			if (fis != null) {
				try {
					fis.close();
				} catch (Exception e) {
					LOGGER.error("renderMergedOutputModel" + e);
				}
			}
		}
		
		out.flush();
		out.close();
	}
	
}