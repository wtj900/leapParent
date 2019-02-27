//
//  OWXPlaceholderView.h
//  Teacher
//
//  Created by 王史超 on 2018/5/31.
//  Copyright © 2018年 Offcn. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 - OWXBlankStyleNormal: 正常
 - OWXBlankStyleNoData: 没有数据
 - OWXNoDataStyleBadNetwork: 网络出错
 */
typedef NS_ENUM(NSInteger, OWXBlankStyle) {
    OWXBlankStyleNormal = 0,
    OWXBlankStyleNoData,
    OWXBlankStyleBadNetwork
};

@interface OWXPlaceholderView : UIView

// 空白页的样式
- (void)blankStyle:(OWXBlankStyle)style;
- (void)blankImage:(NSString *)imageName title:(NSString *)title;

@end
