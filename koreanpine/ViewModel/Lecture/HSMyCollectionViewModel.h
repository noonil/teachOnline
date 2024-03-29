//
//  HSMyCollectionViewModel.h
//  koreanpine
//
//  Created by 陶山强 on 15/10/28.
//  Copyright © 2015年 Christ. All rights reserved.
//

#import "YH_ArrayDataMgr.h"
#import "HSMyCollectionModel.h"
@interface HSMyCollectionViewModel : YH_ArrayDataMgr
- (void)fetchItemsAtPage:(YH_Page *)page succeededHandler:(void (^)(NSInteger, NSArray *))succeededHandler failedHandler:(void (^)(NSError *))failedHandler;
+ (void)getCollectionViewModel:(NSString *)LectureID courseName:(NSString *)courseName succeededHandler:(void (^)(HSMyCollectionModel *))succeededHandler failedHandler:(void (^)(NSError *))failedHandler;
- (void)deleteCollectionCell:(NSString *)lectureID collectID:(NSString *)collectID isHS:(NSInteger)collectSource succeededHandler:(void (^)())succeededHandler failedHandler:(void (^)())failedHandler;
@end
