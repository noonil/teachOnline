//
//  HSRuntimeMgr.m
//  koreanpine
//
//  Created by Christ on 15/7/20.
//  Copyright (c) 2015年 Christ. All rights reserved.
//

#import "HSRuntimeMgr.h"
#import "HSLoginMgr.h"
#import "NetworkCenter.h"

#define kAllCompanysKey @"kAllCompanysKey"
#define kImageSizeDictKey @"kImageSizeDictKey"

@implementation HSRuntimeMgr

+ (instancetype)runtimeMgr
{
    static HSRuntimeMgr *runtimeMgr = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        runtimeMgr = [[HSRuntimeMgr alloc] init];
    });
    return runtimeMgr;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initNotifi];
    }
    return self;
}

- (NSMutableDictionary *)imageSizeDict
{
    if (!_imageSizeDict) {
        [self loadImageSizeInfo];
        _imageSizeDict = [NSMutableDictionary dictionary];
        NSDictionary *cacheImageSizeInfo = [[NSUserDefaults standardUserDefaults] objectForKey:kImageSizeDictKey];
        if (cacheImageSizeInfo) {
            [_imageSizeDict addEntriesFromDictionary:cacheImageSizeInfo];
        }
    }
    return _imageSizeDict;
}

- (void)initNotifi
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidLogin) name:kUserDidLoginNotifi object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidLogout) name:kUserDidLogoutNotifi object:nil];
}

- (void)userDidLogin
{
    [self getPublicLectureList];
    [self getCourseAndExamGraspState];
}

- (void)userDidLogout
{
    self.latestLectureArr = nil;
    self.lectureExamGraspState = nil;
}

- (void)storeImageSizeInfo
{
    [[NSUserDefaults standardUserDefaults] setObject:self.imageSizeDict forKey:kImageSizeDictKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)loadImageSizeInfo
{
    
}

- (void)storeCompanyItems:(NSArray *)companyItems
{
    self.companyItems = companyItems;
    NSData *companysArchiver = [NSKeyedArchiver archivedDataWithRootObject:companyItems];
    if (companysArchiver) {
        [[NSUserDefaults standardUserDefaults] setObject:companysArchiver forKey:kAllCompanysKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (NSMutableArray *)loadCompanyItems
{
    if (!_companyItems) {
        NSData *companyArchiver = [[NSUserDefaults standardUserDefaults] objectForKey:kAllCompanysKey];
        _companyItems = [NSKeyedUnarchiver unarchiveObjectWithData:companyArchiver];
    }
    
    NSMutableArray *mutableCompanys = [NSMutableArray arrayWithArray:_companyItems];
    return mutableCompanys;
}

#pragma mark - 接口处理

- (void)getCompanyInfo
{
    __weak typeof(self) weakSelf = self;
    [[NetworkCenter shareCenter] getCompanyInfoWithFinish:^(NSArray *companyItems) {
        [weakSelf storeCompanyItems:companyItems];
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotifiHomeInfoDidUpdate object:nil];
    } failed:^(NSError *error) {
        
    }];

}

//统计考试合格率&课件掌握度
- (void)getCourseAndExamGraspState
{
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
    [parameter setObject:@"158" forKey:@"versionCode"];
    
    HSCompanyModel *companyModel = [HSLoginMgr loginMgr].loginUser.companyModel;
    if (companyModel.companyUUID.length > 0) {
        [parameter setObject:companyModel.companyUUID forKey:@"uuid"];
    }
    if ([HSLoginMgr loginMgr].loginUser.userId.length > 0) {
        [parameter setObject:[HSLoginMgr loginMgr].loginUser.userId forKey:@"userId"];
    }
    
    [[EPHttpClient sharedClient] POST:@"com/courseware/statistics" parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *resultDict = (NSDictionary *)responseObject;
        if (IsDictionaryClass(resultDict)) {
            self.lectureExamGraspState = [[HSLectureExamGraspState alloc] initWithDict:resultDict];
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotifiHomeInfoDidUpdate object:nil];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

- (void)getPublicLectureList
{
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
    [parameter setObject:@(1) forKey:@"pageNum"];
    [parameter setObject:@(2) forKey:@"pageSize"];
    [parameter setObject:@"158" forKey:@"versionCode"];
    
    HSCompanyModel *companyModel = [HSLoginMgr loginMgr].loginUser.companyModel;
    if (companyModel.companyUUID.length > 0) {
        [parameter setObject:companyModel.companyUUID forKey:@"uuid"];
    }
    if ([HSLoginMgr loginMgr].loginUser.userId.length > 0) {
        [parameter setObject:[HSLoginMgr loginMgr].loginUser.userId forKey:@"userId"];
    }
    
    __weak typeof(self) weakSelf = self;
    
    [[NetworkCenter shareCenter] fetchPulibcLectureListWithParameter:parameter succeededBlock:^(NSInteger totalCount, NSArray *lectureItems) {
        weakSelf.latestLectureArr = lectureItems;
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotifiHomeInfoDidUpdate object:nil];
    } failedBlock:^(NSError *error) {
        
    }];
}


@end
