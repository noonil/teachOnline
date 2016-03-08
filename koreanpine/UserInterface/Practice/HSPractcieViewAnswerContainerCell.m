//
//  HSPractcieViewAnswerContainerCell.m
//  koreanpine
//
//  Created by 陶山强 on 15/11/9.
//  Copyright © 2015年 Christ. All rights reserved.
//

#import "HSPractcieViewAnswerContainerCell.h"
@implementation HSPractcieViewAnswerContainerCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initCell];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initCell];
    }
    return self;
}

- (void)initCell
{
    self.practiceViewAnswerVC = [[HSPracticeViewAnswerVC alloc] init];
    [self.practiceViewAnswerVC.view setFrame:self.contentView.bounds];
    [self.practiceViewAnswerVC.view setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    [self.contentView addSubview:self.practiceViewAnswerVC.view];
}


@end
