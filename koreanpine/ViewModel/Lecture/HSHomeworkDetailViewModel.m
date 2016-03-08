//
//  HSHomeworkDetailViewModel.m
//  koreanpine
//
//  Created by Christ on 15/8/18.
//  Copyright (c) 2015年 Christ. All rights reserved.
//

#import "HSHomeworkDetailViewModel.h"
#import "HSLoginMgr.h"
#import "NetworkCenter.h"
#import "HSLectureModel.h"
#import "HSDoHomeworkViewModel.h"
#import "HSQuestionModel.h"

@interface HSHomeworkDetailViewModel ()

@property (strong, nonatomic) NSMutableArray *wrongQuestionArr;

@end

@implementation HSHomeworkDetailViewModel

- (instancetype)initWithHomeworkModel:(HSLectureHomeworkModel *)homeworkModel
{
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

- (void)reDoHomework
{
    self.currentIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    self.showAnswers = NO;
    self.showWrongQuestions = NO;
    for (HSDoHomeworkViewModel *doHomeworkVM in self.contents) {
        [doHomeworkVM.selectedIndexPaths removeAllObjects];
        doHomeworkVM.questionModel.userAnswer = @"";
    }
}

- (void)finishDoHomework
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

- (void)uploadAnswerResult
{
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
    [parameter setObject:self.homeworkModel.homeworkId forKey:@"homeworkId"];
    [parameter setObject:kVERSIONCODE forKey:@"versionCode"];
    
    HSCompanyModel *companyModel = [HSLoginMgr loginMgr].loginUser.companyModel;
    if (companyModel.companyUUID.length > 0) {
        [parameter setObject:companyModel.companyUUID forKey:@"uuid"];
    }
    if ([HSLoginMgr loginMgr].loginUser.userId.length > 0) {
        [parameter setObject:[HSLoginMgr loginMgr].loginUser.userId forKey:@"userId"];
    }
    
    NSMutableArray *submitDicts = [NSMutableArray array];
    for (HSDoHomeworkViewModel *doHomeworkVM in self.contents) {
        [submitDicts addObject:doHomeworkVM.submitDict];
    }
    NSError *error = nil;
    NSData *submitData = [NSJSONSerialization dataWithJSONObject:submitDicts options:NSJSONWritingPrettyPrinted error:&error];
    if (submitData) {
        NSString *resultStr = [[NSString alloc] initWithData:submitData encoding:NSUTF8StringEncoding];
        [parameter setObject:resultStr forKey:@"data"];
    }
    
    __weak typeof(self) weakSelf = self;
    [[EPHttpClient sharedClient] POST:@"com/courseware/submitDetail" parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dataDict = (NSDictionary *)responseObject;
        BOOL success = [dataDict boolForKey:@"res"];
        if (success) {
            [weakSelf fetchLatest];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error.localizedDescription);
    }];
}

- (void)fetchItemsAtPage:(YH_Page *)page succeededHandler:(void (^)(NSInteger, NSArray *))succeededHandler failedHandler:(void (^)(NSError *))failedHandler
{
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
    [parameter setObject:self.homeworkModel.homeworkId forKey:@"homeworkId"];
    [parameter setObject:kVERSIONCODE forKey:@"versionCode"];
    
    HSCompanyModel *companyModel = [HSLoginMgr loginMgr].loginUser.companyModel;
    if (companyModel.companyUUID.length > 0) {
        [parameter setObject:companyModel.companyUUID forKey:@"uuid"];
    }
    if ([HSLoginMgr loginMgr].loginUser.userId.length > 0) {
        [parameter setObject:[HSLoginMgr loginMgr].loginUser.userId forKey:@"userId"];
    }
    
    [[EPHttpClient sharedClient] POST:@"com/courseware/viewHomework" parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dataDict = responseObject[@"data"];
        NSArray *questionList = dataDict[@"questionList"];
        NSMutableArray *doHomeworkArrs = [NSMutableArray array];
        
        if (IsArrayClass(questionList)) {
            for (NSDictionary *dict in questionList) {
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
