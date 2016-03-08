//
//  YH_Page.h
//  YH_Mall
//
//  Created by Christ on 15/2/2.
//  Copyright (c) 2015年 YOHO. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * 查询结果中分页信息封装
 */
@interface YH_Page : NSObject

/**
 * 总条数
 */
@property(nonatomic) NSInteger totalCount;
/**
 * 总分页数
 */
@property(nonatomic) NSInteger totalPageCount;
/**
 * 当前页码
 *
 * 从1开始
 */
@property(nonatomic) NSInteger currentPage;

/**
 * 每页显示数
 */
@property(nonatomic) NSInteger pageSize;

/**
 * 增加页数
 */
- (void) increasePage;

/**
 * 重置
 */
- (void) reset;

/**
 * 是否是第一页
 *
 * @return YES or NO
 */
- (BOOL) isFirstPage;

@end
