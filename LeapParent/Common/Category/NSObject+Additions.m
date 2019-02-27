//
//  NSObject+Additions.m
//  live
//
//  Created by 王史超 on 2017/5/10.
//  Copyright © 2017年 Remair. All rights reserved.
//

#import "NSObject+Additions.h"

@implementation NSObject (Additions)

- (NSString *)decodeStringFormDictWithKey:(NSString *)key {
    
    NSString *string = @"";
    if (self && [self isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dict = (NSDictionary *)self;
        if ([dict[key] isKindOfClass:[NSString class]]) {
            string = dict[key];
        }
        else if ([dict[key] isKindOfClass:[NSNumber class]]) {
            string = [dict[key] stringValue];
        }
    }
    return string;
    
}

- (NSArray *)decodeArrayFormDictWithKey:(NSString *)key {
    
    NSArray *array = [NSArray array];
    if (self && [self isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dict = (NSDictionary *)self;
        if ([dict[key] isKindOfClass:[NSArray class]]) {
            array = dict[key];
        }
    }
    return array;
}

- (NSDictionary *)decodeDictionaryFormDictWithKey:(NSString *)key {
    
    NSDictionary *dictionary = [NSDictionary dictionary];
    if (self && [self isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dict = (NSDictionary *)self;
        if ([dict[key] isKindOfClass:[NSDictionary class]]) {
            dictionary = dict[key];
        }
    }
    return dictionary;
    
}

- (void)saveObjectToFile:(NSString *)fileName {
    
    NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:fileName];
    [NSKeyedArchiver archiveRootObject:self toFile:filePath];
}

+ (id)getObjectForFile:(NSString *)fileName {
    
    NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:fileName];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        return [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    }
    
    return nil;
}

+ (UIViewController *)getCurrentViewController {
    
    UIWindow *window = [[UIApplication sharedApplication].windows firstObject];
    if (!window) {
        return nil;
    }
    
    UIView *tempView;
    for (UIView *subview in window.subviews) {
        if ([[subview.classForCoder description] isEqualToString:@"UILayoutContainerView"]) {
            tempView = subview;
            break;
        }
    }
    
    if (!tempView) {
        tempView = [window.subviews lastObject];
    }
    
    BOOL(^canNext)(UIResponder *) = ^(UIResponder *responder){
        if (![responder isKindOfClass:[UIViewController class]]) {
            return YES;
        } else if ([responder isKindOfClass:[UINavigationController class]]) {
            return YES;
        } else if ([responder isKindOfClass:[UITabBarController class]]) {
            return YES;
        } else if ([responder isKindOfClass:NSClassFromString(@"UIInputWindowController")]) {
            return YES;
        }
        return NO;
    };
    
    UIResponder *nextResponder = tempView.nextResponder;
    
    while (canNext(nextResponder)) {
        tempView = tempView.subviews.firstObject;
        if (!tempView) {
            return nil;
        }
        nextResponder = tempView.nextResponder;
    }
    
    return (UIViewController *)nextResponder;
    
}

@end
