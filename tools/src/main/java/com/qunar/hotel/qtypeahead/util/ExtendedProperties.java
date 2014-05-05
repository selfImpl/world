package com.qunar.hotel.qtypeahead.util;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.Properties;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.core.io.Resource;

/**
 * 扩展属性
 * 
 * @author zhongyuan.zhang
 */
public class ExtendedProperties extends Properties {

    private static final long serialVersionUID = 8419842392684607254L;

    private Logger logger = LoggerFactory.getLogger(getClass());

    public int intValue(String key, int defaultValue) {
        try {
            return parseInt(key, 10);
        } catch (NumberFormatException e) {
        }
        return defaultValue;
    }

    public long longValue(String key) {
        return longValue(key, 0L);
    }

    public long longValue(String key, long defaultValue) {
        try {
            return parseLong(key, 10);
        } catch (NumberFormatException e) {
        }
        return defaultValue;
    }

    public double doubleValue(String key, double defaultValue) {
        try {
            String property = getProperty(key);
            if (property != null)
                return Double.parseDouble(getProperty(key));
        } catch (NumberFormatException e) {
        }
        return defaultValue;
    }

    public int parseInt(String key, int radix) throws NumberFormatException {
        return Integer.parseInt(getProperty(key), radix);
    }

    public long parseLong(String key, int radix) throws NumberFormatException {
        return Long.parseLong(getProperty(key), radix);
    }

    /** 文件路径 */
    private Resource configLocation;
    private String fileLocation;

    public void setFileLocation(String fileLocation) {
        this.fileLocation = fileLocation;
    }

    public void setConfigLocation(Resource configLocation) {
        this.configLocation = configLocation;
    }

    public void store() {

        File file = null;

        try {
            file = getFile();
            logger.debug("store => {}", file);
            store(new FileOutputStream(file), "");
        } catch (Exception e) {
            logger.error("store config to {} failed", file, e);
        }
    }

    private File getFile() throws IOException {
        if (configLocation != null) {
            return configLocation.getFile();
        }
        return new File(fileLocation);
    }

    public void load() throws Exception {

        if (configLocation == null && fileLocation == null) {
            throw new IllegalArgumentException("'configLocation' is required.");
        }

        File file = getFile();
        if (!file.exists()) {
            logger.warn("{} does not exist, create a new one", file);

            if (!file.createNewFile()) {
                logger.error("create {} failed", file);
            }
        }

        logger.info("Load config Start. <= {}", file);
        load(new FileInputStream(file));
        logger.info("Load config End.");
    }
}
