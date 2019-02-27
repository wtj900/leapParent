//
//  OWXMonsterView.m
//  LeapParent
//
//  Created by 王史超 on 2018/7/4.
//  Copyright © 2018年 offcn. All rights reserved.
//

#import "OWXMonsterView.h"

#import "OWXAudioManager.h"
#import "OWXGameAudioManager.h"

@implementation OWXMonsterView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:CGRectMake(0, 0, 60, 60)];
    if (self) {
    }
    return self;
}

- (void)dieComplete:(void (^)(OWXMonsterView *))complete {
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"SFX_ReviewType1_Hit.mp3" withExtension:nil];
    [[OWXGameAudioManager share] playSoundMusic:url];
    
//    NSString *audioFile = [[NSBundle mainBundle] pathForResource:@"SFX_ReviewType1_Hit.mp3" ofType:nil];
//    NSURL *url = [NSURL fileURLWithPath:audioFile];
//    [OWXAudioManager playSoundWithURL:url];
    
    self.image = [YYImage imageNamed:@"review1_boom"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"打怪成功");
        if (complete) {
            complete(self);
        }
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
