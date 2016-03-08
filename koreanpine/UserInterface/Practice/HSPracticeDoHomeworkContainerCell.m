//
//  HSPracticeDoHomeworkContainerCell.m
//  koreanpine
//
//  Created by 陶山强 on 15/11/9.
//  Copyright © 2015年 Christ. All rights reserved.
//

#import "HSPracticeDoHomeworkContainerCell.h"

@implementation HSPracticeDoHomeworkContainerCell

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
    self.practiceDoHomeWorkVC = [[HSPractcieDoHomeworkVC alloc] init];
    [self.practiceDoHomeWorkVC.view setFrame:self.contentView.bounds];
    [self.practiceDoHomeWorkVC.view setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    [self.contentView addSubview:self.practiceDoHomeWorkVC.view];
    
}

@end
