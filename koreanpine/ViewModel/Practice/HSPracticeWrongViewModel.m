//
//  HSPracticeWrongViewModel.m
//  koreanpine
//
//  Created by 陶山强 on 15/11/5.
//  Copyright © 2015年 Christ. All rights reserved.
//

#import "HSPracticeWrongViewModel.h"
#import "HSLoginMgr.h"
#import "NetworkCenter.h"
#import "HSLectureModel.h"
#import "HSDoHomeworkViewModel.h"
#import "HSQuestionModel.h"
@interface HSPracticeWrongViewModel ()

@property (strong, nonatomic) NSMutableArray *wrongQuestionArr;

@end

@implementation HSPracticeWrongViewModel
- (instancetype)init {
    if (!self) {
        self = [HSPracticeWrongViewModel shareExerciseViewModel];
    }
    return self;
}

+ (instancetype)shareExerciseViewModel {
    static HSPracticeWrongViewModel *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[HSPracticeWrongViewModel alloc] init];
    });
    return instance;
}

- (instancetype)initWithHomeworkModel:(HSLectureHomeworkModel *)homeworkModel {
    self = [HSPracticeWrongViewModel shareExerciseViewModel];
    if (self) {
        self.homeworkModel = homeworkModel;
        self.currentIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    }
    return self;
}
- (NSInteger)contentCount
{
    if (self.showAnswers&&self.showWrongQuestions) {
        return [self.wrongQuestionArr count];
    }
    return [super contentCount];
}

- (YH_Model *)contentAtIndex:(NSInteger)index
{
    if (self.showAnswers&&self.showWrongQuestions) {
        return self.wrongQuestionArr[index];
    }
    return [super contentAtIndex:index];
}

- (void)reDoExercise
{
    
    self.currentIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    self.showAnswers = NO;
    self.showWrongQuestions = NO;
    [self fetchLatest];
    //    for (HSDoHomeworkViewModel *doHomeworkVM in self.contents) {
    //        [doHomeworkVM.selectedIndexPaths removeAllObjects];
    //        doHomeworkVM.questionModel.userAnswer = @"";
    //    }
}

- (void)finishDoExercise
{
    self.currentIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    self.showAnswers = YES;
    self.showWrongQuestions = NO;
//    [self uploadAnswerResult];
}

- (void)viewWrongQuestions
{
    self.currentIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    self.showAnswers = YES;
    self.showWrongQuestions = YES;
    [self updateWrongQuestionArr];
}

- (void)viewAllQuestions
{
    self.currentIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    self.showAnswers = YES;
    self.showWrongQuestions = NO;
}

- (BOOL)canSwithToPreQuestion;
{
    BOOL canSwitch = ([self contentCount] > 0) && (self.currentIndexPath.row > 0);
    return canSwitch;
}

- (BOOL)canSwithToNextQuestion
{
    BOOL canSwitch = ([self contentCount] > 0) && (self.currentIndexPath.row < self.contentCount -1);
    return canSwitch;
}

- (void)switchToPreQuestion
{
    if (![self canSwithToPreQuestion]) { return; }
    NSInteger section = [self.currentIndexPath section];
    NSInteger row = [self.currentIndexPath row];
    row --;
    self.currentIndexPath = [NSIndexPath indexPathForRow:row inSection:section];
}

- (void)switchToNextQuestion
{
    if (![self canSwithToNextQuestion]) { return; }
    NSInteger section = [self.currentIndexPath section];
    NSInteger row = [self.currentIndexPath row];
    row ++;
    self.currentIndexPath = [NSIndexPath indexPathForRow:row inSection:section];
    
}

- (NSMutableArray *)wrongQuestionArr
{
    if (!_wrongQuestionArr) {
        _wrongQuestionArr = [NSMutableArray array];
    }
    return _wrongQuestionArr;
}

//更新错题的内容
- (void)updateWrongQuestionArr
{
    [self.wrongQuestionArr removeAllObjects];
    for (HSDoHomeworkViewModel *doHomeworkVM in self.contents) {
        if (doHomeworkVM.questionModel.quesType == HSQuesTypeJudge) {
            BOOL isAnswerRight = (doHomeworkVM.userJudgeType == doHomeworkVM.answerJudgeType);
            if (!isAnswerRight) {
                [self.wrongQuestionArr addObject:doHomeworkVM];
            }
        }
        BOOL isAnswerRight = [doHomeworkVM.questionModel.answer isEqualToString:doHomeworkVM.questionModel.userAnswer];
        if (!isAnswerRight) {
            [self.wrongQuestionArr addObject:doHomeworkVM];
        }
    }
}

- (void)fetchItemsAtPage:(YH_Page *)page succeededHandler:(void (^)(NSInteger, NSArray *))succeededHandler failedHandler:(void (^)(NSError *))failedHandler
{
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
    [parameter setObject:@(page.currentPage) forKey:@"pageNum"];
    [parameter setObject:@(page.pageSize) forKey:@"pageSize"];
//    [parameter setObject:kVERSIONCODE forKey:@"versionCode"];
    
//    HSCompanyModel *companyModel = [HSLoginMgr loginMgr].loginUser.companyModel;
//    if (companyModel.companyUUID.length > 0) {
//        [parameter setObject:companyModel.companyUUID forKey:@"uuid"];
//    }
    if ([HSLoginMgr loginMgr].loginUser.userId.length > 0) {
        [parameter setObject:[HSLoginMgr loginMgr].loginUser.userId forKey:@"userId"];
    }
//    /com/ctrl/practiceV1_5/queryPracticeWrong
//获取错题列表接口
    [[EPHttpClient sharedClient] POST:@"com/ctrl/practiceV1_5/queryPracticeWrong" parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //data
        NSDictionary *dict = responseObject[@"data"];
        NSArray *lectureListArr = dict[@"data"];
        //              NSLog(@"111%@",dict);
        //courseList
        NSMutableArray *practiceModels = [NSMutableArray array];
        BOOL isarray = IsArrayClass(lectureListArr);
        if (isarray) {
           
            for (NSDictionary *dict in lectureListArr) {
                HSQuestionModel *questionModel = [[HSQuestionModel alloc] initWithDict:dict];
                if ((questionModel.userAnswer.length > 0)&&!self.showAnswers) {
                    self.showAnswers = YES;
                }
                HSDoHomeworkViewModel *doHomeworkViewModel = [[HSDoHomeworkViewModel alloc] initWithQuestionModel:questionModel];
                [practiceModels addObject:doHomeworkViewModel];

            }
            
       
            if (succeededHandler) {
                succeededHandler(practiceModels.count,practiceModels);
            
            }
        } else {
            NSError *error = [NSError errorWithDomain:@"错误的数据" code:-1 userInfo:@{NSLocalizedDescriptionKey:@"数据格式错误"}];
            if (failedHandler) {
                failedHandler(error);
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failedHandler) {
            NSLog(@"%@",error);
            failedHandler(error);
        }
    }];
}

@end
