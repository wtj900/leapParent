//
//  OWXBaseModel.m
//  Teacher
//
//  Created by 王史超 on 2018/1/24.
//  Copyright © 2018年 Offcn. All rights reserved.
//

#import "OWXBaseModel.h"

@implementation OWXBaseModel

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper {
    
    return @{@"ids" : @"id",
             @"describe" : @"description",
             @"classes" : @"class"};
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {}

@end
