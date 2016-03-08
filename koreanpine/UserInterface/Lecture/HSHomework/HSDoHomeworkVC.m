//
//  HSDoHomeworkVC.m
//  koreanpine
//
//  Created by Christ on 15/8/18.
//  Copyright (c) 2015年 Christ. All rights reserved.
//

#import "HSDoHomeworkVC.h"
#import "HSDoHomeworkViewModel.h"
#import "HSQuestionHeaderView.h"
#import "HSAnswerOptionCell.h"

@interface HSDoHomeworkVC ()
<UITableViewDataSource,UITableViewDelegate,HSAnswerJudgeCellDelegate>

@property (strong, nonatomic) UITableView *yhTableView;

@property (strong, nonatomic) HSDoHomeworkViewModel *doHomeworkViewModel;

@end

@implementation HSDoHomeworkVC

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
    [self.yhTableView registerNib:[UINib nibWithNibName:@"HSAnswerJudgeCell" bundle:nil] forCellReuseIdentifier:@"HSAnswerJudgeCell"];
    [self.yhTableView registerClass:[HSQuestionHeaderView class] forHeaderFooterViewReuseIdentifier:@"HSQuestionHeaderView"];
    [self.view addSubview:self.yhTableView];
    
}

- (void)updateDoHomeworkVCWith:(HSDoHomeworkViewModel *)doHomeworkVM
{
    self.doHomeworkViewModel = doHomeworkVM;
    [self.yhTableView reloadData];
}

#pragma mark - UITableView Datasource and Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.doHomeworkViewModel.questionModel.quesType == HSQuesTypeJudge) {
        return 1;
    } else {
        return [self.doHomeworkViewModel optCount];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.doHomeworkViewModel.questionModel.quesType == HSQuesTypeJudge) {
        HSAnswerJudgeCell *cell = (HSAnswerJudgeCell *)[tableView dequeueReusableCellWithIdentifier:@"HSAnswerJudgeCell"];
        [cell setIsTesting:YES];
        cell.delegate = self;
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
        [cell setIsTesting:YES];
        BOOL optionSelected = [self.doHomeworkViewModel.selectedIndexPaths containsObject:indexPath];
        [cell setOptionSelected:optionSelected];
        
        return cell;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    HSQuestionHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"HSQuestionHeaderView"];
    [headerView.contentView setBackgroundColor:[UIColor clearColor]];
    [headerView.questionLabel setText:self.doHomeworkViewModel.questionModel.content];
    if (self.doHomeworkViewModel.questionModel.quesType == HSQuesTypeMuiltSelect) {
        headerView.questionTypeLabel.hidden = NO;
    }else {
        headerView.questionTypeLabel.hidden = YES;
    }
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
//    CGRect textRect = [self.doHomeworkViewModel.questionModel.content boundingRectWithSize:CGSizeMake(CGRectGetWidth(tableView.frame)-30.0f, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17.0f],} context:NULL];
//    CGSize textSize = textRect.size;
    NSString *answer = self.doHomeworkViewModel.questionModel.content;
    CGFloat height = [Common heightForString:answer FontSize:[UIFont systemFontOfSize:17.0f] constrainedSize:CGSizeMake(CGRectGetWidth(tableView.frame)-30.0f, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping]+16;
    if (self.doHomeworkViewModel.questionModel.quesType == HSQuesTypeMuiltSelect) {
        height += 20;
    }
    return height;
//    return 60.0f>(height)?60.0f:height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *answer = [self.doHomeworkViewModel optValueAtIndex:indexPath.row];
    CGFloat height = [Common heightForString:answer FontSize:[UIFont systemFontOfSize:14.0f] constrainedSize:CGSizeMake(CGRectGetWidth(tableView.frame)-91.0f, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping]+30;
    return (70.0f>(height)?70.0f:height);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.doHomeworkViewModel.questionModel.quesType == HSQuesTypeSingleSelect) {
        //已经选中的全部去选中
        for (NSIndexPath *selectedIndexPath in self.doHomeworkViewModel.selectedIndexPaths) {
            if (![selectedIndexPath isEqual:indexPath]) {
                HSAnswerOptionCell *selectedCell = (HSAnswerOptionCell *)[tableView cellForRowAtIndexPath:selectedIndexPath];
                [selectedCell setOptionSelected:NO];
            }
        }
        [self.doHomeworkViewModel.selectedIndexPaths removeAllObjects];
         [[NSNotificationCenter defaultCenter] postNotificationName:kExerciseBtnDidTappedNotification object:@1];
    }
    
    HSAnswerOptionCell *cell = (HSAnswerOptionCell *)[tableView cellForRowAtIndexPath:indexPath];

    if (![self.doHomeworkViewModel.selectedIndexPaths containsObject:indexPath]) {
        [self.doHomeworkViewModel.selectedIndexPaths addObject:indexPath];
        [cell setOptionSelected:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:kExerciseBtnDidTappedNotification object:@1];
    } else {
        [self.doHomeworkViewModel.selectedIndexPaths removeObject:indexPath];
        [cell setOptionSelected:NO];
        [[NSNotificationCenter defaultCenter] postNotificationName:kExerciseBtnDidTappedNotification object:@-1];
    }
   
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y == 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kPracticeTableViewArriveTopNotification object:nil];
    }else  if (((scrollView.contentSize.height-scrollView.frame.size.height) - scrollView.contentOffset.y)*10.0 < 1) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kPracticeTableViewArriveBottomNotification object:nil];
    }
}

- (void)userJudgeStateChangTo:(HSJudgeType)userJudgeType
{
    [self.doHomeworkViewModel setUserJudgeType:userJudgeType];
}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
//    NSLog(@"%@",NSStringFromCGRect(self.yhTableView.tableHeaderView.frame));
}
@end
