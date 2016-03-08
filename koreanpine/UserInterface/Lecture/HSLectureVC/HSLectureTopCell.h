//
//  HSLectureTopCell.h
//  koreanpine
//
//  Created by Christ on 15/8/15.
//  Copyright (c) 2015年 Christ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSGraspProgress.h"
#import "HSLectureModel.h"
#import "HSLectureItemCell.h"
#import "HSBubbleView.h"

@interface HSLectureTopCell : UICollectionViewCell

@property (strong, nonatomic) UIImageView *lectureNewFlag;

@property (strong, nonatomic) HSBubbleView *bubbleView;

@property (strong, nonatomic) UILabel *titleLabel;

@property (strong, nonatomic) HSGraspProgress *graspView;

@property (strong, nonatomic) UILabel *graspStateLabel;

@property (weak, nonatomic) HSLectureModel *lectureModel;

- (void)updateCellWith:(HSLectureModel *)lectureModel;

@end
