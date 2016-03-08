//
//  YH_Model.h
//  YH_Mall
//
//  Created by Cloud on 15/1/23.
//  Copyright (c) 2015年 YOHO. All rights reserved.
//

#import "Mantle.h"

@interface YH_Model : MTLModel <MTLJSONSerializing>

- (instancetype)initWithDict:(NSDictionary *)dict;

+ (NSDateFormatter *)dateFormatter;

@end
