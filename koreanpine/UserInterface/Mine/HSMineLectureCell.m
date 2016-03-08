//
//  HSMineLectureCell.m
//  koreanpine
//
//  Created by Christ on 15/7/25.
//  Copyright (c) 2015年 Christ. All rights reserved.
//

#import "HSMineLectureCell.h"
#import "UIImageView+WebCache.h"

@implementation HSMineLectureCell

- (void)awakeFromNib {
    // Initialization code
    [self initView];
}

- (void)initView
{
    
    self.bearImage = [[UIImageView alloc]initWithImage: [UIImage imageNamed:@"bear"]];
    [self.bearImage setFrame:CGRectMake(5, 5, 17, 19)];
    self.bearImage.backgroundColor = [UIColor clearColor];
    [self.lectureImageView addSubview:self.bearImage];
    
    self.isHotImage = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.lectureImageView.bounds)-15, 0, 15, 15)];
    [self.isHotImage setImage:[UIImage imageNamed:@"hot"]];
    [self.isHotImage setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin];
    self.isHotImage.hidden = YES;
    [self.lectureImageView addSubview:self.isHotImage];
    
    self.isNewImage = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.lectureImageView.bounds)-15-15, 0,15, 15)];
    [self.isNewImage setImage:[UIImage imageNamed:@"new1"]];
    [self.isNewImage setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin];
    self.isNewImage.hidden = YES;
    [self.lectureImageView addSubview:self.isNewImage];
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    
}

- (void)updateCellWith:(HSMineLectureModel *)lectureModel
{
    self.lectureModel = lectureModel;
    
    [self.lectureImageView sd_setImageWithURL:[NSURL URLWithString:self.lectureModel.lectureImageUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
    if (!self.lectureModel.isHs) {
        self.bearImage.hidden = YES;
        
    }else{
        self.bearImage.hidden = NO;
    }
    
    self.isNewImage.hidden = YES;
    self.isHotImage.hidden = YES;
    self.isNewImage.hidden = !lectureModel.isNew;
    self.isHotImage.hidden = !lectureModel.isHot;
    if (!lectureModel.isHot && lectureModel.isNew) {
        self.isNewImage.frame = self.isHotImage.frame;
    }else {
        self.isNewImage.frame = CGRectMake(CGRectGetWidth(self.lectureImageView.bounds)-15-15, 0,15, 15);
    }
    
    [self.titleLabel setText:lectureModel.lectureName];
    [self.detailLabel setText:lectureModel.lectureDetail];
    if (!self.lectureModel.isHs && !self.lectureModel.isCollection) {
        [self.graspView setGraspState:self.lectureModel.graspState];
        NSArray *graspStateTitles = @[@"未掌握",@"掌握中",@"已掌握"];
        [self.graspStateLabel setText:graspStateTitles[self.lectureModel.graspState]];
    }else {
        self.graspStateLabel.text = @"";
    }
    
    
    
}

@end