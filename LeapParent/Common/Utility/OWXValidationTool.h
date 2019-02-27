//
//  OWXValidationTool.h
//  Teacher
//
//  Created by 王史超 on 2018/1/28.
//  Copyright © 2018年 Offcn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OWXValidationTool : NSObject

// 手机号验证
+ (BOOL)isValidateMobile:(NSString *)mobile;
// 6位验证码
+ (BOOL)isValidateSmsNum:(NSString *)smsNum;
// 四位数字
+ (BOOL)isValidateFourNum:(NSString *)numStr;
// 姓名验证
+ (BOOL)validateRealname:(NSString *)realname;
// 验证码验证
+ (BOOL)isValidateCode:(NSString *)code;
// 邀请码验证
+ (BOOL)isValidateInvitationCode:(NSString *)code;
// 全都是数字
+ (BOOL)isAllNumbers:(NSString *)str;
// 去除收尾空格
+ (NSString *)validateString:(NSString *)str;

@end
