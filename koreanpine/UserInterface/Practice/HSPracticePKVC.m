//
//  HSPracticePKVC.m
//  koreanpine
//
//  Created by Victor on 15/11/5.
//  Copyright © 2015年 Christ. All rights reserved.
//

#import "HSPracticePKVC.h"
#import "HSPracticePKButton.h"
#import "HSExerciseDetailVC.h"
#import "UIView+WTXM.h"
#import "HSExerciseViewModel.h"
#import "HSHeroCell.h"
#import "HSPracticeButton.h"
#import "HSUserHeroModel.h"

@interface HSPracticePKVC ()<UITableViewDelegate,UITableViewDataSource,YH_ArrayDataLoadDelegate,HSPracticePKButtonDelegate>
@property (nonatomic,strong) UIView *operationView;
@property (nonatomic,strong) HSPracticePKButton *correctRatioBtn;
@property (nonatomic,strong) HSPracticePKButton *answerQuantityBtn;
@property (nonatomic,strong) HSPracticeButton *practiceButton;

@property (nonatomic,strong) UIView *titleView;
@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,strong) UITableView *herosTableView;

@property (nonatomic,assign) CGRect nomalRect;
@property (nonatomic,strong) HSExerciseViewModel *exerciseViewModel;
@end

@implementation HSPracticePKVC



#pragma mark -共有方法
- (instancetype)init {
    if (self = [super init]) {
        self.view.backgroundColor = [UIColor lightGrayColor];
        [self initView];
        [self initData];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -代理方法||数据源方法
#pragma mark - UITableViewDelegate UITableViewDataSource
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return self.exerciseViewModel.heroArr.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (HSHeroCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseId = @"HSHeroCellReuseId";
    HSHeroCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (!cell) {
        cell = [[HSHeroCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId placeNum:indexPath.section];
    }
    HSHeroModel *heroModel = self.exerciseViewModel.heroArr[indexPath.section];
    cell.sortType = self.exerciseViewModel.sortType;
    cell.placeNum = indexPath.section;
    cell.heroModel = heroModel;
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    view.backgroundColor = RGBACOLOR(0, 0, 0, 0.2);
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.5;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}
- (void)arrayDataMgr:(YH_ArrayDataMgr *)arrayDataMgr didFinishFetch:(CHFetchType)fetchType succeed:(BOOL)succeed error:(NSError *)error {
            [self.herosTableView reloadData];
}

- (void) practicePKBtnTapped:(HSPracticePKButton *)button {
    switch (button.tag) {
        case 520:
            self.exerciseViewModel.sortType = @"rightRate";
            self.titleLabel.text = @"本周英雄榜";
            [self.exerciseViewModel fetchLatest];
            [self popAnimationToChangeBig:button];
            [self popAnimationToChangeSmall:self.answerQuantityBtn];
            break;
        case 521:
            self.exerciseViewModel.sortType = @"totalNum";
            self.titleLabel.text = @"本周英雄榜";
            [self.exerciseViewModel fetchLatest];
            [self popAnimationToChangeBig:button];
            [self popAnimationToChangeSmall:self.correctRatioBtn];
            break;
            
        default:
            break;
    }
    
}
#pragma mark -私有方法
- (void) initView {
    CGSize size = [UIScreen mainScreen].bounds.size;
    CGFloat operationViewH = size.width*0.7;
    self.operationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, operationViewH)];
    self.operationView.backgroundColor = RGBACOLOR(85, 125, 201, 1);
    CGFloat btnWidth = (size.width - 52)/2;
    self.correctRatioBtn = [[HSPracticePKButton alloc] initWithFrame:CGRectMake(20, 25, btnWidth, btnWidth)];
    self.correctRatioBtn.delegate = self;
    self.correctRatioBtn.big = YES;
    self.correctRatioBtn.centerY = self.view.hei*0.47;
    self.correctRatioBtn.sortType = @"rightRate";
    self.correctRatioBtn.tag = 520;
    self.nomalRect = self.correctRatioBtn.frame;
    self.answerQuantityBtn = [[HSPracticePKButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 25 - btnWidth, 25, btnWidth, btnWidth)];
    self.answerQuantityBtn.delegate = self;
    self.answerQuantityBtn.big = NO;
     self.answerQuantityBtn.sortType = @"totalNum";
    self.answerQuantityBtn.tag = 521;
    self.correctRatioBtn.centerY = operationViewH*0.4;
    self.answerQuantityBtn.centerY = self.correctRatioBtn.centerY;
    [self.operationView addSubview:self.correctRatioBtn];
    [self.operationView addSubview:self.answerQuantityBtn];
    CGFloat btnW = 120;
    CGFloat btnH = 35;
    CGFloat btnX = CGRectGetWidth(self.operationView.frame) - btnW;
    CGFloat btnY = CGRectGetHeight(self.operationView.frame)- 10 -btnH;
    self.practiceButton = [[HSPracticeButton alloc] initWithFrame:CGRectMake(btnX, btnY, btnW, btnH)];
    [self.practiceButton setTitle:@"开   练" forState:UIControlStateNormal];
    [self.practiceButton addTarget:self action:@selector(practiceButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.practiceButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.operationView addSubview:self.practiceButton];
    [self.view addSubview:self.operationView];
    
    self.titleView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.operationView.frame), size.width, 25)];
    self.titleView.backgroundColor = RGBACOLOR(216, 232, 255,1);
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, CGRectGetWidth(self.titleView.frame)-20, CGRectGetHeight(self.titleView.frame))];
    self.titleLabel.text = @"本周英雄榜";
    self.titleLabel.font = [UIFont systemFontOfSize:15];
    self.titleLabel.textColor = RGBACOLOR(85, 125, 201, 1);
    [self.titleView addSubview:self.titleLabel];
    [self.view addSubview:self.titleView];
    
    self.herosTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.titleView.frame), size.width, size.height- CGRectGetMaxY(self.titleView.frame)-49-64)];
    self.herosTableView.delegate = self;
    self.herosTableView.dataSource = self;
    [self.view addSubview:self.herosTableView];

}

- (void) practiceButtonTapped:(UIButton *)button {
    HSExerciseDetailVC *exercise = [[HSExerciseDetailVC alloc] initWithHomeworkModel:nil];
    exercise.hidesBottomBarWhenPushed = YES;
    [self.parentViewController.navigationController pushViewController:exercise animated:YES];
}
- (void) reloadUserHeroModel {
    WS(weakSelf);
    [self.exerciseViewModel getUserRankInfoSucceededHandler:^( HSUserHeroModel *userModel) {
        weakSelf.correctRatioBtn.userHeroModel = userModel;
        weakSelf.answerQuantityBtn.userHeroModel = userModel;
    } failedHandler:^(NSError *error) {
        
    }];
 
}
- (void) initData {

    [self.exerciseViewModel fetchLatest];
    WS(weakSelf);
    [self.exerciseViewModel getUserRankInfoSucceededHandler:^( HSUserHeroModel *userModel) {
        weakSelf.correctRatioBtn.userHeroModel = userModel;
        weakSelf.answerQuantityBtn.userHeroModel = userModel;
        [weakSelf popAnimationToChangeBig:weakSelf.correctRatioBtn];
        [weakSelf popAnimationToChangeSmall:weakSelf.answerQuantityBtn];
        
    } failedHandler:^(NSError *error) {
        
    }];
   }

- (void) popAnimationToChangeBig:(HSPracticePKButton *)button {
    button.progressView.userInteractionEnabled = NO;
    button.alpha = 0.7;
     [UIView animateWithDuration:0.25 animations:^{
         button.alpha = 1.0;
         if (button.tag == 520) {
             if (button.centerX == self.nomalRect.origin.x + self.nomalRect.size.width*0.5) {
                 button.x += self.nomalRect.size.width*0.05;
             }else {
                 button.x += self.nomalRect.size.width*0.1;
             }
         }else {
             if (button.centerX == ([UIScreen mainScreen].bounds.size.width - self.nomalRect.origin.x - self.nomalRect.size.width*0.5)) {
                 button.x -= self.nomalRect.size.width*0.05;
             }else {
                 button.x -= self.nomalRect.size.width*0.1;
             }
         }
  
     }];
    
    [UIView animateWithDuration:0.25 animations:^{
                button.transform = CGAffineTransformMakeScale(1.1, 1.1);
    } completion:^(BOOL finished) {
        if (finished) {
            [UIView animateWithDuration:0.15 animations:^{
                button.transform = CGAffineTransformMakeScale(1.15, 1.15);
            } completion:^(BOOL finished) {
                if (finished) {
                    [UIView animateWithDuration:0.1 animations:^{
                      button.transform = CGAffineTransformMakeScale(1.1, 1.1);
                    }];
                }
            }];
        }
    }];
       
}

- (void) popAnimationToChangeSmall:(HSPracticePKButton *)button {
    button.progressView.userInteractionEnabled = YES;
    button.alpha = 1.0;
    [UIView animateWithDuration:0.25 animations:^{
        button.alpha = 0.7;
        if (button.tag == 520) {
            if (button.centerX == self.nomalRect.origin.x + self.nomalRect.size.width*0.5) {
                button.x -= self.nomalRect.size.width*0.05;
            }else {
                button.x -= self.nomalRect.size.width*0.1;
            }
        }else {
            if (button.centerX == ([UIScreen mainScreen].bounds.size.width - self.nomalRect.origin.x - self.nomalRect.size.width*0.5)) {
                button.x += self.nomalRect.size.width*0.05;
            }else {
                button.x += self.nomalRect.size.width*0.1;
            }
        }
  
    }];
    
    [UIView animateWithDuration:0.25 animations:^{
                button.transform = CGAffineTransformMakeScale(0.9, 0.9);
    } completion:^(BOOL finished) {
        if (finished) {
            [UIView animateWithDuration:0.15 animations:^{
                button.transform = CGAffineTransformMakeScale(0.85, 0.85);
            } completion:^(BOOL finished) {
                if (finished) {
                    [UIView animateWithDuration:0.1 animations:^{
                      button.transform = CGAffineTransformMakeScale(0.9, 0.9);
                    }];
                }
            }];
        }
        
    }];
    
    
}


#pragma  mark -懒加载
- (HSExerciseViewModel *)exerciseViewModel {
    if (!_exerciseViewModel) {
        _exerciseViewModel = [[HSExerciseViewModel alloc] init];
        _exerciseViewModel.delegate = self;
        //totalNum，rightRate
        _exerciseViewModel.pageMgr.currentPage = 1;
        _exerciseViewModel.pageMgr.pageSize = 10;
    }
    return _exerciseViewModel;
}
@end
