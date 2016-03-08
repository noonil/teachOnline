//
//  HSOrgViewController.m
//  koreanpine
//
//  Created by 陶山强 on 15/10/21.
//  Copyright © 2015年 Christ. All rights reserved.
//

#import "HSOrgViewController.h"
#import "HSLectureVC.h"
#import "HSCollectionView.h"
#import "HSLectureViewModel.h"
#import "HSLectureHeaderView.h"
#import "HSLectureItemCell.h"
#import "HSLectureDetailVC.h"
#import "HSLectureSearchVC.h"
#import "HSLectureTopCell.h"
#import "DDCollectionViewFlowLayout.h"
#import "UIView+WTXM.h"


@interface HSOrgViewController ()
<UICollectionViewDataSource,UICollectionViewDelegate,DDCollectionViewDelegateFlowLayout,HSLectureItemCellDelegate,YH_ArrayDataLoadDelegate>

@property (strong, nonatomic) HSCollectionView *yhCollectionView;
//@property(strong,nonatomic)HSCollectionView *yhCollectionHsView;
@property (strong, nonatomic) HSLectureViewModel *lectureViewModel;
//@property (strong, nonatomic) HSLectureHsViewModel *lectureHsViewModel;
//@property (strong,nonatomic)UIView *thirdView;
//@property (strong,nonatomic)UIImageView *placeHolderimageView;
//@property (nonatomic,strong) UISegmentedControl *segmentedCtrl;
//@property (nonatomic,assign) NSInteger appType;
//@property(nonatomic,strong)UIScrollView *lectureView;

@end

@implementation HSOrgViewController
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"orgRefreshNotification" object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(receiveNotify:) name:@"orgRefreshNotification" object:nil];
}
-(void)receiveNotify:(NSNotification *)notify{
    [self.lectureViewModel fetchLatest];
    WS(weakSelf);
    self.lectureViewModel.reloadBlock = ^() {
        [weakSelf.yhCollectionView reloadData];
    };
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.lectureViewModel fetchLatest];
    });
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)initView
{
    self.title = @"课程";
    //    self.navigationItem.titleView = self.segmentedCtrl;
    
    self.lectureViewModel = [[HSLectureViewModel alloc] init];
    //    self.lectureHsViewModel = [[HSLectureHsViewModel alloc] init];
    //    self.thirdView = [[UIView alloc]init];
    //    self.thirdView.backgroundColor = [UIColor grayColor];
    
    
    [self.lectureViewModel setDelegate:self];
    //    [self.lectureHsViewModel setDelegate:self];
    
    
    
//    UIScrollView *lectureView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
//    lectureView.contentSize = CGSizeMake(3*self.view.frame.size.width, 0);
//    lectureView.pagingEnabled = YES;
//    lectureView.showsVerticalScrollIndicator = NO;
//    lectureView.showsHorizontalScrollIndicator = NO;
//    lectureView.delegate = self;
    
//    self.lectureView = lectureView;
//    [self.view addSubview:lectureView];

        [self.view addSubview:self.yhCollectionView];
    //    [self.lectureView addSubview:self.yhCollectionHsView];

    //    UIButton *searchBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    //    [searchBtn addTarget:self action:@selector(righBarBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    //    [searchBtn setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    //    [searchBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    //
    //    UIBarButtonItem *rightBarBtn = [[UIBarButtonItem alloc] initWithCustomView:searchBtn];
    //    [self.navigationItem setRightBarButtonItem:rightBarBtn];
    //
    //    self.lectureViewModel.ModelUrl =  @"com/courseV1_4/hsCourseList";
    [self collectionViewReload];
}

//- (void) addSubviewInScrollView {
//    NSInteger count = self.segmentedCtrl.numberOfSegments;
//    for (int i=0; i<count; i++) {
//        switch (i) {
//            case 0:
//                [self.lectureView addSubview:self.yhCollectionView];
//                break;
//            case 1:
//                [self.lectureView addSubview:self.yhCollectionHsView];
//                break;
//            case 2:
//                switch (self.appType) {
//                    case HSAppTypeZhiXueTang:
//                        self.thirdView.frame = CGRectMake(self.view.bounds.size.width*2, 0, self.view.bounds.size.width, self.view.bounds.size.height);
//                        [self.lectureView addSubview:self.thirdView];
//                        [self.thirdView addSubview:self.placeHolderimageView];
//                        break;
//                    case HSAppTypeHongSongPai:
//                        break;
//                    default:
//                        break;
//                }
//                break;
//            default:
//                break;
//        }
//    }
//}

//- (void) segmentedControlDidTouchDown:(UISegmentedControl *)sender {
//    switch (sender.selectedSegmentIndex) {
//        case 0:
//            [self showyhCollectionview];
//            break;
//        case 1:
//            [self showyhCollectionHsView];
//            break;
//        case 2:
//            switch (self.appType) {
//                case HSAppTypeZhiXueTang:
//                    [self showthirdView];
//                    break;
//                case HSAppTypeHongSongPai:
//                    break;
//                default:
//                    break;
//            }
//            break;
//        default:
//            break;
//    }
//}

//-(void)showyhCollectionview{
//       self.lectureView.contentOffset = CGPointMake(0, 0);
//}
//
//-(void)showyhCollectionHsView{
//    self.lectureView.contentOffset = CGPointMake(self.view.bounds.size.width, 0);
//}
//
//-(void)showthirdView{
//    self.lectureView.contentOffset = CGPointMake(self.view.bounds.size.width*2, 0);
//}
-(void)collectionViewReload{
    __weak typeof(self) weakSelf = self;
    [self.yhCollectionView addRefreshActionHandler:^{
        [weakSelf.lectureViewModel fetchLatest];
    }];
    [self.yhCollectionView addLoadMoreActionHandler:^{
        [weakSelf.lectureViewModel fetchMore];
    }];
    [self.yhCollectionView.header beginRefreshing];
//    self.view.userInteractionEnabled = NO;
    
    
    
    //        [self.yhCollectionHsView addRefreshActionHandler:^{
    //            [weakSelf.lectureHsViewModel fetchLatest];
    //        }];
    //        [self.yhCollectionHsView addLoadMoreActionHandler:^{
    //            [weakSelf.lectureViewModel fetchMore];
    //        }];
    //        [self.yhCollectionHsView.header beginRefreshing];
}

//- (void)righBarBtnTapped:(UIButton *)btn
//{
//    HSLectureSearchVC *nextVC = [[HSLectureSearchVC alloc] init];
//    [self.navigationController pushViewController:nextVC animated:YES hideBottomTabBar:YES];
//}

- (HSCollectionView *)yhCollectionView
{
    if (!_yhCollectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        //        [flowLayout setDelegate:self];
        [flowLayout setSectionInset:UIEdgeInsetsMake(10, 5*kScreenPointScale, 10, 5*kScreenPointScale)];
        [flowLayout setMinimumInteritemSpacing:0*kScreenPointScale];
        [flowLayout setMinimumLineSpacing:10.0f];
        [flowLayout setItemSize:CGSizeMake(150, 180)];
        
        _yhCollectionView = [[HSCollectionView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-49.f-55) collectionViewLayout:flowLayout];
        [_yhCollectionView setAlwaysBounceVertical:YES];
        [_yhCollectionView setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
        [_yhCollectionView setBackgroundColor:RGBCOLOR(235, 235, 235)];
        [_yhCollectionView setDelegate:self];
        [_yhCollectionView setDataSource:self];
        
        [_yhCollectionView registerClass:[HSLectureHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HSLectureHeaderView"];
        [_yhCollectionView registerClass:[HSLectureTopCell class] forCellWithReuseIdentifier:@"HSLectureTopCell"];
        [_yhCollectionView registerClass:[HSLectureItemCell class] forCellWithReuseIdentifier:@"HSLectureItemCell"];
    }
    return _yhCollectionView;
}

//- (UIImageView *)placeHolderimageView {
//    if (!_placeHolderimageView) {
//        _placeHolderimageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"placeholder1"]];
//        [_placeHolderimageView setFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
//
//
//    }
//    return _placeHolderimageView;
//}

- (void)headerViewTapped:(UITapGestureRecognizer *)tapGesture
{
    HSLectureModel *lectureModel = (HSLectureModel *)[self.lectureViewModel contentAtIndex:0];
    if (!lectureModel) {
        [[Hud defaultInstance] showMessage:@"暂无有效数据"];
        return;
    }
    HSLectureDetailVC *nextVC = [[HSLectureDetailVC alloc] initWithNibName:@"HSLectureDetailVC" bundle:nil lectureModel:lectureModel isHs:NO ClassID:nil];
    [self.navigationController pushViewController:nextVC animated:YES hideBottomTabBar:YES];
}

#pragma mark - UICollectionView Datasource and Delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger count = [self.lectureViewModel contentCount]-1;
    return count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HSLectureItemCell *itemCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HSLectureItemCell" forIndexPath:indexPath];
    HSLectureModel *lectureModel = (HSLectureModel *)[self.lectureViewModel contentAtIndex:indexPath.row+1];
    [itemCell updateCellWith:lectureModel];
    itemCell.delegate = self;
    
    return itemCell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    HSLectureHeaderView *headerView = (HSLectureHeaderView *)[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"HSLectureHeaderView" forIndexPath:indexPath];
    HSLectureModel *lectureModel = (HSLectureModel *)[self.lectureViewModel contentAtIndex:indexPath.row];
    [headerView updateCellWith:lectureModel];
    [headerView.singleTap removeTarget:self action:@selector(headerViewTapped:)];
    [headerView.singleTap addTarget:self action:@selector(headerViewTapped:)];

    return headerView;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    HSLectureModel *lectureModel = (HSLectureModel *)[self.lectureViewModel contentAtIndex:indexPath.row+1];
    HSLectureDetailVC *nextVC = [[HSLectureDetailVC alloc] initWithNibName:@"HSLectureDetailVC" bundle:nil lectureModel:lectureModel isHs:NO ClassID:nil];
    [nextVC addViewedCourse:lectureModel.lectureID isHs:NO];
//    [self initView];
    [self.parentViewController.navigationController pushViewController:nextVC animated:YES hideBottomTabBar:YES];
//    [self presentViewController:nextVC animated:YES completion:nil];
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(155.0f*kScreenPointScale, 132.0f*kScreenPointScale);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10*kScreenPointScale, 0, 10, 0);
    
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10.0f*kScreenPointScale;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 10.0f*kScreenPointScale;
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(CGRectGetWidth(collectionView.frame), 160.0f*kScreenPointScale+30.0f);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
                     layout:(DDCollectionViewFlowLayout *)layout
   numberOfColumnsInSection:(NSInteger)section
{
    return 2;
}


#pragma mark -

- (void)arrayDataMgr:(YH_ArrayDataMgr *)arrayDataMgr didFinishFetch:(CHFetchType)fetchType succeed:(BOOL)succeed error:(NSError *)error
{
    if (error) {
            [self.yhCollectionView.header endRefreshing];
    }
    if (fetchType == CHFetchLatest) {
        [self.yhCollectionView.header endRefreshing];
    } else {
        [self.yhCollectionView.footer endRefreshing];
    }
    [self.yhCollectionView.footer setHidden:!self.lectureViewModel.hasMoreItems];
    [self.yhCollectionView reloadData];
    
    //    if (fetchType == CHFetchLatest) {
    //        [self.yhCollectionHsView.header endRefreshing];
    //    } else {
    //        [self.yhCollectionHsView.footer endRefreshing];
    //    }
    //    [self.yhCollectionHsView.footer setHidden:!self.lectureViewModel.hasMoreItems];
    //    [self.yhCollectionHsView reloadData];
    
    
    
    
}

- (void)arrayDataMgrUpdateData:(YH_ArrayDataMgr *)arrayDataMgr
{
    [self.yhCollectionView reloadData];
    //    [self.yhCollectionHsView reloadData];
}


#pragma mark -
- (void)lectureItemCellDidFinishLoadImage:(HSLectureItemCell *)cell
{
    //    [self.yhCollectionView reloadData];
}
//- (void) segmentedControlDidTouchDown:(UISegmentedControl *)segment {
//    NSLog(@"%ld",(long)segment.selectedSegmentIndex);
//}
//- (UISegmentedControl *)segmentedCtrl {
//    if (!_segmentedCtrl) {
//        NSArray *titles = nil;
//        switch (self.appType) {
//            case HSAppTypeZhiXueTang:
//                titles = @[@"内部资料", @"红松出品", @"我的收藏"];
//                break;
//            case HSAppTypeHongSongPai:
//                titles = @[@"内部资料", @"我的收藏"];
//                break;
//            default:
//                break;
//        }
//
//        _segmentedCtrl = [[UISegmentedControl alloc] initWithItems:titles];
//        NSLog(@"%@",NSStringFromCGSize(_segmentedCtrl.bounds.size));
//        _segmentedCtrl.tintColor = [UIColor whiteColor];
//        _segmentedCtrl.layer.cornerRadius = 14.5;
//        _segmentedCtrl.layer.masksToBounds = YES;
//        _segmentedCtrl.layer.borderWidth = 1.5;
//        _segmentedCtrl.layer.borderColor = [UIColor whiteColor].CGColor;
//        _segmentedCtrl.selectedSegmentIndex = 0;
//        [_segmentedCtrl addTarget:self action:@selector(segmentedControlDidTouchDown:) forControlEvents:UIControlEventValueChanged];
//    }
//    return _segmentedCtrl;
//}
//- (NSInteger)appType {
//    if (!_appType) {
//        _appType = kHSAPPTYPE;
//    }
//    return _appType;
//}
@end
