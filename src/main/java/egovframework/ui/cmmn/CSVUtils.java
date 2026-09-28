package egovframework.ui.cmmn;

import java.io.InputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Scanner;

public class CSVUtils {
	private static final char DEFAULT_SEPARATOR = ',';
	private static final char DEFAULT_QUOTE = '"';
	private static final int DEFAULT_LINE_NUMBER = 1;
	private static final String DEFAULT_TYPE = "VARCHAR";
	private static final String INTEGER_TYPE = "INTEGER";
	
	public static boolean isStringInt(String s)
	{
	    try
	    {
	        Integer.parseInt(s);
	        return true;
	    } catch (NumberFormatException ex)
	    {
	        return false;
	    }
	}
	
	public static Map<String, Object> print(InputStream is) throws Exception {
		Map<String, Object> map = new HashMap<>();
		
		List<String> typeList = new ArrayList<>();
		List<String> columnList = new ArrayList<>();

		//		Scanner scanner = new Scanner(new File(csvFile));
		Scanner scanner = new Scanner(is);
		int lineNumber = DEFAULT_LINE_NUMBER;
		while (scanner.hasNext()) {
			List<String> line = parseLine(scanner.nextLine());
			
			typeList = new ArrayList<>();
			for(String str : line) {
				
				if(lineNumber == DEFAULT_LINE_NUMBER) {
					columnList.add(str);
				}else {
					if(isStringInt(str)) {
						typeList.add(INTEGER_TYPE);
					}else {
						typeList.add(DEFAULT_TYPE);
					}
				}
			}
			
			// 최초 2줄만 파악하고 리턴
			if(++lineNumber == 3) {
				break;
			}
		}
		scanner.close();
		
		map.put("columnList", columnList);
		map.put("typeList", typeList);
		return map;
	}

	public static List<String> parseLine(String cvsLine) {
		return parseLine(cvsLine, DEFAULT_SEPARATOR, DEFAULT_QUOTE);
	}

	public static List<String> parseLine(String cvsLine, char separators) {
		return parseLine(cvsLine, separators, DEFAULT_QUOTE);
	}

	public static List<String> parseLine(String cvsLine, char separators, char customQuote) {

		List<String> result = new ArrayList<>();

		// if empty, return!
		if (cvsLine == null || cvsLine.isEmpty()) {
			return result;
		}

		if (customQuote == ' ') {
			customQuote = DEFAULT_QUOTE;
		}

		if (separators == ' ') {
			separators = DEFAULT_SEPARATOR;
		}

		StringBuffer curVal = new StringBuffer();
		boolean inQuotes = false;
		boolean startCollectChar = false;
		boolean doubleQuotesInColumn = false;

		char[] chars = cvsLine.toCharArray();

		for (char ch : chars) {

			if (inQuotes) {
				startCollectChar = true;
				if (ch == customQuote) {
					inQuotes = false;
					doubleQuotesInColumn = false;
				} else {

					// Fixed : allow "" in custom quote enclosed
					if (ch == '\"') {
						if (!doubleQuotesInColumn) {
							curVal.append(ch);
							doubleQuotesInColumn = true;
						}
					} else {
						curVal.append(ch);
					}

				}
			} else {
				if (ch == customQuote) {

					inQuotes = true;

					// Fixed : allow "" in empty quote enclosed
					if (chars[0] != '"' && customQuote == '\"') {
						curVal.append('"');
					}

					// double quotes in column will hit this!
					if (startCollectChar) {
						curVal.append('"');
					}

				} else if (ch == separators) {

					result.add(curVal.toString());

					curVal = new StringBuffer();
					startCollectChar = false;

				} else if (ch == '\r') {
					// ignore LF characters
					continue;
				} else if (ch == '\n') {
					// the end, break!
					break;
				} else {
					curVal.append(ch);
				}
			}

		}

		result.add(curVal.toString());

		return result;
	}
}
