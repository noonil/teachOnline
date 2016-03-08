//
//  UMPostTableViewCell.m
//  Feedback
//
//  Created by amoblin on 14/9/10.
//  Copyright (c) 2014年 umeng. All rights reserved.
//

#import "HSFeedbackMessageCell.h"
#import "UMFeedback.h"
#import "UMOpenMacros.h"
#import "HSLoginMgr.h"
#import "UIImageView+WebCache.h"

#define kTimeIntervalAMinute        (NSTimeInterval)(60)
#define kTimeIntervalAHour          (NSTimeInterval)(3600)
#define kTimeIntervalADay           (NSTimeInterval)(3600 * 24)

#define kTextContentLeftAndRightMarginOffset      10.0f
#define kTextContentTopAndBottomMarginOffset      3.0f

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
        UIImage* maskImage = [self maskWithImage:bubbleImage sourceImage:image];
        [super setImage:maskImage];
    }
}

- (UIImage *) maskWithImage:(const UIImage *) maskImage sourceImage:(UIImage *)srcImage
{
    if(!maskImage)
    {
        NSLog(@"Error:maskWithImage is nil");
        return nil;
    }
    CGImageRef imageRef = maskImage.CGImage;
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imageRef), CGImageGetHeight(imageRef));
    CGRect imageRect = (CGRect){.origin = CGPointZero, .size = imageSize};
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(imageRef);
    
    int infoMask = (bitmapInfo & kCGBitmapAlphaInfoMask);
    BOOL anyNonAlpha = (infoMask == kCGImageAlphaNone ||
                        infoMask == kCGImageAlphaNoneSkipFirst ||
                        infoMask == kCGImageAlphaNoneSkipLast);
    
    // CGBitmapContextCreate doesn't support kCGImageAlphaNone with RGB.
    // https://developer.apple.com/library/mac/#qa/qa1037/_index.html
    if (infoMask == kCGImageAlphaNone && CGColorSpaceGetNumberOfComponents(colorSpace) > 1) {
        // Unset the old alpha info.
        bitmapInfo &= ~kCGBitmapAlphaInfoMask;
        
        // Set noneSkipFirst.
        bitmapInfo |= kCGImageAlphaNoneSkipFirst;
    }
    // Some PNGs tell us they have alpha but only 3 components. Odd.
    else if (!anyNonAlpha && CGColorSpaceGetNumberOfComponents(colorSpace) == 3) {
        // Unset the old alpha info.
        bitmapInfo &= ~kCGBitmapAlphaInfoMask;
        bitmapInfo |= kCGImageAlphaPremultipliedFirst;
    }
    
    // It calculates the bytes-per-row based on the bitsPerComponent and width arguments.
    CGContextRef mainViewContentContext = CGBitmapContextCreate(NULL,
                                                                imageSize.width,
                                                                imageSize.height,
                                                                CGImageGetBitsPerComponent(imageRef),
                                                                0,
                                                                colorSpace,
                                                                bitmapInfo);
    
    CGColorSpaceRelease(colorSpace);
    
    CGContextClipToMask(mainViewContentContext, imageRect, imageRef);
    CGContextDrawImage(mainViewContentContext, imageRect, srcImage.CGImage);
    
    CGImageRef newImage = CGBitmapContextCreateImage(mainViewContentContext);
    CGContextRelease(mainViewContentContext);
    
    UIImage *theImage = [UIImage imageWithCGImage:newImage];
    
    CGImageRelease(newImage);
    
    return theImage;
    
}

@end

@interface HSFeedbackMessageCell ()

@property (nonatomic,assign) YHEPrivateMessageType     messageType;
@property (nonatomic,assign) YHEPrivateMessageContentType contentType;
@property (nonatomic,strong) UIImageView *portraitView;
@property (nonatomic,readwrite,strong) YHMessageMaskImageView     *contentImageView;
@property (nonatomic,strong) UIImageView                *bubbleImageView;
@property (nonatomic,strong) UIImageView                *picBubbleImageView;
@property (nonatomic,strong) UIImageView                *sendStatusImageView;
@property (nonatomic,strong) UILabel                    *textContentLabel;
@property (nonatomic,strong) UILabel                    *timeLabel;

@property (strong, nonatomic) UITapGestureRecognizer *imageTapGesture;

@end

@implementation HSFeedbackMessageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self initView];
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
    [self initView];
}

- (void)initView
{
    self.backgroundColor = [UIColor whiteColor];
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    self.portraitView = [[UIImageView alloc] init];
    [self.contentView addSubview:self.portraitView];
    
    self.contentImageView = [[YHMessageMaskImageView alloc] initWithFrame:CGRectMake(0, 0, 105, 100)];
    self.contentImageView.backgroundColor = [UIColor clearColor];
    self.contentImageView.clipsToBounds = YES;
    [self.contentImageView.layer setMasksToBounds:YES];
    [self.contentImageView.layer setCornerRadius:5.0f];
    self.contentImageView.userInteractionEnabled = YES;
    
    self.imageTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapContentImage:)];
    [self.imageTapGesture setNumberOfTapsRequired:1];
    [self.imageTapGesture setNumberOfTouchesRequired:1];
    [self.contentImageView addGestureRecognizer:self.imageTapGesture];    
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
    [self.textContentLabel setText:@"klsfda;kw;qr;wqr;ew;ql"];
    [self.bubbleImageView addSubview:self.textContentLabel];
    
    self.timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    self.timeLabel.font = [UIFont systemFontOfSize:10.0f];
    self.timeLabel.textColor = [UIColor grayColor];
    self.timeLabel.textAlignment = NSTextAlignmentCenter;
    self.timeLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.timeLabel];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    //resize frame
    self.timeLabel.frame = CGRectMake(0, 0, kScreenWidth, 10);
    
    NSString *text = self.textContentLabel.text;
    
    CGRect textRect = [text boundingRectWithSize:CGSizeMake(kScreenWidth - 100, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:NULL];
    CGSize textSize = textRect.size;
    //判断内容是否是图片,根据内容属性来设置cell的属性
    if(YHEPrivateMessageImage == self.contentType) {
        if(YHEPrivateMessageTypeMe == self.messageType) {
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
        
        if(YHEPrivateMessageTypeMe == self.messageType) {
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
    
}

- (void)configCell:(NSDictionary *)info {
    
    self.info = info;
    
    self.messageType = [info[@"type"] isEqualToString:@"user_reply"]?YHEPrivateMessageTypeMe:YHEPrivateMessageTypeOther;
    NSString *picId = info[@"pic_id"];
    self.contentType = (picId.length > 0)?YHEPrivateMessageImage:YHEPrivateMessageText;
    
    self.contentImageView.privateMessageType = self.messageType;
    [self.contentImageView setHidden:(self.contentType != YHEPrivateMessageImage)];
    
    
    [self.portraitView sd_setImageWithURL:[NSURL URLWithString:[HSLoginMgr loginMgr].loginUser.image]];
    
    if (self.messageType == YHEPrivateMessageTypeMe) {
        // ME
        self.contentImageView.backgroundColor = UM_UIColorFromHex(0xDBDBDB);
    } else {
        // DEV
        self.contentImageView.backgroundColor = UM_UIColorFromHex(0x0FB0AA);
    }
    
    if (self.contentType == YHEPrivateMessageImage)  {
        UIImage *thumbImage = [[UMFeedback sharedInstance] thumbImageByID:info[@"pic_id"]];
        
        //这里重新设置frame 105 * 105是为了从服务器获取105 x 105格式的图片 by zhangtao
        self.contentImageView.frame = CGRectMake(self.contentImageView.frame.origin.x, self.contentImageView.frame.origin.y, 105, 105);
        [self.contentImageView setImage:thumbImage];
    } else {
        self.textContentLabel.text = info[@"content"];
    }
    
    
    //设置气泡图片
    if(YHEPrivateMessageTypeMe == self.messageType) {
        UIImage* bubbleImage = [UIImage imageNamed:@"chat_bubble_highlighted"];
        bubbleImage = [bubbleImage resizableImageWithCapInsets:UIEdgeInsetsMake(10, 11, 10, 11)];
        self.bubbleImageView.image = bubbleImage;
        
    }else{
        UIImage* bubbleImage = [UIImage imageNamed:@"chat_bubble_normal"];
        bubbleImage = [bubbleImage resizableImageWithCapInsets:UIEdgeInsetsMake(10, 11, 10, 11)];
        self.bubbleImageView.image = bubbleImage;
    }
    
    if ([info[@"is_failed"] boolValue]) {
        self.textLabel.textColor = UM_UIColorFromHex(0xff0000);
        self.detailTextLabel.textColor = UM_UIColorFromHex(0xff0000);
    } else {
        self.textLabel.textColor = UM_UIColorFromHex(0x000000);
        self.detailTextLabel.textColor = UM_UIColorFromHex(0x000000);
    }
    
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[info[@"created_at"] doubleValue] / 1000];
    self.timeLabel.text = [self dateStringWithDate:date];
}

- (void)tapContentImage:(UITapGestureRecognizer*)tapGestureRecognizer
{
    if([self.imageDelegate respondsToSelector:@selector(cell:contentImageTapped:)])
    {
        [self.imageDelegate cell:self contentImageTapped:self.info];
    }
}


+ (CGFloat)heightWithInfo:(NSDictionary *)info
{
    NSString *picId = info[@"pic_id"];
    YHEPrivateMessageContentType contentType = (picId.length > 0)?YHEPrivateMessageImage:YHEPrivateMessageText;
    
    //如果内容是图片
    if(contentType == YHEPrivateMessageImage)
    {
        //时间自身高度 + 图片顶部间隔高度 + 图片高度 + 图片底部高度
        return 10 + 10 + 100 + 10;
    }
    NSString* text = info[@"content"];
    //    CGSize textSize = [text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(kScreenWidth - 100, CGFLOAT_MAX) lineBreakMode:NSLineBreakByCharWrapping];
    CGRect textRect = [text boundingRectWithSize:CGSizeMake(kScreenWidth - 100, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:NULL];
    CGSize textSize = textRect.size;
    CGFloat bubbleHeight = textSize.height < 20.0f ? 20.0f : textSize.height + kTextContentTopAndBottomMarginOffset*2;
    //时间自身高度 + 气泡顶部间隔 + 气泡高度 +气泡距离底部高度
    return 10 + 10 + bubbleHeight + 10;
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
            visibleString = @"1分钟";
        }
        else {
            visibleString = [NSString stringWithFormat:@"%ld分钟", (long)(timePassed / 60)];
        }
    }
    else if (([originComp year] == [todayComp year]) && ([originComp month] == [todayComp month]) && ([originComp day] == [todayComp day])) {
        visibleString = [NSString stringWithFormat:@"%ld小时", (NSInteger)(timePassed) / 3600];
    }
    else if (([originComp year] == [yesterdayComp year]) && ([originComp month] == [yesterdayComp month]) && ([originComp day] == [yesterdayComp day])) {
        visibleString = @"昨天";
    }
    else if ([originComp year] == [todayComp year]) {
        visibleString = [NSString stringWithFormat:@"%04ld.%ld.%ld", (long)[originComp year], (long)[originComp month], (long)[originComp day]];
    }
    else {
        visibleString = [NSString stringWithFormat:@"%04ld.%ld.%ld", (long)[originComp year], (long)[originComp month], (long)[originComp day]];
    }
    return visibleString;
}



@end
