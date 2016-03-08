//
//  HSHomeVC.m
//  koreanpine
//
//  Created by Christ on 15/7/15.
//  Copyright (c) 2015年 Christ. All rights reserved.
//

#import "HSHomeVC.h"
#import "PowerfulBannerView.h"
#import "HSHomeInfoCell.h"
#import "HSHomeSectionHeader.h"
#import "HSHomeViewModel.h"
#import "PowerfulBannerView.h"
#import "HSMineExamVC.h"
#import "SMPageControl.h"

@interface HSHomeVC ()
<UITableViewDataSource,UITableViewDelegate,HSHomeViewModelDelegate>

@property (strong ,nonatomic) UITableView *tableView;

@property (strong, nonatomic) PowerfulBannerView *powerBannerView;

@property (strong, nonatomic) SMPageControl *pageControl;

@property (strong ,nonatomic) HSHomeViewModel *homeVM;

@end

@implementation HSHomeVC

- (instancetype)init
{
    return [super init];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
    [self setTitle:@"首页"];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initView
{
    [self.view setBackgroundColor:RGBCOLOR(235, 235, 235)];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-49.f) style:UITableViewStyleGrouped];
    [self.tableView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    [self.tableView setTableFooterView:[UIView new]];
    [self.tableView setDataSource:self];
    [self.tableView setDelegate:self];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:self.tableView];
    
    self.powerBannerView = [[PowerfulBannerView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 125.0f*kScreenPointScale)];
    [self.powerBannerView setInfiniteLooping:YES];
    [self.powerBannerView setAutoLooping:YES];
    [self.powerBannerView addSubview:self.pageControl];
    self.powerBannerView.pageControl = self.pageControl;
    
    
    UIView *tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.powerBannerView.frame))];
    [tableHeaderView addSubview:self.powerBannerView];
    [tableHeaderView setBackgroundColor:[UIColor clearColor]];
    [self.tableView setTableHeaderView:tableHeaderView];
    
    self.homeVM = [[HSHomeViewModel alloc] init];
    [self.homeVM setDelegate:self];
    
    [self.powerBannerView setItems:self.homeVM.bannerImageNames];
    
    self.powerBannerView.bannerItemConfigurationBlock = ^UIView *(PowerfulBannerView *banner, id item, UIView *reusableView){
        NSString *imageName = (NSString *)item;
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
        [imageView setFrame:banner.bounds];
        return imageView;
    };
    
    [self.powerBannerView reloadData];
}

- (SMPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[SMPageControl alloc] initWithFrame:CGRectMake(0, 105.f*kScreenPointScale, CGRectGetWidth(self.view.frame), 10.f)];
        _pageControl.indicatorMargin = 5.0f;
        _pageControl.indicatorDiameter = 5.0f;
        _pageControl.currentPageIndicatorImage = [UIImage imageNamed:@"point1"];
        _pageControl.pageIndicatorImage = [UIImage imageNamed:@"point2"];
        _pageControl.backgroundColor = [UIColor clearColor];
    }
    return _pageControl;
}

#pragma mark - UITableView Datasource and Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.homeVM tableViewSectionCount];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.homeVM tableViewNumberOfRowsInSection:section];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    HSHomeSectionHeader *sectionHeader = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"SectionHeader"];
    if (!sectionHeader) {
        sectionHeader = [[HSHomeSectionHeader alloc] initWithReuseIdentifier:@"SectionHeader"];
    }
    HSHomeSectionTitle *homeSectionTitle = [self.homeVM tableViewHomeSectionTitleAtSection:section];
    [sectionHeader updateSectionHeaderWith:homeSectionTitle];
    return sectionHeader;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HSHomeInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdent"];
    if (!cell) {
        cell = [[HSHomeInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellIdent"];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    }
    [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    HSHomeCellInfo *cellInfo = [self.homeVM tableViewHomeCellInfoAtIndexPath:indexPath];
    [cell updateCellWith:cellInfo];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 47.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 47.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
//            [self.tabBarController setSelectedIndex:2];
        } else {
            [self.tabBarController setSelectedIndex:1];
        }
    }
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
//            [self.tabBarController setSelectedIndex:2];
        } else {
            [self.tabBarController setSelectedIndex:1];
        }
    }
    
//    HSMineExamVC *nextVC = [[HSMineExamVC alloc] init];
//    [self.navigationController pushViewController:nextVC animated:YES hideBottomTabBar:YES];
}

#pragma mar - HSHomeViewModelDelegate

- (void)homeViewModelDidUpdateCellInfo:(HSHomeViewModel *)homeViewModel
{
    [self.tableView reloadData];
}

@end
