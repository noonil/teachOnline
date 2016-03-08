//
//  HSCompanyModel.h
//  koreanpine
//
//  Created by Christ on 15/7/19.
//  Copyright (c) 2015年 Christ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HSCompanyModel : NSObject
<NSCoding>

@property (copy, nonatomic) NSString *companyID;

@property (copy, nonatomic) NSString *companyName;

@property (copy, nonatomic) NSString *companyUUID;

- (instancetype)initWithDict:(NSDictionary *)dict;

@end
