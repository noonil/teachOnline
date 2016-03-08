//
//  HSTabbar.h
//  koreanpine
//
//  Created by Christ on 15/7/25.
//  Copyright (c) 2015年 Christ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HSTabbar;

@protocol HSTabbarDelegate <NSObject>

- (void)tabbar:(HSTabbar *)tabbar didSelectedIndex:(NSUInteger)selectIndex;

@end

@interface HSTabbar : UIView

@property (weak, nonatomic) id<HSTabbarDelegate> delegate;

@property (assign, nonatomic) NSUInteger selectedIndex;

@end
