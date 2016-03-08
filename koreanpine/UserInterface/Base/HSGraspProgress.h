//
//  HSGraspProgress.h
//  koreanpine
//
//  Created by Christ on 15/7/22.
//  Copyright (c) 2015年 Christ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, HSGraspState)
{
    HSGraspStateNone = 0,
    HSGraspStateOn,
    HSGraspStateFinish
};

@interface HSGraspProgress : UIView

@property (assign, nonatomic) HSGraspState graspState;

- (void)setSelected:(BOOL)selected animated:(BOOL)animated;

@end
