package com.qunar.hotel.qtypeahead.datastructure;

import java.util.Set;

public class QElement implements Element {
    private static final long serialVersionUID = -2385906232920579818L;

    public QElement() {

    }

    public QElement(int id, String name, String tag, String index, long score,
                    String seq, Set<String> app, boolean poiInName) {
        this.id = id;
        this.name = name;
        this.tag = tag;
        this.index = index;
        this.score = score;
        this.seq = seq;
        this.app = app;
        this.poiInName = poiInName;
    }

    // 唯一键是unique(id, index)

    private int id;
    private String name;
    private String tag;
    private String index;
    private long score;
    private String seq;
    private Set<String> app;


    private boolean poiInName;


    @Override
    public boolean equals(Object o) {
        if (o == null)
            return false;
        if (o.getClass() == getClass()) {
            QElement e = (QElement) o;
            return getElementId() == e.getElementId()
                    && getName().equals(e.getName())
                    && getTag().equals(e.getTag())
                    && getIndex().equals(e.getIndex())
                    && getScore() == e.getScore()
                    && isPoiInName() == e.isPoiInName();
        } else {
            return false;
        }
    };

    @Override
    public int compareTo(Element o) {
        int c1 = getIndex().compareTo(o.getIndex());
        if (c1 != 0) {
            return c1;
        }
        if (this.id < o.getElementId()) {
            return -1;
        } else if (this.id > o.getElementId()) {
            return 1;
        }
        return 0;
    }

    @Override
    public String getIndex() {
        return index;
    }

    @Override
    public void setIndex(String index) {
        this.index = index;
    }

    @Override
    public long getScore() {
        return score;
    }

    @Override
    public void setScore(long score) {
        this.score = score;
    }

    @Override
    public int getElementId() {
        return id;
    }

    @Override
    public void setElementId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getTag() {
        return tag;
    }

    public void setTag(String tag) {
        this.tag = tag;
    }

    public boolean isPoiInName() {
        return poiInName;
    }

    public void setPoiInName(boolean poiInName) {
        this.poiInName = poiInName;
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        sb.append("id = ").append(id).append(",");
        sb.append("name = ").append(name).append(",");
        sb.append("index = ").append(index).append(",");
        sb.append("tag = ").append(tag).append(",");
        sb.append("score = ").append(score).append(",");
        sb.append("poi_in_name = ").append(poiInName).append("\n");
        return sb.toString();
    }

    public String getSeq() {
        return seq;
    }

    public void setSeq(String seq) {
        this.seq = seq;
    }

    public static QElement getMinimalElemnt(String index) {
        return new QElement(Integer.MIN_VALUE, null, null, index, 0, null, null, false);
    }

    public static QElement getMaximalElemnt(String index) {
        return new QElement(Integer.MAX_VALUE, null, null, index, 0, null, null, false);
    }

    public Set<String> getApp() {
        return app;
    }

    public void setApp(Set<String> app) {
        this.app = app;
    }
}
