//
//  HSLoginUser.m
//  koreanpine
//
//  Created by Christ on 15/7/18.
//  Copyright (c) 2015年 Christ. All rights reserved.
//

#import "HSLoginUser.h"
#import "NetworkCenter.h"

@implementation HSLoginUser

- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self && IsDictionaryClass(dict))
    {
        self.token = [dict stringForKey:@"tokenVal"];
        NSDictionary *userInfoDict = [dict dictForKey:@"data"];
        [self updateWithDict:userInfoDict];
    }
    return self;
}

- (void)updateWithDict:(NSDictionary *)dict
{
    self.userId = [dict stringForKey:@"id"];
    self.userName = [dict stringForKey:@"username"];
    self.mobile = [dict stringForKey:@"phonenumber"];
    self.gender = [dict stringForKey:@"sex"];
    
    self.image = [dict stringForKey:@"path"];
    if (self.image.length > 0) {
        self.image = [NSString stringWithFormat:@"%@!68_68.png",self.image];
        self.image = [HSImgBaseURL stringByAppendingString:self.image];
    }
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.token forKey:@"token"];
    [aCoder encodeObject:self.userId forKey:@"userid"];
    [aCoder encodeObject:self.userName forKey:@"username"];
    [aCoder encodeObject:self.mobile forKey:@"mobile"];
    [aCoder encodeObject:self.gender forKey:@"gender"];
    [aCoder encodeObject:self.image forKey:@"image"];
    [aCoder encodeObject:self.companyModel forKey:@"companymodel"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.token = [aDecoder decodeObjectForKey:@"token"];
        self.userId = [aDecoder decodeObjectForKey:@"userid"];
        self.userName = [aDecoder decodeObjectForKey:@"username"];
        self.mobile = [aDecoder decodeObjectForKey:@"mobile"];
        self.gender = [aDecoder decodeObjectForKey:@"gender"];
        self.image = [aDecoder decodeObjectForKey:@"image"];
        self.companyModel = [aDecoder decodeObjectForKey:@"companymodel"];
    }
    return self;
}

@end
