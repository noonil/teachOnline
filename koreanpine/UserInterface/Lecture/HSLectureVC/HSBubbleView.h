//
//  HSBubbleView.h
//  YH_BubbleViewTest
//
//  Created by Christ on 15/8/21.
//  Copyright (c) 2015年 Christ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSBubbleView : UIView

@property (strong, nonatomic) UIImageView *imageView;

- (void)updateImageWithUrl:(NSString *)imageUrl;

@end
