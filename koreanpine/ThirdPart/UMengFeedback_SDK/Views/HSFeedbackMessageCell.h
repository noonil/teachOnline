//
//  UMPostTableViewCell.h
//  Feedback
//
//  Created by amoblin on 14/9/10.
//  Copyright (c) 2014年 umeng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, YHEPrivateMessageType) {
    YHEPrivateMessageTypeMe, // 自己发的
    YHEPrivateMessageTypeOther, //别人发得
};

typedef NS_ENUM(NSInteger, YHESendMessageStatus) {
    YHEMessageDefault,          //默认状态
    YHEMessageSending,          //发送中
    YHEMessageSendingSuccess,   //发送成功
    YHEMessageSendingFailed,    //发送失败
};

typedef NS_ENUM(NSInteger, YHEPrivateMessageContentType) {
    YHEPrivateMessageText,         //文本类型
    YHEPrivateMessageImage,        //图片类型
};

@interface YHMessageMaskImageView : UIImageView

@property(nonatomic,assign)YHEPrivateMessageType privateMessageType;

@end

@class HSFeedbackMessageCell;

@protocol YHEPrivateMessageImageDelegate <NSObject>

- (void)cell:(HSFeedbackMessageCell *)cell contentImageTapped:(NSDictionary *)info;

@end



@interface HSFeedbackMessageCell : UITableViewCell

@property(nonatomic,weak) id<YHEPrivateMessageImageDelegate> imageDelegate;//图片delegate

@property (nonatomic,readonly) YHMessageMaskImageView     *contentImageView;

@property (strong, nonatomic) NSDictionary *info;

- (void)configCell:(NSDictionary *)info;

+ (CGFloat)heightWithInfo:(NSDictionary *)info;

@end
