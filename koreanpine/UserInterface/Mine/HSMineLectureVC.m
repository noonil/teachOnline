//
//  HSMineLectureVC.m
//  koreanpine
//
//  Created by Christ on 15/7/18.
//  Copyright (c) 2015年 Christ. All rights reserved.
//

#import "HSMineLectureVC.h"
#import "HSMineLectureCell.h"
#import "HSMineLectureViewModel.h"
#import "HSMineLectureModel.h"
#import "HSLectureDetailVC.h"
#import "MJRefresh.h"

@interface HSMineLectureVC ()
<UITableViewDataSource,UITableViewDelegate,YH_ArrayDataLoadDelegate>

@property (strong, nonatomic) HSMineLectureViewModel *mineLectureViewModel;

@property (strong, nonatomic) UITableView *tableView;

@end

@implementation HSMineLectureVC

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
    self.mineLectureViewModel = [[HSMineLectureViewModel alloc] init];
    [self.mineLectureViewModel setDelegate:self];
    
    self.title = @"我的课程";
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:self.backBtn];
    self.navigationItem.leftBarButtonItem = backItem;
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.tableView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    [self.tableView registerNib:[UINib nibWithNibName:@"HSMineLectureCell" bundle:nil] forCellReuseIdentifier:@"CellIdent"];
    [self.tableView setDataSource:self];
    [self.tableView setDelegate:self];
    [self.tableView setTableFooterView:[UIView new]];
    [self.view addSubview:self.tableView];
    
    
    __weak typeof(self) weakSelf = self;
    [self.tableView addLegendHeaderWithRefreshingBlock:^{
        [weakSelf.tableView.footer resetNoMoreData];
        [weakSelf.mineLectureViewModel fetchLatest];
    }];
    
    [self.tableView addLegendFooterWithRefreshingBlock:^{
        [weakSelf.mineLectureViewModel fetchMore];
    }];
    
    [self.tableView.header beginRefreshing];
}

#pragma mark - UITableView Datasource and Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.mineLectureViewModel contentCount];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HSMineLectureCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdent"];
    HSMineLectureModel *lectureModel = (HSMineLectureModel *)[self.mineLectureViewModel contentAtIndex:indexPath.row];
    [cell updateCellWith:lectureModel];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 82.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HSLectureModel *lectureModel = (HSLectureModel *)[self.mineLectureViewModel contentAtIndex:indexPath.row];
    HSLectureDetailVC *nextVC = [[HSLectureDetailVC alloc] initWithNibName:@"HSLectureDetailVC" bundle:nil lectureModel:lectureModel isHs:NO ClassID:nil];
    [self.navigationController pushViewController:nextVC animated:YES hideBottomTabBar:YES];
}

#pragma mark -

- (void)arrayDataMgr:(YH_ArrayDataMgr *)arrayDataMgr didFinishFetch:(CHFetchType)fetchType succeed:(BOOL)succeed error:(NSError *)error
{
    if (fetchType == CHFetchLatest) {
        [self.tableView.header endRefreshing];
    } else {
        [self.tableView.footer endRefreshing];
    }
    
    if (!arrayDataMgr.hasMoreItems) {
        [self.tableView.footer noticeNoMoreData];
    }
    [self.tableView.footer setHidden:!self.mineLectureViewModel.hasMoreItems];
    [self.tableView reloadData];
}


@end
