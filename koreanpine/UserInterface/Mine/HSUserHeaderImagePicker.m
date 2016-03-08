//
//  YHEUserHeaderImagePicker.m
//  YOHOE
//
//  Created by Christ on 14-4-25.
//  Copyright (c) 2014年 NewPower Co. All rights reserved.
//

#import "HSUserHeaderImagePicker.h"

@interface HSUserHeaderImagePicker ()
<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@end

@implementation HSUserHeaderImagePicker

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo {
    
    [self.mainVC HSUserHeaderImagePicker:self croppingFinished:image];
    
}



- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *selectedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self.mainVC HSUserHeaderImagePicker:self croppingFinished:selectedImage];
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}


#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.allowsEditing = NO;
        imagePicker.delegate = self;
        [_mainVC presentViewController:imagePicker animated:YES completion:^{
        }];
    }
    else if (buttonIndex == 1)
    {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.allowsEditing = NO;
        imagePicker.delegate = self;
        [_mainVC presentViewController:imagePicker animated:YES completion:^{
        }];
    }
    else
    {
        if ([_mainVC respondsToSelector:@selector(HSUserHeaderImagePicker:otherBtnTappedAtIndex:)]) {
            [_mainVC HSUserHeaderImagePicker:self otherBtnTappedAtIndex:buttonIndex];
        }
    }
}

@end
