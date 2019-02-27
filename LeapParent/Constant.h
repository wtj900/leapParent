//
//  Constant.h
//  Teacher
//
//  Created by 王史超 on 2018/1/15.
//  Copyright © 2018年 Offcn. All rights reserved.
//

#ifndef Constant_h
#define Constant_h

#import "OWXAdaptTool.h"
#import "NSObject+Additions.h"

// 屏幕宽高
#define SCREEN_WIDTH                  [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT                 [UIScreen mainScreen].bounds.size.height

#define iPhone4                       (([UIScreen mainScreen].bounds.size.height == 480) ? YES : NO)
#define iPhone5                       (([UIScreen mainScreen].bounds.size.height == 568) ? YES : NO)
#define iPhone6                       (([UIScreen mainScreen].bounds.size.height == 667) ? YES : NO)
#define iPhone6Plus                   (([UIScreen mainScreen].bounds.size.height == 736) ? YES : NO)
#define iPhoneX                       (([UIScreen mainScreen].bounds.size.height == 812) ? YES : NO)
#define iPad_All                      (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

#define kHeightTabBar                 49
#define iPhoneXBottomUnSafeAreaHeight (iPhoneX ? 34 : 0)

#define kHeightStatusBar              (iPhoneX ? 44 : 20)
#define kHeightNavigationBar          (iPhoneX ? 88 : 64)

#define kAdaptWidth(width)            ((width)  * [OWXAdaptTool widthAdaptScale])
#define kAdaptHeight(height)          ((height) * [OWXAdaptTool heightAdaptScale:NO])
#define kAdaptSafeHeight(height)      ((height) * [OWXAdaptTool heightAdaptScale:YES])

//获取当前系统版本
#define SystemVersion                 [[[UIDevice currentDevice] systemVersion] floatValue]

#define iOS_7                         (SystemVersion >= 7.0)
#define iOS_8                         (SystemVersion >= 8.0)
#define iOS_9                         (SystemVersion >= 9.0)
#define iOSAvailable_11               @available(iOS 11.0, *)

// 颜色设定
#define RGBColor(r, g, b)             RGBAColor(r, g, b, 1)
#define RGBAColor(r, g, b, a)         [UIColor colorWithRed:r / 255. green:g / 255. blue:b / 255. alpha:a]

#define HEXColor(hexValue)            HEXAColor(hexValue, 1)
#define HEXAColor(hexValue, a)        [UIColor colorWithRed:(hexValue >> 16) / 255. green:(hexValue >> 8 & 0xFF) / 255. blue:(hexValue & 0xFF) / 255. alpha:a]

#define ThemeColor                    RGBColor(97, 159, 255)
#define ThemeAColor(a)                RGBAColor(97, 159, 255, a)

#define LineColor                     RGBColor(235, 235, 235)

// 字体设定
#define FontMediumSize(a)             [UIFont fontWithName:@"PingFangSC-Medium" size:kAdaptWidth(a)]
#define FontRegularSize(a)            [UIFont fontWithName:@"PingFangSC-Regular" size:kAdaptWidth(a)]
#define FontSystemSize(a)             [UIFont systemFontOfSize:kAdaptWidth(a)]
#define FontBoldSize(a)               [UIFont boldSystemFontOfSize:kAdaptWidth(a)]

// STRING转换
#define StringFromInt(int)            [NSString stringWithFormat:@"%d", int]
#define StringFromFloat(float)        [NSString stringWithFormat:@"%f", float]
#define StringFromInteger(integer)    [NSString stringWithFormat:@"%ld", (long)integer]
#define StringFromNumber(number)      [NSString stringWithFormat:@"%@", number]

// STRING容错机制
#define IS_NULL(x)                    (!x || [x isKindOfClass:[NSNull class]])
#define IS_EMPTY_STRING(x)            (IS_NULL(x) || [x isEqual:@""] || [x isEqual:@"(null)"])
#define DEFUSE_EMPTY_STRING(x)        (!IS_EMPTY_STRING(x) ? x : @"")
#define PLACE_EMPTY_STRING(x,place)   (IS_EMPTY_STRING(x) ? place : x)

// 数据解析容错机制
#define IntegerFormDict(dict,key)     [[dict decodeStringFormDictWithKey:key] integerValue]
#define StringFormDict(dict,key)      [dict decodeStringFormDictWithKey:key]
#define ArrayFormDict(dict,key)       [dict decodeArrayFormDictWithKey:key]
#define DictionaryFormDict(dict,key)  [dict decodeDictionaryFormDictWithKey:key]

// KeyWindow
#define KeyWindow                     [UIApplication sharedApplication].keyWindow

// Notification Keys
extern NSString * const OWXAPPSwitchRootViewControllerNotification;

// UserDefault Keys
//extern NSString * const OWXUserDefaultNameCurrentClassId;

// Archive Keys
//extern NSString * const OWXFileArchiveNameClassList;


#define IFLY_APPID_VALUE              @"5b35cc3b"

#endif /* Constant_h */
