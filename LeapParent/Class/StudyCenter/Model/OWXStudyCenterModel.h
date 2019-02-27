//
//  OWXStudyCenterModel.h
//  LeapParent
//
//  Created by 王史超 on 2018/7/4.
//  Copyright © 2018年 offcn. All rights reserved.
//

#import "OWXBaseModel.h"

typedef NS_ENUM(NSInteger, OWXStudyCenterLessonProgressState) {
    OWXStudyCenterLessonProgressTodo = 0,
    OWXStudyCenterLessonProgressDoing,
    OWXStudyCenterLessonProgressDone
};

@interface OWXStudyCenterLessonInfoModel : OWXBaseModel

@property (nonatomic, assign) NSInteger rank;

@property (nonatomic, assign) NSInteger lessonId;

@property (nonatomic, copy) NSString *lessonName;

@property (nonatomic, assign) NSInteger prPoint;

@property (nonatomic, assign) NSInteger rePoint;

@property (nonatomic, assign) OWXStudyCenterLessonProgressState state;

@end

@interface OWXStudyCenterModel : OWXBaseModel

@property (nonatomic, strong) NSArray<OWXStudyCenterLessonInfoModel *> *lessonInfoList;

@end
