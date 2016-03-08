//
//  NSString+Extension.m
//  WeiBo17
//
//  Created by teacher on 15/8/23.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)

- (CGSize)sizeWithFont:(UIFont *)font{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    dic[NSFontAttributeName] = font;
    return [self sizeWithAttributes:dic];
}

- (CGSize)sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    dic[NSFontAttributeName] = font;
    return [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
}

@end
    
