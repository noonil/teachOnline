//
//  HSMineLectureCell.h
//  koreanpine
//
//  Created by Christ on 15/7/25.
//  Copyright (c) 2015年 Christ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSMineLectureModel.h"
#import "HSGraspProgress.h"

@interface HSMineLectureCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *lectureImageView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

@property (weak, nonatomic) IBOutlet HSGraspProgress *graspView;

@property (weak, nonatomic) IBOutlet UILabel *graspStateLabel;

@property (weak, nonatomic) HSMineLectureModel *lectureModel;


//判断添加new和hot的图片
@property(nonatomic,strong)UIImageView *isNewImage;

@property(nonatomic,assign)BOOL isNew;

@property(nonatomic,strong)UIImageView *isHotImage;

@property(nonatomic,strong)UIImageView *isNewImage_2;

@property(nonatomic,assign)BOOL isHot;

@property(strong,nonatomic)UIImageView *bearImage;


- (void)updateCellWith:(HSMineLectureModel *)lectureModel;


@end
