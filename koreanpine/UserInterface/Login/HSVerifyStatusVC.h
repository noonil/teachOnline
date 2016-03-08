//
//  HSVerifyStatusVC.h
//  koreanpine
//
//  Created by Victor on 15/10/16.
//  Copyright © 2015年 Christ. All rights reserved.
//

#import "HSBaseVC.h"
@class HSCompanyModel;
@interface HSVerifyStatusVC : HSBaseVC
@property (strong, nonatomic) HSCompanyModel *companyModel;
@property (nonatomic,copy) NSString *phoneNum;
@end
