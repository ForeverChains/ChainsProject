//
//  NSDate+Chains.h
//  MyConclusion
//
//  Created by 马腾飞 on 15/9/23.
//  Copyright (c) 2015年 mtf. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 格式化参数如下：
 G: 公元时代，例如AD公元
 yy: 年的后2位
 yyyy: 完整年
 MM: 月，显示为1-12
 MMM: 月，显示为英文月份简写,如 Jan
 MMMM: 月，显示为英文月份全称，如 Janualy
 dd: 日，2位数表示，如02
 d: 日，1-2位显示，如 2
 EEE: 简写星期几，如Sun
 EEEE: 全写星期几，如Sunday
 aa: 上下午，AM/PM
 H: 时，24小时制，0-23
 K：时，12小时制，0-11
 m: 分，1-2位
 mm: 分，2位
 s: 秒，1-2位
 ss: 秒，2位
 S: 毫秒
 
 常用日期结构：
 yyyy-MM-dd HH:mm:ss.SSS
 yyyy-MM-dd HH:mm:ss
 yyyy-MM-dd
 */

UIKIT_EXTERN NSString *const kNSDateFormatWeekday;
UIKIT_EXTERN NSString *const kNSDateFormatDate;
UIKIT_EXTERN NSString *const kNSDateFormatTime;
UIKIT_EXTERN NSString *const kNSDateFormatDateWithTime;

@interface NSDate (Chains)

+ (NSCalendar *)sharedCalendar;
+ (NSDateFormatter *)sharedDateFormatter;

/**
 *  Compare the two date is same date (Currently include the hour、 minute and second,which can be removed).
 *
 *  @param date The other date
 *
 *  @return true/false
 */
- (BOOL)chains_isSameToDate:(NSDate *)date;

/**
 获取当天的某个时间点
 */
+ (NSDate *)chains_getDateWithHour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second;

/**
 *  NSDate-->NSString
 *
 *  @param date   日期
 *  @param format 格式
 */
+ (NSString *)chains_dateToString:(NSDate *)date withDateFormat:(NSString *)format;

/**
 *  NSString-->NSDate
 *
 *  @param timeStr 字符串
 *  @param format  格式
 */
+ (NSDate *)chains_stringToDate:(NSString *)timeStr withDateFormat:(NSString *)format;


/**
 *  NSDate-->时间戳
 *
 *  @param date 日期
 */
+ (NSTimeInterval)chains_dateToTimeStamp:(NSDate *)date;


/**
 *  时间戳-->NSDate
 *
 *  @param timestamp 时间戳
 */
+ (NSDate *)chains_timeStampToDate:(NSTimeInterval)timestamp;


/**
 *  时间戳-->NSString
 *
 *  @param timestamp 时间戳
 */
+ (NSString *)chains_timeStampToString:(NSTimeInterval)timestamp withDateFormat:(NSString *)format;

/**
 *  NSString-->时间戳
 *
 *  @param timeStr 字符串
 *  @param format  格式
 */
+ (NSTimeInterval)chains_stringToTimeStamp:(NSString *)timeStr withDateFormat:(NSString *)format;


/**
 两个日期相隔时间
 */
+ (NSDateComponents *)chains_compareDateFrom:(NSDate *)earlyTime to:(NSDate *)lateTime;


/**
 叠加时间

 @param value 需要叠加的时间戳
 @param date 起始时间
 */
+ (NSDate *)chains_timeOverlap:(NSTimeInterval)value since:(NSDate *)date;


+ (NSString *)chains_compareTimeStampFrom:(NSTimeInterval)earlyTime to:(NSTimeInterval)lateTime;

- (NSUInteger)chains_hour;

- (NSUInteger)chains_minute;

- (NSUInteger)chains_year;

- (NSUInteger)chains_weekday;

- (NSUInteger)chains_weekNumberOfMonth;

- (NSUInteger)chains_weekNumberOfYear;

@end
