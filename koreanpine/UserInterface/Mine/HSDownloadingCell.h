//
//  HSDownloadingCell.h
//  koreanpine
//
//  Created by Christ on 15/8/22.
//  Copyright (c) 2015年 Christ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSDownloadItem.h"

@class HSDownloadingCell,HSDownloadButton;

@protocol HSDownloadingCellDelegate <NSObject>

- (void) checkmarkBtnTapped:(HSDownloadingCell *)cell;
- (void) jumpToLectureView:(HSDownloadingCell *)cell;
- (void) showOrHideOperationButtons:(HSDownloadingCell *)cell;
@end

@interface HSDownloadingCell : UITableViewCell
<HSDownloadItemDelegate>

@property (weak, nonatomic) IBOutlet UIView *containerView;
//重新开始按钮
@property (weak, nonatomic) IBOutlet HSDownloadButton *actionBtn;
//课程题目
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
 //下载进度label
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;
//文件大小 label
@property (weak, nonatomic) IBOutlet UILabel *lenghtLabel;
@property (weak, nonatomic) IBOutlet UIImageView *lectureImageView;
@property (nonatomic,copy) void (^HSDocumentDisplay)(HSDownloadItem *);
@property (weak, nonatomic) id<HSDownloadingCellDelegate> delegate;

@property (strong, nonatomic) UIButton *checkmarkBtn;

@property (strong, nonatomic) HSDownloadItem *downloadItem;

- (void)resetCell;

- (void)updateCellWithDownloadItem:(HSDownloadItem *)downloadItem;

@end
