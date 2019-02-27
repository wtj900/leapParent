//
//  OWXStudyCenterViewController.m
//  LeapParent
//
//  Created by 王史超 on 2018/7/3.
//  Copyright © 2018年 offcn. All rights reserved.
//

#import "OWXStudyCenterViewController.h"
#import "OWXStudyCenterModel.h"
#import "OWXStudyCenterLevelView.h"
#import "OWXBeatStrangeViewController.h"

NSInteger const kItemCountOfSection = 7;

@interface OWXStudyCenterViewController ()

@property (nonatomic, strong) OWXStudyCenterModel *studyCenterModel;
@property (nonatomic, strong) NSArray<NSArray<OWXStudyCenterLessonInfoModel *> *> *section;
@property (nonatomic, strong) UIImageView *bearImageView;
@property (nonatomic, assign) NSInteger currentLessonRank;

@end

@implementation OWXStudyCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    __weak __typeof(self) weakSelf = self;
    [self loadDataComplete:^{
        [weakSelf buildSubViews];
    }];
    
}

- (void)loadDataComplete:(void (^)(void))complete {
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"StudyCenter.json" ofType:nil];
    NSData *data = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:path]];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    self.studyCenterModel = [OWXStudyCenterModel modelWithDictionary:dict];
    
    [self groupAction];
    
    if (complete) {
        complete();
    }
    
}

- (void)groupAction {
    
    NSMutableArray *section = [[NSMutableArray alloc] init];
    NSInteger i = 0;
    while (YES) {
        
        NSInteger remainder = self.studyCenterModel.lessonInfoList.count - i * kItemCountOfSection;
        
        if (remainder <= 0) {
            break;
        }
        
        NSInteger length = remainder < kItemCountOfSection ? remainder : kItemCountOfSection;
        NSArray *tempArray = [self.studyCenterModel.lessonInfoList subarrayWithRange:NSMakeRange(i * kItemCountOfSection, length)];
        
        [section addObject:tempArray];
        
        i++;
        
    };
    
    self.section = section;
    
}

- (void)buildSubViews {
    
    self.view.backgroundColor = HEXColor(0xFFE88A);
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    [self.view addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
    }];
    
    scrollView.backgroundColor = [UIColor clearColor];
    
    UIImageView *topImageView = [[UIImageView alloc] init];
    topImageView.image = [UIImage imageNamed:@"EndCancelBackground"];
    [scrollView addSubview:topImageView];
    [topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.offset(0);
        make.width.equalTo(scrollView);
        make.height.equalTo(topImageView.mas_width).multipliedBy(884.0 / 750.0);
    }];
    
    UIImage *image = [UIImage imageNamed:@"LearningCenterbackground"];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeTile];
    
    UIImageView *middleImageView = [[UIImageView alloc] init];
    middleImageView.image = image;
    middleImageView.userInteractionEnabled = YES;
    [scrollView addSubview:middleImageView];
    [middleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.equalTo(topImageView);
        make.top.equalTo(topImageView.mas_bottom);
        make.height.equalTo(topImageView.mas_width).multipliedBy(2124.0 / 750.0 * self.section.count * 0.5);
    }];
    
    UIImageView *bottomImageView = [[UIImageView alloc] init];
    bottomImageView.image = [UIImage imageNamed:@"StartBackground"];
    [scrollView addSubview:bottomImageView];
    [bottomImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset(0);
        make.left.width.equalTo(topImageView);
        make.top.equalTo(middleImageView.mas_bottom);
        make.height.equalTo(bottomImageView.mas_width).multipliedBy(354.0 / 750.0);
    }];
    
    [self buildSubViewsWithSuperView:middleImageView];
    
    [self.view addSubview:self.backButton];
    
}

- (void)buildSubViewsWithSuperView:(UIView *)superView {
    
    NSArray *orignX_even = @[@(65), @(130), @(160), @(180), @(115), @(75), @(115)];
    NSArray *orignX_odd = @[@(165), @(125), @(85), @(85), @(125), @(180), @(120)];
    
    [self.section enumerateObjectsUsingBlock:^(NSArray<OWXStudyCenterLessonInfoModel *> * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSArray *orignX = idx % 2 ? orignX_odd : orignX_even;
        [self buildLessionViews:obj orignX:orignX index:self.section.count - idx superView:superView];
    }];
    
    OWXStudyCenterLevelView *levelView = [superView viewWithTag:self.currentLessonRank];
    
    UIImageView *bearImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 72, 78)];
    [superView addSubview:bearImageView];
    bearImageView.center = CGPointMake(levelView.centerX, levelView.origin.y);
    bearImageView.image = [UIImage imageNamed:@"CurrentLesson"];
    self.bearImageView = bearImageView;
    
}

- (void)buildLessionViews:(NSArray<OWXStudyCenterLessonInfoModel *> *)lessions orignX:(NSArray *)orignX index:(NSInteger)index superView:(UIView *)superView {
    
    CGFloat height = 2124.0 / 750.0 * index * 0.5 * SCREEN_HEIGHT;
    
    for (int i = 0; i < lessions.count; i++) {
        
        NSInteger x = [[orignX objectOrNilAtIndex:i] integerValue];
        OWXStudyCenterLevelView *levelView = [[OWXStudyCenterLevelView alloc] init];
        levelView.origin = CGPointMake(x, height - levelView.height * (i + 1));
        [superView addSubview:levelView];
        
        __weak __typeof(self) weakSelf = self;
        OWXStudyCenterLessonInfoModel *lessonInfoModel = [lessions objectOrNilAtIndex:i];
        levelView.lessonInfoModel = lessonInfoModel;
        levelView.tag = lessonInfoModel.rank;
        levelView.clickAction = ^(OWXStudyCenterLessonInfoModel *lessonInfoModel) {
            [weakSelf levelViewAction:lessonInfoModel];
        };
        
        if (lessonInfoModel.state == OWXStudyCenterLessonProgressDoing) {
            self.currentLessonRank = lessonInfoModel.rank;
        }
        
    }
    
}

- (void)levelViewAction:(OWXStudyCenterLessonInfoModel *)lessonInfoModel {
    
    if (lessonInfoModel.state == OWXStudyCenterLessonProgressTodo) {
        [self.view showMessage:@"请先解锁"];
    }
    else {
        OWXBeatStrangeViewController *beatStrangeViewController = [[OWXBeatStrangeViewController alloc] init];
        [self presentViewController:beatStrangeViewController animated:YES completion:nil];
    }
    
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
