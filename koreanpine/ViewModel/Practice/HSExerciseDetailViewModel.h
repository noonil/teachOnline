//
//  HSExerciseDetailViewModel.h
//  koreanpine
//
//  Created by Victor on 15/10/20.
//  Copyright © 2015年 Christ. All rights reserved.
//

#import "YH_ArrayDataMgr.h"

@class HSLectureHomeworkModel;
@interface HSExerciseDetailViewModel : YH_ArrayDataMgr
- (instancetype)initWithHomeworkModel:(HSLectureHomeworkModel *)homeworkModel;

@property (strong, nonatomic) HSLectureHomeworkModel *homeworkModel;
@property (strong, nonatomic) NSIndexPath *currentIndexPath;

@property (assign, nonatomic) BOOL showAnswers;

@property (assign, nonatomic) BOOL showWrongQuestions;

@property (assign, nonatomic) NSUInteger testTime;
@property (nonatomic,copy) NSString *practiceId;
/**
 *  重做作业
 */
- (void)reDoExercise;
/**
 *  结束重做作业
 */
- (void)finishDoExercise;
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
