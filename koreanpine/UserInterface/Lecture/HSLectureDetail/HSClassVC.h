//
//  HSLectureDetailContainerVC.h
//  koreanpine
//
//  Created by Christ on 15/8/15.
//  Copyright (c) 2015年 Christ. All rights reserved.
//

#import "HSBaseVC.h"
#import "HSLectureDetailVC.h"
#import "HSLectureModel.h"
#import "HSLectureClassModel.h"

@protocol HSContainerVCInterface <NSObject>

- (void)willEnterBackgroundDisplay;

- (void)willEnterForegroundDisplay;


- (void)willDisplayContainerView;

- (void)endDisplayContainerView;

@end

@interface HSClassVC : HSBaseVC
<HSContainerVCInterface>

@property (weak ,nonatomic) HSLectureDetailVC *mainVC;

- (void)updateVCWithLecutreModel:(HSLectureModel *)lectureModel  classModel:(HSLectureClassModel *)lectureClassModel;



@end
