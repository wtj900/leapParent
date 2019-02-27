//
//  OWXGameAudioManager.m
//  LeapParent
//
//  Created by 王史超 on 2018/7/5.
//  Copyright © 2018年 offcn. All rights reserved.
//

#import "OWXGameAudioManager.h"

#import <AVFoundation/AVFoundation.h>

@interface OWXGameAudioManager ()<AVAudioPlayerDelegate>

@property (nonatomic, strong) AVAudioPlayer *musicAudioPlayer;
@property (nonatomic, strong) AVAudioPlayer *soundPlayer;

@end

@implementation OWXGameAudioManager


+ (OWXGameAudioManager *)share {
    
    static OWXGameAudioManager *instance = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (void)playBackgroundMusic:(NSString *)name {
    
    [self setAVAudioSessionCategory];
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:name withExtension:Nil];
    self.musicAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:Nil];
    self.musicAudioPlayer.numberOfLoops = INT_MAX;
    [self.musicAudioPlayer prepareToPlay];
    [self.musicAudioPlayer play];
    
}

- (void)playSoundMusic:(NSURL *)url {
    
    [self setAVAudioSessionCategory];
    
    self.soundPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:Nil];
    [self.soundPlayer prepareToPlay];
    [self.soundPlayer play];
    
}

- (void)stop {
    
    [self.musicAudioPlayer stop];
    [self.soundPlayer stop];
    
}

- (void)setAVAudioSessionCategory {
    if (![[AVAudioSession sharedInstance].category isEqualToString:AVAudioSessionCategoryAmbient]) {
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient error:nil];
    }
}

@end
