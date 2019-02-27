//
//  OWXEndView.m
//  LeapParent
//
//  Created by 王史超 on 2018/6/23.
//  Copyright © 2018年 OWX. All rights reserved.
//

#import "OWXEndView.h"

@implementation OWXEndView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initEndView];
    }
    return self;
}

- (void)initEndView {
    
    self.layer.borderColor = [UIColor blackColor].CGColor;
    self.layer.borderWidth = 1.0f;
    self.layer.opacity = 0.1;
    self.layer.cornerRadius = 5;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
