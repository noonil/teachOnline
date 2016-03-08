//
//  HSRemoveCollect.h
//  koreanpine
//
//  Created by 陶山强 on 15/10/28.
//  Copyright © 2015年 Christ. All rights reserved.
//

#import "YH_ArrayDataMgr.h"

@interface HSRemoveCollect : YH_ArrayDataMgr
- (void)fetchItemsAtPage:(YH_Page *)page succeededHandler:(void (^)(NSInteger, NSArray *))succeededHandler failedHandler:(void (^)(NSError *))failedHandler;
@end
