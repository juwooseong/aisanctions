package egovframework.ui.cmmn;

import java.util.ArrayList;
import java.util.List;

public class ArrayUtil {
	
	public static <T> boolean isEmpty(T[] arr) {
		return arr==null || arr.length == 0;
	}
	
	public static <T> boolean isNotEmpty(T[] arr) {
		return !isEmpty(arr);
	}
	
	/**
	 * 배열에서, 현재 위치 인덱스 기준으로, 다음 항목 len개를 합친 문자열 반환
	 * @param arr	: 배열
	 * @param idx	: 현재위치 인덱스
	 * @param len	: 합쳐질 다음 항목개수
	 */
	public static String nextItem(String[] arr, int idx, int len) {
		StringBuffer result = new StringBuffer();
		
		if(arr!=null && idx > -1 && arr.length > idx && len > 0) {
			int loopCnt = Math.min(len, arr.length - idx - 1);
			for(int i=0;i<loopCnt;i++) {
				result.append(arr[idx + i + 1]);
			}
		}
		
		return result.toString();
	}
	
	/**
	 * 배열에서, 현재 위치 인덱스 기준으로, 이전 항목 len개를 합친 문자열 반환
	 * @param arr	: 배열
	 * @param idx	: 현재위치 인덱스
	 * @param len	: 합쳐질 이전 항목개수
	 */
	public static String prevItem(String[] arr, int idx, int len) {
		StringBuffer result = new StringBuffer();
		
		if(arr!=null && idx > -1 && arr.length > idx && len > 0) {
			int loopCnt = Math.min(len, idx);
			for(int i=0;i<loopCnt;i++) {
				result.append(arr[idx - i - 1]);
			}
		}
		
		return result.reverse().toString();
	}
	
	/**
	 * 배열을 리스트로 전환해서 반환
	 * @param arr	: 리스트로 전환할 배열
	 * @return		: 전환된 리스트
	 */
	public static <T> List<T> arrayToList(T[] arr) {
		List<T> list = null;
		if(arr!=null && arr.length > 0) {
			list = new ArrayList<T>();
			for (T item : arr) {
				list.add(item);
			}
		}
		return list;
	}
	
}