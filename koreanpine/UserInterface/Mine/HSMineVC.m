//
//  HSMineVC.m
//  koreanpine
//
//  Created by Christ on 15/7/15.
//  Copyright (c) 2015年 Christ. All rights reserved.
//

#import "HSMineVC.h"
#import "HSUserInfoView.h"
#import "HSLoginMgr.h"
#import "HSUserHeaderImagePicker.h"
#import "HSMineExamVC.h"
#import "HSMineLectureVC.h"
#import "HSModifyPasswordVC.h"
#import "HSMineDownloadVC.h"
#import "HSFeedbackVC.h"
#import "HSAboutVC.h"
#import "UMFeedbackViewController.h"
#import "HSMineDownloadVC.h"
@interface HSMineVC ()
<UITableViewDataSource,UITableViewDelegate,HSUserHeaderImagePickerDelegate>

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) HSUserInfoView *userInfoView;

@property (strong, nonatomic) UIButton *logoutBtn;

@property (strong, nonatomic) NSArray *cellTitles;

@property (nonatomic,strong) HSUserHeaderImagePicker *userHeaderImagePicker;

@end

@implementation HSMineVC

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
    self.title = @"我的";
    [self.view setBackgroundColor:RGBCOLOR(235, 235, 235)];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-50.0f) style:UITableViewStyleGrouped];
    [self.tableView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    [self.tableView setDataSource:self];
    [self.tableView setDelegate:self];
    [self.view addSubview:self.tableView];
    
    self.userInfoView = [[HSUserInfoView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 100)];
    [self.userInfoView setBackgroundColor:[UIColor whiteColor]];
    
    UITapGestureRecognizer *gr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userHeaderViewTapped:)];
    gr.cancelsTouchesInView = NO;
    [self.userInfoView addGestureRecognizer:gr];
    
    _userHeaderImagePicker = [[HSUserHeaderImagePicker alloc] init];
    _userHeaderImagePicker.mainVC = self;

    
    UIView *tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 115)];
    [tableHeaderView addSubview:self.userInfoView];
    [self.tableView setTableHeaderView:tableHeaderView];
    
    self.logoutBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 300, 35)];
    [self.logoutBtn setBackgroundImage:[UIImage imageNamed:@"logout_btn_n"] forState:UIControlStateNormal];
    [self.logoutBtn setBackgroundImage:[UIImage imageNamed:@"logout_btn_p"] forState:UIControlStateHighlighted];
    [self.logoutBtn setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [self.logoutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    [self.logoutBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.logoutBtn addTarget:self action:@selector(logoutBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIView *tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,  CGRectGetWidth(self.view.bounds), 80)];
    [tableFooterView setBackgroundColor:[UIColor clearColor]];
    [tableFooterView addSubview:self.logoutBtn];
    [self.logoutBtn setCenter:CGPointMake(CGRectGetMidX(tableFooterView.bounds), 40)];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    [self.tableView setTableHeaderView:tableHeaderView];
    [self.tableView setTableFooterView:tableFooterView];
    
    [self.userInfoView updateUserInfoViewWith:[HSLoginMgr loginMgr].loginUser];
    
//    self.cellTitles = @[@"我的考试",@"我的课程",@"修改密码",@"下载管理",@"意见反馈",@"关于"];
    self.cellTitles = @[@"下载管理",@"修改密码",@"意见反馈",@"关于"];
}

#pragma mark - UITableView Datasource and Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.cellTitles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdent"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellIdent"];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    NSString *title = self.cellTitles[indexPath.row];
    [cell.textLabel setText:title];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 47.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
//        case 0:{
//            HSMineExamVC *nextVC = [[HSMineExamVC alloc] init];
//            [self.navigationController pushViewController:nextVC animated:YES hideBottomTabBar:YES];
//            break;
//        }
//        case 0:{
//            HSMineLectureVC *nextVC = [[HSMineLectureVC alloc] init];
//            [self.navigationController pushViewController:nextVC animated:YES hideBottomTabBar:YES];
//            break;
//        }
        case 0:{
                        HSMineDownloadVC *nextVC = [[HSMineDownloadVC alloc] init];
                        [self.navigationController pushViewController:nextVC animated:YES hideBottomTabBar:YES];
                        break;
                    }
        case 1:{
            HSModifyPasswordVC *nextVC = [[HSModifyPasswordVC alloc] initWithNibName:@"HSModifyPasswordVC" bundle:nil];
            [self.navigationController pushViewController:nextVC animated:YES hideBottomTabBar:YES];
            break;
        }
//        case 3:{
//            HSMineDownloadVC *nextVC = [[HSMineDownloadVC alloc] init];
//            [self.navigationController pushViewController:nextVC animated:YES hideBottomTabBar:YES];
//            break;
//        }
        case 2:{
//            HSFeedbackVC *nextVC = [[HSFeedbackVC alloc] initWithNibName:@"HSFeedbackVC" bundle:nil];
            UMFeedbackViewController *nextVC = [[UMFeedbackViewController alloc] init];
            [self.navigationController pushViewController:nextVC animated:YES hideBottomTabBar:YES];
            break;
        }
        case 3:{
            HSAboutVC *nextVC = [[HSAboutVC alloc] initWithNibName:@"HSAboutVC" bundle:nil];
            [self.navigationController pushViewController:nextVC animated:YES hideBottomTabBar:YES];
            break;
        }
        default:
            break;
    }
}

#pragma mark - other Action
- (void)logoutBtnTapped:(UIButton *)btn
{
    [[HSLoginMgr loginMgr] logoutCurrentUser];
}

#pragma mark - imagePicker Delegate

- (void)userHeaderViewTapped:(UITapGestureRecognizer *)tapGesture
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self.userHeaderImagePicker cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍摄", @"从相机选择", nil];
    [sheet showInView:self.view];
}

- (void)HSUserHeaderImagePicker:(HSUserHeaderImagePicker *)picker croppingFinished:(UIImage *)resultImage
{
    NSString *documentDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *avatarSavePath = [documentDir stringByAppendingPathComponent:@"avatar.png"];
    [UIImageJPEGRepresentation(resultImage, 0.25) writeToFile:avatarSavePath atomically:YES];
    
    [[Hud defaultInstance] loading:self.view withText:@"上传头像中..."];
    WS(weakSelf);
    [[HSLoginMgr loginMgr] uploadUserHeaderImage:avatarSavePath withFinish:^(NSDictionary *tokenInfo) {
        [[Hud defaultInstance] hide:weakSelf.view];
        [weakSelf.userInfoView updatePortrait:resultImage];
    } failedBlock:^(NSError *error) {
        [[Hud defaultInstance] hide:weakSelf.view];
    }];
}

- (void)HSUserHeaderImagePicker:(HSUserHeaderImagePicker *)picker otherBtnTappedAtIndex:(NSInteger)index
{
    
}

@end
