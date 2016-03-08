//
//  HSLoginVC.m
//  koreanpine
//
//  Created by Christ on 15/7/15.
//  Copyright (c) 2015年 Christ. All rights reserved.
//

#import "HSLoginVC.h"
#import "HSSelectCompanyVC.h"
#import "HSLoginMgr.h"
#import "HSRootVC.h"
#import "Common.h"
#import "HSFindPwdVC.h"
#import "UIView+WTXM.h"
#import "HSRegisterAccountVC.h"
#import "UIImage+ImageEffects.h"
#import "HSMainVC.h"
#import "HSCompanyModel.h"
@interface HSLoginVC ()
<HSCompanyListVCDelegate>
{
//    HSCompanyModel *selectedCompanyModel;
}

@property (weak, nonatomic) IBOutlet UIView *companyContainerView;

@property (weak, nonatomic) IBOutlet UIView *loginContainerView;
@property (weak, nonatomic) IBOutlet UIImageView *loginLogo;

@property (weak, nonatomic) IBOutlet UIButton *signUpBtn;

@property (weak, nonatomic) IBOutlet UITextField *companyNameTF;

@property (weak, nonatomic) IBOutlet UITextField *userNameTF;

@property (weak, nonatomic) IBOutlet UITextField *passwordTF;

@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

- (IBAction)loginBtnTapped:(UIButton *)sender;

- (IBAction)forgetBtnTapped:(UIButton *)sender;

@property (strong, nonatomic) UITapGestureRecognizer *singleTap;

@property (strong, nonatomic) HSSelectCompanyVC *selectCompanyVC;
@property (nonatomic,assign) NSInteger appType;
//@property (nonatomic,strong) HSCompanyModel *companyModel;
@end

@implementation HSLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initView];
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
//- (void)viewWillDisappear:(BOOL)animated {
//    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
//}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (UIStatusBarStyle)preferredStatusBarStyle {
//    return UIStatusBarStyleDefault;
//}
- (void)initView
{
    if (self.phoneNumber) {
        self.userNameTF.text = self.phoneNumber;
    }
    if(self.companyModel) {
        self.companyNameTF.text = self.companyModel.companyName;
    }
    CGFloat cornerRadius = 1.0f;
    [self.companyContainerView.layer setCornerRadius:cornerRadius];
    [self.companyContainerView.layer setMasksToBounds:YES];
    DrawViewBorder(self.companyContainerView, 1.0f, RGBCOLOR(200, 200, 200));
    
    [self.loginContainerView.layer setCornerRadius:cornerRadius];
    [self.loginContainerView.layer setMasksToBounds:YES];
    DrawViewBorder(self.loginContainerView, 1.0f, RGBCOLOR(200, 200, 200));
    
    [self.loginBtn.layer setCornerRadius:3.0f];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectCompanyTapped:)];
    [tapGesture setNumberOfTapsRequired:1];
    [tapGesture setNumberOfTouchesRequired:1];
    [self.companyContainerView addGestureRecognizer:tapGesture];
    
    
    self.singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureTapped:)];
    [self.singleTap setNumberOfTapsRequired:1];
    [self.singleTap setNumberOfTouchesRequired:1];
    [self.view addGestureRecognizer:self.singleTap];
    
    NSData *lastCompanyArchiver = (NSData *)[[NSUserDefaults standardUserDefaults] objectForKey:kStoreKeyLastSelectCompanyModel];
    HSCompanyModel *companyModel = (HSCompanyModel *)[NSKeyedUnarchiver unarchiveObjectWithData:lastCompanyArchiver];
//    selectedCompanyModel = companyModel;
    self.companyModel = companyModel;
    if (companyModel) {
        [self.companyNameTF setText:self.companyModel.companyName];
    }
    switch (self.appType) {
        case HSAppTypeZhiXueTang:
            self.signUpBtn.hidden = YES;
            break;
        case HSAppTypeHongSongPai:
            self.companyContainerView.hidden = YES;
            self.loginLogo.image = [UIImage imageNamed:@"icon"];
            //"id":100709,"name":"南京红松信息技术有限公司","uuid":"6B9B086751F0492BAEDDF84E707F7F6B"
           
            break;
        default:
            break;
    }

}

- (BOOL)validateNickNameAndPassword
{
    UITextField *firstResponseTF = nil;
    NSString *alertMsg = nil;
    BOOL validatePass = YES;
    if (self.userNameTF.text.length * self.passwordTF.text.length == 0) {
        if (self.userNameTF.text.length == 0) {
            firstResponseTF = self.userNameTF;
            alertMsg = @"请输入用户名";
        } else {
            firstResponseTF = self.passwordTF;
            alertMsg = @"请输入密码";
        }
        validatePass = NO;
    } else if (self.userNameTF.text.length < 11) {
        firstResponseTF = self.userNameTF;
        alertMsg = @"手机号码长度不到11位";
        validatePass = NO;
    } else if (self.passwordTF.text.length < 6) {
        firstResponseTF = self.passwordTF;
        alertMsg = @"密码长度至少6位";
        validatePass = NO;
    }
    
    
    
    if (!validatePass) {
//            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:alertMsg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
//        [alertView show];
//        [firstResponseTF becomeFirstResponder];
        [[Hud defaultInstance] showMessage:alertMsg];
    }

    return validatePass;
}

- (IBAction)loginBtnTapped:(UIButton *)sender {
    [self.view endEditing:YES];
   if (!self.companyModel) {
        [[Hud defaultInstance] showMessage:@"请选择企业"];
        return;
    }
    BOOL validatePass = [self validateNickNameAndPassword];
    if (!validatePass) { return; }

    [self.view endEditing:YES];

     [self showWaitAlert];
    NSData *lastCompanyArchiver = (NSData *)[[NSUserDefaults standardUserDefaults] objectForKey:kStoreKeyLastSelectCompanyModel];
    HSCompanyModel *companyModel = (HSCompanyModel *)[NSKeyedUnarchiver unarchiveObjectWithData:lastCompanyArchiver];
    
    [[HSLoginMgr loginMgr] loginWithUserName:self.userNameTF.text passWord:self.passwordTF.text companyModel:companyModel finish:^(NSDictionary *tokenInfo) {
        [[HSRootVC rootVC] finishShowLoginVC];
        [self hideWaitAlert];
    } failedBlock:^(NSError *error) {
        [self hideWaitAlert];
        [[Hud defaultInstance] showMessage:error.localizedDescription];
    }];
    }
- (IBAction)signUpBtnTapped:(UIButton *)sender {
    NSString *phoneNum = nil;
    NSString *regex = @"^((13[0-9])|(14[0-9])|(15[^4,\\D])|(17[0-9])|(18[0,0-9]))\\d{8}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if ( self.userNameTF.text.length == 11 && [predicate evaluateWithObject:self.userNameTF.text]) {
        
        phoneNum = self.userNameTF.text;
        
        
    }
    
    HSRegisterAccountVC *regist = [[HSRegisterAccountVC alloc] initWithNibName:@"HSRegisterAccountVC" bundle:nil];
    regist.phoneNumber = phoneNum;
    [self.navigationController pushViewController:regist animated:YES];
//    [self presentViewController:regist animated:YES completion:^{
//        
//    }];
    
}

- (IBAction)forgetBtnTapped:(UIButton *)sender {
    if (self.companyNameTF.text.length == 0) {
        [self showMsgAlert:@"请选择您的公司"];
        return;
    }
    HSFindPwdVC *nextVC = [[HSFindPwdVC alloc] initWithNibName:@"HSFindPwdVC" bundle:nil];
//    nextVC.companyModel = self.companyModel;
//    NSLog(@"%@",self.companyModel);
    if (self.userNameTF.text) {
        nextVC.phoneNum = self.userNameTF.text;
    }
    [self.navigationController pushViewController:nextVC animated:YES];
}

- (void)singleTapGestureTapped:(UITapGestureRecognizer *)tapGesture {
    [self.view endEditing:YES];
}

- (void)selectCompanyTapped:(UITapGestureRecognizer *)tapGesture {
    
    UIImage *bgImage = [Common screenShotWithView:self.view.window];
    //获取到当前屏幕的磨砂效果
    UIImage *image = [bgImage applyLightEffect];
//    bgImage = [Common boxblurImageWithImage:bgImage Blur:0.6];
    
    
    self.selectCompanyVC = [[HSSelectCompanyVC alloc] init];
    [self.selectCompanyVC setBgImage:image];
    self.selectCompanyVC.delegate = self;
//    [self.navigationController pushViewController:self.selectCompanyVC animated:YES];
    [[HSRootVC rootVC] presentViewController:self.selectCompanyVC animated:YES completion:^{
    
    }];
}

- (void)companyListVC:(HSSelectCompanyVC *)selectCompanyVC companyModel:(HSCompanyModel *)companyModel
{
   NSData *data =  [NSKeyedArchiver archivedDataWithRootObject:companyModel];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:kStoreKeyLastSelectCompanyModel];
//    NSData *lastCompanyArchiver = (NSData *)[[NSUserDefaults standardUserDefaults] objectForKey:kStoreKeyLastSelectCompanyModel];
//    HSCompanyModel *companyModel = (HSCompanyModel *)[NSKeyedUnarchiver unarchiveObjectWithData:lastCompanyArchiver];
    
//    self.companyModel = companyModel;
    self.companyModel = companyModel;
    [self.companyNameTF setText:self.companyModel.companyName];
}
- (NSInteger)appType {
    if (!_appType) {
        _appType = kHSAPPTYPE;
    }
    return _appType;
}
- (HSCompanyModel *)companyModel {
    if (!_companyModel) {
        _companyModel = [[HSCompanyModel alloc] init];
        if (self.appType == HSAppTypeHongSongPai) {
            _companyModel.companyID = @"100709";
            _companyModel.companyName = @"南京红松信息技术有限公司";
            _companyModel.companyUUID = @"6B9B086751F0492BAEDDF84E707F7F6B";
        }
        
    }
    return _companyModel;
}
@end
