//
//  ViewController.h
//  koreanpine
//
//  Created by Christ on 15/7/15.
//  Copyright (c) 2015年 Christ. All rights reserved.
//

#import "HSBaseVC.h"
@class HSLoginVC,HSCompanyModel;
@interface HSRootVC : HSBaseVC
@property (strong, nonatomic) HSLoginVC *loginVC;
@property (nonatomic,copy) NSString *phoneNum;
@property (nonatomic,strong) HSCompanyModel *companyModel;
+ (instancetype)rootVC;

- (void)finishShowlaunchGuideVC;

- (void)finishShowLoginVC;
- (void)showLoginVC;
@end

