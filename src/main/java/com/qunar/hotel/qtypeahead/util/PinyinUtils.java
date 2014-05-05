package com.qunar.hotel.qtypeahead.util;

import net.sourceforge.pinyin4j.PinyinHelper;
import net.sourceforge.pinyin4j.format.HanyuPinyinOutputFormat;
import net.sourceforge.pinyin4j.format.HanyuPinyinToneType;
import net.sourceforge.pinyin4j.format.HanyuPinyinVCharType;
import net.sourceforge.pinyin4j.format.exception.BadHanyuPinyinOutputFormatCombination;
import org.apache.commons.lang.StringUtils;

import java.util.*;

/**
 * Author: xin.huang, weilong.li
 * Date: 12-11-5
 * Time: 10:45
 */
public class PinyinUtils {

	private static HanyuPinyinOutputFormat format = new HanyuPinyinOutputFormat();
	
	static {
        format.setToneType(HanyuPinyinToneType.WITHOUT_TONE);
        format.setVCharType(HanyuPinyinVCharType.WITH_V);
	}
	
    private static List<String> getPinyinOfChar(char chr) {
        String[] pinyinArray = null;
        try {
            pinyinArray = PinyinHelper.toHanyuPinyinStringArray(chr, format);
            if (pinyinArray != null) {
                Set<String> temp = new HashSet<String>(Arrays.asList(pinyinArray));
                pinyinArray = temp.toArray(new String[temp.size()]);
            }
        } catch (BadHanyuPinyinOutputFormatCombination badHanyuPinyinOutputFormatCombination) {
            badHanyuPinyinOutputFormatCombination.printStackTrace();
        }

        return Arrays.asList((pinyinArray == null) ? new String[]{} : pinyinArray);
    }

    private static List<List<String>> appendPinyinListFull(List<List<String>> pinyinList, char chr) {
        List<String> pinyinOfChar = getPinyinOfChar(chr);
        if (pinyinOfChar.isEmpty()) {
        	//无拼音，即不是中文，添加原来的字符
        	pinyinOfChar = new ArrayList<String>(2);
        	pinyinOfChar.add(String.valueOf(chr));
        }

        return generateNewList(pinyinList, pinyinOfChar);
    }

    private static List<List<String>> appendPinyinListInitial(List<List<String>> pinyinList, char chr) {
        List<String> pinyinOfChar = getPinyinOfChar(chr);
        if (pinyinOfChar.isEmpty()) {
        	//无拼音，即不是中文，添加原来的字符
        	pinyinOfChar = new ArrayList<String>(2);
        	pinyinOfChar.add(String.valueOf(chr));
        } else {
	        //get only initial characters
	        for (int i = 0; i < pinyinOfChar.size(); i++) {
	            char initial = pinyinOfChar.get(i).charAt(0);
	            pinyinOfChar.set(i, String.valueOf(initial));
	        }
        }

        return generateNewList(pinyinList, pinyinOfChar);
    }

    private static List<List<String>> generateNewList(List<List<String>> pinyinList, List<String> pinyinOfChar) {
        List<List<String>> newPinyinList = new ArrayList<List<String>>();

        if (pinyinList.isEmpty()) {
            newPinyinList.add(pinyinOfChar);
        } else {
            for (List<String> pyList : pinyinList) {
                for (String py : pinyinOfChar) {
                    List<String> tmpList = new ArrayList<String>();
                    tmpList.addAll(pyList);
                    tmpList.add(py);
                    newPinyinList.add(tmpList);
                }
            }
        }

        return newPinyinList;
    }

    public static List<List<String>> getPinyinOfStringFull(String query) {
        List<List<String>> list = new ArrayList<List<String>>();
        for (int i = 0; i < query.length(); i++) {
            list = appendPinyinListFull(list, query.charAt(i));
        }
        return list;
    }

    public static List<List<String>> getPinyinOfStringInitial(String query) {
        List<List<String>> list = new ArrayList<List<String>>();
        for (int i = 0; i < query.length(); i++) {
            list = appendPinyinListInitial(list, query.charAt(i));
        }
        return list;
    }

    public static void main(String[] args) {
        String testStr = "张三";
//        String testStr = "乐乐乐乐乐乐乐乐乐乐乐乐乐乐乐乐乐乐";
//        String testStr = "中国共产党第十七届中央委员会第七次全体会议在北京举行中国共产党第十七届中央委员会第七次全体会议，于11月1日至4日在北京举行。全会由中央政治局主持。这是胡锦涛、吴邦国、温家宝、贾庆林、李长春、习近平、李克强、贺国强、周永康在主席台上。 新华社记者 李学仁 摄";
        System.out.println("String length: " + testStr.length());
        int count1 = 0, count2 = 0;
        long startTime1 = System.currentTimeMillis();

        for (List<String> stringList : getPinyinOfStringFull(testStr)) {
            System.out.println(count1++ + ":" + StringUtils.join(stringList, ""));
        }

        long startTime2 = System.currentTimeMillis();
        System.out.println("Full: " + (startTime2 - startTime1) + "ms");

        for (List<String> stringList : getPinyinOfStringInitial(testStr)) {
            System.out.println(count2++ + ":" + StringUtils.join(stringList, ""));
        }

        long startTime3 = System.currentTimeMillis();
        System.out.println("Initial: " + (startTime3 - startTime2) + "ms");
    }
}
