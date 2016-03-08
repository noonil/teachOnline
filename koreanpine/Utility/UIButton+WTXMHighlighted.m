//
//  UIButton+WTXMHighlighted.m
//  WTXMMicroblog
//
//  Created by 王涛 on 15/8/30.
//  Copyright (c) 2015年 王涛. All rights reserved.
//

#import "UIButton+WTXMHighlighted.h"
#import <objc/runtime.h>
#define k_highlightEnabled @"highlightEnabled"
@implementation UIButton (WTXMHighlighted)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class claxx = [self class];
        SEL originalSel = @selector(setHighlighted:);
        SEL swizzledSel = @selector(WT_setHighlighted:);
        Method originalMethod = class_getInstanceMethod(claxx, originalSel);
        Method swizzledMethod = class_getInstanceMethod(claxx, swizzledSel);
       BOOL success = class_addMethod(claxx, swizzledSel, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
        if (success) {
            class_replaceMethod(claxx, swizzledSel, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
        }else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
        
    });
}


- (void)WT_setHighlighted:(BOOL)highlighted {
    if (!self.isHighlightEnabled) {
        [self WT_setHighlighted:highlighted];
    }
}







- (void)setHighlightEnabled:(BOOL)highlightEnabled {
    objc_setAssociatedObject(self, k_highlightEnabled, @(highlightEnabled), OBJC_ASSOCIATION_ASSIGN);
}
- (BOOL)isHighlightEnabled {
   return (BOOL)objc_getAssociatedObject(self, k_highlightEnabled);
}
@end
