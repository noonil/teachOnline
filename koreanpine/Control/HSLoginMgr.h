//
//  HSLoginMgr.h
//  koreanpine
//
//  Created by Christ on 15/7/18.
//  Copyright (c) 2015年 Christ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HSLoginUser.h"

#define kStoreKeyUserLoginInfo @"storeKeyUserLoginInfo"
#define kStoreKeyLastSelectCompanyModel @"kStoreKeyLastSelectCompanyModel"

@interface HSLoginMgr : NSObject

+ (instancetype)loginMgr;

@property (assign, nonatomic) BOOL hasLogin;

@property (strong, nonatomic) HSLoginUser *loginUser;

- (void)startCheckLocalLoginInfoWithFinishBlock:(void(^)(BOOL suc))finishBlock;

- (BOOL)shouldCheckLoginInfo;

- (void)logoutCurrentUser;

- (void)loginWithUserName:(NSString *)userName passWord:(NSString *)password companyModel:(HSCompanyModel*)companyModel finish:(void(^)(NSDictionary *tokenInfo))succeededBlock failedBlock:(void(^)(NSError *error))failedBlock;
//注册
- (void) registerNewUserAccountWithPhoneNum:(NSString *)phoneNum Password:(NSString *)password VerifyCode:(NSString *)verifyCode SucceededBlock:(void(^)(NSDictionary *info))succeededBlock FailedBlock:(HSNetworkFailedBlock)failedBlock;
//新用户获取验证码
- (void) getVerifyCodeWithPhoneNumber:(NSString *)phoneNumber SucceededBlock:(void(^)(NSDictionary *info))succeededBlock FailedBlock:(HSNetworkFailedBlock)failedBlock;

//验证号码是否已经存在
- (void) verifyPhoneNumberIsExistOrNotWithPhoneNumber:(NSString *)phoneNumber SucceededBlock:(void(^)(NSDictionary *info))succeededBlock FailedBlock:(HSNetworkFailedBlock)failedBlock;
//忘记密码获取验证码
- (void) getVerifyCodeWithPhoneNumber:(NSString *)phoneNumber companyModel:(HSCompanyModel*)companyModel SucceededBlock:(void(^)(NSDictionary *info))succeededBlock FailedBlock:(HSNetworkFailedBlock)failedBlock;
//校验验证码是否正确
- (void) verifyCodeIsRightOrNotWithPhoneNumber:(NSString *)phoneNumber companyModel:(HSCompanyModel*)companyModel VerifyCode:(NSString *)verifyCode SucceededBlock:(void(^)(NSDictionary *info))succeededBlock FailedBlock:(HSNetworkFailedBlock)failedBlock;
//忘记密码修改密码
- (void) modifyPasswordWithPhoneNumber:(NSString *)phoneNumber companyModel:(HSCompanyModel*)companyModel password:(NSString *)password SucceededBlock:(void(^)(NSDictionary *info))succeededBlock FailedBlock:(HSNetworkFailedBlock)failedBlock;
//上传用户头像
- (void)uploadUserHeaderImage:(NSString *)imagePath withFinish:(void(^)(NSDictionary *info))succeededBlock failedBlock:(void(^)(NSError *error))failedBlock;


@end
