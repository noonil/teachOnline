//
//  UIBarButtonItem+WTXM.h
//  WTXMMicroblog
//
//  Created by 王涛 on 15/1/1.
//  Copyright (c) 2015年 王涛. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (WTXM)
+(instancetype)itemWithImageName:(NSString *)imageName target:(id)target action:(SEL)action;
+(instancetype)itemWithImageName:(NSString *)imageName Title:(NSString *)title target:(id)target action:(SEL)action;
+(instancetype)itemWithTitle:(NSString *)title target:(id)target action:(SEL)action;

@end
