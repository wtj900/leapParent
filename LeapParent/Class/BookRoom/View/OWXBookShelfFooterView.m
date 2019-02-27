//
//  OWXBookShelfFooterView.m
//  LeapParent
//
//  Created by 王史超 on 2018/7/3.
//  Copyright © 2018年 offcn. All rights reserved.
//

#import "OWXBookShelfFooterView.h"

@interface OWXBookShelfFooterView ()

@property (nonatomic, strong) UIView *gradientView;
@property (nonatomic, strong) CAGradientLayer *gradLayer;

@end

@implementation OWXBookShelfFooterView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self buildSubViews];
    }
    return self;
}

- (void)buildSubViews {
    
    UIView *topView = [[UIView alloc] init];
    [self addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.offset(0);
        make.height.mas_equalTo(10);
    }];
    
    topView.backgroundColor = RGBColor(27, 107, 180);
    
    UIView *gradientView = [[UIView alloc] init];
    [self addSubview:gradientView];
    [gradientView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.mas_bottom);
        make.left.right.bottom.offset(0);
    }];
    
    self.gradientView = gradientView;
    
    CAGradientLayer *gradLayer = [CAGradientLayer layer];
    gradLayer.colors = @[(__bridge id)HEXColor(0x045b94).CGColor,
                         (__bridge id)HEXColor(0x176da6).CGColor];
    gradLayer.startPoint = CGPointMake(0, 0);
    gradLayer.endPoint = CGPointMake(0, 1);
    [gradientView.layer addSublayer:gradLayer];
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.gradLayer.frame = self.gradientView.bounds;
    
}

@end
