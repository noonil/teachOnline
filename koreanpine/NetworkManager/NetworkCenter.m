//
//  NetworkCenter.m
//  ManyCode
//
//  Created by lichengfei on 14-7-22.
//  Copyright (c) 2014年 lichengfei. All rights reserved.
//

#import "NetworkCenter.h"
#import "NotifyManager.h"
#import "Reachability.h"
#import "HSLectureModel.h"
#import "HSCompanyModel.h"
#import "HSLoginMgr.h"
#import "HSMyCollectionModel.h"
@interface NetworkCenter ()
@property (nonatomic,copy) NSString *searchUrl;
@end
@implementation NetworkCenter

+ (instancetype)shareCenter
{
    
    static NetworkCenter *_instanceManager = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _instanceManager = [[NetworkCenter alloc] init];
        _instanceManager.httpClient = [EPHttpClient sharedClient];
        _instanceManager.notiCenter = [NotifyManager instanceManager];
        [[NSNotificationCenter defaultCenter] addObserver:_instanceManager selector:@selector(changeSearchUrl:) name:kChooseClassNotification object:nil];
    });
    
    return _instanceManager;
}
- (void) changeSearchUrl:(NSNotification *)notify {
    switch ([notify.object integerValue]) {
        case 0:
            self.searchUrl = @"com/ctrl/course/orgCourseList";
            break;
        case 1:
//           self.searchUrl = @"com/courseV1_4/hsCourseList";
            self.searchUrl = @"com/ctrl/course/hsCourseList";

            break;
        case 2:
            self.searchUrl = @"com/collect/collectInfo/selectCourseCollectV2";
            break;

        default:
            break;
    }
}
- (id) init
{
    self = [super init];
    if (self) {
        
    }
    
    return self;
}


/**
 *  请求网络接口,返回请求的响应接口,并作初期数据处理
 *
 *  @param webApi        网络请求的接口
 *  @param para          请求所带的参数
 *  @param completeBlock 成功请求后得到的响应,此响应包括服务器业务逻辑异常结果,只接收服务器业务逻辑状态码为200的结果
 *  @param errorBlock    服务器响应不正常,网络连接失败返回的响应结果
 */
- (void)requestWebWithParaWithURL:(NSString*)webApi Parameter:(NSDictionary *)para Finish:(HttpResponseSucBlock)completeBlock Error:(HttpResponseErrBlock)errorBlock
{
//    NSLog(@"请求报文:%@", para);
    [self.httpClient POST:webApi parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"URL:%@,Responese:%@",operation.request.URL,responseObject);
        NSError *parserError = nil;
        NSDictionary *resultDic = nil;
        @try {
            resultDic = (NSDictionary *)responseObject;
        }
        @catch (NSException *exception) {
            [NSException raise:@"网络接口返回数据异常" format:@"Error domain %@\n,code=%ld\n,userinfo=%@",parserError.domain,(long)parserError.code,parserError.userInfo];
            //发出消息错误的通知
        }
        @finally {
            //业务产生的状态码
            NSNumber *logicCode = resultDic[@"statusCode"];
            
            //成功获得数据
            if (logicCode.intValue==200) {
                completeBlock(resultDic);
            }
            else{
                //业务逻辑错误
                [[NotifyManager instanceManager] showAlertWithStatusCode:logicCode withAlertView:YES];
                NSError *error = [NSError errorWithDomain:@"服务器业务逻辑错误" code:logicCode.intValue userInfo:nil];
                errorBlock(nil,error);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         [[Hud defaultInstance] hide:[UIApplication sharedApplication].keyWindow];
        if (![self isExistenceNetwork]) {
            NSError *error = [NSError errorWithDomain:@"网络不可用" code:404 userInfo:nil];
            errorBlock(operation,error);
        }
        else{
            errorBlock(operation,error);
            [[NotifyManager instanceManager] showHttpResponseErrorWith:error WithAlertView:NO];
        }
        
    }];
}


- (BOOL)isExistenceNetwork
{
    BOOL isExistenceNetwork;
    //    Reachability *reachAblitity = [Reachability reachabilityForInternetConnection];
    Reachability *reachAblitity = [Reachability reachabilityWithHostName:@"http://www.baidu.com"];
    switch ([reachAblitity currentReachabilityStatus]) {
        case NotReachable:
            isExistenceNetwork=FALSE;
            break;
        case ReachableViaWWAN:
            isExistenceNetwork=TRUE;
            break;
        case ReachableViaWiFi:
            isExistenceNetwork=TRUE;
            break;
    }
    
    return isExistenceNetwork;
}

- (void)getCompanyInfoWithFinish:(void(^)(NSArray *companyItems))successBlock failed:(HSNetworkFailedBlock)failedBlock
{
    [[EPHttpClient sharedClient]  GET:@"com/company/getCompanyInfos" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSArray *companysArr = responseObject[@"data"];
        NSMutableArray *commpanyItems = [NSMutableArray array];
        for (NSDictionary *companyDict in companysArr) {
            HSCompanyModel *companyItem = [[HSCompanyModel alloc] initWithDict:companyDict];
            [commpanyItems addObject:companyItem];
        }
        if (successBlock) {
            successBlock(commpanyItems);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failedBlock(error);
    }];
}

- (void)loginWithNickName:(NSString *)nickname password:(NSString *)password companyUUID:(NSString *)companyUUID succeededBlock:(void(^)(NSDictionary *tokenInfo))succeededBlock failedBlock:(HSNetworkFailedBlock)failedBlock
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:companyUUID forKey:@"uuid"];
    [parameters setObject:nickname forKey:@"phoneNumber"];
    [parameters setObject:password forKey:@"pwdMd5"];
    [[EPHttpClient sharedClient] POST:@"login/doLogin" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *responseDict = (NSDictionary *)responseObject;
        if (IsDictionaryClass(responseDict)){
            NSInteger resCode = [responseDict integerForPath:@"res"];
            if (resCode != 1) {
                NSString *errorMsg = [responseDict stringForKey:@"msg"];
                NSError *error = [NSError errorWithDomain:@"错误" code:-1 userInfo:@{NSLocalizedDescriptionKey:errorMsg}];
                if (failedBlock) {
                    failedBlock(error);
                }
            } else if (succeededBlock) {
                succeededBlock (responseDict);
            }
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failedBlock) {
            failedBlock(error);
        }
    }];
}

- (void)checkLoginInfoWithCompanyUUID:(NSString *)companyUUID loginToken:(NSString *)token succeededBlock:(void(^)(NSDictionary *tokenInfo))succeededBlock failedBlock:(HSNetworkFailedBlock)failedBlock
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:kVERSIONCODE forKey:@"versionCode"];
    [parameters setObject:companyUUID forKey:@"UUID"];
    [parameters setObject:token forKey:@"TOKEN"];
    [[EPHttpClient sharedClient] POST:@"login/checkToken" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *responseDict = (NSDictionary *)responseObject;
        if (IsDictionaryClass(responseDict)){
            NSInteger resCode = [responseDict integerForPath:@"res"];
            if (resCode == 1 ) {
                if (succeededBlock) {
                    succeededBlock (responseDict);
                }
            } else if (failedBlock) {
                NSError *error = [NSError errorWithDomain:@"错误" code:-1 userInfo:@{NSLocalizedDescriptionKey:@"无效的token"}];
                failedBlock(error);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failedBlock) {
            failedBlock(error);
        }
    }];
}

- (void)modifyPasswordWithOldPasswordMd5:(NSString *)oldPasswordMdt newPassword:(NSString *)newPassword finish:(void(^)(NSDictionary *tokenInfo))succeededBlock failedBlock:(void(^)(NSError *error))failedBlock
{
    HSLoginUser *currentUser = [[HSLoginMgr loginMgr] loginUser];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:kVERSIONCODE forKey:@"versionCode"];
    [parameters setObject:currentUser.companyModel.companyUUID forKey:@"uuid"];
    [parameters setObject:currentUser.token forKey:@"token"];
    [parameters setObject:currentUser.userId forKey:@"userId"];
    [parameters setObject:oldPasswordMdt forKey:@"oldPassMd5"];
    [parameters setObject:newPassword forKey:@"newPass"];
    
    [[EPHttpClient sharedClient] POST:@"companyUser/changePass" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *responseDict = (NSDictionary *)responseObject;
        if (IsDictionaryClass(responseDict)){
            NSInteger resCode = [responseDict integerForPath:@"res"];
            if (resCode == 1 ) {
                if (succeededBlock) {
                    succeededBlock (responseDict);
                }
            } else if (failedBlock) {
                NSError *error = [NSError errorWithDomain:@"错误" code:-1 userInfo:@{NSLocalizedDescriptionKey:@"无效的token"}];
                failedBlock(error);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failedBlock) {
            failedBlock(error);
        }
    }];
}

- (void)logoutWithUserID:(NSString *)userID token:(NSString *)token companyUUID:(NSString *)companyUUID finish:(void(^)(NSDictionary *tokenInfo))succeededBlock failedBlock:(void(^)(NSError *error))failedBlock
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:companyUUID forKey:@"uuid"];
    [parameters setObject:token forKey:@"token"];
    [parameters setObject:userID forKey:@"userId"];
    [[EPHttpClient sharedClient] POST:@"login/loginOut" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *responseDict = (NSDictionary *)responseObject;
        if (IsDictionaryClass(responseDict)){
            NSInteger resCode = [responseDict integerForPath:@"res"];
            if (resCode != 1) {
                NSError *error = [NSError errorWithDomain:@"错误" code:-1 userInfo:@{NSLocalizedDescriptionKey:@"无效的token"}];
                if (failedBlock) {
                    failedBlock(error);
                }
            } else if (succeededBlock) {
                succeededBlock (responseDict);
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failedBlock) {
            failedBlock(error);
        }
    }];
}

- (void)fetchPulibcLectureListWithParameter:(NSDictionary *)parameter succeededBlock:(void(^)(NSInteger totalCount, NSArray *lectureItems))succeededBlock failedBlock:(HSNetworkFailedBlock)failedBlock
{
    //
    
    [[EPHttpClient sharedClient] POST:self.searchUrl parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *lectureListArr = nil;
//        if ([self.searchUrl isEqualToString:@"com/courseV1_4/openCourseList"]) {
//            lectureListArr = responseObject[@"data"];
//            
//        }else {
            NSDictionary *lecturelistDict = responseObject[@"data"];
            lectureListArr = lecturelistDict[@"courseList"];
//        }
        if ([self.searchUrl isEqualToString:@"com/collect/collectInfo/selectCourseCollectV2"]) {
                        lectureListArr = lecturelistDict[@"list"];
        }
        NSMutableArray *lectureModels = [NSMutableArray array];
        if (IsArrayClass(lectureListArr)) {
            for (NSDictionary *lectureDict in lectureListArr) {
                HSLectureModel *lectureModel = nil;
                if ([self.searchUrl isEqualToString:@"com/collect/collectInfo/selectCourseCollectV2"]) {
                  NSDictionary  *dict = lectureDict[@"collect"];
                     lectureModel = [[HSMyCollectionModel alloc] initWithDict:dict];
                    lectureModel.collectSource = lectureDict[@"collectSource"];
                    lectureModel.isCollection = YES;
                    if ([lectureModel.collectSource integerValue] == 1) {
                        lectureModel.isHs = NO;
                    }else {
                        lectureModel.isHs = YES;
                    }
                }else {
                    lectureModel = [[HSLectureModel alloc] initWithDict:lectureDict];
                }
                
//                HSLectureModel *lectureModel = [[HSLectureModel alloc] initWithDict:lectureDict];
                if ([self.searchUrl isEqualToString:@"com/ctrl/course/hsCourseList"]) {
                    lectureModel.isHs = YES;
                }else if([self.searchUrl isEqualToString:@"com/ctrl/course/orgCourseList"]) {
                    lectureModel.isHs = NO;
                }
                [lectureModels addObject:lectureModel];
            }
            if (succeededBlock) {
                succeededBlock(lectureModels.count,lectureModels);
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
//注册
- (void) registerNewUserAccountWithPhoneNum:(NSString *)phoneNum PasswordMd5:(NSString *)pwdMd5 VerifyCode:(NSString *)verifyCode SucceededBlock:(void(^)(NSDictionary *Info))succeededBlock FailedBlock:(HSNetworkFailedBlock)failedBlock {
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    NSString *companyUUID = @"6B9B086751F0492BAEDDF84E707F7F6B";
    NSString *versionCode = kVERSIONCODE;
    [parameters setObject:versionCode forKey:@"versionCode"];
    [parameters setObject:companyUUID forKey:@"uuid"];
    [parameters setObject:phoneNum forKey:@"phoneNumber"];
    [parameters setObject:pwdMd5 forKey:@"pwdMd5"];
    [parameters setObject:verifyCode forKey:@"verifyCode"];
    [[EPHttpClient sharedClient] POST:@"companyUser/registerUser" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *responseDict = (NSDictionary *)responseObject;
        if (IsDictionaryClass(responseDict)){
            NSInteger resCode = [responseDict integerForPath:@"res"];
            if (resCode != 1) {
                //"res": 1, // 0: 失败， 1：成功，3：验证码输入错误 ,1000 非红松企业不能注册用户
//                "msg": "",  // 错误码信息
                NSString *errorMsg = [responseDict stringForKey:@"msg"];
                NSError *error = [NSError errorWithDomain:@"错误" code:-1 userInfo:@{NSLocalizedDescriptionKey:errorMsg}];
                if (failedBlock) {
                    failedBlock(error);
                }
            } else if (succeededBlock) {
                succeededBlock (responseDict);
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failedBlock) {
            failedBlock(error);
        }
    }];

}
//验证号码是否已经存在
- (void) verifyPhoneNumberIsExistOrNotWithPhoneNumber:(NSString *)phoneNumber SucceededBlock:(void(^)(NSDictionary *info))succeededBlock FailedBlock:(HSNetworkFailedBlock)failedBlock {
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    NSString *companyUUID = @"6B9B086751F0492BAEDDF84E707F7F6B";
    NSString *versionCode = kVERSIONCODE;
    [parameters setObject:versionCode forKey:@"versionCode"];
    [parameters setObject:companyUUID forKey:@"uuid"];
    [parameters setObject:phoneNumber forKey:@"phoneNumber"];
    
    [[EPHttpClient sharedClient] POST:@"companyUser/validateUserPhone" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *responseDict = (NSDictionary *)responseObject;
        if (IsDictionaryClass(responseDict)){
            NSInteger resCode = [responseDict integerForPath:@"res"];
            if (resCode != 1) {
                /**
                 "res": 1, // 0: 失败， 1：成功，4：手机号码已经存在
                 "msg": "",  // 错误码信息
                 "data": {
                 }
                 */
                NSString *errorMsg = [responseDict stringForKey:@"msg"];
                if (resCode == 4) {
                    errorMsg = @"该手机号码已被注册";
                }
                NSError *error = [NSError errorWithDomain:@"错误" code:-1 userInfo:@{NSLocalizedDescriptionKey:errorMsg}];
                if (failedBlock) {
                    failedBlock(error);
                }
            } else if (succeededBlock) {
                succeededBlock (responseDict);
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failedBlock) {
            failedBlock(error);
        }
    }];
}
//获取验证码
- (void) getVerifyCodeWithPhoneNumber:(NSString *)phoneNumber SucceededBlock:(void(^)(NSDictionary *info))succeededBlock FailedBlock:(HSNetworkFailedBlock)failedBlock {
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    NSString *companyUUID = @"6B9B086751F0492BAEDDF84E707F7F6B";
    NSString *versionCode = kVERSIONCODE;
    [parameters setObject:versionCode forKey:@"versionCode"];
    [parameters setObject:companyUUID forKey:@"uuid"];
    [parameters setObject:phoneNumber forKey:@"phoneNumber"];
    [[EPHttpClient sharedClient] POST:@"companyUser/sendCode4Register" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *responseDict = (NSDictionary *)responseObject;
        if (IsDictionaryClass(responseDict)){
            NSInteger resCode = [responseDict integerForPath:@"res"];
            if (resCode != 1) {
                /**
                 *  "res": 1, // 0: 失败， 1：成功
                 "errCode": 1,  // 错误码， 20030 用户30秒内再次获取验证码
                 "errMsg": 1,  // 错误信息
                 "records": 1,  // 总记录数
                 "pageNum": 0,
                 "pageSize": 0,
                 "data": {
                 "verifyCode": "123456",//验证码值
                 }
                 */
                NSString *errorMsg = [responseDict stringForKey:@"msg"];
                NSError *error = [NSError errorWithDomain:@"错误" code:-1 userInfo:@{NSLocalizedDescriptionKey:errorMsg}];
                if (failedBlock) {
                    failedBlock(error);
                }
                
            } else if (succeededBlock) {
                succeededBlock (responseDict);
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failedBlock) {
            failedBlock(error);
        }
    }];
}
//获取图片验证码
- (void)getVerifyCodeImageWithSucceededBlock:(void (^)(NSDictionary *))succeededBlock FailedBlock:(HSNetworkFailedBlock)failedBlock {
    [[EPHttpClient sharedClient] POST:@"companyUser/getVerifyImage4ForgetPwd" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dict = responseObject[@"data"];
        NSString *URL =dict[@"verifyImge"] ;
        NSData *data = [[NSData alloc] initWithBase64EncodedString:URL options:NSDataBase64DecodingIgnoreUnknownCharacters];
        UIImage *image=[[UIImage alloc] initWithData:data];
        NSMutableDictionary *info = [NSMutableDictionary dictionary];
        [info setObject:image forKey:@"image"];
        [info setObject:dict[@"verifyCode"] forKey:@"verifyCode"];
        
        if (succeededBlock) {
            succeededBlock(info);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}

//忘记密码获取验证码
- (void) getVerifyCodeWithPhoneNumber:(NSString *)phoneNumber companyUUID:(NSString *)companyUUID SucceededBlock:(void(^)(NSDictionary *info))succeededBlock FailedBlock:(HSNetworkFailedBlock)failedBlock {
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    NSString *versionCode = kVERSIONCODE;
    [parameters setObject:versionCode forKey:@"versionCode"];
    [parameters setObject:companyUUID forKey:@"uuid"];
    [parameters setObject:phoneNumber forKey:@"phoneNumber"];
    [[EPHttpClient sharedClient] POST:@"companyUser/sendCode4ForgetPwd" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *responseDict = (NSDictionary *)responseObject;
        if (IsDictionaryClass(responseDict)){
            NSInteger resCode = [responseDict integerForPath:@"res"];
            if (resCode != 1) {
                /**
                 *  "res": 1, // 0: 失败， 1：成功
                 "errCode": 1,  // 错误码，20006 用户不存在，20030 用户30秒内再次获取验证码
                 "errMsg": 1,  // 错误信息
                 "records": 1,  // 总记录数
                 "pageNum": 0,
                 "pageSize": 0,
                 "data": {
                 "verifyCode": "123456",//验证码值
                 }
                 */
                NSString *errorMsg = [responseDict stringForKey:@"msg"];
                NSError *error = [NSError errorWithDomain:@"错误" code:-1 userInfo:@{NSLocalizedDescriptionKey:errorMsg}];
                if (failedBlock) {
                    failedBlock(error);
                }
                
            } else if (succeededBlock) {
                succeededBlock (responseDict);
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failedBlock) {
            failedBlock(error);
        }
    }];

}
//校验验证码是否正确
- (void) verifyCodeIsRightOrNotWithPhoneNumber:(NSString *)phoneNumber companyUUID:(NSString*)companyUUID VerifyCode:(NSString *)verifyCode SucceededBlock:(void(^)(NSDictionary *info))succeededBlock FailedBlock:(HSNetworkFailedBlock)failedBlock {
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    NSString *versionCode = kVERSIONCODE;
    [parameters setObject:versionCode forKey:@"versionCode"];
    [parameters setObject:companyUUID forKey:@"uuid"];
    [parameters setObject:phoneNumber forKey:@"phoneNumber"];
    [parameters setObject:verifyCode forKey:@"verifyCode"];
    
    [[EPHttpClient sharedClient] POST:@"companyUser/verifyCode4ForgetPwd" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *responseDict = (NSDictionary *)responseObject;
        if (IsDictionaryClass(responseDict)){
            NSInteger resCode = [responseDict integerForPath:@"res"];
//            NSDictionary *dict = responseDict[@"data"];
            if (resCode != 1) {
                /**
                 "res": 1, // 0: 失败， 1：成功
                 "errCode": 1,  // 错误码，错误码，20006 用户不存在
                 "errMsg": 1,  // 错误信息
                 "records": 1,  // 总记录数
                 "pageNum": 0,
                 "pageSize": 0,
                 "data": {
                 "isRight": "1",//0：不正确，1：正确
                 }
                 */
                NSString *errorMsg = [responseDict stringForKey:@"msg"];
                if (resCode == 4) {
                    errorMsg = @"该手机号码已被注册";
                }
                NSError *error = [NSError errorWithDomain:@"错误" code:-1 userInfo:@{NSLocalizedDescriptionKey:errorMsg}];
                if (failedBlock) {
                    failedBlock(error);
                }
            }else if (succeededBlock) {
                succeededBlock (responseDict);
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failedBlock) {
            failedBlock(error);
        }
    }];

}
//忘记密码修改密码
- (void) modifyPasswordWithPhoneNumber:(NSString *)phoneNumber companyUUID:(NSString*)companyUUID password:(NSString *)password SucceededBlock:(void(^)(NSDictionary *info))succeededBlock FailedBlock:(HSNetworkFailedBlock)failedBlock {
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
//    NSString *versionCode = kVERSIONCODE;
//    [parameters setObject:versionCode forKey:@"versionCode"];
    [parameters setObject:companyUUID forKey:@"uuid"];
    [parameters setObject:phoneNumber forKey:@"phoneNum"];
    [parameters setObject:password forKey:@"newPass"];
//    NSLog(@"%@",parameters);
    [[EPHttpClient sharedClient] POST:@"companyUser/forgetModifyPassword" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"%@",responseObject);
        NSDictionary *responseDict = (NSDictionary *)responseObject;
        if (IsDictionaryClass(responseDict)){
            NSInteger resCode = [responseDict integerForPath:@"res"];
//             NSDictionary *dict = responseDict[@"data"];
            if (resCode != 1) {
                //"res": 1, // 0: 失败， 1：成功，3：验证码输入错误 ,1000 非红松企业不能注册用户
                //                "msg": "",  // 错误码信息
                NSString *errorMsg = [responseDict stringForKey:@"msg"];
                NSError *error = [NSError errorWithDomain:@"错误" code:-1 userInfo:@{NSLocalizedDescriptionKey:errorMsg}];
                if (failedBlock) {
                    failedBlock(error);
                }
            } else if (succeededBlock) {
                succeededBlock (responseDict);
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"%@",error);
        if (failedBlock) {
            failedBlock(error);
        }
    }];

}

//请求取消收藏
-(void)deleteCollectionCell:(NSString *)lectureID collectID:(NSString *)collectID isHS:(NSString *)hsCourseFlag{
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
        if (collectID ) {
    [parameter setObject:collectID forKey:@"collectInfoId"];
        }
        if (lectureID ) {
    [parameter setObject:lectureID forKey:@"collectionId"];
        }
    
    //    WS(weakSelf);
    //http://localhost:8080/HsMobile/com/ctrl/course/orgCourseList
    //com/courseV1_4/orgCourseList
    //    @"com/courseV1_4/hsCourseList
    NSString *url = nil;
    if ([hsCourseFlag integerValue] == 0) {
        url = @"com/collect/collectInfo/removeCourseCollection";
    }else{
        url = @"com/collect/collectInfo/removeCourseCollectionHongsong";
    }
    [[EPHttpClient sharedClient] POST:url parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *res = nil;
        res = responseObject[@"res"];
        //            [weakSelf getGraspStateInfoWithCourseIds:courseIdArr];
        if ([res intValue] == 1) {
//            [[Hud defaultInstance]showMessage:@"取消收藏成功"];
            //            if([self.delegate respondsToSelector:@selector(arrayDataMgr: didDeleteContentAtIndex:)]){
            //                [self.delegate  arrayDataMgr:self didDeleteContentAtIndex:0];
        }else{
            [[Hud defaultInstance]showMessage:@"取消收藏失败"];
        }

    }
     
     
    failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                  
        }];
    
    
}
-(void)addCollectionCell:(NSString *)lectureID isHS:(NSString *)hsCourseFlag{
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
    if ([HSLoginMgr loginMgr].loginUser.userId.length > 0) {
        [parameter setObject:[HSLoginMgr loginMgr].loginUser.userId forKey:@"userId"];
    }
      [parameter setObject:kVERSIONCODE forKey:@"versionCode"];
    if (lectureID) {
        [parameter setObject:lectureID forKey:@"collectionId"];
    }
        NSString *url = nil;
        if ([hsCourseFlag integerValue] == 0) {
            url = @"com/collect/collectInfo/addCourseCollection";
        }else{
            url = @"com/collect/collectInfo/addCourseCollectionHongsong";
        }
        [[EPHttpClient sharedClient] POST:url parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSString *res = nil;
            res = responseObject[@"res"];
            //            [weakSelf getGraspStateInfoWithCourseIds:courseIdArr];
            if ([res intValue] == 1) {
//                [[Hud defaultInstance]showMessage:@"收藏成功"];
                //            if([self.delegate respondsToSelector:@selector(arrayDataMgr: didDeleteContentAtIndex:)]){
                //                [self.delegate  arrayDataMgr:self didDeleteContentAtIndex:0];
            }else{
                [[Hud defaultInstance]showMessage:@"收藏失败"];
            }
         
            
        }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];

}


//下载 PDF 文件
- (void) downloadPDFFIleWithOption:(NSString *)url downloadSuccess:(void (^)(AFHTTPRequestOperation *, id))success downloadFailure:(void (^)(AFHTTPRequestOperation *, NSError *))failure {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:kVERSIONCODE forKey:@"versionCode"];
    [parameters setObject:url forKey:@"url"];
    ///HsMobile/com/ctrl/course/courseware/getVedioUrlByCloudId
    ///com/courseware/getVedioUrl 旧的
    [[EPHttpClient sharedClient] POST:@"com/courseware/getVedioUrl" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
      
        NSString *pdfUrl = responseObject[@"data"];
                NSInteger resCode = [responseObject integerForPath:@"res"];
        if (resCode == 1) {
            if (success) {
                success(operation,pdfUrl);
            }
//            NSLog(@"%@",pdfUrl);
            //http://dldir1.qq.com/qqfile/qq/QQ7.6/15742/QQ7.6.exe 示范
            
 
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"失败");
    }];
}

@end


@implementation EPHttpClient

+ (instancetype)sharedClient
{
    static EPHttpClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[EPHttpClient alloc] initWithBaseURL:[NSURL URLWithString:HSHttpApiBaseURL]];
        [_sharedClient setSecurityPolicy:[AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone]];
        
        [_sharedClient.responseSerializer setAcceptableContentTypes:[NSSet setWithObject:@"text/plain"]];
        
    });
    
    return _sharedClient;
}

-(void)post:(NSDictionary *)parameters resourcePath:(NSString *)path success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure
{
    //获取当前的url
    NSString *url = [self.baseURL.absoluteString stringByAppendingString:path];
    [[AFHTTPRequestOperationManager manager] POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
//        NSString *message = [responseObject stringForPath:@"message"];
//        NSString *code = [responseObject stringForPath:@"code"];
//        if (![code isEqualToString:@"200"]) {
//            NSDictionary *userInfo = nil;
//            if (IsNilOrNull(message) || IsStrEmpty(message)) {
//                userInfo = [NSDictionary dictionaryWithObject:@"返回数据格式错误" forKey:NSLocalizedDescriptionKey];
//            }else{
//                userInfo = [NSDictionary dictionaryWithObject:message forKey:NSLocalizedDescriptionKey];
//            }
//            NSError *error = [NSError errorWithDomain:YoHoErrorDomain code:YoHoErrorCode userInfo:userInfo];
//            failure(operation, error);
//            return;
//        }
        
        success(operation, responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation, error);
    }];
}
/*- (IBAction)downloadTouched:(id)sender {
    NSString *savedPath = [NSHomeDirectory() stringByAppendingString:@"/Documents/QQ7.6.exe"];
    //    NSDictionary *paramaterDic= @{@"jsonString":[@{@"userid":@"2332"} JSONString]?:@""};
    [self downloadFileWithOption:@{@"userid":@"123123"}
                   withInferface:@"http://dldir1.qq.com/qqfile/qq/QQ7.6/15742/QQ7.6.exe"
                       savedPath:savedPath
                 downloadSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                     
                 } downloadFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
                     
                 } progress:^(float progress) {
                     
                 }];
}
 */

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kChooseClassNotification object:nil];
}
@end