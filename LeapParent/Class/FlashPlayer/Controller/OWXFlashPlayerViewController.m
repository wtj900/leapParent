//
//  OWXFlashPlayerViewController.m
//  LeapParent
//
//  Created by 王史超 on 2018/6/21.
//  Copyright © 2018年 OWX. All rights reserved.
//

#import "OWXFlashPlayerViewController.h"

#import <Lottie/Lottie.h>

@interface OWXFlashPlayerViewController ()

@end

@implementation OWXFlashPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor yellowColor];
    
    LOTAnimationView *animation = [LOTAnimationView animationNamed:@"voice"];
    animation.frame = CGRectMake(0, 0, 200, 300);
    animation.center = CGPointMake(SCREEN_HEIGHT * 0.5, SCREEN_WIDTH * 0.5);
    [self.view addSubview:animation];
    [animation playWithCompletion:^(BOOL animationFinished) {
        // Do Something
    }];
    
    [self.view addSubview:self.backButton];
    
}

//支持的方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
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
