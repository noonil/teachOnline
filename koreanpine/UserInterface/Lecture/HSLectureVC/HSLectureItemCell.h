//
//  HSLectureItemCell.h
//  koreanpine
//
//  Created by Christ on 15/7/22.
//  Copyright (c) 2015年 Christ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSGraspProgress.h"
#import "HSLectureModel.h"

@class HSLectureItemCell;

@protocol HSLectureItemCellDelegate <NSObject>

- (void)lectureItemCellDidFinishLoadImage:(HSLectureItemCell *)cell;

@end

@interface HSLectureItemCell : UICollectionViewCell
@property(strong,nonatomic)UIImageView *bearImage;

@property (strong, nonatomic) UIImageView *lectureNewFlag;

@property (strong, nonatomic) UIImageView *lectureImageView;

@property (strong, nonatomic) UILabel *titleLabel;

@property (strong, nonatomic) HSGraspProgress *graspView;

@property (strong, nonatomic) UILabel *graspStateLabel;

@property (weak, nonatomic) HSLectureModel *lectureModel;

@property(nonatomic,strong)UIImageView *isNewImage;

@property(nonatomic,assign)BOOL isNew;

@property(nonatomic,strong)UIImageView *isHotImage;

@property(nonatomic,strong)UIImageView *isNewImage_2;

@property(nonatomic,assign)BOOL isHot;
@property(nonatomic,assign)float i;
@property(nonatomic,assign)float j;
@property (weak, nonatomic) id<HSLectureItemCellDelegate> delegate;

@property(assign,nonatomic)BOOL isHide;

- (void)updateCellWith:(HSLectureModel *)lectureModel;

+ (CGSize)cellSizeWith:(HSLectureModel *)lectureModel;

@end
