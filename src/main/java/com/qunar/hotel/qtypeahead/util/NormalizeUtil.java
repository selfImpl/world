package com.qunar.hotel.qtypeahead.util;

import org.apache.commons.lang.StringUtils;

import com.qunar.nlp.chinese.util.ChineseNormalizer;
import com.qunar.nlp.chinese.util.ZHConverter;

public class NormalizeUtil {

    /**
     * 将连续的空白字符转换为一个英文空格
     * 
     * @param str 要处理的值
     * @return 转换后的值
     */
    public static String normalizeWhitespace(String str) {
        return str.replaceAll("[ 　]+", " ");
    }

    /**
     * 将中文的"零一二三..."等数字转换成"0123..."
     * 
     * @param value 要转换的字串
     * @return 转换后的字串
     */
    public static String convertUppercaseNumber2Number(String value) {
        if (value == null) {
            return null;
        }
        if (value.length() == 0) {
            return "";
        }

        return StringUtils.replaceEach(value, new String[] { "零", "一", "二", "三", "四", "五", "六", "七", "八", "九" },
                new String[] { "0", "1", "2", "3", "4", "5", "6", "7", "8", "9" });
    }

    /**
     * 将中文大写的"零壹贰叁肆伍陆柒捌玖拾..."等数字转换成"0123..."
     * 
     * @param value 要转换的字串
     * @return 转换后的字串
     */
    public static String convertChineseUppercaseNumber2Number(String value) {
        if (value == null) {
            return null;
        }
        if (value.length() == 0) {
            return "";
        }

        return StringUtils.replaceEach(value, new String[] { "零", "壹", "贰", "叁", "肆", "伍", "陆", "柒", "捌", "玖" },
                new String[] { "0", "1", "2", "3", "4", "5", "6", "7", "8", "9" });
    }

    /**
     * 判断一个字符是否为中文字符（不含标点符号）
     * 
     * @param ch 要判断的字符
     * @return 如果为中文字符，返回true
     */
    public static boolean isChineseChar(char ch) {
        Character.UnicodeBlock ub = Character.UnicodeBlock.of(ch);
        return ub == Character.UnicodeBlock.CJK_UNIFIED_IDEOGRAPHS
                || ub == Character.UnicodeBlock.CJK_COMPATIBILITY_IDEOGRAPHS
                || ub == Character.UnicodeBlock.CJK_UNIFIED_IDEOGRAPHS_EXTENSION_A;
    }
    
    /**
     * 是否只包含英文字母，数字，汉字，空格 
     * @param s
     * @return
     */
    public static boolean isNormalString(String s){
    	for(int i=0;i<s.length();i++){
    		char ch=s.charAt(i);
    		if(!isChineseChar(ch) && !isEnglishChar(ch) 
    			 &&!isDigit(ch) 
    			&& ch!=' ' && ch!=' ')
    			return false;
    	}
    	
    	return true;
    }
    
    public static boolean isDigit(char ch){
    	return ch>='0' && ch<='9';
    }
    
    public static boolean isChineseStr(String str){
    	for(int i=0;i<str.length();i++){
    		if(!isChineseChar(str.charAt(i))) return false;
    	}
    	return true;
    }
    
    public static boolean hasEnglishChar(String str){
    	for(int i=0;i<str.length();i++){
    		if(isEnglishChar(str.charAt(i))){
    			return true;
    		}
    	}
    	return false;
    }

    /**
     * 判断一个字符是否为英文字符（a-zA-Z）
     * 
     * @param ch 要判断的字符
     * @return 如果为英文字符，返回true
     */
    public static boolean isEnglishChar(char ch) {
        return Character.isLowerCase(ch) || Character.isUpperCase(ch);
    }


    /**
     * 判断一个字符是否为英文字符或者数字（a-zA-Z0-9）
     * 
     * @param ch 要判断的字符
     * @return 如果为英文字符 或者数字，返回true
     */
    public static boolean isDigitOrEngilishChar(char ch) {
        return Character.isLowerCase(ch) || Character.isUpperCase(ch) || Character.isDigit(ch);
    }
    
    /**
     * 判断一个字符是否为英文标点或中文标点
     * 
     * @param ch 要判断的字符
     * @return 如果为标点，返回true
     */
    public static boolean isPunctuationChar(char ch) {
        if ((ch > '\u0020') && (ch <= '\u002F')) {
            return true;
        }
        if ((ch >= '\u003A') && (ch <= '\u0040')) {
            return true;
        }
        if ((ch >= '\u005B') && (ch <= '\u0060')) {
            return true;
        }
        if ((ch >= '\u007B') && (ch <= '\u007E')) {
            return true;
        }
        Character.UnicodeBlock ub = Character.UnicodeBlock.of(ch);
        return ub == Character.UnicodeBlock.GENERAL_PUNCTUATION
                || ub == Character.UnicodeBlock.CJK_SYMBOLS_AND_PUNCTUATION
                || ub == Character.UnicodeBlock.HALFWIDTH_AND_FULLWIDTH_FORMS;
    }

    /**
     * 将所有标点替换为replaceChar
     * 
     * @param str 原字符串
     * @param replaceChar 要换的字符
     * @return 替换后的string
     */
    public static String replacePuctuation(String str, char replaceChar) {
        StringBuilder sb = new StringBuilder(str.length());
        for (int i = 0; i < str.length(); i++) {
            char c = str.charAt(i);
            if (isPunctuationChar(c)) {
                sb.append(replaceChar);
            } else {
                sb.append(c);
            }
        }
        return sb.toString();
    }
    
    /**
     * 去除特定情况下的空格
     * 
     * @param str
     * @return
     */
    public static String removeUselessSpace(String str) {
    	StringBuilder sb = new StringBuilder(str.length());
        for (int i = 0; i < str.length(); i++) {
        	if(str.charAt(i) == ' ') {
	            if(i>0 && isDigitOrEngilishChar(str.charAt(i-1)) && 
	            		i+1 < str.length() && isDigitOrEngilishChar(str.charAt(i+1))) {
	            	sb.append(str.charAt(i));
	            }
        	} else {
        		sb.append(str.charAt(i));
        	}
        }
        return sb.toString();
    }

    /**
     * 除去特殊字符c2a0(unicode - '\u00A0')
     * @param str
     * @return
     */
    public static String replaceC2A0(String str) {
    	StringBuilder sb = new StringBuilder(str.length());
    	for(int i = 0; i < str.length(); i++) {
    		if(str.charAt(i) == '\u00A0') {
    			sb.append('\u0020');
    		} else {
    			sb.append(str.charAt(i));
    		}
    	}
    	return sb.toString();
    }
    
    public static boolean isMessy(String str) {
    	if(null == str) return true;
    	boolean ret = false;
    	int cnt = 0;
    	for(int i = 0; i < str.length(); i++) {
    		char s = str.charAt(i);
    		if(!isChineseChar(s) && !isDigitOrEngilishChar(s) && !isPunctuationChar(s)) {
    			cnt++;
    		}
    	}
    	if(1.0 * cnt / str.length() > 0.4) {
    		ret = true;
    	}
    	return ret;
    }
    
    public static String replacePunctuationExcept(String str, char replaceChar, String except) {
    	if(null == str || null == except) return "";
    	StringBuilder sb = new StringBuilder();
    	for(int i = 0; i < str.length(); i++) {
    		char c = str.charAt(i);
    		if (isPunctuationChar(c) && !except.contains(String.valueOf(c))) {
    			sb.append(replaceChar);
    		} else {
    			sb.append(c);
    		}
    	}
    	return sb.toString();
    }
    
    /**
     * @param str 原字符串
     * @return normalize后的string
     */
    public static String normalize(String str) {
        if (str == null)
            return "";
        
        // 全角转半角
        String normalizedStr = ChineseNormalizer.normalize(str);
        // fix全角转半角的遗漏c2a0
        normalizedStr = replaceC2A0(normalizedStr);
        // 繁体转简体
        normalizedStr = ZHConverter.convert(normalizedStr, ZHConverter.SIMPLIFIED);
        // 将标点变成空格除了括号
        normalizedStr = NormalizeUtil.replacePunctuationExcept(normalizedStr, ' ', "()");
        // 合并多个空格
        normalizedStr = NormalizeUtil.normalizeWhitespace(normalizedStr);
        
        // 汉字变数字
        //normalizedStr = NormalizeUtil.convertUppercaseNumber2Number(normalizedStr);
        //normalizedStr = NormalizeUtil.convertChineseUppercaseNumber2Number(normalizedStr);
        // 法文变英文
        //char[] arr = normalizedStr.toCharArray();
        //normalizedStr = new String(ASCIIFoldingUtil.foldToASCII(arr, arr.length));
        
        // 去掉非英文字母之间的空格
        //normalizedStr = NormalizeUtil.removeUselessSpace(normalizedStr);
        
        return normalizedStr.toLowerCase().trim();
    }
    
    public static String normalizeWithSpace(String str) {
        if (str == null)
            return "";
        
        // 全角转半角
        String normalizedStr = ChineseNormalizer.normalize(str);
        // fix全角转半角的遗漏c2a0
        normalizedStr = replaceC2A0(normalizedStr);
        // 繁体转简体
        normalizedStr = ZHConverter.convert(normalizedStr, ZHConverter.SIMPLIFIED);
        // 将标点变成空格
        //normalizedStr = NormalizeUtil.replacePuctuation(normalizedStr, ' ');
        // 合并多个空格
        normalizedStr = NormalizeUtil.normalizeWhitespace(normalizedStr);
        
        return normalizedStr.toLowerCase().trim();
    }
    
    public static void main(String[] argv) {
    	System.out.println(isPunctuationChar(' '));
    }
}
