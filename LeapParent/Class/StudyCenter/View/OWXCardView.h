//
//  OWXCardView.h
//  LeapParent
//
//  Created by 王史超 on 2018/7/6.
//  Copyright © 2018年 offcn. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OWXGameThreeModel;

@interface OWXCardView : UIView

@property (nonatomic, strong) OWXGameThreeModel *model;

@property (nonatomic, copy) void (^cardAction)(OWXCardView *cardView);

- (void)transition;

@end
