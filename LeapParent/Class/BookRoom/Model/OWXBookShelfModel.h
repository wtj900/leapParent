//
//  OWXBookShelfModel.h
//  LeapParent
//
//  Created by 王史超 on 2018/7/3.
//  Copyright © 2018年 offcn. All rights reserved.
//

#import "OWXBaseModel.h"

typedef NS_ENUM(NSInteger, OWXBookShelfBookOrientationType) {
    OWXBookShelfBookOrientationTypeHorizontal = 1,
    OWXBookShelfBookOrientationTypeVertical
};

@interface OWXBookShelfModel : OWXBaseModel

@property (nonatomic, assign) NSInteger bid;

@property (nonatomic, copy) NSString *book_name;

@property (nonatomic, copy) NSString *pic;

@property (nonatomic, assign) OWXBookShelfBookOrientationType orientation;

@property (nonatomic, assign) BOOL is_read;

@end
