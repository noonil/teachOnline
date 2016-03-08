//
//  HSPracticeViewAnswerVC.m
//  koreanpine
//
//  Created by 陶山强 on 15/11/9.
//  Copyright © 2015年 Christ. All rights reserved.
//

#import "HSPracticeViewAnswerVC.h"
#import "HSAnswerResultCell.h"
#import "HSAnswerSectionHeader.h"
#import "HSAnswerOptionCell.h"
#import "HSQuestionHeaderView.h"
@interface HSPracticeViewAnswerVC ()
<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) UITableView *yhTableView;

@property (strong, nonatomic) HSDoHomeworkViewModel *doHomeworkViewModel;

@end

@implementation HSPracticeViewAnswerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.doHomeworkViewModel = [[HSDoHomeworkViewModel alloc] init];
    
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateViewAnswerVCWith:(HSDoHomeworkViewModel *)doHomeworkVM
{
    self.doHomeworkViewModel = doHomeworkVM;
    [self.yhTableView reloadData];
}

- (void)initView
{
    [self.view setBackgroundColor:RGBCOLOR(235, 235, 235)];
    
    self.yhTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.yhTableView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    [self.yhTableView setDataSource:self];
    [self.yhTableView setDelegate:self];
    [self.yhTableView setBounces:NO];
    [self.yhTableView setBackgroundColor:[UIColor clearColor]];
    [self.yhTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.yhTableView setTableFooterView:[UIView new]];
    
    [self.yhTableView registerNib:[UINib nibWithNibName:@"HSAnswerOptionCell" bundle:nil] forCellReuseIdentifier:@"HSAnswerOptionCell"];
    [self.yhTableView registerClass:[HSQuestionHeaderView class] forHeaderFooterViewReuseIdentifier:@"HSQuestionHeaderView"];
    [self.yhTableView registerNib:[UINib nibWithNibName:@"HSAnswerResultCell" bundle:nil] forCellReuseIdentifier:@"HSAnswerResultCell"];
    [self.yhTableView registerNib:[UINib nibWithNibName:@"HSAnswerJudgeCell" bundle:nil] forCellReuseIdentifier:@"HSAnswerJudgeCell"];
    [self.yhTableView registerClass:[HSAnswerSectionHeader class] forHeaderFooterViewReuseIdentifier:@"HSAnswerSectionHeader"];
    [self.view addSubview:self.yhTableView];
    
}

- (void)updateDoHomeworkVCWith:(HSDoHomeworkViewModel *)doHomeworkVM
{
    self.doHomeworkViewModel = doHomeworkVM;
    [self.yhTableView reloadData];
}

#pragma mark - UITableView Datasource and Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        if (self.doHomeworkViewModel.questionModel.quesType == HSQuesTypeJudge) {
            return 1;
        } else {
            return [self.doHomeworkViewModel optCount];
        }
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (self.doHomeworkViewModel.questionModel.quesType == HSQuesTypeJudge) {
            HSAnswerJudgeCell *cell = (HSAnswerJudgeCell *)[tableView dequeueReusableCellWithIdentifier:@"HSAnswerJudgeCell"];
            if ([self.doHomeworkViewModel.questionModel.answer isEqualToString:@"对"]) {
                [cell setAnswerJudgeType:HSJudgeTypeRight];
            } else {
                [cell setAnswerJudgeType:HSJudgeTypeWrong];
            }
            
            [cell setUserJudgeType:self.doHomeworkViewModel.userJudgeType];
            return cell;
        } else {
            NSArray *btnTitles = @[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J"];
            HSAnswerOptionCell *cell = (HSAnswerOptionCell *)[tableView dequeueReusableCellWithIdentifier:@"HSAnswerOptionCell"];
            [cell.optionLabel setText:[self.doHomeworkViewModel optValueAtIndex:indexPath.row]];
            [cell.optionBtn setTitle:btnTitles[indexPath.row] forState:UIControlStateNormal];
            if (self.doHomeworkViewModel.questionModel.quesType == HSQuesTypeMuiltSelect) {
                [cell.optionBtn.layer setCornerRadius:3.0f];
                [cell.optionBtn.layer setMasksToBounds:YES];
            } else {
                [cell.optionBtn.layer setCornerRadius:CGRectGetWidth(cell.optionBtn.bounds)/2];
                [cell.optionBtn.layer setMasksToBounds:YES];
            }
            BOOL optionSelected = [self.doHomeworkViewModel.selectedIndexPaths containsObject:indexPath];
            BOOL rightOption = [self.doHomeworkViewModel.realAnswerIndexPaths containsObject:indexPath];
            [cell setOptionSelected:optionSelected];
            [cell setIsRightOption:rightOption];
            return cell;
        }
    } else {
        HSAnswerResultCell *cell = (HSAnswerResultCell *)[tableView dequeueReusableCellWithIdentifier:@"HSAnswerResultCell"];
        [cell updateCellWithQuestionItem:self.doHomeworkViewModel.questionModel];
        return cell;
    }
    
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        HSQuestionHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"HSQuestionHeaderView"];
        [headerView.questionLabel setText:self.doHomeworkViewModel.questionModel.content];
        if (self.doHomeworkViewModel.questionModel.quesType == HSQuesTypeMuiltSelect) {
            headerView.questionTypeLabel.hidden = NO;
        }else {
            headerView.questionTypeLabel.hidden = YES;
        }
        
        return headerView;
    } else {
        HSAnswerSectionHeader *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"HSAnswerSectionHeader"];
        return headerView;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        NSString *answer = self.doHomeworkViewModel.questionModel.content;
        CGFloat height = [Common heightForString:answer FontSize:[UIFont systemFontOfSize:17.0f] constrainedSize:CGSizeMake(CGRectGetWidth(tableView.frame)-30.0f, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping]+16;
        if (self.doHomeworkViewModel.questionModel.quesType == HSQuesTypeMuiltSelect) {
            height += 20;
        }
        //        return height;
        return 60.0f>(height)?60.0f:height;
    } else {
        return 50.0f;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        NSString *answer = [self.doHomeworkViewModel optValueAtIndex:indexPath.row];
        CGFloat height = [Common heightForString:answer FontSize:[UIFont systemFontOfSize:14.0f] constrainedSize:CGSizeMake(CGRectGetWidth(tableView.frame)-91.0f, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping]+30;
        return (70.0f>(height)?70.0f:height);
    } else {
        NSString *text = [NSString stringWithFormat:@"试题解析：%@",self.doHomeworkViewModel.questionModel.analysis];
        CGRect textRect = [text boundingRectWithSize:CGSizeMake(CGRectGetWidth(tableView.frame)-16, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0f]} context:NULL];
        CGFloat cellHeigt = 84.0f + ceil(textRect.size.height);
        return cellHeigt;
    }
}


@end
