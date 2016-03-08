//
//  YHEPrivateMessageCell.m
//  YOHOE
//
//  Created by jin on 14-5-29.
//  Copyright (c) 2014年 NewPower Co. All rights reserved.
//

#import "YHEPrivateMessageCell.h"

#define kTimeIntervalAMinute        (NSTimeInterval)(60)
#define kTimeIntervalAHour          (NSTimeInterval)(3600)
#define kTimeIntervalADay           (NSTimeInterval)(3600 * 24)

@interface YHMessageMaskImageView : UIImageView

@property(nonatomic,assign)YHEPrivateMessageType privateMessageType;

@end

@implementation YHMessageMaskImageView

-(void)setImage:(UIImage *)image
{
    if(!image || image.size.width < 100 || image.size.height < 100) {
        [super setImage:image];
    }else{
        
        UIImage* bubbleImage = nil;
        if(YHEPrivateMessageTypeMe == self.privateMessageType) {
            bubbleImage = [UIImage imageNamed:@"chat_photo_bubble_highlight"];
        }else{
            bubbleImage = [UIImage imageNamed:@"chat_photo_bubble_normal"];
        }
        UIImage* maskImage = [image maskWithImage:bubbleImage];
        [super setImage:maskImage];
    }
}

@end


@interface YHEPrivateMessageCell()

@property (nonatomic,strong) UIImageView          *headerImageView;
@property (nonatomic,strong) YHMessageMaskImageView     *contentImageView;
@property (nonatomic,strong) UIImageView                *bubbleImageView;
@property (nonatomic,strong) UIImageView                *picBubbleImageView;
@property (nonatomic,strong) UIImageView                *sendStatusImageView;
@property (nonatomic,strong) UILabel            *textContentLabel;
@property (nonatomic,strong) UILabel                    *timeLabel;
@property (nonatomic,strong) YHEPrivateMessage          *privateMessage;

@end

@implementation YHEPrivateMessageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initCell];
    }
    return self;
}

- (void)initCell
{
    self.backgroundColor = [UIColor whiteColor];
    
    self.headerImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:self.headerImageView];
    
//    self.contentImageView = [[YHMessageMaskImageView alloc] initWithFrame:CGRectMake(0, 0, 105, 100) placeHolderImageName:nil];
//    self.contentImageView.backgroundColor = [UIColor clearColor];
//    self.contentImageView.hidden = YES;
//    self.contentImageView.clipsToBounds = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapContentImage:)];
    [self.contentImageView addGestureRecognizer:tap];
    
    [self.contentView addSubview:self.contentImageView];
    
    self.bubbleImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    self.bubbleImageView.userInteractionEnabled = YES;
    [self.contentView addSubview:self.bubbleImageView];
    
    self.sendStatusImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    self.sendStatusImageView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.sendStatusImageView];

    //将内容文本Label放在气泡上
    self.textContentLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
    self.textContentLabel.font = [UIFont systemFontOfSize:14.0f];
    self.textContentLabel.textColor = [UIColor whiteColor];
    self.textContentLabel.textAlignment = NSTextAlignmentLeft;
    self.textContentLabel.backgroundColor = [UIColor clearColor];
    self.textContentLabel.numberOfLines = 0;
    self.textContentLabel.lineBreakMode = NSLineBreakByCharWrapping;
    [self.textContentLabel setText:@""];
    [self.bubbleImageView addSubview:self.textContentLabel];
    
    self.timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    self.timeLabel.font = [UIFont systemFontOfSize:10.0f];
    self.timeLabel.textColor =[UIColor grayColor];
    self.timeLabel.textAlignment = NSTextAlignmentCenter;
    self.timeLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.timeLabel];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressed:)];
    longPress.minimumPressDuration = 0.8;
    [self.contentView addGestureRecognizer:longPress];
    
}

- (void)updateCellContent:(YHEPrivateMessage*)message friendAvatarUrl:(NSString*)url
{
    /*
    self.privateMessage = message;
    
    //reset content
    
    YHELoginUser* curUser = [YHELoginUser currentLoginUser];
    //设置头像
    if(YHEPrivateMessageTypeMe == self.privateMessage.privateMessageType) {
        [self.portraitView updateViewWithImageURLString:curUser.personalInfo.avatarUrl userID:curUser.personalInfo.userID nickname:curUser.personalInfo.nickName];
        self.portraitView.delegate = self.userPortraitViewDelegate;
        self.portraitView.masterType = curUser.personalInfo.masterType;
    }else{
        [self.portraitView updateViewWithImageURLString:self.privateMessage.headUrl userID:self.privateMessage.userId nickname:self.privateMessage.nickName];
        self.portraitView.delegate = self.userPortraitViewDelegate;
        self.portraitView.masterType = self.privateMessage.masterType;
    }
    
    //判断内容是否是图片,根据内容属性来设置cell的属性
    if(YHEPrivateMessageImage == self.privateMessage.privateMessageContentType) {
        self.contentImageView.hidden = NO;
        self.bubbleImageView.hidden = YES;
        self.sendStatusImageView.hidden = YES;
        
        
        if(YHEPrivateMessageTypeMe == self.privateMessage.privateMessageType) {
            self.contentImageView.privateMessageType = YHEPrivateMessageTypeMe;
        }else{
            self.contentImageView.privateMessageType = YHEPrivateMessageTypeOther;
        }
            //这里重新设置frame 105 * 105是为了从服务器获取105 x 105格式的图片 by zhangtao
        self.contentImageView.frame = CGRectMake(self.contentImageView.frame.origin.x, self.contentImageView.frame.origin.y, 105, 105);
        if([self.privateMessage.imageContentUrl length])
            [self.contentImageView updateViewWithImageAtURL:self.privateMessage.imageContentUrl];
        else
            self.contentImageView.image = [UIImage imageNamed:@"share_arrived_pic"];
    }else{
        //防止重用出现问题
        self.contentImageView.hidden = YES;
        self.bubbleImageView.hidden = NO;
        
        //设置气泡图片
        if(YHEPrivateMessageTypeMe == self.privateMessage.privateMessageType) {
            UIImage* bubbleImage = [UIImage imageNamed:@"chat_bubble_highlighted"];
            bubbleImage = [bubbleImage resizableImageWithCapInsets:UIEdgeInsetsMake(10, 11, 10, 11)];
            self.bubbleImageView.image = bubbleImage;
            
        }else{
            UIImage* bubbleImage = [UIImage imageNamed:@"chat_bubble_normal"];
            bubbleImage = [bubbleImage resizableImageWithCapInsets:UIEdgeInsetsMake(10, 11, 10, 11)];
            self.bubbleImageView.image = bubbleImage;
        }
        
        //设置文本和颜色
        if(YHEPrivateMessageTypeMe == self.privateMessage.privateMessageType) {
            self.textContentLabel.textColor = [UIColor colorWithHexString:@"ffffff"];
            self.textContentLabel.mentionColor = [UIColor colorWithIntegerRed:0x96 green:0xec blue:0xff];
            self.textContentLabel.tagColor = [UIColor colorWithIntegerRed:0x96 green:0xec blue:0xff];
            self.textContentLabel.urlColor = [UIColor colorWithIntegerRed:0x96 green:0xec blue:0xff];
        }else{
            self.textContentLabel.textColor = [UIColor colorWithHexString:@"6d6e74"];
            self.textContentLabel.mentionColor = [UIColor colorWithIntegerRed:0x00 green:0x99 blue:0xbb];
            self.textContentLabel.tagColor = [UIColor colorWithIntegerRed:0x00 green:0x99 blue:0xbb];
            self.textContentLabel.urlColor = [UIColor colorWithIntegerRed:0x00 green:0x99 blue:0xbb];
        }
        
        self.sendStatusImageView.hidden = YES;
        //根据消息状态设置消息后面图标
        if(YHEMessageSendingFailed == self.privateMessage.messageStatus) {
            self.sendStatusImageView.image = [UIImage imageNamed:@"chat_send_error_icon"];
            self.sendStatusImageView.hidden = NO;
        }else if(YHEMessageSending == self.privateMessage.messageStatus) {
            
        }else{
        }
        
        //设置文本
        self.textContentLabel.delegate = self.attributedLabelDelegate;
        self.textContentLabel.text = self.privateMessage.textContent;
//        NSAttributedString *string = [[NSAttributedString alloc] initWithString:self.privateMessage.textContent attributes:nil];
//        [self.textContentLabel setAttributedText:string];
    }
    self.timeLabel.text = [self dateStringWithDate:self.privateMessage.time];
    
    */
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    /*
    //resize frame
    self.timeLabel.frame = CGRectMake(0, 0, kScreenWidth, 10);
    
    NSString *text = self.privateMessage.textContent;
    CGSize textSize = [YHENewAttrLabel sizeWithText:text font:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(kScreenWidth - 100, CGFLOAT_MAX) LineBreakMode:NSLineBreakByCharWrapping];
    
    //判断内容是否是图片,根据内容属性来设置cell的属性
    if(YHEPrivateMessageImage == self.privateMessage.privateMessageContentType) {
        if(YHEPrivateMessageTypeMe == self.privateMessage.privateMessageType) {
            self.contentImageView.frame = CGRectMake(kScreenWidth - 150, CGRectGetHeight(self.frame) - 110, 105, 100);
            self.portraitView.frame = CGRectMake(kScreenWidth - 40, CGRectGetHeight(self.frame) - 40, 30, 30);
        }else{
            self.contentImageView.frame = CGRectMake(45, CGRectGetHeight(self.frame) - 110, 105, 100);
            self.portraitView.frame = CGRectMake(10, CGRectGetHeight(self.frame) - 40, 30, 30);
        }
        
    }else{
        //气泡位置
        CGFloat bubbleHeight = textSize.height < 20.0f ? 20.0f : textSize.height + kTextContentTopAndBottomMarginOffset*2;
        
        CGFloat bubbleWidth = textSize.width + kTextContentLeftAndRightMarginOffset*2;
        
        CGFloat bubbleOriginY = 20.0f;
        
        //文本位置
        CGFloat textContentHeight = textSize.height;// < 20.0f ? 20.0f : textSize.height;
        
        CGFloat textContentWidth = textSize.width;
        
        CGFloat textContentOriginX = kTextContentLeftAndRightMarginOffset;
        
        CGFloat textContentOriginY = textSize.height < 20.0f ? 0.0f : kTextContentTopAndBottomMarginOffset;
        
        if(YHEPrivateMessageTypeMe == self.privateMessage.privateMessageType) {
            self.bubbleImageView.frame = CGRectMake(kScreenWidth - 48 - bubbleWidth, bubbleOriginY, bubbleWidth, bubbleHeight);
            self.sendStatusImageView.frame = CGRectMake(self.bubbleImageView.frame.origin.x - 28, self.bubbleImageView.frame.origin.y + (self.bubbleImageView.frame.size.height - 20)/2, 20 , 20);
            self.portraitView.frame = CGRectMake(kScreenWidth - 40, CGRectGetHeight(self.frame) - 35, 30, 30);
            
            self.textContentLabel.frame = CGRectMake(textContentOriginX, textContentOriginY, textContentWidth, textContentHeight);
            CGPoint textContentCenter = self.textContentLabel.center;
            textContentCenter.y = CGRectGetMidY(self.bubbleImageView.bounds);
            [self.textContentLabel setCenter:textContentCenter];
        }else{
            self.bubbleImageView.frame = CGRectMake(45, bubbleOriginY, bubbleWidth, bubbleHeight);
            self.sendStatusImageView.frame = CGRectMake(self.bubbleImageView.frame.origin.x + self.bubbleImageView.frame.size.width + 8, self.bubbleImageView.frame.origin.y + (self.bubbleImageView.frame.size.height - 20)/2, 20 , 20);
            
            self.portraitView.frame = CGRectMake(10, CGRectGetHeight(self.frame) - 35, 30, 30);
            
            self.textContentLabel.frame = CGRectMake(textContentOriginX, textContentOriginY, textContentWidth, textContentHeight);
            CGPoint textContentCenter = self.textContentLabel.center;
            textContentCenter.y = CGRectGetMidY(self.bubbleImageView.bounds);
            [self.textContentLabel setCenter:textContentCenter];
        }
        
        if (bubbleHeight > 20) {
            self.portraitView.frame = CGRectOffset(self.portraitView.frame , 0, -8);
        }
    }
     
     */
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)longPressed:(UILongPressGestureRecognizer *)longPress
{
    if (longPress.state == UIGestureRecognizerStateBegan) {
        if (![self isFirstResponder]) {
            [self becomeFirstResponder];
        }
        
        UIMenuController *menuController = [UIMenuController sharedMenuController];
        [menuController setTargetRect:self.bubbleImageView.frame inView:self.contentView];
        [menuController setMenuVisible:YES animated:YES];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self becomeFirstResponder];
    [super touchesBegan:touches withEvent:event];
}

- (void)tapContentImage:(UITapGestureRecognizer*)tapGestureRecognizer
{
    if([self.imageDelegate respondsToSelector:@selector(contentImageTapped:)])
    {
        [self.imageDelegate contentImageTapped:self.privateMessage];
    }
}

//时间格式化
- (NSString *)dateStringWithDate:(NSDate *)date
{
    if (date == nil) {
        return @" ";
    }
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *originComp = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit) fromDate:date];
    NSDateComponents *todayComp = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit) fromDate:[NSDate date]];
    NSDateComponents *yesterdayComp = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit) fromDate:[NSDate dateWithTimeIntervalSinceNow:(kTimeIntervalADay * -1)]];
    NSTimeInterval timePassed = [[NSDate date] timeIntervalSinceDate:date];
    
    NSString *visibleString = @"";
    if (timePassed < kTimeIntervalAHour) {
        if (timePassed < kTimeIntervalAMinute) {
            visibleString = @"1min";
        }
        else {
            visibleString = [NSString stringWithFormat:@"%dmin", (NSInteger)(timePassed / 60)];
        }
    }
    else if (([originComp year] == [todayComp year]) && ([originComp month] == [todayComp month]) && ([originComp day] == [todayComp day])) {
        visibleString = [NSString stringWithFormat:@"%dhour", (NSInteger)(timePassed) / 3600];
    }
    else if (([originComp year] == [yesterdayComp year]) && ([originComp month] == [yesterdayComp month]) && ([originComp day] == [yesterdayComp day])) {
        visibleString = @"yesterday";
    }
    else if ([originComp year] == [todayComp year]) {
        visibleString = [NSString stringWithFormat:@"%04d.%d.%d", [originComp year], [originComp month], [originComp day]];
    }
    else {
        visibleString = [NSString stringWithFormat:@"%04d.%d.%d", [originComp year], [originComp month], [originComp day]];
    }
    return visibleString;
}

@end
