//
//  UIView+HUD.m
//  FiveHealth
//
//  Created by 王史超 on 2017/12/25.
//  Copyright © 2017年 com.wukangcheng.fivehealths. All rights reserved.
//

#import "UIView+HUD.h"
#import "MBProgressHUD.h"

@implementation UIView (HUD)

- (void)showLoading {
    [self hideHUD];
    
    [self showLoadingWithMsg:nil];
}

- (void)showLoadingWithMsg:(NSString *)msg {
    [self hideHUD];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    hud.label.text = msg;
    hud.label.numberOfLines = 0;
    hud.bezelView.backgroundColor = [UIColor colorWithWhite:17 / 255. alpha:.7];
    hud.contentColor = [UIColor whiteColor];
    hud.removeFromSuperViewOnHide = YES;
    hud.userInteractionEnabled = YES;
    
    hud.offset = CGPointMake(0, -100);
}

- (void)showMessage:(NSString *)message {
    [self hideHUD];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.offset = CGPointMake(0, -100);
    hud.label.text = message;
    hud.label.numberOfLines = 0;
    hud.bezelView.backgroundColor = [UIColor colorWithWhite:17 / 255. alpha:.7];
    hud.contentColor = [UIColor whiteColor];
    hud.removeFromSuperViewOnHide = YES;
    hud.userInteractionEnabled = NO;
    
    [hud hideAnimated:YES afterDelay:2];
}

- (void)hideHUD {
    [MBProgressHUD hideHUDForView:self animated:YES];
}

@end
