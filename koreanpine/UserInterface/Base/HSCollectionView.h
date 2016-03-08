//
//  YH_CollectionView.h
//  YH_Mall
//
//  Created by Cloud on 15/4/24.
//  Copyright (c) 2015年 YOHO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefresh.h"


@interface HSCollectionView : UICollectionView

- (void)addRefreshActionHandler:(void(^)())block;
- (void)addRefresTarget:(id)target action:(SEL)refreshAction;

- (void)addLoadMoreActionHandler:(void(^)())block;;
- (void)addLoadMoreTarget:(id)target action:(SEL)loadAction;


@end
