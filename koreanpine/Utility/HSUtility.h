//
//  HSUtility.h
//  koreanpine
//
//  Created by Christ on 15/7/18.
//  Copyright (c) 2015年 Christ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Hud.h"
#import "Common.h"
#import "NSDictionary+YOHO.h"
#import "HSRuntimeMgr.h"
#import "YH_systemUtility.h"
#import "MJExtension.h"
#define kChooseClassNotification @"kChooseClassNotification"
#define kChangeDownloadItemStateNotification @"kChangeDownloadItemStateNotification"

#define kPracticeTableViewArriveTopNotification @"kPracticeTableViewArriveTopNotification"
#define kPracticeTableViewArriveBottomNotification @"kPracticeTableViewArriveBottomNotification"


#define kUserDidLoginNotifi @"kUserDidLoginNotifi"
#define kUserDidLogoutNotifi @"kUserDidLogoutNotifi"
#define kHSAPP @"kHSAPP"
#define kHSAPPTYPE [[NSUserDefaults standardUserDefaults] integerForKey:kHSAPP]
//#define kHSAPPTYPE 2
#define kVERSIONCODE @"300"
//红松信息出品的两款 App :职学堂和红松派
typedef NS_ENUM(NSUInteger, HSAppType) {
    HSAppTypeZhiXueTang = 1,
    HSAppTypeHongSongPai
};
@interface HSUtility : NSObject
+ (void) verifyApplication;
@end

@interface UINavigationController (PushWithBottomBar)

/**
 *  在tabbar的显示和隐藏发生变动时使用此方法直接完成
 **/
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated hideBottomTabBar:(BOOL)hide;

@end
