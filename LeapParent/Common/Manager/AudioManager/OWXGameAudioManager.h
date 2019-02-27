//
//  OWXGameAudioManager.h
//  LeapParent
//
//  Created by 王史超 on 2018/7/5.
//  Copyright © 2018年 offcn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OWXGameAudioManager : NSObject

+ (OWXGameAudioManager *)share;

- (void)playBackgroundMusic:(NSString *)name;

- (void)playSoundMusic:(NSURL *)url;

- (void)stop;

@end
