//
//  YH_GuangLaudBtn.h
//  YH_Mall
//
//  Created by Christ on 15/4/1.
//  Copyright (c) 2015年 YOHO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSTabbarBtn : UIButton

@property (strong, nonatomic) UIImageView *barImage;

@property (strong, nonatomic) UILabel *barTitleLabel;

- (void)setSelected:(BOOL)selected animated:(BOOL)animated;

@end
