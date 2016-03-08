//
//  HSPracticeVC.m
//  koreanpine
//
//  Created by Christ on 15/7/15.
//  Copyright (c) 2015年 Christ. All rights reserved.
//

#import "HSPracticeVC.h"
#import "HSExerciseViewModel.h"
#import "HSPracticePKVC.h"
#import "HSPracticeWrongVC.h"
@interface HSPracticeVC ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) UIImageView *placeHolderimageView;
@property (strong, nonatomic) UIImageView *placeHolderimageView1;
@property (nonatomic,strong) UISegmentedControl *segmentedCtrl;
@property (nonatomic,assign) NSInteger appType;


@property (nonatomic,strong) UIView *hongSongView;
@property (nonatomic,strong) HSPracticeWrongVC *practiceWrongVC;

@property (nonatomic,strong) UIView *wrongSubiectView;
@property (nonatomic,assign) NSInteger count;
@end

@implementation HSPracticeVC
#pragma mark -共有方法
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showpracticePKVC:) name:@"showpracticePKVCNotify" object:nil];
   }
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"showpracticePKVCNotify" object:nil];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([self.childViewControllers containsObject:self.practiceWrongVC] ) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"wrongListRefreshNotification" object:nil];
    }
}
-(void)showpracticePKVC:(NSNotification *)notify{
    [self showPracticeView];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -代理方法||数据源方法
- (void)righBarBtnTapped:(UIButton *)btn
{
//    HSLectureSearchVC *nextVC = [[HSLectureSearchVC alloc] init];
//    [self.navigationController pushViewController:nextVC animated:YES hideBottomTabBar:YES];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat pageFloat = scrollView.contentOffset.x/self.view.bounds.size.width;
    self.segmentedCtrl.selectedSegmentIndex = (NSInteger)(pageFloat+0.5);
//    if (pageFloat == 0.0) {
//        self.count ++;
//        if (self.count>2) {
//            [self.practicePKVC reloadUserHeroModel];
//        }
//
//    }
}
#pragma mark - UITableViewDataSource
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"enterpriseExerciseView"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"enterpriseExerciseView"];
    }
    return cell;
}

#pragma mark -私有方法
- (void) initView {


    [self.view setBackgroundColor:RGBCOLOR(235, 235, 235)];
    self.navigationItem.titleView = self.segmentedCtrl;
//    UIButton *searchBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
//    [searchBtn addTarget:self action:@selector(righBarBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
//    [searchBtn setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
//    [searchBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
//    
//    UIBarButtonItem *rightBarBtn = [[UIBarButtonItem alloc] initWithCustomView:searchBtn];
//    [self.navigationItem setRightBarButtonItem:rightBarBtn];
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width, ([UIScreen mainScreen].bounds.size.height))];
    [self.view addSubview:scrollView];
    scrollView.contentSize = CGSizeMake(scrollView.bounds.size.width*self.segmentedCtrl.numberOfSegments, 0);
    scrollView.pagingEnabled = YES;
    scrollView.bounces = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.delegate = self;
    
    
    self.scrollView = scrollView;
    [self addSubviewInScrollView];
    

    
}
- (void) addSubviewInScrollView {
    NSInteger count = self.segmentedCtrl.numberOfSegments;
    CGSize size = self.scrollView.bounds.size;
        for (int i=0; i<count; i++) {
        switch (i) {
            case 0:
                self.practicePKVC.view.frame = CGRectMake(0, 0, size.width, size.height);
                [self.scrollView addSubview:self.self.practicePKVC.view];
                [self addChildViewController:self.practicePKVC];
                        break;
            case 1:
               
                self.hongSongView.frame = CGRectMake(size.width, 0, size.width, size.height);
                [self.scrollView addSubview:self.hongSongView];
                [self.hongSongView addSubview:self.placeHolderimageView1];
                break;
            case 2:
//                self.wrongSubiectView.frame = CGRectMake(size.width*2, 0, size.width, size.height);
//                [self.scrollView addSubview:self.wrongSubiectView];
//                [self.wrongSubiectView addSubview:self.placeHolderimageView];
                self.practiceWrongVC.view.frame =CGRectMake(size.width*2, 0, size.width, size.height);
                [self.scrollView addSubview:self.self.practiceWrongVC.view];
                [self addChildViewController:self.practiceWrongVC];
                
                break;
            default:
                
                break;
        }
    }
}
- (void) segmentedControlDidTouchDown:(UISegmentedControl *)sender {
    switch (sender.selectedSegmentIndex) {
        case 0:
            [self showPracticeView];
            break;
        case 1:
            [self showHongSongView];
            break;
        case 2:
            [self showWrongSubiectView];
            break;
        default:
            break;
    }
}
/**
 *  练习PK界面
 */
- (void) showPracticeView {
    self.scrollView.contentOffset = CGPointMake(0, -64);
    [self.practicePKVC reloadUserHeroModel];
}
/**
 *   我的考试界面
 */
- (void) showHongSongView {
    self.scrollView.contentOffset = CGPointMake(self.view.bounds.size.width, 0);
}
/**
 *  错题本界面
 */
- (void) showWrongSubiectView {
    self.scrollView.contentOffset = CGPointMake(self.view.bounds.size.width *2, -64);
//    [self.practiceWrongVC fetchLatests];
    }
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (self.scrollView.contentOffset.x == self.view.bounds.size.width *(self.segmentedCtrl.numberOfSegments-1)){
//    [self.practiceWrongVC fetchLatests];
    }
}
#pragma  mark -懒加载
- (UISegmentedControl *)segmentedCtrl {
    if (!_segmentedCtrl) {
        NSArray *titles = nil;
        titles = @[@"作答排名", @"我的考试", @"错题本"];
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
- (NSInteger)appType {
    if (!_appType) {
        _appType = kHSAPPTYPE;
    }
    return _appType;
}

- (UIImageView *)placeHolderimageView {
    if (!_placeHolderimageView) {
        _placeHolderimageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"placeholder1"]];
        [_placeHolderimageView setFrame:CGRectMake(0, 0, 210, 170)];
        [_placeHolderimageView setCenter:CGPointMake(CGRectGetMidX(self.scrollView.bounds), CGRectGetMidY(self.scrollView.bounds))];
//        [_placeHolderimageView setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin];
    }
    return _placeHolderimageView;
}
- (UIImageView *)placeHolderimageView1 {
    if (!_placeHolderimageView1) {
        _placeHolderimageView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"placeholder1"]];
        [_placeHolderimageView1 setFrame:CGRectMake(0, 0, 210, 170)];
        [_placeHolderimageView1 setCenter:CGPointMake(CGRectGetMidX(self.scrollView.bounds), CGRectGetMidY(self.scrollView.bounds))];
        //        [_placeHolderimageView setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin];
    }
    return _placeHolderimageView1;
}
- (HSPracticePKVC *)practicePKVC {
    if (!_practicePKVC) {
        _practicePKVC = [[HSPracticePKVC alloc] init];
        
    }
    return _practicePKVC;
}
- (UIView *)hongSongView {
    if (!_hongSongView) {
        _hongSongView = [UIView new];
        
    }
    return _hongSongView;
}
- (UIView *)wrongSubiectView {
    if (!_wrongSubiectView) {
        _wrongSubiectView = [UIView new];
        [_wrongSubiectView addSubview:self.placeHolderimageView];
    }
    return _wrongSubiectView;
}
-(HSPracticeWrongVC *)practiceWrongVC{
    if (!_practiceWrongVC) {
        _practiceWrongVC = [[HSPracticeWrongVC alloc]init];
    }
    return _practiceWrongVC;
}
@end
