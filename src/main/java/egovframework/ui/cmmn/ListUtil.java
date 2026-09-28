package egovframework.ui.cmmn;

import java.util.List;

public class ListUtil {
	
	/**
	 * 리스트에서 항목을 추출해서 반환, 해당 추출된 항목은 삭제됨.
	 * @param list		: 리스트
	 * @param idx		: 추출할 번호
	 * @return
	 */
	public static <T> T pop(List<T> list, int idx){
		if(list==null || list.size()==0 || (list.size()-1)<=idx) {
			return null;
		}
		T item = list.get(idx);
		list.remove(idx);
		return item;
	}
	
	/**
	 * 리스트에서 마지막 항목을 추출해서 반환, 해당 추출된 항목은 삭제됨.
	 * @param list		: 리스트
	 * @return
	 */
	public static <T> T pop(List<T> list){
		if(list==null || list.size()==0) {
			return null;
		}
		return pop(list,list.size()-1);
	}
	
	/**
	 * 리스트에서 랜덤으로 항목을 추출해서 반환, 해당 추출된 항목은 삭제됨.
	 * @param list		: 리스트
	 * @return
	 */
	public static <T> T popRand(List<T> list){
		if(list == null || list.size() == 0) {
			return null;
		}
		if(list.size() == 1) {
			return list.get(0);
		}
		int idx = ComUtil.rand(0, list.size()-1);
		return pop(list, idx);
	}
	
}