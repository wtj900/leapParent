//
//  OWXBeatStrangeViewController.m
//  LeapParent
//
//  Created by 王史超 on 2018/7/4.
//  Copyright © 2018年 offcn. All rights reserved.
//

#import "OWXBeatStrangeViewController.h"

#import "OWXGameModel.h"
#import "OWXMonsterView.h"
#import "OWXBearView.h"
#import "OWXQuestionView.h"
#import "OWXAudioManager.h"
#import "OWXGameAudioManager.h"

NSString * const kAnimationType        = @"animType";
NSString * const kAnimationTypeMonster = @"Monster";
NSString * const kAnimationTypeBullet  = @"Bullet";

@interface OWXBeatStrangeViewController () <CAAnimationDelegate>

@property (nonatomic, strong) OWXGameModel *gameModel;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) UIBezierPath *monsterPath;
@property (nonatomic, strong) NSMutableSet<OWXMonsterView *> *monsterViewPool;
@property (nonatomic, strong) NSMutableArray<OWXMonsterView *> *runningMonster;

@property (nonatomic, strong) UIImageView *backgroundView;
@property (nonatomic, strong) OWXBearView *bearImageView;
@property (nonatomic, strong) UIImageView *bulletView;
@property (nonatomic, assign) NSInteger monsterCount;

@property (nonatomic, strong) OWXQuestionView *questionView;
@property (nonatomic, assign) BOOL gameOneOver;

@end

@implementation OWXBeatStrangeViewController

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[OWXGameAudioManager share] stop];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.monsterCount = 0;
    
    [self loadData];
    [self buildSubViews];
    [self setUpTimer];
    [self playBackgroundMusic];
}

- (void)buildSubViews {
    
    __weak __typeof(self) weakSelf = self;
    self.view.backgroundColor = HEXColor(0xA0C51A);
    
    UIImageView *backgroundView = [[UIImageView alloc] init];
    [self.view addSubview:backgroundView];
    [backgroundView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.offset(0);
        make.height.equalTo(backgroundView.mas_width).multipliedBy(1334 / 750.0);
    }];
    
    self.backgroundView = backgroundView;
    backgroundView.userInteractionEnabled = YES;
    backgroundView.image = [UIImage imageNamed:@"review1_bg"];
    
    UIImageView *castleImageView = [[UIImageView alloc] init];
    castleImageView.image = [UIImage imageNamed:@"review1_castle"];
    [backgroundView addSubview:castleImageView];
    [castleImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(0);
        make.bottom.offset(-50);
        make.size.mas_equalTo(CGSizeMake(152, 125));
    }];
    
    UIImageView *grassView = [[UIImageView alloc] init];
    [backgroundView addSubview:grassView];
    [grassView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(40);
        make.top.offset(160);
        make.size.mas_equalTo(CGSizeMake(76, 22));
    }];
    
    grassView.image = [UIImage imageNamed:@"review1_grass"];
    
    OWXBearView *bearImageView = [[OWXBearView alloc] init];
    self.bearImageView = bearImageView;
    [backgroundView addSubview:bearImageView];
    [bearImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(grassView);
        make.bottom.equalTo(grassView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(100, 100));
    }];
    
    bearImageView.animateFinished = ^{
        [weakSelf fireBullet];
    };
    
    OWXQuestionView *questionView = [[OWXQuestionView alloc] init];
    [backgroundView addSubview:questionView];
    [questionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.top.equalTo(bearImageView.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(280, 220));
    }];
    
    self.questionView = questionView;
    questionView.models = self.gameModel.reviewTypeOneWordDataList;
    questionView.answerActionBlock = ^(BOOL isRight, BOOL finished) {
        weakSelf.gameOneOver = finished;
        if (isRight) {
            [weakSelf.bearImageView startAnimate];
        }
    };
    
    [self.view addSubview:self.backButton];
    
}

- (void)fireBullet {
    
    self.bulletView.hidden = NO;
    
    OWXMonsterView *monsterView = self.runningMonster.firstObject;
    CGPoint monsterCurrentCenter = [monsterView.layer presentationLayer].center;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:self.bulletView.center];
    [path addLineToPoint:monsterCurrentCenter];
    
    // 1.创建动画对象
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.delegate = self;
    animation.path = path.CGPath;
    animation.speed = 0.3;
    animation.calculationMode = kCAAnimationLinear;
    [animation setValue:kAnimationTypeBullet forKey:kAnimationType];
    
    // 设置重复次数
    animation.repeatCount = 1;
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    
    [self.bulletView.layer addAnimation:animation forKey:nil];
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"SFX_ReviewType1_Shoot.mp3" withExtension:nil];
    [[OWXGameAudioManager share] playSoundMusic:url];
    
//    [OWXAudioManager playSoundWithURL:url];
    
}

- (void)setUpTimer {
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(monsterSendOut) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    [timer setFireDate:[NSDate distantPast]];

    self.timer = timer;
    
}

- (void)playBackgroundMusic {
    
    [[OWXGameAudioManager share] playBackgroundMusic:@"reviewLessonType2_bg.mp3"];
}

- (void)loadData {
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Game.json" ofType:nil];
    NSData *data = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:path]];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    self.gameModel = [OWXGameModel modelWithDictionary:dict];
    
}

- (void)monsterSendOut {
    
    self.monsterCount++;
    
    if (self.monsterCount > 5) {
        [self.timer invalidate];
        self.timer = nil;
        return;
    }
    
    NSLog(@"发射怪兽");
    
    OWXMonsterView *monsterView = [self dequeueReusableMonsterView];
    [self.runningMonster addObject:monsterView];
    [self addAnimation:monsterView];
    
}

- (void)addAnimation:(OWXMonsterView *)monsterView {
    
    // 1.创建动画对象
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.path = self.monsterPath.CGPath;
    animation.speed = 0.005;
    animation.calculationMode = kCAAnimationPaced;
    animation.delegate = self;
    [animation setValue:kAnimationTypeMonster forKey:kAnimationType];
    
    // 设置重复次数
    animation.repeatCount = 1;
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    
    [monsterView.layer addAnimation:animation forKey:nil];
    
}

- (void)huntMonsterAction {
    
    self.bulletView.hidden = YES;
    [self.bulletView.layer removeAllAnimations];
    
    __weak __typeof(self) weakSelf = self;
    OWXMonsterView *monsterView = self.runningMonster.firstObject;
    [monsterView dieComplete:^(OWXMonsterView *monsterView) {
        [weakSelf monsterViewDieComplete:monsterView];
    }];

}

- (void)monsterViewDieComplete:(OWXMonsterView *)monsterView {
    
    monsterView.hidden = YES;
    [monsterView.layer removeAllAnimations];
    [self.monsterViewPool addObject:monsterView];
    [self.runningMonster removeObjectAtIndex:0];
    if (self.gameOneOver) {
        [self.view showMessage:@"真厉害，怪物都被打败了"];
    }
    else {
        [self.questionView next];
    }
}

- (OWXMonsterView *)dequeueReusableMonsterView {
    
    OWXMonsterView *monsterView = nil;
    if (self.monsterViewPool.count > 0) {
        monsterView = self.monsterViewPool.anyObject;
        monsterView.hidden = NO;
        [self.monsterViewPool removeObject:monsterView];
    }
    else {
        monsterView = [[OWXMonsterView alloc] init];
        [self.backgroundView addSubview:monsterView];
    }
    
    monsterView.image = [YYImage imageNamed:@"monster"];
    monsterView.origin = CGPointMake(300, 590);
    
    return monsterView;
    
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    
    if ([[anim valueForKey:kAnimationType] isEqualToString:kAnimationTypeMonster] && flag) {
        [self.bearImageView cry];
        [self monsterViewDieComplete:self.runningMonster.firstObject];
        NSLog(@"小怪动画正常结束");
    }
    else if ([[anim valueForKey:kAnimationType] isEqualToString:kAnimationTypeMonster] && !flag) {
        NSLog(@"小怪动画异常结束");
    }
    
    
    if ([[anim valueForKey:kAnimationType] isEqualToString:kAnimationTypeBullet] && flag) {
        NSLog(@"子弹动画正常结束");
        [self huntMonsterAction];
    }
    else if ([[anim valueForKey:kAnimationType] isEqualToString:kAnimationTypeBullet] && !flag) {
        NSLog(@"子弹动画异常结束");
    }
    
}

- (UIBezierPath *)monsterPath {
    if (!_monsterPath) {
        _monsterPath = [UIBezierPath bezierPath];
        [_monsterPath moveToPoint:CGPointMake(kAdaptWidth(300), kAdaptWidth(590))];
        [_monsterPath addLineToPoint:CGPointMake(kAdaptWidth(50), kAdaptWidth(590))];
        [_monsterPath addLineToPoint:CGPointMake(kAdaptWidth(50), kAdaptWidth(450))];
        [_monsterPath addLineToPoint:CGPointMake(kAdaptWidth(340), kAdaptWidth(450))];
        [_monsterPath addLineToPoint:CGPointMake(kAdaptWidth(340), kAdaptWidth(140))];
        [_monsterPath addLineToPoint:CGPointMake(kAdaptWidth(100), kAdaptWidth(140))];
    }
    return _monsterPath;
}

- (UIImageView *)bulletView {
    if (!_bulletView) {
        UIImage *image = [UIImage imageNamed:@"review1_bullet"];
        _bulletView = [[UIImageView alloc] initWithImage:image];
        _bulletView.origin = CGPointMake(CGRectGetMaxX(self.bearImageView.frame) - self.bulletView.width, CGRectGetMinY(self.bearImageView.frame));
        [self.backgroundView addSubview:_bulletView];
    }
    return _bulletView;
}

- (NSMutableSet<OWXMonsterView *> *)monsterViewPool {
    if (!_monsterViewPool) {
        _monsterViewPool = [[NSMutableSet alloc] init];
    }
    return _monsterViewPool;
}

- (NSMutableArray<OWXMonsterView *> *)runningMonster {
    if (!_runningMonster) {
        _runningMonster = [[NSMutableArray alloc] init];
    }
    return _runningMonster;
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
