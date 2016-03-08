
//
//  HSMyCollectionViewModel.m
//  koreanpine
//
//  Created by 陶山强 on 15/10/28.
//  Copyright © 2015年 Christ. All rights reserved.
//

#import "HSMyCollectionViewModel.h"
#import "HSLoginMgr.h"
#import "NetworkCenter.h"
#import "HSMyCollectionModel.h"

@implementation HSMyCollectionViewModel
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
    
//    WS(weakSelf);
    //http://localhost:8080/HsMobile/com/ctrl/course/orgCourseList
//    http://localhost:8080/HsMobile/com/collect/collectInfo/selectCourseCollectV2
    //com/courseV1_4/orgCourseList
    [[EPHttpClient sharedClient] POST:@"com/collect/collectInfo/selectCourseCollectV2" parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //data
        NSDictionary *dict = responseObject[@"data"];
        NSArray *lectureListArr = dict[@"list"];
//                           NSLog(@"%@",lectureListArr);
//        NSDictionary *lectureListArr = lectureList[@"collect"];
   
        //courseList
        NSMutableArray *lectureModels = [NSMutableArray array];
        if (IsArrayClass(lectureListArr)) {
            NSMutableArray *courseIdArr = [NSMutableArray array];
            for (NSDictionary *lectureDict in lectureListArr) {
                NSDictionary *collectDict = lectureDict[@"collect"];
                HSMyCollectionModel *lectureModel = [[HSMyCollectionModel alloc] initWithDict:collectDict];
                    [lectureModel setValue:lectureDict[@"collectId"] forKey:@"collectID"];
                    [lectureModel setValue:lectureDict[@"id"] forKey:@"collectInfoID"];
                    [lectureModel setValue:lectureDict[@"collectSource"] forKey:@"collectSource"];
                    [lectureModels addObject:lectureModel];
                    [courseIdArr addObject:lectureModel.lectureID];
    
               
            }
            
//            [weakSelf getGraspStateInfoWithCourseIds:courseIdArr];
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
            NSLog(@"%@",error);
            failedHandler(error);
        }
    }];
}
+ (void)getCollectionViewModel:(NSString *)LectureID courseName:(NSString *)courseName succeededHandler:(void (^)(HSMyCollectionModel *))succeededHandler failedHandler:(void (^)(NSError *))failedHandler
{
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];

    [parameter setObject:kVERSIONCODE forKey:@"versionCode"];
    [parameter setObject:courseName forKey:@"courseName"];
    HSCompanyModel *companyModel = [HSLoginMgr loginMgr].loginUser.companyModel;
    if (companyModel.companyUUID.length > 0) {
        [parameter setObject:companyModel.companyUUID forKey:@"uuid"];
    }
    if ([HSLoginMgr loginMgr].loginUser.userId.length > 0) {
        [parameter setObject:[HSLoginMgr loginMgr].loginUser.userId forKey:@"userId"];
    }
    
    //    WS(weakSelf);
    //http://localhost:8080/HsMobile/com/ctrl/course/orgCourseList
    //    http://localhost:8080/HsMobile/com/collect/collectInfo/selectCourseCollectV2
    //com/courseV1_4/orgCourseList
    [[EPHttpClient sharedClient] POST:@"com/collect/collectInfo/selectCourseCollectV2" parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //data
        NSDictionary *dict = responseObject[@"data"];
        NSArray *lectureListArr = dict[@"list"];
        //                           NSLog(@"%@",lectureListArr);
        //        NSDictionary *lectureListArr = lectureList[@"collect"];
        
        //courseList
//        NSMutableArray *lectureModels = [NSMutableArray array];
        HSMyCollectionModel *lectureModel = nil;
        if (IsArrayClass(lectureListArr)) {
//            NSMutableArray *courseIdArr = [NSMutableArray array];
            for (NSDictionary *lectureDict in lectureListArr) {
                NSDictionary *collectDict = lectureDict[@"collect"];
                lectureModel = [[HSMyCollectionModel alloc] initWithDict:collectDict];
                [lectureModel setValue:lectureDict[@"collectId"] forKey:@"collectID"];
                [lectureModel setValue:lectureDict[@"id"] forKey:@"collectInfoID"];
                [lectureModel setValue:lectureDict[@"collectSource"] forKey:@"collectSource"];
//                if ([lectureModel.collectID isEqualToString:LectureID]) {
//                    [lectureModels addObject:lectureModel];
//                    [courseIdArr addObject:lectureModel.lectureID];
//                }
               
                
                
            }
            
            //            [weakSelf getGraspStateInfoWithCourseIds:courseIdArr];
            if (succeededHandler) {
                succeededHandler(lectureModel);
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

-(void)deleteCollectionCell:(NSString *)lectureID collectID:(NSString *)collectID isHS:(NSInteger)collectSource succeededHandler:(void (^)())succeededHandler failedHandler:(void (^)())failedHandler{
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
//    if (collectID != nil) {
        [parameter setObject:collectID forKey:@"collectInfoId"];
//    }
//    if (lectureID != nil) {
        [parameter setObject:lectureID forKey:@"collectionId"];
//    }
    
    //    WS(weakSelf);
    //http://localhost:8080/HsMobile/com/ctrl/course/orgCourseList
    //com/courseV1_4/orgCourseList
    //    @"com/courseV1_4/hsCourseList
    NSString *url = nil;
    if (collectSource == 1) {
        url = @"com/collect/collectInfo/removeCourseCollection";
    }else{
        url = @"com/collect/collectInfo/removeCourseCollectionHongsong";
    }
    [[EPHttpClient sharedClient] POST:url parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSInteger res = 0;
        res = [responseObject[@"res"] integerValue];
        //            [weakSelf getGraspStateInfoWithCourseIds:courseIdArr];
        if (res ==  1) {
            if([self.delegate respondsToSelector:@selector(arrayDataMgr: didDeleteContentAtIndex:)]){
                [self.delegate  arrayDataMgr:self didDeleteContentAtIndex:0];
            }
            if (succeededHandler) {
                succeededHandler();
            }
        }
    }
     
                              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                  
                              }];
    

}

@end
