//
//  HSLectureDetailVC.m
//  koreanpine
//
//  Created by Christ on 15/7/26.
//  Copyright (c) 2015年 Christ. All rights reserved.
//

#import "HSLectureDetailVC.h"
#import <MediaPlayer/MediaPlayer.h>
#import "UIImageView+WebCache.h"
#import "HSLectureDetailViewModel.h"
#import "HSLectureHsDetailViewModel.h"
#import "HSClassListVC.h"
#import "HSLectureModel.h"
#import "HSLectureStageModel.h"
#import "HSClassContainerCell.h"
#import "HSHomeworkContainerCell.h"
#import "HSPDFContainerCell.h"
#import "CDRTranslucentSideBar.h"

@interface HSLectureDetailVC ()
<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,HSLectureDetailViewModelDelegate,HSLectureHsDetailViewModelDelegate,CDRTranslucentSideBarDelegate>


@property (nonatomic, strong) CDRTranslucentSideBar *sideBar;


@property (weak, nonatomic) IBOutlet UIView *lectrureActionView;
@property (weak, nonatomic) IBOutlet UIButton *lectureListBtn;
@property (weak, nonatomic) IBOutlet UIButton *previousLectureBtn;
@property (weak, nonatomic) IBOutlet UIButton *nextLectureBtn;
- (IBAction)lectureListBtnTapped:(UIButton *)sender;
- (IBAction)previousLectureBtnTapped:(UIButton *)sender;
- (IBAction)nextLectureBtnTapped:(UIButton *)sender;

@property (weak, nonatomic)  id<HSContainerVCInterface> currentShownVC;

@property (strong, nonatomic) HSLectureDetailViewModel *lectureDetailViewModel;
@property (strong, nonatomic) HSLectureHsDetailViewModel *lectureHsDetailViewModel;
@property (strong, nonatomic) HSClassListVC *classListVC;
@property (nonatomic,copy) NSString *classId;
@property (assign, nonatomic) BOOL shouldShowLeftSide;
@property (nonatomic,strong) NSArray *stagelist;
@end

@implementation HSLectureDetailVC

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil lectureModel:(HSLectureModel *)lectureModel isHs:(bool)isHs ClassID:(NSString *)classId
{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.isHs = isHs;
        self.classId = classId;
        if (isHs) {
            self.lectureHsDetailViewModel = [[HSLectureHsDetailViewModel alloc] initWithHSLectureModel:lectureModel];
            [self.lectureHsDetailViewModel setDelegate:self];
        }else {
            self.lectureDetailViewModel = [[HSLectureDetailViewModel alloc] initWithHSLectureModel:lectureModel];
            [self.lectureDetailViewModel setDelegate:self];

        }
            }
    return self;
}
-(void)addViewedCourse:(NSString *)lectureID isHs:(BOOL)isHs{
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
    [parameter setObject:kVERSIONCODE forKey:@"versionCode"];
    if (lectureID) {
        [parameter setObject:lectureID forKey:@"courseId"];
    }
    NSString *url = nil;
//    com/ctrl/course/addHsViewedCourse
//   url = @"com/courseV1_4/addHsViewedCourse";
    if (isHs) {
         url = @"com/ctrl/course/addHsViewedCourse";
    }else{
         url = @"com/ctrl/course/addViewedCourse";
    }
   
//    TODO:post failure
    
    [[EPHttpClient sharedClient] POST:url parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSDictionary *res = responseObject;
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];

    
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initView];
    [self initData];
   
}
//-(void)noti{
//     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(receiveNotify:) name:@"lectureModelReloadNotification" object:nil];
//}
//-(void)receiveNotify:(NSNotification *)notify{
//    [_yhCollectionView reloadData];
//    [self viewDidLoad];
//}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

//    if (self.shouldShowLeftSide) {
//        [self.sideBar showInViewController:self animated:NO];
//        self.shouldShowLeftSide = YES;
//    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self containerVCDidDisappler:self.currentShownVC];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    [self.yhCollectionView setFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-CGRectGetHeight(self.lectrureActionView.bounds))];
}



- (void)initView
{
    UIBarButtonItem *leftBarBtn = [[UIBarButtonItem alloc] initWithCustomView:self.backBtn];
    [self.navigationItem setLeftBarButtonItem:leftBarBtn];
    
    self.shouldShowLeftSide = NO;
    
    self.sideBar = [[CDRTranslucentSideBar alloc] init];
    self.sideBar.delegate = self;
    self.sideBar.sideBarWidth = 270*kScreenPointScale;
    self.sideBar.tag = 0;
    [self.sideBar setContentViewInSideBar:self.classListVC.view];
    [self.view addSubview:self.yhCollectionView];
}

- (BOOL)hasShownLeftView
{
    return self.sideBar.hasShown;
}

- (HSClassListVC *)classListVC
{
    if (!_classListVC) {
        
        if (self.isHs) {
            _classListVC = [[HSClassListVC alloc] initWithLectureDetailViewModel:self.lectureHsDetailViewModel];
            [_classListVC setMainVC:self];
 
        }else {
            _classListVC = [[HSClassListVC alloc] initWithLectureDetailViewModel:self.lectureDetailViewModel];
            [_classListVC setMainVC:self];
 
        }
        
            }
    return _classListVC;
}

- (void)initData
{
    WS(weakSelf);
    [self showWaitAlert];
    if (self.isHs) {
        [self.lectureHsDetailViewModel getCouserStageWithSucceededBlock:^(NSArray *stagItems) {
            if (self.classId.length > 0) {
                    NSInteger count = weakSelf.lectureHsDetailViewModel.stageList.count;
                    for (int i=0; i<count; i++) {
                        HSLectureStageModel *model = weakSelf.lectureHsDetailViewModel.stageList[i];
                        for (int j=0; j<model.lectureClassArr.count; j++) {
                            if([model.lectureClassArr[j] isKindOfClass:[HSLectureClassModel class]]){
                                HSLectureClassModel *classModel = (HSLectureClassModel *)model.lectureClassArr[j];
                                if ([classModel.classId isEqualToString:weakSelf.classId]) {
                                    weakSelf.classListVC.selectedIndexPath = [NSIndexPath indexPathForRow:j inSection:i];
                                    weakSelf.lectureDetailViewModel.currentLectureIndexPath = [NSIndexPath indexPathForRow:j inSection:i];
                                    [weakSelf hideWaitAlert];
                                    [weakSelf.classListVC updateLectureStageView];
                                    [weakSelf.yhCollectionView reloadData];
                                    [weakSelf chapterDidChanged];

                                }
                            }
                        }
                        
                        
                    }
            }else {
                [weakSelf hideWaitAlert];
                [weakSelf.classListVC updateLectureStageView];
                [weakSelf.yhCollectionView reloadData];
            }
            

        } failedBlock:^(NSError *error) {
            [weakSelf hideWaitAlert];
            [[Hud defaultInstance] showMessage:error.localizedDescription];
        }];
        
        [self.lectureHsDetailViewModel addCourseStudyHistoryWithSucceededBlock:^(NSArray *stagItems) {
            
        } failedBlock:^(NSError *error) {
            
        }];

    }else {
        [self.lectureDetailViewModel getCouserStageWithSucceededBlock:^(NSArray *stagItems) {
            if (self.classId.length > 0) {
                NSInteger count = weakSelf.lectureDetailViewModel.stageList.count;
                for (int i=0; i<count; i++) {
                    HSLectureStageModel *model = weakSelf.lectureDetailViewModel.stageList[i];
                    for (int j=0; j<model.lectureClassArr.count; j++) {
                        if([model.lectureClassArr[j] isKindOfClass:[HSLectureClassModel class]]){
                            HSLectureClassModel *classModel = (HSLectureClassModel *)model.lectureClassArr[j];
                            if ([classModel.classId isEqualToString:weakSelf.classId]) {
                            
                                weakSelf.classListVC.selectedIndexPath = [NSIndexPath indexPathForRow:j inSection:i];
                                weakSelf.lectureDetailViewModel.currentLectureIndexPath = [NSIndexPath indexPathForRow:j inSection:i];
                                [weakSelf hideWaitAlert];
                                [weakSelf.classListVC updateLectureStageView];
                                [weakSelf.yhCollectionView reloadData];
                                [weakSelf chapterDidChanged];
                                
                            }
                        }
                    }
                    
                    
                }
            }else {
                [weakSelf hideWaitAlert];
                [weakSelf.classListVC updateLectureStageView];
                self.stagelist = self.lectureDetailViewModel.stageList.copy;
            [weakSelf.yhCollectionView reloadData];
            }
        } failedBlock:^(NSError *error) {
            [weakSelf hideWaitAlert];
            [[Hud defaultInstance] showMessage:error.localizedDescription];
        }];
        
        [self.lectureDetailViewModel addCourseStudyHistoryWithSucceededBlock:^(NSArray *stagItems) {
            
        } failedBlock:^(NSError *error) {
            
        }];
    }
    
    
    
}

- (UICollectionView *)yhCollectionView
{
    if (!_yhCollectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        [flowLayout setSectionInset:UIEdgeInsetsZero];
        [flowLayout setMinimumInteritemSpacing:0];
        [flowLayout setMinimumLineSpacing:0];
        
        _yhCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-CGRectGetHeight(self.lectrureActionView.bounds)) collectionViewLayout:flowLayout];
        [_yhCollectionView setShowsHorizontalScrollIndicator:NO];
        [_yhCollectionView setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];

        [_yhCollectionView setBackgroundColor:RGBCOLOR(235, 235, 235)];
        [_yhCollectionView setScrollEnabled:NO];
        [_yhCollectionView setPagingEnabled:YES];
        [_yhCollectionView setDelegate:self];
        [_yhCollectionView setDataSource:self];
        
        [_yhCollectionView registerClass:[HSClassContainerCell class] forCellWithReuseIdentifier:@"HSLectureDetailContainerCell"];
        [_yhCollectionView registerClass:[HSHomeworkContainerCell class] forCellWithReuseIdentifier:@"HSHomeworkContainerCell"];
        [_yhCollectionView registerClass:[HSPDFContainerCell class] forCellWithReuseIdentifier:@"HSPDFContainerCell"];
    }
    return _yhCollectionView;
}

-(void)backAction:(id)sender
{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)switchCourseContentAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)containerVCWillAppear:(id<HSContainerVCInterface>)containerVC
{
    [containerVC willDisplayContainerView];
}

- (void)containerVCDidDisappler:(id<HSContainerVCInterface>)containerVC
{
    [containerVC endDisplayContainerView];
}

#pragma mark - UICollectionView Datasource and Delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if (self.isHs) {
        return [self.lectureHsDetailViewModel.stageList count];
    }
    return [self.lectureDetailViewModel.stageList count];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.isHs) {
        HSLectureStageModel *stageModel = (HSLectureStageModel *)self.lectureHsDetailViewModel.stageList[section];
        return [stageModel.lectureClassArr count];
    }else {
        HSLectureStageModel *stageModel = (HSLectureStageModel *)self.lectureDetailViewModel.stageList[section];
        return [stageModel.lectureClassArr count];
    }
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
   
    HSLectureStageModel *stageModel = [HSLectureStageModel new];
    HSLectureModel *lectureModel = [HSLectureModel new];
     if (self.isHs) {
           stageModel = (HSLectureStageModel *)self.lectureHsDetailViewModel.stageList[indexPath.section];
         lectureModel =self.lectureHsDetailViewModel.lectureModel;
     }else {
       stageModel = (HSLectureStageModel *)self.lectureDetailViewModel.stageList[indexPath.section];
         lectureModel =self.lectureDetailViewModel.lectureModel;
     }
    
    id<HSLectureDetails> stageDetailModel = stageModel.lectureClassArr[indexPath.row];
    if (stageDetailModel.lectureClassType == HSLectureClassTypeClass) {
        HSLectureClassModel *lectureClassModel = (HSLectureClassModel *)stageDetailModel;
//        NSLog(@"%@",lectureClassModel);
        lectureClassModel.homeworkCount = stageModel.homeworkCount;
        lectureClassModel.classhourCount = stageModel.classhourCount;
        HSClassContainerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HSLectureDetailContainerCell" forIndexPath:indexPath];
        if (cell.classContainerVC.parentViewController == nil) {
            [self addChildViewController:cell.classContainerVC];
            [cell.classContainerVC setMainVC:self];
        }
//         NSLog(@"%@",lectureClassModel);
        [cell updateCellWithLecutreModel:lectureModel classModel:lectureClassModel];
        return cell;
        
    } else if(stageDetailModel.lectureClassType == HSLectureClassTypePractice){
        HSLectureHomeworkModel *homeworkModel = (HSLectureHomeworkModel *)stageDetailModel;
        homeworkModel.homeworkCount = stageModel.homeworkCount;
        homeworkModel.classhourCount = stageModel.classhourCount;
        HSHomeworkContainerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HSHomeworkContainerCell" forIndexPath:indexPath];
        if (cell.homeworkContainerVC.parentViewController == nil) {
            [self addChildViewController:cell.homeworkContainerVC];
            [cell.homeworkContainerVC setMainVC:self];
        }
        [cell updateCellWithLecutreModel:lectureModel homeworkModel:homeworkModel];
        return cell;

    }else {
        HSLecturePDFModel *lecturePDFModel = (HSLecturePDFModel *)stageDetailModel;
        lecturePDFModel.homeworkCount = stageModel.homeworkCount;
        lecturePDFModel.classhourCount = stageModel.classhourCount;
        HSPDFContainerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HSPDFContainerCell" forIndexPath:indexPath];
        if (cell.pdfContainerVC.parentViewController == nil) {
            [self addChildViewController:cell.pdfContainerVC];
            [cell.pdfContainerVC setMainVC:self];
        }
        [cell updateCellWithLecutreModel:lectureModel pdfModel:lecturePDFModel];
        return cell;
    }
}


- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    HSLectureStageModel *stageModel = (HSLectureStageModel *)self.lectureDetailViewModel.stageList[indexPath.section];
    id<HSLectureDetails> stageDetailModel = stageModel.lectureClassArr[indexPath.row];
    [self setTitle:stageDetailModel.name];
    if ([cell isKindOfClass:[HSClassContainerCell class]]) {
        HSClassContainerCell *containerCell = (HSClassContainerCell *)cell;
        self.currentShownVC = containerCell.classContainerVC;
        self.classListVC.selectedIndexPath = indexPath;
        [self.classListVC updateLectureStageView];
        [containerCell willDisplayCell];
    } else if ([cell isKindOfClass:[HSHomeworkContainerCell class]]){
        HSHomeworkContainerCell *containerCell = (HSHomeworkContainerCell *)cell;
        self.currentShownVC = containerCell.homeworkContainerVC;
        
        [containerCell willDisplayCell];
    }else {
        HSPDFContainerCell *containerCell = (HSPDFContainerCell *)cell;
        self.currentShownVC = containerCell.pdfContainerVC;
        [containerCell willDisplayCell];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell isKindOfClass:[HSClassContainerCell class]]) {
        HSClassContainerCell *containerCell = (HSClassContainerCell *)cell;
        [self containerVCDidDisappler:containerCell.classContainerVC];
        [containerCell endDisplayCell];
    } else if ([cell isKindOfClass:[HSHomeworkContainerCell class]]){
        HSHomeworkContainerCell *containerCell = (HSHomeworkContainerCell *)cell;
        [containerCell endDisplayCell];
    }else {
        HSPDFContainerCell *containerCell = (HSPDFContainerCell *)cell;
        [containerCell endDisplayCell];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return  collectionView.frame.size;
}


#pragma mark - Btn Action

- (IBAction)lectureListBtnTapped:(UIButton *)sender {
    //显示课程列表
    [self.sideBar showInViewController:self animated:YES];
}

- (void)chapterDidChanged
{
    if (self.isHs) {
        [self.yhCollectionView scrollToItemAtIndexPath:self.lectureHsDetailViewModel.currentLectureIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
        //关闭课程列表
        [self.sideBar dismissAnimated:YES];
    }else {
        [self.yhCollectionView scrollToItemAtIndexPath:self.lectureDetailViewModel.currentLectureIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
        //关闭课程列表
        [self.sideBar dismissAnimated:YES];
    }
    
}

- (IBAction)previousLectureBtnTapped:(UIButton *)sender {
    
    if(![self.lectureDetailViewModel canSwithToPreLecture]){
        [[Hud defaultInstance] showMessage:@"已经是第一页了"];
        return;
    }
    
    [self.lectureDetailViewModel switchToPreLecture];
    [self lectureDetailViewModelDidupdate];
    [self.yhCollectionView scrollToItemAtIndexPath:self.lectureDetailViewModel.currentLectureIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
}

- (IBAction)nextLectureBtnTapped:(UIButton *)sender {
    NSInteger section = 0;
    
    NSIndexPath *indexPath = self.lectureDetailViewModel.currentLectureIndexPath;
    section = indexPath.section;
       if(![self.lectureDetailViewModel canSwithToNextLecture]){
        [[Hud defaultInstance] showMessage:@"已经是最后一页了"];
        return;
    }
    
    if (![self.yhCollectionView numberOfItemsInSection:section]) {
        return;
    }
    [self.lectureDetailViewModel switchToNextLecture];
    [self lectureDetailViewModelDidupdate];
    [self.yhCollectionView scrollToItemAtIndexPath:self.lectureDetailViewModel.currentLectureIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
}

- (void)lectureDetailViewModelDidupdate
{
    self.classListVC.selectedIndexPath = self.lectureDetailViewModel.currentLectureIndexPath;
    [self.classListVC updateLectureStageView];
}

#pragma mark - CDRSideBarDelegate
- (void)sideBar:(CDRTranslucentSideBar *)sideBar didAppear:(BOOL)animated
{

}

- (void)sideBar:(CDRTranslucentSideBar *)sideBar willAppear:(BOOL)animated
{
    [self.currentShownVC willEnterBackgroundDisplay];
}

- (void)sideBar:(CDRTranslucentSideBar *)sideBar didDisappear:(BOOL)animated
{
    [self.currentShownVC willEnterForegroundDisplay];
}

- (void)sideBar:(CDRTranslucentSideBar *)sideBar willDisappear:(BOOL)animated
{
//    [self.currentShownVC willEnterForegroundDisplay];
}

- (NSArray *)stagelist {
    if (!_stagelist) {
        _stagelist = [NSArray array];
    
    }
    return _stagelist;
}
@end
