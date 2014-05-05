package com.qunar.hotel.qtypeahead.datastructure;

import static org.junit.Assert.*;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import org.junit.Test;

public class TestQSortedElementArray {

	@Test
	public void testExist() {
		List<QElement> l = Collections
				.synchronizedList(new ArrayList<QElement>());
		l.add(build(1, "a", "a", "", 100));
		QSortedElementArray<QElement> arr = new QSortedElementArray<QElement>();
		arr.build(l);
		assertTrue(arr.exist(QElement.getMinimalElemnt("a")));
		assertFalse(arr.exist(QElement.getMinimalElemnt("b")));
	}

	@Test
	public void testAdd() {
		QSortedElementArray<QElement> arr = new QSortedElementArray<QElement>();
		assertTrue(arr.add(build(1, "b", "b", "", 100)));
		assertTrue(arr.add(build(2, "a", "a", "", 100)));
		assertTrue(arr.add(build(2, "abb", "abb", "", 100)));
		assertTrue(arr.add(build(3, "ab", "ab", "", 100)));
		assertEquals(4, arr.size());
		List<QElement> ret = arr.getElementsByPrefix(QElement
				.getMinimalElemnt("a"));
		assertEquals(3, ret.size());
		assertEquals("a", ret.get(0).getName());
		assertEquals("ab", ret.get(1).getName());
		assertEquals("abb", ret.get(2).getName());
	}

	@Test
	public void testAddSameIdAndIndex() {
		QSortedElementArray<QElement> arr = new QSortedElementArray<QElement>();
		assertTrue(arr.add(build(1, "a", "a", "", 100)));
		assertTrue(arr.add(build(1, "a", "a", "", 200)));
		assertTrue(arr.add(build(2, "b", "b", "", 1)));
		assertTrue(arr.add(build(1, "a", "a", "", 3)));
		assertEquals(2, arr.size());
		List<QElement> ret = arr.getElementsByPrefix(QElement
				.getMinimalElemnt("a"));
		assertEquals(1, ret.size());
		assertEquals("a", ret.get(0).getName());
		assertEquals(3, ret.get(0).getScore());
		arr.delete(build(1, "a", "a", "", 100));
		ret = arr.getElementsByPrefix(QElement.getMinimalElemnt("a"));
		assertEquals(null, ret);
	}

	@Test
	public void testDelete() {
		QSortedElementArray<QElement> arr = new QSortedElementArray<QElement>();
		assertTrue(arr.add(build(1, "b", "b", "", 100)));
		assertTrue(arr.add(build(2, "a", "a", "", 100)));
		assertTrue(arr.add(build(3, "abb", "abb", "", 1000)));
		assertTrue(arr.add(build(4, "ab", "ab", "", 100)));
		assertEquals(4, arr.size());
		assertTrue(arr.delete(build(4, "ab", "ab", "", 100)));
		assertEquals(3, arr.size());
		List<QElement> ret = arr.getElementsByPrefix(QElement
				.getMinimalElemnt("a"));
		assertEquals(2, ret.size());
		assertEquals("a", ret.get(0).getName());
		assertEquals("abb", ret.get(1).getName());
		ret = arr.getElementsByPrefix(QElement.getMinimalElemnt("abb"));
		assertEquals(1, ret.size());
		assertEquals(1000, ret.get(0).getScore());
	}

	@Test
	public void testWithSameIndex() {
		List<QElement> l = new ArrayList<QElement>();
		l.add(build(3, "c", "a", "", 100));
		l.add(build(4, "d", "a", "", 100));
		l.add(build(1, "a", "a", "", 100));
		l.add(build(2, "b", "a", "", 100));
		l.add(build(5, "e", "b", "", 100));
		QSortedElementArray<QElement> arr = new QSortedElementArray<QElement>();
		arr.build(l);
		List<QElement> ret = arr.getElementsByPrefix(QElement
				.getMinimalElemnt("a"));
		assertEquals(4, ret.size());
		assertEquals("a", ret.get(0).getName());
		assertEquals("b", ret.get(1).getName());
		assertEquals("c", ret.get(2).getName());
		assertEquals("d", ret.get(3).getName());
		ret = arr.getElementsByPrefix(QElement.getMinimalElemnt("b"));
		assertEquals(1, ret.size());
	}

	private QElement build(int id, String name, String index, String tag,
			long score) {
		QElement ret = new QElement();
		ret.setElementId(id);
		ret.setName(name);
		ret.setIndex(index);
		ret.setTag(tag);
		ret.setScore(score);
		return ret;
	}

}
