//
//  HSModifyPasswordVC.m
//  koreanpine
//
//  Created by Christ on 15/7/18.
//  Copyright (c) 2015年 Christ. All rights reserved.
//

#import "HSModifyPasswordVC.h"
#import "HSLoginMgr.h"
#import "NetworkCenter.h"
#import "HSUtility.h"

@interface HSModifyPasswordVC ()
<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;

@property (weak, nonatomic) IBOutlet UIButton *commitBtn;

- (IBAction)cancelBtnTapped:(UIButton *)sender;

- (IBAction)commitBtnTapped:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UITextField *oldPasswordTF;
@property (weak, nonatomic) IBOutlet UITextField *nowPasswordTF;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordTF;

@end

@implementation HSModifyPasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initView
{
    self.title = @"修改密码";
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:self.backBtn];
    self.navigationItem.leftBarButtonItem = backItem;
    
    [self.oldPasswordTF setDelegate:self];
    [self.nowPasswordTF setDelegate:self];
    [self.confirmPasswordTF setDelegate:self];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapped:)];
    [singleTap setNumberOfTapsRequired:1];
    [singleTap setNumberOfTouchesRequired:1];
    [self.view addGestureRecognizer:singleTap];
}

- (void)singleTapped:(UITapGestureRecognizer *)singleTap
{
    [self.view endEditing:YES];
}

- (IBAction)cancelBtnTapped:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)commitBtnTapped:(UIButton *)sender {

    [self.view endEditing:YES];
    
    if (self.oldPasswordTF.text.length < 6 || self.oldPasswordTF.text.length > 16) {
        [[Hud defaultInstance] showMessage:@"请输入6~16位密码"];
        return;
    }
    if (self.nowPasswordTF.text.length < 6 || self.nowPasswordTF.text.length > 16) {
        [[Hud defaultInstance] showMessage:@"请输入6~16位密码"];
        return;
    }

    if (self.confirmPasswordTF.text.length < 6 || self.confirmPasswordTF.text.length > 16) {
        [[Hud defaultInstance] showMessage:@"请输入6~16位密码"];
        return;
    }
    if (![self.nowPasswordTF.text isEqualToString:self.confirmPasswordTF.text]) {
        [[Hud defaultInstance] showMessage:@"新密码与确认密码不一致"];
        return;
    }
    NSString *oldPasswordMd5 = [Common getMd5_32Bit_String:self.oldPasswordTF.text];

    __weak typeof(self) weakSelf = self;
    [[NetworkCenter shareCenter] modifyPasswordWithOldPasswordMd5:oldPasswordMd5 newPassword:self.nowPasswordTF.text finish:^(NSDictionary *tokenInfo) {
        [weakSelf.navigationController popViewControllerAnimated:YES];
    } failedBlock:^(NSError *error) {
        [[Hud defaultInstance] showMessage:@"修改密码失败"];
    }];}

#pragma mark - TextFiled Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
