//
//  NSDictionary+YOHO.m
//  YH_Marketplace
//
//  Created by Liu Xiangchao on 7/15/14.
//  Copyright (c) 2014 YOHO. All rights reserved.
//

#import "NSDictionary+YOHO.h"

@implementation NSDictionary(YOHO)

-(id)object:(id)options key:(NSString *)key
{
	NSArray *keys = [key componentsSeparatedByString:@"."];
	for (NSString *_key in keys) {
		if ([options isKindOfClass:[NSArray class]]) {
			int _intKey = [_key intValue];
            if ([(NSArray *)options count] <= _intKey) {
                return nil;
            }
            options = [(NSArray *) options objectAtIndex:_intKey];
            
		}else if ([options isKindOfClass:[NSDictionary class]]) {
			options = [(NSDictionary *)options objectForKey:_key];
            if (options != nil && [options isKindOfClass:[NSNull class]]) {
                options = nil;
            }
		}
	}
	return options;
}

- (id)objectForPath:(NSString *)path
{
    return [self object:self key:path];
}

- (NSInteger)integerForPath:(NSString *)path
{
    NSString *string = [self objectForPath:path];
    if ([string respondsToSelector:@selector(integerValue)]) {
        return [string integerValue];
    }
    return 0;
}

- (long)longForPath:(NSString *)path
{
    NSNumber *number = [self objectForPath:path];
    return [number longValue];
}

- (long long)longlongForPath:(NSString *)path {
    NSNumber *number = [self objectForPath:path];
    return [number longLongValue];
}

- (float)floatForPath:(NSString *)path
{
    NSString *string = [self objectForPath:path];
    return [string floatValue];
}

- (double)doubleForPath:(NSString *)path
{
    NSString *string = [self objectForPath:path];
    return [string doubleValue];
}

- (BOOL)boolForPath:(NSString *)path
{
    NSString *string = [self objectForPath:path];
    return [string boolValue];
}

- (NSString *)stringForPath:(NSString *) path
{
    id o = [self objectForPath:path];
    if (o == nil) {
        return @"";
    }
    if ([o isKindOfClass:[NSNull class]]) {
        return @"";
    }
    NSString *s = [NSString stringWithFormat:@"%@", o];
    if ([s isEqualToString:@"<null>"]) {
        s = @"";
    }
    return s;
}

- (NSMutableDictionary *)mutableDeepCopy
{
    NSMutableDictionary *ret = [[NSMutableDictionary alloc] initWithCapacity:[self count]];
    NSArray *keys = [self allKeys];
    for (id key in keys){
        id oneValue = [self valueForKey:key];
        id oneCopy = nil;
        
        if ([oneValue respondsToSelector:@selector(mutableDeepCopy)]){
            oneCopy = [oneValue mutableDeepCopy];
        }else if ([oneValue respondsToSelector:@selector(mutableCopy)]){
            oneCopy = [oneValue mutableCopy];
        }
        if (oneCopy == nil){
            oneCopy = [oneValue copy];
        }
        [ret setValue:oneCopy forKey:key];
    }
    return ret;
}

- (NSDictionary *)dictForKey:(id)key
{
    id object = [self objectForKey:key];
    if ((object == nil)||[object isEqual:[NSNull null]]) {
        object = @{};
    }
    if (![object isKindOfClass:[NSDictionary class]]) {
        DLog(@"Error format With Expect Dictionary,But %@",NSStringFromClass([object class]));
        object = @{};
    }
    return object;
}


- (NSString *)stringForKey:(id)key
{
    id object = [self objectForKey:key];
    if ([object isEqual:[NSNull null]]) {
        return @"";
    }
    if (![object isKindOfClass:[NSString class]]) {
        return [NSString stringWithFormat:@"%@", object];
    }
    return object;
}


- (BOOL)boolForKey:(id)key
{
    id object = self[key];
    if ([object isEqual:[NSNull null]]) {
        return NO;
    }
    if ([object isKindOfClass:[NSNumber class]]) {
        return [object boolValue];
    }
    if ([object isKindOfClass:[NSString class]]) {
        return [object boolValue];
    }
    return NO;
}

/**
 * 转化为JSON格式
 *
 * @return JSON格式的字符串
 */
- (NSString *)asJSONString
{
    NSData *data = [NSJSONSerialization dataWithJSONObject:self options:0 error:nil];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

@end
