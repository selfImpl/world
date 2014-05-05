package com.qunar.hotel.qtypeahead.search;

import com.qunar.flight.qmonitor.QMonitor;
import com.qunar.hotel.algorithms.nlp.PinYinService;
import com.qunar.hotel.algorithms.nlp.PinYinService.PinYin;
import com.qunar.hotel.qtypeahead.datastructure.QElement;
import com.qunar.hotel.qtypeahead.datastructure.QTypeaheadManager;
import com.qunar.hotel.qtypeahead.refresh.CitySyncTask;
import com.qunar.hotel.qtypeahead.util.NormalizeUtil;
import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.annotation.Resource;
import java.util.*;

public class QTypeaheadSearcher {

    private Logger logger = LoggerFactory.getLogger(getClass());
    private static final int MAX_LIMIT = 100;

    @Resource
    private QTypeaheadManager searcher;

    @Resource
    private CitySyncTask cityManager;

    public List<QElement> search(String city, String city_code, String query, int limit,
            String app) {
        if (StringUtils.isEmpty(city_code) && !StringUtils.isEmpty(city)) {
            city_code = cityManager.getCityCode(city);
        }
        if (StringUtils.isEmpty(city_code) || StringUtils.isEmpty(query)) {
            return Collections.emptyList();
        }
        if (limit <= 0 || limit > MAX_LIMIT) {
            // 限制不能太大
            limit = 10;
        }

        long st = System.currentTimeMillis();

        // normalize
        boolean endsWithSpace = query.endsWith(" ");
        String queryNor = NormalizeUtil.normalize(query);

        if (StringUtils.isEmpty(queryNor)) {
            return Collections.emptyList();
        }
        if (endsWithSpace) {
            queryNor = queryNor + " ";
        }

        // search
        List<QElement> results = searcher.searchByScore(city, city_code.toLowerCase()
                .trim(), queryNor, app, limit);

        // 无结果的补救方案
        if (results == null || results.isEmpty()) {
            String city_cn = cityManager.getCityName(city_code);
            if (!StringUtils.isEmpty(city_cn) && queryNor.startsWith(city_cn)) {
                queryNor = queryNor.substring(city_cn.length());
                results = searcher.searchByScore(city, city_code, queryNor, app, limit);
            }
        }

        // 转拼音补结果
        if (results == null || results.size() < limit) {
            if (results == null) {
                results = new LinkedList<QElement>();
            }
            PinYin pys = PinYinService.getPinYin(queryNor, "");
            PINYIN: for (String py : pys.getPinYinList()) {
                if (py.equals(queryNor)) {
                    continue;
                }
                List<QElement> pyRes = searcher.searchByScore(city, city_code, py.trim(),
                        app, limit);
                if (pyRes != null) {
                    for (QElement e : pyRes) {
                        boolean same = false;
                        for (QElement re : results) {
                            if (e.getName().equals(re.getName())) {
                                same = true;
                                break;
                            }
                        }
                        if (!same) {
                            results.add(e);
                        }
                        if (results.size() >= limit) {
                            break PINYIN;
                        }
                    }
                }
            }
        }

        long useTime = System.currentTimeMillis() - st;
        // log统计
        logger.info(
                "typeahead city={}, city_code={}, query={}, limit={}, app={}, resultSize={}, time={}ms.",
                new Object[] { city, city_code, query, limit, app, results.size(),
                        useTime });

        QMonitor.recordOne("QTypeahead_Response", useTime);
        return results;
    }

    public Map<String, Object> converOutput(String city, String q, List<QElement> results) {
        Map<String, Object> out = new HashMap<String, Object>();
        if (results.isEmpty()) {
            out.put("ret", false);
        } else {
            out.put("ret", true);
        }
        out.put("city", city);
        out.put("q", q);
        List<Map<String, String>> data = new ArrayList<Map<String, String>>(
                results.size());

        boolean poiInName = false;
        String qs = StringUtils.trimToEmpty(q);
        for (int i = 0; i < results.size(); i++) {
            Map<String, String> one = new HashMap<String, String>();
            QElement qe = results.get(i);
            String name = qe.getName();
            if (!poiInName && qs.equals(name) && qe.isPoiInName()) {
                poiInName = true;
            }
            one.put("ahead", name);
            one.put("tag", qe.getTag());
            data.add(one);
        }
        out.put("poi_in_name", poiInName);
        out.put("data", data);
        return out;
    }
}
