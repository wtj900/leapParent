//
//  UIView+Additions.m
//  OWXEduAdmin
//
//  Created by 王史超 on 2018/2/1.
//  Copyright © 2018年 Offcn. All rights reserved.
//

#import "UIView+Additions.h"

@implementation UIView (Additions)

- (void)borderLine:(OWXBorderLineType)type color:(UIColor *)color width:(CGFloat)width {
    
    if (type == OWXBorderLineTypeAll) {
        self.layer.borderWidth = width;
        self.layer.borderColor = color.CGColor;
        return;
    }
    
    /// 线的路径
    UIBezierPath * bezierPath = [UIBezierPath bezierPath];
    
    /// 上
    if (type & OWXBorderLineTypeTop) {
        [bezierPath moveToPoint:CGPointMake(0.0f, 0.0f)];
        [bezierPath addLineToPoint:CGPointMake(self.frame.size.width, 0.0f)];
    }
    
    /// 左
    if (type & OWXBorderLineTypeLeft) {
        [bezierPath moveToPoint:CGPointMake(0.0f, self.frame.size.height)];
        [bezierPath addLineToPoint:CGPointMake(0.0f, 0.0f)];
    }
    
    /// 下
    if (type & OWXBorderLineTypeBottom) {
        /// bottom线路径
        [bezierPath moveToPoint:CGPointMake(0.0f, self.frame.size.height)];
        [bezierPath addLineToPoint:CGPointMake(self.frame.size.width, self.frame.size.height)];
    }
    
    /// 右
    if (type & OWXBorderLineTypeRight) {
        /// 右侧线路径
        [bezierPath moveToPoint:CGPointMake(self.frame.size.width, 0.0f)];
        [bezierPath addLineToPoint:CGPointMake(self.frame.size.width, self.frame.size.height)];
    }
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.strokeColor = color.CGColor;
    shapeLayer.fillColor  = [UIColor clearColor].CGColor;
    /// 添加路径
    shapeLayer.path = bezierPath.CGPath;
    /// 线宽度
    shapeLayer.lineWidth = width;
    
    [self.layer addSublayer:shapeLayer];
    
    return;
    
}

@end
