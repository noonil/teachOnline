//
//  HSLectureHsViewModel.h
//  koreanpine
//
//  Created by 陶山强 on 15/10/21.
//  Copyright © 2015年 Christ. All rights reserved.
//

#import "YH_ArrayDataMgr.h"

@interface HSLectureHsViewModel : YH_ArrayDataMgr
@property (strong, nonatomic) NSMutableDictionary *graspStateDict;

- (void)fetchItemsAtPage:(YH_Page *)page succeededHandler:(void (^)(NSInteger, NSArray *))succeededHandler failedHandler:(void (^)(NSError *))failedHandler;
@end
