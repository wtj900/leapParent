//
//  OWXStudyCenterLevelView.h
//  LeapParent
//
//  Created by 王史超 on 2018/7/4.
//  Copyright © 2018年 offcn. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OWXStudyCenterLessonInfoModel;

@interface OWXStudyCenterLevelView : UIView

@property (nonatomic, strong) OWXStudyCenterLessonInfoModel *lessonInfoModel;

@property (nonatomic, copy) void (^clickAction)(OWXStudyCenterLessonInfoModel *lessonInfoModel);

@end
