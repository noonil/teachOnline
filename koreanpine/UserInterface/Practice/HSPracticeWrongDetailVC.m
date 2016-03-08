//
//  HSPracticeWrongDetailVC.m
//  koreanpine
//
//  Created by 陶山强 on 15/11/6.
//  Copyright © 2015年 Christ. All rights reserved.
//

#import "HSPracticeWrongDetailVC.h"





#import "HSLoginMgr.h"
#import "HSPractcieViewAnswerContainerCell.h"
#import "HSPracticeDoHomeworkContainerCell.h"
#import "HSExerciseDetailViewModel.h"
#import "HSTimerLabel.h"
#import "HSDoHomeworkViewModel.h"
#import "HSLectureClassModel.h"
#import "HSExerciseButton.h"
#import "UIView+WTXM.h"
#define screenRect [[UIScreen mainScreen]bounds]
@interface HSPracticeWrongDetailVC ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIAlertViewDelegate,YH_ArrayDataLoadDelegate,UIActionSheetDelegate>
//@property (weak, nonatomic) IBOutlet UIView *timingView;
//@property (weak, nonatomic) IBOutlet UIButton *firstBtn;
//@property (weak, nonatomic) IBOutlet UIButton *viewWrongBtn;
@property (strong, nonatomic) UIButton *doneBtn;
@property (strong,nonatomic)UIButton *confirmButton;
@property (strong, nonatomic) UICollectionView *yhCollectionView;
@property (nonatomic,strong) HSTimerLabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIView *classActionView;
//@property (strong, nonatomic) HSExerciseDetailViewModel *detailViewModel;
@property (nonatomic,strong) NSMutableArray *questionButtons;
@property (nonatomic,strong) UIButton *selectedBtn;
@property (nonatomic,strong) NSMutableArray *wrongListArray;
@end

@implementation HSPracticeWrongDetailVC


#pragma mark -共有方法
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [self initData];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(confirmBtnTapped:) name:@"confirmBtnTappedNotify" object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(exerciseBtnBeChoosed:) name:kExerciseBtnDidTappedNotification object:nil];
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.yhCollectionView setContentOffset:CGPointMake(screenRect.size.width*self.selectedIndex, 0)];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kExerciseBtnDidTappedNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"confirmBtnTappedNotify" object:nil];
}
#pragma mark -代理方法||数据源方法
#pragma mark - UICollectionView Datasource and Delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger count = [self.detailViewModel contentCount];

    return count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
//    if (aCell.practiceDoHomeWorkVC.confirmButton.selected) {
//        self.detailViewModel.showAnswers = YES;
//    }
    self.selectedIndex = indexPath.row;
    HSDoHomeworkViewModel *doHomeworkViewModel = (HSDoHomeworkViewModel *)[self.detailViewModel contentAtIndex:indexPath.row];
    self.doHomeWorkViewModel = doHomeworkViewModel;
    
    if (self.detailViewModel.showAnswers) {
        
        HSPractcieViewAnswerContainerCell *bCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HSPractcieViewAnswerContainerCell" forIndexPath:indexPath];
        [bCell.practiceViewAnswerVC updateViewAnswerVCWith:doHomeworkViewModel];
        return bCell;
    } else {
        
        HSPracticeDoHomeworkContainerCell *aCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HSPracticeDoHomeworkContainerCell" forIndexPath:indexPath];
        [aCell.practiceDoHomeWorkVC updateDoHomeworkVCWith:doHomeworkViewModel];
        return aCell;
    }
}
- (void)confirmBtnTapped:(NSNotification *)notify
{
//    HSDoHomeworkViewModel *doHomeworkViewModel = (HSDoHomeworkViewModel *)notify.object;
    [self.doHomeWorkViewModel submitDict];
//    [self.detailViewModel finishDoExercise];
    self.detailViewModel.showAnswers = YES;
    [self refreshPracticeDetailView];
//    [self.yhCollectionView setContentOffset:CGPointZero];
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return  collectionView.frame.size;
}
- (void)refreshPracticeDetailView
{
    [self.yhCollectionView reloadData];
//    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:index inSection:0];
//    [self.yhCollectionView reloadItemsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil]];
//    NSString *doneBtnTitle = @"移除";
//    [self.doneBtn setTitle:doneBtnTitle forState:UIControlStateNormal];
//    [self.doneBtn sizeToFit];
    
    if (self.detailViewModel.showAnswers) {
        
//        for (UIView *view in self.timingView.subviews) {
//            if ([view isKindOfClass:[HSTimerLabel class]]) {
//                [view removeFromSuperview];
//            }
//        }
        self.timeLabel = nil;
//        for (int i=0; i<self.detailViewModel.contentCount; i++) {
        NSInteger i = index;
            HSDoHomeworkViewModel *doHomeworkVM = (HSDoHomeworkViewModel *)[self.detailViewModel contentAtIndex:i];
            BOOL isAnswer = [doHomeworkVM.questionModel.answer isEqualToString:doHomeworkVM.questionModel.userAnswer];
            HSExerciseButton *btn = self.questionButtons[i];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            if (isAnswer) {
                btn.selected = YES;
                btn.answerType = ExerciseAnswerTypeRight;
                btn.selected = NO;
            }else {
                btn.selected = YES;
                btn.answerType = ExerciseAnswerTypeWrong;
                btn.selected = NO;
            }
//        }
        
    } else {
        for (HSExerciseButton *btn in self.questionButtons) {
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
            btn.selected = YES;
            btn.answerType = ExerciseAnswerTypeNUll;
            btn.selected = NO;
        }
//        HSTimerLabel *label = [[HSTimerLabel alloc] initWithFrame:CGRectMake(self.view.wid-80, 2, 80, 40)];
//        [self.timingView addSubview:label];
//        self.timeLabel = label;
//        [self.timeLabel startTimer];
    }

    //显隐
//    [self.viewWrongBtn setHidden:!self.detailViewModel.showAnswers];
    //是否选中状态
//    [self.viewWrongBtn setSelected:self.detailViewModel.showWrongQuestions];
    //背景色
//    UIColor *viewWrongBtnBgColor = self.viewWrongBtn.selected?kActionBtnSelectColor:kActionBtnNormalColor;
//    [self.viewWrongBtn setBackgroundColor:viewWrongBtnBgColor];
    
//    [self updateTimingView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat pageNum = scrollView.contentOffset.x/self.view.bounds.size.width;
    NSInteger num = 20;
    NSUInteger page = (int)(pageNum + 0.5);
    if (page != num) {
        self.selectedBtn.selected = NO;
        num = page;
    }
    UIButton *btn = self.questionButtons[page];
    btn.selected = YES;
    self.selectedBtn = btn;
    
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
        NSInteger currentPage = scrollView.contentOffset.x/CGRectGetWidth(scrollView.frame);
        self.detailViewModel.currentIndexPath = [NSIndexPath indexPathForRow:currentPage inSection:0];
//        [self updateTimingView];
    }
    if (!self.detailViewModel.showAnswers && scrollView.contentOffset.x == self.view.wid*(self.detailViewModel.contentCount-1)) {
        [self showAlertView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger currentPage = scrollView.contentOffset.x/CGRectGetWidth(scrollView.frame);
    self.detailViewModel.currentIndexPath = [NSIndexPath indexPathForRow:currentPage inSection:0];
//    [self updateTimingView];
}

#pragma mark -
- (void)arrayDataMgr:(YH_ArrayDataMgr *)arrayDataMgr didFinishFetch:(CHFetchType)fetchType succeed:(BOOL)succeed error:(NSError *)error
{
    
    if (succeed) {
//        [self refreshPracticeDetailView];
        [self hideWaitAlert];
    }else{
        
    }
    
  
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            
            break;
        case 1:
            [self.detailViewModel reDoExercise];
            //            [self refreshExerciseDetailView];
            [self.yhCollectionView setContentOffset:CGPointZero];
            
            break;
        case 2:
            [self.navigationController popViewControllerAnimated:YES];
            break;
            
        default:
            break;
    }
}
#pragma mark -私有方法
- (void)initView
{
    self.title = @"错题本";

    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:self.backBtn];
    self.navigationItem.leftBarButtonItem = backItem;
    
    self.doneBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 27)];
    [self.doneBtn setBackgroundColor:RGBCOLOR(72, 95, 192)];
    [self.doneBtn.layer setCornerRadius:3.0f];
    [self.doneBtn.layer setMasksToBounds:YES];
    [self.doneBtn setTitle:@"移除" forState:UIControlStateNormal];
    [self.doneBtn.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
    [self.doneBtn addTarget:self action:@selector(deleteBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    

    
    UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithCustomView:self.doneBtn];
    self.navigationItem.rightBarButtonItem = doneItem;

    [self.yhCollectionView setBounces:NO];
//    self.detailViewModel = [[HSPracticeWrongViewModel alloc]init];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.selectedIndex inSection:0];
    self.detailViewModel.currentIndexPath = indexPath;
    [self.detailViewModel setDelegate:self];
    
    
    [self.view addSubview:self.yhCollectionView];
   

}

//- (IBAction)viewWrongBtnTapped:(UIButton *)sender {
//    if (self.detailViewModel.showWrongQuestions) {
//        [self.detailViewModel viewAllQuestions];
//    } else {
//        [self.detailViewModel viewWrongQuestions];
//    }
//    
//    [self refreshExerciseDetailView];
//    if ([self.detailViewModel contentCount] > self.detailViewModel.currentIndexPath.row) {
//        [self.yhCollectionView setContentOffset:CGPointZero];
//    }
//    
//}
- (void)backAction:(id)sender
{
//    [[NSNotificationCenter defaultCenter]postNotificationName:@"wrongListRefreshNotification" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initData
{
//    [self.detailViewModel fetchLatest];
}
- (void)deleteBtnTapped:(UIButton *)btn
{
    self.doneBtn.enabled = NO;
    
 
    [self deleteWrongPractice:self.doHomeWorkViewModel.questionModel.practiceWrongIdStr success:^(HSPracticeWrongViewModel *detailViewModel) {
        self.detailViewModel.showAnswers = NO;

//        NSLog(@"%ld",(long)self.detailViewModel.contentCount);
        if ([self.detailViewModel contentCount] <= 0  ) {
            self.doneBtn.enabled = YES;
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }else{
            if (![self.detailViewModel canSwithToPreQuestion]) {
            
                [[Hud defaultInstance]showMessage:@"移除成功"];
//                [self.detailViewModel switchToNextQuestion];
//                return;
            }else if(![self.detailViewModel canSwithToNextQuestion]){

                [self.detailViewModel switchToPreQuestion];

                [self.yhCollectionView scrollToItemAtIndexPath:self.detailViewModel.currentIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
                [[Hud defaultInstance]showMessage:@"移除成功"];

//                防止点击过快产生bug
//                [NSThread sleepForTimeInterval:0.5];
            }
            
        }
        
    } failure:^(NSError *error) {
        
    }] ;
    self.doneBtn.enabled = YES;
}

- (IBAction)preBtnTapped:(UIButton *)sender {
    
   
    if (self.detailViewModel.contentCount >=2) {
        self.detailViewModel.showAnswers = NO;
        [self.doHomeWorkViewModel.selectedIndexPaths removeAllObjects];
    }
     [self.yhCollectionView reloadData];
//    if (self.selectedIndex !=0) {
//        [self.detailViewModel switchToPreQuestion];
//        [self.yhCollectionView scrollToItemAtIndexPath:self.detailViewModel.currentIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
//        return;
//    }

    if (![self.detailViewModel canSwithToPreQuestion]) {
        [[Hud defaultInstance] showMessage:@"已经是第一题了"];
        return;
    }
    
    [self.detailViewModel switchToPreQuestion];
    [self.yhCollectionView scrollToItemAtIndexPath:self.detailViewModel.currentIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
//    [self updateTimingView];
    
}
- (IBAction)nextBtnTapped:(UIButton *)sender {
//    [self.detailViewModel reDoExercise];
    
//    [self refreshPracticeDetailView];
   

    
    
    
    if (self.detailViewModel.contentCount >=2) {
         self.detailViewModel.showAnswers = NO;
        [self.doHomeWorkViewModel.selectedIndexPaths removeAllObjects];
    }
    [self.yhCollectionView reloadData];
    if ((self.selectedIndex == (self.detailViewModel.contentCount-1))) {
        [[Hud defaultInstance] showMessage:@"已经是最后一题了"];
        return;
    }
    if (![self.detailViewModel canSwithToNextQuestion]) {
        [[Hud defaultInstance] showMessage:@"已经是最后一题了"];
        return;
    }
    [self.detailViewModel switchToNextQuestion];
    [self.yhCollectionView scrollToItemAtIndexPath:self.detailViewModel.currentIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    
//    [self updateTimingView];
}
//- (void)updateTimingView
//{
//    if (self.detailViewModel.showAnswers) {
//        for (UIButton *btn in self.questionButtons) {
//            btn.hidden = YES;
//        }
//        for (int i=0; i<self.detailViewModel.contentCount; i++) {
//            UIButton *btn = self.questionButtons[i];
//            btn.hidden = NO;
//        }
//    }else {
//        
//    }
//    
//    
//    
//}
//- (void) questionBtnTapped:(UIButton *) button {
//    [UIView animateWithDuration:0.1 animations:^{
//        self.yhCollectionView.contentOffset = CGPointMake(button.tag*self.view.bounds.size.width, 0);
//    }];
//}
//- (void) exerciseBtnBeChoosed:(NSNotification *)notify {
//    NSNumber *num = notify.object;
//    NSInteger chooseNum = num.integerValue;
//    for (HSExerciseButton *btn in self.questionButtons) {
//        
//        if (btn.isSelected) {
//            btn.chooseCount += chooseNum;
//            if (btn.chooseCount) {
//                btn.selected = NO;
//                btn.chooseAnswer = YES;
//                btn.selected = YES;
//                
//            }else {
//                btn.selected = NO;
//                btn.chooseAnswer = NO;
//                btn.selected = YES;
//            }
//        }
//        if (btn.chooseAnswer) {
//            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
//        }else {
//            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
//        }
//    }
//}

- (void) showAlertView {
    NSInteger count=0;
    for (int i=0; i<self.detailViewModel.contentCount; i++) {
        HSDoHomeworkViewModel *doHomeworkVM = (HSDoHomeworkViewModel *)[self.detailViewModel contentAtIndex:i];
        if (IsStrEmpty(doHomeworkVM.questionModel.userAnswer)) {
            count ++;
        }
        
    }
    if (count == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示信息" message:@"确认提交?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView setTag:1001];
        [alertView show];
    }else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示信息" message:@"你还有题目未做完，确认提交?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView setTag:1001];
        [alertView show];
        
    }
}
#pragma  mark -懒加载
- (UICollectionView *)yhCollectionView
{

    if (!_yhCollectionView) {
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        [flowLayout setSectionInset:UIEdgeInsetsZero];
        [flowLayout setMinimumInteritemSpacing:0];
        [flowLayout setMinimumLineSpacing:0];
        
        _yhCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-CGRectGetHeight(self.classActionView.bounds)-64) collectionViewLayout:flowLayout];
        [_yhCollectionView setShowsHorizontalScrollIndicator:NO];
        [_yhCollectionView setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
        [_yhCollectionView setBackgroundColor:RGBCOLOR(235, 235, 235)];
//        设置为无法滑动
        _yhCollectionView.scrollEnabled = NO;
        //        [_yhCollectionView setScrollEnabled:NO];
        [_yhCollectionView setPagingEnabled:YES];
        [_yhCollectionView setDelegate:self];
        [_yhCollectionView setDataSource:self];
        
        [_yhCollectionView registerClass:[HSPracticeDoHomeworkContainerCell class] forCellWithReuseIdentifier:@"HSPracticeDoHomeworkContainerCell"];
        [_yhCollectionView registerClass:[HSPractcieViewAnswerContainerCell class] forCellWithReuseIdentifier:@"HSPractcieViewAnswerContainerCell"];
    }
//    [_yhCollectionView setContentOffset:CGPointMake(screenRect.size.width*self.selectedIndex, 0)];

    return _yhCollectionView;
}


-(void)deleteWrongPractice:(NSString *)practiceWrongIdStr success:(void(^)(HSPracticeWrongViewModel *detailViewModel))successBlock failure:(void(^)(NSError *error))failureBlock{
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
    if ([HSLoginMgr loginMgr].loginUser.userId.length > 0) {
        [parameter setObject:[HSLoginMgr loginMgr].loginUser.userId forKey:@"userId"];
    }
    [parameter setObject:kVERSIONCODE forKey:@"versionCode"];
    if (practiceWrongIdStr) {
        [parameter setObject:practiceWrongIdStr forKey:@"practiceWrongIdStr"];
    }
    [self showWaitAlert];
    [[EPHttpClient sharedClient] POST:@"com/ctrl/practiceV1_5/deletePracticeWrong" parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *res = nil;
        res = responseObject[@"res"];
//        NSLog(@"%d",[res intValue]);
        if ([res intValue] == 1) {
            [self.detailViewModel deleteContentAtIndex:self.detailViewModel.currentIndexPath.row];
            //        NSLog(@"%d",self.detailViewModel.currentIndexPath.row);
            [self hideWaitAlert];
            [self.yhCollectionView reloadData];
//            NSLog(@"%ld",(long)[self.yhCollectionView numberOfItemsInSection:0]);
            successBlock(self.detailViewModel);

                       }
        else{
            [self hideWaitAlert];
            [self showMsgAlert:@"移除失败"];
        }
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self hideWaitAlert];
        [self showMsgAlert:@"移除失败"];
    }];
}

@end
