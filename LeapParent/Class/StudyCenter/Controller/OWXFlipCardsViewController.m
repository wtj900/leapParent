//
//  OWXFlipCardsViewController.m
//  LeapParent
//
//  Created by 王史超 on 2018/7/6.
//  Copyright © 2018年 offcn. All rights reserved.
//

#import "OWXFlipCardsViewController.h"
#import "OWXGameModel.h"
#import "OWXCardView.h"

@interface OWXFlipCardsViewController ()

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) UILabel *countDownLabel;
@property (nonatomic, strong) OWXGameModel *gameModel;

@property (nonatomic, strong) NSMutableArray<OWXCardView *> *totalCards;
@property (nonatomic, strong) NSMutableArray<OWXCardView *> *flipCards;
@property (nonatomic, strong) NSMutableArray<OWXCardView *> *rightCards;

@end

@implementation OWXFlipCardsViewController

static NSInteger countNumber = 10;

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    countNumber = 10;
    [self setUpTimer];
}

- (void)setUpTimer {
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    [timer setFireDate:[NSDate distantPast]];
    
    self.timer = timer;
    
}

- (void)countDown {
    
    countNumber--;
    
    self.countDownLabel.text = [NSString stringWithFormat:@"倒计时：%ld",countNumber];
    
    if (countNumber == 0) {
        [self.timer invalidate];
        self.timer = nil;
        
        self.countDownLabel.hidden = YES;
        [self.totalCards makeObjectsPerformSelector:@selector(transition)];
        
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.layer.contents = (__bridge id _Nullable)([UIImage imageNamed:@"ReviewThree_bg"].CGImage);
    
    [self loadData];
    [self buildSubViews];
}

- (void)buildSubViews {
    
    __weak __typeof(self) weakSelf = self;
    
    NSInteger columnMax = 2;
    NSInteger rowMax = self.gameModel.reviewTypeThreeWordDataList.count / 2;
    
    CGFloat width = 135;
    CGFloat height = 105;
    CGFloat horizontalMiddleMargin = 20;
    CGFloat verticalMiddleMargin = 10;
    CGFloat leftMargin = (SCREEN_HEIGHT - columnMax * width - horizontalMiddleMargin) * 0.5;
    CGFloat topMargin = 70;
    
    for (NSInteger column = 0; column < columnMax; column++) {
        for (NSInteger row = 0; row < rowMax; row++) {
            
            CGFloat left = leftMargin + column * (width + horizontalMiddleMargin);
            CGFloat top = topMargin + row * (height + verticalMiddleMargin);
            
            CGRect frame = CGRectMake(left, top, width, height);
            OWXCardView *cardView = [[OWXCardView alloc] initWithFrame:frame];
            cardView.model = self.gameModel.reviewTypeThreeWordDataList[column * rowMax + row];
            cardView.cardAction = ^(OWXCardView *cardView) {
                [weakSelf checkFlipCardWithNew:cardView];
            };
            
            [self.view addSubview:cardView];
            [self.totalCards addObject:cardView];
            
        }
        
    }

    [self.view addSubview:self.backButton];
    
    UILabel *countDownLabel = [[UILabel alloc] init];
    [self.view addSubview:countDownLabel];
    [countDownLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.backButton);
        make.centerX.offset(0);
    }];
    
    self.countDownLabel = countDownLabel;
    countDownLabel.textColor = [UIColor redColor];
    countDownLabel.font = FontMediumSize(16);
}

- (void)checkFlipCardWithNew:(OWXCardView *)cardView {
    
    [self.flipCards addObject:cardView];
    
    [self checkFlipCard];

}

- (void)checkFlipCard {
    
    if (self.flipCards.count < 2) {
        return;
    }
    
    OWXCardView *first = self.flipCards[0];
    OWXCardView *second = self.flipCards[1];
    
    [self.flipCards removeObject:first];
    [self.flipCards removeObject:second];
    [self checkFlipCard];
    
    if (first.model.wordId != second.model.wordId) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [first transition];
            [second transition];
        });
    }
    else {
        [self.rightCards addObject:first];
        [self.rightCards addObject:second];
        
        if (self.rightCards.count == self.gameModel.reviewTypeThreeWordDataList.count) {
            [self.view showMessage:@"🎉完美"];
        }
        
    }
    
}

- (void)loadData {
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Game.json" ofType:nil];
    NSData *data = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:path]];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    self.gameModel = [OWXGameModel modelWithDictionary:dict];
    
}

- (NSMutableArray *)totalCards {
    if (!_totalCards) {
        _totalCards = [[NSMutableArray alloc] init];
    }
    return _totalCards;
}

- (NSMutableArray *)flipCards {
    if (!_flipCards) {
        _flipCards = [[NSMutableArray alloc] init];
    }
    return _flipCards;
}

- (NSMutableArray *)rightCards {
    if (!_rightCards) {
        _rightCards = [[NSMutableArray alloc] init];
    }
    return _rightCards;
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
