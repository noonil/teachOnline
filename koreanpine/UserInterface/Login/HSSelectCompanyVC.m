//
//  HSSelectCompanyVC.m
//  koreanpine
//
//  Created by Christ on 15/7/15.
//  Copyright (c) 2015年 Christ. All rights reserved.
//

#import "HSSelectCompanyVC.h"
#import "HSRuntimeMgr.h"
#import "Common.h"
#import "HSSystemStart.h"
#import "YHEConvertGB_GIB.h"
#import "HSCompanyModel.h"
#import "UIBarButtonItem+WTXM.h"

#define kFrameImageViewInCell                       CGRectMake(248.0f, 0.0f, 44.0f, 44.0f)
#define kTagImageViewInCell                         10001
#define kTableViewCell_XDeviation                   15
#define kTableViewCell_YDeviation                   5

@interface HSSelectCompanyVC ()
<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>

@property (nonatomic, strong) UIView                    *topNavView;

@property (nonatomic, strong) UITableView               *tableView;

@property (nonatomic, strong) NSMutableArray            *searchedCompanys;

@property (nonatomic, strong) UISearchBar               *searchBar;
// 搜索中只有一个section
@property (nonatomic, getter = isSearching) BOOL        searching;

@property (assign ,nonatomic) BOOL                      isAnimationed;

- (void)initView;

@end

@implementation HSSelectCompanyVC

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.title              = @"选择企业名";
        self.searchedCompanys     = [NSMutableArray array];
        
        
    }
    return self;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}


- (BOOL)prefersStatusBarHidden
{
    return NO;
}

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initNotifi];
    [self initView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

#pragma mark -

- (void)showBrandSelection
{
    CGFloat height = CGRectGetMaxY(self.view.frame);

    CGRect frame = self.view.frame;
    frame.origin.y = height;
    self.view.frame = frame;
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.view.frame;
        frame.origin.y = 0;
        self.view.frame = frame;
    } completion:^(BOOL finished) {
        
    }];
    
}

- (void)cancelBrandSelection
{
    if (self.searchBar.isFirstResponder) {
        [self.searchBar resignFirstResponder];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -

- (void)initNotifi
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recvNotifi:) name:kNotifiCompanysInfos object:nil];
}

- (void)unInitNotifi
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)initView
{
        self.edgesForExtendedLayout                 = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars       = NO;
        self.automaticallyAdjustsScrollViewInsets   = NO;
   
    
    self.view.backgroundColor   = RGBCOLOR(235, 235, 235);
    
    self.bgImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [self.bgImageView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    [self.bgImageView setImage:self.bgImage];
    [self.view addSubview:self.bgImageView];
    
    //添加透明度为80%的图层
    UIView *alpaView = [[UIView alloc]initWithFrame:self.view.bounds];
    [alpaView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    [alpaView setBackgroundColor:[UIColor lightGrayColor]];
    [alpaView setAlpha:0.5];
    [self.view addSubview:alpaView];
    
    self.topNavView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 64.0f)];
    [self.topNavView setBackgroundColor:RGBCOLOR(87, 125, 202)];
    [self.topNavView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, CGRectGetWidth(self.topNavView.bounds), CGRectGetHeight(self.topNavView.bounds)-20.0f)];
    [titleLabel setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    [titleLabel setText:@"选择公司"];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:18.0]];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [self.topNavView addSubview:titleLabel];
    
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 44.0, 44.0)];
    [cancelBtn addTarget:self action:@selector(cancelBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setImage:[UIImage imageNamed:@"shared_back_icon"] forState:UIControlStateNormal];
    [self.topNavView addSubview:cancelBtn];
    [self.view addSubview:self.topNavView];
    
    UIButton *refresBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.topNavView.bounds)-44, 20, 44.0f, 44.0f)];
    [refresBtn setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin];
    [refresBtn addTarget:self action:@selector(refreshBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [refresBtn setImage:[UIImage imageNamed:@"refresh_n"] forState:UIControlStateNormal];
    [refresBtn.titleLabel setFont:[UIFont systemFontOfSize:13.0f]];
    [self.topNavView addSubview:refresBtn];
    
    //设置搜索条
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 64.0f, CGRectGetWidth(self.view.bounds), 44.0f)];
    if ([self.searchBar respondsToSelector:@selector(setSearchBarStyle:)]) {
        [self.searchBar setSearchBarStyle:UISearchBarStyleMinimal];
    } else {
        self.searchBar.barStyle = 3;
    }
    [self.searchBar setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [self.searchBar setBackgroundColor:[Common colorWithHexString:@"fbfbfb"]];
    [self.searchBar setSearchFieldBackgroundImage:[UIImage imageNamed:@"serach_bar_bg"] forState:UIControlStateNormal];
    [self.searchBar setPlaceholder:@"搜索企业"];
    [self.searchBar setDelegate:self];
    [self.view addSubview:self.searchBar];
    
    //设置tableView视图
    float yPos = CGRectGetMaxY(self.searchBar.frame);
    CGRect tableViewFrame = self.view.bounds;
    tableViewFrame.origin.y = yPos;
    tableViewFrame.size.height -= yPos;
    self.tableView  = [[UITableView alloc] initWithFrame:tableViewFrame];
    self.tableView .dataSource = self;
    self.tableView .delegate = self;
    [self.tableView setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
    self.tableView .backgroundColor = [UIColor clearColor];
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    [self.tableView setTableFooterView:[UIView new]];
    [self.view addSubview:self.tableView ];
}

- (void)recvNotifi:(NSNotification *)notifi
{
    [self.tableView reloadData];
}

- (void)cancelBtnTapped:(UIButton *)cancelBtn
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
//    [self.navigationController popViewControllerAnimated:YES];
}

- (void)refreshBtnTapped:(UIButton *)refreshBtn
{
    [[HSRuntimeMgr runtimeMgr] getCompanyInfo];
}

#pragma mark - Search Bar Delegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [self.tableView reloadData];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [self.tableView reloadData];
}

- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    //删除时length为0d
    if([text length] && ![searchBar.text length]){
        self.isAnimationed = YES;
    }else{
        self.isAnimationed = NO;
    }
    if (text.length==0) {
        return YES;
    }
    NSMutableString *textStr = [[NSMutableString alloc] initWithString:searchBar.text];
    [textStr replaceCharactersInRange:range withString:text];
    if (textStr.length > 20) {
//        [self.view alert:@"最多20个字符" type:YHAlertTypeFail];
        return NO;
    }
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    self.searching = searchBar.text.length>0?YES:NO;
    YHEConvertGB_GIB *convert = [[YHEConvertGB_GIB alloc] init];
    //转繁体数据
    NSString *big5String = [convert gbToBig5:searchText];
    //用于头部匹配
    NSPredicate *beginWithPredicate = [NSPredicate predicateWithFormat:@"companyName BEGINSWITH[cd] %@ OR companyName BEGINSWITH[cd] %@",searchText,big5String];
    NSArray *searchingResultArr = [[HSRuntimeMgr runtimeMgr].companyItems filteredArrayUsingPredicate:beginWithPredicate];

    __weak __typeof(self)weakSelf = self;
    [weakSelf.searchedCompanys removeAllObjects];
    [weakSelf.searchedCompanys addObjectsFromArray:searchingResultArr];
    [weakSelf.tableView reloadData];
}

-(void)updateTableViewData:(NSArray*)searchingResultArr
{
    [self.searchedCompanys removeAllObjects];
    [self.searchedCompanys addObjectsFromArray:searchingResultArr];
    [self.tableView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}


- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.tableView reloadData];
    [searchBar resignFirstResponder];
}


#pragma mark - UITableView datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //1.如果在搜索时
    if(self.searching) {
        return self.searchedCompanys.count;
    } else {
        return [HSRuntimeMgr runtimeMgr].companyItems.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    
    YHEBrandListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell){
        cell = [[YHEBrandListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSString *name = @"";
    
    //1.正在搜索
    if (self.searching) {
        HSCompanyModel *companyItem = self.searchedCompanys[indexPath.row];
        name = companyItem.companyName;
    }
    //2.不在搜索状态下正常显示情况
    else{
        HSCompanyModel *companyItem = [HSRuntimeMgr runtimeMgr].companyItems[indexPath.row];
        name = companyItem.companyName;
    }
    [cell fillCellWithText:name];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    
    if (self.isSearching) {
        HSCompanyModel *companyItem = self.searchedCompanys[row];
        [self.delegate companyListVC:self companyModel:companyItem];
    } else {
       HSCompanyModel *companyItem = [HSRuntimeMgr runtimeMgr].companyItems[row];
        [self.delegate companyListVC:self companyModel:companyItem];
    }
    //将视图移除掉
//    [self dismissViewControllerAnimated:YES completion:^{
//        
//    }];
    [self cancelBrandSelection];
//    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Scroll View delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.searchBar resignFirstResponder];
}

@end

#pragma mark - Class YHEBrandListCell

@interface YHEBrandListCell()
@property (strong, nonatomic) UIView *snapView;
@property (assign, nonatomic) BOOL isAnimating;
@end

@implementation YHEBrandListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initCell];
    }
    return self;
}

- (void)initCell
{
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, 300, CGRectGetHeight(self.contentView.bounds))];
    [self.contentLabel setFont:[UIFont systemFontOfSize:15.0f]];
    [self.contentLabel setTextColor:[UIColor blackColor]];
    [self.contentLabel setBackgroundColor:[UIColor clearColor]];
    [self.contentView addSubview:self.contentLabel];
    
}

- (void)resetCell
{
    [self.contentLabel setText:@""];
}

- (void)fillCellWithText:(NSString *)text
{
    self.snapView = [self snapshotViewAfterScreenUpdates:YES];
    [self.contentLabel setText:text];
}

@end