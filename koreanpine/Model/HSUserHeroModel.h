//
//  HSUserHeroModel.h
//  koreanpine
//
//  Created by Victor on 15/11/6.
//  Copyright © 2015年 Christ. All rights reserved.
//

#import "YH_Model.h"

@interface HSUserHeroModel : YH_Model
///ranking4RightNum = 9;
//ranking4RightRate = 9;
//ranking4TotalNum = 5;
//rightCount = 0;
//totalCount = 15;
@property (nonatomic,copy) NSString *ranking4RightNum;
@property (nonatomic,copy) NSString *ranking4RightRate;
@property (nonatomic,copy) NSString *ranking4TotalNum;
@property (nonatomic,copy) NSString *rightCount;
@property (nonatomic,copy) NSString *totalCount;
@end
