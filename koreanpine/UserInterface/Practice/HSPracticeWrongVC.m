//
//  HSPracticeWrongVC.m
//  koreanpine
//
//  Created by 陶山强 on 15/11/5.
//  Copyright © 2015年 Christ. All rights reserved.
//

#import "HSPracticeWrongVC.h"
#import "HSPracticeWrongCell.h"
#import "HSPracticeWrongViewModel.h"
#import "HSPracticeWrongModel.h"
#import "MJRefresh.h"
#import "HSPracticeWrongDetailVC.h"
#import "UIView+WTXM.h"
#import "HSExerciseDetailVC.h"
#define screenRect [[UIScreen mainScreen]bounds]
@interface HSPracticeWrongVC ()<UITableViewDataSource,UITableViewDelegate,YH_ArrayDataLoadDelegate>
{
    UINib *nib;
}


@property(nonatomic,strong)HSPracticeWrongViewModel *practiceWrongViewModel;
@property(nonatomic,strong)UITableView *wrongListView;
@end

@implementation HSPracticeWrongVC

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"wrongListRefreshNotification" object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
    self.practiceWrongList = [self.practiceWrongViewModel contents];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(receiveNotify:) name:@"wrongListRefreshNotification" object:nil];
}
-(void)receiveNotify:(NSNotification *)notify{
    [self wrongListViewReload];
//    [self.practiceWrongViewModel fetchLatest];
//    WS(weakSelf);
//    self.practiceWrongViewModel.reloadBlock = ^() {
//        [weakSelf.wrongListView reloadData];
//    };
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
////        新添加的delegate
//        self.practiceWrongViewModel.delegate = weakSelf;
//        [self.practiceWrongViewModel fetchLatest];
//    });
//    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)initView{
    self.wrongListView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenRect.size.width, screenRect.size.height-49-64)];

    

    [self.wrongListView setDelegate:self];
    [self.wrongListView setDataSource:self];
    
    self.practiceWrongViewModel = [[HSPracticeWrongViewModel alloc] init];
    [self.practiceWrongViewModel setDelegate:self];
    

    

    [self.view addSubview:self.wrongListView];
    self.wrongListView.tableHeaderView = nil;
    self.wrongListView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self wrongListViewReload];


    
}
-(void)wrongListViewReload{
   
    __weak typeof(self) weakSelf = self;
    [self.wrongListView addLegendHeaderWithRefreshingBlock:^{
        [weakSelf.wrongListView.footer resetNoMoreData];
        weakSelf.practiceWrongViewModel.delegate = weakSelf;
        [weakSelf.practiceWrongViewModel fetchLatest];
    }];
    
//    [self.wrongListView addLegendFooterWithRefreshingBlock:^{
//        [weakSelf.practiceWrongViewModel fetchMore];
//    }];

    [self.wrongListView.header beginRefreshing];
}
-(void)fetchLatests{
    [self.practiceWrongViewModel fetchLatest];
}

#pragma mark - UITableView Datasource and Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.practiceWrongViewModel contentCount];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    if (nib == nil) {
        nib = [UINib nibWithNibName:@"HSPracticeWrongCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:@"CellIdent"];
    }
    HSPracticeWrongCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdent"];
    HSPracticeWrongModel *practiceWrongModel = (HSPracticeWrongModel *)[self.practiceWrongViewModel contentAtIndex:indexPath.row];
    NSInteger count = [self.practiceWrongViewModel contentCount];
    NSString *wrongNum = [NSString stringWithFormat:@"%ld",count - indexPath.row];
    
    [cell updateCellWith:practiceWrongModel wrongNum:wrongNum];
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    view.backgroundColor = RGBACOLOR(0, 0, 0, 0.2);
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.5;
}
//推出做题界面
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    HSDoHomeworkViewModel *doHomeworkViewModel = (HSDoHomeworkViewModel *)[self.practiceWrongViewModel contents];
//    NSLog(@"%d",indexPath.row);
    
    HSPracticeWrongDetailVC *nextVC = [[HSPracticeWrongDetailVC alloc]initWithNibName:@"HSPracticeWrongDetailVC" bundle:nil];
    nextVC.doHomeWorkViewModel = doHomeworkViewModel;
    nextVC.detailViewModel = [[HSPracticeWrongViewModel alloc]init];
    nextVC.detailViewModel = self.practiceWrongViewModel;
    nextVC.selectedIndex = indexPath.row;
    nextVC.hidesBottomBarWhenPushed = YES;
    nextVC.detailViewModel.showAnswers = NO;
    [self.navigationController pushViewController:nextVC animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (CGRectGetWidth(screenRect) >320) {
        return 52;
    }
    
    return 48.0f;
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return NO;
}

#pragma mark -重写cell线条靠边
//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//
//{
//    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
//        [cell setSeparatorInset:UIEdgeInsetsZero];
//    }
//    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
//        [cell setLayoutMargins:UIEdgeInsetsZero];
//    }
//}

#pragma mark -

- (void)arrayDataMgr:(YH_ArrayDataMgr *)arrayDataMgr didFinishFetch:(CHFetchType)fetchType succeed:(BOOL)succeed error:(NSError *)error
{
    if (error) {
        [self.wrongListView.header endRefreshing];
    }
    if (fetchType == CHFetchLatest) {
        [self.wrongListView.header endRefreshing];
    } else {
        [self.wrongListView.footer endRefreshing];
    }
    [self.wrongListView.footer setHidden:!self.practiceWrongViewModel.hasMoreItems];
    
    UIView *rewardView = [[UIView alloc]initWithFrame:screenRect];
    UIImageView *rewardImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(screenRect)-200,(CGRectGetWidth(screenRect)-200)/410*317)];
    rewardImage.centerX = rewardView.centerX;
    rewardImage.centerY = rewardView.centerY-64;
    rewardImage.image = [UIImage imageNamed:@"5"];
    [rewardView addSubview:rewardImage];
    UILabel *rewardLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(screenRect), 20)];
    rewardLabel.centerX = rewardView.centerX;
    rewardLabel.centerY = CGRectGetMaxY(rewardImage.frame)+10;
    rewardLabel.text = @"好厉害！一个错题也没有哦~";
    rewardLabel.textAlignment = NSTextAlignmentCenter;
    rewardLabel.alpha = 0.7;
    [rewardView addSubview:rewardLabel];
    
    UILabel *rewardLabel_2 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(rewardLabel.frame), CGRectGetHeight(rewardLabel.frame))];
    rewardLabel_2.centerX = rewardView.centerX;
    rewardLabel_2.centerY = CGRectGetMaxY(rewardLabel.frame)+10;
    rewardLabel_2.text = @"快去                一下吧~";
    rewardLabel_2.textAlignment = NSTextAlignmentCenter;
    rewardLabel_2.alpha = 0.7;
    [rewardView addSubview:rewardLabel_2];

    UIButton *rewardBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, CGRectGetHeight(rewardLabel.frame))];
    rewardBtn.centerX = rewardLabel_2.centerX-15;
    rewardBtn.centerY = rewardLabel_2.centerY;
    [rewardBtn setTitle:@"“练习”" forState:UIControlStateNormal];
    [rewardBtn setTitleColor:RGBACOLOR(85, 125, 201, 1) forState:UIControlStateNormal];
    rewardBtn.alpha = 0.7;
    [rewardBtn addTarget:self action:@selector(rewardBtnTouch) forControlEvents:UIControlEventTouchUpInside];
    [rewardView addSubview:rewardBtn];
    UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipe:)];
    swipeDown.direction = UISwipeGestureRecognizerDirectionDown;
    [rewardView addGestureRecognizer:swipeDown];
    
    
    UIImageView *headerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, screenRect.size.width, screenRect.size.width*238/720)];
    headerImageView.image = [UIImage imageNamed:@"practiceWrong"];
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenRect.size.width, screenRect.size.width*238/720+20)];
    headerView.backgroundColor = RGBACOLOR(0, 0, 0, 0.1);
    [headerView addSubview:headerImageView];
    //    self.wrongListView.separatorStyle = UITableViewCellSeparatorStyleNone;

    if (self.practiceWrongViewModel.contentCount == 0 && succeed) {
        self.wrongListView.tableHeaderView = rewardView;
        self.wrongListView.scrollEnabled = NO;
    }else{
         self.wrongListView.tableHeaderView = headerView;
        self.wrongListView.scrollEnabled = YES;
    }
    if (succeed) {
        [self.wrongListView reloadData];
    }else{
        [[Hud defaultInstance]showMessage:@"网络连接失败"];
    }
    
}
-(void)swipe:(UIGestureRecognizer *)recognizer{
    [self.practiceWrongViewModel fetchLatest];
}
-(void)rewardBtnTouch{
//    [[NSNotificationCenter defaultCenter]postNotificationName:@"showpracticePKVCNotify" object:nil];
    HSExerciseDetailVC *exercise = [[HSExerciseDetailVC alloc] initWithHomeworkModel:nil];
    exercise.hidesBottomBarWhenPushed = YES;
    [self.parentViewController.navigationController pushViewController:exercise animated:YES];
}
- (void)arrayDataMgrUpdateData:(YH_ArrayDataMgr *)arrayDataMgr
{
    [self.wrongListView reloadData];
    //    [self.yhCollectionHsView reloadData];
}




@end
