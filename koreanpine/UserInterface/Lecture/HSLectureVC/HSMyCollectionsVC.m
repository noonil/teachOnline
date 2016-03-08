//
//  HSMyCollectionsVC.m
//  koreanpine
//
//  Created by 陶山强 on 15/10/27.
//  Copyright © 2015年 Christ. All rights reserved.
//

#import "HSMyCollectionsVC.h"

//#import "HSMineLectureVC.h"
//#import "HSMineLectureCell.h"
#import "HSMyCollectionCell.h"
//#import "HSMineLectureViewModel.h"
//#import "HSMyCollectionViewModel.h"
#import "HSMyCollectionModel.h"
#import "HSLectureDetailVC.h"
#import "MJRefresh.h"


@interface HSMyCollectionsVC ()<YH_ArrayDataLoadDelegate,HSMyCollectionCellDelegate>

//@property (strong, nonatomic) HSMyCollectionViewModel *mycollectLectureViewModel;
@property (nonatomic,strong) UIButton *actionBtn;
@property (nonatomic,strong) NSMutableArray *selectedIndexPaths;
@end

@implementation HSMyCollectionsVC



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(receivedNotify:) name:@"mycollectionReloadRefresh" object:nil];
    
}
-(void)receivedNotify:(NSNotification *)notify{
    [self.mycollectLectureViewModel fetchLatest];
    WS(weakSelf);
    self.mycollectLectureViewModel.reloadBlock = ^() {
        [weakSelf.tableView reloadData];
    };
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.mycollectLectureViewModel fetchLatest];
        [self.tableView.header beginRefreshing];
    });
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kHideTableViewEditingNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kDeleteMyCollectionsNotification object:nil];
}
- (void)initView
{
    self.mycollectLectureViewModel = [[HSMyCollectionViewModel alloc] init];
    [self.mycollectLectureViewModel setDelegate:self];
    [self.tableView registerNib:[UINib nibWithNibName:@"HSMyCollectionCell" bundle:nil] forCellReuseIdentifier:@"CellIdent"];
    [self.tableView setTableFooterView:[UIView new]];
//    [self.tableView setFrame:CGRectMake(0, 0, self.view.frame.size.width, [UIScreen mainScreen].bounds.size.height-200)];
//    NSLog(@"%f",self.tableView.frame.size.height);
    
    __weak typeof(self) weakSelf = self;
    [self.tableView addLegendHeaderWithRefreshingBlock:^{
        [weakSelf.tableView.footer resetNoMoreData];
        [weakSelf.mycollectLectureViewModel fetchLatest];
    }];
    
    [self.tableView addLegendFooterWithRefreshingBlock:^{
        [weakSelf.mycollectLectureViewModel fetchMore];
    }];
    
    [self.tableView.header beginRefreshing];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tableViewEndEditing:) name:kHideTableViewEditingNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteMyCollections:) name:kDeleteMyCollectionsNotification object:nil];
}

#pragma mark - UITableView Datasource and Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.mycollectLectureViewModel contentCount];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HSMyCollectionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdent"];
    HSMyCollectionModel *lectureModel = (HSMyCollectionModel *)[self.mycollectLectureViewModel contentAtIndex:indexPath.row];
    [cell updateCellWith:lectureModel];
    cell.checkmarkBtn.selected = NO;
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 82.0f;
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return NO;
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
    [self.tableView.footer setHidden:!self.mycollectLectureViewModel.hasMoreItems];
    [self.tableView reloadData];
}
- (void) tableViewEndEditing:(NSNotification *)notify {
    
    for (NSIndexPath *indexPath in self.selectedIndexPaths) {
        HSMyCollectionCell *cell = (HSMyCollectionCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        cell.checkmarkBtn.selected = NO;
    }
    [self.selectedIndexPaths removeAllObjects];
   [self.tableView setEditing:NO animated:YES];
}
#pragma mark - HSMycollectionCellDelegate
- (void) checkmarkBtnTapped:(HSMyCollectionCell *)cell {
     NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    if ([self.selectedIndexPaths containsObject:indexPath]) {
        [self.selectedIndexPaths removeObject:indexPath];
    }else {
        [self.selectedIndexPaths addObject:indexPath];
    }
}
- (void)jumpToLectureView:(HSMyCollectionCell *)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    HSLectureModel *lectureModel = (HSLectureModel *)[self.mycollectLectureViewModel contentAtIndex:indexPath.row];
    lectureModel.isCollect = 1;
    HSLectureDetailVC *nextVC = nil;
    if ([(lectureModel.collectSource)intValue] == 1) {
        nextVC = [[HSLectureDetailVC alloc] initWithNibName:@"HSLectureDetailVC" bundle:nil lectureModel:lectureModel isHs:NO ClassID:nil];
    }else if([(lectureModel.collectSource)intValue] == 2) {
        nextVC = [[HSLectureDetailVC alloc] initWithNibName:@"HSLectureDetailVC" bundle:nil lectureModel:lectureModel isHs:YES ClassID:nil];
    }
    
    [self.navigationController pushViewController:nextVC animated:YES hideBottomTabBar:YES];
}
- (void)longPressGestureRecognizerActive:(HSMyCollectionCell *)cell {
    [[NSNotificationCenter defaultCenter] postNotificationName:kShowTableViewEditingNotification object:nil];
    [self.tableView setEditing:YES animated:YES];
   BOOL exist = [self.selectedIndexPaths containsObject:[self.tableView indexPathForCell:cell]];
    if (exist) {
        return;
    }
    cell.checkmarkBtn.selected = YES;
    
    [self.selectedIndexPaths addObject:[self.tableView indexPathForCell:cell]];
  
}
- (void) deleteMyCollections:(NSNotification *)notify {
    NSInteger count = 0;
    for (NSIndexPath *indexPath in self.selectedIndexPaths) {
        HSLectureModel *lectureModel = (HSLectureModel *)[self.mycollectLectureViewModel contentAtIndex:indexPath.row];

        //  TODO:此处添加删除后发送请求
        WS(weakSelf);
        __block NSInteger countBlock = count;
        [self.mycollectLectureViewModel deleteCollectionCell:lectureModel.lectureID collectID:lectureModel.collectInfoID isHS:[(lectureModel.hsCourseFlag)intValue] succeededHandler:^() {
            if (countBlock == weakSelf.selectedIndexPaths.count) {
                [weakSelf.mycollectLectureViewModel fetchLatest];
            }else {
                countBlock++;
            }
        } failedHandler:^() {
            
        }];
        
     
    }
    for (NSIndexPath *indexPath in self.selectedIndexPaths) {
         [self.mycollectLectureViewModel deleteContentAtIndex:indexPath.row];
    }
//    [self.tableView deleteRowsAtIndexPaths:self.selectedIndexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    //        取消收藏后刷新界面
    
    [self.tableView.header beginRefreshing];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView.header endRefreshing];
    });
    [self.selectedIndexPaths removeAllObjects];
}
#pragma mark -重写cell线条靠边
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath

{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
#pragma mark - 懒加载

- (NSMutableArray *)selectedIndexPaths {
    if (!_selectedIndexPaths) {
        _selectedIndexPaths = [NSMutableArray array];
    }
    return _selectedIndexPaths;
}
@end
