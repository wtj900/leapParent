//
//  OWXAdaptTool.h
//  Teacher
//
//  Created by 王史超 on 2018/1/16.
//  Copyright © 2018年 Offcn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OWXAdaptTool : NSObject

/**
 屏幕适配宽
 */
+ (CGFloat)widthAdaptScale;

/**
 屏幕适配高
 */
+ (CGFloat)heightAdaptScale:(BOOL)isSafe;

@end
