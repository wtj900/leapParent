//
//  NSObject+Additions.h
//  live
//
//  Created by 王史超 on 2017/5/10.
//  Copyright © 2017年 Remair. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Additions)

- (NSString *)decodeStringFormDictWithKey:(NSString *)key;

- (NSArray *)decodeArrayFormDictWithKey:(NSString *)key;

- (NSDictionary *)decodeDictionaryFormDictWithKey:(NSString *)key;

- (void)saveObjectToFile:(NSString *)fileName;
+ (id)getObjectForFile:(NSString *)fileName;

+ (UIViewController *)getCurrentViewController;

@end
