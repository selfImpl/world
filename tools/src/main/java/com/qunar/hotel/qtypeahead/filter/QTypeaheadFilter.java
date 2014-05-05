package com.qunar.hotel.qtypeahead.filter;

import org.apache.commons.lang.StringUtils;

import com.qunar.hotel.qtypeahead.util.NormalizeUtil;

public class QTypeaheadFilter {

	/**
	 * 判断是否乱码。 除了中文+英文+数字+符号+空格外的字符占总长度的比例不能超过limit。
	 * 
	 * @param str
	 *            需判断的字符串
	 * @param limit
	 *            阀值
	 * @return
	 */
	public static boolean isMessy(String str, double limit) {
		if (StringUtils.isEmpty(str))
			return true;
		boolean ret = false;
		int cnt = 0;
		for (int i = 0; i < str.length(); i++) {
			char s = str.charAt(i);
			if (!NormalizeUtil.isChineseChar(s)
					&& !NormalizeUtil.isDigitOrEngilishChar(s)
					&& !NormalizeUtil.isPunctuationChar(s) && s != ' ') {
				cnt++;
			}
		}
		if (1.0 * cnt / str.length() > limit) {
			ret = true;
		}
		return ret;
	}

	/**
	 * 判断是否太多标点,数字或空格。
	 * 
	 * @param str
	 *            需判断的字符串
	 * @param limit
	 *            阀值
	 * @return
	 */
	public static boolean isTooManyPunctuation(String str, double limit) {
		if (StringUtils.isEmpty(str))
			return true;
		boolean ret = false;
		int cnt = 0;
		for (int i = 0; i < str.length(); i++) {
			char s = str.charAt(i);
			if (NormalizeUtil.isDigit(s) || NormalizeUtil.isPunctuationChar(s)
					|| s == ' ') {
				cnt++;
			}
		}
		if (1.0 * cnt / str.length() > limit) {
			ret = true;
		}
		return ret;
	}
}
