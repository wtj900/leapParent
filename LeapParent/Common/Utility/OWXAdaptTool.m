//
//  OWXAdaptTool.m
//  Teacher
//
//  Created by 王史超 on 2018/1/16.
//  Copyright © 2018年 Offcn. All rights reserved.
//

#import "OWXAdaptTool.h"

@implementation OWXAdaptTool

/**
 *  屏幕适配宽
 *
 *  @return 适配比例
 */
+ (CGFloat)widthAdaptScale {
    
    if (([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)) {
        return 320 / 375.0; // iphone4/4s
    }
    else if (([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)) {
        return 320 / 375.0; // iphone5
    }
    else if (([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)) {
        return 414 / 375.0; // iphone6p
    }
    else if (([UIScreen instancesRespondToSelector:@selector(currentMode)] ? (CGSizeEqualToSize(CGSizeMake(1125, 2001), [[UIScreen mainScreen] currentMode].size) ) : NO)) {
        return 375 / 375.0; // iphone6p
    }
    else if (([UIScreen instancesRespondToSelector:@selector(currentMode)] ? (CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) ) : NO)) {
        return 375 / 375.0; // iphoneX
    }
    else {
        return [UIScreen mainScreen].bounds.size.width / 375.0;
    }
    
}

/**
 *  屏幕适配高
 *
 *  @return 适配比例
 */
+ (CGFloat)heightAdaptScale:(BOOL)isSafe {
    
    if (([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)) {
        return 480 / 667.0; // iphone4/4s
    }
    else if (([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)) {
        return 568 / 667.0; // iphone5
    }
    else if (([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)) {
        return 736 / 667.0; // iphone6p
    }
    else if (([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2001), [[UIScreen mainScreen] currentMode].size) : NO)) {
        return 667 / 667.0; // iphone6p big
    }
    else if (([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)) {
        return (812 - (isSafe ? (88 + 34) : 44)) / 667.0; // iphoneX
    }
    else {
        return [UIScreen mainScreen].bounds.size.height / 667.0;
    }
    
}

@end
