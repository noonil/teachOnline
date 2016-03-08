//
//  YH_PageControl.h
//  YH_Mall
//
//  Created by 葛祥通 on 14-9-25.
//  Copyright (c) 2014年 YOHO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSPageControl : UIPageControl

/*!
 未选中时候的dot的图片。
 */
@property(nonatomic,strong) UIImage *imageNormal;
/*!
 选中时候的dot的图片。
 */
@property(nonatomic,strong) UIImage *imageSelected;

@end
