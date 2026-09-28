package egovframework.ui.cmmn;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.web.servlet.ModelAndView;

import com.woori.ajs.model.DefaultVO;

import egovframework.rte.fdl.property.EgovPropertyService;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;

public class ComUtil {
	
	public static PaginationInfo setListPagingInfo(EgovPropertyService propertiesService, DefaultVO searchVO) {

		/** propertiesService */
		searchVO.setPageUnit(propertiesService.getInt("pageUnit"));
		searchVO.setPageSize(propertiesService.getInt("pageSize"));

		/** pageing setting */
		PaginationInfo paginationInfo = new PaginationInfo();
		paginationInfo.setCurrentPageNo(searchVO.getPageIndex());
		paginationInfo.setRecordCountPerPage(searchVO.getRecordCountPerPage());
		paginationInfo.setPageSize(searchVO.getPageSize());

		searchVO.setFirstIndex(paginationInfo.getFirstRecordIndex());
		searchVO.setLastIndex(paginationInfo.getLastRecordIndex());
		searchVO.setRecordCountPerPage(paginationInfo.getRecordCountPerPage());
		
		if(searchVO.getPageIndex() > 1) {
			searchVO.setLastIndex(searchVO.getLastIndex()-1);
		}
		
		return paginationInfo;
	}
	
	/**
	 * 리스트 변수를 널체크해서, 비어있는 리스트값을 반환.
	 */
	public static <T> List<T> checkListNull(List<T> list){
		return list==null ? (new ArrayList<T>()) : list;
	}
	
	public static int toInt(String num) {
		return Integer.parseInt(StringUtil.nvl(num,"0"));
	}
	public static int toInt(Object num) {
		return Integer.parseInt(StringUtil.nvl(num,"0"));
	}
	public static long toLong(String num) {
		return Long.parseLong(StringUtil.nvl(num,"0"));
	}
	public static long toLong(Object num) {
		return Long.parseLong(StringUtil.nvl(num,"0"));
	}
	public static float toFloat(String num) {
		return Float.parseFloat(StringUtil.nvl(num,"0.0"));
	}
	public static float toFloat(Object num) {
		return Float.parseFloat(StringUtil.nvl(num,"0.0"));
	}
	public static double toDbl(String num) {
		return Double.parseDouble(StringUtil.nvl(num,"0.0"));
	}
	public static double toDbl(Object num) {
		return Double.parseDouble(StringUtil.nvl(num,"0.0"));
	}
	
	public static int rand(int min, int max) {
		int result = 0;
		if(min==max) {
			result = min;
		} else if(min > max) {
			result = 0;
		} else {
			result = Long.valueOf(Math.round(Math.random() * (max - min + 1))).intValue() + min;
			result = Math.min(max, result);
		}
		return result;
	}
	
	public static String getUrl(HttpServletRequest request) {
		return request.getRequestURL().toString().toLowerCase();
	}
	
	/**
	 * 알럿을 출력하면서 팝업을 닫는 설정을 하는 함수.
	 * @param mv			: 모델객체
	 * @param msg			: 출력할 메세지
	 * @param closeYN		: 닫기여부, 기본 Y
	 * @return				: 파라미터로 넘긴 모델객체
	 */
	public static ModelAndView alertClose(ModelAndView mv, String msg) {
		alertClose(mv, msg, "Y");
		return mv;
	}
	
	/**
	 * 알럿을 출력하면서 팝업을 닫는 설정을 하는 함수.
	 * @param mv			: 모델객체
	 * @param msg			: 출력할 메세지
	 * @param closeYN		: 닫기여부, 기본 Y
	 * @return				: 파라미터로 넘긴 모델객체
	 */
	public static ModelAndView alertClose(ModelAndView mv, String msg, String closeYN) {
		closeYN = StringUtil.nvl(closeYN,"N").equals("Y") ? "Y" : "N";
		
		mv.addObject("msg",msg);
		mv.addObject("closeYN",closeYN);
		mv.setViewName("full/common/msg");
		
		return mv;
	}
	
	public static int intZero() {
		return 0;
	}
	
}