//
//  HSHomeworkDetailViewModel.h
//  koreanpine
//
//  Created by Christ on 15/8/18.
//  Copyright (c) 2015年 Christ. All rights reserved.
//

#import "YH_ArrayDataMgr.h"
#import "HSLectureClassModel.h"

@interface HSHomeworkDetailViewModel : YH_ArrayDataMgr

- (instancetype)initWithHomeworkModel:(HSLectureHomeworkModel *)homeworkModel;

@property (strong, nonatomic) HSLectureHomeworkModel *homeworkModel;

@property (strong, nonatomic) NSIndexPath *currentIndexPath;

@property (assign, nonatomic) BOOL showAnswers;

@property (assign, nonatomic) BOOL showWrongQuestions;

@property (assign, nonatomic) NSUInteger testTime;
/**
 *  重做作业
 */
- (void)reDoHomework;
/**
 *  结束重做作业
 */
- (void)finishDoHomework;
/**
 *  只看错题
 */
- (void)viewWrongQuestions;

- (void)viewAllQuestions;

- (BOOL)canSwithToPreQuestion;

- (BOOL)canSwithToNextQuestion;

- (void)switchToPreQuestion;

- (void)switchToNextQuestion;

@end
