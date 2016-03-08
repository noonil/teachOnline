//
//  YH_Model.m
//  YH_Mall
//
//  Created by Cloud on 15/1/23.
//  Copyright (c) 2015年 YOHO. All rights reserved.
//

#import "YH_Model.h"

@implementation YH_Model

- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionaryValue error:(NSError **)error
{
    self = [super initWithDictionary:dictionaryValue error:error];
    if (self == nil) return nil;
    
    return self;
}

- (NSDictionary *)dictionaryValue {
    NSMutableDictionary *modifiedDictionaryValue = [[super dictionaryValue] mutableCopy];
    
    for (NSString *originalKey in [super dictionaryValue]) {
        if ([self valueForKey:originalKey] == nil) {
            [modifiedDictionaryValue removeObjectForKey:originalKey];
        }
    }
    
    return [modifiedDictionaryValue copy];
}

#pragma mark - MTLJSONSerializing

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{};
}

#pragma mark - KVC method

/**
 *  有的时候API的response会有空值，比如pubilshTime可能不是每次都有的，JSON是这样儿的：
 *  {
 *      "pubilshTime": null
 *  }
 *  Mantle在这种情况会将pubilshTime转换为nil，但如果是标量如NSInteger怎么办？KVC会直接raise NSInvalidArgumentException。
 *  所以重写kvc的setNilValueForKey方法，设置为0
 */
- (void)setNilValueForKey:(NSString *)key
{
    [self setValue:@0 forKey:key]; // For NSInteger/CGFloat/BOOL
}

#pragma mark - Date Formatter

+ (NSDateFormatter *)dateFormatter
{
    static NSDateFormatter *_formatter;
    
    if (!_formatter) {
        _formatter = [[NSDateFormatter alloc] init];
        _formatter.dateFormat = @"yyyy.MM.dd HH:mm:ss";
    }
    return _formatter;
}

@end
