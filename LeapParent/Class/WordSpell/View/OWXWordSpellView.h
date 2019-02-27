//
//  OWXWordSpellView.h
//  LeapParent
//
//  Created by 王史超 on 2018/6/22.
//  Copyright © 2018年 OWX. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OWXWordModel;

@interface OWXWordSpellView : UIView

@property (nonatomic, strong) NSArray<OWXWordModel *> *wordList;

@property (nonatomic, copy) void (^spellIndex)(NSInteger index);

@end
