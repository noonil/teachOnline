//
//  HSLectureDetailContainerCell.h
//  koreanpine
//
//  Created by Christ on 15/8/15.
//  Copyright (c) 2015年 Christ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HSClassVC,HSLectureModel,HSLectureClassModel;
@interface HSClassContainerCell : UICollectionViewCell

@property (strong, nonatomic) HSClassVC *classContainerVC;

//@property (strong, nonatomic) HSLectureModel *lectureModel;
//@property (strong, nonatomic) HSLectureClassModel *lectureClassModel;

- (void)updateCellWithLecutreModel:(HSLectureModel *)lectureModel  classModel:(HSLectureClassModel *)lectureClassModel;

- (void)willDisplayCell;

- (void)endDisplayCell;


@end
