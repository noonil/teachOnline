//
//  HSLectureTopCell.m
//  koreanpine
//
//  Created by Christ on 15/8/15.
//  Copyright (c) 2015年 Christ. All rights reserved.
//

#import "HSLectureTopCell.h"
#import "UIImageView+WebCache.h"

@implementation HSLectureTopCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)awakeFromNib
{
    [self initView];
}

- (void)initView
{
    [self.contentView setBackgroundColor:[UIColor whiteColor]];
    
    self.bubbleView = [[HSBubbleView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.contentView.bounds), 180.0f*kScreenPointScale)];
    [self.bubbleView setClipsToBounds:YES];
    [self.bubbleView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [self.contentView addSubview:self.bubbleView];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetHeight(self.contentView.bounds)-30, CGRectGetWidth(self.contentView.bounds)-80.0f, 30.0f)];
    [self.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
    [self.titleLabel setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin];
    [self.contentView addSubview:self.titleLabel];
    
    self.graspView = [[HSGraspProgress alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.contentView.bounds)-70.0f, CGRectGetHeight(self.contentView.bounds)-30.0f, 30.0f, 30.0f)];
    [self.graspView setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin];
    [self.contentView addSubview:self.graspView];
    
    self.graspStateLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.contentView.bounds)-40.0f, 0, 35, 15)];
    [self.graspStateLabel setCenter:CGPointMake(CGRectGetMidX(self.graspStateLabel.frame), CGRectGetMidY(self.graspView.frame))];
    [self.graspStateLabel setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin];
    [self.graspStateLabel setFont:[UIFont systemFontOfSize:11.0f]];
    [self.graspStateLabel setTextColor:[UIColor lightGrayColor]];
    [self.contentView addSubview:self.graspStateLabel];
    
    self.lectureNewFlag = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.contentView.bounds)-30.0f, 0, 30, 30.0f)];
    [self.lectureNewFlag setImage:[UIImage imageNamed:@"u97"]];
    [self.lectureNewFlag setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin];
    [self.contentView addSubview:self.lectureNewFlag];
}

- (void)updateCellWith:(HSLectureModel *)lectureModel
{
    self.lectureModel = lectureModel;
    
    [self.lectureNewFlag setHidden:!self.lectureModel.isNew];
    [self.bubbleView updateImageWithUrl:self.lectureModel.lectureImageUrl];
    
    [self.titleLabel setText:lectureModel.lectureName];
    [self.graspView setGraspState:self.lectureModel.graspState];
    
    NSArray *graspStateTitles = @[@"未掌握",@"掌握中",@"已掌握"];
    [self.graspStateLabel setText:graspStateTitles[self.lectureModel.graspState]];
}
@end
