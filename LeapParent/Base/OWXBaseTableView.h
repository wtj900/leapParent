//
//  OWXBaseTableView.h
//  Teacher
//
//  Created by 王史超 on 2018/1/15.
//  Copyright © 2018年 Offcn. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "OWXPlaceholderView.h"

/**
 - OWXRefreshStateNormal: 正常状态
 - OWXRefreshStateNoMoreData: 显示没有更多数据
 - OWXRefreshStateDisable: 刷新禁止
 - OWXRefreshStateEnd: 停止刷新后禁止
 - OWXRefreshStateEndRefreshing: 停止刷新
 */
typedef NS_ENUM(NSInteger, OWXRefreshState) {
    OWXRefreshStateNormal = 0,
    OWXRefreshStateNoMoreData,
    OWXRefreshStateDisable,
    OWXRefreshStateEnd,
    OWXRefreshStateEndRefreshing,
    OWXRefreshStateBeginRefreshing
};

@interface OWXBaseTableView : UITableView

// 下拉状态
@property (nonatomic, assign) OWXRefreshState pulldown;
// 上拉状态
@property (nonatomic, assign) OWXRefreshState pullup;
// 刷新回调
@property (nonatomic, copy) void (^refreshBlock)(BOOL isUp);
// 空白页的样式
- (void)blankStyle:(OWXBlankStyle)style;
- (void)blankImage:(NSString *)imageName title:(NSString *)title;

@end
