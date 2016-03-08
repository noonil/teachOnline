//
//  HSLectureDownloadMgr.m
//  koreanpine
//
//  Created by Christ on 15/8/22.
//  Copyright (c) 2015年 Christ. All rights reserved.
//

#import "HSLectureDownloadMgr.h"
#import "HSDownloadItem.h"

#define kLectureDownloadCache @"kLectureDownloadCache"

@implementation HSLectureDownloadMgr

+ (instancetype)downloadMgr
{
    static HSLectureDownloadMgr *downloadMgr = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        downloadMgr = [[HSLectureDownloadMgr alloc] init];
    });
    return downloadMgr;
}



- (NSMutableArray *)downloadItems
{
    if (!_downloadItems) {
        _downloadItems = [NSMutableArray array];
    }
    return _downloadItems;
}

- (HSDownloadItem *)downloadItemForLectureClassModel:(HSLectureClassModel *)lectureClassModel
{
    HSDownloadItem *downloadItem = nil;
    if ([lectureClassModel isKindOfClass:[HSLecturePDFModel class]]) {
       HSLecturePDFModel * lecturePDFModel = (HSLecturePDFModel *)lectureClassModel;
        for (HSDownloadItem *item in self.downloadItems) {
            if ([item.lectureClassModel isKindOfClass:[HSLecturePDFModel class]]) {
                HSLecturePDFModel *pdfModel = (HSLecturePDFModel *)item.lectureClassModel;
                if ([pdfModel.cloudId isEqualToString:lecturePDFModel.cloudId]) {
                    downloadItem = item;
                }
            }
        }

    }else {
        for (HSDownloadItem *item in self.downloadItems) {
            if ([item.lectureClassModel isEqual:lectureClassModel]) {
                downloadItem = item;
            }
        }
    }
    
    return downloadItem;
}

#pragma mark -

- (BOOL)addDownloadItemWith:(HSLectureClassModel *)lectureClassModel LectureModel:(HSLectureModel *)lectureModel autoDownload:(BOOL)autoDownload
{
    if ([lectureClassModel isKindOfClass:[HSLecturePDFModel class]]) {
        lectureClassModel = (HSLecturePDFModel *)lectureClassModel;
    }
    HSDownloadItem *downloadItem = [[HSDownloadItem alloc] initWithClassModel:lectureClassModel LectureModel:lectureModel];
    if ([self.downloadItems containsObject:downloadItem]) { return NO; }
    [self.downloadItems addObject:downloadItem];
    if (autoDownload) {
        [downloadItem startDownload];
    }
    [self storeDownloadCache];
    return YES;
}

- (void)storeDownloadCache
{
    NSData *downloadsData = [NSKeyedArchiver archivedDataWithRootObject:self.downloadItems];
    [[NSUserDefaults standardUserDefaults] setObject:downloadsData forKey:kLectureDownloadCache];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)loadDownloadCache
{
    NSData *downloadsData = [[NSUserDefaults standardUserDefaults] objectForKey:kLectureDownloadCache];
    NSArray *cacheDownloadItems = [NSKeyedUnarchiver unarchiveObjectWithData:downloadsData];
    [self.downloadItems addObjectsFromArray:cacheDownloadItems];
}


@end
