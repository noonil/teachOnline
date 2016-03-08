//
//  CHArrayDataMgr.m
//  EPXinGongYi
//
//  Created by Christ on 14/10/27.
//  Copyright (c) 2014年 lichengfei. All rights reserved.
//

#import "YH_ArrayDataMgr.h"

@interface YH_ArrayDataMgr ()

@property (nonatomic, readwrite) NSMutableArray *contents;

@property (nonatomic,assign) BOOL fetching;
@property (nonatomic, getter = isRefetching) BOOL refetching;
@property (nonatomic, getter = isFechingLatest) BOOL fetchingLatest;
@property (nonatomic, getter = isFechingMore) BOOL fetchingMore;

@property (nonatomic, assign) NSUInteger currentPage;

@end

@implementation YH_ArrayDataMgr

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.pageMgr = [[YH_Page alloc] init];
        [self.pageMgr setPageSize:10];
        [self.pageMgr setCurrentPage:1];
    }
    return self;
}
#pragma mark - 数据源的操作
- (NSMutableArray *)contents
{
    if (!_contents) {
        _contents = [NSMutableArray array];
    }
    return _contents;
}

- (NSInteger)contentCount
{
    return self.contents.count;
}

- (NSUInteger)indexOfContent:(YH_Model *)content
{
    NSUInteger index = [self.contents indexOfObject:content];
    return index;
}

- (YH_Model *)contentAtIndex:(NSInteger)index
{
    if (index < 0) {
        return nil;
    }
    
    if (index >= [self contentCount]) {
        return nil;
    }
    
    return [self.contents objectAtIndex:index];
}


- (BOOL)containsContent:(YH_Model *)content
{
    return [self.contents containsObject:content];
}


- (void)deleteContentAtIndex:(NSInteger)index
{
    if (index < 0) {
        return;
    }
    
    if (index >= [self contentCount]) {
        return;
    }
    
    [self.contents removeObjectAtIndex:index];
    
    if ([self.delegate respondsToSelector:@selector(arrayDataMgr:didDeleteContentAtIndex:)]) {
        [self.delegate arrayDataMgr:self didDeleteContentAtIndex:index];
    }
}

- (void)deleteAllContents
{
    [self.contents removeAllObjects];
}

#pragma mark - 数据加载

- (void)fetchLatest
{
    if (self.fetching) { return ; }
    [self.pageMgr reset];
    self.hasMoreItems = NO;
    [self.contents removeAllObjects];

    self.fetchingLatest = YES;
    WS(weakSelf);
    void (^succeededHandler)(NSInteger totalCount, NSArray *fetchedItems) = ^(NSInteger totalCount, NSArray *fetchedItems) {
        weakSelf.fetchingLatest = NO;
        weakSelf.hasMoreItems = (fetchedItems.count==weakSelf.pageMgr.pageSize);
        if (weakSelf.reloadBlock) {
            weakSelf.reloadBlock();
        }
            [weakSelf.contents addObjectsFromArray:fetchedItems];
        if ([weakSelf.delegate respondsToSelector:@selector(arrayDataMgr:didFinishFetch:succeed:error:)]) {
            [weakSelf.delegate arrayDataMgr:weakSelf didFinishFetch:CHFetchLatest succeed:YES error:nil];
        }
        
    };
    
    void (^failedHandler)(NSError *error) = ^(NSError *error) {
        weakSelf.fetchingLatest = NO;
        if ([weakSelf.delegate respondsToSelector:@selector(arrayDataMgr:didFinishFetch:succeed:error:)]) {
            [weakSelf.delegate arrayDataMgr:weakSelf didFinishFetch:CHFetchLatest succeed:NO error:error];
        }
    };
    if ([self.delegate respondsToSelector:@selector(arrayDataMgr:willFetch:)]) {
        [self.delegate arrayDataMgr:self willFetch:CHFetchLatest];
    }
    [self fetchItemsAtPage:self.pageMgr succeededHandler:succeededHandler failedHandler:failedHandler];
}

- (void)fetchMore
{
    if (self.fetching) { return ; }
    if (self.hasMoreItems) {
        [self.pageMgr increasePage];
        self.fetchingMore = YES;
        
        WS(weakSelf);
        void (^succeededHandler)(NSInteger totalCount, NSArray *fetchedItems) = ^(NSInteger totalCount, NSArray *fetchedItems) {
            weakSelf.fetchingMore = NO;
            weakSelf.hasMoreItems = (fetchedItems.count==weakSelf.pageMgr.pageSize);
            [weakSelf.contents addObjectsFromArray:fetchedItems];
            if ([weakSelf.delegate respondsToSelector:@selector(arrayDataMgr:didFinishFetch:succeed:error:)]) {
                [weakSelf.delegate arrayDataMgr:weakSelf didFinishFetch:CHFetchMore succeed:YES error:nil];
            }
            
        };
        
        void (^failedHandler)(NSError *error) = ^(NSError *error) {
            weakSelf.fetchingMore = NO;
            if ([weakSelf.delegate respondsToSelector:@selector(arrayDataMgr:didFinishFetch:succeed:error:)]) {
                [weakSelf.delegate arrayDataMgr:weakSelf didFinishFetch:CHFetchMore succeed:NO error:error];
            }
        };
        
        if ([self.delegate respondsToSelector:@selector(arrayDataMgr:willFetch:)]) {
            [self.delegate arrayDataMgr:self willFetch:CHFetchMore];
        }
        [self fetchItemsAtPage:self.pageMgr succeededHandler:succeededHandler failedHandler:failedHandler];
    }
}

- (BOOL)fetching
{
    return self.fetchingMore||self.fetchingLatest;
}

- (void)fetchItemsAtPage:(YH_Page *)page succeededHandler:(void(^)(NSInteger totalCount, NSArray *fetchedItems))succeededHandler failedHandler:(void(^)(NSError *error))failedHandler
{
    [NSException raise:@"Excute Error" format:@"Should SubClass"];
}

@end
