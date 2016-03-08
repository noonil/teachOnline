//
//  HSExerciseDetailVC.m
//  koreanpine
//
//  Created by Victor on 15/10/19.
//  Copyright © 2015年 Christ. All rights reserved.
//

#import "HSExerciseDetailVC.h"
#import "HSDoHomeworkContainerCell.h"
#import "HSViewAnswerContainerCell.h"
#import "HSExerciseDetailViewModel.h"
#import "HSTimerLabel.h"
#import "HSDoHomeworkViewModel.h"
#import "HSLectureClassModel.h"
#import "HSExerciseButton.h"
#import "UIView+WTXM.h"
#import "HSPracticeVC.h"
#import "HSPracticePKVC.h"
#import "HSExerciseButtonView.h"

@interface HSExerciseDetailVC ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIAlertViewDelegate,YH_ArrayDataLoadDelegate,UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet HSExerciseButtonView *timingView;
@property (nonatomic,strong) UIView *questionButtonsView;
@property (weak, nonatomic) IBOutlet UIView *moreQuestionButtonView;
@property (weak, nonatomic) IBOutlet UIButton *firstBtn;
@property (weak, nonatomic) IBOutlet UIButton *viewWrongBtn;
@property (strong, nonatomic) UIButton *doneBtn;
@property (strong, nonatomic) UICollectionView *yhCollectionView;
@property (nonatomic,strong) HSTimerLabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIView *classActionView;
@property (strong, nonatomic) HSExerciseDetailViewModel *detailViewModel;
@property (nonatomic,strong) NSMutableArray *questionButtons;
@property (nonatomic,strong) UIButton *selectedBtn;
@property (nonatomic,strong) UIAlertView *alert;
@property (nonatomic,strong) UITapGestureRecognizer *recognizerTap;
@property (nonatomic,strong) UISwipeGestureRecognizer *recognizerUp;
@property (nonatomic,strong) UISwipeGestureRecognizer *recognizerDown;
@property (nonatomic,strong) UIButton *grayViewButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timingViewHeightConstraint;
@end

@implementation HSExerciseDetailVC
static bool canMoveUp;
static bool canMoveDown;
- (instancetype)initWithHomeworkModel:(HSLectureHomeworkModel *)homeworkModel
{
    self = [super init];
    if (self) {
        self.detailViewModel = [[HSExerciseDetailViewModel alloc] initWithHomeworkModel:homeworkModel];
        [self.detailViewModel setDelegate:self];
    }
    return self;
}
#pragma mark -共有方法
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [self initData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(exerciseBtnBeChoosed:) name:kExerciseBtnDidTappedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addHandleSwipeUp:) name:kPracticeTableViewArriveBottomNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addHandleSwipeDown:) name:kPracticeTableViewArriveTopNotification object:nil];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kExerciseBtnDidTappedNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kPracticeTableViewArriveTopNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kPracticeTableViewArriveBottomNotification object:nil];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // 禁用 iOS7 返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // 开启
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}
#pragma mark -代理方法||数据源方法
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
- (void)refreshExerciseDetailView
{
    [self.yhCollectionView reloadData];
    NSString *doneBtnTitle = self.detailViewModel.showAnswers?@"再来一发":@"结束";
    [self.doneBtn setTitle:doneBtnTitle forState:UIControlStateNormal];
    [self.doneBtn sizeToFit];
    self.doneBtn.wid += 10;
    [self.timeLabel setHidden:self.detailViewModel.showAnswers];
     NSInteger totalCount = (NSInteger)(self.timingView.wid - 10)/42;
    if (self.detailViewModel.showAnswers) {
        [self.timeLabel stopTimer];
        for (UIView *view in self.classActionView.subviews) {
            if ([view isKindOfClass:[HSTimerLabel class]]) {
                [view removeFromSuperview];
            }
        }
        for (UIView *view in self.questionButtonsView.subviews) {
            if ([view isKindOfClass:[HSExerciseButton class]]) {
                view.alpha = 0;
            }
        }

         for (int i=0; i<self.detailViewModel.contentCount; i++) {
              HSDoHomeworkViewModel *doHomeworkViewModel = (HSDoHomeworkViewModel *)[self.detailViewModel contentAtIndex:i];
             BOOL isAnswer = [doHomeworkViewModel.questionModel.answer isEqualToString:doHomeworkViewModel.questionModel.userAnswer];
             HSExerciseButton *btn = self.questionButtons[i];
             btn.alpha = 1;
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            btn.selected = YES;
            btn.answerType = ExerciseAnswerTypeNUll;
            btn.selected = NO;
             self.timeLabel = nil;
             if (isAnswer) {
                 btn.selected = YES;
                 btn.answerType = ExerciseAnswerTypeRight;
                 btn.selected = NO;
             }else {
                 btn.selected = YES;
                 btn.answerType = ExerciseAnswerTypeWrong;
                 btn.selected = NO;
             }
             if (i == 0) {
                 btn.selected = YES;
                 self.selectedBtn = btn;
             }
         }

    } else {
        for (UIView *view in self.questionButtonsView.subviews) {
            if ([view isKindOfClass:[HSExerciseButton class]]) {
                [view removeFromSuperview];
            }
        }
        [self.questionButtons removeAllObjects];
        CGFloat btnW = 32;
        CGFloat spacing = (self.view.wid - totalCount*btnW)/(totalCount+1)*1.0;
        for (int i=0; i<self.detailViewModel.contentCount; i++) {
            HSExerciseButton *btn = [[HSExerciseButton alloc] initWithFrame:CGRectMake(spacing+(spacing+btnW)*i, 6, btnW, btnW)];
            [btn addTarget:self action:@selector(questionBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
            [btn setTitle:[NSString stringWithFormat:@"%d",i+1] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
            btn.tag = i;
            btn.chooseAnswer = NO;
            btn.chooseCount = 0;
            btn.hidden = NO;
            if (i == 0) {
                btn.selected = YES;
                self.selectedBtn = btn;
            }
            [self.questionButtonsView addSubview:btn];
            [self.questionButtons addObject:btn];
        }
        
        HSTimerLabel *label = [[HSTimerLabel alloc] initWithFrame:CGRectMake(self.view.wid*0.5-40, 4.5, 80, 40)];
        [self.classActionView addSubview:label];
        label.textAlignment = NSTextAlignmentCenter;
        self.timeLabel = label;
        [self.timeLabel startTimer];
        canMoveDown = YES;
    }
    
    //显隐
    [self.viewWrongBtn setHidden:!self.detailViewModel.showAnswers];
    //是否选中状态
    [self.viewWrongBtn setSelected:self.detailViewModel.showWrongQuestions];
    //背景色
    UIColor *viewWrongBtnBgColor = self.viewWrongBtn.selected?kActionBtnSelectColor:kActionBtnNormalColor;
    [self.viewWrongBtn setBackgroundColor:viewWrongBtnBgColor];
    
    [self updateTimingView];
    
    if (self.detailViewModel.contentCount > totalCount) {
        [self.view addGestureRecognizer:self.recognizerDown];
        [self.view addGestureRecognizer:self.recognizerUp];
    }else {
        [self.view removeGestureRecognizer:self.recognizerDown];
        [self.view removeGestureRecognizer:self.recognizerUp];
        self.timingView.moreExerciseBtnView.hidden = YES;
    }
//    [self.view addGestureRecognizer:self.recognizerDown];
//    [self.view addGestureRecognizer:self.recognizerUp];
//    self.timingViewHeightConstraint.constant += 10;
    
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
        [self updateTimingView];
    }
    if (!self.detailViewModel.showAnswers && scrollView.contentOffset.x == self.view.wid*(self.detailViewModel.contentCount-1)) {
        [self showAlertView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger currentPage = scrollView.contentOffset.x/CGRectGetWidth(scrollView.frame);
    self.detailViewModel.currentIndexPath = [NSIndexPath indexPathForRow:currentPage inSection:0];
    [self updateTimingView];
}

#pragma mark -
- (void)arrayDataMgr:(YH_ArrayDataMgr *)arrayDataMgr didFinishFetch:(CHFetchType)fetchType succeed:(BOOL)succeed error:(NSError *)error
{
    [self refreshExerciseDetailView];
    [self hideWaitAlert];
}

#pragma mark - UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1001) {
        if (buttonIndex == 1) {
            [self.detailViewModel setTestTime:self.timeLabel.timeInterval];
            [self.detailViewModel finishDoExercise];
            [self refreshExerciseDetailView];
            [self.yhCollectionView setContentOffset:CGPointZero];
            NSInteger rightAnswer = 0;
            for (int i=0; i<self.detailViewModel.contentCount; i++) {
              HSDoHomeworkViewModel *doHomeworkVM = (HSDoHomeworkViewModel *)[self.detailViewModel contentAtIndex:i];
                if ([doHomeworkVM.questionModel.userAnswer isEqualToString:doHomeworkVM.questionModel.answer]) {
                    rightAnswer ++;
                }
            }
            NSString *title = nil;
            if (rightAnswer == self.detailViewModel.contentCount) {
                title = [NSString stringWithFormat:@"答对%ld题,答错0题，干得漂亮！",(long)rightAnswer];
            }else {
                title = [NSString stringWithFormat:@"答对%ld题,答错%ld题，继续努力哟！",(long)rightAnswer,(self.detailViewModel.contentCount-rightAnswer)];
            }
            
            
            UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:title delegate:self cancelButtonTitle:@"查看解析" destructiveButtonTitle:nil otherButtonTitles:@"再来一发",@"累了，不想要了", nil];
            action.tag = 101;
            [action showInView:self.view];
        }else {
            self.detailViewModel.showAnswers = NO;
        }
    }
}
#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (actionSheet.tag == 101) {
        switch (buttonIndex) {
            case 0:
                [self showWaitAlert];
                [self.detailViewModel reDoExercise];
                //            [self refreshExerciseDetailView];
                [self.yhCollectionView setContentOffset:CGPointZero];
                break;
           
            case 1:
                [self.navigationController popViewControllerAnimated:YES];
                for (UIViewController *VC in self.navigationController.childViewControllers) {
                    if ([VC isKindOfClass:[HSPracticeVC class]]) {
                        HSPracticeVC *practiceVC = (HSPracticeVC *)VC;
                        [practiceVC.practicePKVC reloadUserHeroModel];
                    }
                }
                break;
            case 2:
                break;
                
            default:
                break;
    }
    
    }else if (actionSheet.tag == 102) {
        switch (buttonIndex) {
            case 0:
                [self.navigationController popViewControllerAnimated:YES];
                for (UIViewController *VC in self.navigationController.childViewControllers) {
                    if ([VC isKindOfClass:[HSPracticeVC class]]) {
                        HSPracticeVC *practiceVC = (HSPracticeVC *)VC;
                        [practiceVC.practicePKVC reloadUserHeroModel];
                        practiceVC.scrollView.contentOffset = CGPointMake(0, 0);
                    }
                }
                break;
                case 1:
                [self.navigationController popViewControllerAnimated:YES];
                for (UIViewController *VC in self.navigationController.childViewControllers) {
                    if ([VC isKindOfClass:[HSPracticeVC class]]) {
                        HSPracticeVC *practiceVC = (HSPracticeVC *)VC;
                        [practiceVC.practicePKVC reloadUserHeroModel];
                        practiceVC.scrollView.contentOffset = CGPointMake(0, 0);
                    }
                }
                break;
            default:
                break;
        }
    }
}
#pragma mark -私有方法
- (void)initView
{
    self.title = @"练习";
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:self.backBtn];
    self.navigationItem.leftBarButtonItem = backItem;
    
    self.doneBtn = [[UIButton alloc] init];
    [self.doneBtn setBackgroundColor:RGBCOLOR(72, 95, 192)];
    [self.doneBtn.layer setCornerRadius:3.0f];
    [self.doneBtn.layer setMasksToBounds:YES];
    [self.doneBtn.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
    [self.doneBtn setTitle:@"结束" forState:UIControlStateNormal];
    [self.doneBtn sizeToFit];
    self.doneBtn.wid += 10;
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
    [self showWaitAlert];
}

- (IBAction)viewWrongBtnTapped:(UIButton *)sender {
    if (self.detailViewModel.showWrongQuestions) {
        [self.detailViewModel viewAllQuestions];
    } else {
        [self.detailViewModel viewWrongQuestions];
    }
    
    [self refreshExerciseDetailView];
    if ([self.detailViewModel contentCount] > self.detailViewModel.currentIndexPath.row) {
        [self.yhCollectionView setContentOffset:CGPointZero];
    }
}
- (void)backAction:(id)sender
{
    if (!self.detailViewModel.showAnswers) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"保存已做的练习答案?" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"不保存" otherButtonTitles:@"保存", nil];
        [actionSheet setTag:102];
        [actionSheet showInView:self.view];
//        self.recognizerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapBehind:)];
//        
//        [self.recognizerTap setNumberOfTapsRequired:1];
//        self.recognizerTap.cancelsTouchesInView = NO;
//        [self.alert.window addGestureRecognizer:self.recognizerTap];
        } else {
        [super backAction:sender];
            for (UIViewController *VC in self.navigationController.childViewControllers) {
                if ([VC isKindOfClass:[HSPracticeVC class]]) {
                    HSPracticeVC *practiceVC = (HSPracticeVC *)VC;
                    [practiceVC.practicePKVC reloadUserHeroModel];
                }
              
            }
    }

}
//- (void)handleTapBehind:(UITapGestureRecognizer *)sender {
//    if (sender.state == UIGestureRecognizerStateEnded){
//        CGPoint location = [sender locationInView:nil];
//        if (![self.alert pointInside:[self.alert convertPoint:location fromView:self.alert.window] withEvent:nil]){
//            [self.alert.window removeGestureRecognizer:sender];
//            [self.alert dismissWithClickedButtonIndex:0 animated:YES];
//        }
//    }
//}

- (void)doneBtnTapped:(UIButton *)btn
{
//    提交按钮
    if (!self.detailViewModel.showAnswers) {
        [self showAlertView];
    } else {
        [self showWaitAlert];
        [self.detailViewModel reDoExercise];
//        [self refreshExerciseDetailView];
        
        [self.yhCollectionView setContentOffset:CGPointZero];
    }

}
- (void)initData
{
    [self.detailViewModel fetchLatest];
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
- (void)updateTimingView
{
    if (self.detailViewModel.showAnswers) {
        for (UIButton *btn in self.questionButtons) {
            btn.hidden = YES;
        }
        for (int i=0; i<self.questionButtons.count; i++) {
            UIButton *btn = self.questionButtons[i];
            btn.hidden = NO;
        }
    }else {
        
    }
    
    
    
}
- (void) questionBtnTapped:(UIButton *) button {
    [UIView animateWithDuration:0.1 animations:^{
        self.yhCollectionView.contentOffset = CGPointMake(button.tag*self.view.bounds.size.width, 0);
    }];
    self.detailViewModel.currentIndexPath = [NSIndexPath indexPathForRow:button.tag inSection:0];
}
- (void) exerciseBtnBeChoosed:(NSNotification *)notify {
    NSNumber *num = notify.object;
    NSInteger chooseNum = num.integerValue;
    for (HSExerciseButton *btn in self.questionButtons) {
       
        if (btn.isSelected) {
            btn.chooseCount += chooseNum;
            if (btn.chooseCount) {
                btn.selected = NO;
                btn.chooseAnswer = YES;
                btn.selected = YES;

            }else {
                btn.selected = NO;
                btn.chooseAnswer = NO;
                btn.selected = YES;
            }
        }
        if (btn.chooseAnswer) {
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        }else {
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        }
    }
}

- (void) showAlertView {
       [self.detailViewModel finishDoExercise];
    NSInteger count=0;
    for (int i=0; i<self.detailViewModel.contentCount; i++) {
        HSDoHomeworkViewModel *doHomeworkViewModel = (HSDoHomeworkViewModel *)[self.detailViewModel contentAtIndex:i];
        if (IsStrEmpty(doHomeworkViewModel.questionModel.userAnswer)) {
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

- (void) handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer{
    if(recognizer.direction==UISwipeGestureRecognizerDirectionUp && canMoveUp) {
        self.timingViewHeightConstraint.constant -= 50;
        self.moreQuestionButtonView.y -=60;
        self.yhCollectionView.y -= 60;
        self.yhCollectionView.hei += 60;
        [self.yhCollectionView reloadData];
        [self.grayViewButton removeFromSuperview];
        canMoveDown = YES;
        canMoveUp = NO;
        //执行程序
    }
    if(recognizer.direction==UISwipeGestureRecognizerDirectionDown && canMoveDown) {
        self.timingViewHeightConstraint.constant += 50;
        self.moreQuestionButtonView.y +=60;
        self.yhCollectionView.y += 60;
        self.yhCollectionView.hei -= 60;
        [self.yhCollectionView reloadData];
        [self.view addSubview:self.grayViewButton];
        canMoveUp = YES;
        canMoveDown = NO;
        //执行程+
    }
}

- (void) addHandleSwipeUp:(NSNotification *)notify {
    
}

- (void) addHandleSwipeDown:(NSNotification *)notify {
//    [self.yhCollectionView addGestureRecognizer:self.recognizerDown];
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
- (NSMutableArray *)questionButtons {
    if (!_questionButtons) {
        _questionButtons = [NSMutableArray array];
    }
    return _questionButtons;
}
- (UISwipeGestureRecognizer *)recognizerUp {
    if (!_recognizerUp) {
        _recognizerUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
        [_recognizerUp setDirection:(UISwipeGestureRecognizerDirectionUp)];
    }
    return _recognizerUp;
}
- (UISwipeGestureRecognizer *)recognizerDown {
    if (!_recognizerDown) {
        _recognizerDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
        [_recognizerDown setDirection:(UISwipeGestureRecognizerDirectionDown)];
    }
    return _recognizerDown;
}
- (UIButton *)grayViewButton {
    if (!_grayViewButton) {
        _grayViewButton = [UIButton new];
        _grayViewButton.backgroundColor = [UIColor lightGrayColor];
        _grayViewButton.frame = CGRectMake(0, CGRectGetMaxY(self.timingView.frame), self.view.wid, self.view.hei - CGRectGetMaxY(self.timingView.frame));
    }
    return _grayViewButton;
}
- (UIView *)questionButtonsView {
    if (!_questionButtonsView) {
        _questionButtonsView = [[UIView alloc] initWithFrame:self.timingView.bounds];
        [self.timingView addSubview:_questionButtonsView];
    }
    return _questionButtonsView;
}
@end
