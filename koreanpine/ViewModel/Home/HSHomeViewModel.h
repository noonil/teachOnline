//
//  HSHomeViewModel.h
//  koreanpine
//
//  Created by Christ on 15/7/15.
//  Copyright (c) 2015年 Christ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YH_Model.h"

@class HSHomeSectionTitle;
@class HSHomeCellInfo;
@class HSHomeViewModel;

@protocol HSHomeViewModelDelegate <NSObject>

- (void)homeViewModelDidUpdateCellInfo:(HSHomeViewModel *)homeViewModel;

@end

@interface HSHomeViewModel : NSObject

@property (weak, nonatomic) id<HSHomeViewModelDelegate> delegate;

- (NSArray *)bannerImageNames;

- (NSUInteger)tableViewSectionCount;

- (NSUInteger)tableViewNumberOfRowsInSection:(NSUInteger)section;

- (HSHomeSectionTitle *)tableViewHomeSectionTitleAtSection:(NSUInteger)section;

- (HSHomeCellInfo *)tableViewHomeCellInfoAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface HSHomeSectionTitle : NSObject

@property (copy, nonatomic) NSString *imageName;

@property (copy, nonatomic) NSString *title;

@end

@interface HSHomeCellInfo : NSObject

@property (copy, nonatomic) NSString *imageName;

@property (copy, nonatomic) NSString *highlightImageName;

@property (copy, nonatomic) NSString *title;

@property (assign, nonatomic) BOOL shouldHighlight;

@end


