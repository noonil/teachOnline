//
//  HSMyCollectionsVC.h
//  koreanpine
//
//  Created by 陶山强 on 15/10/27.
//  Copyright © 2015年 Christ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSMyCollectionViewModel.h"
#define kShowTableViewEditingNotification @"kShowTableViewEditingNotification"
#define kHideTableViewEditingNotification @"kHideTableViewEditingNotification"
#define kDeleteMyCollectionsNotification @"kDeleteMyCollectionsNotification"
@interface HSMyCollectionsVC : UITableViewController
@property (strong, nonatomic) HSMyCollectionViewModel *mycollectLectureViewModel;
-(void)initView;
@end
