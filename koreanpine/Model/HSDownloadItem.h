//
//  HSDownloadItem.h
//  koreanpine
//
//  Created by Christ on 15/8/22.
//  Copyright (c) 2015年 Christ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TCBlobDownload.h"
#import "HSLectureClassModel.h"

#define kNotifiLoadLectureStateChange @"kNotifiLoadLectureStateChange"

typedef NS_ENUM(NSUInteger, HSDownloadState) {
    /** The download is instanciated but has not been started yet. */
    HSDownloadStateReady = 0,
    /** The download has started the HTTP connection to retrieve the file. */
    HSDownloadStateDownloading,
    /** The download has been paused. */
    HSDownloadStatePause,
    /** The download has been completed successfully. */
    HSDownloadStateDone,
    /** The download has been cancelled manually. */
    HSDownloadStateCancelled,
    /** The download failed, probably because of an error. It is possible to access the error in the appropriate delegate method or block property. */
    HSDownloadStateFailed
};

@class HSDownloadItem,HSLectureModel;

@protocol HSDownloadItemDelegate <TCBlobDownloaderDelegate>

- (void)downloadItem:(HSDownloadItem *)downloadItem didChagngDownloadState:(HSDownloadState)downloadState;

@end

@interface HSDownloadItem : NSObject
<TCBlobDownloaderDelegate,NSCoding>

- (instancetype)initWithClassModel:(HSLectureClassModel *)lectureClassModel LectureModel:(HSLectureModel *)lectureModel;

@property (strong, nonatomic) HSLectureClassModel *lectureClassModel;

@property (strong, nonatomic) TCBlobDownloader *downloader;

@property (assign, nonatomic) HSDownloadState downloadState;

//@property (strong, nonatomic) NSString *pathToFile;

@property (assign, nonatomic) uint64_t expectedDataLength;

@property (assign, nonatomic) uint64_t receivedDataLength;

@property (assign, nonatomic) float progress;

@property (weak, nonatomic) id<HSDownloadItemDelegate> delegate;
@property (nonatomic,strong) HSLectureModel *lectureModel;
- (void)startDownload;

- (void)pauseDownload;

- (void)cancelDownload;

@end
