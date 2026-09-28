package egovframework.ui.cmmn;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.Locale;

import org.springframework.util.StringUtils;

public class DateUtil {
	/**
	 * 시간단위, 날짜 더하기 등.
	 */
	public static enum TIME_UNIT {
		YEAR, 
		MON, 
		DAY, 
		HOUR, 
		MIN, 
		SEC
	}
	
	/**
	 * 오늘날짜 문자열 반환. (20190807)
	 */
	public static String getToday() {
		return getFormatDate("yyyyMMdd");
	}
	
	/**
	 * 현재시간을 특정포맷 문자열로 변환
	 * @param d					: 날짜객체
	 * @param dateFormat		: yyyyMMddHHmmss
	 * @return
	 */
	public static String getFormatDate(String dateFormat) {
		Date d = new Date();
		return getFormatDate(d, dateFormat);
	}
	
	/**
	 * 특정 날짜값을 특정포맷 문자열로 변환
	 * @param d					: 날짜객체
	 * @param dateFormat		: yyyyMMddHHmmss
	 * @return
	 */
	public static String getFormatDate(Date d, String dateFormat) {
		String result = null;
		
		if(d!=null && !StringUtils.isEmpty(dateFormat)) {
			SimpleDateFormat sf = new SimpleDateFormat(dateFormat, Locale.KOREA);
			result = sf.format(d);
		}
		
		return result;
	}
	
	/**
	 * 날짜 더하기 빼기
	 * @param d					: 기준일시
	 * @param amount			: 더하기 빼기할 숫자
	 * @param timeUnit			: 더하기 빼기할 날짜 단위, DateUtil.TIME_UNIT.MON
	 * @return					: 더하기 빼기한 날짜 객체
	 */
	public static Date getDateAdd(Date d, int amount, TIME_UNIT timeUnit) {
		Calendar cal = Calendar.getInstance();
		cal.setTime(d);
		
		if(TIME_UNIT.YEAR == timeUnit) {
			cal.add(Calendar.YEAR, amount);
		} else if(TIME_UNIT.MON == timeUnit) {
			cal.add(Calendar.MONTH, amount);
		} else if(TIME_UNIT.DAY == timeUnit) {
			cal.add(Calendar.DATE, amount);
		} else if(TIME_UNIT.HOUR == timeUnit) {
			cal.add(Calendar.HOUR, amount);
		} else if(TIME_UNIT.MIN == timeUnit) {
			cal.add(Calendar.MINUTE, amount);
		} else if(TIME_UNIT.SEC == timeUnit) {
			cal.add(Calendar.SECOND, amount);
		} else {
			return null;
		}
		
		return cal.getTime();
	}
	
	/**
	 * 날짜를 더하기 빼기해서, 날짜포맷을 문자열로 반환
	 * @param d					: 날짜객체, new Date();
	 * @param amount			: 더하기 빼기 숫자
	 * @param timeUnit			: 더하기 빼기 날짜 단위, DateUtil.TIME_UNIT.MON
	 * @param dateFormat		: "yyyyMMddhhmmss"
	 * @return
	 */
	public static String getFormatDateAdd(Date d, int amount, TIME_UNIT timeUnit, String dateFormat) {
		String date = "";
		Date d2 = getDateAdd(d, amount, timeUnit);
		date = getFormatDate(d2,dateFormat);
		return date;
	}
	
	/**
	 * 현재 시간에서 날짜를 더하기 빼기해서, 날짜포맷을 문자열로 반환
	 * @param amount			: 더하기 빼기 숫자
	 * @param timeUnit			: 더하기 빼기 날짜 단위, DateUtil.TIME_UNIT.MON
	 * @param dateFormat		: "yyyyMMddhhmmss"
	 * @return
	 */
	public static String getFormatDateAdd(int amount, TIME_UNIT timeUnit, String dateFormat) {
		return getFormatDateAdd(new Date(), amount, timeUnit, dateFormat);
	}
	
}