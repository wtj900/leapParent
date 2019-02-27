//
//  OWXGameModel.m
//  LeapParent
//
//  Created by 王史超 on 2018/7/5.
//  Copyright © 2018年 offcn. All rights reserved.
//

#import "OWXGameModel.h"

@implementation OWXGameOneModel

@end

@implementation OWXGameTwoModel

@end

@implementation OWXGameThreeModel

@end

@implementation OWXGameModel

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass {
    return @{@"reviewTypeOneWordDataList" : [OWXGameOneModel class],
             @"reviewTypeTwoWordDataList" : [OWXGameTwoModel class],
             @"reviewTypeThreeWordDataList" : [OWXGameThreeModel class]};
}

@end
