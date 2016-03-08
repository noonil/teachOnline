//
//  HSTimerLabel.m
//  YH_BubbleViewTest
//
//  Created by Christ on 15/8/21.
//  Copyright (c) 2015年 Christ. All rights reserved.
//

#import "HSTimerLabel.h"

@interface HSTimerLabel ()

@property (strong, nonatomic) NSTimer *timer;

@end

@implementation HSTimerLabel

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}

- (void)timerTrigger
{
    self.timeInterval ++;
    NSInteger secondValue = self.timeInterval%60;
    NSInteger minuteValue = (self.timeInterval/60)%60;
    NSInteger hourValue = (self.timeInterval/3600);
    NSString *timeStr = [NSString stringWithFormat:@"%02ld:%02ld:%02ld",(long)hourValue,(long)minuteValue,(long)secondValue];
    [self setText:timeStr];
}

- (void)startTimer
{
    self.timeInterval = 0;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerTrigger) userInfo:nil repeats:YES];
    [self.timer fire];
}

- (void)countinueTimer
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerTrigger) userInfo:nil repeats:YES];
}

- (void)pauseTimer
{
    [self.timer invalidate];
}

- (void)stopTimer
{
    [self.timer invalidate];
    self.timeInterval = 0;
}

@end
