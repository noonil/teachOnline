//
//  HSMineExamVC.m
//  koreanpine
//
//  Created by Christ on 15/7/18.
//  Copyright (c) 2015年 Christ. All rights reserved.
//

#import "HSMineExamVC.h"

@interface HSMineExamVC ()
<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) UIImageView *placeHolderimageView;

@end

@implementation HSMineExamVC

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
    [self.view setBackgroundColor:RGBCOLOR(235, 235, 235)];
    
    self.title = @"我的考试";
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:self.backBtn];
    self.navigationItem.leftBarButtonItem = backItem;
    
    
    self.placeHolderimageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"placeholder1"]];
    [self.placeHolderimageView setFrame:CGRectMake(0, 0, 210, 170)];
    [self.placeHolderimageView setCenter:CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds))];
    [self.placeHolderimageView setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin];
    [self.view addSubview:self.placeHolderimageView];
    
//    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
//    [self.tableView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
//    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
//    [self.tableView setDataSource:self];
//    [self.tableView setDelegate:self];
//    [self.view addSubview:self.tableView];
}

#pragma mark - UITableView Datasource and Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdent"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellIdent"];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
//    NSString *title = self.cellTitles[indexPath.row];
//    [cell.textLabel setText:title];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 47.0f;
}



@end
