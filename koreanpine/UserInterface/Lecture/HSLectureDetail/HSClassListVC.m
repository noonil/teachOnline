//
//  HSClassListVC.m
//  koreanpine
//
//  Created by Christ on 15/8/3.
//  Copyright (c) 2015年 Christ. All rights reserved.
//

#import "HSClassListVC.h"
#import "HSLectureChapterHeader.h"
#import "HSLectureCourseCell.h"

@interface HSClassListVC ()
<UITableViewDataSource,UITableViewDelegate,HSLectureChapterHeaderDelegate>

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) HSLectureDetailViewModel *lectureDetailViewModel;
@property (nonatomic,strong) HSLectureHsDetailViewModel *lectureHsDetailViewModel;

@end

@implementation HSClassListVC

- (instancetype)initWithLectureDetailViewModel:(NSObject *)viewModel
{
    self = [super init];
    if (self) {
        if ([viewModel isKindOfClass:[HSLectureHsDetailViewModel class]]) {
            self.lectureHsDetailViewModel = (HSLectureHsDetailViewModel *)viewModel;
        }else {
          self.lectureDetailViewModel = (HSLectureDetailViewModel *)viewModel;
        }
        
    }
    return self;
}

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
    [self.view setBackgroundColor:RGBCOLOR(235, 235, 235)];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-64) style:UITableViewStylePlain];
    [self.tableView setDataSource:self];
    [self.tableView setDelegate:self];
    [self.tableView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    [self.tableView registerClass:[HSLectureChapterHeader class] forHeaderFooterViewReuseIdentifier:@"HSLectureChapterHeader"];
    [self.tableView registerClass:[HSLectureCourseCell class] forCellReuseIdentifier:@"HSLectureCourseCell"];
    [self.view addSubview:self.tableView];
    [self.tableView setTableFooterView:[UIView new]];
    
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
}

- (void)updateLectureStageView
{
    
    [self.lectureDetailViewModel setCurrentLectureIndexPath:self.selectedIndexPath];
    [self.tableView reloadData];
    
}

#pragma mark - UITableView Datasource and Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.lectureDetailViewModel) {
        return [self.lectureDetailViewModel.stageList count];
 
    }else {
        return [self.lectureHsDetailViewModel.stageList count];
    }
    }

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger cellCount = 0;
    HSLectureStageModel *lectureStage = [HSLectureStageModel new];
    
    if (self.lectureDetailViewModel) {
        lectureStage = (HSLectureStageModel *)self.lectureDetailViewModel.stageList[section];
    }else if(self.lectureHsDetailViewModel) {
        lectureStage = (HSLectureStageModel *)self.lectureHsDetailViewModel.stageList[section];
    }
        if (section == self.lectureDetailViewModel.currentLectureIndexPath.section) {
        [lectureStage setHasExpand:YES];
    }
    if (lectureStage.hasExpand) {
        cellCount = [lectureStage.lectureClassArr count];
    }
    return cellCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    HSLectureCourseCell *courseCell = [tableView dequeueReusableCellWithIdentifier:@"HSLectureCourseCell"];
    HSLectureStageModel *lectureStage = [HSLectureStageModel new];
    
    if (self.lectureDetailViewModel) {
     lectureStage = (HSLectureStageModel *)self.lectureDetailViewModel.stageList[indexPath.section];
    }else if(self.lectureHsDetailViewModel) {
         lectureStage = (HSLectureStageModel *)self.lectureHsDetailViewModel.stageList[indexPath.section];
    }
    
    HSLectureClassModel *lectureClassModel = (HSLectureClassModel *)lectureStage.lectureClassArr[indexPath.row];
    [courseCell updateCellWithLectureClass:lectureClassModel];
    BOOL shouldSelected = [indexPath isEqual:self.lectureDetailViewModel.currentLectureIndexPath];
    BOOL hsshouldSelected = [indexPath isEqual:self.lectureHsDetailViewModel.currentLectureIndexPath];
    [courseCell setCurrentSelected:shouldSelected||hsshouldSelected];
    return courseCell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    HSLectureCourseCell *courseCell = (HSLectureCourseCell *)cell;
    BOOL shouldSelected = [indexPath isEqual:self.lectureDetailViewModel.currentLectureIndexPath];
    [courseCell setSelected:shouldSelected  animated:NO];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    HSLectureChapterHeader *chapterHeader = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"HSLectureChapterHeader"];
    [chapterHeader setDelegate:self];
 
    HSLectureStageModel *lectureStage = (HSLectureStageModel *)self.lectureDetailViewModel.stageList[section];
    HSLectureStageModel *lectureStageHs = (HSLectureStageModel *)self.lectureHsDetailViewModel.stageList[section];
    if (lectureStage) {
        [chapterHeader updateCellWithStageModel:lectureStage];
    }else{
        [chapterHeader updateCellWithStageModel:lectureStageHs];
    }
 
    return chapterHeader;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"%@",indexPath);
    if (self.lectureDetailViewModel) {
        if ([indexPath isEqual:self.lectureDetailViewModel.currentLectureIndexPath]) { return; }
        HSLectureCourseCell *preCell = (HSLectureCourseCell *)[tableView cellForRowAtIndexPath:self.lectureDetailViewModel.currentLectureIndexPath];
        [preCell setCurrentSelected:NO];
        
        [self.lectureDetailViewModel setCurrentLectureIndexPath:indexPath];
        HSLectureCourseCell *cell = (HSLectureCourseCell *)[tableView cellForRowAtIndexPath:indexPath];
        [cell setCurrentSelected:YES];
        //更新界面
        [self.mainVC chapterDidChanged];
    }else if(self.lectureHsDetailViewModel){
        if ([indexPath isEqual:self.lectureHsDetailViewModel.currentLectureIndexPath]) { return; }
        HSLectureCourseCell *preCell = (HSLectureCourseCell *)[tableView cellForRowAtIndexPath:self.lectureHsDetailViewModel.currentLectureIndexPath];
        [preCell setCurrentSelected:NO];
        
        [self.lectureHsDetailViewModel setCurrentLectureIndexPath:indexPath];
        HSLectureCourseCell *cell = (HSLectureCourseCell *)[tableView cellForRowAtIndexPath:indexPath];
        [cell setCurrentSelected:YES];
        //更新界面
        [self.mainVC chapterDidChanged];
    }
    
}

#pragma mark - Delegate

- (void)lectureChapterHeaderDidTapped:(HSLectureChapterHeader *)lectureChapterHeader
{
    [lectureChapterHeader.lectureStageModel changeExpandState];
    [self.tableView reloadData];
}
- (NSIndexPath *)selectedIndexPath {
    if (!_selectedIndexPath) {
        _selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    }
    return _selectedIndexPath;
}
@end
