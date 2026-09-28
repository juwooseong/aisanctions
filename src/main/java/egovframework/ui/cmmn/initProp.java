package egovframework.ui.cmmn;

import java.io.Reader;
import java.util.Properties;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.apache.ibatis.io.Resources;

public final class initProp {
	private static final Logger LOGGER = LoggerFactory.getLogger(PropUtil.class);
	public String mode;					
	public String mode_name;			
	public String domain;			
	public String portal_login;		
	public String portal_prc;		
	public String check_approve_yn;	
	public String bpr_url;			
	public String upload_path;			
	public String upload_path_down;		
	public String upload_url;		
	public String upload_exts;			
	public long upload_max_size;		
	public String img_url;		
	public String extraction_url;	
	public String inspection_url;
	public String grid_height;		
	public String api_file_upload_url;	
	public String api_file_download_url;
	public String api_file_delete_url;	
	public String enc_key;

	public final String getMode() {
		return mode;
	}


	public void setMode(String mode) {
		this.mode = mode;
	}


	public final String getMode_name() {
		return mode_name;
	}


	public void setMode_name(String mode_name) {
		this.mode_name = mode_name;
	}


	public final String getDomain() {
		return domain;
	}


	public void setDomain(String domain) {
		this.domain = domain;
	}


	public final String getPortal_login() {
		return portal_login;
	}


	public void setPortal_login(String portal_login) {
		this.portal_login = portal_login;
	}


	public final String getPortal_prc() {
		return portal_prc;
	}


	public void setPortal_prc(String portal_prc) {
		this.portal_prc = portal_prc;
	}


	public final String getCheck_approve_yn() {
		return check_approve_yn;
	}


	public void setCheck_approve_yn(String check_approve_yn) {
		this.check_approve_yn = check_approve_yn;
	}


	public final String getBpr_url() {
		return bpr_url;
	}


	public void setBpr_url(String bpr_url) {
		this.bpr_url = bpr_url;
	}


	public final String getUpload_path() {
		return upload_path;
	}


	public void setUpload_path(String upload_path) {
		this.upload_path = upload_path;
	}


	public final String getUpload_path_down() {
		return upload_path_down;
	}


	public void setUpload_path_down(String upload_path_down) {
		this.upload_path_down = upload_path_down;
	}


	public final String getUpload_url() {
		return upload_url;
	}


	public void setUpload_url(String upload_url) {
		this.upload_url = upload_url;
	}


	public final String getUpload_exts() {
		return upload_exts;
	}


	public void setUpload_exts(String upload_exts) {
		this.upload_exts = upload_exts;
	}


	public final long getUpload_max_size() {
		return upload_max_size;
	}


	public void setUpload_max_size(long upload_max_size) {
		this.upload_max_size = upload_max_size;
	}


	public final String getImg_url() {
		return img_url;
	}


	public void setImg_url(String img_url) {
		this.img_url = img_url;
	}


	public final String getExtraction_url() {
		return extraction_url;
	}


	public void setExtraction_url(String extraction_url) {
		this.extraction_url = extraction_url;
	}


	public final String getInspection_url() {
		return inspection_url;
	}


	public void setInspection_url(String inspection_url) {
		this.inspection_url = inspection_url;
	}


	public final String getGrid_height() {
		return grid_height;
	}


	public void setGrid_height(String grid_height) {
		this.grid_height = grid_height;
	}


	public final String getApi_file_upload_url() {
		return api_file_upload_url;
	}


	public void setApi_file_upload_url(String api_file_upload_url) {
		this.api_file_upload_url = api_file_upload_url;
	}


	public final String getApi_file_download_url() {
		return api_file_download_url;
	}


	public void setApi_file_download_url(String api_file_download_url) {
		this.api_file_download_url = api_file_download_url;
	}


	public final String getApi_file_delete_url() {
		return api_file_delete_url;
	}


	public void setApi_file_delete_url(String api_file_delete_url) {
		this.api_file_delete_url = api_file_delete_url;
	}


	public final String getEnc_key() {
		return enc_key;
	}


	public void setEnc_key(String enc_key) {
		this.enc_key = enc_key;
	}


	public static Logger getLogger() {
		return LOGGER;
	}


	public void initProp(int kind, String filePath) {
		Reader reader = null;
		Properties prop = null;
		
		try {
			reader = Resources.getResourceAsReader(filePath);
			prop = new Properties();
			prop.load(reader);
			
			if(kind==1) {
				setMode(StringUtil.nvl(prop.getProperty("mode")));
				setMode_name(StringUtil.nvl(prop.getProperty("modeName")));
				setDomain(StringUtil.nvl(prop.getProperty("domain")));
				setPortal_login	(StringUtil.nvl(prop.getProperty("portal.login")));
				setPortal_prc(StringUtil.nvl(prop.getProperty("portal.prc")));
				setCheck_approve_yn(StringUtil.nvl(prop.getProperty("check.approve.yn")));
				setBpr_url(StringUtil.nvl(prop.getProperty("bpr.url")));
				setUpload_path(StringUtil.nvl(prop.getProperty("upload.path")));
				setUpload_path_down(StringUtil.nvl(prop.getProperty("upload.path.down")));
				setUpload_url(StringUtil.nvl(prop.getProperty("upload.url")));
				setUpload_exts(StringUtil.nvl(prop.getProperty("upload.exts")));
				setUpload_max_size(Long.valueOf(StringUtil.nvl(prop.getProperty("upload.maxSize"),"0")));
				setImg_url(StringUtil.nvl(prop.getProperty("img.url")));
				setExtraction_url(StringUtil.nvl(prop.getProperty("extraction.url")));
				setInspection_url(StringUtil.nvl(prop.getProperty("inspection.url")));
				setGrid_height(StringUtil.nvl(prop.getProperty("grid.height")));
				setApi_file_upload_url(StringUtil.nvl(prop.getProperty("file.upload")));
				setApi_file_download_url(StringUtil.nvl(prop.getProperty("file.download")));
				setApi_file_delete_url(StringUtil.nvl(prop.getProperty("file.delete")));
				setEnc_key(StringUtil.nvl(prop.getProperty("sso.enc.key")));
			}
			
		} catch (Exception e) {
			LOGGER.debug(e.getMessage());
		} finally {
			try {
				if(reader!=null) {
					reader.close();
				}
			}catch(Exception e) {
				LOGGER.debug(e.getMessage());
			}
		}
	}
	
	public initProp() {
		super();
		//initProp ipn = new initProp();
		this.initProp(1,"egovframework/properties/system.properties");
	}
}
