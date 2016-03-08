//
//  HSLectureSearchViewModel.m
//  koreanpine
//
//  Created by Christ on 15/8/21.
//  Copyright (c) 2015年 Christ. All rights reserved.
//

#import "HSLectureSearchViewModel.h"
#import "HSLoginMgr.h"
#import "NetworkCenter.h"
#import "HSLectureModel.h"

@implementation HSLectureSearchViewModel

- (void)setQueryValue:(NSString *)queryValue
{
    _queryValue = queryValue;
    [self fetchLatest];
}


- (void)fetchItemsAtPage:(YH_Page *)page succeededHandler:(void (^)(NSInteger, NSArray *))succeededHandler failedHandler:(void (^)(NSError *))failedHandler
{
    if (_queryValue.length == 0) {
        return;
    }
    
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
    [parameter setObject:@(self.pageMgr.currentPage) forKey:@"pageNum"];
    [parameter setObject:@(self.pageMgr.pageSize) forKey:@"pageSize"];
    [parameter setObject:self.queryValue forKey:@"courseName"];
    [parameter setObject:kVERSIONCODE forKey:@"versionCode"];
    
    HSCompanyModel *companyModel = [HSLoginMgr loginMgr].loginUser.companyModel;
    if (companyModel.companyUUID.length > 0) {
        [parameter setObject:companyModel.companyUUID forKey:@"uuid"];
    }
    if ([HSLoginMgr loginMgr].loginUser.userId.length > 0) {
        [parameter setObject:[HSLoginMgr loginMgr].loginUser.userId forKey:@"userId"];
    }
    
    [[NetworkCenter shareCenter] fetchPulibcLectureListWithParameter:parameter succeededBlock:^(NSInteger totalCount, NSArray *lectureItems) {
        if (succeededHandler) {
            succeededHandler(totalCount,lectureItems);
        }
    } failedBlock:^(NSError *error) {
        if (failedHandler) {
            failedHandler(error);
        }
    }];
}

@end
