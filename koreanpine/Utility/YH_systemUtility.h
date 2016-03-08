//
//  YH_systemUtility.h
//  YH_Mall
//
//  Created by jhsonzhi on 15/6/3.
//  Copyright (c) 2015年 YOHO. All rights reserved.
//

#ifndef YH_Mall_YH_systemUtility_h
#define YH_Mall_YH_systemUtility_h

#define IPHONE5                     ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define IOS7                        ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0 ? YES : NO )


#define RGBCOLOR(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define RGBCOLORVALUE(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define WS(weakSelf)    __weak __typeof(&*self)weakSelf = self

#define kPathCache                  [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]

#define kPathVideoCache           [kPathCache stringByAppendingPathComponent:@"HSVideoCache"]
#define kPathDocumentCache        [kPathCache stringByAppendingPathComponent:@"HSDocumentCache"]
//非空判断
#define kUIAppearanceEnabled        (NSProtocolFromString(@"UIAppearance") != nil)

#define IsNilOrNull(_ref)           (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]))

#define IsDictionaryClass(_ref)     (!IsNilOrNull(_ref) && ([(_ref) isKindOfClass:[NSDictionary class]]))

#define IsArrayClass(_ref)          (!IsNilOrNull(_ref) && ([(_ref) isKindOfClass:[NSArray class]]))

#define IsStrEmpty(_ref)            (IsNilOrNull(_ref) || (![(_ref) isKindOfClass:[NSString class]]) || ([(_ref) isEqualToString:@""]))

#define IsArrEmpty(_ref)            (IsNilOrNull(_ref) || (![(_ref) isKindOfClass:[NSArray class]]) || ([(_ref) count] == 0))


#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define DLog(...)
#endif

// Thanks to: https://gist.github.com/1057420
#define SHARED_INSTANCE_USING_BLOCK(block) \
static dispatch_once_t pred = 0; \
__strong static id _sharedObject = nil; \
dispatch_once(&pred, ^{ \
_sharedObject = block(); \
}); \
return _sharedObject; \

#define DrawViewBorder(view,width,color)\
view.layer.borderWidth = width;\
view.layer.borderColor = color.CGColor;\

//部分屏幕尺寸基于320等比例放大的尺寸
#define kScreenPointScale            CGRectGetWidth([[UIScreen mainScreen] bounds])/320.0f
#define CGRectScreenScaleMake(x,y,width,height) \
CGRectMake(x*kScreenPointScale,y*kScreenPointScale,width*kScreenPointScale,height*kScreenPointScale)
#define UIEdgeInsetsScreenScaleMake(top, left, bottom, right) \
UIEdgeInsetsMake(top*kScreenPointScale,left*kScreenPointScale,bottom*kScreenPointScale,right*kScreenPointScale)

#define CGSizeScreenScaleMake(width, height) \
CGSizeMake(width*kScreenPointScale, height*kScreenPointScale)

#define kScreenWidth                ([[UIScreen mainScreen] bounds].size.width)
#define kScreenHeight                ([[UIScreen mainScreen] bounds].size.height)

#define kActionBtnNormalColor RGBCOLOR(48, 172, 11)
#define kActionBtnLightColor RGBCOLOR(193, 193, 193)
#define kActionBtnSelectColor RGBCOLOR(251, 0, 6)

#endif
