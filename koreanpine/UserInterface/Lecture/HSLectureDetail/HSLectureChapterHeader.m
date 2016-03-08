//
//  HSLectureChapterHeader.m
//  koreanpine
//
//  Created by Christ on 15/8/4.
//  Copyright (c) 2015年 Christ. All rights reserved.
//

#import "HSLectureChapterHeader.h"

@implementation HSLectureChapterHeader

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView
{
    self.indicatorImageView = [[UIImageView alloc] initWithFrame:CGRectMake(4, 0, 25, 25)];
    [self.indicatorImageView setCenter:CGPointMake(CGRectGetMidX(self.indicatorImageView.frame), CGRectGetMidY(self.contentView.bounds))];
    [self.indicatorImageView setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin];
    [self.indicatorImageView setImage:[UIImage imageNamed:@"收起"]];
    [self.indicatorImageView setHighlightedImage:[UIImage imageNamed:@"展开"]];
    [self.contentView addSubview:self.indicatorImageView];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(35, 10, CGRectGetWidth(self.contentView.bounds)-10, 20)];
    [self.titleLabel setFont:[UIFont systemFontOfSize:16.0f]];
    [self.titleLabel setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [self.contentView addSubview:self.titleLabel];
    
    self.graspView = [[HSGraspProgress alloc] initWithFrame:CGRectMake(0, 0, 30.0f, 30.0f)];
    [self.graspView setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin];
    [self.contentView addSubview:self.graspView];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapped:)];
    [singleTap setNumberOfTapsRequired:1];
    [singleTap setNumberOfTouchesRequired:1];
    [self.contentView addGestureRecognizer:singleTap];
}
-(void)layoutSubviews{
    [super layoutSubviews];
    self.titleLabel.frame = CGRectMake(35, 10, CGRectGetWidth(self.contentView.bounds)-35, 20);
}
- (void)updateCellWithStageModel:(HSLectureStageModel *)stageModel
{
    self.lectureStageModel = stageModel;
    [self.indicatorImageView setHighlighted:self.lectureStageModel.hasExpand];
    [self.titleLabel setText:self.lectureStageModel.stageName];
    [self.graspView setGraspState:HSGraspStateOn];
}

- (void)singleTapped:(UITapGestureRecognizer *)tap
{
    if ([self.delegate respondsToSelector:@selector(lectureChapterHeaderDidTapped:)]) {
        [self.delegate lectureChapterHeaderDidTapped:self];
    }
}


@end
