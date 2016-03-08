//
//  HSDownloadItem.m
//  koreanpine
//
//  Created by Christ on 15/8/22.
//  Copyright (c) 2015年 Christ. All rights reserved.
//

#import "HSDownloadItem.h"
#import "HSLectureDownloadMgr.h"
#import "TCBlobDownloader.h"
@implementation HSDownloadItem

- (instancetype)initWithClassModel:(HSLectureClassModel *)lectureClassModel LectureModel:(HSLectureModel *)lectureModel
{
    self = [super init];
    if (self) {
        self.lectureClassModel = lectureClassModel;
        self.lectureModel = lectureModel;
        [self initDownloader];
        [self checkDownloadState];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.lectureClassModel forKey:@"lectureClassModel"];
    [aCoder encodeInt64:self.expectedDataLength forKey:@"expectedDataLength"];
    [aCoder encodeFloat:self.progress forKey:@"progress"];
    [aCoder encodeObject:self.downloader forKey:@"downloader"];
    [aCoder encodeObject:self.lectureModel forKey:@"lectureModel"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.lectureClassModel = [aDecoder decodeObjectForKey:@"lectureClassModel"];
        self.expectedDataLength = [aDecoder decodeInt64ForKey:@"expectedDataLength"];
        self.progress = [aDecoder decodeFloatForKey:@"progress"];
        self.downloader = [aDecoder decodeObjectForKey:@"downloader"];
        self.lectureModel = [aDecoder decodeObjectForKey:@"lectureModel"];
        [self initDownloader];
        [self checkDownloadState];
    }
    return self;
}


//重启app检查下载的尺寸和进度
- (void)checkDownloadState
{
    NSFileManager *fm = [NSFileManager defaultManager];
    
    // Create download directory
    
    // Test if file already exists (partly downloaded) to set HTTP `bytes` header or not
    if ([fm fileExistsAtPath:self.downloader.pathToFile]) {
        uint64_t fileSize = [[fm attributesOfItemAtPath:self.downloader.pathToFile error:nil] fileSize];
        // Allow progress to reflect what's already downloaded
        self.receivedDataLength += fileSize;
    }
    
    if (self.receivedDataLength > 0) {
        self.progress = self.receivedDataLength*1.0f/self.expectedDataLength;
        self.downloadState = HSDownloadStatePause;
        if (self.expectedDataLength == self.receivedDataLength) {
            self.downloadState = HSDownloadStateDone;
        }
    }
}

//重启后要重新生成下载对象
- (void)initDownloader
{
    NSString *documentUrl = nil;
    NSString *documentPath = nil;
    BOOL isDir = NO;
    if ([self.lectureClassModel isKindOfClass:[HSLecturePDFModel class]]) {
        documentUrl = self.lectureClassModel.videoPath;
        documentPath = kPathDocumentCache;
        
        //    NSLog(@"%@",kPathVideoCache);
        isDir = YES;
        if (![[NSFileManager defaultManager] fileExistsAtPath:documentPath isDirectory:&isDir]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:documentPath withIntermediateDirectories:NO attributes:nil error:NULL];
        }
        self.downloader = [[TCBlobDownloader alloc] initWithURL:[NSURL URLWithString:documentUrl] downloadPath:documentPath documentType:TCBlobDownloadDocumentTypePDF delegate:self];
    }else if([self.lectureClassModel isKindOfClass:[HSLectureClassModel class]]) {
        documentUrl = self.lectureClassModel.videoPath;
        documentPath = kPathVideoCache;
        
        //    NSLog(@"%@",kPathVideoCache);
        isDir = YES;
        if (![[NSFileManager defaultManager] fileExistsAtPath:documentPath isDirectory:&isDir]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:documentPath withIntermediateDirectories:NO attributes:nil error:NULL];
        }
        self.downloader = [[TCBlobDownloader alloc] initWithURL:[NSURL URLWithString:documentUrl] downloadPath:documentPath documentType:TCBlobDownloadDocumentTypeVideo delegate:self];
    }
}

- (BOOL)isEqual:(id)object
{
    if (![object isKindOfClass:[HSDownloadItem class]]) { return NO; }
    HSDownloadItem *downloadItem = (HSDownloadItem *)object;
    return [downloadItem.lectureClassModel isEqual:self.lectureClassModel];
}

- (void)startDownload
{
    if (!self.downloader||self.downloader.isCancelled) {
        [self initDownloader];
    }
    if (self.downloader.isExecuting||self.downloadState == HSDownloadStateDone) {  return; }
    if (self.downloader.isFinished && self.downloadState != HSDownloadStateDone) {
        [self initDownloader];
    }
    [[TCBlobDownloadManager sharedInstance] startDownload:self.downloader];
}

- (void)pauseDownload
{
    if (self.downloader.isExecuting) {
        self.downloadState = HSDownloadStatePause;
        [self.downloader cancel];
    }
}

- (void)cancelDownload
{
    self.downloadState = HSDownloadStateCancelled;
    [self.downloader cancel];
    
    NSFileManager *fm = [NSFileManager defaultManager];
    [fm removeItemAtPath:self.downloader.pathToFile error:nil];
}

- (void)setDownloadState:(HSDownloadState)downloadState
{
    _downloadState = downloadState;
    if ([self.delegate respondsToSelector:@selector(downloadItem:didChagngDownloadState:)]) {
        [self.delegate downloadItem:self didChagngDownloadState:_downloadState];
    }
}

#pragma mark - TCBlobDownloader Delegate

- (void)download:(TCBlobDownloader *)blobDownload didReceiveFirstResponse:(NSURLResponse *)response
{
    self.expectedDataLength = self.receivedDataLength + [response expectedContentLength];
    [[HSLectureDownloadMgr downloadMgr] storeDownloadCache];
    self.downloadState = HSDownloadStateDownloading;
    if ([self.delegate respondsToSelector:@selector(download:didReceiveFirstResponse:)]) {
        [self.delegate download:blobDownload didReceiveFirstResponse:response];
    }
}

- (void)download:(TCBlobDownloader *)blobDownload
  didReceiveData:(uint64_t)receivedLength
         onTotal:(uint64_t)totalLength
        progress:(float)progress
{
    self.receivedDataLength = receivedLength;
    self.expectedDataLength = totalLength;
    self.progress = progress;
    if ([self.delegate respondsToSelector:@selector(download:didReceiveData:onTotal:progress:)]) {
        [self.delegate download:blobDownload didReceiveData:receivedLength onTotal:totalLength progress:progress];
    }
}

- (void)download:(TCBlobDownloader *)blobDownload didStopWithError:(NSError *)error
{
    self.downloadState = HSDownloadStateFailed;
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotifiLoadLectureStateChange object:self];
    if ([self.delegate respondsToSelector:@selector(download:didStopWithError:)]) {
        [self.delegate download:blobDownload didStopWithError:error];
    }
}

- (void)download:(TCBlobDownloader *)blobDownload
didFinishWithSuccess:(BOOL)downloadFinished
          atPath:(NSString *)pathToFile
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotifiLoadLectureStateChange object:self];
    self.downloadState = HSDownloadStateDone;
    if ([self.delegate respondsToSelector:@selector(download:didFinishWithSuccess:atPath:)]) {
        [self.delegate download:blobDownload didFinishWithSuccess:downloadFinished atPath:pathToFile];
    };
}

@end
