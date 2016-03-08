//
//  HSLectureSearchVC.m
//  koreanpine
//
//  Created by Christ on 15/8/21.
//  Copyright (c) 2015年 Christ. All rights reserved.
//

#import "HSLectureSearchVC.h"
#import "HSCollectionView.h"
#import "HSLectureSearchViewModel.h"
#import "HSMineLectureCell.h"
#import "HSLectureDetailVC.h"
#import "HSLectureTopCell.h"
#import "DDCollectionViewFlowLayout.h"

@interface HSLectureSearchVC ()
<UITableViewDataSource,UITableViewDelegate,YH_ArrayDataLoadDelegate,UISearchBarDelegate>

@property (strong, nonatomic) HSLectureSearchViewModel *lectureSearchVM;

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) UISearchBar *searchBar;

@property (nonatomic,assign) BOOL isHs;
@end

@implementation HSLectureSearchVC
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
    
    self.lectureSearchVM = [[HSLectureSearchViewModel alloc] init];
    [self.lectureSearchVM setDelegate:self];
    
    self.title = @"搜索课程";
    
    UIBarButtonItem *leftBarBtn = [[UIBarButtonItem alloc] initWithCustomView:self.backBtn];
    [self.navigationItem setLeftBarButtonItem:leftBarBtn];
    
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.bounds), 44)];
    [self.searchBar setPlaceholder:@"搜索课程"];
    [self.searchBar setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [self.searchBar setDelegate:self];
    [self.view addSubview:self.searchBar];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 108, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-108) style:UITableViewStylePlain];
    [self.tableView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    [self.tableView registerNib:[UINib nibWithNibName:@"HSMineLectureCell" bundle:nil] forCellReuseIdentifier:@"CellIdent"];
    [self.tableView setDataSource:self];
    [self.tableView setDelegate:self];
    [self.tableView setTableFooterView:[UIView new]];
    [self.view addSubview:self.tableView];
    

    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    rightBarItem.width = 20;
    [self.navigationItem setRightBarButtonItem:rightBarItem];
    
//    __weak typeof(self) weakSelf = self;
//    
//    [self.tableView addLegendFooterWithRefreshingBlock:^{
//        [weakSelf.lectureSearchVM fetchMore];
//    }];
}

#pragma mark - UITableView Datasource and Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.lectureSearchVM contentCount];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HSMineLectureCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdent"];
    HSMineLectureModel *lectureModel = (HSMineLectureModel *)[self.lectureSearchVM contentAtIndex:indexPath.row];
    [cell updateCellWith:lectureModel];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 82.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HSMineLectureModel *lectureModel = (HSMineLectureModel *)[self.lectureSearchVM contentAtIndex:indexPath.row];
    HSLectureDetailVC *nextVC = [HSLectureDetailVC new];
    if (lectureModel.isHs) {
        nextVC = [[HSLectureDetailVC alloc] initWithNibName:@"HSLectureDetailVC" bundle:nil lectureModel:lectureModel isHs:YES ClassID:nil];
    }else {
         nextVC = [[HSLectureDetailVC alloc] initWithNibName:@"HSLectureDetailVC" bundle:nil lectureModel:lectureModel isHs:NO ClassID:nil];
    }

    [self.navigationController pushViewController:nextVC animated:YES];
}

#pragma mark -

- (void)arrayDataMgr:(YH_ArrayDataMgr *)arrayDataMgr didFinishFetch:(CHFetchType)fetchType succeed:(BOOL)succeed error:(NSError *)error
{
    if (fetchType == CHFetchLatest) {
        [self.tableView.header endRefreshing];
    } else {
        [self.tableView.footer endRefreshing];
    }
    
    if ([arrayDataMgr contentCount] == 0) {
        [[Hud defaultInstance] showMessage:@"没有找到相应的课程"];
    }
    
    [self.tableView reloadData];
}

#pragma mark - UISearchBar Delegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [self.searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.searchBar resignFirstResponder];
    [self.searchBar setShowsCancelButton:NO animated:YES];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.searchBar resignFirstResponder];
    [self.searchBar setShowsCancelButton:NO animated:YES];
    [self.lectureSearchVM setQueryValue:searchBar.text];
}

@end
