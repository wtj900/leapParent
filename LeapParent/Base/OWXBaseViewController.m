//
//  OWXBaseViewController.m
//  Teacher
//
//  Created by 王史超 on 2018/1/15.
//  Copyright © 2018年 Offcn. All rights reserved.
//

#import "OWXBaseViewController.h"

@interface OWXBaseViewController ()

@end

@implementation OWXBaseViewController

- (void)dealloc {
    NSLog(@"%s", __func__);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

//    [UIDevice switchNewOrientation:UIInterfaceOrientationLandscapeRight | UIInterfaceOrientationLandscapeLeft];

    self.navigationController.delegate = self;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = RGBColor(135, 210, 242);
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.backButton];
    
}

- (void)back {
    
    if (self.isPush) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [[UITableViewCell alloc] init];
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES];
}

//支持旋转
- (BOOL)shouldAutorotate {
    return YES;
}

//支持的方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscapeRight | UIInterfaceOrientationMaskLandscapeLeft;
//    if (iPad_All) {
//        return UIInterfaceOrientationMaskLandscapeRight | UIInterfaceOrientationMaskLandscapeLeft;
//    } else {
//        return UIInterfaceOrientationMaskLandscapeRight;
//    }
}

////一开始的方向  很重要
//- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
////    return UIInterfaceOrientationLandscapeRight | UIInterfaceOrientationLandscapeLeft;
//    if (iPad_All) {
//        return UIInterfaceOrientationLandscapeRight | UIInterfaceOrientationLandscapeLeft;
//    } else {
//        return UIInterfaceOrientationLandscapeRight;
//    }
//}

- (UIButton *)backButton {
    if (!_backButton) {
        _backButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 20, 40, 40)];
        [_backButton setImage:[UIImage imageNamed:@"btn_back_gray"] forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}

- (OWXBaseTableView *)tableView {
    if (!_tableView) {
        _tableView = [[OWXBaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
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
