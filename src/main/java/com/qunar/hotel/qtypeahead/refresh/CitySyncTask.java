package com.qunar.hotel.qtypeahead.refresh;

import java.io.IOException;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Component;

import com.alibaba.fastjson.JSON;
import com.qunar.base.meerkat.http.QunarHttpClient;
import com.qunar.base.meerkat.util.PropertyUtil;
import com.qunar.flight.qmonitor.QMonitor;
import com.qunar.hotel.qtypeahead.util.PublishCity;

@Component
public class CitySyncTask extends AbstractTask {
	private QunarHttpClient client = QunarHttpClient.createDefaultClient(3000,
			3000, 200, 50);
	String URL_VERSION = PropertyUtil.getProperty("url.city.version",
			"http://qhotel.qunarman.com/api/cityversion.htm");
	String URL_CITIES = PropertyUtil.getProperty("url.city.data",
			"http://qhotel.qunarman.com/api/citydata.json");

	public Map<String, String> cityToCitycode = Collections.synchronizedMap(new HashMap<String, String>());
	public Map<String, String> cityCodeToCity = Collections.synchronizedMap(new HashMap<String, String>());

	@Override
	protected void doExecute() {

		// FIXME HTTP => RPC & single line => stream iterator
		Long remoteVersion = getRemoteCityVersion();
		if (remoteVersion == null) {
			QMonitor.recordOne("ERR_QHOTEL_CITY_VER");
			return;
		}

		if (remoteVersion <= getLocalVersion()) { // 版本未变更
			return;
		}

		List<PublishCity> cities = getRemoteCities(remoteVersion);
		if (cities == null) {
			QMonitor.recordOne("ERR_QHOTEL_SYNC_CITY");
			return;
		}

		cityToCitycode.clear();
		cityCodeToCity.clear();

		for (PublishCity next : cities) {
			cityToCitycode.put(next.getN().toLowerCase().trim(), next.getC()
					.toLowerCase().trim());
			cityCodeToCity.put(next.getC().toLowerCase().trim(), next.getN()
					.toLowerCase().trim());
		}

		updateTime(cities.size(), (double) remoteVersion);
	}

	public void refreshCity() {
		logger.info("refreshing city.");
		setLocalVersion(-1.0);
		doExecute();
	}

	public String getCityCode(String city) {
		if (null == city)
			return null;
		return cityToCitycode.get(city.toLowerCase().trim());
	}

	public String getCityName(String city_code) {
		if (null == city_code)
			return null;
		return cityCodeToCity.get(city_code.toLowerCase().trim());
	}

	/**
	 * @return 城市版本号 读取失败时返回null
	 */
	private Long getRemoteCityVersion() {
		try {
			String cityVerText = client.httpGet(URL_VERSION);
			logger.debug("city version <= {}", cityVerText);
			return Long.valueOf(cityVerText);
		} catch (IOException e) {
			logger.error("get city ver error", e);
			return null;
		}
	}

	/**
	 * @param version
	 *            城市版本号
	 * @return 城市信息列表，失败时返回null
	 */
	private List<PublishCity> getRemoteCities(long version) {

		String url = URL_CITIES + "?version=" + version;
		try {
			logger.debug("cities <= {}", url);
			return JSON.parseArray(client.httpGet(url), PublishCity.class);
		} catch (IOException e) {
			logger.error("get cities error, ver=" + version, e);
			return null;
		}
	}
}
