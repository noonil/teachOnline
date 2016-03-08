//
//  HSDownloadingCell.m
//  koreanpine
//
//  Created by Christ on 15/8/22.
//  Copyright (c) 2015年 Christ. All rights reserved.
//

#import "HSDownloadingCell.h"
#import "HSDownloadButton.h"
@implementation HSDownloadingCell

- (void)awakeFromNib {
    // Initialization code
    [self initView];
}

- (void)prepareForReuse
{
    [self resetCell];
}


- (void)initView
{
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    [self setIndentationWidth:15];
    
    UIView *editAccessorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 32, 22)];
    
    self.checkmarkBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 0, 22, 22)];
    [self.checkmarkBtn setBackgroundImage:[UIImage imageNamed:@"box02_n"] forState:UIControlStateNormal];
    [self.checkmarkBtn setBackgroundImage:[UIImage imageNamed:@"box02_f"] forState:UIControlStateSelected];
    [self.checkmarkBtn addTarget:self action:@selector(checkBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [editAccessorView addSubview:self.checkmarkBtn];
    [self setEditingAccessoryView:editAccessorView];
    
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(deleteOrNot:)];
    [tapGesture setNumberOfTapsRequired:1];
    [tapGesture setNumberOfTouchesRequired:1];
    [self addGestureRecognizer:tapGesture];
}


- (void)resetCell
{
    [self.downloadItem setDelegate:nil];
}

- (void)updateCellWithDownloadItem:(HSDownloadItem *)downloadItem
{
    self.downloadItem = downloadItem;
    [downloadItem setDelegate:self];
    [self.titleLabel setText:self.downloadItem.lectureClassModel.name];
    if ([self.downloadItem.lectureClassModel isKindOfClass:[HSLecturePDFModel class]]) {
        self.lectureImageView.image = [UIImage imageNamed:@"课程"];
    }else if([self.downloadItem.lectureClassModel isKindOfClass:[HSLectureClassModel class]]) {
        self.lectureImageView.image = [UIImage imageNamed:@"播放"];

    }
    [self updateCellDownloadInfo];
}

- (void)updateCellDownloadInfo
{
//    [self.progressView setProgress:self.downloadItem.progress];
    [self.actionBtn setProgress:self.downloadItem.progress];
//    if (self.downloadItem.downloadState == HSDownloadStateDone && self.downloadItem.progress == 1.0) {
//            }else {
//                self.downloadItem.downloadState = HSDownloadStateCancelled;
//
//    }
    NSDictionary *downloadStates = @{@(HSDownloadStateReady):@"待下载",
                                     @(HSDownloadStateDownloading):@"下载中",
                                     @(HSDownloadStatePause):@"暂停",
                                     @(HSDownloadStateDone):@"完成(100%)",
                                     @(HSDownloadStateCancelled):@"取消下载",
                                     @(HSDownloadStateFailed):@"暂停",
                                     };
    
    NSString *downloadStateValue = downloadStates[@(self.downloadItem.downloadState)];
    
    if (self.downloadItem.downloadState == HSDownloadStateDownloading) {
        downloadStateValue = [downloadStateValue stringByAppendingFormat:@"(%.0f%%)",self.downloadItem.progress*100];
    }else if (self.downloadItem.downloadState == HSDownloadStatePause) {
        downloadStateValue = [downloadStateValue stringByAppendingFormat:@"(%.0f%%)",self.downloadItem.progress*100];
    }else if(self.downloadItem.downloadState == HSDownloadStateFailed) {
        downloadStateValue = [downloadStateValue stringByAppendingFormat:@"(%.0f%%)",self.downloadItem.progress*100];
    }
    [self.progressLabel setText:downloadStateValue];
    
    
    switch (self.downloadItem.downloadState) {
        case HSDownloadStateReady:{
//            [self.actionBtn setTitle:@"开始" forState:UIControlStateNormal];
//            [self.actionBtn setBackgroundColor:kActionBtnNormalColor];
            
            [self.actionBtn setImage:[UIImage imageNamed:@"download"] forState:UIControlStateNormal];
            break;
        }
        case HSDownloadStateDownloading:{
//            [self.actionBtn setTitle:@"暂停" forState:UIControlStateNormal];
//            [self.actionBtn setBackgroundColor:kActionBtnLightColor];
            [self.actionBtn setImage:[UIImage imageNamed:@"download_pause"] forState:UIControlStateNormal];
            break;
        }
        case HSDownloadStatePause:{
//            [self.actionBtn setTitle:@"继续" forState:UIControlStateNormal];
//            [self.actionBtn setBackgroundColor:kActionBtnNormalColor];
            [self.actionBtn setImage:[UIImage imageNamed:@"download"] forState:UIControlStateNormal];

            break;
        }
        case HSDownloadStateDone:{
//            [self.actionBtn setTitle:@"已下载" forState:UIControlStateNormal];
            if (self.downloadItem.progress == 1.0) {
              [self.actionBtn setImage:[UIImage imageNamed:@"download_play"] forState:UIControlStateNormal];
            }else {
               self.downloadItem.downloadState = HSDownloadStatePause;
               [self.actionBtn setImage:[UIImage imageNamed:@"download"] forState:UIControlStateNormal];
            }
            
            
//            [self.actionBtn setBackgroundColor:kActionBtnLightColor];
//            [self.actionBtn setEnabled:YES];
            break;
        }
        case HSDownloadStateCancelled:
        case HSDownloadStateFailed:{
//            [self.actionBtn setTitle:@"重新开始" forState:UIControlStateNormal];
//            [self.actionBtn setBackgroundColor:kActionBtnNormalColor];
            [self.actionBtn setImage:[UIImage imageNamed:@"download"] forState:UIControlStateNormal];
            break;
        }
        default:
            break;
    }
    
    CGFloat hasDownloadSize = self.downloadItem.receivedDataLength/(1024*1024*1.0f);
    CGFloat totalDownloadSize = self.downloadItem.expectedDataLength/(1024*1024*1.0f);
//    if (totalDownloadSize-0.5 < 0) {
//        totalDownloadSize = totalDownloadSize/0.1;
//    }else if (totalDownloadSize + 0.5 > ((int)totalDownloadSize +1)) {
//        totalDownloadSize = (int)totalDownloadSize +1 ;
//    }
    NSString *lenghtValue = [NSString stringWithFormat:@"已下载%.1fM/共%.1fM",hasDownloadSize,totalDownloadSize];
    [self.lenghtLabel setText:lenghtValue];
    
}
- (void) deleteOrNot:(UITapGestureRecognizer *)tapGesture {
    UIColor *color = self.backgroundColor;
    WS(weakSelf);
    [UIView animateWithDuration:0.1 animations:^{
        weakSelf.backgroundColor = [UIColor lightGrayColor];
    }completion:^(BOOL finished) {
        if (finished) {
            weakSelf.backgroundColor = color;
        }
    }];

    if (self.editing) {
        [self.checkmarkBtn setSelected:!self.checkmarkBtn.selected];
        if ([self.delegate respondsToSelector:@selector(checkmarkBtnTapped:)]) {
            [self.delegate checkmarkBtnTapped:self];
        }
        if ([self.delegate respondsToSelector:@selector(showOrHideOperationButtons:)]) {
            [self.delegate showOrHideOperationButtons:self];
        }
    }else {
        if ([self.delegate respondsToSelector:@selector(jumpToLectureView:)]) {
            [self.delegate jumpToLectureView:self];
        }

    }
}
- (void)checkBtnTapped:(UIButton *)checkBtn
{
    [self.checkmarkBtn setSelected:!self.checkmarkBtn.selected];
    if ([self.delegate respondsToSelector:@selector(checkmarkBtnTapped:)]) {
        [self.delegate checkmarkBtnTapped:self];
    }
    if ([self.delegate respondsToSelector:@selector(showOrHideOperationButtons:)]) {
        [self.delegate showOrHideOperationButtons:self];
    }
}

- (IBAction)actionBtnTapped:(UIButton *)sender {
    TCBlobDownloader *downloader = self.downloadItem.downloader;
//    NSString *documentPath = nil;
    if (!downloader) {
        [self.downloadItem startDownload];
        return;
    }
    switch (self.downloadItem.downloadState) {
        case HSDownloadStateCancelled:
        case HSDownloadStateFailed:{
            [self.downloadItem startDownload];
            break;
        }
        case HSDownloadStateDone:{
            if (self.HSDocumentDisplay) {
                self.HSDocumentDisplay(self.downloadItem);
            }
            break;
        }
        case HSDownloadStateDownloading:{
            [self.downloadItem pauseDownload];
            break;
        }
        case HSDownloadStatePause:
        case HSDownloadStateReady:{
            [self.downloadItem startDownload];
            break;
        }
        default:
            break;
    }
}

#pragma mark -

- (void)download:(TCBlobDownloader *)blobDownload didReceiveFirstResponse:(NSURLResponse *)response
{
    [self updateCellDownloadInfo];
}

- (void)download:(TCBlobDownloader *)blobDownload
  didReceiveData:(uint64_t)receivedLength
         onTotal:(uint64_t)totalLength
        progress:(float)progress
{
    [self updateCellDownloadInfo];
}

- (void)download:(TCBlobDownloader *)blobDownload didStopWithError:(NSError *)error
{
    [self updateCellDownloadInfo];
}

- (void)download:(TCBlobDownloader *)blobDownload
didFinishWithSuccess:(BOOL)downloadFinished
          atPath:(NSString *)pathToFile
{
    [self updateCellDownloadInfo];
}

- (void)downloadItem:(HSDownloadItem *)downloadItem didChagngDownloadState:(HSDownloadState)downloadState
{
    [self updateCellDownloadInfo];
}
//- (void) sendChangeStateNotification {
//    [[NSNotificationCenter defaultCenter] postNotificationName:kChangeDownloadItemStateNotification object:nil];
//}
@end
