//
//  OWXStudyCenterLevelView.m
//  LeapParent
//
//  Created by 王史超 on 2018/7/4.
//  Copyright © 2018年 offcn. All rights reserved.
//

#import "OWXStudyCenterLevelView.h"

#import "OWXStudyCenterModel.h"

NSString * const kStarsLeft  = @"StarsLeft";
NSString * const kStarsRight = @"StarsRight";

@interface OWXStudyCenterLevelView ()

@property (nonatomic, strong) UIImageView *baseImageView;

@property (nonatomic, strong) UILabel *levelLabel;

@property (nonatomic, strong) NSDictionary *starViewsDict;

@end

@implementation OWXStudyCenterLevelView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:CGRectMake(0, 0, 100, 68)]) {
        [self buildSubViews];
    }
    return self;
}

- (void)buildSubViews {
    
    UIImageView *baseImageView = [[UIImageView alloc] init];
    self.baseImageView = baseImageView;
    [self addSubview:baseImageView];
    [baseImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
    }];
    
    UILabel *levelLabel = [[UILabel alloc] init];
    [self addSubview:levelLabel];
    [levelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(8);
        make.centerX.offset(0);
    }];
    
    self.levelLabel = levelLabel;
    levelLabel.font = [UIFont boldSystemFontOfSize:22];
    
    CGFloat starViewWidth = 11;
    CGFloat starViewHeight = 16;
    CGFloat starViewFromLeft = 8;
    CGFloat starViewFromTop = 30;
    CGFloat starViewHorizontalMargin = 1;
    CGFloat starViewVerticalMargin = 5;
    
    NSMutableArray *leftStarViews = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < 3; i++) {
        
        CGFloat left = starViewFromLeft + i * (starViewWidth + starViewHorizontalMargin);
        CGFloat top = starViewFromTop + i * starViewVerticalMargin;
        
        UIImageView *imageView = [self creatImageViewWithFrame:CGRectMake(left, top, starViewWidth, starViewHeight)];
        [leftStarViews addObject:imageView];
    }
    
    CGFloat starViewFromRight = starViewFromLeft;
    NSMutableArray *rightStarViews = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < 3; i++) {
        
        CGFloat left = self.frame.size.width - starViewFromRight - starViewWidth - i * (starViewWidth + starViewHorizontalMargin);
        CGFloat top = starViewFromTop + i * starViewVerticalMargin;
        
        UIImageView *imageView = [self creatImageViewWithFrame:CGRectMake(left, top, starViewWidth, starViewHeight)];
        [rightStarViews addObject:imageView];
    }
    
    self.starViewsDict = @{kStarsLeft : leftStarViews,
                           kStarsRight : rightStarViews};
    
    UIButton *button = [[UIButton alloc] initWithFrame:self.bounds];
    [self addSubview:button];
    [button addTarget:self action:@selector(buttonClickAction:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (UIImageView *)creatImageViewWithFrame:(CGRect)frame {
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
    [self addSubview:imageView];
    return imageView;
}

- (void)buttonClickAction:(UIButton *)button {
    if (self.clickAction) {
        self.clickAction(self.lessonInfoModel);
    }
}

- (void)setLessonInfoModel:(OWXStudyCenterLessonInfoModel *)lessonInfoModel {
    
    _lessonInfoModel = lessonInfoModel;
    
    self.levelLabel.text = StringFromInteger(lessonInfoModel.rank);
    
    switch (lessonInfoModel.state) {
        case OWXStudyCenterLessonProgressTodo: {
            [self lessonSetWithUnfinished];
        }
            break;
        case OWXStudyCenterLessonProgressDoing:
        case OWXStudyCenterLessonProgressDone: {
            [self lessonSetWithFinished];
        }
            break;
    }
    
}

- (void)allStarViewIsHidden:(BOOL)isHidden {
    
    NSMutableArray *starViews = [[NSMutableArray alloc] initWithArray:self.starViewsDict[kStarsLeft]];
    [starViews addObjectsFromArray:self.starViewsDict[kStarsRight]];
    [starViews makeObjectsPerformSelector:@selector(setHidden:) withObject:isHidden ? @(YES) : nil];
    
}

- (void)lessonSetWithUnfinished {
    
    [self allStarViewIsHidden:YES];
    self.baseImageView.image = [UIImage imageNamed:@"LessonUnfinished"];
    self.levelLabel.textColor = HEXColor(0xFFE09D);
}

- (void)lessonSetWithFinished {
    
    [self allStarViewIsHidden:NO];
    self.baseImageView.image = [UIImage imageNamed:@"lessonFinished"];
    self.levelLabel.textColor = HEXColor(0xFFEC53);
    
    [self setStarViews:self.starViewsDict[kStarsLeft] left:YES score:self.lessonInfoModel.prPoint];
    [self setStarViews:self.starViewsDict[kStarsRight] left:NO score:self.lessonInfoModel.rePoint];
    
}

- (void)setStarViews:(NSArray<UIImageView *> *)starViews left:(BOOL)left score:(NSInteger)score {
    
    NSString *preName = left ? @"Left" : @"Right";
    
    [starViews enumerateObjectsUsingBlock:^(UIImageView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (score > idx) {
            obj.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@Hight", preName]];
        }
        else {
            obj.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@Light", preName]];
        }
    }];
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
