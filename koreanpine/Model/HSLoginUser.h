//
//  HSLoginUser.h
//  koreanpine
//
//  Created by Christ on 15/7/18.
//  Copyright (c) 2015年 Christ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HSCompanyModel.h"
@interface HSLoginUser : NSObject
<NSCoding>

@property (copy, nonatomic) NSString *userId;              //用户标识
@property (copy, nonatomic) NSString *mobile;              //手机号码
@property (copy, nonatomic) NSString *userName;            //用户昵称
@property (copy, nonatomic) NSString *nickName;            //用户昵称
@property (copy, nonatomic) NSString *birthday;            //出生日期
@property (copy, nonatomic) NSString *image;               //头像
@property (copy, nonatomic) NSString *password;             //用户密码
@property (strong, nonatomic) NSNumber *areaId;               //用户当前选择的地区标识
@property (copy, nonatomic) NSString * gender;             //性别，m：男、f：女、n：未知
@property (copy, nonatomic) NSString *token;                  //登陆后 生成token，重新登录直接传token
@property (strong, nonatomic) HSCompanyModel *companyModel;

- (instancetype)initWithDict:(NSDictionary *)dict;

- (void)updateWithDict:(NSDictionary *)dict;

@end
