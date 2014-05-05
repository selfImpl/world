package com.qunar.hotel.qtypeahead.refresh;

import java.util.LinkedList;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.BeansException;
import org.springframework.beans.factory.InitializingBean;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;
import org.springframework.stereotype.Component;


/**
 * 任务集合
 * <p>
 * Quartz负责执行的唯一任务单元
 * 
 * @author zhongyuan.zhang
 */
@Component
public class TaskSuite implements Task, InitializingBean, ApplicationContextAware {

    private Logger logger = LoggerFactory.getLogger(getClass());

    private List<Task> tasks;

    public static boolean initialized = false;

    public void execute() {

        if (!initialized) {
            // 未初始化完成时，不执行定时任务
            logger.info("Not ready");
            return;
        }

        doExecute();
    }

    public void doExecute() {
        for (Task task : tasks) {
            try {
                task.execute();
            } catch (Exception e) {
                logger.error(task.getClass().getName() + " exception.", e);
            }
        }
    }

    @Override
    public void afterPropertiesSet() throws Exception {
        tasks = new LinkedList<Task>();
        //cleo
        //tasks.add(applicationContext.getBean(QTypeaheadRefreshTask.class));
        //city
        tasks.add(applicationContext.getBean(CitySyncTask.class));
        //array
        tasks.add(applicationContext.getBean(QTypeaheadRefreshTask.class));
        tasks.add(applicationContext.getBean(VersionControlTask.class));
    }

    private ApplicationContext applicationContext;

    @Override
    public void setApplicationContext(ApplicationContext applicationContext) throws BeansException {
        this.applicationContext = applicationContext;
    }
}
