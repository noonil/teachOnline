//
//  HSHomeworkDetailVC.m
//  koreanpine
//
//  Created by Christ on 15/8/18.
//  Copyright (c) 2015年 Christ. All rights reserved.
//

#import "HSHomeworkDetailVC.h"
#import "HSDoHomeworkContainerCell.h"
#import "HSViewAnswerContainerCell.h"
#import "HSHomeworkDetailViewModel.h"
#import "HSDoHomeworkViewModel.h"
#import "HSTimerLabel.h"

@interface HSHomeworkDetailVC ()
<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIAlertViewDelegate,YH_ArrayDataLoadDelegate>

@property (weak, nonatomic) IBOutlet UIView *timingView;

@property (strong, nonatomic) UICollectionView *yhCollectionView;

@property (strong, nonatomic) UIButton *doneBtn;

@property (weak, nonatomic) IBOutlet UIButton *viewWrongBtn;

@property (strong, nonatomic) HSHomeworkDetailViewModel *detailViewModel;

@property (weak, nonatomic) IBOutlet UILabel *leftLabel;

@property (weak, nonatomic) IBOutlet HSTimerLabel *timeLabel;


@property (weak, nonatomic) IBOutlet UIView *classActionView;

@property (weak, nonatomic) IBOutlet UIButton *preBtn;

@property (weak, nonatomic) IBOutlet UIButton *nextBtn;

@end

@implementation HSHomeworkDetailVC

- (instancetype)initWithHomeworkModel:(HSLectureHomeworkModel *)homeworkModel
{
    self = [super init];
    if (self) {
        self.detailViewModel = [[HSHomeworkDetailViewModel alloc] initWithHomeworkModel:homeworkModel];
        [self.detailViewModel setDelegate:self];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initView];
    [self initData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initView
{
    self.title = @"课后作业";
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:self.backBtn];
    self.navigationItem.leftBarButtonItem = backItem;
    
    self.doneBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 27)];
    [self.doneBtn setBackgroundColor:RGBCOLOR(72, 95, 192)];
    [self.doneBtn.layer setCornerRadius:3.0f];
    [self.doneBtn.layer setMasksToBounds:YES];
    [self.doneBtn setTitle:@"结束" forState:UIControlStateNormal];
    [self.doneBtn.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
    [self.doneBtn addTarget:self action:@selector(doneBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.viewWrongBtn setBackgroundColor:kActionBtnNormalColor];
    [self.viewWrongBtn.layer setCornerRadius:3.0f];
    [self.viewWrongBtn.layer setMasksToBounds:YES];
    [self.viewWrongBtn.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
    [self.viewWrongBtn setTitle:@"只看错题" forState:UIControlStateNormal];
    [self.viewWrongBtn setTitle:@"所有题目" forState:UIControlStateSelected];
    
    UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithCustomView:self.doneBtn];
    self.navigationItem.rightBarButtonItem = doneItem;
    
    [self.yhCollectionView setBounces:NO];
    [self.view addSubview:self.yhCollectionView];
}

- (void)initData
{
    [self.detailViewModel fetchLatest];
}

- (UICollectionView *)yhCollectionView
{
    if (!_yhCollectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        [flowLayout setSectionInset:UIEdgeInsetsZero];
        [flowLayout setMinimumInteritemSpacing:0];
        [flowLayout setMinimumLineSpacing:0];
        
        _yhCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.timingView.frame), CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-CGRectGetHeight(self.classActionView.bounds)-CGRectGetMaxY(self.timingView.frame)) collectionViewLayout:flowLayout];
        [_yhCollectionView setShowsHorizontalScrollIndicator:NO];
        [_yhCollectionView setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
        [_yhCollectionView setBackgroundColor:RGBCOLOR(235, 235, 235)];
//        [_yhCollectionView setScrollEnabled:NO];
        [_yhCollectionView setPagingEnabled:YES];
        [_yhCollectionView setDelegate:self];
        [_yhCollectionView setDataSource:self];
        
        [_yhCollectionView registerClass:[HSDoHomeworkContainerCell class] forCellWithReuseIdentifier:@"HSDoHomeworkContainerCell"];
        [_yhCollectionView registerClass:[HSViewAnswerContainerCell class] forCellWithReuseIdentifier:@"HSViewAnswerContainerCell"];
    }
    return _yhCollectionView;
}

#pragma mark - UIScrollView Delegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
        NSInteger currentPage = scrollView.contentOffset.x/CGRectGetWidth(scrollView.frame);
        self.detailViewModel.currentIndexPath = [NSIndexPath indexPathForRow:currentPage inSection:0];
        [self updateTimingView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger currentPage = scrollView.contentOffset.x/CGRectGetWidth(scrollView.frame);
    self.detailViewModel.currentIndexPath = [NSIndexPath indexPathForRow:currentPage inSection:0];
    [self updateTimingView];
}

#pragma mark -
- (void)backAction:(id)sender
{
    if (!self.detailViewModel.showAnswers) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"确定要退出练习？" message:@"退出后未完成的练习不会被保存" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView setTag:1000];
        [alertView show];
    } else {
        [super backAction:sender];
    }
}

- (void)doneBtnTapped:(UIButton *)btn
{
    //重做按钮
    if (self.detailViewModel.showAnswers) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"确定重做？" message:@"重做提交后会覆盖之前做的结果" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView setTag:1001];
        [alertView show];
    } else {
        [self.detailViewModel setTestTime:self.timeLabel.timeInterval];
        [self.detailViewModel finishDoHomework];
        [self refreshHomeworkDetailView];
        [self.yhCollectionView setContentOffset:CGPointZero];
    }
    
}

- (IBAction)viewWrongBtnTapped:(UIButton *)sender {
    
    if (self.detailViewModel.showWrongQuestions) {
        [self.detailViewModel viewAllQuestions];
    } else {
        [self.detailViewModel viewWrongQuestions];
    }
    
    [self refreshHomeworkDetailView];
    if ([self.detailViewModel contentCount] > self.detailViewModel.currentIndexPath.row) {
        [self.yhCollectionView setContentOffset:CGPointZero];
    }
}

- (IBAction)preBtnTapped:(UIButton *)sender {
    if (![self.detailViewModel canSwithToPreQuestion]) {
        [[Hud defaultInstance] showMessage:@"已经是第一题了"];
        return;
    }
    
    [self.detailViewModel switchToPreQuestion];
    [self.yhCollectionView scrollToItemAtIndexPath:self.detailViewModel.currentIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    [self updateTimingView];
    
}

- (IBAction)nextBtnTapped:(UIButton *)sender {
    if (![self.detailViewModel canSwithToNextQuestion]) {
        [[Hud defaultInstance] showMessage:@"已经是最后一题了"];
        return;
    }
    [self.detailViewModel switchToNextQuestion];
    [self.yhCollectionView scrollToItemAtIndexPath:self.detailViewModel.currentIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    [self updateTimingView];
}

//查看答案与做题目界面互相切换
- (void)refreshHomeworkDetailView
{
    [self.yhCollectionView reloadData];
    NSString *doneBtnTitle = self.detailViewModel.showAnswers?@"重做":@"结束";
    [self.doneBtn setTitle:doneBtnTitle forState:UIControlStateNormal];
    
    [self.timeLabel setHidden:self.detailViewModel.showAnswers];    
    
    if (self.detailViewModel.showAnswers) {
        [self.timeLabel stopTimer];
    } else {
        [self.timeLabel startTimer];
    }
    
    //显隐
    [self.viewWrongBtn setHidden:!self.detailViewModel.showAnswers];
    //是否选中状态
    [self.viewWrongBtn setSelected:self.detailViewModel.showWrongQuestions];
    //背景色
    UIColor *viewWrongBtnBgColor = self.viewWrongBtn.selected?kActionBtnSelectColor:kActionBtnNormalColor;
    [self.viewWrongBtn setBackgroundColor:viewWrongBtnBgColor];
    
    [self updateTimingView];
}

- (void)updateTimingView
{

    NSInteger totalCount = [self.detailViewModel contentCount];
    if (totalCount == 0) {
        [self.leftLabel setText:@"暂无相关题目"];
    } else {
        HSDoHomeworkViewModel *doHomeworkVM = (HSDoHomeworkViewModel *)[self.detailViewModel contentAtIndex:self.detailViewModel.currentIndexPath.row];
        
        NSString *questionType = @"";
        switch (doHomeworkVM.questionModel.quesType) {
            case HSQuesTypeSingleSelect: {
                questionType = @"单选题";
                break;
            }
            case HSQuesTypeMuiltSelect: {
                questionType = @"多选题";
                break;
            }
            case HSQuesTypeJudge: {
                questionType = @"判断题";
                break;
            }
            default:
                break;
        }
        [self.leftLabel setText:[NSString stringWithFormat:@"%d/%ld(%@)",self.detailViewModel.currentIndexPath.row+1,(long)[self.detailViewModel contentCount],questionType]];
    }
}

#pragma mark - UICollectionView Datasource and Delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
   return [self.detailViewModel contentCount];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HSDoHomeworkViewModel *doHomeworkViewModel = (HSDoHomeworkViewModel *)[self.detailViewModel contentAtIndex:indexPath.row];
    
    if (self.detailViewModel.showAnswers) {
        HSViewAnswerContainerCell *bCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HSViewAnswerContainerCell" forIndexPath:indexPath];
        [bCell.viewAnswerVC updateViewAnswerVCWith:doHomeworkViewModel];
        return bCell;
    } else {
        HSDoHomeworkContainerCell *aCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HSDoHomeworkContainerCell" forIndexPath:indexPath];
        [aCell.doHomeWorkVC updateDoHomeworkVCWith:doHomeworkViewModel];
        return aCell;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return  collectionView.frame.size;
}

#pragma mark - 
- (void)arrayDataMgr:(YH_ArrayDataMgr *)arrayDataMgr didFinishFetch:(CHFetchType)fetchType succeed:(BOOL)succeed error:(NSError *)error
{
    [self refreshHomeworkDetailView];
}

#pragma mark - UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1000) {
        if (buttonIndex == 1) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    } else if (alertView.tag == 1001) {
        if (buttonIndex == 1) {
            [self.detailViewModel reDoHomework];
            [self refreshHomeworkDetailView];
            
            [self.yhCollectionView setContentOffset:CGPointZero];
        }
    }
}


@end
