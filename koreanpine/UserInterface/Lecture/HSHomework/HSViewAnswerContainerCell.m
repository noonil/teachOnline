//
//  HSViewAnswerCell.m
//  koreanpine
//
//  Created by Christ on 15/8/18.
//  Copyright (c) 2015年 Christ. All rights reserved.
//

#import "HSViewAnswerContainerCell.h"

@implementation HSViewAnswerContainerCell

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
    self.viewAnswerVC = [[HSViewAnswerVC alloc] init];
    [self.viewAnswerVC.view setFrame:self.contentView.bounds];
    [self.viewAnswerVC.view setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    [self.contentView addSubview:self.viewAnswerVC.view];
}

@end
