//
//  OWXAPPInfoTool.h
//  Teacher
//
//  Created by 王史超 on 2018/1/26.
//  Copyright © 2018年 Offcn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OWXAPPInfoTool : NSObject

// 获取app版本号
+ (NSString *)getLocalAppVersion;

// 获取app build版本号
+ (NSString *)getLocalAppBuildVersion;

// 获取BundleID
+ (NSString *)getBundleID;

// 获取app的名字
+ (NSString *)getAppName;

@end
