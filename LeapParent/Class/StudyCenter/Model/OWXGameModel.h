//
//  OWXGameModel.h
//  LeapParent
//
//  Created by 王史超 on 2018/7/5.
//  Copyright © 2018年 offcn. All rights reserved.
//

#import "OWXBaseModel.h"

typedef NS_ENUM(NSInteger, OWXGameThreeContentType) {
    OWXGameThreeContentTypeWord = 1,
    OWXGameThreeContentTypePicture
};

@interface OWXGameOneModel : OWXBaseModel

@property (nonatomic, assign) NSInteger wordId;

@property (nonatomic, assign) NSInteger rightPos;

@property (nonatomic, copy) NSString *pronounce;

@property (nonatomic, copy) NSString *picture1;

@property (nonatomic, copy) NSString *picture2;

@property (nonatomic, copy) NSString *word;

@end

@interface OWXGameTwoModel : OWXBaseModel



@end

@interface OWXGameThreeModel : OWXBaseModel

@property (nonatomic, assign) NSInteger wordId;

@property (nonatomic, assign) OWXGameThreeContentType type;

@property (nonatomic, copy) NSString *content;

@property (nonatomic, copy) NSString *word;

@property (nonatomic, copy) NSString *pronounce;

@end

@interface OWXGameModel : OWXBaseModel

@property (nonatomic, strong) NSArray<OWXGameOneModel *> *reviewTypeOneWordDataList;
@property (nonatomic, strong) NSArray<OWXGameTwoModel *> *reviewTypeTwoWordDataList;
@property (nonatomic, strong) NSArray<OWXGameThreeModel *> *reviewTypeThreeWordDataList;

@end
