package egovframework.ui.cmmn;

/**
 * properties 파일들을 읽어들여서, 설정변수에 저장.
 * static 메서드 및 일반 클래스 들에서 모두 사용가능.
 */
public class PropUtil {
	static final initProp iprop = new initProp();
	public static final String MODE = iprop.getMode();

	public static final String MODE_NAME = iprop.getMode_name();
	public static final String DOMAIN = iprop.getDomain();
	public static final String PORTAL_LOGIN = iprop.getPortal_login();
	public static final String PORTAL_PRC = iprop.getPortal_prc();
	public static final String CHECK_APPROVE_YN = iprop.getCheck_approve_yn();
	public static final String UPLOAD_PATH = iprop.getUpload_path();
	public static final String UPLOAD_URL = iprop.getUpload_url();
	public static final String UPLOAD_EXTS = iprop.getUpload_exts();
	public static final String BPR_URL = iprop.getBpr_url();
	public static final String IMG_URL = iprop.getImg_url();
	public static final String EXTRACTION_URL = iprop.getExtraction_url();
	public static final String INSPECTION_URL = iprop.getInspection_url();
	public static final String GRID_HEIGHT = iprop.getGrid_height();
	public static final long   UPLOAD_MAX_SIZE = iprop.getUpload_max_size();
	public static final String API_FILE_UPLOAD_URL = iprop.getApi_file_upload_url();
	public static final String API_FILE_DOWNLOAD_URL = iprop.getApi_file_download_url();
	public static final String API_FILE_DELETE_URL = iprop.getApi_file_delete_url();
	public static final String ENC_KEY = iprop.getEnc_key();
	//public static final String PROXY_URL = iprop.getPr;
	public static final String UPLOAD_PATH_DOWN = iprop.getUpload_path_down();
	/**
	 * 프로퍼티 파일 로드처리.
	 * @param kind			: 1 ~ , 파일구분
	 * @param filePath		: properties 파일 경로
	 */

}