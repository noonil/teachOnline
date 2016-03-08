//
//  HSTimerLabel.h
//  YH_BubbleViewTest
//
//  Created by Christ on 15/8/21.
//  Copyright (c) 2015年 Christ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSTimerLabel : UILabel

@property (assign, nonatomic) NSUInteger timeInterval;

- (void)startTimer;

- (void)countinueTimer;

- (void)pauseTimer;

- (void)stopTimer;

@end
