//
//  HSExerciseViewModel.m
//  koreanpine
//
//  Created by Victor on 15/10/20.
//  Copyright © 2015年 Christ. All rights reserved.
//

#import "HSExerciseViewModel.h"
#import "HSLoginMgr.h"
#import "MJExtension.h"
#import "HSHeroModel.h"
#import "HSUserHeroModel.h"
@implementation HSExerciseViewModel
- (instancetype)init {
    if (!self) {
        self = [HSExerciseViewModel shareExerciseViewModel];
    }
    return self;
}

+ (instancetype)shareExerciseViewModel {
    static HSExerciseViewModel *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[HSExerciseViewModel alloc] init];
    });
    return instance;
}

- (void)fetchItemsAtPage:(YH_Page *)page succeededHandler:(void (^)(NSInteger, NSArray *))succeededHandler failedHandler:(void (^)(NSError *))failedHandler {
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
    [parameter setObject:self.sortType forKey:@"sortType"];
    [parameter setObject:@(1) forKey:@"pageNum"];
    [parameter setObject:@(10) forKey:@"pageSize"];
    if ([HSLoginMgr loginMgr].loginUser.userId.length > 0) {
        [parameter setObject:[HSLoginMgr loginMgr].loginUser.userId forKey:@"userId"];
    }
    //获取练习分类接口
    [[EPHttpClient sharedClient] POST:@"com/ctrl/practiceV1_5/getOrgThisWeekRankingList" parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //data
        NSDictionary *dict = responseObject[@"data"];
        NSArray *accountListArr = dict[@"list"];
        NSMutableArray *heroModels = [NSMutableArray array];
        if (IsArrayClass(accountListArr)) {
            for (NSDictionary *heroDict in accountListArr) {
                HSHeroModel *hero = [HSHeroModel objectWithKeyValues:heroDict];
                [heroModels addObject:hero];
            }
            self.heroArr = heroModels;
//            NSLog(@"%@",heroModels);
//            NSLog(@"%@",self.heroArr);
            if (succeededHandler) {
                succeededHandler(heroModels.count,heroModels);
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
- (NSString *)sortType {
    if (!_sortType) {
        _sortType = @"rightRate";
    }
    return _sortType;
}

- (void)getUserRankInfoSucceededHandler:(void (^)(HSUserHeroModel *))succeededHandler failedHandler:(void (^)(NSError *))failedHandler {
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
    if ([HSLoginMgr loginMgr].loginUser.userId.length > 0) {
        [parameter setObject:[HSLoginMgr loginMgr].loginUser.userId forKey:@"userId"];
    }
    [[EPHttpClient sharedClient] POST:@"com/ctrl/practiceV1_5/getUserWeekRankingInfo" parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //data
        NSDictionary *dict = responseObject[@"data"];
        HSUserHeroModel *userHero = [HSUserHeroModel objectWithKeyValues:dict];
                         if (succeededHandler) {
                succeededHandler(userHero);
            }
            

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failedHandler) {
            //            NSLog(@"%@",error);
            failedHandler(error);
        }
    }];

}
@end
