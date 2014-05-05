package com.qunar.hotel.qtypeahead.util;

import com.qunar.base.meerkat.util.PropertyUtil;
import com.qunar.hotel.algorithms.nlp.PinYinService;
import com.qunar.hotel.qtypeahead.refresh.CitySyncTask;
import com.qunar.hotel.qtypeahead.refresh.QTypeaheadRefreshTask;
import com.qunar.hotel.qtypeahead.refresh.TaskSuite;
import com.qunar.hotel.qtypeahead.refresh.VersionControlTask;
import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.ApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

/**
 * 启动初始化
 * <p>
 * 避免，启动时数据初始化时间过长，发布检测服务端口始终为404，导致的超时发布失败。
 * 
 * @author zhongyuan.zhang
 */
public class InitLoadListener implements ServletContextListener {

	private Logger logger = LoggerFactory.getLogger(getClass());

	@Override
	public void contextInitialized(ServletContextEvent sce) {
		logger.info("Init load Start.");
		ApplicationContext context = WebApplicationContextUtils
				.getWebApplicationContext(sce.getServletContext());

		while (true) {
			CitySyncTask cityManager = context.getBean(CitySyncTask.class);
			cityManager.refreshCity();
			String testname = cityManager.getCityName("beijing_city");
			if (!StringUtils.isEmpty(testname))
				break;
			logger.warn("get city & city_codes error, try again.");
			try {
				Thread.sleep(1000);
			} catch (InterruptedException e) {
				logger.error("get city error.", e);
			}
		}
		logger.info("refresh city done.");
		QTypeaheadRefreshTask typeahead = context
				.getBean(QTypeaheadRefreshTask.class);
		typeahead.initTypeahead();
		logger.info("QTypeaheadRefreshTask done.");
		VersionControlTask versions = context.getBean(VersionControlTask.class);
		versions.storeVersions();
		logger.info("VersionControlTask done.");
		
		PinYinService.addUserDict(PropertyUtil.getProperty("my.pinyin.dat", ""));
		PinYinService.getPinYin("哈哈哈哈", "");
		logger.info("PinYinService init done.");
		
		TaskSuite.initialized = true;

		logger.info("Init load End.");
	}

	@Override
	public void contextDestroyed(ServletContextEvent sce) {

	}
}
