//
//  CHArrayDataMgr.h
//  EPXinGongYi
//
//  Created by Christ on 14/10/27.
//  Copyright (c) 2014年 lichengfei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YH_Page.h"
#import "YH_Model.h"

typedef NS_ENUM(NSUInteger, CHFetchType)
{
    CHFetchLatest = 0,
    CHFetchMore
};

@class YH_ArrayDataMgr;

@protocol YH_ArrayDataLoadDelegate <NSObject>

- (void)arrayDataMgr:(YH_ArrayDataMgr *)arrayDataMgr didFinishFetch:(CHFetchType)fetchType succeed:(BOOL)succeed error:(NSError *)error;

@optional

- (void)arrayDataMgr:(YH_ArrayDataMgr *)arrayDataMgr willFetch:(CHFetchType)fetchType;

- (void)arrayDataMgr:(YH_ArrayDataMgr *)arrayDataMgr didDeleteContentAtIndex:(NSInteger)index;

- (void)arrayDataMgrUpdateData:(YH_ArrayDataMgr *)arrayDataMgr;

@end

@interface YH_ArrayDataMgr : NSObject

@property (nonatomic, readonly) NSMutableArray *contents;

@property (nonatomic,readonly,getter = isRefetching) BOOL refetching;
@property (nonatomic,readonly,getter = isFechingLatest) BOOL fetchingLatest;
@property (nonatomic,readonly,getter = isFechingMore) BOOL fetchingMore;
@property (nonatomic,assign) BOOL hasMoreItems;
@property (strong, nonatomic) YH_Page *pageMgr;
@property (nonatomic,copy) void (^reloadBlock)();
@property (nonatomic,weak) id<YH_ArrayDataLoadDelegate> delegate;

- (NSInteger)contentCount;
- (NSUInteger)indexOfContent:(YH_Model *)content;
- (YH_Model *)contentAtIndex:(NSInteger)index;
- (BOOL)containsContent:(YH_Model *)content;
- (void)deleteContentAtIndex:(NSInteger)index;
- (void)deleteAllContents;

- (void)fetchLatest;

- (void)fetchMore;

- (void)fetchItemsAtPage:(YH_Page *)page succeededHandler:(void(^)(NSInteger totalCount, NSArray *fetchedItems))succeededHandler failedHandler:(void(^)(NSError *error))failedHandler;

@end
