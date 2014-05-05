package com.qunar.hotel.qtypeahead.datastructure;

import java.util.List;

public interface SortedArray<E extends Element> {
	
	/**
	 * 根据element列表构建array
	 * @param elements element列表
	 * @return 成功与否
	 */
	public boolean build(List<E> elements);
	
	/**
	 * 增加一个element，如果重复，覆盖它
	 * @param e 需添加的element
	 * @return 成功与否
	 */
	public boolean add(E e);
	
	/**
	 * 删除一个element
	 * @param e element, at lease have a id and index.
	 * @return 成功与否
	 */
	public boolean delete(E e);
	
	/**
	 * 查找一个index.equals(key)的element
	 * @param key
	 * @return null表示找不到
	 */
	public E search(E element);
	
	/**
	 * 获取index的前缀为prefix的element列表
	 * @param prefix 搜索的前缀
	 * @return element列表
	 */
	public List<E> getElementsByPrefix(E element);
	
	/**
	 * 查找是否存在index.equals(key)的element
	 * @param key
	 * @return 是否找到
	 */
	public boolean exist(E element);
	
	/**
	 * 获取elements的数量
	 * @return 数量
	 */
	public int size();
}
