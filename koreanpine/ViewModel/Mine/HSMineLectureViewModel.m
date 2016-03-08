//
//  HSMineLectureViewModel.m
//  koreanpine
//
//  Created by Christ on 15/7/25.
//  Copyright (c) 2015年 Christ. All rights reserved.
//

#import "HSMineLectureViewModel.h"
#import "HSLoginMgr.h"
#import "NetworkCenter.h"
#import "HSMineLectureModel.h"
#import "HSMineLectureModel.h"

@implementation HSMineLectureViewModel

- (void)fetchItemsAtPage:(YH_Page *)page succeededHandler:(void (^)(NSInteger, NSArray *))succeededHandler failedHandler:(void (^)(NSError *))failedHandler
{
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
    [parameter setObject:@(page.currentPage) forKey:@"pageNum"];
    [parameter setObject:@(page.pageSize) forKey:@"pageSize"];
    [parameter setObject:kVERSIONCODE forKey:@"versionCode"];
    
//    HSCompanyModel *companyModel = [HSLoginMgr loginMgr].loginUser.companyModel;
//    if (companyModel.companyUUID.length > 0) {
//        [parameter setObject:companyModel.companyUUID forKey:@"uuid"];
//    }
    if ([HSLoginMgr loginMgr].loginUser.userId.length > 0) {
        [parameter setObject:[HSLoginMgr loginMgr].loginUser.userId forKey:@"userId"];
    }
    
    [[EPHttpClient sharedClient] POST:@"com/studyHis/selectUserStudyCourseHis" parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"%@",responseObject);
        NSArray *lectureListArr = responseObject[@"data"];
        NSMutableArray *lectureModels = [NSMutableArray array];
        if (IsArrayClass(lectureListArr)) {
            for (NSDictionary *lectureDict in lectureListArr) {
                HSMineLectureModel *lectureModel = [[HSMineLectureModel alloc] initWithDict:lectureDict];
//                判断是否为我的收藏
//                if (lectureModel.isCollect) {
                  [lectureModels addObject:lectureModel];
//                }
                
            }
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
            failedHandler(error);
        }
    }];

    
}



@end
