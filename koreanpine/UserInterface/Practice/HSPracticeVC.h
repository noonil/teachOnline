//
//  HSPracticeVC.h
//  koreanpine
//
//  Created by Christ on 15/7/15.
//  Copyright (c) 2015年 Christ. All rights reserved.
//

#import "HSBaseVC.h"
@class HSPracticePKVC;
@interface HSPracticeVC : HSBaseVC
@property (nonatomic,strong) HSPracticePKVC * practicePKVC;
@property (nonatomic,weak) UIScrollView *scrollView;
@end
