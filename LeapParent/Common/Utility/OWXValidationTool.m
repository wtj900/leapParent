//
//  OWXValidationTool.m
//  Teacher
//
//  Created by 王史超 on 2018/1/28.
//  Copyright © 2018年 Offcn. All rights reserved.
//

#import "OWXValidationTool.h"

@implementation OWXValidationTool

#pragma mark 手机号码验证

+ (BOOL)isValidateMobile:(NSString *)mobile {
    
    NSString * phoneRegex = @"^(1)\\d{10}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile] && (11 == mobile.length);
}

// 验证码6位验证
+ (BOOL)isValidateSmsNum:(NSString *)smsNum {
    
    NSString *smsNumRegex = @"\\d{6}";
    
    NSPredicate *smsNumPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", smsNumRegex];
    
    return [smsNumPredicate evaluateWithObject:smsNum];
}

// 四位数字
+ (BOOL)isValidateFourNum:(NSString *)numStr {
    
    NSString *fourNumRegex = @"\\d{4}";
    
    NSPredicate *fourNumPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", fourNumRegex];
    
    return [fourNumPredicate evaluateWithObject:numStr];
}

// 姓名验证
+ (BOOL)validateRealname:(NSString *)realname {
    
    NSString *nicknameRegex = @"^[\u4e00-\u9fa5]{2,8}$";
    
    NSPredicate *nicknamePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", nicknameRegex];
    
    return [nicknamePredicate evaluateWithObject:realname];
}

/**
 *  验证邀请码是否符合格式，长度8，只能包含字符、数字
 *
 *  @param code 密码字符串
 *
 *  @return 判断结果
 */
+ (BOOL)isValidateInvitationCode:(NSString *)code {
    
    NSString *codeRegex = @"^[0-9a-zA-Z]{8}$";
    NSPredicate *codeTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",codeRegex];
    return [codeTest evaluateWithObject:code];
    
}

/**
 *  验证密码是否符合格式，长度在6~18之间，只能包含字符、数字、且必须为混合组合
 *
 *  @param code 密码字符串
 *
 *  @return 判断结果
 */
+ (BOOL)isValidateCode:(NSString *)code {
    
    NSString *codeRegex = @"^(?![0-9]+$)(?![a-zA-Z]+$)(?!([^(0-9a-zA-Z)]|[\(\\)])+$)([^(0-9a-zA-Z)]|[\(\\)]|[a-zA-Z]|[0-9]){6,18}$";
    NSPredicate *codeTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",codeRegex];
    return [codeTest evaluateWithObject:code];
    
}

/**
 *  检验全都是数字的字符串
 *
 *  @param str 待检测的字符串
 *
 *  @return 判断结果
 */
+ (BOOL)isAllNumbers:(NSString *)str {
    
    NSString *numberRegex = @"^[0-9]*$";
    NSPredicate *numberPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numberRegex];
    return [numberPredicate evaluateWithObject:str];
}

/**
 去掉首尾空格

 @param str 原字符串
 @return 转换后字符串
 */
+ (NSString *)validateString:(NSString *)str {
    NSString *cnvStr = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    return cnvStr;
}

@end
