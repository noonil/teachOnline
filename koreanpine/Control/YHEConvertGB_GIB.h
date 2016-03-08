//
//  YHEConvertGB_GIB.h
//  YOHOE
//
//  Created by 葛祥通 on 14-5-15.
//  Copyright (c) 2014年 NewPower Co. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 基本原理
 字体的切换其实就是编码的切换
 GB2312<->Unicode<->BIG5
 这样一个流程，Unicode充当切换的桥梁。
 */

@interface YHEConvertGB_GIB : NSObject
{
	NSString*	_string_GB;
	NSString*	_string_BIG5;
}

-(NSString*)gbToBig5:(NSString*)srcString;
-(NSString*)big5ToGb:(NSString*)srcString;
@end
