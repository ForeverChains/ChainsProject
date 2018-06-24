//
//  NSDate+Chains.m
//  MyConclusion
//
//  Created by 马腾飞 on 15/9/23.
//  Copyright (c) 2015年 mtf. All rights reserved.
//

#import "NSDate+Chains.h"

NSString *const kNSDateFormatWeekday          = @"EEEE";
NSString *const kNSDateFormatDate             = @"yyyy-MM-dd";
NSString *const kNSDateFormatTime             = @"HH:mm:ss";
NSString *const kNSDateFormatDateWithTime     = @"yyyy-MM-dd HH:mm:ss";

@implementation NSDate (Chains)

//经常创建NSDateFormatter与NSCalendar会影响性能
static NSCalendar *_calendar = nil;
static NSDateFormatter *_displayFormatter = nil;

+ (void)initializeStatics {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        @autoreleasepool {
            if (_calendar == nil) {
#if __has_feature(objc_arc)
                _calendar = [NSCalendar currentCalendar];
#else
                _calendar = [[NSCalendar currentCalendar] retain];
#endif
            }
            if (_displayFormatter == nil) {
                _displayFormatter = [[NSDateFormatter alloc] init];
            }
        }
    });
}

+ (NSCalendar *)sharedCalendar {
    [self initializeStatics];
    return _calendar;
}

+ (NSDateFormatter *)sharedDateFormatter {
    [self initializeStatics];
    return _displayFormatter;
}

- (BOOL)chains_isSameToDate:(NSDate *)date
{
    NSCalendar *calendar = [[self class] sharedCalendar];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *compsSelf = [calendar components:unitFlags fromDate:self];
    NSDateComponents *compsOther = [calendar components:unitFlags fromDate:date];
    if(compsSelf.year == compsOther.year &&
       compsSelf.month == compsOther.month &&
       compsSelf.day == compsOther.day &&
       compsSelf.hour == compsOther.hour &&
       compsSelf.minute == compsOther.minute &&
       compsSelf.second == compsOther.second) {
        return YES;
    }
    return NO;
}

+ (NSDate *)chains_getDateWithHour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second
{
    //获取当前时间
    NSDate *currentDate = [NSDate date];
    NSCalendar *currentCalendar = [[self class] sharedCalendar];
    
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    NSDateComponents *currentComps = [currentCalendar components:unitFlags fromDate:currentDate];
    
    //设置当天的某个点
    NSDateComponents *resultComps = [[NSDateComponents alloc] init];
    [resultComps setYear:[currentComps year]];
    [resultComps setMonth:[currentComps month]];
    [resultComps setDay:[currentComps day]];
    [resultComps setHour:hour];
    [resultComps setMinute:minute];
    [resultComps setSecond:second];
    
    return [currentCalendar dateFromComponents:resultComps];
}

+ (NSString *)chains_dateToString:(NSDate *)date withDateFormat:(NSString *)format
{
    NSDateFormatter *dateFormatter = [self sharedDateFormatter];
    [dateFormatter setDateFormat:format];
    return [dateFormatter stringFromDate:date];
}

+ (NSDate *)chains_stringToDate:(NSString *)timeStr withDateFormat:(NSString *)format
{
    NSDateFormatter *dateFormatter = [self sharedDateFormatter];
    [dateFormatter setDateFormat:format];
    return [dateFormatter dateFromString:timeStr];
}

+ (NSDate *)chains_timeStampToDate:(NSTimeInterval)timestamp
{
    return [self dateWithTimeIntervalSince1970:timestamp];
}

+ (NSString *)chains_timeStampToString:(NSTimeInterval)timeStamp withDateFormat:(NSString *)format
{
    NSDate *date = [self dateWithTimeIntervalSince1970:timeStamp];
    return [self chains_dateToString:date withDateFormat:format];
}

+ (NSTimeInterval)chains_dateToTimeStamp:(NSDate *)date
{
    return (long)[date timeIntervalSince1970];
}

+ (NSTimeInterval)chains_stringToTimeStamp:(NSString *)timeStr withDateFormat:(NSString *)format
{
    NSDate *date = [self chains_stringToDate:timeStr withDateFormat:format];
    return [NSDate chains_dateToTimeStamp:date];
}

+ (NSDateComponents *)chains_compareDateFrom:(NSDate *)beginDate to:(NSDate *)endDate
{
    NSCalendar *calendar = [[self class] sharedCalendar];
    // 需要对比的时间数据
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth
    | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    // 对比时间差
    NSDateComponents *dateCom = [calendar components:unit fromDate:beginDate toDate:endDate options:0];
    NSLog(@"dateCom %ld年%ld月%ld日%ld时%ld分",(long)dateCom.year,(long)dateCom.month,(long)dateCom.day,(long)dateCom.hour,(long)dateCom.minute);
    return dateCom;
}

+ (NSDate *)chains_timeOverlap:(NSTimeInterval)value since:(NSDate *)date
{
    return [NSDate dateWithTimeInterval:value sinceDate:date];
}

+ (NSString *)chains_compareTimeStampFrom:(NSTimeInterval)earlyTime to:(NSTimeInterval)lateTime
{
    NSTimeInterval cha = lateTime - earlyTime;
    
    NSInteger day;
    NSInteger hour;
    NSInteger min;
    NSInteger sec;
    NSString *str;
    if (cha/86400 > 1)
    {
        day = cha/86400;
        hour = (cha - day*86400)/3600;
        min = (cha - day*86400 - hour*3600)/60;
        if (hour == 0)
        {
            str = [NSString stringWithFormat:@"相差%ld天",day];
        }
        else
        {
            str = [NSString stringWithFormat:@"相差%ld天%ld小时",day,hour];
        }
    }
    else if (cha/3600 > 1)
    {
        hour = cha/3600;
        min = (cha - hour*3600)/60;
        if (min == 0)
        {
            str = [NSString stringWithFormat:@"相差%ld小时",hour];
        }
        else
        {
            str = [NSString stringWithFormat:@"相差%ld小时%ld分钟",hour,min];
        }
    }
    else
    {
        div_t time = div(cha,60);
        min = time.quot;
        sec = time.rem;
        if (min == 0)
        {
            str = [NSString stringWithFormat:@"相差%ld秒",sec];
        }
        else
        {
            str = [NSString stringWithFormat:@"相差%ld分钟%ld秒",min,sec];
        }
    }
    NSLog(@"%@",str);
    return str;
}

- (NSUInteger)chains_hour
{
    NSCalendar *calendar = [[self class] sharedCalendar];
    NSDateComponents *weekdayComponents = [calendar components:(NSCalendarUnitHour) fromDate:self];
    return [weekdayComponents hour];
}

- (NSUInteger)chains_minute
{
    NSCalendar *calendar = [[self class] sharedCalendar];
    NSDateComponents *weekdayComponents = [calendar components:(NSCalendarUnitMinute) fromDate:self];
    return [weekdayComponents minute];
}

- (NSUInteger)chains_year
{
    NSCalendar *calendar = [[self class] sharedCalendar];
    NSDateComponents *weekdayComponents = [calendar components:(NSCalendarUnitYear) fromDate:self];
    return [weekdayComponents year];
}

- (NSUInteger)chains_weekday
{
    NSDateComponents *weekdayComponents = [[[self class] sharedCalendar] components:(NSCalendarUnitWeekday) fromDate:self];
    return [weekdayComponents weekday];
}

- (NSUInteger)chains_weekNumberOfMonth
{
    NSCalendar *calendar = [[self class] sharedCalendar];
    NSDateComponents *dateComponents = [calendar components:(NSCalendarUnitWeekOfMonth) fromDate:self];
    return [dateComponents weekOfMonth];
}

- (NSUInteger)chains_weekNumberOfYear
{
    NSCalendar *calendar = [[self class] sharedCalendar];
    NSDateComponents *dateComponents = [calendar components:(NSCalendarUnitWeekOfYear) fromDate:self];
    return [dateComponents weekOfYear];
}

@end
