//
//  HSLectureViewModel.h
//  koreanpine
//
//  Created by Christ on 15/7/22.
//  Copyright (c) 2015年 Christ. All rights reserved.
//

#import "YH_ArrayDataMgr.h"

@interface HSLectureViewModel : YH_ArrayDataMgr

@property (strong, nonatomic) NSMutableDictionary *graspStateDict;

- (void)fetchItemsAtPage:(YH_Page *)page succeededHandler:(void (^)(NSInteger, NSArray *))succeededHandler failedHandler:(void (^)(NSError *))failedHandler;

@end
