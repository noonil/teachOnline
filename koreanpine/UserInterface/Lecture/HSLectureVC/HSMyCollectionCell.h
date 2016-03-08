//
//  HSMyCollectionCell.h
//  koreanpine
//
//  Created by 陶山强 on 15/10/28.
//  Copyright © 2015年 Christ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSMyCollectionModel.h"
#import "HSGraspProgress.h"
@class HSMyCollectionCell;
@protocol HSMyCollectionCellDelegate <NSObject>

- (void) checkmarkBtnTapped:(HSMyCollectionCell *)cell;
- (void) jumpToLectureView:(HSMyCollectionCell *)cell;
- (void) longPressGestureRecognizerActive:(HSMyCollectionCell *)cell;
@end
@interface HSMyCollectionCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *lectureImageView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *detailLabel;



@property (weak, nonatomic) HSMyCollectionModel *lectureModel;

//判断添加new和hot的图片
@property(nonatomic,strong)UIImageView *isNewImage;

@property(nonatomic,assign)BOOL isNew;

@property(nonatomic,strong)UIImageView *isHotImage;

@property(nonatomic,strong)UIImageView *isNewImage_2;

@property(nonatomic,assign)BOOL isHot;

@property(strong,nonatomic)UIImageView *bearImage;
- (void)updateCellWith:(HSMyCollectionModel *)lectureModel;
@property (strong, nonatomic) UIButton *checkmarkBtn;

@property (nonatomic,weak) id<HSMyCollectionCellDelegate> delegate;

@end
