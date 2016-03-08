//
//  HSPracticeWrongVC.h
//  koreanpine
//
//  Created by 陶山强 on 15/11/5.
//  Copyright © 2015年 Christ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSPracticeWrongModel.h"
@interface HSPracticeWrongVC : UIViewController
@property(nonatomic,strong)NSMutableArray *practiceWrongList;
@property(nonatomic,strong)HSPracticeWrongModel *practiceWrongModel;
-(void)wrongListViewReload;
-(void)fetchLatests;
@end
