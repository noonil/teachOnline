//
//  HSMineDownloadVC.m
//  koreanpine
//
//  Created by Christ on 15/7/18.
//  Copyright (c) 2015年 Christ. All rights reserved.
//

#import "HSMineDownloadVC.h"
#import "HSDownloadingCell.h"
#import "HSMineDownloadActionView.h"
#import "HSMineDownloadViewModel.h"
#import "HSLectureDownloadMgr.h"
#import "TCBlobDownloader.h"
#import "HSDownloadItem.h"
#import <MediaPlayer/MediaPlayer.h>
#import "HSLectureModel.h"
#import "HSLectureClassModel.h"
#import "HSLectureDetailVC.h"
@interface HSMineDownloadVC ()
<UITableViewDataSource,UITableViewDelegate,HSDownloadingCellDelegate,UIDocumentInteractionControllerDelegate>

@property (strong, nonatomic) UIView *contentView;

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) HSMineDownloadViewModel *downloadVM;

@property (strong, nonatomic) UIButton *actionBtn;

@property (strong, nonatomic) HSMineDownloadActionView *actionView;

@property (assign, nonatomic) BOOL shouldShowActionView;

@property (strong, nonatomic) NSMutableArray *selectedIndexPaths;

@property (nonatomic,strong) MPMoviePlayerController *moviePlayer;

@property (nonatomic,strong) UIDocumentInteractionController *documentInteractionController;
@end

@implementation HSMineDownloadVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initView
{
    self.title = @"下载管理";
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:self.backBtn];
    self.navigationItem.leftBarButtonItem = backItem;
    
    self.actionBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 27)];
    [self.actionBtn setBackgroundColor: RGBACOLOR(88, 117, 198, 1)];
    [self.actionBtn.layer setCornerRadius:3.0f];
    [self.actionBtn.layer setMasksToBounds:YES];
    [self.actionBtn setTitle:@"操作" forState:UIControlStateNormal];
    [self.actionBtn.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
    [self.actionBtn addTarget:self action:@selector(actionBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithCustomView:self.actionBtn];
    self.navigationItem.rightBarButtonItem = doneItem;
    
    self.contentView = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.contentView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    [self.view addSubview:self.contentView];
    
    self.actionView = [[HSMineDownloadActionView alloc] initWithFrame:CGRectMake(0, 14, CGRectGetWidth(self.view.bounds), 50.0f)];
    [self.actionView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [self.actionView.startBtn addTarget:self action:@selector(startBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.actionView.startBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    [self.actionView.pauseBtn addTarget:self action:@selector(pauseBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.actionView.pauseBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    [self.actionView.removeBtn addTarget:self action:@selector(removeBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.actionView.removeBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    self.actionView.startBtn.enabled = NO;
    self.actionView.pauseBtn.enabled = NO;
    self.actionView.removeBtn.enabled = NO;

    [self.actionView.selectAllBtn addTarget:self action:@selector(selectAllBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.contentView addSubview:self.actionView];
    self.actionView.hidden = YES;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.actionView.frame), CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.contentView.bounds)-CGRectGetMaxY(self.actionView.frame)) style:UITableViewStylePlain];
    [self.tableView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    [self.tableView registerNib:[UINib nibWithNibName:@"HSDownloadingCell" bundle:nil] forCellReuseIdentifier:@"HSDownloadingCell"];
//    [self.tableView registerClass:[HSMineDownloadActionView class] forHeaderFooterViewReuseIdentifier:@"HSMineDownloadActionView"];
    [self.tableView setDataSource:self];
    [self.tableView setDelegate:self];
    [self.tableView setTableFooterView:[UIView new]];
    [self.contentView addSubview:self.tableView];
}

- (NSMutableArray *)selectedIndexPaths
{
    if (!_selectedIndexPaths) {
        _selectedIndexPaths = [NSMutableArray array];
    }
    return _selectedIndexPaths;
}

- (void)actionBtnTapped:(UIButton *)btn
{
    
    self.shouldShowActionView = !self.shouldShowActionView;
    [self.tableView setEditing:self.shouldShowActionView animated:YES];
    if (self.shouldShowActionView) {
        [self showActionView];
        [self.actionBtn setTitle:@"取消" forState: UIControlStateNormal];
    } else {
        [self hideActionView];
        [self.actionBtn setTitle:@"操作" forState: UIControlStateNormal];
    }
}

- (void)startBtnTapped:(UIButton *)btn
{
    for (NSIndexPath *indexPath in self.selectedIndexPaths) {
        HSDownloadItem *downloadItem = (HSDownloadItem *)[HSLectureDownloadMgr downloadMgr].downloadItems[indexPath.row];
        [downloadItem startDownload];
    }
    
//    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:0];
//    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)pauseBtnTapped:(UIButton *)btn
{
    for (NSIndexPath *indexPath in self.selectedIndexPaths) {
        HSDownloadItem *downloadItem = (HSDownloadItem *)[HSLectureDownloadMgr downloadMgr].downloadItems[indexPath.row];
        [downloadItem pauseDownload];
    }
    
//    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:0];
//    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)removeBtnTapped:(UIButton *)btn
{
    NSMutableIndexSet *removeIndexSet = [NSMutableIndexSet indexSet];
    for (NSIndexPath *indexPath in self.selectedIndexPaths) {
        HSDownloadItem *downloadItem = (HSDownloadItem *)[HSLectureDownloadMgr downloadMgr].downloadItems[indexPath.row];
        [downloadItem cancelDownload];
        [removeIndexSet addIndex:indexPath.row];
    }
    [[HSLectureDownloadMgr downloadMgr].downloadItems removeObjectsAtIndexes:removeIndexSet];
    [[HSLectureDownloadMgr downloadMgr] storeDownloadCache];
    
    [self hideActionView];
    self.shouldShowActionView = !self.shouldShowActionView;
    [self.tableView setEditing:self.shouldShowActionView animated:YES];
    [self.actionBtn setTitle:@"操作" forState: UIControlStateNormal];
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:0];
    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
    for (NSIndexPath *indexPath in self.selectedIndexPaths) {
      HSDownloadingCell *cell = (HSDownloadingCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        cell.checkmarkBtn.selected = !cell.checkmarkBtn.selected;
    }
    self.actionView.startBtn.enabled = NO;
    self.actionView.pauseBtn.enabled = NO;
    
    self.actionView.removeBtn.enabled = NO;
    if (![[HSLectureDownloadMgr downloadMgr].downloadItems count]) {
        self.actionBtn.hidden = YES;
    }else {
        self.actionBtn.hidden = NO;
    }

   }

- (void)showActionView
{
    if ([[HSLectureDownloadMgr downloadMgr].downloadItems count] == 0) { return; }
    self.actionView.hidden = NO;
    [UIView animateWithDuration:0.25 animations:^{
        CGFloat topHeight = 50.0f;
        [self.contentView setFrame:CGRectMake(0, topHeight, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-topHeight)];
    } completion:^(BOOL finished) {
        if (finished) {
            
        }
    }];
}

- (void)hideActionView
{
    
    [UIView animateWithDuration:0.25 animations:^{
        CGFloat topHeight = 0.0f;
        [self.contentView setFrame:CGRectMake(0, topHeight, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-topHeight)];
    } completion:^(BOOL finished) {
        if (finished) {
          self.actionView.hidden = YES;  
        }
    }];

}

- (void)selectAllBtnTapped:(UIButton *)btn
{
    NSInteger totalCount = [[HSLectureDownloadMgr downloadMgr].downloadItems count];
    BOOL hasSelectAll = [self hasSelectedAll];
    
    //全不选
    [self.selectedIndexPaths removeAllObjects];
    //没有完全选中就全部选中
    if (!hasSelectAll) {
        for (int row = 0; row < totalCount; row++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
            [self.selectedIndexPaths addObject:indexPath];
        }
        
    }
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:0];
    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
    [btn setSelected:[self hasSelectedAll]];
    [self showOrHideOperationButtons:nil];
}

- (BOOL)hasSelectedAll
{
    NSInteger totalCount = [[HSLectureDownloadMgr downloadMgr].downloadItems count];
    NSInteger hasSelectCount = [self.selectedIndexPaths count];
    
    BOOL hasSelectAll = (totalCount == hasSelectCount)&&(totalCount > 0);
    return hasSelectAll;
}

#pragma mark - HSDownloadingCellDelegate
- (void)checkmarkBtnTapped:(HSDownloadingCell *)cell
{
   
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        if (cell.checkmarkBtn.selected) {
            [self.selectedIndexPaths addObject:indexPath];
        } else {
            [self.selectedIndexPaths removeObject:indexPath];
        }
    
}
- (void)jumpToLectureView:(HSDownloadingCell *)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    HSDownloadItem *downloadItem = [HSLectureDownloadMgr downloadMgr].downloadItems[indexPath.row];
    if (downloadItem.lectureModel.isHs) {
        HSLectureDetailVC *nextVC = [[HSLectureDetailVC alloc] initWithNibName:@"HSLectureDetailVC" bundle:nil lectureModel:downloadItem.lectureModel isHs:YES ClassID:downloadItem.lectureClassModel.classId];
        
        [self.navigationController pushViewController:nextVC animated:YES hideBottomTabBar:YES];
    }else {
        HSLectureDetailVC *nextVC = [[HSLectureDetailVC alloc] initWithNibName:@"HSLectureDetailVC" bundle:nil lectureModel:downloadItem.lectureModel isHs:NO ClassID:downloadItem.lectureClassModel.classId];
        
        [self.navigationController pushViewController:nextVC animated:YES hideBottomTabBar:YES];
    }

}
- (void)showOrHideOperationButtons:(HSDownloadingCell *)cell {
    if (self.selectedIndexPaths.count == 0) {
        self.actionView.startBtn.enabled = NO;
        self.actionView.pauseBtn.enabled = NO;

        self.actionView.removeBtn.enabled = NO;
    

    }else {
        self.actionView.startBtn.enabled = YES;
        self.actionView.pauseBtn.enabled = YES;
        
        self.actionView.removeBtn.enabled = YES;
    }
    if (self.selectedIndexPaths.count == [self.tableView numberOfRowsInSection:0]) {
        self.actionView.selectAllBtn.selected = YES;
    }else {
        self.actionView.selectAllBtn.selected = NO;
    }
}
#pragma mark - UITableView Datasource and Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (![[HSLectureDownloadMgr downloadMgr].downloadItems count]) {
        self.actionBtn.hidden = YES;
    }else {
        self.actionBtn.hidden = NO;
    }
    return [[HSLectureDownloadMgr downloadMgr].downloadItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HSDownloadingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HSDownloadingCell"];
    HSDownloadItem *downloadItem = [HSLectureDownloadMgr downloadMgr].downloadItems[indexPath.row];
    [cell updateCellWithDownloadItem:downloadItem];
    [cell setDelegate:self];
    BOOL hasSelected = [self.selectedIndexPaths containsObject:indexPath];
    [cell.checkmarkBtn setSelected:hasSelected];
    cell.HSDocumentDisplay = ^(HSDownloadItem *downloadItem) {
        NSURL *URL = [NSURL fileURLWithPath:downloadItem.downloader.pathToFile];
//         NSLog(@"%@",downloadItem.downloader.pathToFile);
        if ([downloadItem.lectureClassModel isKindOfClass:[HSLecturePDFModel class]]) {
            if (URL) {
                // Initialize Document Interaction Controller
                self.documentInteractionController = [UIDocumentInteractionController
                                                      interactionControllerWithURL:URL];
                // Configure Document Interaction Controller
                [self.documentInteractionController setDelegate:self];
                self.documentInteractionController.name = downloadItem.lectureClassModel.name;
                
                // Preview PDF
                [self.documentInteractionController presentPreviewAnimated:YES];
            }

        }else if([downloadItem.lectureClassModel isKindOfClass:[HSLectureClassModel class]]) {
            self.moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:URL];
            self.moviePlayer.controlStyle = MPMovieControlStyleFullscreen;
            self.moviePlayer.scalingMode = MPMovieScalingModeAspectFit;
            self.moviePlayer.movieSourceType = MPMovieSourceTypeFile;
//            CGSize size = [UIScreen mainScreen].bounds.size;
            [self.moviePlayer.view setFrame:[UIScreen mainScreen].bounds];
            self.moviePlayer.initialPlaybackTime = -1.0;
            [self.moviePlayer.view setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
            //                [self presentMoviePlayerViewControllerAnimated:self.moviePlayer];
            [keyWINDOW addSubview:self.moviePlayer.view];
            // 注册一个播放结束的通知
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(myMovieFinishedCallback:)
                                                         name:MPMoviePlayerPlaybackDidFinishNotification
                                                       object:self.moviePlayer];
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willFullScreen) name:MPMoviePlayerWillEnterFullscreenNotification object:nil];
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didExitFullScreen) name:MPMoviePlayerDidExitFullscreenNotification object:nil];
//            [[NSNotificationCenter defaultCenter] addObserver:self
//                                                     selector:@selector(moviePlayerWillEnterFullscreenNotification:)
//                                                         name:MPMoviePlayerWillEnterFullscreenNotification
//                                                       object:self.moviePlayer];
//            
//            [[NSNotificationCenter defaultCenter] addObserver:self
//                                                     selector:@selector(moviePlayerWillExitFullscreenNotification:)
//                                                         name:MPMoviePlayerWillExitFullscreenNotification
//                                                       object:self.moviePlayer];
                            [self.moviePlayer play];
        }
           };
    return cell;
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    HSMineDownloadActionView *actionView = (HSMineDownloadActionView *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"HSMineDownloadActionView"];
//    
//    [actionView.startBtn addTarget:self action:@selector(startBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
//    [actionView.pauseBtn addTarget:self action:@selector(pauseBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
//    [actionView.removeBtn addTarget:self action:@selector(removeBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
//    [actionView.selectAllBtn addTarget:self action:@selector(selectAllBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
//    
//    return actionView;
//}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return NO;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    HSMineDownloadActionView *actionView = (HSMineDownloadActionView *)view;
    [actionView updateActionHeaderView];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0f;
}
- (void)willFullScreen
{
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (orientation == UIInterfaceOrientationPortrait) {
        AppDelegate  *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            delegate.allowRotation = YES;
        [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeLeft animated:YES];
         [self.moviePlayer play];
    }
}

- (void)didExitFullScreen
{
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (orientation == UIInterfaceOrientationLandscapeLeft) {
        [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait animated:YES];
    }
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
}

- (void)didChangeStatusBarOrientation
{
    //    NSLog(@"c");
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (orientation == UIInterfaceOrientationLandscapeLeft) {
        [UIView animateWithDuration:0.3 animations:^{
            self.view.transform = CGAffineTransformMakeRotation(-M_PI/2);
            CGRect bounds = [UIScreen mainScreen].bounds;
            [self.view setFrame:CGRectMake(0, 0, CGRectGetHeight(bounds), CGRectGetWidth(bounds))];
            [self.view setNeedsLayout];
        }];
    } else {
        [UIView animateWithDuration:0.3 animations:^{
            self.view.transform = CGAffineTransformIdentity;
            CGRect bounds = [UIScreen mainScreen].bounds;
            [self.view setFrame:bounds];
            [self.view setNeedsLayout];
        }];
    }
}

- (void) myMovieFinishedCallback:(NSNotification *)notify {
    MPMoviePlayerController *player = notify.object;
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerPlaybackDidFinishNotification
                                                  object:player];
    [player.view removeFromSuperview];
    // 释放视频对象
    
}
//- (void)moviePlayerWillEnterFullscreenNotification:(NSNotification*)notify
//
//{
//    
////    AppDelegate  *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    
////    delegate.allowRotation = YES;
//    
//    NSLog(@"moviePlayerWillEnterFullscreenNotification");
//  
//}
//
//- (void)moviePlayerWillExitFullscreenNotification:(NSNotification*)notify
//
//{
//    
////    AppDelegate  *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    
////    delegate.allowRotation = NO;
//    
//    [self.moviePlayer play];
//    
//    NSLog(@"moviePlayerWillExitFullscreenNotification");
//    
// 
//    
//}
- (UIViewController *) documentInteractionControllerViewControllerForPreview:
(UIDocumentInteractionController *) controller {
    
    return self;
}
@end
