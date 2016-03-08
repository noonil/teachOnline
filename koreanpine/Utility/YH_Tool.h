//
//  YH_Tool.h
//  YH_Mall
//
//  Created by XingYaXin on 14-10-10.
//  Copyright (c) 2014年 YOHO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

typedef enum {
    YHBAlertTypeMessage,
    YHBAlertTypeSuccess,
    YHBAlertTypeFail,
    YHBAlertTypeNetwork,
    YHBAlertTypeWait,
} YHBAlertType;

@interface YH_Tool : NSObject

+ (void)alert:(NSString *)message type:(YHBAlertType)type autoHide:(BOOL)isAutoHide inView:(UIView *)view;
// 所有不加view参数的,都是默认加在主window上,无法进行其他操作
+ (void)alert:(NSString *)message type:(YHBAlertType)type autoHide:(BOOL)isAutoHide;
+ (void)alert:(NSString *)message type:(YHBAlertType)type;
+ (void)alertMessage:(NSString *)message;
+ (void)alertSuccess:(NSString *)message;
+ (void)alertFail:(NSString *)message;
+ (void)alertNetwork:(NSString *)message;
+ (void)alertNetworkLess;
+ (void)alertWait;
+ (void)hideAlert;
+ (void)hideAlertInView:(UIView *)view;
@end
