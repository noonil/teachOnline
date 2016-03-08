//
//  HSExerciseViewModel.h
//  koreanpine
//
//  Created by Victor on 15/10/20.
//  Copyright © 2015年 Christ. All rights reserved.
//

#import "YH_ArrayDataMgr.h"
@class HSUserHeroModel;
@interface HSExerciseViewModel : YH_ArrayDataMgr
//totalNum，rightRate
@property (nonatomic,copy) NSString *sortType;
@property (nonatomic,strong) NSArray *heroArr;
+ (instancetype) shareExerciseViewModel;
- (void) getUserRankInfoSucceededHandler:(void (^)(HSUserHeroModel *userModel))succeededHandler failedHandler:(void (^)(NSError *error))failedHandler;
@end
