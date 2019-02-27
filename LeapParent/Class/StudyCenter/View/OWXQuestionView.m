//
//  OWXQuestionView.m
//  LeapParent
//
//  Created by 王史超 on 2018/7/5.
//  Copyright © 2018年 offcn. All rights reserved.
//

#import "OWXQuestionView.h"
#import "OWXGameModel.h"
#import "OWXAudioManager.h"
#import "OWXGameAudioManager.h"

typedef NS_ENUM(NSInteger, OWXQuestionAnswerType) {
    OWXQuestionAnswerTypeNone = 0,
    OWXQuestionAnswerTypeWrong,
    OWXQuestionAnswerTypeRight
};

@interface OWXQuestionDetailView : UIView

@property (nonatomic, copy) NSString *picture;

@property (nonatomic, assign) OWXQuestionAnswerType answerType;

@property (nonatomic, copy) void (^answerAction)(OWXQuestionDetailView *view);

@end

@interface OWXQuestionDetailView ()

@property (nonatomic, strong) UIImageView *pictureImageView;
@property (nonatomic, strong) UIImageView *signImageView;

@end

@implementation OWXQuestionDetailView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self buildSubViews];
    }
    return self;
}

- (void)buildSubViews {
    
    UIImageView *backImageView = [[UIImageView alloc] init];
    backImageView.image = [UIImage imageNamed:@"review1_question_image_board"];
    [self addSubview:backImageView];
    [backImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
    }];
    
    UIImageView *pictureImageView = [[UIImageView alloc] init];
    [self addSubview:pictureImageView];
    [pictureImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(10, 10, 10, 10));
    }];
    
    self.pictureImageView = pictureImageView;
    pictureImageView.layer.cornerRadius = 10;
    
    UIImageView *signImageView = [[UIImageView alloc] init];
    [self addSubview:signImageView];
    [signImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_bottom);
        make.centerX.offset(0);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    self.signImageView = signImageView;
    
    UIButton *button = [[UIButton alloc] init];
    [self addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
    }];
    
    [button addTarget:self action:@selector(clickButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)clickButtonAction {
    if (self.answerAction) {
        self.answerAction(self);
    }
}

- (void)setPicture:(NSString *)picture {
    
    self.signImageView.hidden = YES;
    [self.pictureImageView setImageWithURL:[NSURL URLWithString:picture] placeholder:[UIImage imageNamed:@"review1_placeholder"]];
    
}

- (void)setAnswerType:(OWXQuestionAnswerType)answerType {
    
    self.signImageView.hidden = NO;
    switch (answerType) {
        case OWXQuestionAnswerTypeNone: {
            self.signImageView.hidden = YES;
        }
            break;
        case OWXQuestionAnswerTypeWrong: {
            self.signImageView.image = [UIImage imageNamed:@"review1_wrong"];
        }
            break;
        case OWXQuestionAnswerTypeRight: {
            self.signImageView.image = [UIImage imageNamed:@"review1_right"];
        }
            break;
    }
}

@end

@interface OWXQuestionView ()

@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong) UILabel *wordLabel;

@end

@implementation OWXQuestionView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self buildSubViews];
    }
    return self;
}

- (void)buildSubViews {
    
    __weak __typeof(self) weakSelf = self;
    
    UIImageView *boardImageView = [[UIImageView alloc] init];
    boardImageView.userInteractionEnabled = YES;
    boardImageView.image = [UIImage imageNamed:@"review1_question_board"];
    [self addSubview:boardImageView];
    [boardImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset(0);
        make.height.equalTo(boardImageView.mas_width).multipliedBy(338 / 600.0);
    }];
    
    NSMutableArray *views = [[NSMutableArray alloc] init];
    for (int i = 1; i <= 2; i++) {
        OWXQuestionDetailView *detailView = [[OWXQuestionDetailView alloc] init];
        detailView.tag = i;
        detailView.answerAction = ^(OWXQuestionDetailView *view) {
            [weakSelf questionDetailViewAction:view];
        };
        
        [boardImageView addSubview:detailView];
        [views addObject:detailView];
    }
    
    [views mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:133 leadSpacing:10 tailSpacing:10];
    [views mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.offset(0);
        make.height.mas_equalTo(102);
    }];
    
    UILabel *wordLabel = [[UILabel alloc] init];
    [self addSubview:wordLabel];
    [wordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.bottom.equalTo(boardImageView.mas_top).offset(5);
    }];
    
    self.wordLabel = wordLabel;
    wordLabel.textColor = [UIColor redColor];
    wordLabel.font = FontMediumSize(30);
    
}

- (void)questionDetailViewAction:(OWXQuestionDetailView *)view {
    
    if (self.currentIndex >= self.models.count) {
        return;
    }
    
    OWXGameOneModel *model = [self.models objectAtIndex:self.currentIndex];
    BOOL isRight = view.tag == model.rightPos;
    BOOL isFinished = self.models.count - 1 == self.currentIndex;
    NSLog(@"%@-----%@", isRight ? @"答对了" : @"答错了", isFinished ? @"结束了" : @"继续");
    
    self.userInteractionEnabled = !isRight;
    
    NSString *audioName = isRight ? @"ReviewLessonType3Correct.mp3" : @"ReviewLessonType3Error.mp3";
    NSURL *url = [[NSBundle mainBundle] URLForResource:audioName withExtension:Nil];
    [[OWXGameAudioManager share] playSoundMusic:url];
    
    view.answerType = isRight ? OWXQuestionAnswerTypeRight : OWXQuestionAnswerTypeWrong;
    OWXQuestionDetailView *otherView = [self viewWithTag:view.tag % 2 + 1];
    otherView.answerType = OWXQuestionAnswerTypeNone;
    
    if (self.answerActionBlock) {
        self.answerActionBlock(isRight, isFinished);
    }
}

- (void)setModels:(NSArray<OWXGameOneModel *> *)models {
    
    _models = models;
    
    self.currentIndex = 0;
    [self setModelWithIndex:self.currentIndex];
}

- (void)setModelWithIndex:(NSInteger)index {
    
    if (index > self.models.count - 1) {
        return;
    }
    
    self.userInteractionEnabled = YES;
    
    OWXGameOneModel *model = [self.models objectAtIndex:index];
    
    self.wordLabel.text = model.word;
    
    OWXQuestionDetailView *leftView = [self viewWithTag:1];
    leftView.picture = model.picture1;
    
    OWXQuestionDetailView *rightView = [self viewWithTag:2];
    rightView.picture = model.picture2;
    
    [[OWXGameAudioManager share] playSoundMusic:[NSURL URLWithString:model.pronounce]];
}

- (void)next {
    
    self.currentIndex++;
    [self setModelWithIndex:self.currentIndex];

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
