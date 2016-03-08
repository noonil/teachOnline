//
//  HSUserInfoView.m
//  koreanpine
//
//  Created by Christ on 15/7/18.
//  Copyright (c) 2015年 Christ. All rights reserved.
//

#import "HSUserInfoView.h"
#import "UIImageView+WebCache.h"
#import "UIView+WTXM.h"
@interface HSUserInfoView ()
@property (nonatomic,assign) NSInteger appType;
@end
@implementation HSUserInfoView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)awakeFromNib
{
    [self initView];
}

- (void)initView
{
    self.headIcon = [[UIImageView alloc] initWithFrame:CGRectMake(20, 15, 70, 70)];
    [self.headIcon setUserInteractionEnabled:YES];
    [self.headIcon.layer setCornerRadius:3.0f];
    [self.headIcon.layer setMasksToBounds:YES];
    [self addSubview:self.headIcon];
    
    CGFloat gapValue = 10.0f;
    self.nickNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.headIcon.frame)+gapValue, CGRectGetMinY(self.headIcon.frame), 200, 20)];
    [self addSubview:self.nickNameLabel];
    
    self.companyNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.headIcon.frame)+gapValue, 40, 200, 20)];
    [self addSubview:self.companyNameLabel];
    
    self.phoneNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.headIcon.frame)+gapValue, 65, 200, 20)];
    [self.phoneNumLabel setTextColor:[UIColor grayColor]];
    [self addSubview:self.phoneNumLabel];
    if (self.appType == HSAppTypeHongSongPai) {
        self.companyNameLabel.hidden = YES;
        self.nickNameLabel.centerY += 10;
        self.phoneNumLabel.centerY -= 10;
    }
}

- (void)updateUserInfoViewWith:(HSLoginUser *)loginUser
{
    [self.headIcon sd_setImageWithURL:[NSURL URLWithString:loginUser.image] placeholderImage:[UIImage imageNamed:@"默认头像"]];
    [self.nickNameLabel setText:loginUser.userName];
    [self.companyNameLabel setText:loginUser.companyModel.companyName];
    [self.phoneNumLabel setText:loginUser.mobile];
}

- (void)updatePortrait:(UIImage *)image
{
    self.headIcon.image = image;
}
- (NSInteger)appType {
    if (!_appType) {
        _appType = kHSAPPTYPE;

    }
    return _appType;
}
@end
