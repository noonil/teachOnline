//
//  HSLectureVC.m
//  koreanpine
//
//  Created by Christ on 15/7/15.
//  Copyright (c) 2015年 Christ. All rights reserved.
//

#import "HSOrgViewController.h"
#import "HShsViewController.h"
#import "HSMyCollectionsVC.h"
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
#import "HSMainVC.h"

@interface HSLectureVC ()<UIScrollViewDelegate>


//@property (strong, nonatomic) HSCollectionView *yhCollectionView;
//@property(strong,nonatomic)HSCollectionView *yhCollectionHsView;
//@property (strong, nonatomic) HSLectureViewModel *lectureViewModel;
//@property (strong, nonatomic) HSLectureHsViewModel *lectureHsViewModel;
@property(strong,nonatomic)HShsViewController *vc2;
@property(strong,nonatomic)HSOrgViewController *vc1;
@property (strong,nonatomic)HSMyCollectionsVC *vc3;
@property (strong,nonatomic)UIImageView *placeHolderimageView;
@property (nonatomic,strong) UISegmentedControl *segmentedCtrl;
@property (nonatomic,assign) NSInteger appType;
@property(nonatomic,strong)UIScrollView *lectureView;
@property (nonatomic,strong) UIButton *deleteBtn;
@end

@implementation HSLectureVC

- (void)viewDidLoad {
    [super viewDidLoad];
//    解决弹到navibar中的bug
    self.edgesForExtendedLayout=UIRectEdgeNone;
    // Do any additional setup after loading the view.
    [self initView];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kShowTableViewEditingNotification object:nil];
}
- (void)initView
{
    self.title = @"课程";
        self.navigationItem.titleView = self.segmentedCtrl;
    
//    self.lectureViewModel = [[HSLectureViewModel alloc] init];
    //    self.lectureHsViewModel = [[HSLectureHsViewModel alloc] init];
            
    
//    [self.lectureViewModel setDelegate:self];
    //    [self.lectureHsViewModel setDelegate:self];
    
    
    
        UIScrollView *lectureView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        lectureView.contentSize = CGSizeMake(3*self.view.frame.size.width, 0);
        lectureView.pagingEnabled = YES;
        lectureView.bounces = NO;
        lectureView.showsVerticalScrollIndicator = NO;
        lectureView.showsHorizontalScrollIndicator = NO;
    
    
        lectureView.delegate = self;

        self.lectureView = lectureView;
        [self.view addSubview:lectureView];
    
//    [self.view addSubview:self.yhCollectionView];
    //    [self.lectureView addSubview:self.yhCollectionHsView];
    
        UIButton *searchBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        [searchBtn addTarget:self action:@selector(righBarBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
        [searchBtn setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
        [searchBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    
        UIBarButtonItem *rightBarBtn = [[UIBarButtonItem alloc] initWithCustomView:searchBtn];
        [self.navigationItem setRightBarButtonItem:rightBarBtn];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:self.backBtn];
    self.navigationItem.leftBarButtonItem = backItem;
    self.backBtn.hidden = YES;
    //
    //    self.lectureViewModel.ModelUrl =  @"com/courseV1_4/hsCourseList";
//    [self collectionViewReload];
    [self addSubviewInScrollView];
    [[NSNotificationCenter defaultCenter] postNotificationName:kChooseClassNotification object:@0];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showBackButton:) name:kShowTableViewEditingNotification object:nil];
}

- (void) addSubviewInScrollView {
    self.vc1 = [[HSOrgViewController alloc]init];
    self.vc1.view.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    self.vc2 = [[HShsViewController alloc]init];
    self.vc2.view.frame = CGRectMake(self.view.bounds.size.width, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    self.vc3 = [[HSMyCollectionsVC alloc]init];
    self.vc3.view.frame = CGRectMake(self.view.bounds.size.width*2, 0, self.view.bounds.size.width, self.view.bounds.size.height-113);
      [self addChildViewController:self.vc1];
      [self addChildViewController:self.vc2];
      [self addChildViewController:self.vc3];
    NSInteger count = self.segmentedCtrl.numberOfSegments;
    for (int i=0; i<count; i++) {
        switch (i) {
            case 0:
                [self.lectureView addSubview:_vc1.view];
                break;
            case 1:
                [self.lectureView addSubview:_vc2.view];
                break;
            case 2:
//                switch (self.appType) {
//                    case HSAppTypeZhiXueTang:
                        [self.lectureView addSubview:_vc3.view];
//                        break;
//                    case HSAppTypeHongSongPai:
//                        break;
//                    default:
//                        break;
//                }
//                break;
            default:
                break;
        }
    }
}

- (void) segmentedControlDidTouchDown:(UISegmentedControl *)sender {
    switch (sender.selectedSegmentIndex) {
        case 0:
            [self showyhCollectionview];
            [self backAction:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:kChooseClassNotification object:@0];
            break;
        case 1:
            [self showyhCollectionHsView];
            [self backAction:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:kChooseClassNotification object:@1];
            break;
        case 2:
            switch (self.appType) {
                case HSAppTypeZhiXueTang:
                    [self showthirdView];
                   
                    [[NSNotificationCenter defaultCenter] postNotificationName:kChooseClassNotification object:@2];
                    break;
                case HSAppTypeHongSongPai:
                    break;
                default:
                    break;
            }
            break;
        default:
            break;
    }
}

-(void)showyhCollectionview{
       self.lectureView.contentOffset = CGPointMake(0, 0);
    
   
}

-(void)showyhCollectionHsView{
    self.lectureView.contentOffset = CGPointMake(self.view.bounds.size.width, 0);
}

-(void)showthirdView{
    self.lectureView.contentOffset = CGPointMake(self.view.bounds.size.width*2, 0);
}


- (void)righBarBtnTapped:(UIButton *)btn
{
    [self backAction:nil];
    HSLectureSearchVC *nextVC = [[HSLectureSearchVC alloc] init];
    [self.navigationController pushViewController:nextVC animated:YES hideBottomTabBar:YES];
}



- (UIImageView *)placeHolderimageView {
    if (!_placeHolderimageView) {
        _placeHolderimageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"placeholder1"]];
        [_placeHolderimageView setFrame:CGRectMake(0, 0,150, 150)];
        _placeHolderimageView.center = self.view.center;


    }
    return _placeHolderimageView;
}
- (void) showBackButton:(NSNotification *)notify {
    self.backBtn.hidden = NO;
    HSMainVC *tabBarVC = (HSMainVC *)self.tabBarController;
   UITabBar *tabBar = (UITabBar *)tabBarVC.aTabbar;
    [UIView animateWithDuration:0.15 animations:^{
      [tabBar setHidden:YES];
    } completion:^(BOOL finished) {
        if (finished) {
           [UIView animateWithDuration:0.15 animations:^{
               self.deleteBtn.hidden = NO;
           }];
        }
    }];

}
- (void)backAction:(id)sender {
    self.backBtn.hidden = YES;
    HSMainVC *tabBarVC = (HSMainVC *)self.tabBarController;
    UITabBar *tabBar = (UITabBar *)tabBarVC.aTabbar;
    [UIView animateWithDuration:0.25 animations:^{
        self.deleteBtn.hidden = YES;
    } completion:^(BOOL finished) {
        if (finished) {
          [UIView animateWithDuration:0.15 animations:^{
              [tabBar setHidden:NO];
          }];
        }
    }];

    [[NSNotificationCenter defaultCenter] postNotificationName:kHideTableViewEditingNotification object:nil];
}
- (void) deleteButtonTapped:(UIButton *)button {
    self.backBtn.hidden = YES;
    HSMainVC *tabBarVC = (HSMainVC *)self.tabBarController;
    UITabBar *tabBar = (UITabBar *)tabBarVC.aTabbar;
    [UIView animateWithDuration:0.25 animations:^{
        self.deleteBtn.hidden = YES;
    } completion:^(BOOL finished) {
        if (finished) {
            [UIView animateWithDuration:0.15 animations:^{
                [tabBar setHidden:NO];
            }];
        }
    }];
    [[NSNotificationCenter defaultCenter] postNotificationName:kDeleteMyCollectionsNotification object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:kHideTableViewEditingNotification object:nil];
    
}
#pragma mark - UICollectionView Datasource and Delegate



#pragma mark -
//- (void)lectureItemCellDidFinishLoadImage:(HSLectureItemCell *)cell
//{
    //    [self.yhCollectionView reloadData];
//}

- (UISegmentedControl *)segmentedCtrl {
    if (!_segmentedCtrl) {
        NSArray *titles = nil;
        switch (self.appType) {
            case HSAppTypeZhiXueTang:
                titles = @[@"内部资料", @"红松出品",@"我的收藏"];
                break;
            case HSAppTypeHongSongPai:
                titles = @[@"内部资料",@"我的收藏"];
                break;
            default:
                break;
        }

        _segmentedCtrl = [[UISegmentedControl alloc] initWithItems:titles];
//        NSLog(@"%@",NSStringFromCGSize(_segmentedCtrl.bounds.size));
        _segmentedCtrl.tintColor = [UIColor whiteColor];
        _segmentedCtrl.layer.cornerRadius = 14.5;
        _segmentedCtrl.layer.masksToBounds = YES;
        _segmentedCtrl.layer.borderWidth = 1;
        _segmentedCtrl.layer.borderColor = [UIColor whiteColor].CGColor;
        _segmentedCtrl.selectedSegmentIndex = 0;
        [_segmentedCtrl addTarget:self action:@selector(segmentedControlDidTouchDown:) forControlEvents:UIControlEventValueChanged];
    }
    return _segmentedCtrl;
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    NSInteger selectNumber = scrollView.contentOffset.x /( 320.0*kScreenPointScale);
  
    _segmentedCtrl.selectedSegmentIndex = selectNumber;
    switch (selectNumber) {
        case 0:
            [self backAction:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:kChooseClassNotification object:@0];
            break;
        case 1:
            [self backAction:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:kChooseClassNotification object:@1];
            break;
        case 2:

            [[NSNotificationCenter defaultCenter] postNotificationName:kChooseClassNotification object:@2];
            break;
        default:
            break;
    }
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (NSInteger)appType {
    if (!_appType) {
        _appType = kHSAPPTYPE;
    }
    return _appType;
}
- (UIButton *)deleteBtn {
    if (!_deleteBtn) {
        HSMainVC *tabBarVC = (HSMainVC *)self.tabBarController;
        UITabBar *tabBar = (UITabBar *)tabBarVC.aTabbar;
        CGRect rect = [tabBar convertRect:tabBar.bounds toView:keyWINDOW.rootViewController.view];
        _deleteBtn = [[UIButton alloc] initWithFrame:rect];
        [_deleteBtn addTarget:self action:@selector(deleteButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [_deleteBtn setTitle:@"  删   除" forState:UIControlStateNormal];
        [_deleteBtn setImage:[UIImage imageNamed:@"delete_n"] forState:UIControlStateNormal];
        [_deleteBtn setImage:[UIImage imageNamed:@"delete_f"] forState:UIControlStateHighlighted];
        [_deleteBtn setBackgroundColor:[UIColor whiteColor]];
        [_deleteBtn setTitleColor:RGBACOLOR(230, 105, 68, 1) forState:UIControlStateNormal];
        [_deleteBtn setTitleColor:RGBACOLOR(181, 80, 50, 1) forState:UIControlStateHighlighted];
        [keyWINDOW.rootViewController.view addSubview:_deleteBtn];
        _deleteBtn.hidden = YES;
    }
    return _deleteBtn;
}
@end
