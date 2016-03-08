//
//  HSLectureChapterHeader.h
//  koreanpine
//
//  Created by Christ on 15/8/4.
//  Copyright (c) 2015年 Christ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSGraspProgress.h"
#import "HSLectureStageModel.h"

@class HSLectureChapterHeader;

@protocol HSLectureChapterHeaderDelegate <NSObject>

- (void)lectureChapterHeaderDidTapped:(HSLectureChapterHeader *)lectureChapterHeader;

@end

@interface HSLectureChapterHeader : UITableViewHeaderFooterView

@property (strong, nonatomic) UIImageView *indicatorImageView;

@property (strong, nonatomic) UILabel *titleLabel;

@property (strong, nonatomic) HSGraspProgress *graspView;

@property (strong, nonatomic) HSLectureStageModel *lectureStageModel;

@property (weak, nonatomic) id<HSLectureChapterHeaderDelegate> delegate;

- (void)updateCellWithStageModel:(HSLectureStageModel *)stageModel;

@end
