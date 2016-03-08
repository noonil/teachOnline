//
//  HSHeroCell.h
//  koreanpine
//
//  Created by Victor on 15/11/5.
//  Copyright © 2015年 Christ. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HSHeroModel;
@interface HSHeroCell : UITableViewCell
@property (nonatomic,strong) HSHeroModel *heroModel;
@property (nonatomic,copy) NSString *sortType;
@property (nonatomic,assign) NSInteger placeNum;
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier placeNum:(NSInteger)placeNum;
@end
