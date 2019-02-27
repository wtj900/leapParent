//
//  OWXBearView.h
//  LeapParent
//
//  Created by 王史超 on 2018/7/4.
//  Copyright © 2018年 offcn. All rights reserved.
//

#import "YYAnimatedImageView.h"

@interface OWXBearView : YYAnimatedImageView

- (void)startAnimate;

- (void)cry;

@property (nonatomic, copy) void (^animateFinished)(void);

@end
