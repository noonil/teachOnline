//
//  HSLectureHsViewModel.m
//  koreanpine
//
//  Created by 陶山强 on 15/10/21.
//  Copyright © 2015年 Christ. All rights reserved.
//

#import "HSLectureHsViewModel.h"
#import "HSLoginMgr.h"
#import "NetworkCenter.h"
#import "HSLectureModel.h"

@implementation HSLectureHsViewModel

- (void)fetchItemsAtPage:(YH_Page *)page succeededHandler:(void (^)(NSInteger, NSArray *))succeededHandler failedHandler:(void (^)(NSError *))failedHandler
{
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
    [parameter setObject:@(page.currentPage) forKey:@"pageNum"];
    [parameter setObject:@(page.pageSize) forKey:@"pageSize"];
    [parameter setObject:kVERSIONCODE forKey:@"versionCode"];
    
    HSCompanyModel *companyModel = [HSLoginMgr loginMgr].loginUser.companyModel;
    if (companyModel.companyUUID.length > 0) {
        [parameter setObject:companyModel.companyUUID forKey:@"uuid"];
    }
    if ([HSLoginMgr loginMgr].loginUser.userId.length > 0) {
        [parameter setObject:[HSLoginMgr loginMgr].loginUser.userId forKey:@"userId"];
    }
    
    WS(weakSelf);
    //http://localhost:8080/HsMobile/com/ctrl/course/orgCourseList
    //com/courseV1_4/orgCourseList
    //    @"com/courseV1_4/hsCourseList
    [[EPHttpClient sharedClient] POST:@"com/courseV1_4/hsCourseList" parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //data
        NSDictionary *dict = responseObject[@"data"];
        NSArray *lectureListArr = dict[@"courseList"];
        //courseList
//        NSLog(@"%@",responseObject);
        NSMutableArray *lectureModels = [NSMutableArray array];
        if (IsArrayClass(lectureListArr)) {
            NSMutableArray *courseIdArr = [NSMutableArray array];
            for (NSDictionary *lectureDict in lectureListArr) {
                HSLectureModel *lectureModel = [[HSLectureModel alloc] initWithDict:lectureDict];
                [lectureModels addObject:lectureModel];
                [courseIdArr addObject:lectureModel.lectureID];
            }
            
            [weakSelf getGraspStateInfoWithCourseIds:courseIdArr];
            if (succeededHandler) {
                succeededHandler(lectureModels.count,lectureModels);
            }
        } else {
            NSError *error = [NSError errorWithDomain:@"错误的数据" code:-1 userInfo:@{NSLocalizedDescriptionKey:@"数据格式错误"}];
            if (failedHandler) {
                failedHandler(error);
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failedHandler) {
//            NSLog(@"%@",error);
            failedHandler(error);
        }
    }];
}

- (NSMutableDictionary *)graspStateDict
{
    if (!_graspStateDict) {
        _graspStateDict = [[NSMutableDictionary alloc] init];
    }
    return _graspStateDict;
}

- (void)getGraspStateInfoWithCourseIds:(NSMutableArray *)courseIds
{
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
    [parameter setObject:@(self.pageMgr.currentPage) forKey:@"pageNum"];
    [parameter setObject:@(self.pageMgr.pageSize) forKey:@"pageSize"];
    [parameter setObject:kVERSIONCODE forKey:@"versionCode"];
    NSString *courseIdValue = [courseIds componentsJoinedByString:@","];
    [parameter setObject:courseIdValue forKey:@"courseIds"];
    HSCompanyModel *companyModel = [HSLoginMgr loginMgr].loginUser.companyModel;
    if (companyModel.companyUUID.length > 0) {
        [parameter setObject:companyModel.companyUUID forKey:@"uuid"];
    }
    if ([HSLoginMgr loginMgr].loginUser.userId.length > 0) {
        [parameter setObject:[HSLoginMgr loginMgr].loginUser.userId forKey:@"userId"];
    }
    
    WS(weakSelf);
    //http://localhost:8080/HsMobile/com/courseV1_4/getCourseMaster旧的
    // http://localhost:8080/HsMobile/com/ctrl/course/getCourseMaster
    [[EPHttpClient sharedClient] POST:@"com/courseV1_4/getCourseMaster" parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
//                NSLog(@"%@",responseObject);
        NSArray *dataArr = responseObject[@"data"];
        //        NSDictionary *dict = responseObject[@"data"];
        //        NSArray *dataArr = dict[@"courseList"];
        for (NSDictionary *graspItem in dataArr) {
            NSString *key = [graspItem stringForKey:@"courseId"];
            NSString *value = [graspItem stringForKey:@"masterVal"];
            if (key&&value) {
                [weakSelf.graspStateDict setObject:value forKey:key];
            }
        }
        [weakSelf updateLectureGraspState];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

- (void)updateLectureGraspState
{
    for (HSLectureModel *lectureItem in self.contents) {
        NSString *graspValueStr = self.graspStateDict[lectureItem.lectureID];
        if (graspValueStr) {
            CGFloat graspValue = [graspValueStr floatValue];
            if (graspValue == 0.0) {
                lectureItem.graspState = HSGraspStateNone;
            } else if(graspValue == 100.0) {
                lectureItem.graspState = HSGraspStateFinish;
            } else {
                lectureItem.graspState = HSGraspStateOn;
            }
        } else {
            lectureItem.graspState = HSGraspStateNone;
        }
    }
    
    if([self.delegate respondsToSelector:@selector(arrayDataMgrUpdateData:)]){
        [self.delegate arrayDataMgrUpdateData:self];
    }
}



@end
