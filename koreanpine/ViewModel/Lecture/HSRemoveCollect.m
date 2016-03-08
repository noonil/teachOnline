//
//  HSRemoveCollect.m
//  koreanpine
//
//  Created by 陶山强 on 15/10/28.
//  Copyright © 2015年 Christ. All rights reserved.
//

#import "HSRemoveCollect.h"
#import "HSLoginMgr.h"
#import "NetworkCenter.h"
#import "HSLectureModel.h"
@implementation HSRemoveCollect
- (void)fetchItemsAtPage:(YH_Page *)page succeededHandler:(void (^)(NSInteger, NSArray *))succeededHandler failedHandler:(void (^)(NSError *))failedHandler
{
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
//    [parameter setObject:@(page.currentPage) forKey:@"pageNum"];
//    [parameter setObject:@(page.pageSize) forKey:@"pageSize"];
//    [parameter setObject:kVERSIONCODE forKey:@"versionCode"];
    
//    HSLectureModel *lectureModel = [[HSLectureModel alloc]init];
//    if (lectureModel.collectID.length > 0) {
//        [parameter setObject:lectureModel.collectID forKey:@"collectInfoId"];
//    }
//    if (lectureModel.lectureID.length > 0) {
//        [parameter setObject:lectureModel.lectureID forKey:@"collectionId"];
//    }
    
//    WS(weakSelf);
    //http://localhost:8080/HsMobile/com/ctrl/course/orgCourseList
    //com/courseV1_4/orgCourseList
    //    @"com/courseV1_4/hsCourseList
    [[EPHttpClient sharedClient] POST:@"com/collect/collectInfo/removeCourseCollection" parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSInteger res = 0;
        res = [responseObject[@"res"] integerValue];
//            [weakSelf getGraspStateInfoWithCourseIds:courseIdArr];
        if (res ==  1) {
            if([self.delegate respondsToSelector:@selector(arrayDataMgr: didDeleteContentAtIndex:)]){
                [self.delegate  arrayDataMgr:self didDeleteContentAtIndex:0];
            }
        }
     }

     
      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
     }];
}
@end
