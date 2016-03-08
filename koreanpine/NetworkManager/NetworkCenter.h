//
//  NetworkCenter.h
//  ManyCode
//
//  Created by lichengfei on 14-7-22.
//  Copyright (c) 2014年 lichengfei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "NetworkApiDefine.h"
#import <CoreLocation/CoreLocation.h>
//static NSString *const HSHttpApiBaseURL = @"http://192.168.10.26:8080/HsMobile/";
//#ifdef DEBUG
//static NSString *const HSHttpApiBaseURL = @"http://192.168.10.136:8088/HsMobile/";
//static NSString *const HSImgBaseURL = @"http://192.168.10.113:18080/img";
//#else
static NSString *const HSHttpApiBaseURL = @"http://app.hongsong.cn:80/HsMobile/";
static NSString *const HSImgBaseURL = @"http://image1.hongsong.cn";
//#endif

/**
 *  请求成功后的数据简单处理后的回调
 *
 *  @param resultDic 返回的字典对象
 */
typedef void (^HttpResponseSucBlock) (NSDictionary *resultDic);

typedef void(^HSNetworkFailedBlock)(NSError *error);
/**
 *  请求失败后的响应及错误实例
 *
 *  @param operation 响应
 *  @param erro      错误实例
 */
typedef void (^HttpResponseErrBlock) (AFHTTPRequestOperation *operation,NSError *error);


@class EPHttpClient;
@class NotifyManager;

@interface NetworkCenter : NSObject<NSURLSessionDelegate>

@property (nonatomic, assign) EPHttpClient *httpClient;
@property (nonatomic, assign) NotifyManager *notiCenter;

+ (instancetype)shareCenter;

/**
 *  请求网络接口,返回请求的响应接口,并作初期数据处理
 *
 *  @param webApi        网络请求的接口
 *  @param para          请求所带的参数
 *  @param completeBlock 成功请求后得到的响应,此响应包括服务器业务逻辑异常结果,只接收服务器业务逻辑状态码为200的结果
 *  @param errorBlock    服务器响应不正常,网络连接失败返回的响应结果
 */
- (void)requestWebWithParaWithURL:(NSString*)webApi Parameter:(NSDictionary *)para Finish:(HttpResponseSucBlock)completeBlock Error:(HttpResponseErrBlock)errorBlock;

- (void)getCompanyInfoWithFinish:(void(^)(NSArray *companyItems))successBlock failed:(HSNetworkFailedBlock)failedBlock;

//登录
- (void)loginWithNickName:(NSString *)nickname password:(NSString *)password companyUUID:(NSString *)companyUUID succeededBlock:(void(^)(NSDictionary *tokenInfo))succeededBlock failedBlock:(HSNetworkFailedBlock)failedBlock;

- (void)checkLoginInfoWithCompanyUUID:(NSString *)companyUUID loginToken:(NSString *)token succeededBlock:(void(^)(NSDictionary *tokenInfo))succeededBlock failedBlock:(HSNetworkFailedBlock)failedBlock;

//注销
- (void)logoutWithUserID:(NSString *)userID token:(NSString *)token companyUUID:(NSString *)companyUUID finish:(void(^)(NSDictionary *tokenInfo))succeededBlock failedBlock:(void(^)(NSError *error))failedBlock;

- (void)modifyPasswordWithOldPasswordMd5:(NSString *)oldPasswordMdt newPassword:(NSString *)newPassword finish:(void(^)(NSDictionary *tokenInfo))succeededBlock failedBlock:(void(^)(NSError *error))failedBlock;

- (void)fetchPulibcLectureListWithParameter:(NSDictionary *)parameter succeededBlock:(void(^)(NSInteger totalCount, NSArray *lectureItems))succeededBlock failedBlock:(HSNetworkFailedBlock)failedBlock;
//注册
- (void) registerNewUserAccountWithPhoneNum:(NSString *)phoneNum PasswordMd5:(NSString *)pwdMd5 VerifyCode:(NSString *)verifyCode SucceededBlock:(void(^)(NSDictionary *Info))succeededBlock FailedBlock:(HSNetworkFailedBlock)failedBlock;
//新用户获取验证码
- (void) getVerifyCodeWithPhoneNumber:(NSString *)phoneNumber SucceededBlock:(void(^)(NSDictionary *info))succeededBlock FailedBlock:(HSNetworkFailedBlock)failedBlock;
//验证号码是否已经存在
- (void) verifyPhoneNumberIsExistOrNotWithPhoneNumber:(NSString *)phoneNumber SucceededBlock:(void(^)(NSDictionary *info))succeededBlock FailedBlock:(HSNetworkFailedBlock)failedBlock;
//忘记密码获取验证码
- (void) getVerifyCodeWithPhoneNumber:(NSString *)phoneNumber companyUUID:(NSString *)companyUUID SucceededBlock:(void(^)(NSDictionary *info))succeededBlock FailedBlock:(HSNetworkFailedBlock)failedBlock;
//获取图片验证码(忘记密码)
- (void) getVerifyCodeImageWithSucceededBlock:(void(^)(NSDictionary *info))succeededBlock FailedBlock:(HSNetworkFailedBlock)failedBlock;
//校验验证码是否正确
- (void) verifyCodeIsRightOrNotWithPhoneNumber:(NSString *)phoneNumber companyUUID:(NSString*)companyUUID VerifyCode:(NSString *)verifyCode SucceededBlock:(void(^)(NSDictionary *info))succeededBlock FailedBlock:(HSNetworkFailedBlock)failedBlock;
//忘记密码修改密码
- (void) modifyPasswordWithPhoneNumber:(NSString *)phoneNumber companyUUID:(NSString*)companyUUID password:(NSString *)password SucceededBlock:(void(^)(NSDictionary *info))succeededBlock FailedBlock:(HSNetworkFailedBlock)failedBlock;
#pragma mark - 课程相关

//取消收藏
-(void)deleteCollectionCell:(NSString *)lectureID collectID:(NSString *)collectID isHS:(NSString *)hsCourseFlag;

//添加收藏
-(void)addCollectionCell:(NSString *)lectureID isHS:(NSString *)hsCourseFlag;



//- (void) downloadPDFFIleWithOption:(NSString *)cloudId downloadSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success downloadFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

@end

@interface EPHttpClient : AFHTTPRequestOperationManager

+ (instancetype)sharedClient;

-(void)post:(NSDictionary *)parameters resourcePath:(NSString *)path success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure;



@end

