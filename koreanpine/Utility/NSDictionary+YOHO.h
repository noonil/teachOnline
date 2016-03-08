//
//  NSDictionary+YOHO.h
//  YH_Marketplace
//
//  Created by Liu Xiangchao on 7/15/14.
//  Copyright (c) 2014 YOHO. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (YOHO)


- (id)objectForPath:(NSString *)path;

- (NSInteger)integerForPath:(NSString *)path;

- (long)longForPath:(NSString *)path;

- (long long)longlongForPath:(NSString *)path;

- (float)floatForPath:(NSString *)path;

- (double)doubleForPath:(NSString *)path;

- (BOOL)boolForPath:(NSString *)path;

- (NSString *)stringForPath:(NSString *)path;

- (NSMutableDictionary *)mutableDeepCopy;

- (NSDictionary *)dictForKey:(id)key;

- (NSString *)stringForKey:(id)key;

- (BOOL)boolForKey:(id)key;

- (NSString *)asJSONString;

@end
