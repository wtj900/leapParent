//
//  OWXBaseViewController.h
//  Teacher
//
//  Created by 王史超 on 2018/1/15.
//  Copyright © 2018年 Offcn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OWXBaseTableView.h"
#import "OWXBaseNavigationController.h"

@interface OWXBaseViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate>

@property (nonatomic, strong) OWXBaseTableView *tableView;

@property (nonatomic, assign) BOOL isPush;
@property (nonatomic, strong) UIButton *backButton;

- (void)back;

@end
