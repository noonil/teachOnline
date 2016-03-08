//
//  YHEPrivateMessageCell.h
//  YOHOE
//
//  Created by jin on 14-5-29.
//  Copyright (c) 2014年 NewPower Co. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "YHEPrivateMessage.h"

@class YHEPrivateMessage;

#define kTextContentLeftAndRightMarginOffset      10.0f
#define kTextContentTopAndBottomMarginOffset      3.0f

@protocol YHEPrivateMessageImageDelegate <NSObject>

- (void)contentImageTapped:(YHEPrivateMessage*)message;

@end

@interface YHEPrivateMessageCell : UITableViewCell

@property(nonatomic,weak) id<YHEPrivateMessageImageDelegate> imageDelegate;//图片delegate
@property(nonatomic,weak) id<YHEUserHeaderViewDelegate> userPortraitViewDelegate;//头像delegate
@property(nonatomic,weak) id<YHENewAttrLabelDelegate> attributedLabelDelegate;//属性文字

//因为好友头像url是外部带进来的所以作为参数传递
- (void)updateCellContent:(YHEPrivateMessage*)message friendAvatarUrl:(NSString*)url;

@end
