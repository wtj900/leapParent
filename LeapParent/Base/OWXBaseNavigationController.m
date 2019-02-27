//
//  OWXBaseNavigationController.m
//  Teacher
//
//  Created by 王史超 on 2018/1/15.

//  Copyright © 2018年 Offcn. All rights reserved.
//

#import "OWXBaseNavigationController.h"
#import "OWXBaseViewController.h"

@interface OWXBaseNavigationController ()

@end

@implementation OWXBaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationBar.translucent = NO;
    // 导航栏颜色
    self.navigationBar.barTintColor = [UIColor redColor];
    // 导航栏文字
    self.navigationBar.tintColor = [UIColor redColor];
    self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : [UIFont boldSystemFontOfSize:18]};
    // 底部分隔线
    self.navigationBar.shadowImage = [[UIImage alloc] init];
//    [self.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
}

- (void)pushViewController:(OWXBaseViewController *)viewController animated:(BOOL)animated {
    
    viewController.backButton.hidden = self.viewControllers.count <= 0;
    viewController.hidesBottomBarWhenPushed = self.viewControllers.count > 0;
    
    [super pushViewController:viewController animated:animated];
}

- (BOOL)shouldAutorotate {
    return self.topViewController.shouldAutorotate;
}

//支持的方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    NSLog(@"%ld",self.topViewController.supportedInterfaceOrientations);
    return self.topViewController.supportedInterfaceOrientations;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
