//
//  HSExerciseDetailViewModel.m
//  koreanpine
//
//  Created by Victor on 15/10/20.
//  Copyright © 2015年 Christ. All rights reserved.
//

#import "HSExerciseDetailViewModel.h"
#import "HSLoginMgr.h"
#import "NetworkCenter.h"
#import "HSLectureModel.h"
#import "HSDoHomeworkViewModel.h"
#import "HSQuestionModel.h"
@interface HSExerciseDetailViewModel ()

@property (strong, nonatomic) NSMutableArray *wrongQuestionArr;

@end
@implementation HSExerciseDetailViewModel


- (instancetype)initWithHomeworkModel:(HSLectureHomeworkModel *)homeworkModel {
    self = [super init];
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
    [self uploadAnswerResult];
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

//上传答案
- (void)uploadAnswerResult
{
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
    [parameter setObject:self.practiceId forKey:@"id"];
//    [parameter setObject:kVERSIONCODE forKey:@"versionCode"];
    
//    HSCompanyModel *companyModel = [HSLoginMgr loginMgr].loginUser.companyModel;
//    if (companyModel.companyUUID.length > 0) {
//        [parameter setObject:companyModel.companyUUID forKey:@"uuid"];
//    }
    if ([HSLoginMgr loginMgr].loginUser.userId.length > 0) {
        [parameter setObject:[HSLoginMgr loginMgr].loginUser.userId forKey:@"userId"];
    }
    
    NSMutableArray *submitDicts = [NSMutableArray array];
    for (HSDoHomeworkViewModel *doHomeworkVM in self.contents) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:doHomeworkVM.submitDict[@"id"] forKey:@"quesId"];
        [dict setObject:doHomeworkVM.submitDict[@"userAnswer"] forKey:@"answer"];
        [submitDicts addObject:dict];
    }
    NSError *error = nil;
    NSData *submitData = [NSJSONSerialization dataWithJSONObject:submitDicts options:NSJSONWritingPrettyPrinted error:&error];
    if (submitData) {
        NSString *resultStr = [[NSString alloc] initWithData:submitData encoding:NSUTF8StringEncoding];
        [parameter setObject:resultStr forKey:@"answerList"];
    }
//    [parameter setObject:submitDicts forKey:@"answerList"];
//    __weak typeof(self) weakSelf = self;
    //com/ctrl/practiceV1_5/saveAnswerQues
    //com/courseware/submitDetail
    [[EPHttpClient sharedClient] POST:@"com/ctrl/practiceV1_5/commit" parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSDictionary *dataDict = (NSDictionary *)responseObject;
//        BOOL success = [dataDict boolForKey:@"res"];
//        if (success) {
//            [weakSelf fetchLatest];
//        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error.localizedDescription);
    }];
}

- (void)fetchItemsAtPage:(YH_Page *)page succeededHandler:(void (^)(NSInteger, NSArray *))succeededHandler failedHandler:(void (^)(NSError *))failedHandler
{
//    [[EPHttpClient sharedClient] POST:@"com/ctrl/practiceV1_5/getClassify" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSInteger res = [responseObject[@"res"] integerValue];
//        if (res == 1) {
//            NSArray *questionClassifiesArr = responseObject[@"data"];
//            for (NSArray *questionClassArr in questionClassifiesArr) {
//                
//            }
//        }
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        
//    }];
    
    
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
//    NSString *classifyIds = @"11,12,13,14,15";
//    [parameter setObject:classifyIds forKey:@"classifyIds"];
    [parameter setObject:kVERSIONCODE forKey:@"versionCode"];
    
//    HSCompanyModel *companyModel = [HSLoginMgr loginMgr].loginUser.companyModel;
//    if (companyModel.companyUUID.length > 0) {
//        [parameter setObject:companyModel.companyUUID forKey:@"uuid"];
//    }
    if ([HSLoginMgr loginMgr].loginUser.userId.length > 0) {
        [parameter setObject:[HSLoginMgr loginMgr].loginUser.userId forKey:@"userId"];
    }
    //开始练习接口 ： com/ctrl/practiceV1_5/beginPractice
    [[EPHttpClient sharedClient] POST:@"com/ctrl/practiceV1_5/beginPractice" parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *dataArr = responseObject[@"data"];
        NSDictionary *dict = dataArr[0];
        self.practiceId = dict[@"practiceId"];
        NSArray *eduQuestionList = dict[@"eduQuestionList"];
               NSMutableArray *doHomeworkArrs = [NSMutableArray array];
        if (IsArrayClass(eduQuestionList)) {
            for (NSDictionary *dict in eduQuestionList) {
                HSQuestionModel *questionModel = [[HSQuestionModel alloc] initWithDict:dict];
                if ((questionModel.userAnswer.length > 0)&&!self.showAnswers) {
                    self.showAnswers = YES;
                }
                HSDoHomeworkViewModel *doHomeworkViewModel = [[HSDoHomeworkViewModel alloc] initWithQuestionModel:questionModel];
                [doHomeworkArrs addObject:doHomeworkViewModel];
            }
        }
        succeededHandler(doHomeworkArrs.count,doHomeworkArrs);
        [self updateWrongQuestionArr];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failedHandler(error);
    }];
}

@end
