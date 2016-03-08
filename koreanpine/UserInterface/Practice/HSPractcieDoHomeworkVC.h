//
//  HSPractcieDoHomeworkVC.h
//  koreanpine
//
//  Created by 陶山强 on 15/11/9.
//  Copyright © 2015年 Christ. All rights reserved.
//

#import "HSBaseVC.h"
#import "HSDoHomeworkViewModel.h"
@interface HSPractcieDoHomeworkVC : HSBaseVC
- (void)updateDoHomeworkVCWith:(HSDoHomeworkViewModel *)doHomeworkVM;
@property(nonatomic,strong)UIButton *confirmButton;
@end
