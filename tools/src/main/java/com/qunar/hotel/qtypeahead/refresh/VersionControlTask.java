package com.qunar.hotel.qtypeahead.refresh;

import java.io.File;
import java.io.FileOutputStream;
import java.io.ObjectOutputStream;
import java.util.LinkedList;
import java.util.List;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.BeansException;
import org.springframework.beans.factory.InitializingBean;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;
import org.springframework.stereotype.Component;

import com.qunar.base.meerkat.util.PropertyUtil;
import com.qunar.hotel.qtypeahead.datastructure.QTypeaheadManager;
import com.qunar.hotel.qtypeahead.util.ExtendedProperties;

/**
 * 定期讲内存数据和版本写入磁盘
 * 
 * @author zhongyuan.zhang
 */
@Component
public class VersionControlTask implements Task, InitializingBean, ApplicationContextAware {

    private final Logger logger = LoggerFactory.getLogger(getClass());

    private List<AbstractTask> tasks = new LinkedList<AbstractTask>();

    private long lastExecutedTime = 0;

    @Resource
    private QTypeaheadManager typeahead;
    @Resource
    private ExtendedProperties versionProperties;
    @Resource
    private ExtendedProperties intervalProperties;

    public void storeVersions() {
    	doExecute();
    	lastExecutedTime = System.currentTimeMillis();
    }
    
    @Override
    public void execute() {
        long currentTime = System.currentTimeMillis();
        if (getInterval() * 1000 < currentTime - lastExecutedTime) {
            logger.debug("execute Start.");

            doExecute();
            lastExecutedTime = currentTime;

            logger.debug("execute End.");
        }
    }

    private static final String SYNC_TEMP_DIR = PropertyUtil.getProperty("sync.store", "./");
    
    private synchronized void doExecute() {
        logger.info("commit data");
        
        if(commitTypeaheadData()) {
	        for (AbstractTask task : tasks) {
	            versionProperties.setProperty(task.getClass().getName(), String.valueOf(task.getLocalVersion()));
	        }
        }

        versionProperties.store();
    }
    
    private boolean commitTypeaheadData() {
        File tmpDict = new File(SYNC_TEMP_DIR, "dict-" + System.currentTimeMillis());
        
        logger.info("Export dict Start => {}", tmpDict);
        try {
			typeahead.serialize(new ObjectOutputStream(new FileOutputStream(tmpDict)));
		} catch (Exception e) {
			logger.error("Dict export error.", e);
		}
        logger.info("Export dict End.");
        File target = new File(typeahead.getDictPath());
        if (tmpDict != null && tmpDict.renameTo(target)) {
            logger.info("rename dict {} => {}", tmpDict, target);
            return true;
        } else {
            logger.error("rename failed {} => {}", tmpDict, target);
            return false;
        }
    }

    protected long getInterval() {
        return intervalProperties.longValue(VersionControlTask.class.getName(), 3600L * 24);
    }

    @Override
    public void afterPropertiesSet() throws Exception {
    	//cleo
        //tasks.add(applicationContext.getBean(QTypeaheadRefreshTask.class));
    	//city
    	tasks.add(applicationContext.getBean(CitySyncTask.class));
    	//array
    	tasks.add(applicationContext.getBean(QTypeaheadRefreshTask.class));
    }

    public List<AbstractTask> getTasks() {
        return tasks;
    }

    private ApplicationContext applicationContext;

    @Override
    public void setApplicationContext(ApplicationContext applicationContext) throws BeansException {
        this.applicationContext = applicationContext;
    }
}
