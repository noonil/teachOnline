//
//  HSLectureDetailViewModel.m
//  koreanpine
//
//  Created by Christ on 15/7/28.
//  Copyright (c) 2015年 Christ. All rights reserved.
//

#import "HSLectureDetailViewModel.h"
//#import "HSLectureModel.h"
#import "HSLoginMgr.h"
#import "HSLectureStageModel.h"
#import "HSClassVC.h"
@interface HSLectureDetailViewModel ()

@property (strong, readwrite, nonatomic) NSArray *stageList;

@end

@implementation HSLectureDetailViewModel

- (instancetype)initWithHSLectureModel:(HSLectureModel *)lectureModel
{
    self = [super init];
    if (self) {
        self.lectureModel = lectureModel;
        self.currentLectureIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    }
    return self;
}

- (NSInteger)totalLectureCount
{
    NSInteger totalCount = 0;
    for (HSLectureStageModel *stageModel in self.stageList) {
        totalCount += [stageModel.lectureClassArr count];
    }
    return totalCount;
}

- (NSMutableDictionary *)graspStateDict
{
    if (!_graspStateDict) {
        _graspStateDict = [[NSMutableDictionary alloc] init];
    }
    return _graspStateDict;
}

//studyHis/addStudyCourseRecord

- (void)addCourseStudyHistoryWithSucceededBlock:(void(^)(NSArray *stagItems))succeededBlock failedBlock:(HSNetworkFailedBlock)failedBlock
{
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
    [parameter setObject:kVERSIONCODE forKey:@"versionCode"];
    
    HSCompanyModel *companyModel = [HSLoginMgr loginMgr].loginUser.companyModel;
    if (companyModel.companyUUID.length > 0) {
        [parameter setObject:companyModel.companyUUID forKey:@"uuid"];
    }
    if ([HSLoginMgr loginMgr].loginUser.userId.length > 0) {
        [parameter setObject:[HSLoginMgr loginMgr].loginUser.userId forKey:@"userId"];
    }
    if (self.lectureModel.lectureID) {
        [parameter setObject:self.lectureModel.lectureID forKey:@"courseId"];
    }
   //用户课程学习记录接口
    [[EPHttpClient sharedClient] POST:@"com/studyHis/addStudyCourseRecord" parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

    }];
}

- (void)getCouserStageWithSucceededBlock:(void(^)(NSArray *stagItems))succeededBlock failedBlock:(HSNetworkFailedBlock)failedBlock
{
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
    [parameter setObject:kVERSIONCODE forKey:@"versionCode"];
    
    HSCompanyModel *companyModel = [HSLoginMgr loginMgr].loginUser.companyModel;
    if (companyModel.companyUUID.length > 0) {
        [parameter setObject:companyModel.companyUUID forKey:@"uuid"];
    }
    if ([HSLoginMgr loginMgr].loginUser.userId.length > 0) {
        [parameter setObject:[HSLoginMgr loginMgr].loginUser.userId forKey:@"userId"];
    }
    if (self.lectureModel.lectureID > 0) {
        [parameter setObject:self.lectureModel.lectureID forKey:@"courseId"];
    }
    
    
    
    __weak typeof(self) weakSelf = self;
    //课程阶段目录列表接口
    [[EPHttpClient sharedClient] POST:@"com/courseStage/selectCourseStage" parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"responeObject %@",responseObject);
        NSArray *stageArr = responseObject[@"data"];
        if (IsArrayClass(stageArr)) {
            NSMutableArray *stagItems = [NSMutableArray array];
             NSMutableArray *houseworkIds = [NSMutableArray array];
//            NSMutableArray *pdfIds
            for (NSDictionary *stageDict in stageArr) {
                HSLectureStageModel *stageItem = [[HSLectureStageModel alloc] initWithDict:stageDict];
                [stageItem setValue:responseObject[@"classhourCount"] forKey:@"classhourCount"];
                [stageItem setValue:responseObject[@"homeworkCount"] forKey:@"homeworkCount"];
                for (id homeworkItem in stageItem.lectureClassArr) {
                    
                    if ([homeworkItem isKindOfClass:[HSLectureHomeworkModel class]]) {
                     HSLectureHomeworkModel *item = (HSLectureHomeworkModel *)homeworkItem;
                        item.isHs = weakSelf.lectureModel.isHs;
                         [houseworkIds addObject:item.homeworkId];
                    }
                        else if([homeworkItem isKindOfClass:[HSLecturePDFModel class]]) {
                      HSLecturePDFModel *item = (HSLecturePDFModel *)homeworkItem;
                             item.isHs = weakSelf.lectureModel.isHs;
//
                        }else {
                            HSLectureClassModel *item = (HSLectureClassModel *)homeworkItem;
                            item.isHs = weakSelf.lectureModel.isHs;
                        }
                }
                
                [stagItems addObject:stageItem];
            }
            [self getHouseworkGraspStateWithHouseIds:houseworkIds];
            weakSelf.stageList = stagItems;
            if (succeededBlock) {
                succeededBlock(weakSelf.stageList);
            }
        } else {
            NSError *error = [NSError errorWithDomain:@"错误的数据" code:-1 userInfo:@{NSLocalizedDescriptionKey:@"数据格式错误"}];
            if (failedBlock) {
                failedBlock(error);
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failedBlock) {
            NSError *error = [NSError errorWithDomain:@"错误的数据" code:-1 userInfo:@{NSLocalizedDescriptionKey:@"加载失败，请检查网络状态！"}];
            failedBlock(error);
        }
    }];
}

- (void)getHouseworkGraspStateWithHouseIds:(NSMutableArray *)houseworkIds
{
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
    [parameter setObject:kVERSIONCODE forKey:@"versionCode"];
    NSString *houseIdValue = [houseworkIds componentsJoinedByString:@","];
    [parameter setObject:houseIdValue forKey:@"homeWorkIds"];
    HSCompanyModel *companyModel = [HSLoginMgr loginMgr].loginUser.companyModel;
    if (companyModel.companyUUID.length > 0) {
        [parameter setObject:companyModel.companyUUID forKey:@"uuid"];
    }
    if ([HSLoginMgr loginMgr].loginUser.userId.length > 0) {
        [parameter setObject:[HSLoginMgr loginMgr].loginUser.userId forKey:@"userId"];
    }
    //作业掌握度接口
    [[EPHttpClient sharedClient] POST:@"com/courseWare/getHomeWorkMaster" parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *dataArr = responseObject[@"data"];
        for (NSDictionary *graspItem in dataArr) {
            NSString *key = [graspItem stringForKey:@"homeWorkId"];
            NSString *value = [graspItem stringForKey:@"masterVal"];
            if (key&&value) {
                [self.graspStateDict setObject:value forKey:key];

            }
        }
        
        [self updateHomeworkGraspState];
        if([self.delegate respondsToSelector:@selector(lectureDetailViewModelDidupdate)]){
            [self.delegate  lectureDetailViewModelDidupdate];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];

}
- (void)getLectureViewPathWithSucceededBlock:(void (^)(NSString *))succeededBlock failedBlock:(HSNetworkFailedBlock)failedBlock {
    
}
- (void)updateHomeworkGraspState
{
    HSLectureHomeworkModel *homeworkModel = [[HSLectureHomeworkModel alloc] init];
    for (HSLectureStageModel *stageItem in self.stageList) {
        
        for (HSLectureHomeworkModel *homeworkItem in stageItem.lectureClassArr) {
            if ([homeworkItem isKindOfClass:[HSLectureHomeworkModel class]]) {
                NSString *graspValueStr = self.graspStateDict[homeworkItem.homeworkId];
                if (graspValueStr) {
                    CGFloat graspValue = [graspValueStr floatValue];
                    if (graspValue == 0.0) {
                        homeworkItem.graspState = HSGraspStateNone;
                        homeworkItem.masterDegree = graspValue;
                    } else if(graspValue == 100.0) {
                        homeworkItem.graspState = HSGraspStateFinish;
                        homeworkItem.masterDegree = graspValue;
                    } else {
                        homeworkItem.graspState = HSGraspStateOn;
                        homeworkItem.masterDegree = graspValue;
                    }
                } else {
                    homeworkItem.graspState = HSGraspStateNone;
                }
                homeworkModel = homeworkItem;
            }
        }
    }
    
    if([self.delegate respondsToSelector:@selector(lectureDetailViewModelDidupdate)]){
        [self.delegate lectureDetailViewModelDidupdate];
    }
}

- (void)setCurrentLectureIndexPath:(NSIndexPath *)currentLectureIndexPath
{
    _currentLectureIndexPath = currentLectureIndexPath;
    if (self.stageList.count > _currentLectureIndexPath.section) {
        HSLectureStageModel *stageItem = (HSLectureStageModel *)self.stageList[_currentLectureIndexPath.section];
        stageItem.hasExpand = YES;
    }
}


- (BOOL)canSwithToPreLecture
{
    NSInteger section = [self.currentLectureIndexPath section];
    NSInteger row = [self.currentLectureIndexPath row];
    BOOL canSwith = YES;
    if (self.stageList.count < (section + 1)) {
        canSwith = NO;
    } else if(section + row == 0) {
        canSwith = NO;
    }
    return canSwith;
}

- (BOOL)canSwithToNextLecture
{
    NSInteger section = [self.currentLectureIndexPath section];
    NSInteger row = [self.currentLectureIndexPath row];
    BOOL canSwith = YES;
    if (self.stageList.count < (section + 1)) {
        canSwith = NO;
    } else if(section == self.stageList.count - 1) {
        HSLectureStageModel *stageModel = self.stageList[section];
        if (row == stageModel.lectureClassArr.count - 1) {
            canSwith = NO;
        }
    }
    return canSwith;
}

- (void)switchToPreLecture
{
    
    if (![self canSwithToPreLecture]) { return; }
    
    NSInteger section = [self.currentLectureIndexPath section];
    NSInteger row = [self.currentLectureIndexPath row];

    if (self.currentLectureIndexPath.row > 0) {
        --row;
    } else {
        --section;
        HSLectureStageModel *stageModel = self.stageList[section];
        row = stageModel.lectureClassArr.count-1;
    }
    self.currentLectureIndexPath = [NSIndexPath indexPathForRow:row inSection:section];
    NSLog(@"%@",self.currentLectureIndexPath);
}

- (void)switchToNextLecture
{
    if (![self canSwithToNextLecture]) { return; }
    NSInteger section = 0;
    NSInteger row = 0;
    section = [self.currentLectureIndexPath section];
    row = [self.currentLectureIndexPath row];
    
    HSLectureStageModel *stageModel = self.stageList[section];
    if (row == stageModel.lectureClassArr.count -1) {
        ++section;
        row = 0;
    } else {
        
        ++row;
    }
    self.currentLectureIndexPath = [NSIndexPath indexPathForRow:row inSection:section];
//    NSLog(@"%@",self.currentLectureIndexPath);
}

@end
