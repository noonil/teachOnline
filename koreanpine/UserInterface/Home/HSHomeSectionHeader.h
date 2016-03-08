//
//  HSHomeSectionHeader.h
//  koreanpine
//
//  Created by Christ on 15/7/18.
//  Copyright (c) 2015年 Christ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSHomeViewModel.h"

@interface HSHomeSectionHeader : UITableViewHeaderFooterView

- (void)updateSectionHeaderWith:(HSHomeSectionTitle *)homeSectionTitle;

@end
