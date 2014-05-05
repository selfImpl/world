package com.qunar.hotel.qtypeahead.datastructure;

import java.util.ArrayList;
import java.util.List;
import java.util.NavigableSet;
import java.util.TreeSet;

public class QSortedElementTreeSet<E extends Element> extends TreeSet<E>
		implements SortedArray<E> {

	/**
	 * 
	 */
	private static final long serialVersionUID = 682878451229968860L;

	@Override
	public boolean build(List<E> elements) {
		return super.addAll(elements);
	}

	@Override
	public boolean add(E e) {
		if (super.contains(e)) {
			super.remove(e);
		}
		return super.add(e);
	}

	@Override
	public boolean delete(E e) {
		return super.remove(e);
	}

	@Override
	public E search(E element) {
		NavigableSet<E> sub = super.tailSet(element, true);
		if (0 == sub.size())
			return null;
		return sub.first();
	}

	@Override
	public List<E> getElementsByPrefix(E minElement) {
		List<E> ret = new ArrayList<E>();
		NavigableSet<E> sub = super.tailSet(minElement, true);
		for (E one : sub) {
			if (one.getIndex().startsWith(minElement.getIndex())) {
				ret.add(one);
			} else {
				break;
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
		return super.size();
	}

}
