//
//  NSDate+Additions.h
//  Teacher
//
//  Created by 王史超 on 2018/1/28.
//  Copyright © 2018年 Offcn. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, OWXDatePositionType) {
    OWXDatePositionTypeBefore = -1,
    OWXDatePositionTypeSame,
    OWXDatePositionTypeLater
};

@interface NSDate (Additions)

+ (NSDate *)currentZeroDate;

+ (NSDate *)zeroDate:(NSDate *)date;

+ (NSInteger)currentZeroDateTimeInterval;

+ (NSInteger)zeroDateTimeInterval:(NSDate *)date;

+ (NSDate *)currentEndDate;

+ (NSDate *)endDate:(NSDate *)date;

+ (NSInteger)currentEndDateTimeInterval;

+ (NSInteger)endDateTimeInterval:(NSDate *)date;

+ (NSString *)chineseDateString:(NSDate *)date;

+ (NSDate *)monthDate:(NSDate *)date isBegin:(BOOL)isBegin;

+ (NSDate *)dateFromTimeInterval:(NSInteger)timeInterval;

+ (NSString *)dateStringFromTimeInterval:(NSInteger)timeInterval format:(NSString *)format;

+ (NSInteger)timeIntervalFromDate:(NSDate *)date;

+ (NSDate *)dateFromTimeString:(NSString *)timeString format:(NSString *)format;

+ (BOOL)isSameDay:(NSDate *)oneDay twoDay:(NSDate *)twoDay;

- (OWXDatePositionType)datePositionWithOtherDay:(NSDate *)day;

@end
