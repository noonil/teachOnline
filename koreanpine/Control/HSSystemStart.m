//
//  HSSystemStart.m
//  koreanpine
//
//  Created by Christ on 15/7/15.
//  Copyright (c) 2015年 Christ. All rights reserved.
//

#import "HSSystemStart.h"
#import "HSLoginMgr.h"
#import "NetworkCenter.h"
#import "UMFeedback.h"
#import "MobClick.h"
#import "IQKeyboardManager.h"
#import "HSLectureDownloadMgr.h"

@implementation HSSystemStart

//系统启动 (这个方法无特殊情况请不要修改， 如果增加启动函数，
//请在 SystemStartBySync/SystemStartByAsync 中添加
+(BOOL)SystemStart
{
    [HSSystemStart SystemStartBySync];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [HSSystemStart SystemStartByAsync];
    });
    return YES;
}

//同步启动
+(BOOL)SystemStartBySync
{        //feed back
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [UMFeedback setAppkey:@"5582241667e58ef3ee0064bd"];
    [UMFeedback setLogEnabled:NO];
    [[UMFeedback sharedInstance] setFeedbackViewController:[UMFeedback feedbackViewController] shouldPush:YES];
    
    return YES;
}

//异步启动
+(void)SystemStartByAsync
{
    [[HSRuntimeMgr runtimeMgr] getCompanyInfo];
    [[HSLectureDownloadMgr downloadMgr] loadDownloadCache];
}

@end
