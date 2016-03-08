//
//  HSLectureDownloadMgr.h
//  koreanpine
//
//  Created by Christ on 15/8/22.
//  Copyright (c) 2015年 Christ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HSDownloadItem.h"

@interface HSLectureDownloadMgr : NSObject

+ (instancetype)downloadMgr;

@property (strong, nonatomic) NSMutableArray *downloadItems;

- (HSDownloadItem *)downloadItemForLectureClassModel:(HSLectureClassModel *)lectureClassModel;

- (BOOL)addDownloadItemWith:(HSLectureClassModel *)lectureClassModel LectureModel:(HSLectureModel *)lectureModel autoDownload:(BOOL)autoDownload;

- (void)storeDownloadCache;

- (void)loadDownloadCache;

@end
