package egovframework.ui.cmmn;

import java.io.File;

public class StringUtil {
	
	public static String nvl(Object str) {
		return nvl(str.toString(),"");
	}
	
	public static String nvl(Object str, String rep) {
		return nvl(str.toString(),rep);
	}
	
	public static String nvl(String str) {
		return nvl(str,"");
	}
	
	public static String nvl(String str, String rep) {
		return str==null ? rep : str;
	}

	public static String nvl2(Object str) {
		String str2 = nvl2(str.toString(),"");
		if(str2.trim().equals("")) {
			str2 = "";
		}
		return str2;
	}
	
	public static String nvl2(Object str, String rep) {
		return nvl2(str.toString(),rep);
	}
	
	public static String nvl2(String str) {
		return nvl2(str,"");
	}
	
	public static String nvl2(String str, String rep) {
		String str2 = str==null ? rep : str;
		if(str2.trim().equals("")) {
			str2 = rep;
		}
		return str2;
	}

	/**
	 * 두개의 경로 문자열을 하나의 경로로 병합.
	 * 
	 * @param path1
	 * @param path2
	 * @param seperator
	 * @return
	 */
	public static String combinePath(String path1, String path2) {
		return combinePath(path1, path2, File.separator);
	}
	
	/**
	 * 두개의 경로 문자열을 하나의 경로로 병합.
	 * 
	 * @param path1
	 * @param path2
	 * @param seperator
	 * @return
	 */
	public static String combinePath(String path1, String path2, String seperator) {
		String result = "";
		StringBuffer resultSb = new StringBuffer();
		
		path1 = nvl(path1);
		path2 = nvl(path2);
		seperator = nvl(seperator);
		
		//result = path1 + seperator + path2;
		resultSb.append(path1).append(seperator).append(path2);
		result = resultSb.toString();
		
		result = result.replace(seperator+seperator, seperator);
		result = result.replace(seperator+seperator, seperator);
		
		return result;
	}

	public static boolean isEmpty(String str) {
		return nvl(str).trim().equals("");
	}

	public static boolean isEmpty(Object str) {
		return isEmpty(nvl(str));
	}

	public static boolean isNotEmpty(String str) {
		return !isEmpty(nvl(str));
	}

	public static boolean isNotEmpty(Object str) {
		return !isEmpty(nvl(str));
	}
	
	public static String joinArray(String[] arr) {
		return joinArray(arr,",");
	}
	
	public static String joinArray(String[] arr, String deli) {
		StringBuffer sb = new StringBuffer();
		
		deli = nvl(deli);
		
		if(arr!=null) {
			for(int i=0;i<arr.length;i++) {
				sb.append(concat(new String[] {i > 0 ? deli : "", String.valueOf(arr[i])}));
			}
		}
		
		return sb.toString();
	}

	public static String joinArray(int[] arr, String deli) {
		StringBuffer sb = new StringBuffer();
		
		deli = nvl(deli);
		
		if(arr!=null) {
			for(int i=0;i<arr.length;i++) {
				sb.append(concat(new String[] {i > 0 ? deli : "", String.valueOf(arr[i])}));
			}
		}
		
		return sb.toString();
	}

	public static String joinArray(int[] arr) {
		return joinArray(arr,",");
	}
	
	public static boolean isEquals(String str1, String str2) {
		return nvl(str1).equals(nvl(str2));
	}
	
	public static boolean isNotEquals(String str1, String str2) {
		return !isEquals(str1, str2);
	}
	
	/**
	 * 문자열 붙이기 함수
	 * StringUtil.concat(new String[] {"1","2","3",...});
	 * @param str		: 문자열 파라미터 다수
	 */
	public static String concat(String[] str) {
		if(str==null) {
			return null;
		}
		
		StringBuffer sb = new StringBuffer();
		for (String item : str) {
			sb.append(item);
		}
		
		return sb.toString();
	}
	
	/**
	 * 문자열 비교 유사도 구하기
	 * 기준단어의 글자들이 추출단어에서 몇개나 일치하는지 일치율을 추출.
	 * 기준단어를 한글자씩 루프를 돌면서, 대상단어를 검색해서, 있으면 일치수 증가.
	 * 단, 대상단어를 검색할때, 기준단어의 이전단어 검색된 위치의 다음위치부터 검색을 해나감.
	 * 기준단어의 순서보장.
	 * 예) 기준단어 : 고려, 대상단어 : 고오려(일치), 고려(일치), 려고(불일치), ...
	 * @param str1 		: 기준단어 (제재단어 등)
	 * @param str2 		: 비교대상 단어(추출단어)
	 * @return			: 최대 유사율을 반환.
	 */
	public static double wordSimRate(String str1, String str2) {
		double v_rate = 0.0;
		
		if(StringUtil.isNotEmpty(str1) && StringUtil.isNotEmpty(str2)) {
			int v_cnt					= 0;
			int v_pos					= -1;
			String v_base_word			= "";
			int v_base_word_len			= 0;
			String v_base_char			= "";
			String v_tgt_word			= "";
			
			v_base_word				= str1.trim().toLowerCase();
			v_base_word_len			= v_base_word.length();
			v_tgt_word 				= str2.trim().toLowerCase();
			
			//두 단어가 완전 일치하면 100% 일치율.
			if(v_base_word.equals(v_tgt_word)) {
				return 100.0;
			}
			
			//기준단어의 글자들이 비교대상단어에 일치하는 단어의 개수를 추출. 
			for(int i=0;i<v_base_word_len;i++) {
				v_base_char = str1.substring(i,i+1);
				v_pos = v_tgt_word.indexOf(v_base_char,v_pos + 1);
				
				if(v_pos!=-1) {
					v_cnt++;
				}
			}
			
			//일치하는 글자개수가 한개이상이면, 전체 글자수로 나누어서, 일치비율을 구함.
			if(v_cnt > 0) {
				v_rate = (CastUtil.intToDbl(v_cnt) / CastUtil.intToDbl(v_base_word_len)) * 100.0;
				Double.valueOf(String.valueOf(v_cnt));
				v_rate = Math.round(v_rate * 100.0) / 100.0;		//소수점 두번째에서 반올림
			}
		}
		
		return v_rate;
	}
	
	/**
	 * 사용자이름의 중간에 O표시를 하고, 앞과 뒷글자만 보여줌.
	 * @param userNm	: 사용자명 (홍길동)
	 * @return			: 숨김문자열 (홍O동)
	 */
	public static String getUserNm(String userNm) {
		String result = "";
		
		if(isNotEmpty(userNm)) {
			int userLen = Math.max(userNm.length() - 2, 1);
			
			if(userNm.length() >= 3) {
				result = concat(new String[]{
					userNm.substring(0,1),
					"OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO".substring(0,userLen),
					userNm.substring(userNm.length()-1)});
			} else if(userNm.length() == 2) {
				result = concat(new String[]{userNm.substring(0,1),"O"});
			} else {
				result = userNm;
			}
		}
		
		return result;
	}

}