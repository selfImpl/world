package com.qunar.hotel.qtypeahead.datastructure;

import java.io.Serializable;

public interface Element extends Serializable, Comparable<Element> {
	
	public int getElementId();
	
	public void setElementId(int id);
	
	/**
	 * 获取用来做索引的字符串
	 * @return 做索引的字符串
	 */
	public String getIndex();

	/**
	 * 设置做索引的字符串
	 * @param index
	 */
	public void setIndex(String index);

	/**
	 * 获取该element的分值
	 * @return 该element的分值
	 */
	public long getScore();

	/**
	 * 设置该element的分值
	 * @param score
	 */
	public void setScore(long score);
}
