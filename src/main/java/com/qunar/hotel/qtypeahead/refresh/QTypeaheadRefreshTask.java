package com.qunar.hotel.qtypeahead.refresh;

import com.qunar.base.meerkat.util.PropertyUtil;
import com.qunar.hotel.qcensor.QCensorImpl;
import com.qunar.hotel.qcensor.SensitiveWord;
import com.qunar.hotel.qtypeahead.datastructure.QElement;
import com.qunar.hotel.qtypeahead.datastructure.QTypeaheadManager;
import com.qunar.hotel.qtypeahead.filter.QTypeaheadFilter;
import com.qunar.hotel.qtypeahead.util.NormalizeUtil;
import org.springframework.stereotype.Component;

import javax.annotation.Resource;
import java.util.*;

@Component
public class QTypeaheadRefreshTask extends AbstractTask {
	private Set<Object> lastUpdated = new HashSet<Object>();
	private double lastUpdateTime = -1.0;

	private final int NARMAL_STATUS = 0;

	private final double MESSY_LIMIT = Double.valueOf(PropertyUtil.getProperty(
			"qtypeahead.filter.messy.limit", "0.3"));
	private final double PUNC_LIMIT = Double.valueOf(PropertyUtil.getProperty(
			"qtypeahead.filter.punc.limit", "0.65"));

	// 对于不符合filter的id,做删除
	private List<Integer> banId = new ArrayList<Integer>();
	private final int DELETE_BANID_BATCH = 1000;

	private final int FULL_GET_BATCH = 300000;

	// sqls
	private final String incrementSql = "select id, city_code, query, query_py, tag, tag_py, status, type, hotel_seq, app, search_cnt, detail_cnt, EXTRACT(EPOCH FROM last_mod) as last_mod, poi_in_name from qt_hotel_log_analyse_result "
			+ "where last_mod >= to_timestamp(?)";

	private final String fullSql = "select id, city_code, query, query_py, tag, tag_py, status, type, hotel_seq, app, search_cnt, detail_cnt, EXTRACT(EPOCH FROM last_mod) as last_mod, poi_in_name from qt_hotel_log_analyse_result "
			+ "where status = 0 order by id offset ? limit ?";

	@Resource
	CitySyncTask citycodeToName;

	@Resource
	QTypeaheadManager dao;

	// 黄反词
	@Resource
	QCensorImpl qCensor;

	public void initTypeahead() {
		
		if(getLocalVersion() > 0) {
			//从字典恢复
			return;
		}
		
		// 全量更新, 数据太多必须分批...
		banId.clear();

		String sql = fullSql;
		int offset = 0, elementCount = 0;

		while (true) {
			int count = 0;
			Object[] param = new Object[] { offset, FULL_GET_BATCH };
			List<Map<String, Object>> elements = jdbcTemplate.queryForList(sql,
					param);
			Iterator<Map<String, Object>> it = elements.iterator();
			while (it.hasNext()) {
				updateEachRecord(it.next());
				count++;
			}
			elementCount += count;
			logger.info("get elements offset : {}, limit : {}, cnt : {}",
					new Object[] { offset, FULL_GET_BATCH, count });
			if (count != FULL_GET_BATCH) {
				break;
			}
			offset += count;
		}

		deleteBannedIds();

		// 更新版本信息
		updateTime(elementCount, lastUpdateTime);
		logger.info("updated version : {}.", getLocalVersion());
	}

	@Override
	protected void doExecute() {
		double version = getLocalVersion();
		logger.info("QTypeaheadRefreshTask start with version : {}", version);

		refreshElements(version);
	}

	private void refreshElements(double version) {
		banId.clear();

		String sql = incrementSql;
		Object[] param = new Object[] { version };
		List<Map<String, Object>> elements = jdbcTemplate.queryForList(sql,
				param);
		Iterator<Map<String, Object>> it = elements.iterator();
		int elementCount = 0;
		while (it.hasNext()) {
			updateEachRecord(it.next());
			elementCount++;
		}

		deleteBannedIds();

		// 更新版本信息
		updateTime(elementCount, lastUpdateTime);
		logger.info("updated version : {}.", getLocalVersion());
	}

	private void deleteBannedIds() {
		if (!banId.isEmpty()) {
			int tot = 0;
			StringBuilder sb = new StringBuilder();
			List<Object> param = new ArrayList<Object>();
			for (int id : banId) {
				tot++;
				sb.append("update qt_hotel_log_analyse_result set status = 1 where id = ?;");
				param.add(id);
				if (tot % DELETE_BANID_BATCH == 0) {
					jdbcTemplate.update(sb.toString(), param.toArray());
					sb = new StringBuilder();
					param = new ArrayList<Object>();
				}
			}
			if (sb.length() > 0) {
				jdbcTemplate.update(sb.toString(), param.toArray());
			}
			logger.info("deleted banned id size : {}.", banId.size());
		}
	}

	@SuppressWarnings("unchecked")
	private List<QElement> buildElements(String city_code,
			Map<String, Object> cur) {
		int id = (Integer) cur.get("id");
		String name = (String) cur.get("query");
		String tag = (String) cur.get("tag");
		String seq = (String) cur.get("hotel_seq");
		int search_cnt = (Integer) cur.get("search_cnt");
		int detail_cnt = (Integer) cur.get("detail_cnt");
		long score = ((long) search_cnt << 32) | detail_cnt;
        boolean poiInName =  (1 == (Integer) cur.get("poi_in_name"));

		// app
		HashSet <String> app = null;
		Object ob_app = cur.get("app");
		if (ob_app != null) {
			app = new HashSet<String>(((Map<String, String>) ob_app).keySet());
		}

		// go filters
		// 过滤乱码
		if (QTypeaheadFilter.isMessy(name.trim(), MESSY_LIMIT)) {
			logger.warn("skip messy word : {}, id : {}.", name, id);
			return null;
		}
		// 过滤过多的数字或标点
		if (QTypeaheadFilter.isTooManyPunctuation(name.trim(), PUNC_LIMIT)) {
			logger.warn(
					"skip too many punctuation or digit word : {}, id : {}.",
					name, id);
			return null;
		}

		// 通过filter后才normalize
		String nameNor = NormalizeUtil.normalize(name);
		String tagNor = NormalizeUtil.normalize(tag);

		// 查无该city_code，或名字和城市名相同, 不要
		String cityCn = citycodeToName.getCityName(city_code);
		if (null == cityCn || cityCn.equals(nameNor)) {
			logger.warn("error city_code element : {}, id : {}", city_code, id);
			return null;
		}

		// 长度小于2不要
		if (nameNor.length() < 2)
			return null;

		// 过滤黄反词
		List<SensitiveWord> c1 = qCensor.censor(nameNor);
		List<SensitiveWord> c2 = qCensor.censor(tagNor);
		if (null != c1 && null != c2 && (!c1.isEmpty() || !c2.isEmpty())) {
			// logger.warn("contains SensitiveWord element id : {}, name : {}, tag : {}.",
			// new Object[] {id, name, tag});
			return null;
		}

		List<QElement> res = new ArrayList<QElement>();
		res.add(new QElement(id, name, tag, nameNor, score, seq, app, poiInName));
		if (tagNor != null && !tagNor.equals("") && !tagNor.equals(nameNor)) {
			res.add(new QElement(id, name, tag, tagNor, score, seq, app, poiInName));
		}
		if (nameNor.startsWith(cityCn)) {
			String ind = nameNor.substring(cityCn.length());
			if (!ind.equals(tagNor) && ind.length() > 1) {
				res.add(new QElement(id, name, tag, ind, score, seq, app, poiInName));
			}
		}
		// pinyin
		String name_py = (String) cur.get("query_py");
		if (null != name_py) {
			String[] pys = name_py.split("\\|");
			for (String py : pys) {
				if (py.length() < 2)
					continue;
				res.add(new QElement(id, name, tag, py.toLowerCase(), score, seq, app, poiInName));
			}
		}
		String tag_py = (String) cur.get("tag_py");
		if (null != tag_py) {
			String[] pys = tag_py.split("\\|");
			for (String py : pys) {
				if (py.length() < 2)
					continue;
				res.add(new QElement(id, name, tag, py.toLowerCase(), score, seq, app, poiInName));
			}
		}
		// logger.debug("[bulid info], id : {}, name : {}, name_py : {}, tag_py : {}.",
		// new Object[] { id, name, name_py, tag_py });
		return res;
	}

	private void updateEachRecord(Map<String, Object> cur) {
		int id = (Integer) cur.get("id");
		String city_code = ((String) cur.get("city_code")).toLowerCase().trim();
		double last_mod = (Double) cur.get("last_mod");
		if (last_mod > lastUpdateTime) {
			lastUpdateTime = last_mod;
			lastUpdated.clear();
		}
		if (lastUpdated.contains(id)) {
			logger.info("lastUpdated skip element id : {}", id);
			return;
		}
		if (Math.abs(last_mod - lastUpdateTime) < 1e-5) {
			lastUpdated.add(id);
		}
		List<QElement> getElements = null;
		try {
			getElements = buildElements(city_code, cur);
		} catch (Exception e) {
			logger.error("build fail : {}", cur.toString(), e);
			return;
		}
		if (null == getElements) {
			banId.add(id);
			return;
		}

		int status = (Integer) cur.get("status");
		if (status == NARMAL_STATUS) {
			for (QElement e : getElements) {
				dao.indexElement(city_code, e);
			}
		} else {
			for (QElement e : getElements) {
				dao.deleteElement(city_code, e);
			}
		}
	}
}
