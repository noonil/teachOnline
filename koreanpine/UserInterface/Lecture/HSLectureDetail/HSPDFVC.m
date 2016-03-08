//
//  HSPDFVC.m
//  koreanpine
//
//  Created by Victor on 15/10/14.
//  Copyright © 2015年 Christ. All rights reserved.
//

#import "HSPDFVC.h"
#import "HSLectureModel.h"
#import "HSLectureClassModel.h"
#import "HSMineDownloadVC.h"
#import "HSDownloadItem.h"
#import "HSLectureDownloadMgr.h"
#import "HSPDFContainerCell.h"
#import "UIImageView+WebCache.h"
#import "HSMyCollectionViewModel.h"
#import "HSMyUILabel.h"
#define screenrect [[UIScreen mainScreen]bounds]
@interface HSPDFVC ()<NSURLSessionDelegate,UIDocumentInteractionControllerDelegate>
@property (nonatomic,strong) UIDocumentInteractionController *documentInteractionController;
@property (weak, nonatomic) IBOutlet UIButton *downloadPDFBtn;
@property (weak, nonatomic) IBOutlet UIImageView *infoView;

@property (strong, nonatomic) UIScrollView *lectureDetailView;

@property (strong, nonatomic) UIImageView *lectureLogoImageView;

@property (strong, nonatomic) HSLectureModel *lectureModel;

@property(strong,nonatomic)UILabel *titleLabel;

@property (strong, nonatomic) HSMyUILabel *textLabel;

@property (strong, nonatomic) HSMyUILabel *textLabel_2;

@property (assign, nonatomic) CGFloat textLabel_2_height;

@property(strong,nonatomic)UILabel *detailLabel;

@property(strong,nonatomic) UIButton *collectButton;

@property(strong,nonatomic)  UILabel *collectNum;

//@property (strong, nonatomic) UIImageView *lectureLogoImageView;


@property (strong, nonatomic) HSLecturePDFModel *lecturePDFModel;
@end

@implementation HSPDFVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initView];
    

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeDownloadItemState:) name:kChangeDownloadItemStateNotification object:nil];

    // Do any additional setup after loading the view from its nib.
}
-(void)initView{

    
    //    [self.videoPlayView setFrame:CGRectMake(0,64, viewWidth, viewWidth*9/16)];
    //    NSLog(@"%f",self.lectureInfoView.frame.size.width);
    //    [self.lectureInfoView setFrame:CGRectMake(0, 64+viewWidth*9/16, viewWidth, 44)];
    //    [self.lectureInfoView setBackgroundColor:[UIColor whiteColor]];
    self.lectureDetailView = [[UIScrollView alloc]init];
    self.lectureDetailView.backgroundColor = [UIColor clearColor];
    [self.lectureDetailView setFrame:CGRectMake(0, self.downloadPDFBtn.frame.size.height + self.downloadPDFBtn.frame.origin.y+13, screenrect.size.width,screenrect.size.height - self.downloadPDFBtn.frame.size.height-self.infoView.frame.size.height-26-64-49)];
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
    //    [self.lectureDownloadBtn.layer setCornerRadius:3.0f];
    //    [self.lectureDownloadBtn.layer setMasksToBounds:YES];
    //    第二个label
    self.textLabel_2 = [[HSMyUILabel alloc]initWithFrame:CGRectMake(8, self.lectureLogoImageView.frame.origin.y+self.lectureLogoImageView.frame.size.height + 8,screenrect.size.width-8-8, 120)];
    
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
    }else if(i < 10000){
        collectNum = [NSString stringWithFormat:@"%d",i];
    }else{
        collectNum = [NSString stringWithFormat:@"%.1f万",i/10000.0];
    }
    self.collectNum.text = collectNum;
}


-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kChangeDownloadItemStateNotification object:nil];
}
//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
//}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateVCWithLecutreModel:(HSLectureModel *)lectureModel  pdfModel:(HSLecturePDFModel *)lecturePDFModel
{
    self.lectureModel = lectureModel;
    self.lecturePDFModel = lecturePDFModel;
    
    self.navigationController.navigationBar.topItem.title = lecturePDFModel.name;
    NSString *downloadBtnTitle = nil;
    if ([lecturePDFModel.pdfFileSize integerValue]/(1024*1024) > 0) {
        downloadBtnTitle = [NSString stringWithFormat:@"下 载 (%.1fM)",[lecturePDFModel.pdfFileSize integerValue] /(1024.0f*1024.0f)];
    }else {
        downloadBtnTitle = [NSString stringWithFormat:@"下 载 (%.2fkb)",[lecturePDFModel.pdfFileSize integerValue] /1024.0f];
    }
    
    [self.downloadPDFBtn setTitle:downloadBtnTitle forState:UIControlStateNormal];
    
    
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
    //    判断是否是今天
    NSDate *today = [NSDate dateWithTimeIntervalSinceNow:0];
    NSString *todayStr = [formatter stringFromDate:today];
    if ([updateTime isEqualToString:todayStr]) {
        updateTime = @"今天";
    }
   
//    [self.updateTimeLabel setText:modifytime];
//    [self.pdfNumLabel setText:@"2"];
//    [self.homeworkNumLabel setText:@"5"];
    
//    if (self.lectureModel.lectureDetail) {
//        NSTextStorage* textStorage = [[NSTextStorage alloc] initWithString:self.lectureModel.lectureDetail  attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.0]}];
//        [self.introduceTextView setAttributedText:textStorage];
    //    [self.detailLabel setText:lecturerDetailLabel];
    NSString  *lecturerDetailLabel = [NSString stringWithFormat:@"更新时间:%@\n课件数:%@   作业数:%@\n已有%@人浏览",updateTime,lecturePDFModel.classhourCount,lecturePDFModel.homeworkCount,[self simpleString:self.lectureModel.viewed]];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 5;// 字体的行间距
    NSDictionary *attributes = @{
                                 
                                 NSFontAttributeName:[UIFont systemFontOfSize:12],
                                 NSParagraphStyleAttributeName:paragraphStyle,
                                 NSForegroundColorAttributeName:
                                     [UIColor lightGrayColor]
                                 
                                 };
    self.detailLabel.attributedText = [[NSAttributedString alloc] initWithString:lecturerDetailLabel attributes:attributes];
    
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
        self.textLabel_2_height = [Common heightForString:string_2 FontSize:[UIFont systemFontOfSize:16.0] constrainedSize:CGSizeMake(CGRectGetWidth(screenrect)-16, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
        [self.textLabel_2 setFrame:CGRectMake(8, self.lectureLogoImageView.frame.origin.y+self.lectureLogoImageView.frame.size.height,screenrect.size.width-8-8,self.textLabel_2_height)];
        self.lectureDetailView.contentSize = CGSizeMake(0, self.detailLabel.frame.size.height+self.detailLabel.frame.origin.y+8+86*kScreenPointScale+self.textLabel_2_height+8);

        
        NSTextStorage* textStorage_2 = [[NSTextStorage alloc] initWithString:string_2  attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.0]}];
        [self.textLabel_2 setAttributedText:textStorage_2];
        //        self.lectureDetailView.attributedText = textStorage;
    }

   
    self.collectButton.selected = self.lectureModel.isCollect;
    
    if ([self.lectureModel.collectCount intValue] == 0) {
        [self.collectNum setText:@"收藏"];
    }else{
        [self.collectNum setText:[self simpleString:self.lectureModel.collectCount]];
    }
    
    [self.lectureLogoImageView sd_setImageWithURL:[NSURL URLWithString:self.lectureModel.lectureImageUrl]];
    [self updateDownloadStateBtn];
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
//分割字符串
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
//计算字符串字数
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
    HSDownloadItem *downloadItem = [[HSLectureDownloadMgr downloadMgr] downloadItemForLectureClassModel:self.lecturePDFModel];
    if ((!downloadItem)) {
        //        [self.downloadPDFBtn setBackgroundColor:kActionBtnNormalColor];
        NSString *downloadBtnTitle = nil;
        if ([self.lecturePDFModel.pdfFileSize integerValue]/(1024*1024) > 0) {
            downloadBtnTitle = [NSString stringWithFormat:@"下 载 (%.1fM)",[self.lecturePDFModel.pdfFileSize integerValue] /(1024.0f*1024.0f)];
        }else {
            downloadBtnTitle = [NSString stringWithFormat:@"下 载 (%.2fkb)",[self.lecturePDFModel.pdfFileSize integerValue] /1024.0f];
        }

        [self.downloadPDFBtn setTitle:downloadBtnTitle forState:UIControlStateNormal];
    } else {
        switch (downloadItem.downloadState) {
                
            case HSDownloadStateFailed:
            case HSDownloadStateCancelled:{
                //                [self.downloadPDFBtn setBackgroundColor:kActionBtnNormalColor];
                NSString *downloadBtnTitle = [NSString stringWithFormat:@"下 载 (%.2fkb)",[self.lecturePDFModel.pdfFileSize integerValue] /1024.0f];
                [self.downloadPDFBtn setTitle:downloadBtnTitle forState:UIControlStateNormal];
                break;
            }
            case HSDownloadStateReady:
            case HSDownloadStatePause:
            case HSDownloadStateDownloading: {
                //                [self.downloadPDFBtn setBackgroundColor:kActionBtnNormalColor];
                [self.downloadPDFBtn setTitle:@"下载中" forState:UIControlStateNormal];
                break;
            }
            case HSDownloadStateDone:{
                //                [self.downloadPDFBtn setBackgroundColor:kActionBtnNormalColor];
                [self.downloadPDFBtn setTitle:@"打 开" forState:UIControlStateNormal];
                break;
            }
            default:
                break;
        }
    }
}
- (void) changeDownloadItemState:(NSNotification *)notify {
    
    [self updateDownloadStateBtn];
}
- (void)willEnterForegroundDisplay
{
    
}
- (void)willEnterBackgroundDisplay
{
    //    __weak typeof(self) weakSelf = self;
    //    [self.homeworkModel getHomeworkInfoWithFinish:^{
    //        [weakSelf updateHomeworkInfo];
    //    }];
}

- (void)willDisplayContainerView
{
//    __weak typeof(self) weakSelf = self;
//    [self showWaitAlert:@"刷新作业数据"];
//    [self.lecturePDFModel getHomeworkInfoWithFinish:^{
//        [self hideWaitAlert];
//        [weakSelf updateHomeworkInfo];
//    }];
}
- (void)endDisplayContainerView
{
    
}
- (IBAction)downloadBtnTapped:(UIButton *)sender {
    //    NSLog(@"%@",self.lectureModel.lectureID);
    if (!self.lecturePDFModel) {return;}
    NSString *downloadBtnTitle = nil;
    if ([self.lecturePDFModel.pdfFileSize integerValue]/(1024*1024) > 0) {
        downloadBtnTitle = [NSString stringWithFormat:@"下 载 (%.1fM)",[self.lecturePDFModel.pdfFileSize integerValue] /(1024.0f*1024.0f)];
    }else {
        downloadBtnTitle = [NSString stringWithFormat:@"下 载 (%.2fkb)",[self.lecturePDFModel.pdfFileSize integerValue] /1024.0f];
    }
    if ([sender.titleLabel.text isEqualToString:downloadBtnTitle]) {
        [self.lecturePDFModel getLectureViewPathWithSucceededBlock:^(NSString *videoPath) {
            //             [self downloadFileWithUrl:videoPath];
            HSDownloadItem *downloadItem = [[HSLectureDownloadMgr downloadMgr] downloadItemForLectureClassModel:self.lecturePDFModel];
            if (!downloadItem) {
                [[HSLectureDownloadMgr downloadMgr] addDownloadItemWith:self.lecturePDFModel LectureModel:self.lectureModel autoDownload:YES];
            }
            [self updateDownloadStateBtn];
        } failedBlock:^(NSError *error) {
            [self updateDownloadStateBtn];
        }];
        
    }else if([sender.titleLabel.text isEqualToString:@"下载中"]) {
        for (UIViewController *viewCrtl in self.mainVC.navigationController.childViewControllers) {
            if ([viewCrtl isKindOfClass:[HSMineDownloadVC class]]) {
                [self.mainVC.navigationController popToViewController:viewCrtl animated:YES];
                return;
            }
        }

        HSMineDownloadVC *download = [[HSMineDownloadVC alloc] init];
        [self.navigationController pushViewController:download animated:YES];
    }else {
        //        NSURL *URL = self.
        HSDownloadItem *downloadItem = [[HSLectureDownloadMgr downloadMgr] downloadItemForLectureClassModel:self.lecturePDFModel];
        if (downloadItem.downloader.pathToFile) {
            // Initialize Document Interaction Controller
            self.documentInteractionController = [UIDocumentInteractionController
                                                  interactionControllerWithURL:[NSURL fileURLWithPath:downloadItem.downloader.pathToFile]];
            // Configure Document Interaction Controller
            [self.documentInteractionController setDelegate:self];
            self.documentInteractionController.name = self.lecturePDFModel.name;
            
            // Preview PDF
            [self.documentInteractionController presentPreviewAnimated:YES];
        }
        //                    HSMineDownloadVC *download = [[HSMineDownloadVC alloc] init];
        //            [self.navigationController pushViewController:download animated:YES];
        //      
    }
    
}



- (UIViewController *) documentInteractionControllerViewControllerForPreview:
(UIDocumentInteractionController *) controller {
    
    return self;
}
@end
