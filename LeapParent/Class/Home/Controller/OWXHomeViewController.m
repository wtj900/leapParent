//
//  OWXHomeViewController.m
//  leapParent
//
//  Created by 王史超 on 2018/6/5.
//  Copyright © 2018年 OWX. All rights reserved.
//

#import "OWXHomeViewController.h"

#import <POP.h>
#import "FTPopOverMenu.h"
#import "OWXFlashPlayerViewController.h"
#import "OWXBookRoomViewController.h"
#import "OWXSettingViewController.h"
#import "OWXMagicStoryViewController.h"
#import "OWXWordSpellViewController.h"
#import "LeapParent-Swift.h"
#import "OWXStudyCenterViewController.h"
#import "OWXFlipCardsViewController.h"

const NSInteger OWXButtonTag = 100;

static CGFloat const animationDelay = 0.05;

typedef NS_ENUM(NSInteger, OWXPOPActionViewTag) {
    OWXPOPActionViewTag_1 = 0,
    OWXPOPActionViewTag_2,
    OWXPOPActionViewTag_3,
    OWXPOPActionViewTag_4,
    OWXPOPActionViewTag_5,
    OWXPOPActionViewTag_6,
    OWXPOPActionViewTag_7
};

@interface OWXHomeViewController ()

@property (nonatomic, strong) NSMutableArray<UIButton *> *buttonArray;

@end

@implementation OWXHomeViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self startAnimation];
}

- (void)startAnimation {
    
    [self.buttonArray shuffle];
    
    for (NSInteger index = 0; index < self.buttonArray.count; index++) {
        
        UIButton *button = self.buttonArray[index];
        CGFloat buttonEndY = 0;
        if (button.tag >= OWXPOPActionViewTag_4) {
            buttonEndY = 280;
        } else {
            buttonEndY = 80;
        }
        
        // 7.给按钮添加弹簧动画
        POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
        anim.toValue = [NSValue valueWithCGRect:CGRectMake(button.frame.origin.x, buttonEndY, button.frame.size.width, button.frame.size.height)];
        anim.springBounciness = 8; //springBounciness为弹簧弹力 取值范围为【0，20】， 默认为4
        anim.springSpeed = 15; //springSpeed为弹簧速度 速度越快 动画时间越短 取值范围[0,20], 默认为12 和springBounciness一起决定弹簧动画效果
        anim.beginTime = CACurrentMediaTime() + animationDelay * index;  // 开始时间添加延迟
        [button pop_addAnimation:anim forKey:nil];
        [anim setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
            // 动画执行完毕 恢复点击事件
            self.view.userInteractionEnabled = YES;
        }];
        
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self resetButtons];
}

- (void)resetButtons {
    
    [self.buttonArray enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.frame = CGRectMake(obj.frame.origin.x, -obj.frame.size.height, obj.frame.size.width, obj.frame.size.height);
    }];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self buildSubViews];
    
}

- (void)buildSubViews {
    
    UIButton *mineButton = [[UIButton alloc] init];
    [self.view addSubview:mineButton];
    [mineButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.offset(0);
        make.size.mas_equalTo(CGSizeMake(89, 89));
    }];
    
    [mineButton setAdjustsImageWhenHighlighted:NO];
    [mineButton setImage:[UIImage imageNamed:@"btn_menu_icon"] forState:UIControlStateNormal];
    [mineButton addTarget:self action:@selector(showMineListPop:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *serviceButton = [[UIButton alloc] init];
    [self.view addSubview:serviceButton];
    [serviceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(0);
        make.centerY.offset(0);
        make.size.mas_equalTo(CGSizeMake(39, 48));
    }];
    
    [serviceButton setImage:[UIImage imageNamed:@"home_btn_service"] forState:UIControlStateNormal];
    [serviceButton addTarget:self action:@selector(showService:) forControlEvents:UIControlEventTouchUpInside];
    
    NSArray *titles = @[@"故事书", @"单词拼写", @"书架"];
    NSArray *tags = @[@(OWXPOPActionViewTag_1), @(OWXPOPActionViewTag_2), @(OWXPOPActionViewTag_3)];
    [self addActionViewsWithTiles:titles size:CGSizeMake(175, 180) tags:tags];
    
    titles = @[@"读本", @"学习中心", @"翻牌", @"动画播放"];
    tags = @[@(OWXPOPActionViewTag_4), @(OWXPOPActionViewTag_5), @(OWXPOPActionViewTag_6), @(OWXPOPActionViewTag_7)];
    [self addActionViewsWithTiles:titles size:CGSizeMake(140, 68) tags:tags];
    
}

- (void)addActionViewsWithTiles:(NSArray *)titles size:(CGSize)size tags:(NSArray *)tags {
    
    CGFloat middleMargin = 20;
    CGFloat leftMargin = (SCREEN_WIDTH - titles.count * size.width - (titles.count - 1) * middleMargin) * 0.5;
    
    for (NSInteger index = 0; index < titles.count; index++) {
        
        CGFloat buttonOriginX = leftMargin + index * (size.width + middleMargin);
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(buttonOriginX, 0, size.width, size.height)];
        [self.view addSubview:button];
        button.tag = [tags[index] integerValue];
        button.backgroundColor = [UIColor blueColor];
        button.titleLabel.numberOfLines = 0;
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        [button setTitle:[NSString stringWithFormat:@"%@",titles[index]] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.buttonArray addObject:button];
        
    }
    
}

- (void)showMineListPop:(UIButton *)sender {
    
    CGRect senderFrame = [sender.superview convertRect:sender.frame toView:KeyWindow];
    CGRect senderRect = CGRectMake(senderFrame.origin.x, senderFrame.origin.y, senderFrame.size.width, senderFrame.size.height * 0.5);
    
    [FTPopOverMenu showFromSenderFrame:senderRect
                              withMenu:@[@"@我的", @"扫一扫", @"设置"]
                             doneBlock:^(NSInteger selectedIndex) {
                                 [self popMenuActionIndex:selectedIndex];
                             }
                          dismissBlock:nil];
    
}

- (void)popMenuActionIndex:(NSInteger)index {
    
    if (0 == index) {
        NSDictionary *userInfo = @{@"login" : @(NO)};
        [[NSNotificationCenter defaultCenter] postNotificationName:OWXAPPSwitchRootViewControllerNotification object:nil userInfo:userInfo];
    }
    else if (1 == index) {
        OWXFlashPlayerViewController *flashPlayerViewController = [[OWXFlashPlayerViewController alloc] init];
        [self presentViewController:flashPlayerViewController animated:YES completion:nil];
    }
    else if (2 == index) {
        OWXFlashPlayerViewController *flashPlayerViewController = [[OWXFlashPlayerViewController alloc] init];
        [self presentViewController:flashPlayerViewController animated:YES completion:nil];
    }
    
}

- (void)showService:(UIButton *)sender {
    OWXFlashPlayerViewController *flashPlayerViewController = [[OWXFlashPlayerViewController alloc] init];
    [self presentViewController:flashPlayerViewController animated:YES completion:nil];
}

- (void)buttonAction:(UIButton *)sender {

    switch (sender.tag) {
        case OWXPOPActionViewTag_1: {
            OWXMagicStoryViewController *magicStoryViewController = [[OWXMagicStoryViewController alloc] init];
            [self presentViewController:magicStoryViewController animated:YES completion:nil];
        }
            break;
        case OWXPOPActionViewTag_2: {
            OWXWordSpellViewController *wordSpellViewController = [[OWXWordSpellViewController alloc] init];
            [self presentViewController:wordSpellViewController animated:YES completion:nil];
        }
            break;
        case OWXPOPActionViewTag_3: {
            OWXBookRoomViewController *bookRoomViewController = [[OWXBookRoomViewController alloc] init];
            [self presentViewController:bookRoomViewController animated:YES completion:nil];
        }
            break;
        case OWXPOPActionViewTag_4: {
            OWXReaderViewController *readerViewController = [[OWXReaderViewController alloc] init];
            [self presentViewController:readerViewController animated:YES completion:nil];
        }
            break;
        case OWXPOPActionViewTag_5: {
            OWXStudyCenterViewController *studyCenterViewController = [[OWXStudyCenterViewController alloc] init];
            [self presentViewController:studyCenterViewController animated:YES completion:nil];
        }
            break;
        case OWXPOPActionViewTag_6: {
            OWXFlipCardsViewController *flipCardsViewController = [[OWXFlipCardsViewController alloc] init];
            [self presentViewController:flipCardsViewController animated:YES completion:nil];
        }
            break;
        case OWXPOPActionViewTag_7: {
            OWXFlashPlayerViewController *flashPlayerViewController = [[OWXFlashPlayerViewController alloc] init];
            [self presentViewController:flashPlayerViewController animated:YES completion:nil];
        }
            break;
    }
    
}

- (NSMutableArray *)buttonArray {
    if (!_buttonArray) {
        _buttonArray = [[NSMutableArray alloc] init];
    }
    return _buttonArray;
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
