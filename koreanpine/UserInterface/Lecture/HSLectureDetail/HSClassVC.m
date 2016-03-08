//
//  HSLectureDetailContainerVC.m
//  koreanpine
//
//  Created by Christ on 15/8/15.
//  Copyright (c) 2015年 Christ. All rights reserved.
//

#import "HSClassVC.h"
#import <MediaPlayer/MediaPlayer.h>
#import "UIImageView+WebCache.h"
#import "HSMyUILabel.h"
#import "HSRuntimeMgr.h"
#import "HSLectureDownloadMgr.h"
#import "HSDownloadItem.h"
#import "HSVideoPlayView.h"
#import "HSMineDownloadVC.h"
#import "NetworkCenter.h"
#import "HSMyCollectionViewModel.h"
#import "HSOrgViewController.h"
#import "AppDelegate.h"
#import "HSLectureClassModel.h"
#import "HSMyCollectionsVC.h"

#define screenScale self.view.frame.size.width/320
#define imageAndLabelScale 3/2
#define viewWidth self.view.frame.size.width
#define itemCellScale 145/155
#define screenrect [[UIScreen mainScreen]bounds]

@interface HSClassVC ()<UIScrollViewDelegate>

@property (strong, nonatomic) IBOutlet HSVideoPlayView *videoPlayView;

@property (weak, nonatomic) IBOutlet UIView *lectureInfoView;


@property (weak, nonatomic) IBOutlet UILabel *lectureAuthurLabel;
@property (weak, nonatomic) IBOutlet UIButton *lectureDownloadBtn;




@property(strong,nonatomic)UIScrollView *lectureDetailView;

@property (strong, nonatomic) UIImageView *lectureLogoImageView;

@property (strong, nonatomic) HSLectureModel *lectureModel;

@property(strong,nonatomic)UILabel *titleLabel;

@property (strong, nonatomic) HSMyUILabel *textLabel;

@property (strong, nonatomic) HSMyUILabel *textLabel_2;

@property(assign,nonatomic)CGFloat textLabel_2_height;

@property(strong,nonatomic)UILabel *detailLabel;

@property(strong,nonatomic) UIButton *collectButton;

@property(strong,nonatomic)  UILabel *collectNum;


@property (strong, nonatomic) HSLectureClassModel *lectureClassModel;

- (IBAction)downloadBtnTapped:(UIButton *)sender;
@end

@implementation HSClassVC
//- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
//    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
//        self.navigationItem.title = @"ceshi ";
//    }return self;
//}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    [self initView];
    [self initNotifi];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

}

- (void)viewWillDisappear:(BOOL)animated
{
//    [self stopPlayVideo];
    [super viewWillDisappear:animated];
    
}

- (void)dealloc
{
    [self stopPlayVideo];
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initView
{
//    
//    [self.videoPlayView setFrame:CGRectMake(0,64, viewWidth, viewWidth*9/16)];
//    NSLog(@"%f",self.lectureInfoView.frame.size.width);
//    [self.lectureInfoView setFrame:CGRectMake(0, 64+viewWidth*9/16, viewWidth, 44)];
    [self.lectureInfoView setBackgroundColor:[UIColor whiteColor]];

    self.lectureDetailView = [[UIScrollView alloc]init];
    self.lectureDetailView.backgroundColor = [UIColor clearColor];
    [self.lectureDetailView setFrame:CGRectMake(0, self.videoPlayView.frame.size.height + self.lectureInfoView.frame.size.height, screenrect.size.width,screenrect.size.height - self.videoPlayView.frame.size.height - self.lectureInfoView.frame.size.height -64)];
    [self.view addSubview:self.lectureDetailView];

  

    self.titleLabel= [[UILabel alloc]initWithFrame:CGRectMake(8, 8, self.lectureDetailView.bounds.size.width-16, 25)];
    self.titleLabel.text = @"微课简介";
    [self.titleLabel setFont:[UIFont systemFontOfSize:18.0f]];
    self.titleLabel.textColor = [UIColor lightGrayColor];
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.lectureDetailView addSubview:self.titleLabel];
    
    self.detailLabel= [[UILabel alloc]initWithFrame:CGRectMake(8, 8+25+8, self.lectureDetailView.bounds.size.width/2, 60)];
    self.detailLabel.numberOfLines = 3;
    [self.lectureDetailView addSubview:self.detailLabel];
    
//    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRect:CGRectMake(5, self.lectureDetailView.bounds.size.height-140, 150, 120)];
//    [self.lectureDetailView.textContainer setExclusionPaths:@[bezierPath]];
//    [self.lectureDownloadBtn setHidden:YES];
    
   
    
//    self.lectureDetailView.backgroundColor = [UIColor whiteColor];
//    [self.lectureDetailView setEditable:NO];
    self.lectureLogoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(8,self.detailLabel.frame.size.height+self.detailLabel.frame.origin.y+8, 155*kScreenPointScale, 86*kScreenPointScale)];
    [self.lectureLogoImageView setContentMode:UIViewContentModeScaleAspectFill];
    [self.lectureLogoImageView setClipsToBounds:YES];
    [self.lectureDetailView addSubview:self.lectureLogoImageView];
    

    
// 第一个label
    self.textLabel = [[HSMyUILabel alloc]initWithFrame:CGRectMake(self.lectureLogoImageView.frame.size.width+30, self.lectureLogoImageView.frame.origin.y,screenrect.size.width-self.lectureLogoImageView.frame.size.width-30-8, 86*kScreenPointScale)];
    
    [self.textLabel setFont:[UIFont systemFontOfSize:16.0f]];
    self.textLabel.numberOfLines = 0;
    self.textLabel.verticalAlignment = VerticalAlignmentTop;
    self.textLabel.textColor = [UIColor lightGrayColor];
    [self.lectureDetailView addSubview:self.textLabel];
    [self.lectureDownloadBtn.layer setCornerRadius:3.0f];
    [self.lectureDownloadBtn.layer setMasksToBounds:YES];
    //    第二个label
    self.textLabel_2 = [[HSMyUILabel alloc]init];
    
    [self.textLabel_2 setFont:[UIFont systemFontOfSize:16.0f]];
    self.textLabel_2.numberOfLines = 0;
    self.textLabel_2.verticalAlignment = VerticalAlignmentTop;
    self.textLabel_2.textColor = [UIColor lightGrayColor];
    [self.lectureDetailView addSubview:self.textLabel_2];
    
//    添加收藏按钮
    self.collectButton = [[UIButton alloc]initWithFrame:CGRectMake(self.lectureDetailView.bounds.size.width-48, 15, 30, 30)];
//    NSLog(@"%f",self.view.bounds.size.width);
    
    [self.collectButton addTarget:self action:@selector(changeCollect) forControlEvents:UIControlEventTouchUpInside];
    [self.collectButton setImage:[UIImage imageNamed:@"收藏01_f"] forState:UIControlStateNormal];
    [self.collectButton setImage:[UIImage imageNamed:@"收藏01_n"] forState:UIControlStateSelected];

    [self.lectureDetailView addSubview:self.collectButton];
    
//    添加收藏数目
    self.collectNum = [[UILabel alloc]initWithFrame:CGRectMake(screenrect.size.width-58, 46, 50, 20)];
    self.collectNum.font = [UIFont systemFontOfSize:12.0f];
    self.collectNum.textColor = [UIColor lightGrayColor];
    
    self.collectNum.textAlignment = NSTextAlignmentCenter;
    [self.lectureDetailView addSubview:self.collectNum];
    //    类似classmodel
 
    self.lectureDetailView.bounces = NO;
    self.lectureDetailView.showsVerticalScrollIndicator = NO;
   
}
-(void)changeCollect{
    self.collectButton.selected = !self.collectButton.selected;
    //    点击时刷新我的收藏界面
    [[NSNotificationCenter defaultCenter]postNotificationName:@"mycollectionReloadRefresh" object:nil];
    //
    ////    刷新课程界面
    [[NSNotificationCenter defaultCenter]postNotificationName:@"orgRefreshNotification" object:nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"hsRefreshNotification" object:nil];
    int i = [self.lectureModel.collectCount intValue];
    if(self.collectButton.selected == NO){
        //    刷新数据源
        [HSMyCollectionViewModel getCollectionViewModel:self.lectureModel.lectureID courseName:self.lectureModel.lectureName succeededHandler:^(HSMyCollectionModel *lectureModel) {
            //        NSLog(@"%@",lectureModel.collectInfoID);
            self.lectureModel.collectInfoID = lectureModel.collectInfoID;
            [[NetworkCenter shareCenter]deleteCollectionCell:self.lectureModel.lectureID collectID:self.lectureModel.collectInfoID isHS:self.lectureModel.hsCourseFlag];
        } failedHandler:^(NSError *error) {
            
        }];
        [[NetworkCenter shareCenter]deleteCollectionCell:self.lectureModel.lectureID collectID:self.lectureModel.collectID isHS:self.lectureModel.hsCourseFlag];
        i--;
    
        self.lectureModel.isCollect = NO;
        
    }else{
        [[NetworkCenter shareCenter]addCollectionCell:self.lectureModel.lectureID isHS:self.lectureModel.hsCourseFlag];
        i++;
        self.lectureModel.isCollect = YES;
    }
    self.lectureModel.collectCount = [NSString stringWithFormat:@"%d",i];
    NSString *collectNum = nil;
    if (i >=100000000) {
        collectNum  = [NSString stringWithFormat:@"%.1f亿",i/100000000.0];
    }else if(i < 10000 && i>0){
        collectNum = [NSString stringWithFormat:@"%d",i];
    }else if(i == 0){
        collectNum = @"收藏";
    }else{
        collectNum = [NSString stringWithFormat:@"%.1f万",i/10000.0];
    }

    self.collectNum.text = collectNum;
}


- (void)initNotifi
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recvDownloadStateChange:) name:kNotifiLoadLectureStateChange object:nil];
    
//    此通知获取播放器的播放状态变化
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(WillChangeStatusBarOrientation) name:UIApplicationWillChangeStatusBarOrientationNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChangeStatusBarOrientation) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willFullScreen) name:MPMoviePlayerWillEnterFullscreenNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didExitFullScreen) name:MPMoviePlayerDidExitFullscreenNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeDownloadItemState:) name:kChangeDownloadItemStateNotification object:nil];
}

- (void)unInitNotifi
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)playVideoBtnTapped:(UIButton *)btn
{
    [self.videoPlayView playVideo];
}


- (void)updateVCWithLecutreModel:(HSLectureModel *)lectureModel  classModel:(HSLectureClassModel *)lectureClassModel
{
    self.lectureModel = lectureModel;
    self.lectureClassModel = lectureClassModel;
    self.navigationController.navigationBar.topItem.title = lectureClassModel.name;
    if (self.lectureClassModel.videoPath.length > 0) {
        [self startPlayVideoWithVideoPath:self.lectureClassModel.videoPath];
    } else {
        __weak typeof(self) weakSelf = self;
        [self.lectureClassModel getLectureViewPathWithSucceededBlock:^(NSString *videoPath) {
            [weakSelf startPlayVideoWithVideoPath:videoPath];
        } failedBlock:^(NSError *error) {
            
        }];
    }
    
    [self updateDownloadStateBtn];
    self.navigationItem.title = self.lectureClassModel.name;
    NSString *lecturerName = @"佚名";
    if (self.lectureClassModel.lecturerName.length > 0 && ![self.lectureClassModel.lecturerName  isEqual: @"(null)"]) {
        lecturerName = [NSString stringWithFormat:@"课件讲师:%@",self.lectureClassModel.lecturerName];
    }else{
        lecturerName = [NSString stringWithFormat:@"课件讲师:%@",lecturerName];
    }
    
    [self.lectureAuthurLabel setText:lecturerName];
    
    [self.lectureLogoImageView sd_setImageWithURL:[NSURL URLWithString:self.lectureModel.lectureImageUrl]];
    
    if (self.lectureModel.lectureDetail) {
//        self.lectureModel.lectureDetail = @" 编写一个截取字符串的函数，输入为一个字符串和字节数，输出为按字节截取的字符串。 但是要保证汉字不被截半个，如“我ABC”4，应该截为“我AB”，输入“我ABC汉DEF”，6，应该输出为“我ABC”而不是“我ABC+汉的半个”";
        int i = [self separatedstring:self.lectureModel.lectureDetail fontsize:[UIFont systemFontOfSize:16.0] cgrect:self.textLabel.frame];
        NSString *string_1 = [self.lectureModel.lectureDetail substringToIndex:i];
        NSTextStorage* textStorage = [[NSTextStorage alloc] initWithString:string_1  attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.0]}];
        [self.textLabel setAttributedText:textStorage];
        NSString *string_2 = [self.lectureModel.lectureDetail substringFromIndex:i];
        if (i == [self convertToInt:self.lectureModel.lectureDetail]) {
            string_2 = @"";
        }
        NSTextStorage* textStorage_2 = [[NSTextStorage alloc] initWithString:string_2  attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.0]}];
        [self.textLabel_2 setAttributedText:textStorage_2];
        self.textLabel_2_height = [Common heightForString:string_2 FontSize:[UIFont systemFontOfSize:16.0] constrainedSize:CGSizeMake(CGRectGetWidth(screenrect)-16, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
        [self.textLabel_2 setFrame:CGRectMake(8, self.lectureLogoImageView.frame.origin.y+self.lectureLogoImageView.frame.size.height,screenrect.size.width-8-8,self.textLabel_2_height)];
        self.lectureDetailView.contentSize = CGSizeMake(0, self.detailLabel.frame.size.height+self.detailLabel.frame.origin.y+8+86*kScreenPointScale+self.textLabel_2_height+8);
//        self.lectureDetailView.attributedText = textStorage;
    }
//    if ([self.lectureModel.hsCourseFlag integerValue] == 1) {
//        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//        [formatter setDateStyle:NSDateFormatterMediumStyle];
//        [formatter setTimeStyle:NSDateFormatterShortStyle];
//        [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"]; //
//        
//        NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
//        [formatter setTimeZone:timeZone];
//        
//        NSDate* date = [formatter dateFromString:self.lectureModel.updateTime]; //------------将字符串
//        self.lectureModel.updateTime = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];
//    }
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"beijing"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"MM月dd日"];
     NSString *updateTime = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[lectureModel.updateTime doubleValue]/1000]];
    NSDate *today = [NSDate dateWithTimeIntervalSinceNow:0];
    NSString *todayStr = [formatter stringFromDate:today];
    if ([updateTime isEqualToString:todayStr]) {
        updateTime = @"今天";
    }
    NSString  *lecturerDetailLabel = [NSString stringWithFormat:@"更新时间:%@\n课件数:%@   作业数:%@\n已有%@人浏览",updateTime,lectureClassModel.classhourCount,lectureClassModel.homeworkCount,[self simpleString:self.lectureModel.viewed]];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 5;// 字体的行间距
    NSDictionary *attributes = @{
                                 
                                 NSFontAttributeName:[UIFont systemFontOfSize:12],
                                 NSParagraphStyleAttributeName:paragraphStyle,
                                 NSForegroundColorAttributeName:
                                     [UIColor lightGrayColor]
                                 
                                 };
    self.detailLabel.attributedText = [[NSAttributedString alloc] initWithString:lecturerDetailLabel attributes:attributes];
    
    
//    [self.detailLabel setText:lecturerDetailLabel];
    if ([self.lectureModel.collectCount intValue] == 0) {
        [self.collectNum setText:@"收藏"];
    }else{
        [self.collectNum setText:[self simpleString:self.lectureModel.collectCount]];
    }
    
    self.collectButton.selected = self.lectureModel.isCollect;
    
}
-(NSString *)simpleString:(NSString *)string{
    NSString *simpledString = nil;
    if ([string floatValue] >=100000000) {
        simpledString = [NSString stringWithFormat:@"%.1f亿",[string floatValue]/100000000];
    }else if([string floatValue]<10000){
        simpledString = [NSString stringWithFormat:@"%d",[string intValue]];
    }else{
        simpledString = [NSString stringWithFormat:@"%.1f万",[string floatValue]/10000];
    }
    return simpledString;
}
-(int)separatedstring:(NSString *)string fontsize:(UIFont *)font cgrect:(CGRect)rect{
    int j = [self convertToInt:string];
    for (int i = j; i >0; i--) {
        string = [string substringToIndex:i];
         CGFloat height = [Common heightForString:string FontSize:font constrainedSize:CGSizeMake(CGRectGetWidth(rect), CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
        if (height <= CGRectGetHeight(rect)) {
            return i;
        }
    }
    return [self convertToInt:string];
}
-  (int)convertToInt:(NSString*)strtemp {
    
    int strlength = 0;
    char* p = (char*)[strtemp cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0 ; i<[strtemp lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
        if (*p) {
            p++;
            strlength++;
        }
        else {
            p++;
        }
    }
    return (strlength+1)/2;
    
}
- (void)updateDownloadStateBtn
{

    NSString *downloadBtnTitle = [NSString stringWithFormat:@"下 载 (%.1fM)",self.lectureClassModel.fileSize/(1024.0f*1024.0f)];
    HSDownloadItem *downloadItem = [[HSLectureDownloadMgr downloadMgr] downloadItemForLectureClassModel:self.lectureClassModel];
    if ((!downloadItem)) {
        [self.lectureDownloadBtn setBackgroundColor:kActionBtnNormalColor];
        
        [self.lectureDownloadBtn setTitle:downloadBtnTitle forState:UIControlStateNormal];
    } else {
        switch (downloadItem.downloadState) {
            
            case HSDownloadStateFailed:
            case HSDownloadStateCancelled:{
                [self.lectureDownloadBtn setBackgroundColor:kActionBtnNormalColor];
                [self.lectureDownloadBtn setTitle:downloadBtnTitle forState:UIControlStateNormal];
                break;
            }
            case HSDownloadStateReady:{
                [self.lectureDownloadBtn setBackgroundColor:kActionBtnNormalColor];
                [self.lectureDownloadBtn setTitle:@"等待中" forState:UIControlStateNormal];
                break;
            }
            case HSDownloadStatePause:
            case HSDownloadStateDownloading: {
                [self.lectureDownloadBtn setBackgroundColor:kActionBtnNormalColor];
                [self.lectureDownloadBtn setTitle:@"下载中" forState:UIControlStateNormal];
                break;
            }
            case HSDownloadStateDone:{
                [self.lectureDownloadBtn setBackgroundColor:kActionBtnNormalColor];
                [self.lectureDownloadBtn setTitle:@"已下载" forState:UIControlStateNormal];
                break;
            }
            default:
                break;
        }
    }
}

- (void)willEnterBackgroundDisplay
{
    [self.videoPlayView pausePlayVideo];
}

- (void)willEnterForegroundDisplay
{
    if ([self.videoPlayView isPaused]) {
        [self.videoPlayView playVideo];
    }
}

- (void)willDisplayContainerView
{
    
}

- (void)endDisplayContainerView
{
    if (![self.videoPlayView.moviePlayer isFullscreen]) {
        [self.videoPlayView stopPlayVideo];
    }

}

#pragma mark -

- (IBAction)downloadBtnTapped:(UIButton *)sender {
     NSString *downloadBtnTitle = [NSString stringWithFormat:@"下 载 (%.1fM)",self.lectureClassModel.fileSize/(1024.0f*1024.0f)];
    if (!self.lectureClassModel) { return; }
    if (![self.lectureDownloadBtn.titleLabel.text isEqualToString:downloadBtnTitle]) {
        for (UIViewController *viewCrtl in self.mainVC.navigationController.childViewControllers) {
            if ([viewCrtl isKindOfClass:[HSMineDownloadVC class]]) {
                [self.mainVC.navigationController popToViewController:viewCrtl animated:YES];
                return;
            }
        }
        HSMineDownloadVC *download = [[HSMineDownloadVC alloc] init];
        [self.navigationController pushViewController:download animated:YES];
        return;
    }
    HSDownloadItem *downloadItem = [[HSLectureDownloadMgr downloadMgr] downloadItemForLectureClassModel:self.lectureClassModel];
    if (!downloadItem) {
        [[HSLectureDownloadMgr downloadMgr] addDownloadItemWith:self.lectureClassModel LectureModel:self.lectureModel autoDownload:YES];
    }
    [self updateDownloadStateBtn];

}

- (void)recvDownloadStateChange:(NSNotification *)notifi
{
    [self updateDownloadStateBtn];
}

#pragma mark - Video Action
- (IBAction)playBtnTapped:(UIButton *)sender {
    
    [self.videoPlayView playVideo];
}

- (void)startPlayVideoWithVideoPath:(NSString *)videoPath
{
//    [self.videoPlayView setContentURL:[NSURL URLWithString:videoPath]];
//    [self.videoPlayView play];
    [self.videoPlayView.moviePlayer setContentURL:[NSURL URLWithString:videoPath]];
    if (![self.mainVC hasShownLeftView]) {
        [self.videoPlayView playVideo];
    }
}

- (void)stopPlayVideo
{
    [self.videoPlayView stopPlayVideo];
}

//当播放器的播放状态发生变化时的通知
- (void)videoPlayStateDidChange:(NSNotification *)notifi
{
//    DLog(@"state change = %ld", (long)self.videoPlayView.moviePlayer.playbackState);
//    switch (self.videoPlayView.moviePlayer.playbackState) {
//        case MPMoviePlaybackStatePlaying:
//            break;
//        case MPMoviePlaybackStatePaused:
//        case MPMoviePlaybackStateStopped:{
//            break;
//        }
//        default:
//            break;
//    }
}

- (void)videoPlayerReadyForDisplay:(NSNotification *)notifi
{
    DLog(@"ready for display");
}

//- (void)willFullScreen
//{
//    AppDelegate  *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//            delegate.allowRotation = YES;
//    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
//    if (orientation == UIInterfaceOrientationPortrait) {
//
//        [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeLeft animated:YES];
//        [self.videoPlayView.moviePlayer play];
//    }
//    }
- (void)willFullScreen
{
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (orientation == UIInterfaceOrientationPortrait) {
        AppDelegate  *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        delegate.allowRotation = YES;
        [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeLeft animated:YES];
        [self.videoPlayView.moviePlayer play];
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
- (void) changeDownloadItemState:(NSNotification *)notify {

    [self updateDownloadStateBtn];
}
- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    [self.lectureInfoView setFrame:CGRectMake(CGRectGetMinX(self.lectureInfoView.frame), CGRectGetMaxY(self.videoPlayView.frame), CGRectGetWidth(self.lectureInfoView.frame), CGRectGetHeight(self.lectureInfoView.frame))];
    
    [self.lectureDetailView setFrame:CGRectMake(CGRectGetMinX(self.lectureDetailView.frame), CGRectGetMaxY(self.lectureInfoView.frame), CGRectGetWidth(self.lectureDetailView.frame), CGRectGetHeight(self.lectureDetailView.frame))];
    
    //       NSLog(@"d");
//    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
//    if (orientation == UIInterfaceOrientationLandscapeLeft) {
//        [self.videoPlayView setFrame:self.view.bounds];
//        [self.videoPlayView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
//    } else {
//        [self.videoPlayView setFrame:CGRectMake(0, 0, 300, 300)];
//        [self.videoPlayView setCenter:CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds)-40)];
//    }
    
}

- (void)WillChangeStatusBarOrientation
{
    
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

- (BOOL)shouldAutorotate
{
//    NSLog(@"k");
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}


@end
