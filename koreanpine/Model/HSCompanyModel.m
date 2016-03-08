//
//  HSCompanyModel.m
//  koreanpine
//
//  Created by Christ on 15/7/19.
//  Copyright (c) 2015年 Christ. All rights reserved.
//

#import "HSCompanyModel.h"

@implementation HSCompanyModel

- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self.companyID = [dict stringForKey:@"id"];
        self.companyName = [dict stringForKey:@"name"];
        self.companyUUID = [dict stringForKey:@"uuid"];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.companyID = [aDecoder decodeObjectForKey:@"id"];
        self.companyName = [aDecoder decodeObjectForKey:@"name"];
        self.companyUUID = [aDecoder decodeObjectForKey:@"uuid"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.companyID forKey:@"id"];
    [aCoder encodeObject:self.companyName forKey:@"name"];
    [aCoder encodeObject:self.companyUUID forKey:@"uuid"];
}

@end
