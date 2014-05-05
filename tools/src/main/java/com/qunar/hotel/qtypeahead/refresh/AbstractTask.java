package com.qunar.hotel.qtypeahead.refresh;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.jdbc.core.JdbcTemplate;

import com.qunar.flight.qmonitor.QMonitor;
import com.qunar.hotel.qtypeahead.util.ExtendedProperties;

/**
 * 任务抽象类
 * 
 * @author zhongyuan.zhang
 */
public abstract class AbstractTask implements Task {

    protected Logger logger = LoggerFactory.getLogger(getClass());

    @Resource
    protected ExtendedProperties versionProperties;
    @Resource
    private ExtendedProperties intervalProperties;
    @Resource
    protected JdbcTemplate jdbcTemplate;

    /**
     * 上次任务执行时间
     */
    private long lastExecutedTime = 0;

    /**
     * 本地数据版本
     */
    private Double localVersion = null;

    /**
     * 获取当前数据库时间戳
     * 
     * @return
     */
    protected double getNowFromDB() {
        return jdbcTemplate.queryForObject("select EXTRACT(EPOCH FROM now())", Double.class);
    }

    @Override
    public void execute() {

        // 当前系统时间
        long currentTime = System.currentTimeMillis();

        // 当前时间 - 上次执行时间 > 间隔时间
        if (getInterval() * 1000 < currentTime - lastExecutedTime) {
            logger.debug("execute Start.");
            doExecute();
            lastExecutedTime = currentTime;
            logger.debug("execute End.");
        }
    }

    protected abstract void doExecute();

    protected void updateTime(int rowCount, double currentTime) {
        // update count monitor
        QMonitor.recordOne(getClass().getSimpleName() + "_SYNC");

        logger.info("count: {}", rowCount);
        if (rowCount > 0) {
            setLocalVersion(currentTime);
        }
    }

    /**
     * 获取最后版本
     * 
     * @return 初始为-1
     */
    public double getLocalVersion() {
        if (localVersion == null) {
            localVersion = versionProperties.doubleValue(this.getClass().getName(), -1);
        }

        return localVersion;
    }

    /**
     * 设置最后版本
     * 
     * @param version 为null时无效
     */
    public void setLocalVersion(Double version) {
        if (version != null) {
            this.localVersion = version;
        }
    }

    protected long getInterval() {
        return intervalProperties.longValue(this.getClass().getName(), 0);
    }
}
