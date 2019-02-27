//
//  OWXAPPInfoTool.m
//  Teacher
//
//  Created by 王史超 on 2018/1/26.
//  Copyright © 2018年 Offcn. All rights reserved.
//

#import "OWXAPPInfoTool.h"

@implementation OWXAPPInfoTool

// 获取app版本号
+ (NSString *)getLocalAppVersion {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

// 获取app build版本号
+ (NSString *)getLocalAppBuildVersion {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
}

// 获取BundleID
+ (NSString *)getBundleID {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
}

// 获取app的名字
+ (NSString *)getAppName {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
}

@end
