package egovframework.ui.cmmn;

import java.util.List;

/**
 * 현재 리스트의 현재참조상태를 저장해서, next 메서드 등을 이용해서 항목들을 참조
 */
public class IndexList<T> {
	private int index = -1;
	private List<T> list;
	
	public IndexList(List<T> p_list) {
		list = p_list;
	}
	
	public int getIndex() {
		return index;
	}
	public void setIndex(int index) {
		this.index = index;
	}
	public List<T> getList() {
		return list;
	}
	public void setList(List<T> list) {
		this.list = list;
	}
	/**
	 * 다음항목 반환
	 */
	public T getNextItem() {
		if(list==null || list.size()==0) {
			return null;
		}
		index++;
		if(index <= (list.size()-1)) {
			return list.get(index);
		} else {
			return null;
		}
	}
	/**
	 * 계속 순환해서, 처음부터 끝까지 돌고나서, 다시 처음으로 돌아가서 순환.
	 */
	public T getRotateItem() {
		if(list==null || list.size()==0) {
			return null;
		}
		if(index >= (list.size()-1)) {
			index = -1;
		}
		return getNextItem();
	}
}