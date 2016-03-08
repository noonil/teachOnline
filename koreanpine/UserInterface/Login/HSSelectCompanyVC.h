//
//  HSSelectCompanyVC.h
//  koreanpine
//
//  Created by Christ on 15/7/15.
//  Copyright (c) 2015年 Christ. All rights reserved.
//

#import "HSBaseVC.h"
#import "HSCompanyModel.h"


@protocol HSCompanyListVCDelegate;


typedef NS_ENUM(NSInteger, YHEBrandListViewControllerType) {
    YHEBrandListViewControllerTypeDefault,
    YHEBrandListViewControllerTypeArticle,
};


@interface HSSelectCompanyVC : HSBaseVC

@property (nonatomic, weak) id<HSCompanyListVCDelegate> delegate;
@property (nonatomic, getter = isNavigationBarTranslucent) BOOL navigationBarTranslucent;
@property (nonatomic, strong) NSArray   *products;
//显示半透明的图
@property (nonatomic, strong) UIImageView *bgImageView;
@property (strong ,nonatomic) UIImage *bgImage;

- (void)showBrandSelection;

@end

@interface YHEBrandListCell : UITableViewCell

@property (nonatomic,strong) UILabel *contentLabel;
- (void)fillCellWithText:(NSString *)text;

- (void)resetCell;

@end


@protocol HSCompanyListVCDelegate

- (void)companyListVC:(HSSelectCompanyVC *)selectCompanyVC companyModel:(HSCompanyModel *)companyModel;

@end
