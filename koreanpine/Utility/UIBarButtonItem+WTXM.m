//
//  UIBarButtonItem+WTXM.m
//  WTXMMicroblog
//
//  Created by 王涛 on 15/1/1.
//  Copyright (c) 2015年 王涛. All rights reserved.
//

#import "UIBarButtonItem+WTXM.h"

@implementation UIBarButtonItem (WTXM)
+(instancetype)itemWithImageName:(NSString *)imageName target:(id)target action:(SEL)action {
    UIButton *btn=[[UIButton alloc] init];
    [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    NSString *imageNameHighlighted=[NSString stringWithFormat:@"%@_highlighted",imageName];
    [btn setImage:[UIImage imageNamed:imageNameHighlighted] forState:UIControlStateHighlighted];
    [btn sizeToFit];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
}
+(instancetype)itemWithImageName:(NSString *)imageName Title:(NSString *)title target:(id)target action:(SEL)action {
    UIButton *btn=[[UIButton alloc] init];
    [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    NSString *imageNameHighlighted=[NSString stringWithFormat:@"%@_highlighted",imageName];
    [btn setImage:[UIImage imageNamed:imageNameHighlighted] forState:UIControlStateHighlighted];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor orangeColor] forState:UIControlStateHighlighted];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn sizeToFit];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
}
+(instancetype)itemWithTitle:(NSString *)title target:(id)target action:(SEL)action {
    UIButton *btn=[[UIButton alloc] init];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [btn setTitleColor:[UIColor orangeColor] forState:UIControlStateHighlighted];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn sizeToFit];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
}
@end
