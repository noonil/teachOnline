//
//  HSPracticeWrongViewModel.h
//  koreanpine
//
//  Created by 陶山强 on 15/11/5.
//  Copyright © 2015年 Christ. All rights reserved.
//

#import "HSHomeworkDetailViewModel.h"
#import "HSPracticeWrongModel.h"
@class HSLectureHomeworkModel;
@interface HSPracticeWrongViewModel : YH_ArrayDataMgr
@property(nonatomic,strong) HSPracticeWrongModel *practiceWrongModel;

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
- (void)fetchItemsAtPage:(YH_Page *)page succeededHandler:(void (^)(NSInteger, NSArray *))succeededHandler failedHandler:(void (^)(NSError *))failedHandler;

@end
