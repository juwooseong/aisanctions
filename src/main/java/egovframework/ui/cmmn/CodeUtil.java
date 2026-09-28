package egovframework.ui.cmmn;

import java.util.List;

import com.woori.ajs.model.CommonCodeVO;

public class CodeUtil {
	
	/**
	 * 코드목록에서 특정 코드값에 해당하는 코드명을 반환
	 * @param codeList			: 코드목록
	 * @param code				: 찾을코드값
	 */
	public static String getVal(List<CommonCodeVO> codeList, String code) {
		return getVal(codeList, code, 1);
	}
	
	/**
	 * 코드목록에서 특정 코드값에 해당하는 코드명을 반환
	 * @param codeList			: 코드목록
	 * @param code				: 찾을코드값
	 * @param opt				: 옵션, 1 - 한글코드명, 2 - 영문코드명
	 */
	public static String getVal(List<CommonCodeVO> codeList, String code, int opt) {
		String result = "";
		
		if(codeList!=null && codeList.size() > 0) {
			for(int i=0;i<codeList.size();i++) {
				CommonCodeVO row = codeList.get(i);
				if(StringUtil.isEquals(row.getAiInptCmnCd(), code)) {
					if(opt == 1) {
						result = row.getAiInptCmnCdNm();
					} else {
						result = row.getAiInptCmnCdEngNm();
					}
					break;
				}
			}
		}
		
		return result;
	}

	/**
	 * 코드목록에서 특정 코드에 해당하는 항목을 반환.
	 * @param codeList		: 코드목록
	 * @param code			: 코드문자열
	 * @return				: 코드항목객체
	 */
	public static CommonCodeVO getItem(List<CommonCodeVO> codeList, String code) {
		CommonCodeVO result = null;
		
		if(codeList!=null && codeList.size() > 0) {
			for(int i=0;i<codeList.size();i++) {
				CommonCodeVO row = codeList.get(i);
				if(StringUtil.isEquals(row.getAiInptCmnCd(), code)) {
					result = row;
					break;
				}
			}
		}
		
		return result;
	}
	
}