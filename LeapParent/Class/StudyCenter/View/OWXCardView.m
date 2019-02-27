//
//  OWXCardView.m
//  LeapParent
//
//  Created by 王史超 on 2018/7/6.
//  Copyright © 2018年 offcn. All rights reserved.
//

#import "OWXCardView.h"

#import "OWXGameModel.h"

@interface OWXCardView ()

@property (nonatomic, strong) UIImageView *pictureImageView;

@property (nonatomic, strong) UILabel *wordLabel;

@property (nonatomic, strong) UIImageView *coverImageView;

@end

@implementation OWXCardView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self buildSubView];
    }
    return self;
}

- (void)buildSubView {
    
    self.backgroundColor = [UIColor clearColor];
    self.userInteractionEnabled = NO;
    
    UIView *backView = [[UIView alloc] init];
    [self addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(10, 10, 10, 10));
    }];
    
    backView.backgroundColor = [UIColor whiteColor];
    
    UIImageView *pictureImageView = [[UIImageView alloc] init];
    self.pictureImageView = pictureImageView;
    [backView addSubview:pictureImageView];
    [pictureImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(5, 5, 5, 5));
    }];
    
    UILabel *wordLabel = [[UILabel alloc] init];
    [backView addSubview:wordLabel];
    [wordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.offset(0);
    }];
    
    self.wordLabel = wordLabel;
    wordLabel.textColor = HEXColor(0xA93E3B);
    wordLabel.font = FontMediumSize(21);
    
    UIImageView *boardImageView = [[UIImageView alloc] init];
    boardImageView.image = [UIImage imageNamed:@"ReviewThreeCardBorder"];
    [backView addSubview:boardImageView];
    [boardImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
    }];
    
    UIImageView *coverImageView = [[UIImageView alloc] init];
    [self addSubview:coverImageView];
    [coverImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
    }];
    
    self.coverImageView = coverImageView;
    coverImageView.hidden = YES;
    coverImageView.image = [UIImage imageNamed:@"ReviewThreeCardMask"];
    
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)]];
    
}

- (void)tapAction {
    
    [self transition];
    
    if (self.cardAction) {
        self.cardAction(self);
    }
}

- (void)transition {
    
    [UIView animateWithDuration:0.5 animations:^{
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self cache:YES];
    } completion:^(BOOL finished) {
        self.userInteractionEnabled = !self.userInteractionEnabled;
    }];
    
    self.coverImageView.hidden = !self.coverImageView.hidden;
    
}

- (void)setModel:(OWXGameThreeModel *)model {
    
    _model = model;
    
    self.wordLabel.hidden = !(model.type == OWXGameThreeContentTypeWord);
    self.pictureImageView.hidden = !(model.type == OWXGameThreeContentTypePicture);
    
    if (model.type == OWXGameThreeContentTypeWord) {
        self.wordLabel.text = model.content;
    } else {
        [self.pictureImageView setImageWithURL:[NSURL URLWithString:model.content] placeholder:[UIImage imageNamed:@"review1_placeholder"]];
    }
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
