//
//  OWXAudioManager.h
//  LeapParent
//
//  Created by 王史超 on 2018/6/28.
//  Copyright © 2018年 OWX. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^PlayComplete)(void);

@interface OWXAudioManager : NSObject

+ (OWXAudioManager *)share;

- (void)streamerWithAudioFile:(NSURL *)file;

- (void)cyclePlayStreamerWithAudioFile:(NSURL *)file;

- (void)playStreamerWithAudioFile:(NSURL *)file complete:(PlayComplete)complete;

- (void)playStreamerWithAudioFile:(NSURL *)file cycle:(BOOL)cycle complete:(PlayComplete)complete;

- (void)playStreamerComplete:(PlayComplete)complete;

- (void)pauseStreamer;

- (void)stopStreamer;

+ (void)playSoundWithURL:(NSURL *)url;

@property (nonatomic, assign) NSTimeInterval currentTime;

@end
