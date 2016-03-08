//
//  HSPracticeWrongDetailVC.h
//  koreanpine
//
//  Created by 陶山强 on 15/11/6.
//  Copyright © 2015年 Christ. All rights reserved.
//

#import "HSBaseVC.h"

#import "HSPracticeWrongViewModel.h"
@class HSLectureHomeworkModel;
@interface HSPracticeWrongDetailVC : HSBaseVC
- (instancetype)initWithHomeworkModel:(HSLectureHomeworkModel *)homeworkModel;
@property(nonatomic,strong)HSPracticeWrongViewModel *detailViewModel;
@property (strong, nonatomic) HSLectureHomeworkModel *homeworkModel;
@property(nonatomic,strong)HSDoHomeworkViewModel *doHomeWorkViewModel;
@property(nonatomic,assign)NSInteger selectedIndex;
@property(nonatomic,assign)NSInteger currentIndex;
@end
