//
//  HSPracticeWrongCell.h
//  koreanpine
//
//  Created by 陶山强 on 15/11/5.
//  Copyright © 2015年 Christ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSPracticeWrongModel.h"
@interface HSPracticeWrongCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *WrongNum;
@property (weak, nonatomic) IBOutlet UILabel *wrongText;
@property(nonatomic,strong)HSPracticeWrongModel *practiceWrongModel;
- (void)updateCellWith:(HSPracticeWrongModel *)practiceWrongModel wrongNum:(NSString *)wrongNum;

@end
