//
//  OWXPlaceholderView.m
//  Teacher
//
//  Created by 王史超 on 2018/5/31.
//  Copyright © 2018年 Offcn. All rights reserved.
//

#import "OWXPlaceholderView.h"

@interface OWXPlaceholderView ()

@property (nonatomic, weak) UIImageView *imageView;
@property (nonatomic, weak) UILabel *titleLabel;

@end

@implementation OWXPlaceholderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self buildSubViews];
    }
    return self;
}

- (void)buildSubViews {
    
    UIImageView *imageView = [[UIImageView alloc] init];
    [self addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.bottom.equalTo(self.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(kAdaptWidth(150), kAdaptWidth(130)));
    }];
    
    self.imageView = imageView;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    UILabel *titleLabel = [[UILabel alloc] init];
    [self addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageView.mas_bottom);
        make.centerX.equalTo(imageView);
    }];
    
    self.titleLabel = titleLabel;
    titleLabel.textColor = [UIColor colorWithWhite:136 / 255. alpha:1];
    titleLabel.font = [UIFont systemFontOfSize:14];
    
}

- (void)blankStyle:(OWXBlankStyle)style {
    
    NSString *imageName = nil;
    NSString *title = nil;
    switch (style) {
        case OWXBlankStyleNoData: {
            imageName = @"ic_content_null";
            title = @"暂无内容";
        }
            break;
        case OWXBlankStyleBadNetwork: {
            imageName = @"ic_network_error";
            title = @"网络未连接，触屏重新加载";
        }
            break;
        default:
            break;
    }
    
    [self blankImage:imageName title:title];
}

- (void)blankImage:(NSString *)imageName title:(NSString *)title {
    
    self.hidden = IS_EMPTY_STRING(imageName) && IS_EMPTY_STRING(title);
    self.imageView.image = [UIImage imageNamed:imageName];
    self.titleLabel.text = title;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
