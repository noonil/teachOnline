//
//  YHEUserHeaderImagePicker.h
//  YOHOE
//
//  Created by Christ on 14-4-25.
//  Copyright (c) 2014年 NewPower Co. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  用于选择用户及品牌头像的图片选择器及处理逻辑代码
 */

@protocol HSUserHeaderImagePickerDelegate;

@interface HSUserHeaderImagePicker : NSObject
<UIActionSheetDelegate>

@property (nonatomic,weak) UIViewController<HSUserHeaderImagePickerDelegate> *mainVC;

@end

@protocol HSUserHeaderImagePickerDelegate <NSObject>

- (void)HSUserHeaderImagePicker:(HSUserHeaderImagePicker *)picker croppingFinished:(UIImage *)resultImage;

@optional

- (void)HSUserHeaderImagePicker:(HSUserHeaderImagePicker *)picker otherBtnTappedAtIndex:(NSInteger)index;

@end
