//
//  AppDelegate.h
//  koreanpine
//
//  Created by Christ on 15/7/15.
//  Copyright (c) 2015年 Christ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, assign) BOOL allowRotation;

+ (AppDelegate *)appDelegate;

@end

