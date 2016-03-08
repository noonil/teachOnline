//
//  HSLoginMgr.m
//  koreanpine
//
//  Created by Christ on 15/7/18.
//  Copyright (c) 2015年 Christ. All rights reserved.
//

#import "HSLoginMgr.h"
#import "NetworkCenter.h"
#import "HSCompanyModel.h"
#import "YH_Tool.h"

//#define kStoreKeyUserLoginInfo @"storeKeyUserLoginInfo"
//#define kStoreKeyLastSelectCompanyModel @"kStoreKeyLastSelectCompanyModel"

@interface HSLoginMgr ()

@property (strong, nonatomic) HSCompanyModel *lastSelectedCompanyModel;

@end

@implementation HSLoginMgr

+ (instancetype)loginMgr
{
    static HSLoginMgr *loginMgr = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        loginMgr = [[HSLoginMgr alloc] init];
    });
    return loginMgr;
}

- (void)startCheckLocalLoginInfoWithFinishBlock:(void(^)(BOOL suc))finishBlock
{
    NSData *storeCurrentUserArchiver = [[NSUserDefaults standardUserDefaults] objectForKey:kStoreKeyUserLoginInfo];
    if (!storeCurrentUserArchiver || storeCurrentUserArchiver.length == 0) {
        return;
    }
    
    HSLoginUser *loginUser = [NSKeyedUnarchiver unarchiveObjectWithData:storeCurrentUserArchiver];
    if (loginUser) {
        //对token进行验证
        [self checkLoginTokenWithUserInfo:loginUser withFinishBlock:^(BOOL suc) {
            if (finishBlock) {
                finishBlock(suc);
            }
        }];
        self.loginUser = loginUser;
    }

}

- (BOOL)shouldCheckLoginInfo
{
    NSData *storeCurrentUserArchiver = [[NSUserDefaults standardUserDefaults] objectForKey:kStoreKeyUserLoginInfo];
    if (!storeCurrentUserArchiver || storeCurrentUserArchiver.length == 0) {
        return NO;
    } else {
        return YES;
    }
}

- (void)loginWithUserName:(NSString *)userName passWord:(NSString *)password companyModel:(HSCompanyModel *)companyModel finish:(void(^)(NSDictionary *tokenInfo))succeededBlock failedBlock:(void(^)(NSError *error))failedBlock
{
    self.lastSelectedCompanyModel = companyModel;
    password = [Common getMd5_32Bit_String:password];
//    NSLog(@"%@",password);
    [[NetworkCenter shareCenter] loginWithNickName:userName password:password companyUUID:companyModel.companyUUID succeededBlock:^(NSDictionary *tokenInfo) {
        [self updateUserInfoWithTokenInfo:tokenInfo];
        if (succeededBlock) {
            succeededBlock(tokenInfo);
        }

    } failedBlock:^(NSError *error) {
        failedBlock(error);
    }];
}
//注册
- (void) registerNewUserAccountWithPhoneNum:(NSString *)phoneNum Password:(NSString *)password VerifyCode:(NSString *)verifyCode SucceededBlock:(void (^)(NSDictionary *))succeededBlock FailedBlock:(HSNetworkFailedBlock)failedBlock {
    [[NetworkCenter shareCenter] registerNewUserAccountWithPhoneNum:phoneNum PasswordMd5:password VerifyCode:verifyCode SucceededBlock:^(NSDictionary *info) {
        if (succeededBlock) {
            succeededBlock(info);
        }
    } FailedBlock:^(NSError *error) {
        failedBlock(error);
    }];
}

//获取验证码
- (void) getVerifyCodeWithPhoneNumber:(NSString *)phoneNumber SucceededBlock:(void(^)(NSDictionary *info))succeededBlock FailedBlock:(HSNetworkFailedBlock)failedBlock {
    [[NetworkCenter shareCenter] getVerifyCodeWithPhoneNumber:phoneNumber SucceededBlock:^(NSDictionary *info) {
        if (succeededBlock) {
            succeededBlock(info);
        }
    } FailedBlock:^(NSError *error) {
        failedBlock(error);
    }];
}

//验证号码是否已经存在
- (void) verifyPhoneNumberIsExistOrNotWithPhoneNumber:(NSString *)phoneNumber SucceededBlock:(void(^)(NSDictionary *info))succeededBlock FailedBlock:(HSNetworkFailedBlock)failedBlock {
    [[NetworkCenter shareCenter] verifyPhoneNumberIsExistOrNotWithPhoneNumber:phoneNumber SucceededBlock:^(NSDictionary *info) {
        if (succeededBlock) {
            succeededBlock(info);
        }
    } FailedBlock:^(NSError *error) {
         failedBlock(error);
    }];
}
//忘记密码获取验证码
- (void) getVerifyCodeWithPhoneNumber:(NSString *)phoneNumber companyModel:(HSCompanyModel*)companyModel SucceededBlock:(void(^)(NSDictionary *info))succeededBlock FailedBlock:(HSNetworkFailedBlock)failedBlock {
     [[NetworkCenter shareCenter] getVerifyCodeWithPhoneNumber:phoneNumber companyUUID:companyModel.companyUUID SucceededBlock:^(NSDictionary *info) {
         if (succeededBlock) {
             succeededBlock(info);
         }
     } FailedBlock:^(NSError *error) {
         failedBlock(error);
     }];

}
//校验验证码是否正确
- (void) verifyCodeIsRightOrNotWithPhoneNumber:(NSString *)phoneNumber companyModel:(HSCompanyModel*)companyModel VerifyCode:(NSString *)verifyCode SucceededBlock:(void(^)(NSDictionary *info))succeededBlock FailedBlock:(HSNetworkFailedBlock)failedBlock {
    [[NetworkCenter shareCenter] verifyCodeIsRightOrNotWithPhoneNumber:phoneNumber companyUUID:companyModel.companyUUID VerifyCode:verifyCode SucceededBlock:^(NSDictionary *info) {
        if (succeededBlock) {
            succeededBlock(info);
        }
    } FailedBlock:^(NSError *error) {
        failedBlock(error);
    }];

}
- (void)checkLoginTokenWithUserInfo:(HSLoginUser *)loginUser withFinishBlock:(void(^)(BOOL suc))finishBlock
{
    if (loginUser.companyModel.companyUUID.length * loginUser.token.length == 0) {
        return;
    }
    
    [YH_Tool alert:@"" type:YHBAlertTypeWait];
    [[NetworkCenter shareCenter] checkLoginInfoWithCompanyUUID:loginUser.companyModel.companyUUID loginToken:loginUser.token succeededBlock:^(NSDictionary *tokenInfo) {
        NSDictionary *userInfoDict = tokenInfo[@"data"];
        if (IsDictionaryClass(userInfoDict)) {
            [self.loginUser updateWithDict:userInfoDict];
        }
        
        self.hasLogin = YES;
        [YH_Tool hideAlert];
        if (finishBlock) {
            finishBlock(YES);
        }
        
    } failedBlock:^(NSError *error) {
        self.loginUser = nil;
        self.hasLogin = NO;
        [YH_Tool alert:error.localizedDescription type:YHBAlertTypeFail autoHide:YES];
        if (finishBlock) {
            finishBlock(NO);
        }
    }];
}
//忘记密码修改密码
- (void) modifyPasswordWithPhoneNumber:(NSString *)phoneNumber companyModel:(HSCompanyModel*)companyModel password:(NSString *)password SucceededBlock:(void(^)(NSDictionary *info))succeededBlock FailedBlock:(HSNetworkFailedBlock)failedBlock {
    [[NetworkCenter shareCenter] modifyPasswordWithPhoneNumber:phoneNumber companyUUID:companyModel.companyUUID password:password SucceededBlock:^(NSDictionary *info) {
        if (succeededBlock) {
            succeededBlock(info);
        }
    } FailedBlock:^(NSError *error) {
        failedBlock(error);
    }];

}
- (void)logoutCurrentUser
{
    self.hasLogin = NO;
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kStoreKeyUserLoginInfo];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:kUserDidLogoutNotifi object:nil];
    [[NetworkCenter shareCenter] logoutWithUserID:self.loginUser.userId token:self.loginUser.token companyUUID:self.loginUser.companyModel.companyUUID finish:^(NSDictionary *tokenInfo) {
//        [[NSNotificationCenter defaultCenter] postNotificationName:kUserDidLogoutNotifi object:nil];
    } failedBlock:^(NSError *error) {
        
    }];
}


- (void)updateUserInfoWithTokenInfo:(NSDictionary *)tokenInfo
{
    HSLoginUser *loginUser = [[HSLoginUser alloc] initWithDict:tokenInfo];
    loginUser.companyModel = self.lastSelectedCompanyModel;
    self.loginUser = loginUser;
    self.hasLogin = YES;
    [self storeCurrentLoginUser];
}

- (void)storeCurrentLoginUser
{
    NSData *loginUserArchiver = [NSKeyedArchiver archivedDataWithRootObject:self.loginUser];
    NSData *lastCompanyArchiver = [NSKeyedArchiver archivedDataWithRootObject:self.loginUser.companyModel];
    [[NSUserDefaults standardUserDefaults] setObject:loginUserArchiver forKey:kStoreKeyUserLoginInfo];
    [[NSUserDefaults standardUserDefaults] setObject:lastCompanyArchiver forKey:kStoreKeyLastSelectCompanyModel];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - Other action

- (void)uploadUserHeaderImage:(NSString *)imagePath withFinish:(void(^)(NSDictionary *tokenInfo))succeededBlock failedBlock:(void(^)(NSError *error))failedBlock;
{
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
    [parameter setObject:@"160" forKey:@"versionCode"];
    [parameter setObject:@"Android" forKey:@"device_type"];
    [parameter setObject:@"Android" forKey:@"deviceType"];
    HSCompanyModel *companyModel = [HSLoginMgr loginMgr].loginUser.companyModel;
    if (companyModel.companyUUID.length > 0) {
        [parameter setObject:companyModel.companyUUID forKey:@"uuid"];
    }
    if ([HSLoginMgr loginMgr].loginUser.userId.length > 0) {
        [parameter setObject:[HSLoginMgr loginMgr].loginUser.userId forKey:@"userId"];
    }
    
    
    
    [[EPHttpClient sharedClient] POST:@"companyUser/edit" parameters:parameter constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        NSURL *filePathURL = [NSURL fileURLWithPath:imagePath];
        [formData appendPartWithFileURL:filePathURL name:@"file" error:nil];
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *resultInfo = responseObject[@"data"];
        if (!IsDictionaryClass(resultInfo)) {
            if (succeededBlock) {
                succeededBlock(resultInfo);
            }
        } else {
            NSError *error = [NSError errorWithDomain:@"错误的数据" code:-1 userInfo:@{NSLocalizedDescriptionKey:@"数据格式错误"}];
            if (failedBlock) {
                failedBlock(error);
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failedBlock) {
            failedBlock(error);
        }
    }];
}

@end
