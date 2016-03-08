//
//  HSHomeworkVC.m
//  koreanpine
//
//  Created by Christ on 15/8/17.
//  Copyright (c) 2015年 Christ. All rights reserved.
//

#import "HSHomeworkVC.h"
#import "HSHomeworkDetailVC.h"
#import "UIImageView+WebCache.h"
#import "HSMyCollectionViewModel.h"
#import "HSMyUILabel.h"
#define screenrect [[UIScreen mainScreen]bounds]
@interface HSHomeworkVC ()
@property (weak, nonatomic) IBOutlet UIView *infoView;
@property (weak, nonatomic) IBOutlet UILabel *totalCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *graspStateLabel;
@property (weak, nonatomic) IBOutlet UIButton *doHomeworkBtn;
@property (strong, nonatomic) UIScrollView *lectureDetailView;


@property (strong, nonatomic) UIImageView *lectureLogoImageView;

@property (strong, nonatomic) HSLectureModel *lectureModel;

@property(strong,nonatomic)UILabel *titleLabel;

@property (strong, nonatomic) HSMyUILabel *textLabel;

@property (strong, nonatomic) HSMyUILabel *textLabel_2;

@property (assign,nonatomic)CGFloat textLabel_2_height;

@property(strong,nonatomic)UILabel *detailLabel;

@property(strong,nonatomic) UIButton *collectButton;

@property(strong,nonatomic) UILabel *collectNum;





@property (strong, nonatomic) HSLectureHomeworkModel *homeworkModel;

@end

@implementation HSHomeworkVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self willDisplayContainerView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initView
{
    [self.infoView.layer setCornerRadius:3.0f];
    [self.infoView.layer setMasksToBounds:YES];
    
    [self.doHomeworkBtn.layer setCornerRadius:3.0f];
    [self.doHomeworkBtn.layer setMasksToBounds:YES];
    
    
    //    [self.videoPlayView setFrame:CGRectMake(0,64, viewWidth, viewWidth*9/16)];
    //    NSLog(@"%f",self.lectureInfoView.frame.size.width);
    //    [self.lectureInfoView setFrame:CGRectMake(0, 64+viewWidth*9/16, viewWidth, 44)];
//    [self.lectureInfoView setBackgroundColor:[UIColor whiteColor]];
    self.lectureDetailView = [[UIScrollView alloc]init];
    self.lectureDetailView.backgroundColor = [UIColor clearColor];
    [self.lectureDetailView setFrame:CGRectMake(0, self.doHomeworkBtn.frame.size.height + self.doHomeworkBtn.frame.origin.y+13, screenrect.size.width,screenrect.size.height - self.doHomeworkBtn.frame.size.height-self.infoView.frame.size.height-26-64-49)];
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

- (void)updateVCWithLecutreModel:(HSLectureModel *)lectureModel  homeworkModel:(HSLectureHomeworkModel *)homeworkModel
{
    self.lectureModel = lectureModel;
    self.homeworkModel = homeworkModel;
    self.navigationController.navigationBar.topItem.title = homeworkModel.name;
    self.navigationItem.title = self.homeworkModel.name;
//    NSString *lecturerName = @"佚名";

    
    [self.lectureLogoImageView sd_setImageWithURL:[NSURL URLWithString:self.lectureModel.lectureImageUrl]];
    
    if (self.lectureModel.lectureDetail) {
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

    NSString *updateTime = nil;
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
    updateTime = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[lectureModel.updateTime doubleValue]/1000]];
//    判断是否是今天
        NSDate *today = [NSDate dateWithTimeIntervalSinceNow:0];
        NSString *todayStr = [formatter stringFromDate:today];
        if ([updateTime isEqualToString:todayStr]) {
            updateTime = @"今天";
        }
    
        NSString  *lecturerDetailLabel = [NSString stringWithFormat:@"更新时间:%@\n课件数:%@   作业数:%@\n已有%@人浏览",updateTime,homeworkModel.classhourCount,homeworkModel.homeworkCount,[self simpleString:self.lectureModel.viewed]];
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

- (IBAction)doHomeworkBtnTapped:(UIButton *)sender {
    HSHomeworkDetailVC *nextVC = [[HSHomeworkDetailVC alloc] initWithHomeworkModel:self.homeworkModel];
    [self.mainVC.navigationController pushViewController:nextVC animated:YES];
}

- (void)updateHomeworkInfo
{
     [self.totalCountLabel setText:[NSString stringWithFormat:@"作业题数：%ld道",(unsigned long)self.homeworkModel.totalCount]];
    [self.rightCountLabel setText:[NSString stringWithFormat:@"答对题数：%ld道",(long)self.homeworkModel.rightNum]];
    NSAttributedString *masterDegreeStr = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.1f%%",self.homeworkModel.masterDegree] attributes:@{NSForegroundColorAttributeName:RGBACOLOR(161, 82, 4, 1.0),NSFontAttributeName:[UIFont systemFontOfSize:15.0f]}];
    NSMutableAttributedString *graspText = [[NSMutableAttributedString alloc] initWithString:@"掌握度：" attributes:@{NSForegroundColorAttributeName:RGBCOLOR(169, 169, 169),NSFontAttributeName:[UIFont systemFontOfSize:15.0f]}];
    [graspText appendAttributedString:masterDegreeStr];
    [self.graspStateLabel setAttributedText:graspText];
    

    
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



- (void)willEnterBackgroundDisplay
{
    __weak typeof(self) weakSelf = self;
    [self.homeworkModel getHomeworkInfoWithFinish:^{
        [weakSelf updateHomeworkInfo];
    }];
}

- (void)willEnterForegroundDisplay
{

}

- (void)willDisplayContainerView
{
    __weak typeof(self) weakSelf = self;
    [self showWaitAlert:@"刷新作业数据"];
    [self.homeworkModel getHomeworkInfoWithFinish:^{
        [self hideWaitAlert];
        [weakSelf updateHomeworkInfo];
    }];
}

- (void)endDisplayContainerView
{
    
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
     __weak typeof(self) weakSelf = self;
    [self.homeworkModel getHomeworkInfoWithFinish:^{
        [self hideWaitAlert];
        [weakSelf updateHomeworkInfo];
    }];
}
@end
