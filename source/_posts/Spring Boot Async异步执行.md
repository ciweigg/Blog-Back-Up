title: Spring Boot Async异步执行
date: 2018-01-19 10:19:12
tags: [SpringBoot]
categories: [SpringBoot]
---
异步调用就是不用等待结果的返回就执行后面的逻辑，同步调用则需要等带结果再执行后面的逻辑。

通常我们使用异步操作都会去创建一个线程执行一段逻辑，然后把这个线程丢到线程池中去执行，代码如下：
<!--more-->
```
ExecutorService executorService = Executors.newFixedThreadPool(10);
executorService.execute(() -> {
    try {
        // 业务逻辑
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
    }
 });
 ```
这样的方式看起来没那么优雅，尽管用了java的lambda。在Spring Boot中有一种更简单的方式来执行异步操作，只需要一个@Async注解即可。

```
@Async
public void saveLog() {
    System.err.println(Thread.currentThread().getName());
}
```
我们可以直接在Controller中调用这个业务方法，它就是异步执行的，会在默认的线程池中去执行。需要注意的是一定要在外部的类中去调用这个方法，如果在本类调用是不起作用的，比如this.saveLog()。 最后在启动类上开启异步任务的执行，添加@EnableAsync即可。

另外关于执行异步任务的线程池我们也可以自定义，首先我们定义一个线程池的配置类，用来配置一些参数，具体代码如下：

```
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Configuration;  

/**
 * 异步任务线程池配置
 * 
 * @author yinjihuan
 */
@Configuration
@ConfigurationProperties(prefix = "spring.task.pool")
public class TaskThreadPoolConfig { 

    //核心线程数
    private int corePoolSize = 5;  

    //最大线程数
    private int maxPoolSize = 50;  

    //线程池维护线程所允许的空闲时间
    private int keepAliveSeconds = 60;  

    //队列长度
    private int queueCapacity = 10000;

    //线程名称前缀
    private String threadNamePrefix = "FSH-AsyncTask-";

    public String getThreadNamePrefix() {
        return threadNamePrefix;
    }

    public void setThreadNamePrefix(String threadNamePrefix) {
        this.threadNamePrefix = threadNamePrefix;
    }

    public int getCorePoolSize() {
        return corePoolSize;
    }

    public void setCorePoolSize(int corePoolSize) {
        this.corePoolSize = corePoolSize;
    }

    public int getMaxPoolSize() {
        return maxPoolSize;
    }

    public void setMaxPoolSize(int maxPoolSize) {
        this.maxPoolSize = maxPoolSize;
    }

    public int getKeepAliveSeconds() {
        return keepAliveSeconds;
    }

    public void setKeepAliveSeconds(int keepAliveSeconds) {
        this.keepAliveSeconds = keepAliveSeconds;
    }

    public int getQueueCapacity() {
        return queueCapacity;
    }

    public void setQueueCapacity(int queueCapacity) {
        this.queueCapacity = queueCapacity;
    }

}
```
然后我们重新定义线程池的配置：

```
import java.lang.reflect.Method;
import java.util.concurrent.Executor;
import java.util.concurrent.ThreadPoolExecutor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.aop.interceptor.AsyncUncaughtExceptionHandler;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.scheduling.annotation.AsyncConfigurer;
import org.springframework.scheduling.concurrent.ThreadPoolTaskExecutor;

@Configuration  
public class AsyncTaskExecutePool implements AsyncConfigurer {    
    private Logger logger = LoggerFactory.getLogger(AsyncTaskExecutePool.class);

    @Autowired    
    private TaskThreadPoolConfig config;

    @Override  
    public Executor getAsyncExecutor() {  
        ThreadPoolTaskExecutor executor = new ThreadPoolTaskExecutor();  
        executor.setCorePoolSize(config.getCorePoolSize());    
        executor.setMaxPoolSize(config.getMaxPoolSize());    
        executor.setQueueCapacity(config.getQueueCapacity());    
        executor.setKeepAliveSeconds(config.getKeepAliveSeconds());    
        executor.setThreadNamePrefix(config.getThreadNamePrefix());
        //线程池对拒绝任务（无线程可用）的处理策略，目前只支持AbortPolicy、CallerRunsPolicy
        //AbortPolicy:直接抛出java.util.concurrent.RejectedExecutionException异常 -->
        //CallerRunsPolicy:主线程直接执行该任务，执行完之后尝试添加下一个任务到线程池中，可以有效降低向线程池内添加任务的速度 -->
        //DiscardOldestPolicy:抛弃旧的任务、暂不支持；会导致被丢弃的任务无法再次被执行 -->
        //DiscardPolicy:抛弃当前任务、暂不支持；会导致被丢弃的任务无法再次被执行 -->
        executor.setRejectedExecutionHandler(new ThreadPoolExecutor.CallerRunsPolicy());  
        executor.initialize();    
        return executor;    
    }  

    @Override  
    public AsyncUncaughtExceptionHandler getAsyncUncaughtExceptionHandler() {// 异步任务中异常处理  
        return new AsyncUncaughtExceptionHandler() {  
            @Override  
            public void handleUncaughtException(Throwable arg0, Method arg1, Object... arg2) {  
                logger.error("=========================="+arg0.getMessage()+"=======================", arg0);  
                logger.error("exception method:" + arg1.getName());  
            }  
        };  
    }    
}
```
配置完之后我们的异步任务执行的线程池就是我们自定义的了，我们可以通过在属性文件里面配置线程池的大小等等信息，也可以使用默认的配置：

spring.task.pool.maxPoolSize=100
最后讲下线程池配置的拒绝策略，当我们的线程数量高于线程池的处理速度时，任务会被缓存到本地的队列中，队列也是有大小的，如果超过了这个大小，我们需要有拒绝的策略，不然就会内存溢出了，目前支持2中拒绝策略：

AbortPolicy: 直接抛出java.util.concurrent.RejectedExecutionException异常
CallerRunsPolicy: 主线程直接执行该任务，执行完之后尝试添加下一个任务到线程池中，可以有效降低向线程池内添加任务的速度
建议大家用CallerRunsPolicy策略，因为当队列中的任务满了之后，如果直接抛异常，那么这个任务就会被丢弃，如果是CallerRunsPolicy策略会用主线程去执行，就是同步执行，最起码这样任务不会丢弃。