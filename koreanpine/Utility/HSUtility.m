//
//  HSUtility.m
//  koreanpine
//
//  Created by Christ on 15/7/18.
//  Copyright (c) 2015年 Christ. All rights reserved.
//

#import "HSUtility.h"

@implementation HSUtility
//判断到底是哪个 APP 并保存当前 app 类型
+ (void)verifyApplication {
    NSString *name = [NSBundle mainBundle].infoDictionary[@"CFBundleName"];
    if ([name isEqualToString:@"职学堂"]) {
       [[NSUserDefaults standardUserDefaults] setInteger:HSAppTypeZhiXueTang forKey:kHSAPP] ;
    }else {
         [[NSUserDefaults standardUserDefaults] setInteger:HSAppTypeHongSongPai forKey:kHSAPP] ;
    }
    [[NSUserDefaults standardUserDefaults] synchronize];//数据立即同步
}

@end

@implementation UINavigationController (PushWithBottomBar)

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated hideBottomTabBar:(BOOL)hide
{
    [viewController setHidesBottomBarWhenPushed:hide];
    [self pushViewController:viewController animated:animated];
}

@end