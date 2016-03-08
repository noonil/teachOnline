//
//  YH_Page.m
//  YH_Mall
//
//  Created by Christ on 15/2/2.
//  Copyright (c) 2015年 YOHO. All rights reserved.
//

#import "YH_Page.h"

@implementation YH_Page

/**
 * 增加页数
 */
- (void) increasePage {
    self.currentPage ++;
}

/**
 * 重置
 */
- (void) reset {
    self.currentPage = 1;
}

- (BOOL) isFirstPage {
    return (self.currentPage == 1);
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<YH_Page>(total=%ld, countPages=%ld, pageNo=%ld, size:%ld)", (long)self.totalCount, (long)self.totalPageCount, (long)self.currentPage, (long)self.pageSize];
}

@end
