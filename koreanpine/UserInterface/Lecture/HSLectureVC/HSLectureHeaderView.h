//
//  HSLectureHeaderView.h
//  koreanpine
//
//  Created by Christ on 15/7/25.
//  Copyright (c) 2015年 Christ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSGraspProgress.h"
#import "HSLectureModel.h"
#import "HSLectureItemCell.h"
#import "HSBubbleView.h"

@interface HSLectureHeaderView : UICollectionReusableView
@property(strong,nonatomic)UIImageView *bearImage;

@property (strong, nonatomic) UIImageView *lectureNewFlag;

@property (strong, nonatomic) HSBubbleView *bubbleView;

@property (strong, nonatomic) UILabel *titleLabel;

@property (strong, nonatomic) HSGraspProgress *graspView;

@property (strong, nonatomic) UILabel *graspStateLabel;

@property(nonatomic,strong)UIImageView *isNewImage;

@property(nonatomic,assign)BOOL isNew;

@property(nonatomic,strong)UIImageView *isHotImage;

@property(nonatomic,strong)UIImageView *isNewImage_2;

@property(nonatomic,assign)BOOL isHot;

@property (weak, nonatomic) HSLectureModel *lectureModel;

@property (strong, nonatomic) UITapGestureRecognizer *singleTap;
@property(assign,nonatomic)BOOL isHide;
- (void)updateCellWith:(HSLectureModel *)lectureModel;

@end
