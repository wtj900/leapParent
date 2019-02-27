//
//  OWXQuestionView.h
//  LeapParent
//
//  Created by 王史超 on 2018/7/5.
//  Copyright © 2018年 offcn. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OWXGameOneModel;

@interface OWXQuestionView : UIView

@property (nonatomic, strong) NSArray<OWXGameOneModel *> *models;

@property (nonatomic, copy) void (^answerActionBlock)(BOOL isRight, BOOL finished);

- (void)next;

@end
