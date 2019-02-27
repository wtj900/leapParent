//
//  OWXAudioManager.m
//  LeapParent
//
//  Created by 王史超 on 2018/6/28.
//  Copyright © 2018年 OWX. All rights reserved.
//

#import "OWXAudioManager.h"

#import "DOUAudioStreamer.h"
#import <AudioToolbox/AudioToolbox.h>

static void *kStatusKVOKey = &kStatusKVOKey;
static void *kDurationKVOKey = &kDurationKVOKey;
static void *kBufferingRatioKVOKey = &kBufferingRatioKVOKey;

NSString * const OWXAudioObserverKeyPathStatus = @"status";
NSString * const OWXAudioObserverKeyPathDuration = @"duration";
NSString * const OWXAudioObserverKeyPathBufferingRatio = @"bufferingRatio";

@interface OWXAudioFile : NSObject <DOUAudioFile>

/**
 *  音频文件路径
 */
@property (nonatomic, strong) NSURL *audioFileURL;

@end

@implementation OWXAudioFile

@end

@interface OWXAudioManager ()

@property (nonatomic, strong) DOUAudioStreamer *audioStreamer;

@property (nonatomic, copy) PlayComplete complete;

@property (nonatomic, assign) BOOL cycle;

@end

@implementation OWXAudioManager

+ (OWXAudioManager *)share {
    static OWXAudioManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[OWXAudioManager alloc] init];
    });
    return instance;
}

- (void)creatAudioStreamerWithAudioFile:(OWXAudioFile *)audioFile {
    
    self.audioStreamer = [DOUAudioStreamer streamerWithAudioFile:audioFile];
    
    [self.audioStreamer addObserver:self forKeyPath:OWXAudioObserverKeyPathStatus options:NSKeyValueObservingOptionNew context:kStatusKVOKey];
    [self.audioStreamer addObserver:self forKeyPath:OWXAudioObserverKeyPathDuration options:NSKeyValueObservingOptionNew context:kDurationKVOKey];
    [self.audioStreamer addObserver:self forKeyPath:OWXAudioObserverKeyPathBufferingRatio options:NSKeyValueObservingOptionNew context:kBufferingRatioKVOKey];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    
    if (context == kStatusKVOKey) {
        [self performSelector:@selector(updateStatus)
                     onThread:[NSThread mainThread]
                   withObject:nil
                waitUntilDone:NO];
    }
    else if (context == kDurationKVOKey) {
        [self performSelector:@selector(timerAction:)
                     onThread:[NSThread mainThread]
                   withObject:nil
                waitUntilDone:NO];
    }
    else if (context == kBufferingRatioKVOKey) {
        
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)updateStatus {
    
    switch (self.audioStreamer.status) {
        case DOUAudioStreamerPlaying:
            break;
        case DOUAudioStreamerPaused:
            break;
        case DOUAudioStreamerIdle:
            break;
        case DOUAudioStreamerFinished:
            if (self.complete) {
                self.complete();
            }
            if (self.cycle) {
                [self playStreamerComplete:nil];
            }
            break;
        case DOUAudioStreamerBuffering:
            break;
        case DOUAudioStreamerError:
            break;
    }
}

- (void)timerAction:(id)timer {
    
    //    if ([_streamer duration] == 0.0) {
    //        [self.slider setValue:0.0f animated:NO];
    //        self.nowTimeLabel.text = @"00:00";
    //    }else {
    //        /// 播放进度条
    //        if (self.sliding == YES) {
    //
    //        }else{
    //            [self.slider setValue:[_streamer currentTime] / [_streamer duration] animated:YES];
    //        }
    //        //// 当前播放时间
    //        double minutesElapsed = floor(fmod([_streamer currentTime]/ 60.0,60.0));
    //        double secondsElapsed = floor(fmod([_streamer currentTime],60.0));
    //        self.nowTimeLabel.text = [NSString stringWithFormat:@"%02.0f:%02.0f",minutesElapsed, secondsElapsed];
    //        /// 音频总时长
    //        double minutesElapsedtotal = floor(fmod([_streamer duration]/ 60.0,60.0));
    //        double secondsElapsedtotal = floor(fmod([_streamer duration],60.0));
    //        self.totalTimeLabel.text = [NSString stringWithFormat:@"%02.0f:%02.0f",minutesElapsedtotal, secondsElapsedtotal];
    //    }
    //    /// 缓存进度
    //    self.progress.progress = [_streamer bufferingRatio];
}

- (void)streamerWithAudioFile:(NSURL *)file {
    
    OWXAudioFile *audioFile = [[OWXAudioFile alloc] init];
    audioFile.audioFileURL = file;
    
    self.cycle = NO;
    self.complete = nil;
    [self creatAudioStreamerWithAudioFile:audioFile];
    
}

- (void)playStreamerWithAudioFile:(NSURL *)file complete:(PlayComplete)complete {
    [self playStreamerWithAudioFile:file cycle:NO complete:complete];
}

- (void)playStreamerWithAudioFile:(NSURL *)file cycle:(BOOL)cycle complete:(PlayComplete)complete {
    
    [self streamerWithAudioFile:file];
    
    self.cycle = cycle;
    [self playStreamerComplete:complete];
    
}

- (void)cyclePlayStreamerWithAudioFile:(NSURL *)file {
    [self playStreamerWithAudioFile:file cycle:YES complete:nil];
}

- (void)playStreamerComplete:(PlayComplete)complete {
    
    if (self.audioStreamer.status == DOUAudioStreamerFinished && !self.cycle) {
        if (complete) {
            complete();
        }
        return;
    }
    
    self.complete = complete;
    [self.audioStreamer play];
}

- (void)pauseStreamer {
    [self.audioStreamer pause];
}

- (void)stopStreamer {
    [self.audioStreamer stop];
}

+ (void)playSoundWithURL:(NSURL *)url {
    
    static SystemSoundID soundIDTest = 0;

    if (url) {
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)url, &soundIDTest);
    }
    AudioServicesPlaySystemSound(soundIDTest);
    
}

- (NSTimeInterval)currentTime {
    return self.audioStreamer.currentTime;
}

@end
