//
//  OWXLoginViewController.m
//  leapParent
//
//  Created by 王史超 on 2018/6/5.
//  Copyright © 2018年 OWX. All rights reserved.
//

#import "OWXLoginViewController.h"

@interface OWXLoginViewController ()

@end

@implementation OWXLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self buildSubView];
    
}

- (void)buildSubView {
    
    NSLog(@"%f-----%f",SCREEN_WIDTH, SCREEN_HEIGHT);
    
    [self.view addSubview:self.backButton];
    
    UIButton *loginButton = [[UIButton alloc] init];
    [self.view addSubview:loginButton];
    [loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.offset(0);
        make.size.mas_equalTo(CGSizeMake(100, 100));
    }];
    
    loginButton.backgroundColor = [UIColor yellowColor];
    [loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [loginButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [loginButton addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)login {
    NSDictionary *userInfo = @{@"login" : @(YES)};
    [[NSNotificationCenter defaultCenter] postNotificationName:OWXAPPSwitchRootViewControllerNotification object:nil userInfo:userInfo];
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
