package com.qunar.hotel.qtypeahead.datastructure;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public class QSortedElementArray<E extends Element> implements SortedArray<E>, Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = -3175245757197621240L;
	private List<E> data = new ArrayList<E>();

	@Override
	public boolean add(E e) {
		boolean ret = false;
		int st = lowerBoundByDictionaryOrder(e.getIndex());
		int ind = -1;
		if(inDataArray(st)) {
			for(int i = st; i < data.size(); i++) {
				if(!data.get(i).getIndex().equals(data.get(st).getIndex())) break;
				if(data.get(i).getElementId() == e.getElementId()
						&& data.get(i).getIndex().equals(e.getIndex())) {
					ind = i;
					break;
				}
			}
		}
		if (inDataArray(ind)) {
			data.set(ind, e);
		} else {
			data.add(st, e);
		}
		ret = true;
		return ret;
	}

	@Override
	public boolean delete(E e) {
		boolean ret = false;
		int st = lowerBoundByPrefix(e.getIndex());
		if (inDataArray(st)) {
			for (int i = st; i < data.size(); i++) {
				if (!data.get(i).getIndex().equals(e.getIndex()))
					break;
				if (data.get(i).compareTo(e) == 0) {
					data.remove(i);
					ret = true;
					break;
				}
			}
		}
		return ret;
	}

	@Override
	public E search(E element) {
		String prefix = element.getIndex();
		int st = lowerBoundByPrefix(prefix);
		int ed = upperBoundByPrefix(prefix);
		if (inDataArray(st) && inDataArray(ed)) {
			return data.get(st);
		}
		return null;
	}

	@Override
	public List<E> getElementsByPrefix(E element) {
		List<E> ret = null;
		int st = lowerBoundByPrefix(element.getIndex());
		int ed = upperBoundByPrefix(element.getIndex());
		if (inDataArray(st) && inDataArray(ed)) {
			ret = new ArrayList<E>(ed - st + 1);
			for (int i = st; i <= ed; i++) {
				ret.add(data.get(i));
			}
		}
		return ret;
	}

	@Override
	public boolean exist(E element) {
		return null != search(element);
	}

	@Override
	public int size() {
		return data.size();
	}

	@Override
	public boolean build(List<E> elements) {
		Collections.sort(elements);
		data = Collections.synchronizedList(elements);
		return true;
	}

	private boolean inDataArray(int index) {
		return 0 <= index && index < data.size();
	}

	/**
	 * 判断element的index是否以prefix为前缀
	 * 
	 * @param e
	 *            element
	 * @param prefix
	 *            前缀字符串
	 * @return 是否前缀
	 */
	private boolean isPrefix(Element e, String prefix) {
		return e.getIndex().startsWith(prefix);
	}

	/**
	 * 查找第一个比key大的element的index
	 * 
	 * @param key
	 * @return
	 */
	private int lowerBoundByDictionaryOrder(String key) {
		int low = -1, high = data.size();
		while (high - low > 1) {
			int mid = (high - low) / 2 + low;
			int com = data.get(mid).getIndex().compareTo(key);
			if (com >= 0) {
				high = mid;
			} else {
				low = mid;
			}
		}
		return high;
	}

	/**
	 * 获取以key为前缀的第一个element的data下标
	 * 
	 * @param prefix
	 *            prefix
	 * @return data下标, 没有返回-1。
	 */
	private int lowerBoundByPrefix(String prefix) {
		int high = lowerBoundByDictionaryOrder(prefix);
		// 下标high不在数组中，返回-1
		if (!inDataArray(high))
			return -1;
		// 不以prefix为前缀，返回-1
		if (!isPrefix(data.get(high), prefix))
			return -1;
		return high;
	}

	/**
	 * 获取以key为前缀的最后一个element的data下标
	 * 
	 * @param prefix
	 *            prefix
	 * @return data下标, 没有返回-1。
	 */
	private int upperBoundByPrefix(String prefix) {
		int low = -1, high = data.size();
		while (high - low > 1) {
			int mid = (high - low) / 2 + low;
			int com = data.get(mid).getIndex().compareTo(prefix);
			if (com <= 0) {
				low = mid;
			} else {
				// com > 0
				if (isPrefix(data.get(mid), prefix)) {
					low = mid;
				} else {
					high = mid;
				}
			}
		}
		// 下标low不在数组中，返回-1
		if (!inDataArray(low))
			return -1;
		// 不以prefix为前缀，返回-1
		if (!isPrefix(data.get(low), prefix))
			return -1;
		return low;
	}

	@Override
	public String toString() {
		StringBuilder sb = new StringBuilder();
		for (int i = 0; i < data.size(); i++) {
			sb.append(data.get(i).toString());
		}
		return sb.toString();
	}
}
