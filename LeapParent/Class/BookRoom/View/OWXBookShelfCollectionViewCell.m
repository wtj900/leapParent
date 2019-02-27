//
//  OWXBookShelfCollectionViewCell.m
//  LeapParent
//
//  Created by 王史超 on 2018/6/9.
//  Copyright © 2018年 OWX. All rights reserved.
//

#import "OWXBookShelfCollectionViewCell.h"

#import "OWXBookShelfModel.h"

@interface OWXBookShelfCollectionViewCell ()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation OWXBookShelfCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self buildSubViews];
    }
    return self;
}

- (void)buildSubViews {
    
    UIImageView *imageView = [[UIImageView alloc] init];
    self.imageView = imageView;
    [self.contentView addSubview:imageView];

}

- (void)setModel:(OWXBookShelfModel *)model {
    
    _model = model;
    
    CGSize size = CGSizeZero;
    NSString *imageName = @"";
    
    if (model.orientation == OWXBookShelfBookOrientationTypeHorizontal) {
        size = CGSizeMake(95, 75);
        imageName = @"bookroom_img_bg_book_horizontal";
    }
    else {
        size = CGSizeMake(75, 95);
        imageName = @"bookroom_img_bg_book_vertical";
    }
    
    self.imageView.image = [UIImage imageNamed:imageName];
    [self.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset(-5);
        make.centerX.offset(0);
        make.size.mas_equalTo(size);
    }];

}

@end
