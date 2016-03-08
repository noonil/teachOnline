//
//  HSClassListVC.h
//  koreanpine
//
//  Created by Christ on 15/8/3.
//  Copyright (c) 2015年 Christ. All rights reserved.
//

#import "HSBaseVC.h"
#import "HSLectureDetailVC.h"
#import "HSLectureDetailViewModel.h"
#import "HSLectureHsDetailViewModel.h"
@interface HSClassListVC : HSBaseVC

- (instancetype)initWithLectureDetailViewModel:(NSObject *)viewModel;

@property (weak, nonatomic) HSLectureDetailVC *mainVC;
@property (nonatomic,strong) NSIndexPath *selectedIndexPath;
- (void)updateLectureStageView;

@end
