package egovframework.ui.cmmn;

public class XssUtil {

	/**
	 * html 태그 보안 문자열 이스케이프 처리
	 * @param str	: 문자열
	 */
	public static String escapeHtml(String str) {
		String[] entitySrcTxts = new String[] {"&","#","<",">","(",")","&amp;"};
		String[] entityDstTxts = new String[] {"&amp;","&#35;","&lt;","&gt;","&#40;","&#41;","&#38;"};
		
		for(int i=0;i<entitySrcTxts.length;i++) {
			String src = entitySrcTxts[i];
			String dst = entityDstTxts[i];
			str = str.replace(src, dst);
		}
		
		return str;
	}
	
}