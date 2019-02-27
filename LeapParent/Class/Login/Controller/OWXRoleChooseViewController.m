//
//  OWXRoleChooseViewController.m
//  leapParent
//
//  Created by 王史超 on 2018/6/5.
//  Copyright © 2018年 OWX. All rights reserved.
//

#import "OWXRoleChooseViewController.h"
#import "OWXLoginViewController.h"

@interface OWXRoleChooseViewController ()

@end

@implementation OWXRoleChooseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UILabel *label = [[UILabel alloc] init];
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.top.offset(30);
    }];

    label.text = @"你是学生还是老师？";
    label.textColor = [UIColor whiteColor];
    label.font = FontMediumSize(16);

    UIButton *studentButton = [self buttonWithTitle:@"\"我是学生\"" image:@"login_img_student" tag:100];
    [studentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.offset(0);
        make.right.equalTo(self.view.mas_centerX).offset(-50);
        make.size.mas_equalTo(CGSizeMake(186, 187));
    }];
    
    UIButton *teacherButton = [self buttonWithTitle:@"\"我是老师\"" image:@"login_img_teacher" tag:200];
    [teacherButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(studentButton);
        make.left.equalTo(self.view.mas_centerX).offset(50);
        make.size.equalTo(studentButton);
    }];
    
}

- (UIButton *)buttonWithTitle:(NSString *)title image:(NSString *)image tag:(NSInteger)tag {

    UIButton *button = [[UIButton alloc] init];
    [self.view addSubview:button];
    
    button.tag = tag;
    [button setAdjustsImageWhenHighlighted:NO];
    [button setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *label = [[UILabel alloc] init];
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(button);
        make.top.equalTo(button.mas_bottom).offset(10);
    }];
    
    label.text = title;
    label.font = FontMediumSize(15);

    return button;
}

- (void)buttonAction:(UIButton *)sender {
    
    if (sender.tag == 100) {
        OWXLoginViewController *loginViewController = [[OWXLoginViewController alloc] init];
        loginViewController.isPush = YES;
        [self.navigationController pushViewController:loginViewController animated:YES];
    } else {
        OWXLoginViewController *loginViewController = [[OWXLoginViewController alloc] init];
        loginViewController.isPush = YES;
        [self.navigationController pushViewController:loginViewController animated:YES];
    }
    
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
