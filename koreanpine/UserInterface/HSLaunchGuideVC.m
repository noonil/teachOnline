//
//  HSLaunchGuideVC.m
//  koreanpine
//
//  Created by Christ on 15/7/15.
//  Copyright (c) 2015年 Christ. All rights reserved.
//

#import "HSLaunchGuideVC.h"
#import "HSRootVC.h"

typedef void (^FinishBlock)();

@interface HSLaunchGuideCell : UICollectionViewCell

@property (strong, nonatomic) UIImageView *imageView;

@property (strong, nonatomic) UIButton *finishLaunchBtn;

@property (copy, nonatomic) FinishBlock finishBlock;

@end

@interface HSLaunchGuideVC ()
<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    CGPoint panStartPoint;
}

@property (strong, nonatomic) UICollectionView *collectionView;

@property (strong, nonatomic) NSArray *launchImageNames;
@property (nonatomic,assign) NSInteger appType;
@end

@implementation HSLaunchGuideVC

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
    switch (self.appType) {
        case HSAppTypeZhiXueTang:
            if (kScreenHeight > 500) {
                self.launchImageNames = @[@"launchimage3_5a",@"launchimage3_5b",@"launchimage3_5c"];
            } else {
                self.launchImageNames = @[@"launch_guide1",@"launch_guide2",@"launch_guide3"];
            }

            break;
        case HSAppTypeHongSongPai:
            self.launchImageNames = @[@"hsp-img1", @"hsp-img2", @"hsp-img3"];
            break;
        default:
            break;
    }
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setMinimumLineSpacing:0];
    [flowLayout setMinimumInteritemSpacing:0];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
    [self.collectionView setBackgroundColor:[UIColor whiteColor]];
    [self.collectionView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    [self.collectionView setPagingEnabled:YES];
    [self.collectionView setBounces:NO];
    [self.collectionView registerClass:[HSLaunchGuideCell class] forCellWithReuseIdentifier:@"HSLaunchGuideCell"];
    [self.collectionView setShowsHorizontalScrollIndicator:NO];
    [self.collectionView setDataSource:self];
    [self.collectionView setDelegate:self];
    [self.view addSubview:self.collectionView];
    
    [self.collectionView.panGestureRecognizer addTarget:self action:@selector(finishGuideGesturePaned:)];
}

#pragma mark - UICollectionView Datasource and Delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.launchImageNames.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HSLaunchGuideCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HSLaunchGuideCell" forIndexPath:indexPath];
    [cell.imageView setImage:[UIImage imageNamed:self.launchImageNames[indexPath.row]]];
    [cell.finishLaunchBtn setHidden:(indexPath.row != 2)];
    [cell setFinishBlock:^(){
        [[HSRootVC rootVC] finishShowlaunchGuideVC];
    }];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(CGRectGetWidth(collectionView.bounds), CGRectGetHeight(collectionView.bounds));
}

#pragma mark - Other Action
- (void)finishGuideGesturePaned:(UIPanGestureRecognizer *)panGesture
{
    switch (panGesture.state) {
        case UIGestureRecognizerStateBegan:
            panStartPoint = [panGesture locationInView:panGesture.view];
            break;
            
        case UIGestureRecognizerStateEnded:{
            if (self.collectionView.contentOffset.x >= CGRectGetWidth(self.collectionView.bounds)*(self.launchImageNames.count-1)) {
            CGPoint panEndPoint = [panGesture locationInView:panGesture.view];
            if ((panStartPoint.x - panEndPoint.x) > 40.0f) {
                    [[HSRootVC rootVC] finishShowlaunchGuideVC];
                }
            }
            break;
        }
        case UIGestureRecognizerStateCancelled:{
            panStartPoint = CGPointZero;
            break;
        }
        default:
            break;
    }
}
- (NSInteger)appType {
    if (!_appType) {
        _appType = kHSAPPTYPE;
    }
    return _appType;
}
@end

@implementation HSLaunchGuideCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)awakeFromNib
{
    [self initView];
}

- (void)initView
{
    self.imageView = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
    [self.imageView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    [self.imageView setUserInteractionEnabled:YES];
    [self.contentView addSubview:self.imageView];
    
    self.finishLaunchBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 124, 36)];
//    [self.finishLaunchBtn setBackgroundColor:[UIColor whiteColor]];
//    [self.finishLaunchBtn setTitle:@"立即体验" forState:UIControlStateNormal];
//    [self.finishLaunchBtn.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
//    [self.finishLaunchBtn setTitleColor:RGBCOLOR(55, 159, 92) forState:UIControlStateNormal];
//    [self.finishLaunchBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [self.finishLaunchBtn setImage:[UIImage imageNamed:@"立即体验"] forState:UIControlStateNormal];
    [self.finishLaunchBtn setImage:[UIImage imageNamed:@"立即体验2"] forState:UIControlStateHighlighted];
//    [self.finishLaunchBtn.layer setCornerRadius:18.0f];
    [self.finishLaunchBtn addTarget:self action:@selector(finishBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
//    DrawViewBorder(self.finishLaunchBtn, 0.5f, RGBCOLOR(55, 159, 92));
    
    [self.finishLaunchBtn setCenter:CGPointMake(CGRectGetMidX(self.contentView.bounds), CGRectGetHeight(self.contentView.bounds)-118.0f)];
    [self.finishLaunchBtn setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin];
    [self.contentView addSubview:self.finishLaunchBtn];
    
}

- (void)finishBtnTapped:(UIButton *)btn
{
    if (self.finishBlock) {
        self.finishBlock();
    }
}

@end
