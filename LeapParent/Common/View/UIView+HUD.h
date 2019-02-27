//
//  UIView+HUD.h
//  FiveHealth
//
//  Created by 王史超 on 2017/12/25.
//  Copyright © 2017年 com.wukangcheng.fivehealths. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (HUD)

/**
 转圈
 */
- (void)showLoading;

/**
 带文本的转圈
 
 @param msg 显示的文本
 */
- (void)showLoadingWithMsg:(NSString *)msg;

/**
 只显示文本
 
 @param message 内容
 */
- (void)showMessage:(NSString *)message;

/**
 隐藏 showLoading 和 showLoadingWithMsg，不能隐藏别的
 */
- (void)hideHUD;

@end
