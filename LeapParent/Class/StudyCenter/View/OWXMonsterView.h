//
//  OWXMonsterView.h
//  LeapParent
//
//  Created by 王史超 on 2018/7/4.
//  Copyright © 2018年 offcn. All rights reserved.
//

#import "YYAnimatedImageView.h"

@interface OWXMonsterView : YYAnimatedImageView

- (void)dieComplete:(void (^)(OWXMonsterView *monsterView))complete;

@end
