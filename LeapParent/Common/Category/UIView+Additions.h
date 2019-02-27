//
//  UIView+Additions.h
//  OWXEduAdmin
//
//  Created by 王史超 on 2018/2/1.
//  Copyright © 2018年 Offcn. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSUInteger, OWXBorderLineType) {
    OWXBorderLineTypeAll     = 0,       ///< 全部
    OWXBorderLineTypeTop     = 1 << 0,  ///< 上边线
    OWXBorderLineTypeLeft    = 1 << 1,  ///< 左边线
    OWXBorderLineTypeBottom  = 1 << 2,  ///< 下边线
    OWXBorderLineTypeRight   = 1 << 3,  ///< 右边线
};

@interface UIView (Additions)

- (void)borderLine:(OWXBorderLineType)type color:(UIColor *)color width:(CGFloat)width;

@end
