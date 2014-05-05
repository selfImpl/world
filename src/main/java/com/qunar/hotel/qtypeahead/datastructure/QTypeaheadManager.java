package com.qunar.hotel.qtypeahead.datastructure;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.PriorityQueue;
import java.util.Set;
import java.util.concurrent.locks.ReentrantReadWriteLock;

import org.apache.commons.lang.StringUtils;
import org.objenesis.strategy.StdInstantiatorStrategy;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.InitializingBean;

import com.esotericsoftware.kryo.Kryo;
import com.esotericsoftware.kryo.io.Input;
import com.esotericsoftware.kryo.io.Output;

public class QTypeaheadManager implements InitializingBean {
    private final Logger logger = LoggerFactory.getLogger(getClass());

    private Map<String, QSortedElementTreeSet<QElement>> typeahead;

    private ReentrantReadWriteLock rwLock = new ReentrantReadWriteLock();

    public boolean indexElement(String cityCode, QElement e) {
        try {
            rwLock.writeLock().lock();
            QSortedElementTreeSet<QElement> data = typeahead.get(cityCode);
            if (data == null) {
                data = new QSortedElementTreeSet<QElement>();
                typeahead.put(cityCode, data);
            }
            return data.add(e);
        } finally {
            rwLock.writeLock().unlock();
        }
    }

    public boolean buildElements(String cityCode, List<QElement> e) {
        try {
            rwLock.writeLock().lock();
            QSortedElementTreeSet<QElement> data = new QSortedElementTreeSet<QElement>();
            typeahead.put(cityCode, data);
            return data.build(e);
        } finally {
            rwLock.writeLock().unlock();
        }
    }

    public boolean deleteElement(String cityCode, QElement e) {
        try {
            rwLock.writeLock().lock();
            QSortedElementTreeSet<QElement> data = typeahead.get(cityCode);
            if (data == null)
                return false;
            return data.delete(e);
        } finally {
            rwLock.writeLock().unlock();
        }
    }

    /**
     * @param city
     *            城市中文名
     * @param cityCode
     *            城市city_code
     * @param query
     *            查询的前缀
     * @param app
     *            查询的应用
     * @param limit
     *            0或负数为取出所有elements,整数为最大取这么多个
     * @return limit个elements
     */
    public List<QElement> searchByScore(String city, String cityCode, String query,
            String app, int limit) {
        if (cityCode == null || query == null)
            return null;
        if (limit <= 0) {
            limit = Integer.MAX_VALUE;
        }
        PriorityQueue<QElement> pq = new PriorityQueue<QElement>(limit, scoreComparator);
        List<QElement> res = new ArrayList<QElement>();
        Set<String> nameFilter = new HashSet<String>();
        Map<String, QElement> seqBest = new HashMap<String, QElement>();
        try {
            rwLock.readLock().lock();
            QSortedElementTreeSet<QElement> data = typeahead.get(cityCode);
            if (null == data)
                return res;
            List<QElement> all = data.getElementsByPrefix(QElement
                    .getMinimalElemnt(query));
            if (all != null) {
                for (int i = 0; i < all.size(); i++) {
                    if (nameFilter.contains(all.get(i).getName()))
                        continue;
                    if (!StringUtils.isEmpty(app) && !all.get(i).getApp().contains(app)) {
                        continue;
                    }
                    String seq = all.get(i).getSeq();
                    if (StringUtils.isBlank(seq)) {
                        pq.add(all.get(i));
                        nameFilter.add(all.get(i).getName());
                    } else {
                        QElement oldBest = seqBest.get(seq);
                        if (oldBest == null) {
                            seqBest.put(seq, all.get(i));
                        } else {
                            if (scoreComparator.compare(oldBest, all.get(i)) < 0) {
//                                logger.info("{}({}) is better then {}({}).",
//                                        new Object[] { all.get(i).getName(),
//                                                all.get(i).getScore(), oldBest.getName(),
//                                                oldBest.getScore() });
                                seqBest.put(seq, all.get(i));
                            }
                        }
                    }
                    // 只取score最大的limit个
                    if (pq.size() > limit) {
                        QElement e = pq.remove();
                        nameFilter.remove(e.getName());
                    }
                }
                for (Entry<String, QElement> et : seqBest.entrySet()) {
                    pq.add(et.getValue());
                }
                // 拿取score最大的最多limit个
                int more = pq.size() - limit;
                for (int i = 0; i < more; i++) {
                    pq.poll();
                }
                for (int i = 0; i < limit; i++) {
                    if (pq.isEmpty()) {
                        break;
                    }
                    res.add(pq.poll());
                }
            }
            Collections.reverse(res);
            return res;
        } finally {
            rwLock.readLock().unlock();
        }
    }

    private static QElementScoreComparator scoreComparator = new QElementScoreComparator();

    private static class QElementScoreComparator implements Comparator<QElement> {

        @Override
        public int compare(QElement o1, QElement o2) {
            if (o1.getScore() < o2.getScore()) {
                return -1;
            } else if (o1.getScore() > o2.getScore()) {
                return 1;
            } else {
                return o2.getName().length() - o1.getName().length();
            }
        }
    }

    public void serialize(ObjectOutputStream oos) throws IOException {
        Output output = new Output(oos);

        Kryo kryo = new Kryo();
        kryo.setReferences(false);
        kryo.setRegistrationRequired(false);
        kryo.setInstantiatorStrategy(new StdInstantiatorStrategy());

        try {
            rwLock.readLock().lock();
            kryo.writeClassAndObject(output, typeahead);
        } finally {
            output.close();
            rwLock.readLock().unlock();
        }
    }

    public void deserialize(ObjectInputStream ois) throws IOException,
            ClassNotFoundException {
        Input input = new Input(ois);

        Kryo kryo = new Kryo();
        kryo.setReferences(false);
        kryo.setRegistrationRequired(false);
        kryo.setInstantiatorStrategy(new StdInstantiatorStrategy());

        try {
            @SuppressWarnings("unchecked")
            Map<String, QSortedElementTreeSet<QElement>> newTypeahead = (Map<String, QSortedElementTreeSet<QElement>>) kryo
                    .readClassAndObject(input);
            rwLock.writeLock().lock();
            typeahead = newTypeahead;
        } catch (Exception e) {
            logger.error("deserialize error", e);
        } finally {
            input.close();
            rwLock.writeLock().unlock();
        }
    }

    private String dictPath = null;

    public String getDictPath() {
        return dictPath;
    }

    public void setDictPath(String dictPath) {
        this.dictPath = dictPath;
    }

    @Override
    public void afterPropertiesSet() throws Exception {
        if (this.getDictPath() == null) {
            throw new IllegalArgumentException("'dictPath' is required.");
        }

        File file = new File(getDictPath());
        if (file.exists()) {
            logger.info("Load dict Start. <= {}", file);
            this.deserialize(new ObjectInputStream(new FileInputStream(file)));
            logger.info("Load dict End.");
        } else {
            logger.info("dictPath not exist : {}, creating a new instance.",
                    getDictPath());
            typeahead = new HashMap<String, QSortedElementTreeSet<QElement>>();
        }
    }

}
