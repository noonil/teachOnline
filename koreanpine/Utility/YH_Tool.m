//
//  YH_Tool.m
//  YH_Mall
//
//  Created by XingYaXin on 14-10-10.
//  Copyright (c) 2014年 YOHO. All rights reserved.
//

#import "YH_Tool.h"

#define kAlertDelayTime     1.0f


@implementation YH_Tool
+ (void)alert:(NSString *)message type:(YHBAlertType)type autoHide:(BOOL)isAutoHide inView:(UIView *)view
{
    NSString *msg = @"";
    if (IsNilOrNull(message) || [message isEqualToString:@""]) {
        msg  =  NSLocalizedString(@"loading...", nil);
    }else{
        msg = message;
    }
    
    if (view == nil) {
        view = [[UIApplication sharedApplication] keyWindow];
    }
    
    [self hideAlertInView:view];
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:view];
    hud.labelFont = [UIFont systemFontOfSize:12.0f];
    hud.detailsLabelText = msg;
    hud.yOffset = -60.0f;
    hud.removeFromSuperViewOnHide = YES;
    
    NSString *alertImageName = @"";
    MBProgressHUDMode mode = MBProgressHUDModeCustomView;
    if (type == YHBAlertTypeFail) {
        alertImageName = @"shared_alert_fail";
    }
    else if (type == YHBAlertTypeSuccess) {
        alertImageName = @"shared_alert_success";
    }
    else if (type == YHBAlertTypeNetwork) {
        alertImageName = @"shared_alert_network";
    }
    else if (type == YHBAlertTypeMessage) {
        alertImageName = @"";
    }
    else if (type == YHBAlertTypeWait) {
        mode = MBProgressHUDModeIndeterminate;
    }
    if (mode == MBProgressHUDModeCustomView) {
        hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:alertImageName]];
    }
    hud.mode = mode;
    
    [view addSubview:hud];
    [hud show:YES];
    if (isAutoHide) {
        double delayInSeconds = kAlertDelayTime;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [hud hide:YES];
        });
    }
}


+ (void)alert:(NSString *)message type:(YHBAlertType)type autoHide:(BOOL)isAutoHide
{
    if (IsStrEmpty(message))
    {
        message = nil;
    }
    [self alert:message type:type autoHide:isAutoHide inView:[[UIApplication sharedApplication] keyWindow]];
}


+ (void)alert:(NSString *)message type:(YHBAlertType)type
{
    [self alert:message type:type autoHide:YES];
}


+ (void)alertMessage:(NSString *)message
{
    [self alert:message type:YHBAlertTypeMessage];
}


+ (void)alertSuccess:(NSString *)message
{
    [self alert:message type:YHBAlertTypeSuccess];
}


+ (void)alertFail:(NSString *)message
{
    [self alert:message type:YHBAlertTypeFail];
}


+ (void)alertNetwork:(NSString *)message
{
    [self alert:message type:YHBAlertTypeNetwork];
}


+ (void)alertNetworkLess
{
    [self alertNetwork:NSLocalizedString(@"bad network try later", nil)];
}


+ (void)alertWait
{
    [self alert:NSLocalizedString(@"loading...", nil) type:YHBAlertTypeWait autoHide:NO];
}


+ (void)hideAlert
{
    [MBProgressHUD hideAllHUDsForView:[[UIApplication sharedApplication] keyWindow] animated:NO];
}


+ (void)hideAlertInView:(UIView *)view
{
    [MBProgressHUD hideAllHUDsForView:view animated:NO];
}

@end
