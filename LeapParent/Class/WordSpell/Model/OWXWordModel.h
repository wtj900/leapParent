//
//  OWXWordModel.h
//  LeapParent
//
//  Created by 王史超 on 2018/6/22.
//  Copyright © 2018年 OWX. All rights reserved.
//

#import "OWXBaseModel.h"

@interface OWXWordModel : OWXBaseModel

@property (nonatomic, assign) NSInteger wordid;

@property (nonatomic, copy) NSString *word;

@property (nonatomic, copy) NSString *image;

@property (nonatomic, copy) NSString *audio;

@property (nonatomic, copy) NSString *structs;

@end
