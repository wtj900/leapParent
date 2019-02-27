//
//  OWXBaseTableView.m
//  Teacher
//
//  Created by 王史超 on 2018/1/15.
//  Copyright © 2018年 Offcn. All rights reserved.
//

#import "OWXBaseTableView.h"
#import <MJRefresh/MJRefresh.h>

@interface OWXBaseTableView ()

@property (nonatomic, strong) MJRefreshNormalHeader *headerRefresh;
@property (nonatomic, strong) MJRefreshBackNormalFooter *footerRefresh;

@property (nonatomic, strong) OWXPlaceholderView *placeholderView;

@end


@implementation OWXBaseTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        [self initTableView];
    }
    return self;
}

- (void)initTableView {
    
    self.estimatedRowHeight = 0;
    self.estimatedSectionHeaderHeight = 0;
    self.estimatedSectionFooterHeight = 0;
    self.backgroundColor = [UIColor clearColor];
    
    self.headerRefresh = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(pulldownRefresh)];
    self.headerRefresh.automaticallyChangeAlpha = YES;
    
    self.footerRefresh = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(pullupRefresh)];
    self.footerRefresh.automaticallyChangeAlpha = YES;
    
    OWXPlaceholderView *placeholderView = [[OWXPlaceholderView alloc] init];
    [self addSubview:placeholderView];
    [placeholderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.offset(0);
        make.size.equalTo(self);
    }];
    
    self.placeholderView = placeholderView;
    placeholderView.hidden = YES;
    
}

- (void)pulldownRefresh {
    if (self.refreshBlock) {
        self.refreshBlock(NO);
    }
}

- (void)pullupRefresh {
    if (self.refreshBlock) {
        self.refreshBlock(YES);
    }
}

- (void)endRefreshing:(BOOL)isUp {
    
    isUp ? [self.footerRefresh endRefreshing] : [self.headerRefresh endRefreshing];
}

- (void)blankStyle:(OWXBlankStyle)style {
    
    switch (style) {
        case OWXBlankStyleNoData:
        case OWXBlankStyleBadNetwork: {
            self.pullup = OWXRefreshStateDisable;
        }
            break;
        default:
            break;
    }
    
    [self.placeholderView blankStyle:style];
}

- (void)blankImage:(NSString *)imageName title:(NSString *)title {
    
    [self.placeholderView blankImage:imageName title:title];
}

- (void)setPulldown:(OWXRefreshState)pulldown {
    _pulldown = pulldown;
    
    switch (pulldown) {
        case OWXRefreshStateNormal: {
            self.mj_header = self.headerRefresh;
        }
            break;
        case OWXRefreshStateEndRefreshing: {
            [self.headerRefresh endRefreshing];
        }
            break;
        case OWXRefreshStateBeginRefreshing: {
            if (!self.mj_header) {
                self.mj_header = self.headerRefresh;
            }
            [self.headerRefresh beginRefreshing];
        }
            break;
        default:
            self.mj_header = nil;
            break;
    }
}

- (void)setPullup:(OWXRefreshState)pullup {
    
    _pullup = pullup;
    
    switch (pullup) {
            case OWXRefreshStateNormal: {
                self.mj_footer = self.footerRefresh;
            }
            break;
            case OWXRefreshStateNoMoreData: {
                [self.mj_footer endRefreshingWithNoMoreData];
            }
            break;
            case OWXRefreshStateEnd: {
                __weak __typeof(self) weakSelf = self;
                [self.footerRefresh endRefreshingWithCompletionBlock:^{
                    __strong __typeof(self) strongSelf = weakSelf;
                    if (strongSelf) {
                        strongSelf.mj_footer = nil;
                    }
                }];
            }
            break;
            case OWXRefreshStateEndRefreshing: {
                [self.mj_footer endRefreshing];
            }
            break;
        default: {
            self.mj_footer = nil;
        }
            break;
    }
    
}

@end
