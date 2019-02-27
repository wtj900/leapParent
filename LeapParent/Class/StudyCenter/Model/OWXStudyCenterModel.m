//
//  OWXStudyCenterModel.m
//  LeapParent
//
//  Created by 王史超 on 2018/7/4.
//  Copyright © 2018年 offcn. All rights reserved.
//

#import "OWXStudyCenterModel.h"

@implementation OWXStudyCenterLessonInfoModel

@end

@implementation OWXStudyCenterModel


+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass {
    return @{@"lessonInfoList" : [OWXStudyCenterLessonInfoModel class]};
}

@end
