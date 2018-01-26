title: Java8新特性-时间格式化
date: 2018-01-25 11:00:32
tags: [JAVA]
categories: [JAVA]
---
### 解析与格式化

java.time.format.DateTimeFormatter 类：该类提供了三种格式化方法：
1.预定义的标准格式
2.语言环境相关的格式
3.自定义的格式
<!--more-->
### 测试代码
```
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.temporal.TemporalAccessor;
import java.util.Locale;

import org.junit.Test;

public class TimeFormatTest {
	/*
	 * 时间格式化：java.time.format.DateTimeFormatter 
	 * 	1.默认提供
	 * 	2.自定义格式
	 * 格式化步骤:
	 *	1.新建一个DateTimeFormatter对象（有静态对象，也可以自己创建[自己创建是调用ofPattern方法]）。	
	 *	2.调用该对象的format方法，参数是需要格式化的LocalDateTime对象。
	 * 解析步骤：
	 * 	1.新建一个时间的字符串对象。
	 * 	2.新建一个DateTimeFormatter对象（有静态对象，也可以自己创建[自己创建是调用ofPattern方法]）。
	 * 	3.调用DateTimeFormatter对象的parse方法，进行解析，返回一个TemporalAccessor对象。
	 * 	4.调用LocalDateTime的静态方法form，将TemporalAccessor转换成LocalDateTime对象。
	 */
	
	// 时间格式化：1.默认提供
	@Test
	public void test1() {
		// 1.新建一个DateTimeFormatter对象（有静态对象，也可以自己创建）
		DateTimeFormatter isoDate = DateTimeFormatter.ISO_DATE;
		
		LocalDateTime ldt1 = LocalDateTime.now();
		
		// 2.调用该对象的format方法，参数是需要格式化的LocalDateTime对象。
		String format = isoDate.format(ldt1);
		
		System.out.println("时间是：" + format);
	}
	/*
	 * 结果：
	 * 	时间是：2018-01-22
	 */
	
	// 时间格式化：2.自定义格式
	@Test
	public void test2() {
		// 1.新建一个DateTimeFormatter对象（有静态对象，也可以自己创建[自己创建是调用ofPattern方法]）
		DateTimeFormatter pattern = DateTimeFormatter.ofPattern("yyyy年MM月dd日 HH时mm分ss秒", Locale.CHINA);
		
		// 2.调用该对象的format方法，参数是需要格式化的LocalDateTime对象。
		String format = pattern.format(LocalDateTime.now());
		
		System.out.println("时间是：" + format);
	}
	/*
	 * 结果：
	 * 	时间是：2018年01月22日 11时30分55秒
	 */
	
	// 时间解析：自定义格式
	@Test
	public void test3() {
		// 1.新建一个时间的字符串对象。
		String dateTime = "2017年12月30日 13点20分30秒";
		
		// 2.新建一个DateTimeFormatter对象（有静态对象，也可以自己创建[自己创建是调用ofPattern方法]）。
		DateTimeFormatter pattern = DateTimeFormatter.ofPattern("yyyy年MM月dd日 HH点mm分ss秒");

		// 3.调用DateTimeFormatter对象的parse方法，进行解析，返回一个TemporalAccessor对象。
		TemporalAccessor parse = pattern.parse(dateTime);

		// 4.调用LocalDateTime的静态方法form，将TemporalAccessor转换成LocalDateTime对象。
		LocalDateTime ldt1 = LocalDateTime.from(parse);
		
		System.out.println("LocalDateTime：" + ldt1);
	}
	/*
	 * 结果：
	 * 	LocalDateTime：2017-12-30T13:20:30
	 */
	 
	     /*
     * TemporalAdjuster: 时间校正器,这是个接口。
     * TemporalAdjusters:时间矫正器的一个工具类，提供了一些对TemporalAdjuster接口的具体实现类。
     *
     * 使用步骤：
     * 	1.调用LocalDateTime的with方法。
     * 	2.在with方法中传入TemporalAdjuster
     */

    // 使用TemporalAdjusters工具类。
    @Test
    public void test4() {
        LocalDateTime ldt1 = LocalDateTime.now();
        System.out.println("现在是：" + ldt1);

//        LocalDateTime ldt2 = ldt1.plusDays(1); //获取当前日期的下一天
//        LocalDateTime ldt2 = ldt1.plusDays(-1); //获取当前日期的前一天
        LocalDateTime ldt2 = ldt1.with(TemporalAdjusters.next(DayOfWeek.SUNDAY)); //获取下一个周日
        //日期格式化
        DateTimeFormatter isoDate = DateTimeFormatter.ISO_DATE;
        String dates = isoDate.format(ldt2);
        System.out.println("下一个日期：" + ldt2);
    }
    
    /*
     * 3.计算时间差/日期差
     * 	Duration:用于计算两个“时间”间隔
     * 	Period:用于计算两个“日期”间隔
     */
    @Test
    public void test5() {
        Instant ins1 = Instant.now();
        for (int i = 0; i < 1000*10000; i++) {
            //为了测试时间间隔，不做任何处理这边。
        }
        Instant ins2 = Instant.now();
        /*
         * Duration.between：传Instant/LocalDateTime都行。
         */
        // 1.Duration.between:计算两个时间间隔，返回一个Duration对象
        Duration between = Duration.between(ins1,ins2);

        // 2.Duration的toXxx方法：转换成对应的时间单位
        System.out.println("时间间隔：" + between.toMillis() + "s");


        /*
         * Period.between:计算两个日期的间隔，返回一个Period对象
         */
        LocalDate ld1 = LocalDate.now();

        LocalDate ld2 = LocalDate.of(2018, 10, 20);

        Period period = Period.between(ld1, ld2);

        // 相差 多少年 多少月 多少天
        System.out.println(period.getYears());
        System.out.println(period.getMonths());
        System.out.println(period.getDays());
        System.out.println("相差："+ period.getYears()+"年"+period.getMonths()+"月"+period.getDays()+"天");
    }
    
}
```