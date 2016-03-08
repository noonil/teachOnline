//
//  HSUserInfoView.h
//  koreanpine
//
//  Created by Christ on 15/7/18.
//  Copyright (c) 2015年 Christ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSLoginUser.h"

@interface HSUserInfoView : UIView

@property (strong, nonatomic) UIImageView *headIcon;

@property (strong, nonatomic) UILabel *nickNameLabel;

@property (strong, nonatomic) UILabel *companyNameLabel;

@property (strong, nonatomic) UILabel *phoneNumLabel;

- (void)updateUserInfoViewWith:(HSLoginUser *)loginUser;

- (void)updatePortrait:(UIImage *)image;

@end
