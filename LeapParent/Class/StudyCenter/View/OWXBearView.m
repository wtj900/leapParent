//
//  OWXBearView.m
//  LeapParent
//
//  Created by 王史超 on 2018/7/4.
//  Copyright © 2018年 offcn. All rights reserved.
//

#import "OWXBearView.h"

@interface OWXBearView ()

@property (nonatomic, assign) NSInteger animationCount;

@end

@implementation OWXBearView

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"currentAnimatedImageIndex"];
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.image = [UIImage imageNamed:@"review1_bear_idle"];
        [self addObserver:self forKeyPath:@"currentAnimatedImageIndex" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {

    if ([keyPath isEqualToString:@"currentAnimatedImageIndex"]) {

        NSString *newValue = change[NSKeyValueChangeNewKey];

        if (self.animationCount == newValue.integerValue + 1) {
            [self animationEnd];
        }
    }

}

- (void)animationEnd {
    if (self.animateFinished) {
        self.animateFinished();
    }
}

- (void)startAnimate {

    YYImage *image = [YYImage imageNamed:@"review1_bear_attack"];
    self.image = image;
    self.animationCount = [image animatedImageFrameCount];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.image = [UIImage imageNamed:@"review1_bear_idle"];
    });

}

- (void)cry {
    
    self.image = [UIImage imageNamed:@"review1_bear_hurt"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.image = [UIImage imageNamed:@"review1_bear_idle"];
    });
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
