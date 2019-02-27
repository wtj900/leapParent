//
//  NSDate+Additions.m
//  Teacher
//
//  Created by 王史超 on 2018/1/28.
//  Copyright © 2018年 Offcn. All rights reserved.
//

#import "NSDate+Additions.h"

@implementation NSDate (Additions)

+ (NSDate *)currentZeroDate {
    return [self zeroDate:[NSDate date]];
}

+ (NSDate *)zeroDate:(NSDate *)date {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy年MM月dd日";
    NSString *dateString = [formatter stringFromDate:date];
    return [formatter dateFromString:dateString];
}

+ (NSInteger)currentZeroDateTimeInterval {
    return [self zeroDateTimeInterval:[NSDate date]];
}

+ (NSInteger)zeroDateTimeInterval:(NSDate *)date {
    return (NSInteger)([self zeroDate:date].timeIntervalSince1970 * 1000);
}

+ (NSDate *)currentEndDate {
    return [self endDate:[NSDate date]];
}

+ (NSDate *)endDate:(NSDate *)date {
    return [[self zeroDate:date] dateByAddingTimeInterval:60 * 60 * 24 - 1];
}

+ (NSInteger)currentEndDateTimeInterval {
    return [self endDateTimeInterval:[NSDate date]];
}

+ (NSInteger)endDateTimeInterval:(NSDate *)date {
    return [self timeIntervalFromDate:[self endDate:date]];
}

+ (NSInteger)timeIntervalFromDate:(NSDate *)date {
    return (NSInteger)(date.timeIntervalSince1970 * 1000);
}

+ (NSString *)chineseDateString:(NSDate *)date {
    
    NSArray *chineseYears = @[@"甲子", @"乙丑", @"丙寅", @"丁卯", @"戊辰", @"己巳", @"庚午", @"辛未", @"壬申", @"癸酉",
                              @"甲戌", @"乙亥", @"丙子", @"丁丑", @"戊寅", @"己卯", @"庚辰", @"辛己", @"壬午", @"癸未",
                              @"甲申", @"乙酉", @"丙戌", @"丁亥", @"戊子", @"己丑", @"庚寅", @"辛卯", @"壬辰", @"癸巳",
                              @"甲午", @"乙未", @"丙申", @"丁酉", @"戊戌", @"己亥", @"庚子", @"辛丑", @"壬寅", @"癸丑",
                              @"甲辰", @"乙巳", @"丙午", @"丁未", @"戊申", @"己酉", @"庚戌", @"辛亥", @"壬子", @"癸丑",
                              @"甲寅", @"乙卯", @"丙辰", @"丁巳", @"戊午", @"己未", @"庚申", @"辛酉", @"壬戌", @"癸亥"];
    
    NSArray *chineseMonths = @[@"正月",@"二月",@"三月",@"四月",@"五月",@"六月",@"七月",@"八月",@"九月",@"十月",@"冬月",@"腊月"];
    
    NSArray *chineseDays = @[@"初一", @"初二", @"初三", @"初四", @"初五", @"初六", @"初七", @"初八", @"初九", @"初十",
                             @"十一", @"十二", @"十三", @"十四", @"十五", @"十六", @"十七", @"十八", @"十九", @"二十",
                             @"廿一", @"廿二", @"廿三", @"廿四", @"廿五", @"廿六", @"廿七", @"廿八", @"廿九", @"三十"];
    
//    NSArray *chineseHours = @[@"子", @"丑", @"寅", @"卯", @"辰", @"巳", @"午", @"未", @"申", @"酉", @"戌", @"亥"];
    
    NSArray *weeks = @[@"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六"];
    
    NSCalendar *chineseCalendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierChinese];
    
    NSCalendarUnit unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitWeekday;
    NSDateComponents *dateComponents = [chineseCalendar components:unitFlags fromDate:date];
    
    NSString *week = weeks[dateComponents.weekday - 1];
    NSString *year = chineseYears[dateComponents.year - 1];
    NSString *month = chineseMonths[dateComponents.month - 1];
    NSString *day = chineseDays[dateComponents.day - 1];
    
//    NSInteger hourIndex = 0;
//    if (dateComponents.hour >= 1 && dateComponents.hour < 3) {
//        hourIndex = 1;
//    }
//    else if (dateComponents.hour >= 3 && dateComponents.hour < 5) {
//        hourIndex = 2;
//    }
//    else if (dateComponents.hour >= 5 && dateComponents.hour < 7) {
//        hourIndex = 3;
//    }
//    else if (dateComponents.hour >= 7 && dateComponents.hour < 9) {
//        hourIndex = 4;
//    }
//    else if (dateComponents.hour >= 9 && dateComponents.hour < 11) {
//        hourIndex = 5;
//    }
//    else if (dateComponents.hour >= 11 && dateComponents.hour < 13) {
//        hourIndex = 6;
//    }
//    else if (dateComponents.hour >= 13 && dateComponents.hour < 15) {
//        hourIndex = 7;
//    }
//    else if (dateComponents.hour >= 15 && dateComponents.hour < 17) {
//        hourIndex = 8;
//    }
//    else if (dateComponents.hour >= 17 && dateComponents.hour < 19) {
//        hourIndex = 9;
//    }
//    else if (dateComponents.hour >= 19 && dateComponents.hour < 21) {
//        hourIndex = 10;
//    }
//    else if (dateComponents.hour >= 21 && dateComponents.hour < 23) {
//        hourIndex = 11;
//    }
    
//    NSString *hour = chineseHours[hourIndex];
    
    return [NSString stringWithFormat:@"%@ %@%@%@",week ,year, month, day];
    
}

+ (NSDate *)monthDate:(NSDate *)date isBegin:(BOOL)isBegin {
    
    NSTimeInterval interval = 0;
    NSDate *beginDate = nil;
    NSDate *endDate = nil;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setFirstWeekday:2];//设定周一为周首日
    BOOL ok = [calendar rangeOfUnit:NSCalendarUnitMonth startDate:&beginDate interval:&interval forDate:date];
    
    if (ok) {
        endDate = [beginDate dateByAddingTimeInterval:interval - 1];
    }
    
    if (isBegin) {
        return beginDate;
    } else {
        return endDate;
    }
    
}

+ (NSDate *)dateFromTimeInterval:(NSInteger)timeInterval {
    
    NSTimeInterval cnvTimeInterval = 0;
    
    NSString *timeString = StringFromInteger(timeInterval);
    if (13 == timeString.length) {
        cnvTimeInterval = timeInterval / 1000;
    }
    else if (10 == timeString.length) {
        cnvTimeInterval = timeInterval;
    }
    else {
        return [NSDate date];
    }
    
    return [NSDate dateWithTimeIntervalSince1970:cnvTimeInterval];

}

+ (NSString *)dateStringFromTimeInterval:(NSInteger)timeInterval format:(NSString *)format {
    
    if (timeInterval <= 0) {
        return @"时间信息异常";
    }
    
    NSString *dateString = [[self dateFromTimeInterval:timeInterval] stringWithFormat:format];
    
    return dateString;
    
}

+ (NSDate *)dateFromTimeString:(NSString *)timeString format:(NSString *)format {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = format;
    NSDate *date = [formatter dateFromString:timeString];
    return date;
    
}

+ (BOOL)isSameDay:(NSDate *)oneDay twoDay:(NSDate *)twoDay {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy年MM月dd日";
    NSString *oneDayString = [formatter stringFromDate:oneDay];
    NSString *twoDayString = [formatter stringFromDate:twoDay];
    return [oneDayString isEqualToString:twoDayString];
    
}

- (OWXDatePositionType)datePositionWithOtherDay:(NSDate *)day {
    
    if ([[self class] isSameDay:self twoDay:day]) {
        return OWXDatePositionTypeSame;
    }
    else if ([[self class] timeIntervalFromDate:self] > [[self class] timeIntervalFromDate:day]) {
        return OWXDatePositionTypeLater;
    }
    else {
        return OWXDatePositionTypeBefore;
    }
    
}
@end
