//
//  HSLoginVC.h
//  koreanpine
//
//  Created by Christ on 15/7/15.
//  Copyright (c) 2015年 Christ. All rights reserved.
//

#import "HSBaseVC.h"
@class HSCompanyModel;
@interface HSLoginVC : HSBaseVC
@property (nonatomic,copy) NSString *phoneNumber;
@property (nonatomic,strong) HSCompanyModel *companyModel;

@end
